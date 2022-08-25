#!/bin/bash

source ../faers_config.config
log_location=test_log.txt

log_location=${BASE_FILE_DIR}/logs/${LOG_FILENAME}
printf '\n' > $log_location
printf '\n' >> $log_location
echo "BEGINNING OF STAGE 4_LOGGING JOB(S)" >> $log_location
printf '\n' >> $log_location
echo 'DEMO COUNT RESULTS' >> $log_location
echo ${DEMO_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DEMO_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DEMO_ROW_COUNT} -lt ${DEMO_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${DEMO_COMPARISON_ROW_COUNT}
    cnt=${DEMO_ROW_COUNT}
    #missing_count= $(({DEMO_COMPARISON_ROW_COUNT}-{DEMO_ROW_COUNT}))
    #missing_count=$((comp_cnt-cnt))
    echo $comp_cnt
    echo $cnt
    missing_count=`expr $comp_cnt - $cnt`
    echo $missing_count " MISSING"  >> $log_location
    echo $missing_count " MISSING"
fi
printf '\n' >> $log_location
printf '\n' >> $log_location
echo ${DRUG_ROW_COUNT} "<- " ${DATABASE_NAME} " DRUG COUNT " >> $log_location
echo ${DRUG_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} " DRUG COUNT " >> $log_location
printf '\n' >> $log_location
printf '\n' >> $log_location
echo 'LAERS AKA LEGACY DATA COMPARISON' >> $log_location
printf '\n' >> $log_location
echo ${DEMO_LEGACY_ROW_COUNT} "<- " ${DATABASE_NAME} " DEMO  LEGACY COUNT " >> $log_location
echo ${DEMO_LEGACY_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} " DEMO  LEGACY COUNT " >> $log_location
printf '\n' >> $log_location
echo ${DRUG_LEGACY_ROW_COUNT} "<- " ${DATABASE_NAME} " DRUG  LEGACY COUNT " >> $log_location
echo ${DRUG_LEGACY_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} " DRUG  LEGACY  COUNT " >> $log_location
printf '\n' >> $log_location
printf '\n' >> $log_location


echo "BEGINNING OF STAGE 5_SQLS JOB" >> $log_location
printf '\n' >> $log_location
