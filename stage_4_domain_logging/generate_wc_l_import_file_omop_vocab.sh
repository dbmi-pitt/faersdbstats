#!/bin/bash
# /home/pentaho-secondary/projects-brb265-2024/faersdbstats/faersdbstats/stage_4_domain_logging/generate_wc_l_import_file_omop_vocab.sh

# Load shared config
source ../../faers_config.config

# Use a specific directory where OMOP vocab files live
BASE_FILE_DIR="$OMOP_FILE_DIR"

# Output location
OUTPUT_DIR="$BASE_FILE_DIR/qa"
OUTPUT_FILE="$OUTPUT_DIR/omop_vocab_wc_import.psv"

# Ensure the directory exists
if [ ! -d "$BASE_FILE_DIR" ]; then
  echo "❌ Base directory does not exist: $BASE_FILE_DIR"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

# Overwrite header row
echo "log_filename|filename|laers_or_faers|yr|qtr|wc_l_count" > "$OUTPUT_FILE"

# Static metadata for this vocab import
laers_or_faers="staging_vo"
yr=2025
qtr=1

# Ensure log filename is set
if [ -z "$LOG_FILENAME" ]; then
  echo "LOG_FILENAME is not set in the configuration file. Exiting."
  exit 1
fi

# Loop through all .csv files in the vocab directory
for file in "$BASE_FILE_DIR"/*.csv; do
  [ -e "$file" ] || continue

  filename=$(basename "$file")

  # Skip backup or helper files
  if [[ "$filename" =~ _head\.csv$ || "$filename" =~ _no_nulls\.csv$ ]]; then
    echo "Skipping helper file: $filename"
    continue
  fi

  wc_l_count=$(($(wc -l < "$file") - 1))
  echo "$LOG_FILENAME|$filename|$laers_or_faers|$yr|$qtr|$wc_l_count" >> "$OUTPUT_FILE"
done

echo "✅ OMOP vocab wc-l import PSV created: $OUTPUT_FILE"
