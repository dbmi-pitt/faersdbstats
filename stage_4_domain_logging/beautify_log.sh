#!/bin/bash

# copy this script to your logs folder, chmod 774 it and run it from the terminal

# this script was found to be necessary because pentaho will not let you use header/footers with appending and I found no other ways to add line breaks easily

source ../../faers_config.config

#cd ${FAERSDBSTATS_REPO_LOCATION}/logs

LOG_FILENAME_BASE=${LOG_FILENAME: 0:-4}

sed 's/\^differences\^differences/\^differences/g' < ${BASE_FILE_DIR}/logs/${LOG_FILENAME} > ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

sed -i 's/\^matches\^differences/\^matches/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

sed -i 's/\^matches\^differences/\^matches/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

sed -i 's/\^differences\^matches/\^differences/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

#replace ^matchesCHAR with ^matches \n CHAR
sed -i -E 's/(\^matches)([a-zA-Z])/\1\n\2/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

sed -i -E 's/(\^differences)([a-zA-Z])/\1\n\2/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

sed -i 's/\^matches(\n)\^matches/\^matches/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt
#replace any number of 
sed -i -E 's/(\s+\n)\^differences/\1/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

sed -i -E 's/(\^differences)(\s)/\1\n\2/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

#replace (^matches)(any number of 0-9's) with (^matches)\n(any number of 0-9's)
sed -i -E 's/(\^matches)([0-9]+)/\1\n\2/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

#replace (^differences)(any number of 0-9's) with (^matches)\n(any number of 0-9's)
sed -i -E 's/(\^differences)([0-9]+)/\1\n\2/g' ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt

echo 'you now have a beautify log located here: '
echo ${BASE_FILE_DIR}/logs/${LOG_FILENAME_BASE}_beautified.txt