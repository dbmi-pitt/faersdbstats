#!/bin/bash
# this script downloads all the current ASCII format FAERS files from the FDA website
# as of May 15th 2018
#
# bucknelius
################################################################

#source "../../faers_config.config" #for local testing
source "${BASE_FILE_DIR}/faers_config.config"

# 19q1| https://fis.fda.gov/content/Exports/faers_ascii_2019Q1.zip
# 18a4| https://fis.fda.gov/content/Exports/faers_ascii_2018q4.zip
# 18q3| https://fis.fda.gov/content/Exports/faers_ascii_2018q3.zip
# 18q2| https://fis.fda.gov/content/Exports/faers_ascii_2018q2.zip
# 18q1| https://fis.fda.gov/content/Exports/faers_ascii_2018q1.zip

echo `pwd`
cd "${BASE_FILE_DIR}"
echo `pwd`

rm -rf data_new
mkdir data_new
cd data_new

# FAERS ASCII
if [ ${LOAD_NEW_YEAR} -le 2012 ]
then
    #echo we have laers data
    faers_or_laers='laers';
    fileyearquarter="${LOAD_NEW_YEAR: -2}${LOAD_NEW_QUARTER,,}"
    zip_url=https://fis.fda.gov/content/Exports/aers_ascii_"${LOAD_NEW_YEAR}${LOAD_NEW_QUARTER,,}".zip
    zip_filename="aers_ascii_${LOAD_NEW_YEAR}${LOAD_NEW_QUARTER,,}.zip"
    echo will wget this $zip_url
    wget $zip_url 2>&1
    unzip $zip_filename 2>> error.txt 1>> output.txt
    mv ASCII/ASC_NTS.pdf ASCII/ASC_NTS"${fileyearquarter}".pdf
else
    #echo we have faers data
    faers_or_laers='faers';
    fileyearquarter="${LOAD_NEW_YEAR: -2}${LOAD_NEW_QUARTER}"
    zip_url=https://fis.fda.gov/content/Exports/faers_ascii_"${LOAD_NEW_YEAR}${LOAD_NEW_QUARTER}".zip
    echo will wget this $zip_url
    wget $zip_url 2>&1
    unzip faers_ascii_${LOAD_NEW_YEAR}${LOAD_NEW_QUARTER}.zip  2>> error.txt 1>> output.txt
    mv ASCII/ASC_NTS.pdf ASCII/ASC_NTS"${fileyearquarter}".pdf
fi

echo `pwd`
#mv FAQs.pdf ascii/FAQs"${fileyearquarter}".pdf
#mv FAQs.doc ascii/FAQs"${fileyearquarter}".doc
#mv Readme.pdf ascii/Readme"${fileyearquarter}.pdf"
#mv Readme.doc ascii/Readme"${fileyearquarter}.doc"
#mv ascii/ASC_NTS.doc ascii/ASC_NTS"${fileyearquarter}".doc

# # cleanup from miscellaneous sub-directory names
# mv ASCII/* ascii
# mv asci/* ascii
# mv asii/* ascii
# rmdir ASCII
# rmdir asci
# rmdir asii
