#!/bin/sh
# this script unzips (and if needed also downloads) all the legacy ASCII format FAERS files from the FDA website
# from the first 2004Q1 until 2012Q3 (last updated 8 December 2020)
#
# LTS Computing LLC
################################################################

for year in $(seq 2004 2012); do
  for quarter in 1 2 3 4; do
    fileyearquarter="${year}Q${quarter}"
    if [ "${fileyearquarter}" = "2012Q4" ]; then
      echo "Done with the legacy files"
      exit 0
    fi
    echo "processing ${fileyearquarter}"
#   If you still need to download the files uncomment this line
#   curl -L -O https://fis.fda.gov/content/Exports/aers_ascii_${fileyearquarter}.zip
    unzip aers_ascii_${fileyearquarter}.zip
    rm README.doc
    rm SIZE*.TXT
    rm ascii/Asc_nts.doc
  done
done
