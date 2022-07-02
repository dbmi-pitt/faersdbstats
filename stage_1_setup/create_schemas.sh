#!/bin/bash
source ${BASE_FILE_DIR}/faers.config
echo ${DATABASE_PASSWORD}
PGPASSWORD=$(echo ${DATABASE_PASSWORD}) psql -U rw_grp -d cem_pitt_2022 -w --no-password -h localhost -c "CREATE SCHEMA IF NOT EXISTS $(echo ${DATABASE_SCHEMA});"
