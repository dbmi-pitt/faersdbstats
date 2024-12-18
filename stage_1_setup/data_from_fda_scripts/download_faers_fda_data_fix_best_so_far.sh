#!/bin/bash
# /home/pentaho-secondary/projects-brb265-2024/faersdbstats/faersdbstats/stage_1_setup/faersdbstats_data_test_scripts/download_faers_fda_data_fix.sh

# Uncomment source to debug from command line
# source ../faers_config.config
source ../../../faers_config.config

# cat ../../../faers_config.config

# echo "/n"
echo "DATABASE_BACKUP_LOCATION is :$DATABASE_BACKUP_LOCATION"

# Set and echo globstar settings for ** used
shopt -s globstar 
shopt globstar
    if [ ! -d ${DATABASE_BACKUP_LOCATION}/faersdbstats_data_test ]; then
        mkdir -p ${DATABASE_BACKUP_LOCATION}/faersdbstats_data_test
    fi
    cd ${DATABASE_BACKUP_LOCATION}/faersdbstats_data_test/
    dir_above_laers_or_faers=$(pwd)
# for laers_faers in laers faers; do 
for laers_faers in faers; do 
    mkdir -p $dir_above_laers_or_faers/$laers_faers

    cd $dir_above_laers_or_faers/$laers_faers

    # for domain in demo drug indi; do #outc reac rpsr ther; do
    for domain in demo drug indi outc reac rpsr ther; do
    # for domain in rpsr; do
        mkdir -p $dir_above_laers_or_faers/$laers_faers/$domain

        cd $dir_above_laers_or_faers/$laers_faers/$domain
        # for THIS_YEAR in 2004 2005 2006 2007 2008 2009 2010 2011 2012; do
        for THIS_YEAR in 2022; do
            # for THIS_QUARTER in Q1 Q2 Q3 Q4; do
            for THIS_QUARTER in Q3; do
                echo $laers_faers - $domain - ${THIS_YEAR} - ${THIS_QUARTER}
                LOAD_NEW_YEAR=$THIS_YEAR
                LOAD_NEW_QUARTER=$THIS_QUARTER
                qtr_num=${LOAD_NEW_QUARTER: 1}
                THIS_QUARTER_num=${THIS_QUARTER: 1}
                # echo 'THIS_QUARTER is '$THIS_QUARTER

                # LOAD_NEW_YEAR=2004
                mkdir -p ${LOAD_NEW_YEAR}'/Q'${qtr_num}
                # echo 'LOAD_NEW_QUARTER is '$LOAD_NEW_QUARTER
                # THIS_QUARTER=$LOAD_NEW_QUARTER
                LOAD_NEW_QUARTER=$THIS_QUARTER
                # echo ${LOAD_NEW_YEAR:-2}

                # echo ${LOAD_NEW_QUARTER}
                fileyearquarter="${LOAD_NEW_YEAR:-2}${LOAD_NEW_QUARTER}"


                # mkdir -p og/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}/
                # mkdir -p og/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}_downloads

                # cd og/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}_downloads/                
                # echo ${LOAD_NEW_QUARTER: 1}
                # echo ${qtr_num}
                # echo `pwd`
                # zip_url=https://fis.fda.gov/content/Exports/aers_ascii_2005q1.zip
                echo 'https://fis.fda.gov/content/Exports/faers_ascii_'${LOAD_NEW_YEAR}'q'${THIS_QUARTER_num}'.zip'
                zip_url='https://fis.fda.gov/content/Exports/faers_ascii_'${LOAD_NEW_YEAR}'q'${THIS_QUARTER_num}'.zip'
                echo will wget this $zip_url
                #download data -P = to specific dir faersdbstats_data_test
                #skip 12 Q4
                # if [ "$THIS_YEAR" != '2012' ] && [ "$THIS_QUARTER" != 'Q4' ]; then
                    # wget $zip_url --no-clobber -P ${dir_above_laers_or_faers}/faersdbstats_data_test 2>&1
                # else 
                #     echo 'Skipping 2012 Q4 as instructed'
                # fi
                # if [ ! -d ascii ]; then
                #   mkdir ascii
                # fi
                if [ ! -d $dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/${THIS_QUARTER} ]; then
                    mkdir -p $dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/${THIS_QUARTER}
                fi
                zip_filename_loc=$dir_above_laers_or_faers/'faers_ascii_'${THIS_YEAR}'q'${qtr_num}'.zip'
                #unzip -n = no overwrite
                unzip -n $zip_filename_loc -d $dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/${THIS_QUARTER} 2>> error.txt 1>> output.txt
                if [ -f $dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/${THIS_QUARTER}/ascii/${domain^^}${THIS_YEAR:2}${THIS_QUARTER}.TXT ]; then
                    mv  $dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/${THIS_QUARTER}/ascii/${domain^^}${THIS_YEAR:2}${THIS_QUARTER}.TXT $dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/${THIS_QUARTER}/${domain^^}${THIS_YEAR:2}${THIS_QUARTER}.txt
                fi
                # if [ -f $dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/${THIS_QUARTER}/ascii/${domain^^}${THIS_YEAR:2}Q${THIS_QUARTER}.txt ]; then
                #     mv  $dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/${THIS_QUARTER}/ascii/${domain^^}${THIS_YEAR:2}Q${THIS_QUARTER}.txt $dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/Q${THIS_QUARTER}/${domain^^}${THIS_YEAR:2}${THIS_QUARTER}.txt
                # fi
                # if [ -f ${dir_above_laers_or_faers}/faersdbstats_data_test/ascii/DEMO${LOAD_NEW_YEAR}q${LOAD_NEW_QUARTER}.txt ]; then
                #     mv ${dir_above_laers_or_faers}/faersdbstats_data_test/ascii/DEMO${LOAD_NEW_YEAR:2}${LOAD_NEW_QUARTER}.txt ascii/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}/DEMO${LOAD_NEW_YEAR:2}${LOAD_NEW_QUARTER}.txt
                # fi
                # echo 'about to check if this exists - ' ${dir_above_laers_or_faers}/faersdbstats_data_test/ASCII/ASC_NTS.pdf ascii/${THIS_YEAR}/${THIS_QUARTER}/ASC_NTS${fileyearquarter}.pdf
                if [ -f ${dir_above_laers_or_faers}/faersdbstats_data_test/ASCII/ASC_NTS.pdf ]; then
                    mv ${dir_above_laers_or_faers}/faersdbstats_data_test/ASCII/ASC_NTS.pdf ascii/${THIS_YEAR}/${LOAD_NEW_QUARTER}/ASC_NTS${fileyearquarter}.pdf
                fi
            done; #end quarter loop
        cd $dir_above_laers_or_faers/$laers_faers/$domain
        done; #end year loop
        cd $dir_above_laers_or_faers/$laers_faers
        done; #end domain loop
    cd $dir_above_laers_or_faers;
done; #end laers_faers loop