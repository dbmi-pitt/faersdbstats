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
        aws s3 sync s3://${AWS_S3_BUCKET_NAME}/data/ . --exclude "*" --include "*.txt" 
fi

# cd data_from_s3

#make use case for legacy data faers_or_laers
if [  [ ${LOAD_NEW_YEAR} -le 2012 ] && [ ${LOAD_NEW_QUARTER: 1} -le 3] ]
then
    #echo we have laers data
    faers_or_laers='laers';
else
    #echo we have faers data
    faers_or_laers='faers';
fi


if [ "${LOAD_ALL_TIME}" = 1 ]; then

    #download s3://..data to local/data_from_s3
    echo LOAD_ALL_TIME is 1
    
    #s3 download if REBUILD_ALL_TIME_DATA_LOCALLY=1 or data_from_s3 does not exist locally
    if [ "${REBUILD_ALL_TIME_DATA_LOCALLY}" = 1 ] || [ ! -d "${BASE_FILE_DIR}/data_from_s3" ]; then
        echo data should exist in ${BASE_FILE_DIR}/data_from_s3/
        aws s3 cp s3://napdi-cem-sandbox-files/data/ ${BASE_FILE_DIR}/data_from_s3/ --recursive --exclude "*" --include "*.txt" --exclude "*old.txt" 
    else
        echo data should exist in ${BASE_FILE_DIR}/data_from_s3/
    fi

    data_from_s3_root_above_laers_faers=`pwd`;
    headempty=0
    echo 'pwd is ';
    echo `pwd` it should be path/to/data_from_s3;

    #loop through faers and laers folders
    for laers_faers in faers laers; do
        echo laers_faers is $laers_faers;
        cd $laers_faers;
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
                    thefilenamedata='$'"${thefilename}""$qtr""$year"
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
                        else
                            echo 'head is not empty so grabbing from line 2 on'
                            
                            #tail outputs last -n+2 lines of a file (shows all lines of report from the second line onwards) # --quiet does not output the filename
                            tail -n +2 --quiet "${name::-4}"_staged_with_lfs_only.txt >> $domain.txt
                            #        ^ output starting at line #2
                        fi #end if [ $headempty = 0 ]; then
                    else
                        echo 'name is short '$name
                                echo $domain
                                echo thefilename is $thefilename
                                echo thefilenamedata is $thefilenamedata                    

                                #chop for _test ing
                                #sed -i '11,$ d' ${domain}_test.txt
                                #head ${domain}_test.txt #for testing
                    fi #end if [[ "${#thefilename}" -gt 7 ]]; then 
                
                done; #end .txt file loop
                #reset headempty for next domain
                headempty=0
                cd ..
                done; #end domain loop
        cd $data_from_s3_root_above_laers_faers
    done; #end laers faers; do
else #not LOAD_ALL_DATA
    echo REPLACING ALL DATA IN data_from_s3 WITH DATA FROM ${LOAD_NEW_QUARTER}  ${LOAD_NEW_YEAR}
    echo "REPLACING ALL DATA IN data_from_s3 WITH DATA FROM" ${LOAD_NEW_QUARTER}  ${LOAD_NEW_YEAR} >> $log_location
    
        #download s3://..data to local/data_from_s3
        #echo "data will be downloaded to..."
        #echo ${BASE_FILE_DIR}/data_from_s3/

        #echo "we will pull down year ->" ${LOAD_NEW_YEAR}
        #echo "... and we will pull down quarter ->" ${LOAD_NEW_QUARTER}

        #locally loop through domains and create one staged import file ("domain".txt ie demo.txt)
        curdir=`pwd`;
        headempty=0
        #echo 'pwd is ';
        #echo `pwd` it should be path/to/data_from_s3 aka BASE_FILE_DIR;

        for domain in demo drug indi outc reac rpsr ther; do # indi rpsr outc; do
            s3_bucket_source_path=s3://napdi-cem-sandbox-files/data/$faers_or_laers/$domain/${LOAD_NEW_YEAR}/${LOAD_NEW_QUARTER}
            

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
                    cd "$faers_or_laers/$domain"

                    #note ** requires shopt globstar
                    for name in ./**/*.txt; do       
                        #substring expansion is thrown off by thefilename is 18Q1_new.txt name is ./2018/Q1/DEMO18Q1_new.txt
                        #to do make thefilename everything after the 3rd "/" #done was ${name: -12}
                        thefilenamedata='';
                        thefilename=${name: 10}
                        year='$'${name: 4:2}
                        qtr='$'${name: 8:1}
                        thefilenamedata='$'"${thefilename}""$qtr""$year"
                        echo 'thefilename is '$thefilename;
                        echo 'qtr is '$qtr;

                        #prevent the filename being just old.txt, txt or nothing
                        if [[ "${#thefilename}" -gt 7 ]]; then 
                            echo "name is ${name}";
                            echo 'thefilename '$thefilename' is greater than 7 in length and is '${#thefilename}
                            
                                echo 'about to append thefilenamedata of '$thefilenamedata ' to ' $name
                                sed -i "s|$|$thefilenamedata|g" $name          
                            echo "name is ${name}"
                            if [ $headempty = 0 ]; then
                                #put header row into drug.txt
                                echo 'headempty'
                                head -1 $name > $domain.txt
                                
                                headempty=1 &&
                                #tail outputs last -n+2 lines of a file #-q does not output the filename
                                tail -n +2 --quiet $name >> $domain.txt
                            else
                                echo 'head not empty'
                                #tail outputs last -n+2 lines of a file #-q does not output the filename
                                tail -n +2 --quiet $name >> $domain.txt
                            fi #end if [ $headempty = 0 ]; then
                            #break 60
                    
                            #i need to know if this will work here for speed reasons
                            #echo this is super important
                            echo the domain is $faers_or_laers $domain
                            echo the thefilename is $thefilename
                            echo the thefilenamedata is $thefilenamedata


                            # #add thefilenamedata to the end of every line in the file
                            # #sed "s|$|endoftheline|g" demo_lf.txt > demo_test.txt
                            # sed -i "s|$|$thefilenamedata|g" ${domain}.txt

                            # #replace first occurence of $thefilenamedata
                            # sed -i "0,/$thefilenamedata/{s/$thefilenamedata//}" ${domain}.txt
                        fi
                    done; #end for name in ./**/*.txt; do

            fi #end if [ -z "$state" ]
        #reset headempty for next domain
        headempty=0
        #echo pwd is `pwd`
        #echo '$curdir is '$curdir
        cd $curdir #not sure if needed
        #break 60
        head ${domain}.txt
    done; #end for domain in /data/; do
    #done;
fi #end if [ "${LOAD_ALL_TIME}" = 1 ]; then

echo "s3_data_download.sh done data should be located in " ${BASE_FILE_DIR}"/data_from_s3/" >> $log_location