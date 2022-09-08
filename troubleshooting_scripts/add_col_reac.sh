#!/bin/bash

#rebuilds drug domain data files for '12 Q4, all '13, and '14 Q1 and Q2

#use this to add columns after ./s3_data_download.sh (stage 2) has been run to check tweaks locally

#for adding empty columns gets run on from domain level directory
source ../../faers_config.config
cd ${BASE_FILE_DIR}/data_from_s3/faers/reac/

# example workflow:
# _x_ 1. run *stage_2*/s3_data_download.sh - build out *_staged_with_lfs_only.txt (adds filename qtr yr)
# _x_ 2. run *domain*/add_col.sh - <adds col (back into _staged_with_lfs_only.txt)
# ___ 3. run *stage_2*./s3_data_download_after_add_col.sh on(_staged_with_lfs_only.txt)
# ___ 4. run sed '0/$DRUG12Q4.txt$4$12$filename$yr$qtr/$filename$yr$qtr' drug.txt

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

for name in ./2012/**/*Q4.txt; do
    echo 'name is' $name
    cp $name ${name:0:12}_bak.txt
    #replace 5th $ with $$ put into *.txt (chopping off name's .txt w/ -4)
    # sed 's/\$/\$\$/5' $name > "${name::-4}".txt

    #delete column 3
    # cut --complement -d' ' -f3 rpsr.txt

    tr -d '\015' <$name >"${name}"_staged_with_lfs_only.txt

    # sed -i 's/\$/\$\$/3' $name
   #           \      \
   # escaped $ n $$    replace 3rd one
   
    sed 's/$/$\$/' <${name}_staged_with_lfs_only.txt > $name

 
    #build out header (1st line of txt file)
    # header="$(head -1 --quiet "${name::-4}".txt)"
    
    #remove \r
    # header="${header%%[[:cntrl:]]}"
    
    #headers we want
    #primaryid$caseid$drug_seq$role_cod$drugname$prod_ai$val_vbm$route$dose_vbm$cum_dose_chr$cum_dose_unit$dechal$rechal$lot_num$exp_dt$nda_num$dose_amt$dose_unit$dose_form$dose_freq

    # sed -i 's/\$pt\$/\$pt\$drug_rec_act/g' $name
      sed -i '0,/\$pt\$/{s/\$pt\$/\$drug_rec_act\$/}' reac.txt

    #make a sm.txt file that has only 20 lines to check results
    sed '20,$ d' $name > "${name:0:10}"sm.txt

    head ../../reac.txt
    head REAC12Q4.txt

    echo '... if results are what you are after comment out the aws s3 download and/or cp and/or sync and re-run ./s3_data_download.sh to rebuilt reac.txt'
    echo 'you might also like to limit the for domain loop to just reac'
done;


# DRUG14Q1_staged_with_lfs_only.txt
# ^this is 44 characters so you change ./s3_data_download.sh to -gt 40 to only build drug.txt from this scripts output