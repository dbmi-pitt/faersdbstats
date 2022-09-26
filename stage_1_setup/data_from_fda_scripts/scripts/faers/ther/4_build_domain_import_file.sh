#!/bin/bash

# local var config

thispwd=`pwd`
echo $thispwd
echo pwd isssss `pwd`
thisdomain=${thispwd: -4}
echo assuming domain is $thisdomain

#for adding empty columns gets run on from domain level directory
source ../../../../faers_config.config
cd ${BASE_FILE_DIR}/faersdbstats_data/data_meta
# cd ${BASE_FILE_DIR}/data_from_s3/laers/indi/

echo pwd now is `pwd`
# exit;

# aws s3 sync . s3://napdi-cem-sandbox-files/data/faers/indi/ --include "*" --exclude "*only.txt"

#set and echo globstar settings for ** used
shopt -s globstar

#blow out old staged files for guess and checking
# for file in ./**/*_new_header.txt; do
#     echo 'about to rm '"$file"
#     rm $file
# done;

#specific quarter(s)
# for file in ./2014/Q1/*.txt ./2014/Q2/*.txt ; do

#for entire year 
# for file in ./2014/**/*.txt; do
# if [ "${LOAD_ALL_TIME}" = 1 ]; then
# mkdir -p ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/
#     #download s3://..data to local/data_from_s3
#     echo LOAD_ALL_TIME is 1
    
#     #s3 download if REBUILD_ALL_TIME_DATA_LOCALLY=1 or data_from_s3 does not exist locally
#     if [ "${REBUILD_ALL_TIME_DATA_LOCALLY}" = 1 ] || [ ! -d "${BASE_FILE_DIR}/data_from_s3" ]; then
#         echo data should exist in ${BASE_FILE_DIR}/data_from_s3/
#         aws s3 cp s3://napdi-cem-sandbox-files/data/ ${BASE_FILE_DIR}/data_from_s3/ --recursive --exclude "*" --include "*.txt" --exclude "*old.txt" 
#     else
#         echo data should exist in ${BASE_FILE_DIR}/data_from_s3/
#     fi

    data_from_s3_root_above_laers_or_faers=`pwd`;

