-- validate_z_qa_vars.sql
-- Usage: psql -h host -U user -d db -f validate_z_qa_vars.sql
-- This script checks whether there are rows in the QA import log with NULL yr or qtr
-- and returns a non-zero exit code if any are found (useful for CI or ETL QA).

WITH null_yr_qtr AS (
  SELECT COUNT(*) AS null_count FROM vigi_qa.z_qa_wc_import_log WHERE yr IS NULL OR qtr IS NULL
)
SELECT
  CASE WHEN (SELECT null_count FROM null_yr_qtr) > 0 THEN
    (RAISE NOTICE 'NULL year/qtr found in vigi_qa.z_qa_wc_import_log: %', (SELECT null_count FROM null_yr_qtr))
  ELSE
    (RAISE NOTICE 'No NULL yr/qtr in vigi_qa.z_qa_wc_import_log')
  END;

-- For shell: exit with status 1 if any null rows exist
\set null_count `psql -At -c "SELECT COUNT(*) FROM vigi_qa.z_qa_wc_import_log WHERE yr IS NULL OR qtr IS NULL"`
\echo :null_count
\if :null_count <> '0'
\echo 'ERROR: NULL values exist in vigi_qa.z_qa_wc_import_log'
\! exit 1
\else
\echo 'OK: No NULL values in vigi_qa.z_qa_wc_import_log'
\! exit 0
\endif
