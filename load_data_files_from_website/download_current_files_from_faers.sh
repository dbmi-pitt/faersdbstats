#!/bin/sh
# this script downloads all the current (starting 2012q4) ASCII format FAERS files from the FDA website
# as of December 8th 2020.
#
# LTS Computing LLC
#
# When adding new FEARS files to the project add something like this to the bottom of the file
# wget https://fis.fda.gov/content/Exports/faers_ascii_2020Q4.zip
# mv faers_ascii_2020Q4.zip faers_data_files/
# -o unzip faers_ascii_2020Q4.zip
#
# When you are done and the .zip file is in the faers_data_files folder remove the code
#
# Alternatively download them manually and place them in the data files folder
#
#
################################################################

mkdir -p "ascii"

for report in ./faers_data_files/*.zip; do
  echo "unzipping ${report}"
  # -o because the readme, faqs and asc_nts files can be overwritten we don't need them
  unzip -o $report -d .
done

# Add commands for files to be downloaded here...

# cleanup from miscellaneous sub-directory names
mv ASCII/* ascii
mv asci/* ascii
mv asii/* ascii
rmdir ASCII
rmdir asci
rmdir asii

# Remove unwanted files
rm FAQs.doc
rm FAQs.pdf
rm Readme.doc
rm Readme.pdf
