#!/bin/sh
##########################################################################
# create the combined reaction files with the filename appended as the last column
# NOTE the reaction file formats are in two versions
# We will call the file format before 2014 Q3 version A and everything from 2014 Q3 onwards, version B
#
# LTS Computing LLC
##########################################################################

# load the reaction files

# file format version A
cd ascii

thefilenamenoprefix=reac12q4
thefilename="${thefilenamenoprefix}.txt"
# remove windows carriage return, add on the filename column name to the header line and add the filename as the last column on each line
sed 's/\r$//' "${thefilename}"| sed '1,1 s/$/\$filename/' | sed "2,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"

for year in $(seq 13 20); do
  for quarter in 1 2 3 4; do
    thefilenamenoprefix="REAC${year}Q${quarter}"
    echo "processing ${thefilenamenoprefix}"
    thefilename="${thefilenamenoprefix}.txt"
    # remove windows carriage return, remove the header line and add the filename as the last column on each line
    sed 's/\r$//' "${thefilename}" | sed '1,1d' | sed "1,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"
  done
done

# concatenate all the version A reaction files with filenames together into a single file for loading
cat reac12q4_with_filename.txt REAC13Q1_with_filename.txt REAC13Q2_with_filename.txt REAC13Q3_with_filename.txt \
  REAC13Q4_with_filename.txt REAC14Q1_with_filename.txt REAC14Q2_with_filename.txt >all_version_A_reac_data_with_filename.txt

# concatenate all the version B reaction files with filenames together into a single file for loading
cat REAC14Q3_with_filename.txt REAC14Q4_with_filename.txt REAC15*_with_filename.txt REAC16*_with_filename.txt \
  REAC17*_with_filename.txt REAC18*_with_filename.txt REAC19*_with_filename.txt REAC20*_with_filename.txt >all_version_B_reac_data_with_filename.txt
