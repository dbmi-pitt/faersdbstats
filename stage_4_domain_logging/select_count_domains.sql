set search_path=faers;

DO $$
DECLARE
    rec RECORD;
    dynamic_table TEXT;
BEGIN
    FOR rec IN 
        SELECT * FROM z_qa_faers_wc_import_log
    LOOP
        -- Construct the dynamic table name with proper case
        dynamic_table := LOWER(LEFT(rec.filename, 4));

        -- Debugging: Print the generated query
        RAISE NOTICE 'Dynamic table: %, yr: %, qtr: %, filename: %', dynamic_table, rec.yr, rec.qtr, rec.filename;
        RAISE NOTICE 'Generated Query: UPDATE faers.z_qa_faers_wc_import_log 
              SET select_count_on_domain = (
                  SELECT COUNT(*) FROM %I WHERE yr = $1 AND qtr = $2
              )
              WHERE filename = $3 AND yr = $1 AND qtr = $2', dynamic_table;
        -- Execute the dynamic query
        EXECUTE format(
            'UPDATE z_qa_faers_wc_import_log 
             SET select_count_on_domain = (
                 SELECT COUNT(*) FROM %s WHERE yr = $1 AND qtr = $2
             )
             WHERE filename = $3 AND yr = $1 AND qtr = $2',
             dynamic_table
        )
        USING rec.yr, rec.qtr, rec.filename;
    END LOOP;
END $$;