#!/usr/bin/bash
#source ../../faers_config.config

log_location=${BASE_FILE_DIR}/logs/${LOG_FILENAME}
echo log_location is $log_location

printf '\n' >> $log_location
echo "###################################################" > $log_location
echo "##### VALUES FROM faers_config.config #############" >> $log_location
echo "###################################################" >> $log_location
printf '\n' >> $log_location
echo BASE_FILE_DIR is ${BASE_FILE_DIR}
echo FAERSDBSTATS_REPO_LOCATION is ${FAERSDBSTATS_REPO_LOCATION} >> $log_location
echo LOG_FILENAME is ${LOG_FILENAME} >> $log_location
printf '\n' >> $log_location

#####################################################################
#######################   PENTAHO    ################################
#####################################################################

#local location of https://github.com/dbmi-pitt/faersdbstats repo

#Orange book data download link location #https://www.fda.gov/drugs/drug-approvals-and-databases/orange-book-data-files #"Orange Book Data Files (compressed)" < path from link w/ text "Orange Book Data Files (compressed)"
echo "###################################################" >> $log_location
echo CEM_ORANGE_BOOK_DOWNLOAD_URL is ${CEM_ORANGE_BOOK_DOWNLOAD_URL} >> $log_location
echo CEM_ORANGE_BOOK_DOWNLOAD_FILENAME is ${CEM_ORANGE_BOOK_DOWNLOAD_FILENAME} >> $log_location
#CEM_ORANGE_BOOK_DOWNLOAD_MONTH=04 #<GET FROM DOWNLOADED ZIP NAME IN ABOVE LINK
#CEM_ORANGE_BOOK_DOWNLOAD_YEAR=2022 #<GET FROM DOWNLOADED ZIP NAME IN ABOVE LINK
echo CEM_DOWNLOAD_DATA_FOLDER is ${CEM_DOWNLOAD_DATA_FOLDER} >> $log_location
echo "###################################################" >> $log_location


printf '\n' >> $log_location
#####################################################################
#######################   AWS    ####################################
#####################################################################
printf '\n' >> $log_location
echo "###################################################" >> $log_location
echo "################### AWS ###########################" >> $log_location
echo "###################################################" >> $log_location
printf '\n' >> $log_location
#edit values and save as aws.config
echo "$(aws configure list)" >> $log_location
# echo AWS_S3_BUCKET_NAME is ${AWS_S3_BUCKET_NAME} >> $log_location
# echo AWS_S3_ACCESS_KEY is ${AWS_S3_ACCESS_KEY} >> $log_location
# echo AWS_ACCESS_KEY_ID is ${AWS_ACCESS_KEY_ID} >> $log_location
# echo AWS_S3_SECRET_KEY is ${AWS_S3_SECRET_KEY} >> $log_location
# echo AWS_SECRET_ACCESS_KEY is ${AWS_SECRET_ACCESS_KEY} >> $log_location
# echo AWS_DEFAULT_REGION is ${AWS_DEFAULT_REGION} >> $log_location

#####################################################################
#######################   DATABASE    ###############################
#####################################################################
printf '\n' >> $log_location
echo "###################################################" >> $log_location
echo "#################### DATABASES ####################" >> $log_location
echo "###################################################" >> $log_location
printf '\n' >> $log_location
echo DATABASE_HOST is ${DATABASE_HOST} >> $log_location
echo DATABASE_PORT is ${DATABASE_PORT} >> $log_location
echo DATABASE_SCHEMA is ${DATABASE_SCHEMA} >> $log_location
echo DATABASE_NAME is ${DATABASE_NAME} >> $log_location
echo DATABASE_USERNAME is ${DATABASE_USERNAME} >> $log_location
echo "#################### LOG ##########################" >> $log_location
echo DATABASE_LOG_SCHEMA is ${DATABASE_LOG_SCHEMA} >> $log_location
echo DATABASE_LOG_TABLE is ${DATABASE_LOG_TABLE} >> $log_location
echo DATABASE_LOG_NAME is ${DATABASE_LOG_NAME} >> $log_location
echo DATABASE_LOG_SCHEMA is ${DATABASE_LOG_SCHEMA} >> $log_location
echo "#################### COMPARISON ##########################" >> $log_location
echo DATABASE_HOST is ${DATABASE_COMPARISON_HOST} >> $log_location
echo DATABASE_PORT is ${DATABASE_COMPARISON_PORT} >> $log_location
echo DATABASE_SCHEMA is ${DATABASE_COMPARISON_SCHEMA} >> $log_location
echo DATABASE_NAME is ${DATABASE_COMPARISON_NAME} >> $log_location
echo DATABASE_USERNAME is ${DATABASE_COMPARISON_USERNAME} >> $log_location

# I don't think this is used
# DATABASE_PASSWORD} >> $log_location

printf '\n' >> $log_location
printf '\n' >> $log_location
echo "###################################################" >> $log_location
echo "############   TIMEFRAME    #######################" >> $log_location
echo "###################################################" >> $log_location
printf '\n' >> $log_location

# LOAD_ALL_TIME 
echo "LOAD_ALL_TIME is " $LOAD_ALL_TIME >> $log_location

# BELOW CONFIGS ARE NEEDED EVEN IF LOAD_ALL_TIME=1 (FOR ORANGE BOOK DATA)

echo "LOAD_NEW_QUARTER is " $LOAD_NEW_QUARTER >> $log_location
echo "LOAD_NEW_YEAR is " $LOAD_NEW_YEAR >> $log_location

printf '\n' >> $log_location
echo "###################################################" >> $log_location
echo "############# END OF CONFIG VALUES ################" >> $log_location
echo "###################################################" >> $log_location
printf '\n' >> $log_location

printf '\n' >> $log_location
echo "#########################################" >> $log_location
echo "###### BEGINNING STAGE_1 OUTPUT #########" >> $log_location
echo "#########################################" >> $log_location
printf '\n' >> $log_location
