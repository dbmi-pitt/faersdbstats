#!/bin/bash
# source ../../faers_config.config
log_location=${BASE_FILE_DIR}/logs/${LOG_FILENAME}

echo $log_location
# printf '\n' >> $log_location
# printf '\n' >> $log_location
# echo "BEGINNING OF STAGE_4_LOGGING DOMAIN COUNT RESULTS" >> $log_location
# printf '\n' >> $log_location

# echo 'DEMO' >> $log_location
# echo ${DEMO_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
# echo ${DEMO_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
# if [ ${DEMO_ROW_COUNT} -lt ${DEMO_COMPARISON_ROW_COUNT} ]
# then
# 	comp_cnt=${DEMO_COMPARISON_ROW_COUNT}
# 	cnt=${DEMO_ROW_COUNT}
#     echo $comp_cnt
#     echo $cnt
# 	missing_count=$(($comp_cnt-$cnt))
# 	echo $missing_count " MISSING"
# 	echo $missing_count " MISSING"  >> $log_location
# elif [ ${DEMO_ROW_COUNT} -gt ${DEMO_COMPARISON_ROW_COUNT} ]
# then
#     comp_cnt=${DEMO_COMPARISON_ROW_COUNT}
# 	cnt=${DEMO_ROW_COUNT}
#     missing_count=$(($cnt-$comp_cnt))
# 	echo $missing_count " EXTRA"  >> $log_location
# elif [ ${DEMO_ROW_COUNT} -eq 0 ]
# then
#     echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
# elif [ ${DEMO_COMPARISON_ROW_COUNT} -eq 0 ]
# then
#      echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
# else
#     echo "DEMO PERFECTO!!!"  >> $log_location
# fi
# printf '\n' >> $log_location
# echo $(wc -l ${BASE_FILE_DIR}/data_from_s3/faers/demo/demo.txt) >> $log_location
# echo '^wc -l of demo.txt' >> $log_location
# printf '\n' >> $log_location
# printf '\n' >> $log_location



# echo 'DRUG' >> $log_location
# echo ${DRUG_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
# echo ${DRUG_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
# if [ ${DRUG_ROW_COUNT} -lt ${DRUG_COMPARISON_ROW_COUNT} ]
# then
# 	comp_cnt=${DRUG_COMPARISON_ROW_COUNT}
# 	cnt=${DRUG_ROW_COUNT}
#     echo $comp_cnt
#     echo $cnt
# 	missing_count=$(($comp_cnt-$cnt))
# 	echo $missing_count " MISSING"
# 	echo $missing_count " MISSING"  >> $log_location
# elif [ ${DRUG_ROW_COUNT} -gt ${DRUG_COMPARISON_ROW_COUNT} ]
# then
#     comp_cnt=${DRUG_COMPARISON_ROW_COUNT}
# 	cnt=${DRUG_ROW_COUNT}
#     missing_count=$(($cnt-$comp_cnt))
# 	echo $missing_count " EXTRA"  >> $log_location
# elif [ ${DRUG_ROW_COUNT} -eq 0 ]
# then
#     echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
# elif [ ${DRUG_COMPARISON_ROW_COUNT} -eq 0 ]
# then
#      echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
# else
#     echo "DRUG PERFECTO!!!"  >> $log_location
# fi
# printf '\n' >> $log_location
# echo $(wc -l ${BASE_FILE_DIR}/data_from_s3/faers/drug/drug.txt) >> $log_location
# echo '^wc -l of drug.txt' >> $log_location
# printf '\n' >> $log_location
# printf '\n' >> $log_location


# echo 'INDI' >> $log_location
# echo ${INDI_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
# echo ${INDI_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
# if [ ${INDI_ROW_COUNT} -lt ${INDI_COMPARISON_ROW_COUNT} ]
# then
# 	comp_cnt=${INDI_COMPARISON_ROW_COUNT}
# 	cnt=${INDI_ROW_COUNT}
#     echo $comp_cnt
#     echo $cnt
# 	missing_count=$(($comp_cnt-$cnt))
# 	echo $missing_count " MISSING"
# 	echo $missing_count " MISSING"  >> $log_location
# elif [ ${INDI_ROW_COUNT} -gt ${INDI_COMPARISON_ROW_COUNT} ]
# then
#     comp_cnt=${INDI_COMPARISON_ROW_COUNT}
# 	cnt=${INDI_ROW_COUNT}
#     missing_count=$(($cnt-$comp_cnt))
# 	echo $missing_count " EXTRA"  >> $log_location
# elif [ ${INDI_ROW_COUNT} -eq 0 ]
# then
#     echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
# elif [ ${INDI_COMPARISON_ROW_COUNT} -eq 0 ]
# then
#      echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
# else
#     echo "INDI PERFECTO!!!"  >> $log_location
# fi
# printf '\n' >> $log_location
# echo $(wc -l ${BASE_FILE_DIR}/data_from_s3/faers/indi/indi.txt) >> $log_location
# echo '^wc -l of indi.txt' >> $log_location
# printf '\n' >> $log_location
# printf '\n' >> $log_location


