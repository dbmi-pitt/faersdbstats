#!/bin/bash

# move this script to ${BASE_FILE_DIR}/data_from_s3/faers/${thisdomain}

#rebuilds ${thisdomain} domain data files for '12 Q4, all '13, and '14 Q1 and Q2

#use this to add columns after ./s3_data_download.sh (stage 2) has been run to check tweaks locally
thispwd=`pwd`
echo $thispwd
echo pwd isssss `pwd`
thisdomain=${thispwd: -4}
echo assuming domain is $thisdomain
#for adding empty columns gets run on from domain level directory
# source ../../faers_config.config
# cd ${BASE_FILE_DIR}/faersdbstats_data/data_3_sync_columns/laers/${thisdomain}/
# workpwd=${BASE_FILE_DIR}/faersdbstats_data/data_3_sync_columns/laers/${thisdomain}/
# echo pwd now is `pwd`
# exit;
# example workflow:
# _x_ 1. run *stage_2*/s3_data_download.sh - build out *_staged_with_lfs_only.txt (adds filename qtr yr)
# _x_ 2. run *domain*/add_col.sh - <adds col (back into _staged_with_lfs_only.txt)
# ___ 3. run *stage_2*./s3_data_download_after_add_col.sh on(_staged_with_lfs_only.txt)
# # ___ 4. run sed '0/$DEMO12Q4.txt$4$12$filename$yr$qtr/$filename$yr$qtr' ${thisdomain}.txt

# aws s3 sync . s3://${AWS_S3_BUCKET_NAME}/data/faers/${thisdomain}/ --include "*" --exclude "*only.txt"

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

# for name in ./2012/**/*Q4.txt; do
# for name in ./2013/**/*.txt; do
# for name in ./2014/**/*Q1.txt ./2014/**/*Q2.txt; do #just one file 2014 *Q2.txt
# for name in ./2004/**/*.txt ./2005/**/*Q1.txt ./2005/**/*Q2.txt; do

# echo 'set for all quarters needing additional columns 04 05Q1 n 05Q2'
# for name in ./2012/**/*Q4.txt ./2013/**/*.txt ./2014/**/*Q1.txt ./2014/**/*Q2.txt; do #all quarters needed

# for name in ./2004/**/*.txt ./2005/**/*Q1.txt ; do #for not 05 q2 but others needed
# for name in ./2004/**/*.txt ./2005/**/*Q2.txt; do
# for name in ./2005/**/*Q1.txt; do
# for name in ./2005/**/*Q2.txt; do

echo 'set for 12 q4'
# for name in ./2012/**/*Q4.txt ; do #just 2012 to test
for name in ./2012/**/*Q4.txt ./2013/**/*.txt ./2014/**/*Q1.txt  ./2014/**/*Q2.txt ; do #trouble area

# for name in ./2005/**/*Q3.txt; do
        echo 'name is' $name
    if [ "${#name}" -eq 22 ]; then 
        echo '22 long name is' $name
        pathtoname=${name: 0:9}
        #if bak does not exist create it
        if [ ! -f ${name:0:12}_bak.txt ]; then
            cp $name ${name:0:12}_bak.txt
            echo 'just made '${name:0:12}_bak.txt
        else
            echo ${name:0:12}_bak.txt' already exists; will check for old.txt'
            # $possible_old_loc=
            echo ${pathtoname}'/old.txt'
            # if old restore it
            if [ -f ${pathtoname}/old.txt ]; then
                echo 'old.txt exists will copy into'$name
                cp ${pathtoname}/old.txt $name
            else
                echo `pwd`
                echo 'old.txt DID NOT exists will copy *_bak.txt into'$name
                cp ${name:0:12}_bak.txt $name
            fi
        fi

        #replace 5th $ with $$ put into *.txt (chopping off name's .txt w/ -4)
        # sed 's/\$/\$\$/5' $name > "${name::-4}".txt
        tr -d '\015' <$name >"${name::-4}"_staged_with_lfs_only.txt

        #add empty last column at end of each line by adding 22nd $
        # sed -i 's/\$/\$\$/21' $name
        echo about to sed on $name
        echo output to  ${name::-4}_added_empty_col.txt
        sed 's/$/\$/g' < ${name::-4}_staged_with_lfs_only.txt > ${name::-4}_added_empty_col.txt
        #           \   \      \
           # escaped $ n $$$$   replace 21st one
    
        #build out header (1st line of txt file)
        # header="$(head -1 --quiet "${name::-4}".txt)"
        
        #remove \r
        # header="${header%%[[:cntrl:]]}"
        
        #headers we want
        #primaryid$caseid$${thisdomain}_seq$role_cod$CONFID$prod_ai$val_vbm$route$dose_vbm$cum_dose_chr$cum_dose_unit$dechal$rechal$lot_num$exp_dt$nda_num$dose_amt$dose_unit$dose_form$dose_freq

        # sed -i 's/\$CONFID/\$CONFID\$REPORTER_COUNTRY/g' $name
        
        #the last \$ will create an empty column to before last 3 columns
        # sed -i 's/\$\$\$\$\$CONFID/\$\$CONFID\$\$REPORTER_COUNTRY\$/g' $name
        #replace first occurence only to ensure it's the header
        sed '0,/\$pt\$/{s/\$pt\$/\$pt\$drug_rec_act/}' < ${name::-4}_added_empty_col.txt > ${name::-4}_added_new_header.txt
            #  sed 's/CONFID/CONFID\$REPORTER_COUNTRY/g' < $name > ${name::-4}_fixed.txt
        # sed -i 's/\$pt\$\$val_vbm/\$pt\$prod_ai\$val_vbm/g' $name
        cp ${name::-4}_added_new_header.txt $name

        #make a sm.txt file that has only 20 lines to check results
        sed '20,$ d' $name > "${name:10:2}"sm.txt
        echo $name >> headers.txt
        sed '1,$ d' $name >> headers.txt
        else
        echo SKIPPED $name not equal to 22 chars long
        fi
echo ' '
echo `head -3 $name`
done;
echo ' '

../.././f2_report_generator.sh

# echo '' > header_report_all_files.txt

# for file in ./**/**/*.txt; do
#     if [ "${#file}" -eq 22 ]; then
#         echo $file is 22 long
#         echo $file >> header_report_all_files.txt
#         # sed '2,$ d' < $file >> header_report_all_files.txt
#         #output first 2 lines to a file
#         head -2 $file >> header_report_all_files.txt
#         echo ' ' >> header_report_all_files.txt
#         echo ' ' >> header_report_all_files.txt
#     else
#         # echo SKIMPPED $file is ${#file} long
#     fi
# done;

# echo 'check the headers.txt file in each domains folder' 
# echo 'and the header_report_all_files.txt file in each domains folder in ' 
echo 'compare data_2 04Q1 with data_3 04Q1'
echo $workpwd
# echo 'this script should have taken *_staged_with_lfs_only.txt in data_from_s3/laers/${thisdomain}/**/ (quarter folders) and added a 23th column and then added to the header REPORTER_COUNTRY after $CONFID ';
# DEMO14Q1_staged_with_lfs_only.txt
# ^this is 44 characters so you change ./s3_data_download.sh to -gt 40 to only build ${thisdomain}.txt from this scripts output
echo 'this script should have taken *.txt in ./faers/demo/**/ (quarter folders) and added a 9th 12 and 15th column and auth_num and lit_ref and age_grp respectively'
echo ' '
echo 'can copy text easily from sm.txt in the qtr folder and paste above 14 Q3 in first_2_lines_report.txt to check vertical alignment' 