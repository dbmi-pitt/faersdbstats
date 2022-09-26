#!/bin/bash

# built from data_4/add_filename_yr_qtr.sh

# this script should be in ${BASE_FIL_DIR}/faersdbstats_data/data_meta/
# move output of this script to ${BASE_FIL_DIR}/data_from_s3/$laers_faers/$domain

#rebuilds $domain data files for '12 Q4, all '13, and '14 Q1 and Q2

##local config vars
$laers_faers=laers
$domain=drug

echo pwd is `pwd`

# source ../../faers_config.config
# cd ${BASE_FILE_DIR}/faersdbstats_data/data_meta/$laers_faers/$domain

echo pwd now is `pwd`
# exit;

# example workflow:
# Big Step one
# _x_ A. make sure .txt not .TXT
# _x_ B. remove crlf line endings and make lfs
# _x_ C. sync columns (*_cols_syncd.txt) (run ./first_2_lines_report_generator.sh to see alignment)

# Big Step two
# ___ 4. add filename_yr_qtr (*_with_data.txt)
# Big Step three?
# ___ 5. make import_file ($domain/$domain.txt)

# aws s3 sync . s3://napdi-cem-sandbox-files/data/$laers_faers/$domain --include "*" --exclude "*only.txt"

#set and echo globstar settings for ** used
shopt -s globstar

#### blow out old staged files for guess and checking
#### for file in ./**/*_new_header.txt; do
####     echo 'about to rm '"$file"
####     rm $file
#### done;

#specific quarter(s)
# for file in ./2004/Q1/*.txt ./2004/Q2/*.txt ; do

#for entire year 
#  for name in ./**/2004/**/*Q1.txt ./**/2004/**/*Q2.txt ./**/2004/**/*Q3.txt ./**/2004/**/*Q4.txt; do #all time

#all time
for name in ./**/*Q1.txt ./**/*Q2.txt ./**/*Q3.txt ./**/*Q4.txt; do #all time

# for name in ./2012/**/*Q4.txt; do
# for name in ./2004/**/*.txt; do
# for name in ./2004/**/*Q1.txt ./2004/**/*Q2.txt; do #just one file 2004 *Q2.txt
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

            # Big Step One Part A. - .TXT to .txt
            if [ ${name: -4} == '.TXT' ]; then
                echo 'found a .TXT' creating a .txt
                cp $name ${name:0:29}.txt
            # else
                # echo 'nahdawg'
            fi
        

            # Big Step One Part B. - .TXT to .txt
            tr -d '\015' < $name > "${name::-4}"_staged_with_lfs_only.txt

            # remove 11th $ to get rid of last $ in data section
             sed -i 's/\$//12' "${name::-4}"_staged_with_lfs_only.txt
            # Big Step One Part C. - .TXT to .txt
                #run ./first_2_lineS_report_generator.sh
            ## skipped because drug domain's good

            # Big Step Two
                thefilename=${name:0:18}
                thefilenamebase=${name:10:8}
                year='$'${name:14:2}
                qtr='$'${name:17:1}
                thefilenamedata="${thefilenamebase^^}.txt""$year""$qtr"
                echo 'the filename is '$thefilename
                echo '$thefilenamedata is '$thefilenamedata
                sed "s|$|\$$thefilenamedata|g" < ${name::-4}"_staged_with_lfs_only.txt" > ${name::-4}_with_data.txt
                pathtoname=${name: 0:9}
                # replace first occurence of $thefilenamedata to fix the header
                sed -i "0,/$thefilenamedata/{s/$thefilenamedata/filename\$yr\$qtr/}" ${name::-4}_with_data.txt


            # Big Step three?
            # ___ 5. make import_file ($domain/$domain.txt)
                

            # thefilename=${name:10}
        # thefilenamebase=${name:15:8}
        # year='$'${name:4:2}
        # qtr='$'${name:8:1}
        # thefilenamedata='$'"${thefilename}""$year""$qtr"
        # echo '$thefilenamedata is '$thefilenamedata
        # sed -i "s|$|$thefilenamedata|g" $name
        # echo 'the filename is '$thefilename
        # pathtoname=${name: 0:9}
        # #if bak does not exist create it
        # # if [ ! -f ${name:0:12}_bak.txt ]; then
        # #     cp $name ${name:0:12}_bak.txt
        # #     echo 'just made '${name:0:12}_bak.txt
        # # else
        # #     echo ${name:0:12}_bak.txt' already exists; will check for old.txt'
        # #     # $possible_old_loc=
        # #     echo ${pathtoname}'/old.txt'
        # #     if [ -f ${pathtoname}/old.txt ]; then
        # #         echo 'old.txt exists will copy into'$name
        # #         cp ${pathtoname}/old.txt $name
        # #     else
        # #         echo `pwd`
        # #         echo 'old.txt DID NOT exists will copy into'$name
        # #         cp ${name:0:12}_bak.txt $name
        #     # fi
        # replace first occurence of $thefilenamedata to fix the header
        # sed -i "0,/$thefilenamedata/{s/$thefilenamedata/\$\$filename\$year\$qtr/}" $name
        fi

        #replace 5th $ with $$ put into *.txt (chopping off name's .txt w/ -4)
        # sed 's/\$/\$\$/5' $name > "${name::-4}".txt
        # tr -d '\015' <$name >"${name}"_staged_with_lfs_only.txt

        #add empty last column at end of each line by adding 22nd $
        # sed -i 's/\$/\$\$/22' $name        
        #           \   \      \
           # escaped $ n $$   replace 22nd one
    
    
        #build out header (1st line of txt file)
        # header="$(head -1 --quiet "${name::-4}".txt)"
        
        #remove \r
        # header="${header%%[[:cntrl:]]}"
        
        #headers we want
        #primaryid$caseid$demo_seq$role_cod$CONFID$prod_ai$val_vbm$route$dose_vbm$cum_dose_chr$cum_dose_unit$dechal$rechal$lot_num$exp_dt$nda_num$dose_amt$dose_unit$dose_form$dose_freq

        # sed -i 's/\$CONFID/\$CONFID\$REPORTER_COUNTRY/g' $name

        # #make a sm.txt file that has only 20 lines to check results
        # sed '20,$ d' $name > "${name:0:10}"sm.txt
        # else
        # echo SKIPPED $name not equal to 22 chars long
        # fi
done;

echo 'next step would be running ./build_domain_import_file.sh'

# echo 'this script should have taken *_staged_with_lfs_only.txt in data_from_s3/laers/demo/**/ (quarter folders) and added a 23th column and then added to the header REPORTER_COUNTRY after $CONFID ';
# DEMO14Q1_staged_with_lfs_only.txt
# ^this is 44 characters so you change ./s3_data_download.sh to -gt 40 to only build demo.txt from this scripts output

# echo 'attempting to run f2_report_generator.sh for you'
# libreoffice --calc ../../f2_report_generator.sh