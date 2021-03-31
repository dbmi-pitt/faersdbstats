-- With this file we load the deleted cases as merged in create_deleted_data_file.sh into a lookup table
-- Then based on this list all deleted cases are deleted ;-)
-- Run this after all the tables are loaded.


SET SEARCH_PATH = faers;

DROP TABLE IF EXISTS deleted_cases;
CREATE TABLE deleted_cases
(
    caseid INTEGER NOT NULL
);

COPY deleted_cases FROM '/Users/rowan/code/faersdbstats_emc/load_data_files_from_website/deleted/all_deleted_cases.txt' WITH DELIMITER E'$' CSV HEADER QUOTE E'\b';

-- Delete all deleted case from the db
DELETE FROM demo
WHERE caseid IN (SELECT caseid::varchar FROM deleted_cases);
DELETE FROM drug
WHERE caseid IN (SELECT caseid::varchar FROM deleted_cases);
DELETE FROM indi
WHERE caseid IN (SELECT caseid::varchar FROM deleted_cases);
DELETE FROM outc
WHERE caseid IN (SELECT caseid::varchar FROM deleted_cases);
DELETE FROM reac
WHERE caseid IN (SELECT caseid::varchar FROM deleted_cases);
DELETE FROM rpsr
WHERE caseid IN (SELECT caseid::varchar FROM deleted_cases);
DELETE FROM ther
WHERE caseid IN (SELECT caseid::varchar FROM deleted_cases);

DELETE FROM drug_legacy
WHERE isr IN (SELECT isr FROM demo_legacy WHERE "CASE" IN (SELECT caseid::varchar FROM deleted_cases));
DELETE FROM indi_legacy
WHERE isr IN (SELECT isr FROM demo_legacy WHERE "CASE" IN (SELECT caseid::varchar FROM deleted_cases));
DELETE FROM outc_legacy
WHERE isr IN (SELECT isr FROM demo_legacy WHERE "CASE" IN (SELECT caseid::varchar FROM deleted_cases));
DELETE FROM reac_legacy
WHERE isr IN (SELECT isr FROM demo_legacy WHERE "CASE" IN (SELECT caseid::varchar FROM deleted_cases));
DELETE FROM rpsr_legacy
WHERE isr IN (SELECT isr FROM demo_legacy WHERE "CASE" IN (SELECT caseid::varchar FROM deleted_cases));
DELETE FROM ther_legacy
WHERE isr IN (SELECT isr FROM demo_legacy WHERE "CASE" IN (SELECT caseid::varchar FROM deleted_cases));

DELETE FROM demo_legacy
WHERE "CASE" IN (SELECT caseid::varchar FROM deleted_cases);
