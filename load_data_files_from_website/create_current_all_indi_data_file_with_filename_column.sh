#!/bin/sh
##########################################################################
# create the combined indication files with the filename appended as the last column
#
# LTS Computing LLC
##########################################################################

# load the indication files

cd ascii

thefilenamenoprefix=indi12q4
thefilename="${thefilenamenoprefix}.txt"
# remove windows carriage return, add on the filename column name to the header line and add the filename as the last column on each line
sed 's/\r$//' "${thefilename}" | sed '1,1 s/$/\$filename/' | sed "2,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"

thisyear=$(date +"%y")
for year in $(seq 13 "${thisyear}"); do
  for quarter in 1 2 3 4; do
    thefilenamenoprefix="INDI${year}Q${quarter}"
    echo "processing ${thefilenamenoprefix}"
    thefilename="${thefilenamenoprefix}.txt"
    # remove windows carriage return, remove the header line and add the filename as the last column on each line
    sed 's/\r$//' "${thefilename}" | sed '1,1d' | sed "1,$ s/$/\$${thefilename}/" >"${thefilenamenoprefix}_with_filename.txt"
  done
done

# concatenate all the indication files with filenames together into a single file for loading
cat indi12q4_with_filename.txt INDI*_with_filename.txt >all_indi_data_with_filename.txt
