#!/bin/bash
# This script downloads all the current ASCII format FAERS files from the FDA website
# and organizes the PDF files into their own year/quarter subfolders.
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
# Ensure ${LOAD_NEW_QUARTER} does not include an extra "Q"
if [[ ! ${LOAD_NEW_QUARTER} =~ ^Q ]]; then
    quarter_prefix="Q${LOAD_NEW_QUARTER}"
else
    quarter_prefix="${LOAD_NEW_QUARTER}"
fi
year_quarter_folder="${LOAD_NEW_YEAR}/${quarter_prefix}"
mkdir -p "${year_quarter_folder}"

echo "Downloading from URL: ${zip_url}"
wget -O "${year_quarter_folder}/${zip_filename}" "${zip_url}" 2>&1

echo "Unzipping file: ${year_quarter_folder}/${zip_filename}"
unzip "${year_quarter_folder}/${zip_filename}" -d "${year_quarter_folder}" 2>> error.txt 1>> output.txt

# Rename and move the PDF file to the year/quarter folder
pdf_files=$(find "${year_quarter_folder}" -type f -name "*.pdf")
for pdf_file in $pdf_files; do
    pdf_basename=$(basename "$pdf_file")
    new_pdf_filename="${year_quarter_folder}/${pdf_basename%.*}_${fileyearquarter}.pdf"
    echo "Renaming and moving PDF: ${pdf_file} -> ${new_pdf_filename}"
    mv "$pdf_file" "$new_pdf_filename"
done

# Optionally move other files if necessary
# doc_files=$(find "${year_quarter_folder}" -type f -name "*.doc")
# for doc_file in $doc_files; do
#     doc_basename=$(basename "$doc_file")
#     new_doc_filename="${year_quarter_folder}/${doc_basename%.*}_${fileyearquarter}.doc"
#     echo "Renaming and moving DOC: ${doc_file} -> ${new_doc_filename}"
#     mv "$doc_file" "$new_doc_filename"
# done

# Clean up unnecessary directories
rm -rf "${year_quarter_folder}/ASCII"
rm -rf "${year_quarter_folder}/asci"
rm -rf "${year_quarter_folder}/asii"

echo "Script complete. PDF files organized in ${year_quarter_folder}"
