#!/bin/bash

# built from data_4/add_filename_yr_qtr.sh

# move this script to ${BASE_FIL_DIR}/data_from_s3/faers/drug

# laers drug comes w/ good column alignment, except the data sections of all files have a trailing $ which spaces line appended data out (chosen solution is to remove the 12th $)

#use this to add columns after ./s3_data_download.sh (stage 2) has been run to check tweaks locally

echo pwd is `pwd`

#for adding empty columns gets run on from domain level directory
# source ../../faers_config.config
# cd ${BASE_FILE_DIR}/faersdbstats_data/data_4_add_filename_yr_qtr/laers/demo/

# echo pwd now is `pwd`
# exit;
# example workflow:
# _x_ 1. run *stage_2*/s3_data_download.sh - build out *_staged_with_lfs_only.txt (adds filename qtr yr)
# _x_ 2. run *domain*/add_col.sh - <adds col (back into _staged_with_lfs_only.txt)
# ___ 3. run *stage_2*./s3_data_download_after_add_col.sh on(_staged_with_lfs_only.txt)
# ___ 4. run sed '0/$DEMO12Q4.txt$4$12$filename$yr$qtr/$filename$yr$qtr' demo.txt

# aws s3 sync . s3://napdi-cem-sandbox-files/data/faers/demo/ --include "*" --exclude "*only.txt"

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

#all time
for name in ./**/*Q1.txt ./**/*Q2.txt ./**/*Q3.txt ./**/*Q4.txt; do #all time

# for name in ./2012/**/*Q4.txt; do
# for name in ./2013/**/*.txt; do
# for name in ./2014/**/*Q1.txt ./2014/**/*Q2.txt; do #just one file 2014 *Q2.txt
# for name in ./2004/**/*.txt ./2005/**/*Q1.txt ./2005/**/*Q2.txt; do
# for name in ./2004/**/*.txt ./2005/**/*Q1.txt ./2005/**/*Q2.txt; do #all quarters needed
# for name in ./2004/**/*.txt ./2005/**/*Q1.txt ; do #for not 05 q2 but others needed
# for name in ./2004/**/*.txt ./2005/**/*Q2.txt; do
# for name in ./2004/**/*Q1.txt  ./2004/**/*Q2.txt  ./2004/**/*Q3.txt  ./2004/**/*Q4.txt ./2005/**/*Q1.txt ./2005/**/*Q2.txt ./2005/**/*Q3.txt ./2005/**/*Q4.txt; do
# for name in ./2005/**/*Q1.txt; do #one qtr
# for name in ./2006/**/*Q1.txt; do
# for name in ./2012/**/*Q2.txt; do
# for name in ./2012/**/*Q2.txt; do
# for name in ./2005/**/*Q3.txt; do
# for name in ./2005/**/*Q3.txt ./2005/**/*Q4.txt; do
# for name in ./2011/**/*Q4.txt; do
        echo 'name is' $name
        echo '#name is' ${#name}
    if [ "${#name}" -eq 22 ]; then 
        echo '22 long name is' $name
        thefilename=${name:10}
        thefilenamebase=${name:15:8}
        year='$'${name:4:2}
        qtr='$'${name:8:1}
        thefilenamedata='$'"${thefilename}""$year""$qtr"
        echo '$thefilenamedata is '$thefilenamedata

        tr -d '\015' < $name > "${name::-4}"_staged_with_lfs_only.txt

        #remove trailing data $ by replacing with nothing
         sed -i 's/\$//12' "${name::-4}"_staged_with_lfs_only.txt        
        #           \   \
        #    escaped $   replace 12th one

        sed -i "s|$|$thefilenamedata|g" "${name::-4}"_staged_with_lfs_only.txt
        echo 'the filename is '$thefilename
        pathtoname=${name: 0:9}
        # if bak does not exist create it
        if [ ! -f ${name:0:12}_bak.txt ]; then
            cp $name ${name:0:12}_bak.txt
            echo 'just made '${name:0:12}_bak.txt
        else
            echo ${name:0:12}_bak.txt' already exists; will check for old.txt'
            # $possible_old_loc=
            echo ${pathtoname}'/old.txt'
            if [ -f ${pathtoname}/old.txt ]; then
                echo 'old.txt exists will copy into'$name
                cp ${pathtoname}/old.txt $name
            else
                echo `pwd`
                echo 'old.txt DID NOT exists will copy into'$name
                cp ${name:0:12}_bak.txt $name
            fi
        # replace first occurence of $thefilenamedata to fix the header
        sed -i "0,/$thefilenamedata/{s/$thefilenamedata/\$filename\$yr\$qtr/}" "${name::-4}"_staged_with_lfs_only.txt
        fi

        #replace 5th $ with $$ put into *.txt (chopping off name's .txt w/ -4)
        # sed 's/\$/\$\$/5' $name > "${name::-4}".txt
        # tr -d '\015' <$name >"${name}"_staged_with_lfs_only.txt


    
    
        #build out header (1st line of txt file)
        # header="$(head -1 --quiet "${name::-4}".txt)"
        
        #remove \r
        # header="${header%%[[:cntrl:]]}"
        
        #headers we want
        #primaryid$caseid$demo_seq$role_cod$CONFID$prod_ai$val_vbm$route$dose_vbm$cum_dose_chr$cum_dose_unit$dechal$rechal$lot_num$exp_dt$nda_num$dose_amt$dose_unit$dose_form$dose_freq


        # #make a sm.txt file that has only 20 lines to check results
        # sed '20,$ d' $name > "${name:0:10}"sm.txt
        else
        echo SKIPPED $name not equal to 22 chars long
    fi
done;

# echo 'this script should have taken *_staged_with_lfs_only.txt in data_from_s3/laers/demo/**/ (quarter folders) and added a 23th column and then added to the header REPORTER_COUNTRY after $CONFID ';
# DEMO14Q1_staged_with_lfs_only.txt
# ^this is 44 characters so you change ./s3_data_download.sh to -gt 40 to only build demo.txt from this scripts output

# echo 'attempting to run ./1_first_2_lines_report_generator.sh for you'
# libreoffice --calc first_2_lines_report.txt