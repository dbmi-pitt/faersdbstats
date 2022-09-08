#!/bin/bash
#uncomment source to debug from command line
source ../../faers_config.config

log_location=${BASE_FILE_DIR}/logs/${LOG_FILENAME}
#shell options #-s enable (set) each optname #globstar enables ** recursive dir search

printf '\n' >> $log_location
echo "########### s3_data_download ######################" >> $log_location

#belt and suspenders aws credentials
export "AWS_ACCESS_KEY_ID=${AWS_S3_ACCESS_KEY}"
export "AWS_SECRET_ACCESS_KEY=${AWS_S3_SECRET_KEY}"
export "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"

#output aws credentials
aws configure list

#set and echo globstar settings for ** used
shopt -s globstar 
shopt globstar
cd ${BASE_FILE_DIR}

echo 'REBUILD_ALL_TIME_DATA_LOCALLY is '$REBUILD_ALL_TIME_DATA_LOCALLY
#check if /data_from s3 does not exist then either create it or delete and recreate it
if [ "${REBUILD_ALL_TIME_DATA_LOCALLY}" == 1 ] || [ ! -d "${BASE_FILE_DIR}/data_from_s3" ]; then
        if [ ! -d "data_from_s3" ]; then
            echo data_from_s3 does not exist, will make - line 26
            mkdir data_from_s3
            cd data_from_s3
            aws s3 sync s3://${AWS_S3_BUCKET_NAME}/data/ . --exclude "*" --include "*.txt" 
        else 
            echo data_from_s3 does exist, will remove and recreate - line 29
            rm -r data_from_s3
            mkdir data_from_s3
        fi
    else
        cd data_from_s3
        #download non-existant text files from s3 to data_from_s3
        echo Performing an aws s3 sync with s3://${AWS_S3_BUCKET_NAME}/data/
        aws s3 sync s3://${AWS_S3_BUCKET_NAME}/data/ . --exclude "*" --include "*.txt" 
fi

# cd data_from_s3

# laers_or_faers toggle
if [ ${LOAD_NEW_YEAR} -le 2012 ] && [ ${LOAD_NEW_QUARTER: 1} -le 3]
then
    echo we have laers data
    laers_or_faers='laers';
else
    echo we have faers data
    laers_or_faers='faers';
fi


