#!/bin/bash
./download_current_files_from_faers.sh
./download_legacy_files_from_faers.sh
./create_current_data_files_with_filename_column.sh
./create_legacy_data_files_with_filename_column.sh
./create_deleted_data_file.sh