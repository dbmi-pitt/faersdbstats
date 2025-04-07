#!/bin/bash
# /home/pentaho-secondary/projects-brb265-2024/faersdbstats/faersdbstats/stage_4_domain_logging/generate_wc_l_import_file_rpsr.sh
source ../../faers_config.config

# Base directory for all years of data
BASE_FILE_DIR="$BASE_FILE_DIR/data_from_s3/laers/rpsr"

# Output file for all years
OUTPUT_DIR="$BASE_FILE_DIR/qa"
OUTPUT_FILE="$OUTPUT_DIR/rpsr_wc_import.psv"

# Ensure the base directory exists (and stop execution if not found)
if [ ! -d "$BASE_FILE_DIR" ]; then
  echo "Base directory does not exist: $BASE_FILE_DIR"
  exit 1
fi

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Write header row to the output file (overwrites if it already exists)
echo "log_filename|filename|laers_or_faers|yr|qtr|wc_l_count" > "$OUTPUT_FILE"

# Ensure the LOG_FILENAME variable is set in the config file
if [ -z "$LOG_FILENAME" ]; then
  echo "LOG_FILENAME is not set in the configuration file. Exiting."
  exit 1
fi

# Loop through each year directory (e.g., 2024, 2025)
for year_dir in "$BASE_FILE_DIR"/*; do
  # Skip if not a directory
  [ -d "$year_dir" ] || continue

  # Extract year (YYYY format)
  yr=$(basename "$year_dir")

  # Convert year to two-digit format (YY)
  yr=$((yr % 100))

  # Loop through each quarter (Q* directories)
  for quarter_dir in "$year_dir"/Q*; do
  # Skip if not a directory
  [ -d "$quarter_dir" ] || continue

  # Extract quarter (e.g., 'Q1') and convert to integer (1, 2, 3, 4)
  qtr=$(basename "$quarter_dir" | sed 's/Q//')
  

  echo "Processing quarter directory: $quarter_dir"

  # Loop through files in the current quarter directory
  for file in "$quarter_dir"/*.txt; do
    # Skip if no files are present
    [ -e "$file" ] || continue

      # Skip certain filenames
      filename=$(basename "$file")
      if [[ "$filename" =~ _staged_with_lfs_only\.txt$ || "$filename" =~ ^old\.txt$ || "$filename" =~ ^ol\.txt$ ]]; then
        echo "Skipping file: $filename"
        continue
      fi

      # double check log_filename is still set
      log_filename="$LOG_FILENAME"
      if [ -z "$log_filename" ]; then
        echo "Error: log_filename is unset while processing $filename. Skipping."
        continue
      fi

      # Line count, minus 1 for header
      wc_l_count=$(($(wc -l < "$file") - 1))

    # Determine LAERS or FAERS (set to 'faers' for now)
    laers_or_faers="laers"

    # Append data to the output PSV file
    echo "$log_filename|$filename|$laers_or_faers|$yr|$qtr|$wc_l_count" >> "$OUTPUT_FILE"
  done
done
done

echo "Import PSV file created: $OUTPUT_FILE"