if [ "${LOAD_ALL_TIME}" = 1 ]; then
mkdir -p ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/
    #download s3://..data to local/data_from_s3
    echo LOAD_ALL_TIME is 1
    
    #s3 download if REBUILD_ALL_TIME_DATA_LOCALLY=1 or data_from_s3 does not exist locally
    if [ "${REBUILD_ALL_TIME_DATA_LOCALLY}" = 1 ] || [ ! -d "${BASE_FILE_DIR}/data_from_s3" ]; then
        echo data should exist in ${BASE_FILE_DIR}/data_from_s3/
        aws s3 cp s3://napdi-cem-sandbox-files/data/ ${BASE_FILE_DIR}/data_from_s3/ --recursive --exclude "*" --include "*.txt" --exclude "*old.txt" 
    else
        echo data should exist in ${BASE_FILE_DIR}/data_from_s3/
    fi

    data_from_s3_root_above_laers_or_faers=`pwd`;
    headempty=0
    echo 'pwd is ';
    echo `pwd` it should be path/to/data_from_s3;

    #loop through faers and laers folders
    for laers_or_faers_dir in faers laers; do
        echo laers_or_faers_dir is $laers_or_faers_dir;
        cd $laers_or_faers_dir;
        # echo outer loop pwd is `pwd`

            #locally loop through domains and create one staged import file ("domain".txt ie demo.txt)
            for domain in demo drug indi outc reac rpsr ther; do
            #do one domain like this
            # for domain in rpsr; do

                cd $domain
                echo inner loop domain $domain pwd is `pwd`
                echo pwd is `pwd`
                #blow out old staged files
                    for file in ./**/*_staged_with_lfs_only.txt; do
                        echo 'about to rm '"$file"
                        rm $file
                    done;
                #for name in "${BASE_FILE_DIR}"/data_from_s3/**/*.txt; do #if data_from_s3 isn't specified it might run /all_data/ and take forever #zsh needed
                for name in ./**/*.txt; do
                    #substring expansion is thrown off by thefilename is 18Q1_new.txt name is ./2018/Q1/DEMO18Q1_new.txt
                    #to do make thefilename everything after the 3rd "/" #done was ${name: -12}
                    # thefilenamedata='';
                    thefilename=${name: 10}
                    thefilenamebase=${name:10:8}
                    year='$'${name: 4:2}
                    qtr='$'${name: 8:1}
                    thefilenamedata='$'"${thefilename}""$year""$qtr"
                    echo 'thefilename is '$thefilename;
                    echo 'qtr is '$qtr;

                    #if length of string  thefilename is greater than 11
                    if [[ "${#thefilename}" -gt 11 ]]; then 
                        # echo "name is ${name}";
                        echo 'thefilename is long ENOUGHHHHHHHHHHHHHH'
                        echo 'thefilename is '$thefilename;
                        echo 'thefilenamedata is '$thefilenamedata;
                        echo '################################# name:10:2 is '${name:10:2};
                        #remove CRLF and build out something less than 11 chars long; like DE_lf.txt for staging purposes to avoid aws cli sync redownloading data files #note sed -z takes forever so use this
                        tr -d '\015' <$name >"${name::-4}"_staged_with_lfs_only.txt
                        # add thefilenamedata to the end of each line
                        sed -i "s|$|$thefilenamedata|g" "${name::-4}"_staged_with_lfs_only.txt
                        # if 1st line header line of domain.txt has not been created
                        if [ $headempty = 0 ]; then
                            #put header row into drug.txt
                            echo 'head is empty'
                            #build out header (1st line of txt file)
                            header="$(head -1 --quiet ${name})"
                            #remove \r
                            header="${header%%[[:cntrl:]]}"
                            #append column header $filename
                            header+=\$filename
                            #add year and quarter
                            header+=\$yr\$qtr

                            echo $header > ${domain}.txt                            
                            echo "${domain}.txt" is the domain.txt

                            #this was need for some domains leaving here just in case
                            #replace first occurence of $thefilenamedata
                            # sed -i "0,/$thefilenamedata/{s/$thefilenamedata//}" $name

                            headempty=1 &&
                            #tail outputs last -n+2 lines of a file (shows all lines of report from the second line onwards) # --quiet does not output the filename                    
                            tail -n +2 --quiet "${name::-4}"_staged_with_lfs_only.txt >> $domain.txt
                            #replace first occurence of $thefilenamedata
                            # sed -i "0,/$thefilenamedata/{s/$thefilenamedata//}" $domain.txt
                            #create domain log file in ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/
                                    echo $thefilename > ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}.txt
                                    # printf "\n" >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}.txt
                                    #add header line to file
                                    echo $header >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}.txt
                                    printf "\n" >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}.txt
                                    sed -n '2p' < "${name::-4}"_staged_with_lfs_only.txt >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}.txt
                        else
                            echo 'head is not empty so grabbing from line 2 on'
                            
                            #tail outputs last -n+2 lines of a file (shows all lines of report from the second line onwards) # --quiet does not output the filename
                            tail -n +2 --quiet "${name::-4}"_staged_with_lfs_only.txt >> $domain.txt
                            #        ^ output starting at line #2
                            echo "${name::-4}"_staged_with_lfs_only.txt >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                            echo ' '
                                    printf "\n" >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                    tail -2 "${name::-4}"_staged_with_lfs_only.txt>> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                    printf "\n\n" >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                        fi #end if [ $headempty = 0 ]; then
                                    echo ' '
                    else
                        echo 'name is short '$name
                                echo $domain
                                echo thefilename is $thefilename
                                echo thefilenamedata is $thefilenamedata
                                echo ' '

                                #chop for _test ing
                                #sed -i '11,$ d' ${domain}_test.txt
                                #head ${domain}_test.txt #for testing
                    fi #end if [[ "${#thefilename}" -gt 7 ]]; then 
                
                done; #end .txt file loop
                #reset headempty for next domain
                headempty=0
                cd ..
                done; #end domain loop
        cd $data_from_s3_root_above_laers_or_faers
    done; #end laers faers; do
