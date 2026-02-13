
DO $$
DECLARE
    rec RECORD;
    domain TEXT;
    rowcount INTEGER;
BEGIN
    FOR rec IN
        SELECT * FROM z_qa_faers_wc_import_log
    LOOP
        -- Extract domain from the filename (first 4 letters, lowercase)
        domain := LOWER(LEFT(rec.filename, 4));
        -- first consider rpsr only
        -- IF domain IN ('rpsr') THEN
        -- ...then do the rest of the domains
	  	  -- IF domain IN ('demo', 'drug', 'indi', 'outc', 'reac', 'ther') THEN
        -- or you can do call domains
      IF domain IN ('demo', 'drug', 'indi', 'outc', 'reac', 'rpsr', 'ther') THEN
            -- Only proceed if select_count_on_domain is 0 or NULL and yr < 25
                IF (rec.select_count_on_domain IS NULL OR rec.select_count_on_domain = 0) AND rec.yr < 25 THEN
                -- Debugging output
                RAISE NOTICE 'Processing table: %, yr: %, qtr: %, filename: %', domain, rec.yr, rec.qtr, rec.filename;
                -- Build and execute the dynamic query
                EXECUTE format(
                    'UPDATE z_qa_faers_wc_import_log
                        SET select_count_on_domain = (
                            SELECT COUNT(*) FROM %I_legacy
                              WHERE yr = $1 AND qtr = $2
                        )
                      WHERE LOWER(filename) = LOWER($3) AND
                                                yr = $1 AND
                                                qtr = $2 AND
                                                (select_count_on_domain IS NULL
                                                    OR
                                                select_count_on_domain = 0) AND
                                                yr < 25',
                    domain  -- injects table name safely as identifier
                )
                USING rec.yr, rec.qtr, rec.filename;
                -- Get and show number of rows updated
                GET DIAGNOSTICS rowcount = ROW_COUNT;
                RAISE NOTICE 'Rows updated: %', rowcount;
            ELSE
                -- Skip rows where select_count_on_domain is already populated or yr < 12
                RAISE NOTICE 'Skipping already populated or wrong year: %, yr: %, qtr: %, filename: %', domain, rec.yr, rec.qtr, rec.filename;
            END IF;
        ELSE
            RAISE NOTICE 'Skipping table: %', domain;
        END IF;
    END LOOP;
END $$;
