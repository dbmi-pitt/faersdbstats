#!/bin/bash
log_location=${BASE_FILE_DIR}/logs/${LOG_FILENAME}

# log_location=test_log.txt
# source ../faers_config.config

echo $log_location
printf '\n' >> $log_location
printf '\n' >> $log_location
echo "LEGACY LAERS LAYERS " >> $log_location
echo "STAGE_4_LOGGING DOMAIN_LEGACY COUNT RESULTS" >> $log_location
echo "LEGACY LAERS LEGACY LAERS LEGACY LAERS LEGACY LAERS LEGACY LAERS LEGACY LAERS "
printf '\n' >> $log_location

echo 'DEMO_LEGACY' >> $log_location
echo ${DEMO_LEGACY_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DEMO_LEGACY_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
echo ${DEMO_LEGACY_ROW_COUNT} "rc"
echo ${DEMO_LEGACY_COMPARISON_ROW_COUNT} "crc"
if [ ${DEMO_LEGACY_ROW_COUNT} -lt ${DEMO_LEGACY_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${DEMO_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${DEMO_LEGACY_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DEMO_LEGACY_ROW_COUNT} -gt ${DEMO_LEGACY_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${DEMO_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${DEMO_LEGACY_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DEMO_LEGACY_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DEMO_LEGACY_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DEMO_LEGACY PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUG_LEGACY' >> $log_location
echo ${DRUG_LEGACY_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUG_LEGACY_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUG_LEGACY_ROW_COUNT} -lt ${DRUG_LEGACY_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${DRUG_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${DRUG_LEGACY_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUG_LEGACY_ROW_COUNT} -gt ${DRUG_LEGACY_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${DRUG_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${DRUG_LEGACY_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUG_LEGACY_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUG_LEGACY_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUG_LEGACY PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location


echo 'INDI_LEGACY' >> $log_location
echo ${INDI_LEGACY_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${INDI_LEGACY_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${INDI_LEGACY_ROW_COUNT} -lt ${INDI_LEGACY_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${INDI_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${INDI_LEGACY_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${INDI_LEGACY_ROW_COUNT} -gt ${INDI_LEGACY_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${INDI_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${INDI_LEGACY_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${INDI_LEGACY_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${INDI_LEGACY_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "INDI_LEGACY PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location


echo 'REAC_LEGACY' >> $log_location
echo ${REAC_LEGACY_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${REAC_LEGACY_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${REAC_LEGACY_ROW_COUNT} -lt ${REAC_LEGACY_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${REAC_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${REAC_LEGACY_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${REAC_LEGACY_ROW_COUNT} -gt ${REAC_LEGACY_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${REAC_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${REAC_LEGACY_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${REAC_LEGACY_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${REAC_LEGACY_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "REAC_LEGACY PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location




echo 'RPSR_LEGACY' >> $log_location
echo ${RPSR_LEGACY_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${RPSR_LEGACY_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${RPSR_LEGACY_ROW_COUNT} -lt ${RPSR_LEGACY_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${RPSR_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${RPSR_LEGACY_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${RPSR_LEGACY_ROW_COUNT} -gt ${RPSR_LEGACY_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${RPSR_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${RPSR_LEGACY_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${RPSR_LEGACY_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${RPSR_LEGACY_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "RPSR_LEGACY PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'THER_LEGACY' >> $log_location
echo ${THER_LEGACY_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${THER_LEGACY_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${THER_LEGACY_ROW_COUNT} -lt ${THER_LEGACY_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${THER_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${THER_LEGACY_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${THER_LEGACY_ROW_COUNT} -gt ${THER_LEGACY_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${THER_LEGACY_COMPARISON_ROW_COUNT}
	cnt=${THER_LEGACY_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${THER_LEGACY_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${THER_LEGACY_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "THER_LEGACY PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location