else #not LOAD_ALL_DATA
    echo REPLACING ALL DATA IN data_from_s3 WITH DATA FROM ${LOAD_NEW_QUARTER}  ${LOAD_NEW_YEAR}
    echo "REPLACING ALL DATA IN data_from_s3 WITH DATA FROM" ${LOAD_NEW_QUARTER}  ${LOAD_NEW_YEAR} >> $log_location
    mkdir -p ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/
    
        #download s3://..data to local/data_from_s3
        #echo "data will be downloaded to..."
        #echo ${BASE_FILE_DIR}/data_from_s3/

        #echo "we will pull down year ->" ${LOAD_NEW_YEAR}
        #echo "... and we will pull down quarter ->" ${LOAD_NEW_QUARTER}
    #s3 download if REBUILD_ALL_TIME_DATA_LOCALLY=1 or data_from_s3 does not exist locally
    if [ "${REBUILD_ALL_TIME_DATA_LOCALLY}" = 1 ] || [ ! -d "${BASE_FILE_DIR}/data_from_s3" ]; then
        echo data should exist in ${BASE_FILE_DIR}/data_from_s3/
        echo about to run aws s3 cp because REBUILD_ALL_TIME_DATA_LOCALLY was 1 or data_from_s3 did not exist
        aws s3 cp s3://napdi-cem-sandbox-files/data/ ${BASE_FILE_DIR}/data_from_s3/ --recursive --exclude "*" --include "*.txt" --exclude "*old.txt" 
    else
        echo REBUILD_ALL_TIME_DATA_LOCALLY is not one or ${BASE_FILE_DIR}/data_from_s3/ did not exist so skipping aws cp
    fi

    data_from_s3_root_above_laers_or_faers=`pwd`;

        #locally loop through domains and create one staged import file ("domain".txt ie demo.txt)
        curdir=`pwd`;
        headempty=0
        echo 'pwd is ';
        echo `pwd` it should be path/to/data_from_s3 aka BASE_FILE_DIR;