echo 'OUTC' >> $log_location
echo ${OUTC_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${OUTC_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${OUTC_ROW_COUNT} -lt ${OUTC_COMPARISON_ROW_COUNT} ]
then
	comp_cnt=${OUTC_COMPARISON_ROW_COUNT}
	cnt=${OUTC_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${OUTC_ROW_COUNT} -gt ${OUTC_COMPARISON_ROW_COUNT} ]
then
    comp_cnt=${OUTC_COMPARISON_ROW_COUNT}
	cnt=${OUTC_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${OUTC_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${OUTC_COMPARISON_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "OUTC PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
echo $(wc -l ${BASE_FILE_DIR}/data_from_s3/faers/outc/outc.txt) >> $log_location
echo '^wc -l of outc.txt' >> $log_location
printf '\n' >> $log_location
printf '\n' >> $log_location

# Check if LOAD_ALL_TIME is not 0
if [ ${LOAD_ALL_TIME} -ne 1 ]; then
    echo "Adding new quarter" >> $log_location

    # Get the line count of outc_new_qtr.txt
    new_qtr_count=$(wc -l < ${BASE_FILE_DIR}/data_from_s3/faers/outc/outc_new_qtr.txt)
    echo "${new_qtr_count} <- outc_new_qtr.txt" >> $log_location

    # Compare new quarter line count against the missing count
    comparison_result=$(($new_qtr_count - $missing_count))
    if [ $comparison_result -eq 0 ]; then
        echo "NEW QUARTER PERFECTO!" >> $log_location
    else
        echo "New quarter line count (${new_qtr_count}) does not match missing count (${missing_count}). Difference: $comparison_result" >> $log_location
    fi

    # Add blank lines for log separation
    printf '\n' >> $log_location
fi

# echo 'REAC' >> $log_location
# echo ${REAC_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
# echo ${REAC_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
# if [ ${REAC_ROW_COUNT} -lt ${REAC_COMPARISON_ROW_COUNT} ]
# then
# 	comp_cnt=${REAC_COMPARISON_ROW_COUNT}
# 	cnt=${REAC_ROW_COUNT}
#     echo $comp_cnt
#     echo $cnt
# 	missing_count=$(($comp_cnt-$cnt))
# 	echo $missing_count " MISSING"
# 	echo $missing_count " MISSING"  >> $log_location
# elif [ ${REAC_ROW_COUNT} -gt ${REAC_COMPARISON_ROW_COUNT} ]
# then
#     comp_cnt=${REAC_COMPARISON_ROW_COUNT}
# 	cnt=${REAC_ROW_COUNT}
#     missing_count=$(($cnt-$comp_cnt))
# 	echo $missing_count " EXTRA"  >> $log_location
# elif [ ${REAC_ROW_COUNT} -eq 0 ]
# then
#     echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
# elif [ ${REAC_COMPARISON_ROW_COUNT} -eq 0 ]
# then
#      echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
# else
#     echo "REAC PERFECTO!!!"  >> $log_location
# fi
# printf '\n' >> $log_location
# echo $(wc -l ${BASE_FILE_DIR}/data_from_s3/faers/reac/reac.txt) >> $log_location
# echo '^wc -l of reac.txt' >> $log_location
# printf '\n' >> $log_location
# printf '\n' >> $log_location




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
echo $(wc -l ${BASE_FILE_DIR}/data_from_s3/faers/rpsr/rpsr.txt) >> $log_location
printf '\n' >> $log_location
echo '^wc -l of rpsr.txt' >> $log_location
printf '\n' >> $log_location
printf '\n' >> $log_location

# Check if LOAD_ALL_TIME is not 0
if [ ${LOAD_ALL_TIME} -ne 1 ]; then
    echo "Adding new quarter" >> $log_location

    # Get the line count of rpsr_new_qtr.txt
    new_qtr_count=$(wc -l < ${BASE_FILE_DIR}/data_from_s3/faers/rpsr/rpsr_new_qtr.txt)
    echo "${new_qtr_count} <- rpsr_new_qtr.txt" >> $log_location

    # Compare new quarter line count against the missing count
    comparison_result=$(($new_qtr_count - $missing_count))
    if [ $comparison_result -eq 0 ]; then
        echo "NEW QUARTER PERFECTO!" >> $log_location
    else
        echo "New quarter line count (${new_qtr_count}) does not match missing count (${missing_count}). Difference: $comparison_result" >> $log_location
    fi

    # Add blank lines for log separation
    printf '\n' >> $log_location
fi

# echo 'THER' >> $log_location
# echo ${THER_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
# echo ${THER_COMPARISON_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
# if [ ${THER_ROW_COUNT} -lt ${THER_COMPARISON_ROW_COUNT} ]
# then
# 	comp_cnt=${THER_COMPARISON_ROW_COUNT}
# 	cnt=${THER_ROW_COUNT}
#     echo $comp_cnt
#     echo $cnt
# 	missing_count=$(($comp_cnt-$cnt))
# 	echo $missing_count " MISSING"
# 	echo $missing_count " MISSING"  >> $log_location
# elif [ ${THER_ROW_COUNT} -gt ${THER_COMPARISON_ROW_COUNT} ]
# then
#     comp_cnt=${THER_COMPARISON_ROW_COUNT}
# 	cnt=${THER_ROW_COUNT}
#     missing_count=$(($cnt-$comp_cnt))
# 	echo $missing_count " EXTRA"  >> $log_location
# elif [ ${THER_ROW_COUNT} -eq 0 ]
# then
#     echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
# elif [ ${THER_COMPARISON_ROW_COUNT} -eq 0 ]
# then
#      echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
# else
#     echo "THER PERFECTO!!!"  >> $log_location
# fi
# echo $(wc -l ${BASE_FILE_DIR}/data_from_s3/faers/ther/ther.txt) >> $log_location
# printf '\n' >> $log_location
# echo '^wc -l of ther.txt' >> $log_location
# printf '\n' >> $log_location
# printf '\n' >> $log_location




# echo "BEGINNING OF STAGE_4_META QUARTER LOGS" >> $log_location
# printf '\n' >> $log_location
