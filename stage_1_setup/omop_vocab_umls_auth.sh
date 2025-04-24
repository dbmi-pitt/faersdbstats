#!/bin/bash

CONFIG_FILE="${BASE_FILE_DIR}/faers_config.config"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "❌ Config file not found at: $CONFIG_FILE" >&2
  exit 1
fi

source "$CONFIG_FILE"

if [[ -z "$OMOP_UMLS_API_KEY" ]]; then
  echo "❌ OMOP_UMLS_API_KEY is not set in $CONFIG_FILE" >&2
  exit 1
fi

if [[ -z "$OMOP_FILE_DIR" ]]; then
  echo "❌ OMOP_FILE_DIR is not set in $CONFIG_FILE" >&2
  exit 1
fi

if [[ ! -f "$OMOP_FILE_DIR/cpt.sh" ]]; then
  echo "❌ cpt.sh not found in $OMOP_FILE_DIR" >&2
  exit 1
fi

# Change into the vocabulary folder where cpt.sh and cpt4.jar are
cd "$OMOP_FILE_DIR" || {
  echo "❌ Failed to cd into $OMOP_FILE_DIR" >&2
  exit 1
}

# Call the unchanged cpt.sh
./cpt.sh "$OMOP_UMLS_API_KEY"
