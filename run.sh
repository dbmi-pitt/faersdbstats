#!/bin/sh

# Script is used as part of an EMC internal data processing pipeline, but 'should work' by itself
# Process expects:
#   1. vocabulary to be preloaded in schema staging_vocabulary
#   2. required postgres variables to be set
#   3. Java and Maven

export PGPASSWORD=${POSTGRES_PASSWORD}
psql -h "${POSTGRES_HOST}" -U "${POSTGRES_USER}" -c "\CREATE SCHEMA IF NOT EXISTS faers" "${POSTGRES_DATABASE}"

echo "Loading reference data"
cd reference_and_mapping_data || exit 1
psql -h "${POSTGRES_HOST}" -U "${POSTGRES_USER}" -f load_country_code_table.sql "${POSTGRES_DATABASE}"
psql -h "${POSTGRES_HOST}" -U "${POSTGRES_USER}" -f create_meddra_snomed_mapping_table.sql "${POSTGRES_DATABASE}"
cd ../
echo "Done loading reference data"


echo "Loading raw data"
cd load_data_files_from_website || exit 1
./download_all_and_create_files.sh
for SQLFILE in ./load*.sql; do
  echo "executing ${SQLFILE}"
  psql -h "${POSTGRES_HOST}" -U "${POSTGRES_USER}" -f "${SQLFILE}" "${POSTGRES_DATABASE}"
done
psql -h "${POSTGRES_HOST}" -U "${POSTGRES_USER}" -f delete_deleted_records.sql "${POSTGRES_DATABASE}"
cd ../
echo "Done loading raw data"

psql -h "${POSTGRES_HOST}" -U "${POSTGRES_USER}" -f handle_duplicate_cases/derive_unique_all_case.sql "${POSTGRES_DATABASE}"

echo "Downloading Aioli app"
curl -L -O https://github.com/RowanErasmus/aioli/archive/refs/heads/master.zip
unzip master.zip

echo "Creating config file for aioli app"
SETTINGS_FILE_NAME="config.properties"
cat >${SETTINGS_FILE_NAME} <<EOF
port=${POSTGRES_PORT}
host=${POSTGRES_HOST}
user=${POSTGRES_USER}
password=${POSTGRES_PASSWORD}
name=${POSTGRES_DATABASE}
EOF

rm aioli-master/src/main/resources/${SETTINGS_FILE_NAME}
mv ${SETTINGS_FILE_NAME} aioli-master/src/main/resources/${SETTINGS_FILE_NAME}

cd aioli-master || exit 1
mvn clean package assembly:single
java -jar target/ailoi_java-1.0-SNAPSHOT-jar-with-dependencies.jar -tv rxnorm -rmin false || exit 1

./standardized_output/standardize.sh

echo "That's it aeolus is done!!!!"