#  #loop through faers and laers folders
#     for laers_or_faers in faers laers; do
        echo laers_or_faers is $laers_or_faers;
        # cd $laers_or_faers;
    # for laers_or_faers_dir in faers; do
        # echo laers_or_faers_dir is $laers_or_faers_dir;
        echo laers_or_faers is $laers_or_faers;
        # cd $laers_or_faers_dir;
        cd $laers_or_faers
        echo just cd-ed into `pwd`

        #housekeeping
                    #blow out old staged files
                    for file in ./**/*_staged_with_lfs_only.txt; do
                        echo 'about to rm '"$file"
                        rm $file
                    done;

                    #blow out old staged files
                    for file in ./**/*_new_qtr.txt; do
                        echo 'about to rm '"$file"
                        rm $file
                    done;

        for domain in demo drug indi outc reac rpsr ther; do # indi rpsr outc; do
        
            echo '$domain is ' $domain
            
            domain_level=${BASE_FILE_DIR}/data_from_s3/$faers_or_laers${domain}
            echo 'just made domain_level='${domain_level}

            s3_bucket_source_path=s3://napdi-cem-sandbox-files/data/$laers_or_faers/$domain/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}
            
            echo 'about to check if new source data is there; setting state = aws s3 ls of '$s3_bucket_source_path
            state=`aws s3 ls $s3_bucket_source_path`
            # if $state not empty it means s3 data exists and stage 1 succeeded
            if [ -z "$state" ]
                then
                    >&2 echo $s3_bucket_source_path does not exist, check config and s3
                    exit 1
                else
                    echo 's3 new quarter data source path exists'
                    #echo local path will be 
                    #data_from_s3_folder_path=${BASE_FILE_DIR}/data_from_s3/$laers_or_faers/$domain/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER} #${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}/
                    YYQQtxt=${LOAD_NEW_YEAR:2:3}${LOAD_NEW_QUARTER}.txt

                    #copy down the data from the s3
                    # aws s3 cp $s3_bucket_source_path $data_from_s3_folder_path --exclude "*" --include "*$YYQQtxt" --recursive
                    #`pwd`
                    # cd "$laers_or_faers/$domain"

                    #note ** requires shopt globstar


                    echo about to cd into $domain/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}/
                    cd $domain/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}/

                    echo 'pwd for to search for ./**/.txt from is '`pwd`
                    echo 'about to loop for name in ./**/*.txt; do'

                    # cd $domain
                    #loop through all .txt files in domain folder
                    for name in ./**/*.txt; do
                        #substring expansion is thrown off by thefilename is 18Q1_new.txt name is ./2018/Q1/DEMO18Q1_new.txt
                        #to do make thefilename everything after the 3rd "/" #done was ${name: -12}
                        echo 'inside the for name loop pwd is '`pwd`
                        echo the name is $name
                        thefilename=${name: 2}
                        year='$'${name: 6:2}
                        qtr='$'${name: 9:1}
                        thefilenamedata='$'"${thefilename}""$year""$qtr"
                        echo 'thefilename is '$thefilename;
                        echo 'qtr is '$qtr;

                        #prevent the filename being just old.txt, txt or nothing
                        # 'the # v gets char length'
                        if [[ "${#thefilename}" -gt 11 ]]; then 
                                echo "name is ${name}";
                                echo 'thefilename '$thefilename' is greaterrr than 11 in length and is '${#thefilename}
                                
                                echo 'about to append thefilenamedata of '$thefilenamedata ' to ' "${name::-4}"_staged_with_lfs_only.txt
                                #sed -i "s|$|$thefilenamedata|g" $name
                                echo "name is ${name}"
                                #remove CRLF and build out something less than 11 chars long; like DE_lf.txt for staging purposes to avoid aws cli sync redownloading data files #note sed -z takes forever so use this
                                tr -d '\015' <$name >"${name::-4}"_staged_with_lfs_only.txt
                                # add thefilenamedata to the end of each line
                                sed -i "s|$|$thefilenamedata|g" "${name::-4}"_staged_with_lfs_only.txt
                                # if 1st line header line of domain.txt has not been created
                                if [ $headempty = 0 ]; then
                                    #put header row into drug.txt
                                    echo 'head is empty'
                                    #build out header (1st line of txt file)
                                    header="$(head -1 --quiet ${name})"
                                    #remove \r
                                    header="${header%%[[:cntrl:]]}"
                                    #append column header $filename
                                    header+=\$filename
                                    #add year and quarter
                                    header+=\$yr\$qtr


                                    echo ../../${domain}_new_qtr.txt
                                    echo $header > ../../${domain}_new_qtr.txt
                                    echo "${domain}.txt" is the domain.txt

                                    #this was need for some domains leaving here just in case
                                    #replace first occurence of $thefilenamedata
                                    # sed -i "0,/$thefilenamedata/{s/$thefilenamedata//}" $name

                                    headempty=1 &&
                                    #tail outputs last -n+2 lines of a file (shows all lines of report from the second line onwards) # --quiet does not output the filename                    
                                    tail -n +2 --quiet "${name::-4}"_staged_with_lfs_only.txt >> ../../${domain}_new_qtr.txt
                                    #replace first occurence of $thefilenamedata
                                    # sed -i "0,/$thefilenamedata/{s/$thefilenamedata//}" $domain.txt

                                    #create domain log file in ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/
                                    echo $thefilename > ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                    # printf "\n" >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}.txt
                                    #add header line to file
                                    echo $header >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                    printf "\n" >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                    #add 2nd line of 1st file that creates
                                    sed -n '2p' < "${name::-4}"_staged_with_lfs_only.txt >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                else
                                    echo 'head is not empty so grabbing from line 2 on'
                                    
                                    #tail outputs last -n+2 lines of a file (shows all lines of report from the second line onwards) # --quiet does not output the filename
                                    tail -n +2 --quiet "${name::-4}"_staged_with_lfs_only.txt >> ../../${domain}_new_qtr.txt
                                    #        ^ output starting at line #2

                                    echo "${name::-4}"_staged_with_lfs_only.txt >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                    echo ' '
                                    printf "\n" >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                    tail -2 "${name::-4}"_staged_with_lfs_only.txt>> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                    printf "\n\n" >> ${BASE_FILE_DIR}/logs/stage_2_domain_import_file_creation/${laers_or_faers}_${domain}_new_qtr.txt
                                fi #end if [ $headempty = 0 ]; then
                                    echo ' '
                            else
                                #else the filename was not 11 characters long
                                echo ${thefilename} 'has a length of ' ${#thefilename} ' which is not 11 characters long and therefore ignored'
                                echo ' '
                                #i need to know if this will work here for speed reasons
                                #echo this is super important
                                # echo the domain is $laers_or_faers $domain
                                # echo the thefilename is $thefilename
                                # echo the thefilenamedata is $thefilenamedata


                                # #add thefilenamedata to the end of every line in the file
                                # #sed "s|$|endoftheline|g" demo_lf.txt > demo_test.txt
                                # sed -i "s|$|$thefilenamedata|g" ${domain}.txt

                                # #replace first occurence of $thefilenamedata
                                # sed -i "0,/$thefilenamedata/{s/$thefilenamedata//}" ${domain}.txt
                                
                        fi #end if [[ "${#thefilename}" -gt 11 ]]; then 
                    done; #end for name in ./**/*.txt; do

            fi #end if [ -z "$state" ]
        #reset headempty for next domain
        headempty=0
        echo pwd is `pwd`
        #echo '$curdir is '$curdir

        echo ' '
        echo 'here is the first 10 lines of ' ../../${domain}_new_qtr.txt
        head ../../${domain}_new_qtr.txt
        echo ' '

        echo 'about to cd up 3 levels'
        #cd out out of domain and into laers_or_faers
        cd ../../../
        echo pwd after up 3 levels is `pwd`
        echo ' '
        echo ' '
        echo ' '
        # break 60
    done; #end for domain in /data/; do
    cd $data_from_s3_root_above_laers_or_faers;
#   done; #end for laers faers; do
fi #end if [ "${LOAD_ALL_TIME}" = 1 ]; then

echo "s3_data_download.sh done data should be located in " ${BASE_FILE_DIR}"/data_from_s3/" >> $log_location