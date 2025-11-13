#!/bin/bash
set -euo pipefail

# Config sourcing is optional; variables are expected to be set by the Pentaho job step
# via "Set job variables". If the repo-local config exists relative to this script,
# source it as a fallback to aid local runs.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../../faers_config.config"
if [[ -f "${CONFIG_FILE}" ]]; then
    # shellcheck disable=SC1090
    source "${CONFIG_FILE}"
fi

echo "FAERSDBSTATS_REPO_LOCATION is " ${FAERSDBSTATS_REPO_LOCATION:-"(unset)"}

export "AWS_ACCESS_KEY_ID=${AWS_S3_ACCESS_KEY}"
#echo "AWS_S3_ACCESS_KEY = ${AWS_S3_ACCESS_KEY}"

export "AWS_SECRET_ACCESS_KEY=${AWS_S3_SECRET_KEY}"
#echo "AWS_S3_BUCKET_NAME=${AWS_S3_BUCKET_NAME}"

export "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"
#echo "AWS_S3_SECRET_KEY=${AWS_S3_SECRET_KEY}"

cd "${BASE_FILE_DIR}"

aws configure list


# echo "Pwd is "
# pwd

echo CEM_ORANGE_BOOK_DOWNLOAD_URL is "${CEM_ORANGE_BOOK_DOWNLOAD_URL}"

mkdir -p "${CEM_DOWNLOAD_DATA_FOLDER}_setup"
cd "${CEM_DOWNLOAD_DATA_FOLDER}_setup"

echo pwd is
pwd

# Check if a previous download already exists in the working folder
detected_file="$(ls -t EOBZIP_*.zip 2>/dev/null | head -n1 || true)"
if [[ -z "${detected_file}" ]]; then
    # No prior zip found; download a fresh copy
    if curl -fL -OJ "${CEM_ORANGE_BOOK_DOWNLOAD_URL}"; then
        echo "SUCCESS!"
        detected_file="$(ls -t EOBZIP_*.zip 2>/dev/null | head -n1 || true)"
    else
        echo "Download failed. Check CEM_ORANGE_BOOK_DOWNLOAD_URL and network connectivity." | tee -a error.txt
        exit 1
    fi
else
    echo "Found existing Orange Book zip: ${detected_file}; skipping download."
fi
configured_file="${CEM_ORANGE_BOOK_DOWNLOAD_FILENAME:-}"

if [[ -n "${configured_file}" && -f "${configured_file}" ]]; then
    filename="${configured_file}"
elif [[ -n "${detected_file}" ]]; then
    filename="${detected_file}"
else
    echo "Could not determine downloaded filename EOBZIP_*.zip" | tee -a error.txt
    exit 1
fi

echo "downloaded filename is ${filename}"

# Verify it's a zip
zipinfo "${filename}" >/dev/null

echo "BASE_FILE_DIR is ${BASE_FILE_DIR}"
data_setup_path="${BASE_FILE_DIR}/${CEM_DOWNLOAD_DATA_FOLDER}_setup"
cd "${data_setup_path}"
echo "data_setup_path is ${data_setup_path}"
echo "changed directories to: $(pwd)"

rm -rf orange-book-data-files
mkdir -p "orange-book-data-files"

echo "BASE_FILE_DIR is"
echo "${BASE_FILE_DIR}"

unzip -q "${data_setup_path}/${filename}" -d "orange-book-data-files"

echo "in ${data_setup_path}/orange-book-data-files line counts are as follows"
wc -l orange-book-data-files/exclusivity.txt || true
wc -l orange-book-data-files/patent.txt || true # do we use this?
wc -l orange-book-data-files/products.txt || true

#echo the location of the log file is 
#pwd 

# {
    #exec 1>> output.txt
    #exec 2>> error.txt
# }
#or
#exec >logfile.txt 2>&1

#echo "End " ${Internal.Job.Name} " log " >> error.txt >> output.txt
