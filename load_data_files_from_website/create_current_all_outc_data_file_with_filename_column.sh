#!/bin/sh
##########################################################################
# create the combined outcome files with the filename appended as the last column
#
# LTS Computing LLC
##########################################################################

# load the outcome files
cd ascii

thefilenamenoprefix=outc12q4
thefilename="${thefilenamenoprefix}.txt"
# remove windows carriage return, add on the filename column name to the header line and add the filename as the last column on each line
sed 's/\r$//' "${thefilename}" | sed '1,1 s/$/\$filename/' | sed "2,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"

for year in $(seq 13 20); do
  for quarter in 1 2 3 4; do
    thefilenamenoprefix="OUTC${year}Q${quarter}"
    echo "processing ${thefilenamenoprefix}"
    thefilename="${thefilenamenoprefix}.txt"
    # remove windows carriage return, remove the header line and add the filename as the last column on each line
    sed 's/\r$//' "${thefilename}" | sed '1,1d' | sed "1,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"
  done
done

# concatenate all the outcome files with filenames together into a single file for loading
cat outc12q4_with_filename.txt OUTC*_with_filename.txt >all_outc_data_with_filename.txt
