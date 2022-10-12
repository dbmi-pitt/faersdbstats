#!/bin/bash

# built from data_4/add_filename_yr_qtr.sh

# this script should be in ${BASE_FIL_DIR}/faersdbstats_data/data_meta/
# move output of this script to ${BASE_FIL_DIR}/data_from_s3/faers/indi

#rebuilds indi domain data files for '12 Q4, all '13, and '14 Q1 and Q2

##local config vars
laers_faers=laers
domain=indi

echo pwd is `pwd`

source ../../faers_config.config
cd ${BASE_FILE_DIR}/faersdbstats_data/data_meta/$laers_faers/$domain

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

# aws s3 sync . s3://${AWS_S3_BUCKET_NAME}/data/$laers_faers/$domain --include "*" --exclude "*only.txt"

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

        echo 'name is' $name
        echo '#name is' ${#name}
    if [ "${#name}" -eq 22 ]; then 
        echo '22 long name is' $name
        # echo '${name::-4} is' ${name::-4}
        echo '${name:: -4} is' ${name:: -4}

            # Big Step One Part A. - .TXT to .txt
            if [ ${name: -4} == '.TXT' ]; then
                echo 'found a .TXT' creating a .txt
                cp $name ${name:0:29}.txt
            # else
                # echo 'nahdawg'
            fi
        

            # # Big Step One Part B. - .TXT to .txt
            tr -d '\015' < $name > "${name::-4}"_staged_with_lfs_only.txt

            # # remove 11th $ to get rid of last $ in data section
            #  sed -i 's/\$//12' "${name::-4}"_staged_with_lfs_only.txt
            
            # # Big Step One Part C. - .TXT to .txt
            #     #run ./first_2_lineS_report_generator.sh
            # ## skipped because indi domain's good

            # # Big Step Two
                thefilename=${name:0:29}
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



        fi

done;

echo 'next step would be running ./build_domain_import_file.sh'

# echo 'attempting to run f2_report_generator.sh for you'
# libreoffice --calc ../../f2_report_generator.sh