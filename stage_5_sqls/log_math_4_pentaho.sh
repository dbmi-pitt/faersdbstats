#!/bin/bash
log_location=${BASE_FILE_DIR}/logs/${LOG_FILENAME}

# log_location=test_log.txt
# source ../faers_config.config

echo $log_location
printf '\n' >> $log_location
printf '\n' >> $log_location
echo "BEGINNING OF STAGE_4_LOGGING DOMAIN COUNT RESULTS" >> $log_location
printf '\n' >> $log_location

echo 'DEMO' >> $log_location
echo ${DEMO_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DEMO_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DEMO_ROW_COUNT} -lt ${DEMO_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${DEMO_COMPARISON_ROW_COUNT}
	cnt=${DEMO_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DEMO_ROW_COUNT} -gt ${DEMO_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${DEMO_COMPARISON_ROW_COUNT}
	cnt=${DEMO_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DEMO_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DEMO_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DEMO PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUG' >> $log_location
echo ${DRUG_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUG_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUG_ROW_COUNT} -lt ${DRUG_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${DRUG_COMPARISON_ROW_COUNT}
	cnt=${DRUG_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUG_ROW_COUNT} -gt ${DRUG_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${DRUG_COMPARISON_ROW_COUNT}
	cnt=${DRUG_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUG_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUG_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUG PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location


echo 'INDI' >> $log_location
echo ${INDI_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${INDI_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${INDI_ROW_COUNT} -lt ${INDI_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${INDI_COMPARISON_ROW_COUNT}
	cnt=${INDI_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${INDI_ROW_COUNT} -gt ${INDI_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${INDI_COMPARISON_ROW_COUNT}
	cnt=${INDI_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${INDI_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${INDI_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "INDI PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location


echo 'REAC' >> $log_location
echo ${REAC_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${REAC_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${REAC_ROW_COUNT} -lt ${REAC_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${REAC_COMPARISON_ROW_COUNT}
	cnt=${REAC_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${REAC_ROW_COUNT} -gt ${REAC_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${REAC_COMPARISON_ROW_COUNT}
	cnt=${REAC_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${REAC_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${REAC_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "REAC PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location




echo 'RPSR' >> $log_location
echo ${RPSR_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${RPSR_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${RPSR_ROW_COUNT} -lt ${RPSR_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${RPSR_COMPARISON_ROW_COUNT}
	cnt=${RPSR_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${RPSR_ROW_COUNT} -gt ${RPSR_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${RPSR_COMPARISON_ROW_COUNT}
	cnt=${RPSR_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${RPSR_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${RPSR_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "RPSR PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'THER' >> $log_location
echo ${THER_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${THER_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${THER_ROW_COUNT} -lt ${THER_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${THER_COMPARISON_ROW_COUNT}
	cnt=${THER_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${THER_ROW_COUNT} -gt ${THER_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${THER_COMPARISON_ROW_COUNT}
	cnt=${THER_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${THER_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${THER_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "THER PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location




echo "BEGINNING OF STAGE 5_SQLS JOB" >> $log_location
printf '\n' >> $log_location
