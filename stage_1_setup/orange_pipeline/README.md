# Orange Book Python Pipeline

This pipeline mirrors `stage_1_setup/orange_book_job.kjb` + `orange_book_transform.ktr`:

1. Download Orange Book zip from `CEM_ORANGE_BOOK_DOWNLOAD_URL`
2. Save zip in `OMOP_FILE_DIR` using `OMOP_FILE_NAME`
3. Unzip to local staging
4. Upload staged files to `s3://${AWS_S3_BUCKET_NAME}/${CEM_DOWNLOAD_DATA_FOLDER}_setup`
5. Download files back from S3
6. Truncate and load `${DATABASE_SCHEMA}.nda` from `products.txt`

## Platform assumptions

- Development may happen on Windows
- Primary runtime target is Linux Ubuntu servers
- No Windows-specific runtime behavior is required

## Prerequisites (Ubuntu runtime)

### System packages

- Python 3.10+ (3.12 recommended)
- `pip`
- `unzip` available on PATH
- Optional: AWS CLI v2 (required only if using `--s3-mode cli`)

### Python packages

Install:

```bash
pip install -r stage_1_setup/orange_pipeline/requirements.txt
```

This installs:

- `psycopg[binary]` for PostgreSQL load into `nda`
- `boto3` for S3 transfers in `--s3-mode boto3` (or `auto` fallback)

### Database requirements

- PostgreSQL reachable from runtime host
- Table `${DATABASE_SCHEMA}.nda` exists (see `stage_1_setup/create_nda_table.sql`)
- Runtime DB user can `TRUNCATE` and `INSERT` on `${DATABASE_SCHEMA}.nda`

### Config requirements

By default, the script reads `faersdbstats/faers_config.config`.

Required config keys:

- `BASE_FILE_DIR`
- `OMOP_FILE_DIR`
- `OMOP_FILE_NAME`
- `CEM_ORANGE_BOOK_DOWNLOAD_URL`
- `CEM_DOWNLOAD_DATA_FOLDER`
- `AWS_S3_BUCKET_NAME`
- `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (or `AWS_S3_ACCESS_KEY` and `AWS_S3_SECRET_KEY`)
- `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_NAME`, `DATABASE_SCHEMA`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`

## Run

Single entrypoint:

```bash
python stage_1_setup/orange_pipeline/main.py run
```

Subcommands:

```bash
python stage_1_setup/orange_pipeline/main.py download
python stage_1_setup/orange_pipeline/main.py upload --s3-mode auto
python stage_1_setup/orange_pipeline/main.py redownload --s3-mode auto
python stage_1_setup/orange_pipeline/main.py load
```

S3 mode:

- `auto`: try AWS CLI then fall back to `boto3`
- `cli`: force AWS CLI
- `boto3`: force Python SDK

## Operational notes

- AWS credentials are loaded from config and injected at runtime.
- Loader maps first 14 `~`-delimited columns in `products.txt` to `${DATABASE_SCHEMA}.nda`, matching Pentaho mapping.
- Load mode is `TRUNCATE + full reload` each run.