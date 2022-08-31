#!/bin/bash
log_location=${BASE_FILE_DIR}/logs/create_schemas_sh.txt
source ${BASE_FILE_DIR}/faers_config.config
echo ${DATABASE_PASSWORD}
PGPASSWORD=$(echo ${DATABASE_PASSWORD}) psql -U ${DATABASE_USERNAME} -d ${DATABASE_NAME} -w --no-password -h ${DATABASE_HOST} -c "CREATE SCHEMA IF NOT EXISTS $(echo ${DATABASE_SCHEMA});" -o $log_location

# echo "CREATE_SCHEMAS TALKING" >> $log_location