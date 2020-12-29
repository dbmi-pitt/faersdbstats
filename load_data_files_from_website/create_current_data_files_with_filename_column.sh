#!/bin/sh

echo "Starting"

echo "processing demo data"
sh ./create_current_all_demo_data_files_with_filename_column.sh

echo "processing drug data"
sh ./create_current_all_drug_data_files_with_filename_column.sh

echo "processing indi data"
sh ./create_current_all_indi_data_file_with_filename_column.sh

echo "processing outc data"
sh ./create_current_all_outc_data_file_with_filename_column.sh

echo "processing reac data"
sh ./create_current_all_reac_data_files_with_filename_column.sh

echo "processing rpsr data"
sh ./create_current_all_rpsr_data_file_with_filename_column.sh

echo "processing ther data"
sh ./create_current_all_ther_data_file_with_filename_column.sh

echo "Finished"
