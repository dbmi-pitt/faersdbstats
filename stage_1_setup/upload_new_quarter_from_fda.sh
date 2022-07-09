#!/bin/zsh
# 

#source "../../faers_config.config"
source "${BASE_FILE_DIR}/faers_config.config"

# cd "../../data_new"
cd "${BASE_FILE_DIR}/data_new"

fileyearquarter="${LOAD_NEW_YEAR: -2}""${LOAD_NEW_QUARTER}"

echo $fileyearquarter

cd ASCII

for i in *Q*; do 
    if [[ "$i" == "ASC_NTS"${fileyearquarter}".pdf" ]] ; then
        continue;
    else 
        echo will upload $i to;
        echo s3://napdi-cem-sandbox-files/data/faers/"${i:0:4:l}"/20"${i:4:2}"/"${i:6:2}"
        aws s3 cp $i s3://napdi-cem-sandbox-files/data/faers/"${i:0:4:l}"/20"${i:4:2}"/"${i:6:2}"/  
    fi
done 
