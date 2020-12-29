#!/bin/sh
##########################################################################
# create combined drug files with the filename appended as the last column
# NOTE the drug file formats are in two versions
# We will call the file format before 2014 Q3 version A and everything from 2014 Q3 onwards, version B
#
# LTS Computing LLC
##########################################################################

# load the drug files

# file format version A

cd ascii

thefilenamenoprefix=drug12q4
thefilename="${thefilenamenoprefix}.txt"
# remove windows carriage return, add on the filename column name to the header line and add the filename as the last column on each line
sed 's/\r$//' "${thefilename}"| sed '1,1 s/$/\$filename/' | sed "2,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"

for year in $(seq 13 20); do
  for quarter in 1 2 3 4; do
    thefilenamenoprefix="DRUG${year}Q${quarter}"
    echo "processing ${thefilenamenoprefix}"
    thefilename="${thefilenamenoprefix}.txt"
    # remove windows carriage return, remove the header line and add the filename as the last column on each line
    sed 's/\r$//' "${thefilename}" | sed '1,1d' | sed "1,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"
  done
done

# concatenate all the version A drug files with filenames together into a single file for loading
cat drug12q4_with_filename.txt DRUG13Q1_with_filename.txt DRUG13Q2_with_filename.txt DRUG13Q3_with_filename.txt \
  DRUG13Q4_with_filename.txt DRUG14Q1_with_filename.txt DRUG14Q2_with_filename.txt >all_version_A_drug_data_with_filename.txt

echo "Concatting all files into a single file, may take a minute..."
# concatenate all the version B drug files with filenames together into a single file for loading
cat DRUG14Q3_with_filename.txt DRUG14Q4_with_filename.txt DRUG15*_with_filename.txt DRUG16*_with_filename.txt \
  DRUG17*_with_filename.txt DRUG18*_with_filename.txt DRUG19*_with_filename.txt \
  DRUG20*_with_filename.txt >all_version_B_drug_data_with_filename.txt

# remove replace non utf8 characters form sourcefile with something similar.
# This small java app was built using junidecode 0.3.0 https://github.com/gcardone/junidecode
mv ../illigal-char-cleaner-1.0.jar .
java -jar illigal-char-cleaner-1.0.jar all_version_B_drug_data_with_filename.txt
mv illigal-char-cleaner-1.0.jar ../

echo "done!"
