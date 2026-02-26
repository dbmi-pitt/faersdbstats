from __future__ import annotations

import argparse
import csv
import io
import os
import re
import subprocess
import sys
import urllib.request
import zipfile
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


VAR_PATTERN = re.compile(r"\$\{([A-Za-z0-9_]+)\}")
NDA_COLUMNS = [
    "ingredient",
    "dfroute",
    "trade_name",
    "applicant",
    "strength",
    "appl_type",
    "appl_no",
    "product_no",
    "te_code",
    "approval_date",
    "rld",
    "rs",
    "type",
    "applicant_full_name",
]


@dataclass
class Settings:
    base_file_dir: Path
    omop_file_dir: Path
    omop_file_name: str
    orange_book_url: str
    orange_book_download_filename: str
    download_data_folder: str
    aws_bucket_name: str
    aws_access_key_id: str
    aws_secret_access_key: str
    aws_default_region: str
    database_host: str
    database_port: int
    database_name: str
    database_schema: str
    database_username: str
    database_password: str

    @property
    def s3_prefix(self) -> str:
        return f"{self.download_data_folder}_setup"

    @property
    def extracted_dir(self) -> Path:
        return self.omop_file_dir / "orange-book-data-files"

    @property
    def roundtrip_dir(self) -> Path:
        return self.omop_file_dir / self.s3_prefix

    @property
    def products_roundtrip_path(self) -> Path:
        return self.roundtrip_dir / "products.txt"

    def aws_env(self) -> dict[str, str]:
        env = dict(os.environ)
        env["AWS_ACCESS_KEY_ID"] = self.aws_access_key_id
        env["AWS_SECRET_ACCESS_KEY"] = self.aws_secret_access_key
        env["AWS_DEFAULT_REGION"] = self.aws_default_region
        return env


