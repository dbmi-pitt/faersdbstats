#!/bin/bash

source ../../faers_config.config

cd ${BASE_FILE_DIR}/data_from_s3/

# for laers_faers in laers faers; do
# for laers_faers in laers; do
for laers_faers in faers; do

    # for domain in demo; do
    for domain in demo drug indi outc reac rpsr ther; do
    # for domain in drug indi outc reac rpsr ther; do

        echo pwd is `pwd`
        file_path=${BASE_FILE_DIR}'/data_from_s3/'$laers_faers'/'$domain'/'${domain}'.txt'
        dest_path='s3://'${AWS_S3_BUCKET_NAME}'/'${AWS_S3_DOMAIN_BACKUP_DEST}'/'$laers_faers'/'$domain'/'${domain}'.txt'
        echo 'running aws s3 cp '$file_path $dest_path
        # aws s3 cp --follow-symlinks --recursive ./$domain/${domain}.txt s3://${AWS_S3_BUCKET_NAME}/${AWS_S3_DOMAIN_BACKUP_DEST}/$laers_faers/$domain/${domain}.txt
        aws s3 cp $file_path $dest_path

    done; #done domain


done; #done laers_faers