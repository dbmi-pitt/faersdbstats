#!/bin/bash
#shell options #-s enable (set) each optname #globstar enables ** recursive dir search

#uncomment source to debug from command line
#source ../faers.config

 #export AWS_PROFILE=user1

export "AWS_ACCESS_KEY_ID=${AWS_S3_ACCESS_KEY}"
#echo "AWS_S3_ACCESS_KEY = ${AWS_S3_ACCESS_KEY}"

export "AWS_SECRET_ACCESS_KEY=${AWS_S3_SECRET_KEY}"
#echo "AWS_S3_BUCKET_NAME=${AWS_S3_BUCKET_NAME}"

export "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"

aws configure list

#exit;

shopt -s globstar
shopt globstar
cd ${BASE_FILE_DIR}

#check if /data_from s3 does not exist then either create it or delete and recreate it
if [ ! -d "data_from_s3" ]; then
    echo data_from_s3 does not exist, will make - line 8
	mkdir data_from_s3
else 
    echo data_from_s3 does exist, will remove and recreate - line 11
	rm -r data_from_s3
	mkdir data_from_s3
fi
cd data_from_s3

#if LOAD_NEW_DATA
if [ "${LOAD_ALL_TIME}" = 1 ]; then

    #download s3://..data_test to local/data_from_s3
    echo data will be downloaded to ${BASE_FILE_DIR}/data_from_s3/
    aws s3 cp s3://napdi-cem-sandbox-files/data/ ${BASE_FILE_DIR}/data_from_s3/ --recursive --exclude "*" --include "*.txt"

    #locally loop through domains and create one staged import file ("domain".txt ie demo.txt)
    curdir=`pwd`;
    headempty=0
    echo 'pwd is ';
    echo `pwd` it should be path/to/data_from_s3;
    for domain in demo drug indi outc reac rpsr ther; do
        echo 'domain is '$domain;
        #mkdir $domain #throws error because aws cp created it
        cd $domain
        #for name in "${BASE_FILE_DIR}"/data_from_s3/**/*.txt; do #if data_from_s3 isn't specified it might run /all_data/ and take forever
        for name in ./**/*.txt; do
        echo 'name is '$name;
            if [ $headempty = 0 ]; then
                #put header row into drug.txt
                head -1 --quiet $name > $domain.txt
                
                headempty=1 &&
                #tail outputs last -n+2 lines of a file #-q does not output the filename
                tail -n +2 --quiet $name >> $domain.txt
            else
                #tail outputs last -n+2 lines of a file #-q does not output the filename
                tail -n +2 --quiet $name >> $domain.txt
            fi
            #break 60
        done; #end for name in ./**/*.txt; do
        #reset headempty for next domain
        headempty=0
        cd $curdir
        #break 60
    done; #end for domain in drug demo; do 
else #not LOAD_ALL_DATA equivalent to LOAD_NEW_DATA
    echo REPLACING ALL DATA IN data_from_s3 WITH DATA FROM ${LOAD_NEW_QUARTER}  ${LOAD_NEW_YEAR}
    
        #download s3://..data_test to local/data_from_s3
        #echo "data will be downloaded to..."
        #echo ${BASE_FILE_DIR}/data_from_s3/

        #echo "we will pull down year ->" ${LOAD_NEW_YEAR}
        #echo "... and we will pull down quarter ->" ${LOAD_NEW_QUARTER}

        #locally loop through domains and create one staged import file ("domain".txt ie demo.txt)
        curdir=`pwd`;
        headempty=0
        #echo 'pwd is ';
        #echo `pwd` it should be path/to/data_from_s3 aka BASE_FILE_DIR;

        #make use case for legacy data faers_or_laers
        if [ ${LOAD_NEW_YEAR} -le 2012 ]
        then
            #echo we have laers data
            faers_or_laers='laers';
        else
            #echo we have faers data
            faers_or_laers='faers';
        fi

        for domain in demo drug indi outc reac rpsr ther; do # indi rpsr outc; do
            s3_bucket_source_path=s3://napdi-cem-sandbox-files/data/$domain/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}
            

            state=`aws s3 ls $s3_bucket_source_path`
            if [ -z "$state" ]
                then
                    >&2 echo $s3_bucket_source_path does not exist, check config and s3
                    exit 1
                else
                    echo 's3 source path exists'
                    #echo local path will be 
                    data_from_s3_folder_path=${BASE_FILE_DIR}/data_from_s3/$faers_or_laers/$domain/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER} #${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}/
                    YYQQtxt=${LOAD_NEW_YEAR:2:3}${LOAD_NEW_QUARTER}.txt

                    aws s3 cp $s3_bucket_source_path $data_from_s3_folder_path --exclude "*" --include "*$YYQQtxt" --recursive
                    #`pwd`
                    cd "$domain"

                    #note ** requires shopt globstar
                    for name in ./**/*.txt; do       
                        #echo 'pwd is (in for loop)'
                        #echo `pwd`                        
                        #echo 'domain is '$domain                 
                       #echo 'name is '
                        echo "$name"
                            if [ $headempty = 0 ]; then
                                #put header row into drug.txt
                                head -1 --quiet $name > $domain.txt
                                
                                headempty=1 &&
                                #tail outputs last -n+2 lines of a file #-q does not output the filename
                                tail -n +2 --quiet $name >> $domain.txt
                            else
                                #tail outputs last -n+2 lines of a file #-q does not output the filename
                                tail -n +2 --quiet $name >> $domain.txt
                            fi #end if [ $headempty = 0 ]; then
                            #break 60
                    done; #end for name in ./**/*.txt; do
            fi #end if [ -z "$state" ]
        #reset headempty for next domain
        headempty=0
        #echo pwd is `pwd`
        #echo '$curdir is '$curdir
        cd $curdir #not sure if needed
        #break 60
    done; #end for domain in demo drug; do
    #done;
fi #end if [ "${LOAD_ALL_TIME}" = 1 ]; then