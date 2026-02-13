#!/usr/bin/env bash
# Utility for classifying laers vs faers in a consistent, config-aware way.
#
# It uses optional config variables:
#   LAERS_LAST_YEAR (default 2012)
#   LAERS_LAST_QTR  (default 3)
# and falls back to directory name heuristics if available.

# If caller has already sourced faers_config.config, these may be set there.
LAERS_LAST_YEAR=${LAERS_LAST_YEAR:-2012}
LAERS_LAST_QTR=${LAERS_LAST_QTR:-3}

# Given 2-digit year and integer quarter, return laers|faers using cutoff.
classify_laers_or_faers_by_yq() {
  local yr2=$1
  local qtr=$2
  # Convert 2-digit year to 4-digit (2000-based)
  local y4=$((2000 + yr2))
  if (( y4 < LAERS_LAST_YEAR )) || { (( y4 == LAERS_LAST_YEAR )) && (( qtr <= LAERS_LAST_QTR )); }; then
    echo "laers"
  else
    echo "faers"
  fi
}

# Use directory name if it clearly encodes laers/faers; otherwise fall back to Y/Q cutoff.
classify_by_path_or_yq() {
  local base_dir="$1"
  local yr2="$2"
  local qtr="$3"
  if [[ "$base_dir" == */laers/* ]]; then
    echo "laers"
  elif [[ "$base_dir" == */faers/* ]]; then
    echo "faers"
  else
    classify_laers_or_faers_by_yq "$yr2" "$qtr"
  fi
}
