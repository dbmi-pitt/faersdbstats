run_date=$(date "+%m%d%Y")
DB_BACKUP_FILENAME="${LOG_FILENAME_ROOT}_stg_1_auto_bk_fcd_${run_date}.dump"
DB_BACKUP_FILENAME_FCD="${LOG_FILENAME_ROOT}_stg_1_auto_bk_fcd_${run_date}.dump"
DB_BACKUP_FILENAME_PATH=${DATABASE_BACKUP_LOCATION}${DB_BACKUP_FILENAME}
DB_BACKUP_FILENAME_PATH_FCD=${DATABASE_BACKUP_LOCATION}${DB_BACKUP_FILENAME_FCD}
#echo $run_date

echo '${DB_BACKUP_FILENAME} is ' ${DB_BACKUP_FILENAME}
echo ${DB_BACKUP_FILENAME_PATH}

# creates larger database back-up file
PGPASSWORD="${DATABASE_PASSWORD}" pg_dump -h ${DATABASE_HOST} -p ${DATABASE_PORT} -U ${DATABASE_USERNAME} ${DATABASE_NAME} > ${DB_BACKUP_FILENAME_PATH}


#note -Fc = Format custom Output a custom-format archive suitable for input into
              # pg_restore. Together with the directory output format, this is
              # the most flexible output format in that it allows manual
              # selection and reordering of archived items during restore. This
              # format is also compressed by default.

# creates smaller database back-up file
PGPASSWORD="${DATABASE_PASSWORD}" pg_dump -Fc -h ${DATABASE_HOST} -p ${DATABASE_PORT} -U ${DATABASE_USERNAME} ${DATABASE_NAME} > ${DB_BACKUP_FILENAME_PATH_FCD}
