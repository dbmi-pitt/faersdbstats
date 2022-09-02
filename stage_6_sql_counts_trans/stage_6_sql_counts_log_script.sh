#!/bin/bash
log_location=${BASE_FILE_DIR}/logs/${LOG_FILENAME}

# log_location=test_log.txt
# source ../faers_config.config

echo $log_location
printf '\n' >> $log_location
printf '\n' >> $log_location
echo "Stage_6_sql_counts_3_of_3 has started" >> $log_location
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



echo 'DRUGNAME_LIST' >> $log_location
echo ${DRUGNAME_LIST_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUGNAME_LIST_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUGNAME_LIST_ROW_COUNT} -lt ${DRUGNAME_LIST_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUGNAME_LIST_COMP_ROW_COUNT}
	cnt=${DRUGNAME_LIST_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUGNAME_LIST_ROW_COUNT} -gt ${DRUGNAME_LIST_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUGNAME_LIST_COMP_ROW_COUNT}
	cnt=${DRUGNAME_LIST_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUGNAME_LIST_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUGNAME_LIST_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUGNAME_LIST PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'REAC_PT_LIST' >> $log_location
echo ${REAC_PT_LIST_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${REAC_PT_LIST_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${REAC_PT_LIST_ROW_COUNT} -lt ${REAC_PT_LIST_COMP_ROW_COUNT} ]
then
	comp_cnt=${REAC_PT_LIST_COMP_ROW_COUNT}
	cnt=${REAC_PT_LIST_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${REAC_PT_LIST_ROW_COUNT} -gt ${REAC_PT_LIST_COMP_ROW_COUNT} ]
then
    comp_cnt=${REAC_PT_LIST_COMP_ROW_COUNT}
	cnt=${REAC_PT_LIST_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${REAC_PT_LIST_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${REAC_PT_LIST_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "REAC_PT_LIST PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_DRUG_OUTCOME_DRILLDOWN' >> $log_location
echo ${STANDARD_DRUG_OUTCOME_DRILLDOWN_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_DRUG_OUTCOME_DRILLDOWN_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_DRUG_OUTCOME_DRILLDOWN_ROW_COUNT} -lt ${STANDARD_DRUG_OUTCOME_DRILLDOWN_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_DRUG_OUTCOME_DRILLDOWN_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_DRILLDOWN_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_DRILLDOWN_ROW_COUNT} -gt ${STANDARD_DRUG_OUTCOME_DRILLDOWN_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_DRUG_OUTCOME_DRILLDOWN_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_DRILLDOWN_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_DRILLDOWN_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_DRILLDOWN_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_DRUG_OUTCOME_DRILLDOWN PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_DRUG_OUTCOME_COUNT_D1_ROW_COUNT' >> $log_location
echo ${STANDARD_DRUG_OUTCOME_COUNT_D1_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_DRUG_OUTCOME_COUNT_D1_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_DRUG_OUTCOME_COUNT_D1_ROW_COUNT} -lt ${STANDARD_DRUG_OUTCOME_COUNT_D1_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_DRUG_OUTCOME_COUNT_D1_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_COUNT_D1_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COUNT_D1_ROW_COUNT} -gt ${STANDARD_DRUG_OUTCOME_COUNT_D1_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_DRUG_OUTCOME_COUNT_D1_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_COUNT_D1_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COUNT_D1_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COUNT_D1_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_DRUG_OUTCOME_COUNT_D1_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_ROW_COUNT' >> $log_location
echo ${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_ROW_COUNT} -lt ${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_ROW_COUNT} -gt ${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_DRUG_OUTCOME_COUNT_A_COUNT_B_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_DRUG_OUTCOME_COUNT_C_ROW_COUNT' >> $log_location
echo ${STANDARD_DRUG_OUTCOME_COUNT_C_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_DRUG_OUTCOME_COUNT_C_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_DRUG_OUTCOME_COUNT_C_ROW_COUNT} -lt ${STANDARD_DRUG_OUTCOME_COUNT_C_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_DRUG_OUTCOME_COUNT_C_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_COUNT_C_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COUNT_C_ROW_COUNT} -gt ${STANDARD_DRUG_OUTCOME_COUNT_C_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_DRUG_OUTCOME_COUNT_C_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_COUNT_C_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COUNT_C_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COUNT_C_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_DRUG_OUTCOME_COUNT_C_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_DRUG_OUTCOME_CONTINGENCY_ROW_COUNT' >> $log_location
echo ${STANDARD_DRUG_OUTCOME_CONTINGENCY_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_DRUG_OUTCOME_CONTINGENCY_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_DRUG_OUTCOME_CONTINGENCY_ROW_COUNT} -lt ${STANDARD_DRUG_OUTCOME_CONTINGENCY_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_DRUG_OUTCOME_CONTINGENCY_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_CONTINGENCY_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_CONTINGENCY_ROW_COUNT} -gt ${STANDARD_DRUG_OUTCOME_CONTINGENCY_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_DRUG_OUTCOME_CONTINGENCY_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_CONTINGENCY_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_CONTINGENCY_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_CONTINGENCY_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_DRUG_OUTCOME_CONTINGENCY_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_DRUG_OUTCOME_ROW_COUNT' >> $log_location
echo ${STANDARD_DRUG_OUTCOME_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_DRUG_OUTCOME_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_DRUG_OUTCOME_ROW_COUNT} -lt ${STANDARD_DRUG_OUTCOME_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_DRUG_OUTCOME_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_ROW_COUNT} -gt ${STANDARD_DRUG_OUTCOME_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_DRUG_OUTCOME_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_DRUG_OUTCOME_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_CASE_OUTCOME_ROW_COUNT' >> $log_location
echo ${STANDARD_CASE_OUTCOME_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_CASE_OUTCOME_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_CASE_OUTCOME_ROW_COUNT} -lt ${STANDARD_CASE_OUTCOME_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_CASE_OUTCOME_COMP_ROW_COUNT}
	cnt=${STANDARD_CASE_OUTCOME_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_CASE_OUTCOME_ROW_COUNT} -gt ${STANDARD_CASE_OUTCOME_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_CASE_OUTCOME_COMP_ROW_COUNT}
	cnt=${STANDARD_CASE_OUTCOME_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_CASE_OUTCOME_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_CASE_OUTCOME_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_CASE_OUTCOME_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_CASE_INDICATION_ROW_COUNT' >> $log_location
echo ${STANDARD_CASE_INDICATION_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_CASE_INDICATION_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_CASE_INDICATION_ROW_COUNT} -lt ${STANDARD_CASE_INDICATION_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_CASE_INDICATION_COMP_ROW_COUNT}
	cnt=${STANDARD_CASE_INDICATION_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_CASE_INDICATION_ROW_COUNT} -gt ${STANDARD_CASE_INDICATION_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_CASE_INDICATION_COMP_ROW_COUNT}
	cnt=${STANDARD_CASE_INDICATION_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_CASE_INDICATION_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_CASE_INDICATION_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_CASE_INDICATION_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location





echo 'STANDARD_CASE_OUTCOME_CATEGORY_ROW_COUNT' >> $log_location
echo ${STANDARD_CASE_OUTCOME_CATEGORY_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_CASE_OUTCOME_CATEGORY_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_CASE_OUTCOME_CATEGORY_ROW_COUNT} -lt ${STANDARD_CASE_OUTCOME_CATEGORY_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_CASE_OUTCOME_CATEGORY_COMP_ROW_COUNT}
	cnt=${STANDARD_CASE_OUTCOME_CATEGORY_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_CASE_OUTCOME_CATEGORY_ROW_COUNT} -gt ${STANDARD_CASE_OUTCOME_CATEGORY_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_CASE_OUTCOME_CATEGORY_COMP_ROW_COUNT}
	cnt=${STANDARD_CASE_OUTCOME_CATEGORY_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_CASE_OUTCOME_CATEGORY_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_CASE_OUTCOME_CATEGORY_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_CASE_OUTCOME_CATEGORY_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUG_REGEX_MAPPING_ROW_COUNT' >> $log_location
echo ${DRUG_REGEX_MAPPING_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUG_REGEX_MAPPING_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUG_REGEX_MAPPING_ROW_COUNT} -lt ${DRUG_REGEX_MAPPING_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUG_REGEX_MAPPING_COMP_ROW_COUNT}
	cnt=${DRUG_REGEX_MAPPING_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUG_REGEX_MAPPING_ROW_COUNT} -gt ${DRUG_REGEX_MAPPING_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUG_REGEX_MAPPING_COMP_ROW_COUNT}
	cnt=${DRUG_REGEX_MAPPING_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUG_REGEX_MAPPING_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUG_REGEX_MAPPING_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUG_REGEX_MAPPING_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUG_REGEX_MAPPING_WORDS_ROW_COUNT' >> $log_location
echo ${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT} -lt ${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT}
	cnt=${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT} -gt ${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT}
	cnt=${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUG_REGEX_MAPPING_WORDS_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUG_REGEX_MAPPING_WORDS_ROW_COUNT' >> $log_location
echo ${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT} -lt ${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT}
	cnt=${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT} -gt ${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT}
	cnt=${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUG_REGEX_MAPPING_WORDS_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUG_REGEX_MAPPING_WORDS_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUG_REGEX_MAPPING_WORDS_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUG_MAPPING_MULTI_INGREDIENT_LIST_ROW_COUNT' >> $log_location
echo ${DRUG_MAPPING_MULTI_INGREDIENT_LIST_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUG_MAPPING_MULTI_INGREDIENT_LIST_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUG_MAPPING_MULTI_INGREDIENT_LIST_ROW_COUNT} -lt ${DRUG_MAPPING_MULTI_INGREDIENT_LIST_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUG_MAPPING_MULTI_INGREDIENT_LIST_COMP_ROW_COUNT}
	cnt=${DRUG_MAPPING_MULTI_INGREDIENT_LIST_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUG_MAPPING_MULTI_INGREDIENT_LIST_ROW_COUNT} -gt ${DRUG_MAPPING_MULTI_INGREDIENT_LIST_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUG_MAPPING_MULTI_INGREDIENT_LIST_COMP_ROW_COUNT}
	cnt=${DRUG_MAPPING_MULTI_INGREDIENT_LIST_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUG_MAPPING_MULTI_INGREDIENT_LIST_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUG_MAPPING_MULTI_INGREDIENT_LIST_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUG_MAPPING_MULTI_INGREDIENT_LIST_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_ROW_COUNT' >> $log_location
echo ${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_ROW_COUNT} -lt ${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_COMP_ROW_COUNT} ]
then
	comp_cnt=${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_COMP_ROW_COUNT}
	cnt=${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_ROW_COUNT} -gt ${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_COMP_ROW_COUNT} ]
then
    comp_cnt=${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_COMP_ROW_COUNT}
	cnt=${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "RXNORM_MAPPING_SINGLE_INGREDIENT_LIST_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'RXNORM_MAPPING_BRAND_NAME_LIST_ROW_COUNT' >> $log_location
echo ${RXNORM_MAPPING_BRAND_NAME_LIST_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${RXNORM_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${RXNORM_MAPPING_BRAND_NAME_LIST_ROW_COUNT} -lt ${RXNORM_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT} ]
then
	comp_cnt=${RXNORM_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT}
	cnt=${RXNORM_MAPPING_BRAND_NAME_LIST_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${RXNORM_MAPPING_BRAND_NAME_LIST_ROW_COUNT} -gt ${RXNORM_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT} ]
then
    comp_cnt=${RXNORM_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT}
	cnt=${RXNORM_MAPPING_BRAND_NAME_LIST_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${RXNORM_MAPPING_BRAND_NAME_LIST_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${RXNORM_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "RXNORM_MAPPING_BRAND_NAME_LIST_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUG_MAPPING_BRAND_NAME_LIST_ROW_COUNT' >> $log_location
echo ${DRUG_MAPPING_BRAND_NAME_LIST_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUG_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUG_MAPPING_BRAND_NAME_LIST_ROW_COUNT} -lt ${DRUG_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUG_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT}
	cnt=${DRUG_MAPPING_BRAND_NAME_LIST_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUG_MAPPING_BRAND_NAME_LIST_ROW_COUNT} -gt ${DRUG_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUG_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT}
	cnt=${DRUG_MAPPING_BRAND_NAME_LIST_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUG_MAPPING_BRAND_NAME_LIST_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUG_MAPPING_BRAND_NAME_LIST_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUG_MAPPING_BRAND_NAME_LIST_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUG_AI_MAPPING_ROW_COUNT' >> $log_location
echo ${DRUG_AI_MAPPING_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUG_AI_MAPPING_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUG_AI_MAPPING_ROW_COUNT} -lt ${DRUG_AI_MAPPING_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUG_AI_MAPPING_COMP_ROW_COUNT}
	cnt=${DRUG_AI_MAPPING_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUG_AI_MAPPING_ROW_COUNT} -gt ${DRUG_AI_MAPPING_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUG_AI_MAPPING_COMP_ROW_COUNT}
	cnt=${DRUG_AI_MAPPING_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUG_AI_MAPPING_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUG_AI_MAPPING_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUG_AI_MAPPING_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'NDA_INGREDIENT_ROW_COUNT' >> $log_location
echo ${NDA_INGREDIENT_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${NDA_INGREDIENT_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${NDA_INGREDIENT_ROW_COUNT} -lt ${NDA_INGREDIENT_COMP_ROW_COUNT} ]
then
	comp_cnt=${NDA_INGREDIENT_COMP_ROW_COUNT}
	cnt=${NDA_INGREDIENT_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${NDA_INGREDIENT_ROW_COUNT} -gt ${NDA_INGREDIENT_COMP_ROW_COUNT} ]
then
    comp_cnt=${NDA_INGREDIENT_COMP_ROW_COUNT}
	cnt=${NDA_INGREDIENT_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${NDA_INGREDIENT_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${NDA_INGREDIENT_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "NDA_INGREDIENT_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUG_NDA_MAPPING_ROW_COUNT' >> $log_location
echo ${DRUG_NDA_MAPPING_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUG_NDA_MAPPING_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUG_NDA_MAPPING_ROW_COUNT} -lt ${DRUG_NDA_MAPPING_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUG_NDA_MAPPING_COMP_ROW_COUNT}
	cnt=${DRUG_NDA_MAPPING_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUG_NDA_MAPPING_ROW_COUNT} -gt ${DRUG_NDA_MAPPING_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUG_NDA_MAPPING_COMP_ROW_COUNT}
	cnt=${DRUG_NDA_MAPPING_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUG_NDA_MAPPING_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUG_NDA_MAPPING_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUG_NDA_MAPPING_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'COMBINED_DRUG_MAPPING_ROW_COUNT' >> $log_location
echo ${COMBINED_DRUG_MAPPING_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${COMBINED_DRUG_MAPPING_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${COMBINED_DRUG_MAPPING_ROW_COUNT} -lt ${COMBINED_DRUG_MAPPING_COMP_ROW_COUNT} ]
then
	comp_cnt=${COMBINED_DRUG_MAPPING_COMP_ROW_COUNT}
	cnt=${COMBINED_DRUG_MAPPING_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${COMBINED_DRUG_MAPPING_ROW_COUNT} -gt ${COMBINED_DRUG_MAPPING_COMP_ROW_COUNT} ]
then
    comp_cnt=${COMBINED_DRUG_MAPPING_COMP_ROW_COUNT}
	cnt=${COMBINED_DRUG_MAPPING_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${COMBINED_DRUG_MAPPING_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${COMBINED_DRUG_MAPPING_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "COMBINED_DRUG_MAPPING_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUGNAME_LIST_ROW_COUNT' >> $log_location
echo ${DRUGNAME_LIST_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUGNAME_LIST_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUGNAME_LIST_ROW_COUNT} -lt ${DRUGNAME_LIST_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUGNAME_LIST_COMP_ROW_COUNT}
	cnt=${DRUGNAME_LIST_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUGNAME_LIST_ROW_COUNT} -gt ${DRUGNAME_LIST_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUGNAME_LIST_COMP_ROW_COUNT}
	cnt=${DRUGNAME_LIST_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUGNAME_LIST_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUGNAME_LIST_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUGNAME_LIST_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location


# I don't think this exists
# echo 'REAC_PT_ROW_COUNT' >> $log_location
# echo ${REAC_PT_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
# echo ${REAC_PT_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
# if [ ${REAC_PT_ROW_COUNT} -lt ${REAC_PT_COMP_ROW_COUNT} ]
# then
# 	comp_cnt=${REAC_PT_COMP_ROW_COUNT}
# 	cnt=${REAC_PT_ROW_COUNT}
#     echo $comp_cnt
#     echo $cnt
# 	missing_count=$(($comp_cnt-$cnt))
# 	echo $missing_count " MISSING"
# 	echo $missing_count " MISSING"  >> $log_location
# elif [ ${REAC_PT_ROW_COUNT} -gt ${REAC_PT_COMP_ROW_COUNT} ]
# then
#     comp_cnt=${REAC_PT_COMP_ROW_COUNT}
# 	cnt=${REAC_PT_ROW_COUNT}
#     missing_count=$(($cnt-$comp_cnt))
# 	echo $missing_count " EXTRA"  >> $log_location
# elif [ ${REAC_PT_ROW_COUNT} -eq 0 ]
# then
#     echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
# elif [ ${REAC_PT_COMP_ROW_COUNT} -eq 0 ]
# then
#      echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
# else
#     echo "REAC_PT_ROW_COUNT PERFECTO!!!"  >> $log_location
# fi
# printf '\n' >> $log_location
# printf '\n' >> $log_location



echo 'CASEDEMO_ROW_COUNT' >> $log_location
echo ${CASEDEMO_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${CASEDEMO_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${CASEDEMO_ROW_COUNT} -lt ${CASEDEMO_COMP_ROW_COUNT} ]
then
	comp_cnt=${CASEDEMO_COMP_ROW_COUNT}
	cnt=${CASEDEMO_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${CASEDEMO_ROW_COUNT} -gt ${CASEDEMO_COMP_ROW_COUNT} ]
then
    comp_cnt=${CASEDEMO_COMP_ROW_COUNT}
	cnt=${CASEDEMO_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${CASEDEMO_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${CASEDEMO_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "CASEDEMO_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DRUGNAME_LEGACY_LIST_ROW_COUNT' >> $log_location
echo ${DRUGNAME_LEGACY_LIST_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DRUGNAME_LEGACY_LIST_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DRUGNAME_LEGACY_LIST_ROW_COUNT} -lt ${DRUGNAME_LEGACY_LIST_COMP_ROW_COUNT} ]
then
	comp_cnt=${DRUGNAME_LEGACY_LIST_COMP_ROW_COUNT}
	cnt=${DRUGNAME_LEGACY_LIST_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DRUGNAME_LEGACY_LIST_ROW_COUNT} -gt ${DRUGNAME_LEGACY_LIST_COMP_ROW_COUNT} ]
then
    comp_cnt=${DRUGNAME_LEGACY_LIST_COMP_ROW_COUNT}
	cnt=${DRUGNAME_LEGACY_LIST_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DRUGNAME_LEGACY_LIST_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DRUGNAME_LEGACY_LIST_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DRUGNAME_LEGACY_LIST_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'REAC_PT_LEGACY_LIST_ROW_COUNT' >> $log_location
echo ${REAC_PT_LEGACY_LIST_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${REAC_PT_LEGACY_LIST_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${REAC_PT_LEGACY_LIST_ROW_COUNT} -lt ${REAC_PT_LEGACY_LIST_COMP_ROW_COUNT} ]
then
	comp_cnt=${REAC_PT_LEGACY_LIST_COMP_ROW_COUNT}
	cnt=${REAC_PT_LEGACY_LIST_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${REAC_PT_LEGACY_LIST_ROW_COUNT} -gt ${REAC_PT_LEGACY_LIST_COMP_ROW_COUNT} ]
then
    comp_cnt=${REAC_PT_LEGACY_LIST_COMP_ROW_COUNT}
	cnt=${REAC_PT_LEGACY_LIST_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${REAC_PT_LEGACY_LIST_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${REAC_PT_LEGACY_LIST_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "REAC_PT_LEGACY_LIST_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'CASEDEMO_LEGACY_ROW_COUNT' >> $log_location
echo ${CASEDEMO_LEGACY_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${CASEDEMO_LEGACY_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${CASEDEMO_LEGACY_ROW_COUNT} -lt ${CASEDEMO_LEGACY_COMP_ROW_COUNT} ]
then
	comp_cnt=${CASEDEMO_LEGACY_COMP_ROW_COUNT}
	cnt=${CASEDEMO_LEGACY_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${CASEDEMO_LEGACY_ROW_COUNT} -gt ${CASEDEMO_LEGACY_COMP_ROW_COUNT} ]
then
    comp_cnt=${CASEDEMO_LEGACY_COMP_ROW_COUNT}
	cnt=${CASEDEMO_LEGACY_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${CASEDEMO_LEGACY_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${CASEDEMO_LEGACY_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "CASEDEMO_LEGACY_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'ALL_CASEDEMO_ROW_COUNT' >> $log_location
echo ${ALL_CASEDEMO_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${ALL_CASEDEMO_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${ALL_CASEDEMO_ROW_COUNT} -lt ${ALL_CASEDEMO_COMP_ROW_COUNT} ]
then
	comp_cnt=${ALL_CASEDEMO_COMP_ROW_COUNT}
	cnt=${ALL_CASEDEMO_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${ALL_CASEDEMO_ROW_COUNT} -gt ${ALL_CASEDEMO_COMP_ROW_COUNT} ]
then
    comp_cnt=${ALL_CASEDEMO_COMP_ROW_COUNT}
	cnt=${ALL_CASEDEMO_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${ALL_CASEDEMO_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${ALL_CASEDEMO_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "ALL_CASEDEMO_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_ROW_COUNT' >> $log_location
echo ${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_ROW_COUNT} -lt ${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_COMP_ROW_COUNT} ]
then
	comp_cnt=${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_COMP_ROW_COUNT}
	cnt=${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_ROW_COUNT} -gt ${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_COMP_ROW_COUNT} ]
then
    comp_cnt=${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_COMP_ROW_COUNT}
	cnt=${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DEFAULT_ALL_CASEDEMO_EVENT_DT_KEYS_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DEFAULT_ALL_CASEDEMO_AGE_KEYS_ROW_COUNT' >> $log_location
echo ${DEFAULT_ALL_CASEDEMO_AGE_KEYS_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DEFAULT_ALL_CASEDEMO_AGE_KEYS_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DEFAULT_ALL_CASEDEMO_AGE_KEYS_ROW_COUNT} -lt ${DEFAULT_ALL_CASEDEMO_AGE_KEYS_COMP_ROW_COUNT} ]
then
	comp_cnt=${DEFAULT_ALL_CASEDEMO_AGE_KEYS_COMP_ROW_COUNT}
	cnt=${DEFAULT_ALL_CASEDEMO_AGE_KEYS_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DEFAULT_ALL_CASEDEMO_AGE_KEYS_ROW_COUNT} -gt ${DEFAULT_ALL_CASEDEMO_AGE_KEYS_COMP_ROW_COUNT} ]
then
    comp_cnt=${DEFAULT_ALL_CASEDEMO_AGE_KEYS_COMP_ROW_COUNT}
	cnt=${DEFAULT_ALL_CASEDEMO_AGE_KEYS_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DEFAULT_ALL_CASEDEMO_AGE_KEYS_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DEFAULT_ALL_CASEDEMO_AGE_KEYS_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DEFAULT_ALL_CASEDEMO_AGE_KEYS_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'DEFAULT_REPORTER_COUNTRY_KEYS_ROW_COUNT' >> $log_location
echo ${DEFAULT_REPORTER_COUNTRY_KEYS_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${DEFAULT_REPORTER_COUNTRY_KEYS_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${DEFAULT_REPORTER_COUNTRY_KEYS_ROW_COUNT} -lt ${DEFAULT_REPORTER_COUNTRY_KEYS_COMP_ROW_COUNT} ]
then
	comp_cnt=${DEFAULT_REPORTER_COUNTRY_KEYS_COMP_ROW_COUNT}
	cnt=${DEFAULT_REPORTER_COUNTRY_KEYS_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${DEFAULT_REPORTER_COUNTRY_KEYS_ROW_COUNT} -gt ${DEFAULT_REPORTER_COUNTRY_KEYS_COMP_ROW_COUNT} ]
then
    comp_cnt=${DEFAULT_REPORTER_COUNTRY_KEYS_COMP_ROW_COUNT}
	cnt=${DEFAULT_REPORTER_COUNTRY_KEYS_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${DEFAULT_REPORTER_COUNTRY_KEYS_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${DEFAULT_REPORTER_COUNTRY_KEYS_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "DEFAULT_REPORTER_COUNTRY_KEYS_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'UNIQUE_ALL_CASEDEMO_ROW_COUNT' >> $log_location
echo ${UNIQUE_ALL_CASEDEMO_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${UNIQUE_ALL_CASEDEMO_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${UNIQUE_ALL_CASEDEMO_ROW_COUNT} -lt ${UNIQUE_ALL_CASEDEMO_COMP_ROW_COUNT} ]
then
	comp_cnt=${UNIQUE_ALL_CASEDEMO_COMP_ROW_COUNT}
	cnt=${UNIQUE_ALL_CASEDEMO_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${UNIQUE_ALL_CASEDEMO_ROW_COUNT} -gt ${UNIQUE_ALL_CASEDEMO_COMP_ROW_COUNT} ]
then
    comp_cnt=${UNIQUE_ALL_CASEDEMO_COMP_ROW_COUNT}
	cnt=${UNIQUE_ALL_CASEDEMO_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${UNIQUE_ALL_CASEDEMO_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${UNIQUE_ALL_CASEDEMO_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "UNIQUE_ALL_CASEDEMO_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'UNIQUE_ALL_CASE_ROW_COUNT' >> $log_location
echo ${UNIQUE_ALL_CASE_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${UNIQUE_ALL_CASE_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${UNIQUE_ALL_CASE_ROW_COUNT} -lt ${UNIQUE_ALL_CASE_COMP_ROW_COUNT} ]
then
	comp_cnt=${UNIQUE_ALL_CASE_COMP_ROW_COUNT}
	cnt=${UNIQUE_ALL_CASE_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${UNIQUE_ALL_CASE_ROW_COUNT} -gt ${UNIQUE_ALL_CASE_COMP_ROW_COUNT} ]
then
    comp_cnt=${UNIQUE_ALL_CASE_COMP_ROW_COUNT}
	cnt=${UNIQUE_ALL_CASE_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${UNIQUE_ALL_CASE_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${UNIQUE_ALL_CASE_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "UNIQUE_ALL_CASE_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_DRUG_OUTCOME_STATISTICS_ROW_COUNT' >> $log_location
echo ${STANDARD_DRUG_OUTCOME_STATISTICS_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_DRUG_OUTCOME_STATISTICS_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_DRUG_OUTCOME_STATISTICS_ROW_COUNT} -lt ${STANDARD_DRUG_OUTCOME_STATISTICS_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_DRUG_OUTCOME_STATISTICS_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_STATISTICS_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_STATISTICS_ROW_COUNT} -gt ${STANDARD_DRUG_OUTCOME_STATISTICS_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_DRUG_OUTCOME_STATISTICS_COMP_ROW_COUNT}
	cnt=${STANDARD_DRUG_OUTCOME_STATISTICS_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_STATISTICS_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_DRUG_OUTCOME_STATISTICS_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_DRUG_OUTCOME_STATISTICS_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_COMBINED_DRUG_MAPPING_ROW_COUNT' >> $log_location
echo ${STANDARD_COMBINED_DRUG_MAPPING_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_COMBINED_DRUG_MAPPING_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_COMBINED_DRUG_MAPPING_ROW_COUNT} -lt ${STANDARD_COMBINED_DRUG_MAPPING_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_COMBINED_DRUG_MAPPING_COMP_ROW_COUNT}
	cnt=${STANDARD_COMBINED_DRUG_MAPPING_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_COMBINED_DRUG_MAPPING_ROW_COUNT} -gt ${STANDARD_COMBINED_DRUG_MAPPING_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_COMBINED_DRUG_MAPPING_COMP_ROW_COUNT}
	cnt=${STANDARD_COMBINED_DRUG_MAPPING_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_COMBINED_DRUG_MAPPING_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_COMBINED_DRUG_MAPPING_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_COMBINED_DRUG_MAPPING_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location



echo 'STANDARD_CASE_DRUG_ROW_COUNT' >> $log_location
echo ${STANDARD_CASE_DRUG_ROW_COUNT} "<- " ${DATABASE_NAME}  >> $log_location
echo ${STANDARD_CASE_DRUG_COMP_ROW_COUNT} "<- " ${DATABASE_COMPARISON_NAME} >> $log_location
if [ ${STANDARD_CASE_DRUG_ROW_COUNT} -lt ${STANDARD_CASE_DRUG_COMP_ROW_COUNT} ]
then
	comp_cnt=${STANDARD_CASE_DRUG_COMP_ROW_COUNT}
	cnt=${STANDARD_CASE_DRUG_ROW_COUNT}
    echo $comp_cnt
    echo $cnt
	missing_count=$(($comp_cnt-$cnt))
	echo $missing_count " MISSING"
	echo $missing_count " MISSING"  >> $log_location
elif [ ${STANDARD_CASE_DRUG_ROW_COUNT} -gt ${STANDARD_CASE_DRUG_COMP_ROW_COUNT} ]
then
    comp_cnt=${STANDARD_CASE_DRUG_COMP_ROW_COUNT}
	cnt=${STANDARD_CASE_DRUG_ROW_COUNT}
    missing_count=$(($cnt-$comp_cnt))
	echo $missing_count " EXTRA"  >> $log_location
elif [ ${STANDARD_CASE_DRUG_ROW_COUNT} -eq 0 ]
then
    echo "TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)"  >> $log_location
elif [ ${STANDARD_CASE_DRUG_COMP_ROW_COUNT} -eq 0 ]
then
     echo 'TABLES EMPTY PLEASE INVESTIGATE; (did stage_3 run?)'  >> $log_location
else
    echo "STANDARD_CASE_DRUG_ROW_COUNT PERFECTO!!!"  >> $log_location
fi
printf '\n' >> $log_location
printf '\n' >> $log_location


echo "#######################################################" >> $log_location
echo "################ STAGE 6 COMPLETE #####################" >> $log_location
echo "#######################################################" >> $log_location

