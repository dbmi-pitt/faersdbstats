#!/bin/bash

# shopt -s globstar

# for name in ./2005/**/*.txt; do

# # sed -i '151,$ d' $name

# # head $name
# echo $name

# done;


#!/bin/bash

# move this script to ${BASE_FILE_DIR}/data_from_s3/faers/demo

#rebuilds demo domain data files for '12 Q4, all '13, and '14 Q1 and Q2

#use this to add columns after ./s3_data_download.sh (stage 2) has been run to check tweaks locally


#for adding empty columns gets run on from domain level directory
source ../../faers_config.config
scripts_pwd=`pwd`
echo scripts_pwd is `pwd`
# cd pathtogoto

# echo pwd now is `pwd`
# example workflow:
# _x_ 1. run *stage_2*/s3_data_download.sh - build out *_staged_with_lfs_only.txt (adds filename qtr yr)
# _x_ 2. run *domain*/add_col.sh - <adds col (back into _staged_with_lfs_only.txt)
# ___ 3. run *stage_2*./s3_data_download_after_add_col.sh on(_staged_with_lfs_only.txt)
# ___ 4. run sed '0/$DEMO12Q4.txt$4$12$filename$yr$qtr/$filename$yr$qtr' demo.txt

# aws s3 sync . s3://${AWS_S3_BUCKET_NAME}/data/faers/demo/ --include "*" --exclude "*only.txt"

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
# for name in ./2004/**/*.txt ./2005/**/*Q1.txt ./2005/**/*Q2.txt; do #all quarters needed
# for name in ./2004/**/*.txt ./2005/**/*Q1.txt ; do #for not 05 q2 but others needed
# for name in ./2004/**/*.txt ./2005/**/*Q2.txt; do
# for name in ./2005/**/*Q1.txt; do
# for name in ./2005/**/*Q2.txt; do
# for name in ./2012/**/*Q4.txt; do #build small first
for name in ./2012/**/*Q4.txt ./2013/**/*.txt ./2014/**/*Q1.txt ./2014/**/*Q2.txt; do #
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
                echo 'old.txt DID NOT exists will copy into'$name
                cp ${name:0:12}_bak.txt $name
            fi
        fi

        #replace 5th $ with $$ put into *.txt (chopping off name's .txt w/ -4)
        # sed 's/\$/\$\$/5' $name > "${name::-4}".txt
        # tr -d '\015' <$name >"${name}"_staged_with_lfs_only.txt

        #add empty last column at end of each line by adding 22nd $
        # sed -i 's/\$/\$\$/22' $name        
        #           \   \      \
           # escaped $ n $$   replace 22nd one

        #add 8th empty col
        sed -i 's/\$/\$\$/9' $name        
        #           \   \      \
        #    escaped $ n $$   replace 22nd one

        #add 10th
        sed -i 's/\$/\$\$/12' $name        
        #           \   \      \
           # escaped $ n $$   replace 22nd one

        #add 14th
        sed -i 's/\$/\$\$/15' $name        
        #           \   \      \
           # escaped $ n $$   replace 22nd one
    
        #build out header (1st line of txt file)
        # header="$(head -1 --quiet "${name::-4}".txt)"
        
        #remove \r
        # header="${header%%[[:cntrl:]]}"
        
        #headers we want
        #primaryid$caseid$demo_seq$role_cod$CONFID$prod_ai$val_vbm$route$dose_vbm$cum_dose_chr$cum_dose_unit$dechal$rechal$lot_num$exp_dt$nda_num$dose_amt$dose_unit$dose_form$dose_freq

        # sed -i 's/\$CONFID/\$CONFID\$REPORTER_COUNTRY/g' $name

        #create auth_num header
         sed -i 's/\$rept_cod\$/\$rept_cod\$auth_num/g' $name

        # #create lit_ref header
        sed -i 's/\$mfr_sndr\$/\$mfr_sndr\$lit_ref/g' $name

        # #create age_grp header
        sed -i 's/\$age_cod\$/\$age_cod\$age_grp/g' $name

        #make a sm.txt file that has only 20 lines to check results
        sed '20,$ d' $name > "${name:0:10}"sm.txt
        else
        echo SKIPPED $name not equal to 22 chars long
        fi
echo ' '
echo `head -3 $name`
done;
echo ' '

echo 'this script should have taken *.txt in ./faers/demo/**/ (quarter folders) and added a 9th 12 and 15th column and auth_num and lit_ref and age_grp respectively'
echo ' '
echo 'can copy text easily from sm.txt in the qtr folder and paste above 14 Q3 in first_2_lines_report.txt to check vertical alignment' 