if [ "${LOAD_ALL_TIME}" = 1 ]; then
    # mkdir -p ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/
        #download s3://..data to local/data_from_s3
        echo LOAD_ALL_TIME is 1
        headempty=0
    # for name in ./2012/**/*Q4.txt; do
    # for name in ./2013/**/*.txt; do
    # for name in ./2014/**/*Q1.txt ./2014/**/*Q2.txt; do #just one file 2014 *Q2.txt
    for laers_faers in faers; do # faers; do
        cd $data_from_s3_root_above_laers_or_faers/$laers_faers
        # for year in 2004 2005; do
        # for name in ./2004/**/*.txt ./2005/**/*Q1.txt ./2005/**/*Q2.txt; do
        headempty=0
        for domain in $thisdomain; do
            # for year in 2004; do # just 2004
            # for year in 2004 2005 2006 2007 2008 2009 2010 2011 2012; do 
            for year in 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022; do  #makes data enter domain file in chronological order
            # for year in 2013; do 
            echo pwd in year loop is      `pwd`
                for name in ./$domain/$year/**/*Q1_with_data.txt ./$domain/$year/**/*Q2_with_data.txt ./$domain/$year/**/*Q3_with_data.txt ./$domain/$year/**/*Q4_with_data.txt; do #all quarters needed

                    # for name in ./2004/**/*.txt ./2005/**/*Q1.txt ; do #for not 05 q2 but others needed

                    # for name in ./2004/**/*.txt ./2005/**/*Q2.txt; do
                    # for name in ./2005/**/*Q1.txt; do
                    # for name in ./2005/**/*Q2.txt; do
                    # echo ${name} length of ${#name}

                    if [ ${#name} -eq 37 ]; then
                        echo $name is 37 chars long lets gooooooooo
                        domain=${name:2:4}
                        # year=${name:7:4}
                        yr=${name:9:2}
                        quarter=${name:12:2}
                        qtr=${name:13:1}
                        echo $laers_faers - $domain - $year - $quarter aka - $yr $qtr
                        # echo 'year is ' $year
                        # echo 'yr is ' $yr
                        domain_uc=${name:2:4} #domain upper case
                        #make domain lower case
                        domain=${domain_uc,,}
                                echo 'name is' $name
                                echo 'domain is' $domain
                            # if [ "${#name}" -eq 22 ]; then 
                            #     echo '22 long name is' $name
                            #     pathtoname=${name: 0:9}
                            #     #if bak does not exist create it
                            #     if [ ! -f ${name:0:12}_bak.txt ]; then
                            #         cp $name ${name:0:12}_bak.txt
                            #         echo 'just made '${name:0:12}_bak.txt
                            #     else
                            #         echo ${name:0:12}_bak.txt' already exists; will check for old.txt'
                            #         # $possible_old_loc=
                            #         echo ${pathtoname}'/old.txt'
                            #         if [ -f ${pathtoname}/old.txt ]; then
                            #             echo 'old.txt exists will copy into'$name
                            #             cp ${pathtoname}/old.txt $name
                            #         else
                            #             echo `pwd`
                            #             echo 'old.txt DID NOT exists will copy into'$name
                            #             cp ${name:0:12}_bak.txt $name
                            #         fi
                            #     fi

                                #replace 5th $ with $$ put into *.txt (chopping off name's .txt w/ -4)
                                # sed 's/\$/\$\$/5' $name > "${name::-4}".txt
                                # tr -d '\015' <$name >"${name}"_staged_with_lfs_only.txt

                                #add empty last column at end of each line by adding 22nd $
                                # sed -i 's/\$/\$\$/22' $name        
                                #           \   \      \
                                # escaped $ n $$   replace 22nd one
                            echo 'pwd for report would be '`pwd`
                            #  report
                            firstline=$(head -1 $name) #kind of a duplicate of the compare_every_files_header.sh
                            # echo $firstline >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}.txt #kind of a duplicate of the compare_every_files_header.sh
                            # if 1st line header line of domain.txt has not been created
                                if [ $headempty = 0 ]; then
                                    #build out header (1st line of txt file)
                                    echo '$headempty is '$headempty
                                    echo 'head -1 is ' `head -1 ${name}`
                                    header="$(head -1 --quiet ${name})"                                   
                                    
                                    #remove \r
                                    header="${header%%[[:cntrl:]]}"
                                    echo $header
                                    echo $header > $domain/${domain}.txt
                                    echo "${domain}.txt" is the domain.txt
                                    
                                    #headers we want
                                    #primaryid$caseid$indi_seq$role_cod$CONFID$prod_ai$val_vbm$route$dose_vbm$cum_dose_chr$cum_dose_unit$dechal$rechal$lot_num$exp_dt$nda_num$dose_amt$dose_unit$dose_form$dose_freq
                                    headempty=1 &&
                                    #tail outputs last -n+2 lines of a file (shows all lines of report from the second line onwards) # --quiet does not output the filename                    
                                    tail -n +2 --quiet ${name} >> $domain/$domain.txt
                                else #else on headempty = 0; so headempty not 0
                                    echo '$headempty is '$headempty
                                    next_header="$(head -1 --quiet ${name})"
                                    
                                    if [ ! $header == $next_header ]; then
                                        echo pwd is `pwd`
                                        echo domain is $domain
                                        echo 'header '
                                        echo $header
                                        echo 'does not match'
                                        echo 'see 4_fail_log.txt'
                                        echo $next_header
                                        echo $header > 4_fail_log.txt
                                        echo $next_header >> 4_fail_log.txt
                                        exit;
                                    else
                                    #tail outputs last -n+2 lines of a file (shows all lines of report from the second line onwards) # --quiet does not output the filename
                                    tail -n +2 --quiet ${name} >> $domain/$domain.txt
                                    fi

                                fi #end if [ $headempty = 0 ]; then

                                #make a sm.txt file that has only 20 lines to check results
                                # sed '20,$ d' $name > "${name:0:10}"sm.txt
                    else
                        echo SKIPPED $name not equal to 27 chars long its ${#name}
                    fi #end name length
                done; #end .txt file loop aka qtr loop
            done; #end year loop
            #reset headempty for next domain

            #replace null chars w/ space
            sed -i 's/\x0/ /g' $domain/${domain}.txt
            head < $domain/${domain}.txt > $thispwd/${domain}_head_n_tail.txt
            tail < $domain/${domain}.txt >> $thispwd/${domain}_head_n_tail.txt
            
            #uppercase filename
            sed -i 's/indi12q4.txt/INDI12q4.txt/g' indi.txt
            
            
            echo `wc -l $domain/${domain}.txt`
            cd $data_from_s3_root_above_laers_or_faers
        done; #end domain loop
    
     done; #end laers_faers loop
            headempty=0
    else
        echo 'you must be looking to load one quarter of data'
        # done; #end domain loop
fi #LOAD_ALL_TIME = 1

echo 'if you would like to compare against a previous import file run head and compare against '$domain'_head.txt '

echo ' after ensuring '$domain'.txt import file is in the correct location check the preview step for this domain in stage 3'

# echo 'this script should have taken *_staged_with_lfs_only.txt in data_from_s3/laers/indi/**/ (quarter folders) and added a 23th column and then added to the header REPORTER_COUNTRY after $CONFID ';
# DEMO14Q1_staged_with_lfs_only.txt
# ^this is 44 characters so you change ./s3_data_download.sh to -gt 40 to only build indi.txt from this scripts output
