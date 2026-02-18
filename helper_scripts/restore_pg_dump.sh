#!/usr/bin/env bash
# /home/pentaho-secondary/projects-brb265-2024/faersdbstats/faersdbstats/helper_scripts/restore_pg_dump.sh
# Logs: ./logs/ (relative to this script directory)

set -u

DUMP="/media/large-backup-drive/pentaho-secondary-extension/cem_development_2025_LOG-Oct-2025-QA-V11-load-2025-Q1-test_stg_1_auto_bk_fcd_02122026.dump"
DB="cem_development_2026"
HOST="localhost"
PORT="5433"
USER="postgres"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGDIR="$SCRIPT_DIR/logs"
mkdir -p "$LOGDIR"

TS="$(date +%Y%m%d_%H%M%S)"
OUTLOG="$LOGDIR/${DB}_restore_${TS}.out.log"
ERRLOG="$LOGDIR/${DB}_restore_${TS}.err.log"

echo "Starting restore at: $(date)"
echo "Dump: $DUMP"
echo "Target: $USER@$HOST:$PORT/$DB"
echo "STDOUT log: $OUTLOG"
echo "STDERR log: $ERRLOG"
echo

# Kill connections, drop, recreate (DB is disposable)
psql -h "$HOST" -U "$USER" -p "$PORT" -d postgres -v ON_ERROR_STOP=1 -c "
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = '${DB}' AND pid <> pg_backend_pid();
" 1>>"$OUTLOG" 2>>"$ERRLOG"

dropdb   -h "$HOST" -U "$USER" -p "$PORT" "$DB" 1>>"$OUTLOG" 2>>"$ERRLOG"
createdb -h "$HOST" -U "$USER" -p "$PORT" "$DB" 1>>"$OUTLOG" 2>>"$ERRLOG"

# Restore: pg_restore 17 reads the dump; strip transaction_timeout for PG14; continue on errors
(
  pg_restore -f - "$DUMP" \
  | sed '/^[[:space:]]*SET[[:space:]]\+transaction_timeout[[:space:]]*=.*/d' \
  | psql -h "$HOST" -U "$USER" -p "$PORT" -d "$DB"
) 1>>"$OUTLOG" 2>>"$ERRLOG"

echo
echo "Finished at: $(date)"
echo "STDOUT log: $OUTLOG"
echo "STDERR log: $ERRLOG"