def parse_key_value_file(config_path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    for raw_line in config_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip()
    return values


def resolve_variables(values: dict[str, str]) -> dict[str, str]:
    resolved = dict(values)

    def _expand(text: str) -> str:
        for _ in range(20):
            changed = False

            def replace_match(match: re.Match[str]) -> str:
                nonlocal changed
                name = match.group(1)
                replacement = resolved.get(name, os.environ.get(name, match.group(0)))
                if replacement != match.group(0):
                    changed = True
                return replacement

            updated = VAR_PATTERN.sub(replace_match, text)
            text = updated
            if not changed:
                break
        return text

    for key in list(resolved.keys()):
        resolved[key] = _expand(resolved[key])
    return resolved


def default_config_path() -> Path:
    return Path(__file__).resolve().parents[2] / "faers_config.config"


def load_settings(config_path: Path) -> Settings:
    if not config_path.exists():
        raise FileNotFoundError(f"Config file not found: {config_path}")

    raw = parse_key_value_file(config_path)
    values = resolve_variables(raw)

    base_file_dir = Path(values["BASE_FILE_DIR"]).expanduser()
    omop_file_dir = Path(values["OMOP_FILE_DIR"]).expanduser()
    if not omop_file_dir.is_absolute():
        omop_file_dir = (base_file_dir / omop_file_dir).resolve()

    aws_access_key_id = values.get("AWS_ACCESS_KEY_ID") or values.get("AWS_S3_ACCESS_KEY", "")
    aws_secret_access_key = values.get("AWS_SECRET_ACCESS_KEY") or values.get("AWS_S3_SECRET_KEY", "")

    return Settings(
        base_file_dir=base_file_dir,
        omop_file_dir=omop_file_dir,
        omop_file_name=values.get("OMOP_FILE_NAME", "omop-vocabulary.zip"),
        orange_book_url=values["CEM_ORANGE_BOOK_DOWNLOAD_URL"],
        orange_book_download_filename=values.get("CEM_ORANGE_BOOK_DOWNLOAD_FILENAME", ""),
        download_data_folder=values.get("CEM_DOWNLOAD_DATA_FOLDER", "data"),
        aws_bucket_name=values["AWS_S3_BUCKET_NAME"],
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        aws_default_region=values["AWS_DEFAULT_REGION"],
        database_host=values["DATABASE_HOST"],
        database_port=int(values.get("DATABASE_PORT", "5432")),
        database_name=values["DATABASE_NAME"],
        database_schema=values["DATABASE_SCHEMA"],
        database_username=values["DATABASE_USERNAME"],
        database_password=values["DATABASE_PASSWORD"],
    )


def log(message: str) -> None:
    print(f"[orange-pipeline] {message}")


def choose_download_filename(settings: Settings) -> str:
    if settings.omop_file_name:
        return settings.omop_file_name
    if settings.orange_book_download_filename:
        return settings.orange_book_download_filename
    return "orange-book.zip"


def download_orange_book(settings: Settings) -> Path:
    settings.omop_file_dir.mkdir(parents=True, exist_ok=True)

    destination = settings.omop_file_dir / choose_download_filename(settings)
    log(f"Downloading Orange Book zip from {settings.orange_book_url}")
    with urllib.request.urlopen(settings.orange_book_url) as response:
        data = response.read()
    destination.write_bytes(data)
    log(f"Saved zip to {destination}")
    return destination


def unzip_orange_book(zip_path: Path, settings: Settings) -> Path:
    settings.extracted_dir.mkdir(parents=True, exist_ok=True)
    log(f"Extracting {zip_path.name} to {settings.extracted_dir}")
    with zipfile.ZipFile(zip_path, "r") as archive:
        archive.extractall(settings.extracted_dir)
    return settings.extracted_dir


def require_products_file(search_dir: Path) -> Path:
    if not search_dir.exists():
        raise FileNotFoundError(f"Directory not found: {search_dir}")
    for path in search_dir.rglob("*"):
        if path.is_file() and path.name.lower() == "products.txt":
            return path
    raise FileNotFoundError(f"Could not locate products.txt under {search_dir}")


def run_aws_cli(args: list[str], settings: Settings) -> None:
    command = ["aws", *args]
    log("Running: " + " ".join(command))
    subprocess.run(command, check=True, env=settings.aws_env())


def upload_directory_cli(settings: Settings) -> None:
    source = settings.extracted_dir
    if not source.exists():
        raise FileNotFoundError(f"Directory not found for upload: {source}")
    target = f"s3://{settings.aws_bucket_name}/{settings.s3_prefix}"
    run_aws_cli(["s3", "cp", str(source), target, "--recursive"], settings)


def download_directory_cli(settings: Settings) -> None:
    settings.roundtrip_dir.mkdir(parents=True, exist_ok=True)
    source = f"s3://{settings.aws_bucket_name}/{settings.s3_prefix}"
    run_aws_cli(["s3", "cp", source, str(settings.roundtrip_dir), "--recursive"], settings)


def iter_files_recursive(root: Path) -> Iterable[Path]:
    for path in root.rglob("*"):
        if path.is_file():
            yield path


def upload_directory_boto3(settings: Settings) -> None:
    try:
        import boto3  # type: ignore
    except ImportError as exc:
        raise ImportError("boto3 is required for --s3-mode boto3") from exc

    source = settings.extracted_dir
    if not source.exists():
        raise FileNotFoundError(f"Directory not found for upload: {source}")

    client = boto3.client(
        "s3",
        aws_access_key_id=settings.aws_access_key_id,
        aws_secret_access_key=settings.aws_secret_access_key,
        region_name=settings.aws_default_region,
    )

    for path in iter_files_recursive(source):
        relative = path.relative_to(source).as_posix()
        key = f"{settings.s3_prefix}/{relative}"
        log(f"Uploading {path.name} -> s3://{settings.aws_bucket_name}/{key}")
        client.upload_file(str(path), settings.aws_bucket_name, key)


def download_directory_boto3(settings: Settings) -> None:
    try:
        import boto3  # type: ignore
    except ImportError as exc:
        raise ImportError("boto3 is required for --s3-mode boto3") from exc

    settings.roundtrip_dir.mkdir(parents=True, exist_ok=True)
    client = boto3.client(
        "s3",
        aws_access_key_id=settings.aws_access_key_id,
        aws_secret_access_key=settings.aws_secret_access_key,
        region_name=settings.aws_default_region,
    )

    paginator = client.get_paginator("list_objects_v2")
    prefix = f"{settings.s3_prefix}/"
    for page in paginator.paginate(Bucket=settings.aws_bucket_name, Prefix=prefix):
        for item in page.get("Contents", []):
            key = item["Key"]
            relative = key[len(prefix) :]
            if not relative:
                continue
            destination = settings.roundtrip_dir / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            log(f"Downloading s3://{settings.aws_bucket_name}/{key}")
            client.download_file(settings.aws_bucket_name, key, str(destination))


def upload_to_s3(settings: Settings, s3_mode: str) -> None:
    if s3_mode == "cli":
        upload_directory_cli(settings)
        return
    if s3_mode == "boto3":
        upload_directory_boto3(settings)
        return

    try:
        upload_directory_cli(settings)
    except Exception:
        log("AWS CLI upload failed, falling back to boto3")
        upload_directory_boto3(settings)


def redownload_from_s3(settings: Settings, s3_mode: str) -> Path:
    if s3_mode == "cli":
        download_directory_cli(settings)
    elif s3_mode == "boto3":
        download_directory_boto3(settings)
    else:
        try:
            download_directory_cli(settings)
        except Exception:
            log("AWS CLI download failed, falling back to boto3")
            download_directory_boto3(settings)

    products = require_products_file(settings.roundtrip_dir)
    if products != settings.products_roundtrip_path:
        settings.products_roundtrip_path.parent.mkdir(parents=True, exist_ok=True)
        settings.products_roundtrip_path.write_bytes(products.read_bytes())
        products = settings.products_roundtrip_path
    return products


def parse_products_rows(products_path: Path) -> list[tuple[str, ...]]:
    log(f"Reading Orange Book rows from {products_path}")
    with products_path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.reader(handle, delimiter="~")
        header = next(reader, None)
        if header is None:
            return []

        rows: list[tuple[str, ...]] = []
        for row in reader:
            if not row:
                continue
            normalized = [value.strip() for value in row]
            if len(normalized) < len(NDA_COLUMNS):
                normalized.extend([""] * (len(NDA_COLUMNS) - len(normalized)))
            rows.append(tuple(normalized[: len(NDA_COLUMNS)]))
    return rows


def load_nda_table(settings: Settings, products_path: Path) -> None:
    rows = parse_products_rows(products_path)
    log(f"Prepared {len(rows)} rows for load into {settings.database_schema}.nda")

    try:
        import psycopg  # type: ignore
    except ImportError as exc:
        raise ImportError("psycopg is required to load nda table") from exc

    dsn = (
        f"host={settings.database_host} "
        f"port={settings.database_port} "
        f"dbname={settings.database_name} "
        f"user={settings.database_username} "
        f"password={settings.database_password}"
    )
    insert_sql = (
        f"INSERT INTO {settings.database_schema}.nda "
        f"({', '.join(NDA_COLUMNS)}) VALUES ({', '.join(['%s'] * len(NDA_COLUMNS))})"
    )

    with psycopg.connect(dsn) as conn:
        with conn.cursor() as cur:
            cur.execute(f"TRUNCATE TABLE {settings.database_schema}.nda")
            if rows:
                cur.executemany(insert_sql, rows)
        conn.commit()

    log(f"Loaded {len(rows)} rows into {settings.database_schema}.nda")


def run_pipeline(settings: Settings, s3_mode: str) -> None:
    zip_path = download_orange_book(settings)
    unzip_orange_book(zip_path, settings)
    require_products_file(settings.extracted_dir)
    upload_to_s3(settings, s3_mode=s3_mode)
    products_path = redownload_from_s3(settings, s3_mode=s3_mode)
    load_nda_table(settings, products_path)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Orange Book data pipeline: download -> S3 upload -> S3 re-download -> load schema.nda"
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=default_config_path(),
        help="Path to faers_config.config",
    )
    parser.add_argument(
        "--s3-mode",
        choices=["auto", "cli", "boto3"],
        default="auto",
        help="S3 transfer mode",
    )

    subparsers = parser.add_subparsers(dest="command")
    subparsers.add_parser("run", help="Run full pipeline")
    subparsers.add_parser("download", help="Download and unzip Orange Book zip")
    subparsers.add_parser("upload", help="Upload extracted Orange Book files to S3")
    subparsers.add_parser("redownload", help="Download files from S3 to local roundtrip path")

    load_parser = subparsers.add_parser("load", help="Load products.txt into ${DATABASE_SCHEMA}.nda")
    load_parser.add_argument(
        "--products-path",
        type=Path,
        default=None,
        help="Optional path to products.txt; defaults to OMOP_FILE_DIR/<CEM_DOWNLOAD_DATA_FOLDER>_setup/products.txt",
    )
    return parser


def run_from_args(args: argparse.Namespace) -> None:
    settings = load_settings(args.config)
    command = args.command or "run"

    if command == "run":
        run_pipeline(settings, s3_mode=args.s3_mode)
        return

    if command == "download":
        zip_path = download_orange_book(settings)
        unzip_orange_book(zip_path, settings)
        found = require_products_file(settings.extracted_dir)
        log(f"products.txt located at {found}")
        return

    if command == "upload":
        require_products_file(settings.extracted_dir)
        upload_to_s3(settings, s3_mode=args.s3_mode)
        return

    if command == "redownload":
        products_path = redownload_from_s3(settings, s3_mode=args.s3_mode)
        log(f"products.txt downloaded to {products_path}")
        return

    if command == "load":
        products_path = args.products_path
        if products_path is None:
            products_path = settings.products_roundtrip_path
        if not products_path.exists():
            products_path = require_products_file(products_path.parent)
        load_nda_table(settings, products_path)
        return

    raise ValueError(f"Unsupported command: {command}")


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        run_from_args(args)
    except Exception as exc:
        log(f"Pipeline failed: {exc}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())