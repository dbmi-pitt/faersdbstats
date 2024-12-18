#!/bin/bash
# This script downloads all the current ASCII format FAERS files from the FDA website
# and organizes them into year/quarter subfolders.
# As of May 15th, 2018
#
################################################################

source "../../faers_config.config" # for local testing
# source "${BASE_FILE_DIR}/faers_config.config"

# Example URLs for reference
# 19q1| https://fis.fda.gov/content/Exports/faers_ascii_2019Q1.zip
# 18a4| https://fis.fda.gov/content/Exports/faers_ascii_2018q4.zip
# 18q3| https://fis.fda.gov/content/Exports/faers_ascii_2018q3.zip
# 18q2| https://fis.fda.gov/content/Exports/faers_ascii_2018q2.zip
# 18q1| https://fis.fda.gov/content/Exports/faers_ascii_2018q1.zip

echo "Current working directory: $(pwd)"
cd "${BASE_FILE_DIR}"
echo "Changed to base file directory: $(pwd)"

# Create a clean directory for new data
rm -rf data_new
mkdir data_new
cd data_new

# FAERS ASCII
if [ ${LOAD_NEW_YEAR} -le 2012 ]
then
    faers_or_laers='laers'
    fileyearquarter="${LOAD_NEW_YEAR: -2}${LOAD_NEW_QUARTER,,}"
    zip_url="https://fis.fda.gov/content/Exports/aers_ascii_${LOAD_NEW_YEAR}${LOAD_NEW_QUARTER,,}.zip"
    zip_filename="aers_ascii_${LOAD_NEW_YEAR}${LOAD_NEW_QUARTER,,}.zip"
else
    faers_or_laers='faers'
    fileyearquarter="${LOAD_NEW_YEAR: -2}${LOAD_NEW_QUARTER}"
    zip_url="https://fis.fda.gov/content/Exports/faers_ascii_${LOAD_NEW_YEAR}${LOAD_NEW_QUARTER}.zip"
    zip_filename="faers_ascii_${LOAD_NEW_YEAR}${LOAD_NEW_QUARTER}.zip"
fi

# Create year/quarter specific subdirectory
year_quarter_folder="${LOAD_NEW_YEAR}/Q${LOAD_NEW_QUARTER}"
mkdir -p "${year_quarter_folder}"

echo "Downloading from URL: ${zip_url}"
wget -O "${year_quarter_folder}/${zip_filename}" "${zip_url}" 2>&1

echo "Unzipping file: ${year_quarter_folder}/${zip_filename}"
unzip "${year_quarter_folder}/${zip_filename}" -d "${year_quarter_folder}" 2>> error.txt 1>> output.txt

# Rename and move the PDF file to the year/quarter folder
if [ -f "${year_quarter_folder}/ASCII/ASC_NTS.pdf" ]; then
    mv "${year_quarter_folder}/ASCII/ASC_NTS.pdf" "${year_quarter_folder}/ASC_NTS_${fileyearquarter}.pdf"
fi

# Optionally move other files if necessary
# mv "${year_quarter_folder}/FAQs.pdf" "${year_quarter_folder}/FAQs_${fileyearquarter}.pdf"
# mv "${year_quarter_folder}/Readme.pdf" "${year_quarter_folder}/Readme_${fileyearquarter}.pdf"

# Clean up unnecessary directories
rm -rf "${year_quarter_folder}/ASCII"
rm -rf "${year_quarter_folder}/asci"
rm -rf "${year_quarter_folder}/asii"

echo "Script complete. Files organized in ${year_quarter_folder}"
