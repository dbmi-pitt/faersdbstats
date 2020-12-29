#!/bin/sh
##########################################################################
# create the combined demographic files with the filename appended as the last column
# NOTE the demographic file formats are in two versions
# We will call the file format before 2014 Q3 version A and everything from 2014 Q3 onwards, version B
#
# LTS Computing LLC
##########################################################################

# load the demographic files

# file format version A

cd ascii

thefilenamenoprefix=demo12q4
thefilename="${thefilenamenoprefix}.txt"
# remove windows carriage return, add on the filename column name to the header line and add the filename as the last column on each line
sed 's/\r$//' "${thefilename}"| sed '1,1 s/$/\$filename/' | sed "2,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"

#Non conform file name
thefilenamenoprefix="DEMO18Q1"
echo "processing ${thefilenamenoprefix}"
thefilename="DEMO18Q1_new.txt"
# remove windows carriage return, remove the header line and add the filename as the last column on each line
sed 's/\r$//' "${thefilename}"| sed '1,1d' | sed "1,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"

for year in $(seq 13 20); do
  for quarter in 1 2 3 4; do
    thefilenamenoprefix="DEMO${year}Q${quarter}"
    echo "processing ${thefilenamenoprefix}"
    thefilename="${thefilenamenoprefix}.txt"
    # remove windows carriage return, remove the header line and add the filename as the last column on each line
    sed 's/\r$//' "${thefilename}" | sed '1,1d' | sed "1,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"
  done
done

# concatenate all the version A demo files with filenames together into a single file for loading
cat demo12*_with_filename.txt DEMO13*_with_filename.txt DEMO14Q1_with_filename.txt DEMO14Q2_with_filename.txt >all_version_A_demo_data_with_filename.txt

# concatenate all the version B demo files with filenames together into a single file for loading
cat DEMO14Q3_with_filename.txt DEMO14Q4_with_filename.txt DEMO15*_with_filename.txt DEMO16*_with_filename.txt \
  DEMO17*_with_filename.txt DEMO18*_with_filename.txt DEMO19*_with_filename.txt \
  DEMO20*_with_filename.txt >all_version_B_demo_data_with_filename.txt
