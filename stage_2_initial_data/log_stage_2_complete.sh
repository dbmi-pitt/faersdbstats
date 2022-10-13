#!/bin/bash
log_location=${BASE_FILE_DIR}/logs/${LOG_FILENAME}
printf '\n' >> $log_location
echo "#######################################################" >> $log_location
echo "################ STAGE 2 COMPLETE #####################" >> $log_location
echo "#######################################################" >> $log_location
printf '\n\n' >> $log_location
echo '*note: if LOAD_ALL_DATA=1 run BOTH Ss and STAGE 4S' >> $log_location
echo '...also bulk of STAGE_3s and STAGE_4s transforms logging is handled at beginning of stage 5' >> $log_location
printf '\n\n' >> $log_location