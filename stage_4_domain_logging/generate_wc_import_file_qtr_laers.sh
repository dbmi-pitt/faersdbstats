#!/bin/bash

# Source the configuration file for LOG_FILENAME and other variables
source ../../faers_config.config

# Check if LOG_FILENAME is set
if [ -z "$LOG_FILENAME" ]; then
  echo "LOG_FILENAME is not set in the configuration file. Exiting."
  exit 1
fi

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

  # Loop through files in the current quarter directory
  for file in "$quarter_dir"/*.txt; do
    echo "$file"
    # Skip if no files are present
    [ -e "$file" ] || continue

      # Skip files that match *_staged_with_lfs_only.txt, old.txt, or ol.txt
      if [[ "$file" =~ _staged_with_lfs_only\.txt$ || "$file" =~ /old\.txt$ || "$file" =~ /ol\.txt$ ]]; then
          echo "Skipping file: $(basename "$file")"
        continue
      fi

        # Use the actual filename dynamically for the second column
        filename=$(basename "$file")

      # Set log_filename from config
      log_filename="$LOG_FILENAME"

        # Determine LAERS or FAERS (set to 'faers' for now)
        laers_or_faers="laers"

        # Get line count using wc -l
        wc_l_count=$(wc -l < "$file")

        # Append data to the output PSV file
      echo "$log_filename|$filename|$laers_or_faers|$yr|$qtr|$wc_l_count" >> "$OUTPUT_FILE"
      done
    done
done

echo "Import PSV file created: $OUTPUT_FILE"
