#!/bin/bash
# /home/pentaho-secondary/projects-brb265-2024/faersdbstats/faersdbstats/stage_1_setup/faersdbstats_data_test_scripts/download_faers_fda_data_fix.sh

# Source the configuration file
source ../../../faers_config.config

echo "DATABASE_BACKUP_LOCATION is :$DATABASE_BACKUP_LOCATION"

# Set globstar options
shopt -s globstar 
shopt globstar

# Create the main directory
if [ ! -d ${DATABASE_BACKUP_LOCATION}/faersdbstats_data_test ]; then
    mkdir -p ${DATABASE_BACKUP_LOCATION}/faersdbstats_data_test
fi

cd ${DATABASE_BACKUP_LOCATION}/faersdbstats_data_test/
dir_above_laers_or_faers=$(pwd)

for laers_faers in faers; do 
    mkdir -p $dir_above_laers_or_faers/$laers_faers

    cd $dir_above_laers_or_faers/$laers_faers

    for THIS_YEAR in 2024; do
        for THIS_QUARTER in Q1 Q2 Q3; do
            echo "Processing $laers_faers - ${THIS_YEAR} - ${THIS_QUARTER}"
            
            zip_url="https://fis.fda.gov/content/Exports/faers_ascii_${THIS_YEAR}q${THIS_QUARTER:1}.zip"
            zip_filename_loc="${dir_above_laers_or_faers}/faers_ascii_${THIS_YEAR}q${THIS_QUARTER:1}.zip"

            # Download the ZIP file (only once)
            if [ ! -f "$zip_filename_loc" ]; then
                echo "Downloading: $zip_url"
                wget $zip_url --no-clobber -O "$zip_filename_loc" 2>&1
            else
                echo "File already exists: $zip_filename_loc"
            fi

            if [ -f "$zip_filename_loc" ]; then
                unzip_dir="${dir_above_laers_or_faers}/unzipped/${THIS_YEAR}/Q${THIS_QUARTER:1}"
                mkdir -p "$unzip_dir"

                echo "Unzipping $zip_filename_loc to $unzip_dir"
                unzip -n "$zip_filename_loc" -d "$unzip_dir" 2>> error.txt 1>> output.txt

                if [ $? -ne 0 ]; then
                    echo "ERROR: Failed to unzip $zip_filename_loc"
                    exit 1
                fi
            else
                echo "ERROR: ZIP file not found: $zip_filename_loc"
                exit 1
            fi

            # Process files for each domain
            source_dir="$unzip_dir/ASCII"
            if [ -d "$source_dir" ]; then
                echo "Processing files from $source_dir"

                for domain in demo drug indi outc reac rpsr ther; do
                    target_dir="$dir_above_laers_or_faers/$laers_faers/$domain/${THIS_YEAR}/Q${THIS_QUARTER:1}"
                    mkdir -p "$target_dir"

                    domain_file_pattern="${domain^^}${THIS_YEAR:2}${THIS_QUARTER}.*"

                    echo "Looking for $domain_file_pattern in $source_dir"
                    files_found=$(find "$source_dir" -type f -name "$domain_file_pattern")

                    if [ -n "$files_found" ]; then
                        for file in $files_found; do
                            echo "Moving $file to $target_dir"
                            mv "$file" "$target_dir/"
                        done
                    else
                        echo "No files found for domain: $domain in $source_dir"
                    fi
                done
            else
                echo "ERROR: Expected directory does not exist: $source_dir"
            fi

        done # End quarter loop
    done # End year loop

    cd $dir_above_laers_or_faers

done # End laers_faers loop