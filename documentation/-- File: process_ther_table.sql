-- File: process_ther_table.sql
-- Path: /path/to/sql/scripts/

SET search_path = faers;

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN 
        SELECT * FROM z_qa_faers_wc_import_log
    LOOP
        -- Process only if the dynamic table is 'ther'
        IF LOWER(LEFT(rec.filename, 4)) = 'ther' THEN
            -- Debugging: Print the generated query
            RAISE NOTICE 'Dynamic table: ther, yr: %, qtr: %, filename: %', rec.yr, rec.qtr, rec.filename;

            RAISE NOTICE 'Generated Query: UPDATE z_qa_faers_wc_import_log 
                  SET select_count_on_domain = (
                      SELECT COUNT(*) FROM ther WHERE yr = $1 AND qtr = $2
                  )
                  WHERE filename = $3 AND yr = $1 AND qtr = $2';

            -- Execute the dynamic query
            EXECUTE format(
                'UPDATE z_qa_faers_wc_import_log 
                 SET select_count_on_domain = (
                     SELECT COUNT(*) FROM ther WHERE yr = $1 AND qtr = $2
                 )
                 WHERE filename = $3 AND yr = $1 AND qtr = $2'
            )
            USING rec.yr, rec.qtr, rec.filename;
        ELSE
            -- Skip if the table is not 'ther'
            RAISE NOTICE 'Skipping table: %', LOWER(LEFT(rec.filename, 4));
        END IF;
    END LOOP;
END $$;
