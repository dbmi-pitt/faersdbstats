#!/usr/bin/env bash
# check_and_source_config.sh
# Usage: check_and_source_config.sh <config_path> [VAR1,VAR2,...]
# Example: check_and_source_config.sh ../../faers_config.config LOAD_NEW_YEAR,LOAD_NEW_QUARTER
# - sources the given config file
# - verifies the file exists and is readable
# - optionally checks that a comma-separated set of environment variables is set
# - prints values of requested variables to the log for debugging
# - exits non-zero if any required checks fail

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <config_path> [comma_sep_var_list]"
  exit 2
fi

CONFIG_PATH="$1"
REQUIRED_VARS_RAW="${2:-}"

if [ ! -f "$CONFIG_PATH" ]; then
  echo "ERROR: Config not found at: $CONFIG_PATH" >&2
  exit 3
fi

# Source the config
# Use 'set -a' to export functions and variables so that they are visible to child processes
set -a
. "$CONFIG_PATH"
set +a

# Validate the required variables if they are provided
if [ -n "$REQUIRED_VARS_RAW" ]; then
  IFS=','; read -ra reqvars <<< "$REQUIRED_VARS_RAW"; unset IFS
  MISSING=0
  for v in "${reqvars[@]}"; do
    if [ -z "${!v:-}" ]; then
      echo "ERROR: Required variable '$v' not set after sourcing '$CONFIG_PATH'" >&2
      MISSING=1
    fi
  done
  if [ "$MISSING" -ne 0 ]; then
    echo "One or more required variables missing - aborting" >&2
    exit 4
  fi
fi

# Print key variables for debugging; helpful when Pentaho shell steps crop up in logs
echo "Sourced config: $CONFIG_PATH"
if [ -n "$REQUIRED_VARS_RAW" ]; then
  echo "Stamped vars from config:" >&2
  IFS=','; read -ra reqvars <<< "$REQUIRED_VARS_RAW"; unset IFS
  for v in "${reqvars[@]}"; do
    echo "  $v=${!v:-<unset>}" >&2
  done
fi

exit 0
