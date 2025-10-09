-- Adds column comments for FAERS and vocabulary tables only if a comment does NOT already exist.
-- Execute after creating tables in entire_database_extracted_create_tables.sql.
-- ${DATABASE_SCHEMA} will be substituted by Pentaho before executing.
-- Uses a helper function set_comment_if_absent(schema, table, column, comment_text).

BEGIN;

CREATE OR REPLACE FUNCTION set_comment_if_absent(
        p_schema  text,
        p_table   text,
        p_column  text,
        p_comment text
) RETURNS void LANGUAGE plpgsql AS $$
DECLARE
        existing text;
BEGIN
        SELECT pgd.description
            INTO existing
            FROM pg_catalog.pg_statio_all_tables st
            JOIN pg_catalog.pg_description pgd ON (pgd.objoid = st.relid)
            JOIN pg_catalog.pg_attribute pga ON (pga.attrelid = st.relid AND pga.attnum = pgd.objsubid)
            WHERE st.schemaname = p_schema
              AND st.relname = p_table
              AND pga.attname = p_column;

        IF existing IS NULL THEN
            EXECUTE format('COMMENT ON COLUMN %I.%I.%I IS %L', p_schema, p_table, p_column, p_comment);
        END IF;
END;
$$;

/* =========================
     Helper macro style note:
     ${DATABASE_SCHEMA} variable will be expanded by Pentaho.
*/


/* =========================
   FAERS CASE / DEMO TABLES
   ========================= */
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','database','Database source identifier (e.g., FAERS, LAERS)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','caseid','Case identifier - groups related reports');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','isr','Individual Safety Report identifier');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','caseversion','Version number of the case report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','i_f_code','Initial/Follow-up code (I=Initial, F=Follow-up)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','event_dt','Date when the adverse event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','age','Age of the patient when event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','sex','Gender/sex of the patient (M/F/U)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','reporter_country','Country code of the reporter');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','primaryid','Primary unique identifier for the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','drugname_list','Concatenated list of all drug names in the case');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','reac_pt_list','Concatenated list of all reaction preferred terms');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','fda_dt','Date FDA received the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','all_casedemo','imputed_field_name','Name of field that was imputed if any');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','caseid','Case identifier - groups related reports');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','caseversion','Version number of the case report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','i_f_code','Initial/Follow-up code (I=Initial, F=Follow-up)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','event_dt','Date when the adverse event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','age','Age of the patient when event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','sex','Gender/sex of the patient (M/F/U)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','reporter_country','Country code of the reporter');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','primaryid','Primary unique identifier for the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','drugname_list','Concatenated list of all drug names in the case');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','reac_pt_list','Concatenated list of all reaction preferred terms');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo','fda_dt','Date FDA received the report');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','CASE','Legacy case identifier format');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','i_f_cod','Initial/Follow-up code (legacy format)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','event_dt','Date when the adverse event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','age','Age of the patient when event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','gndr_cod','Gender code (legacy format)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','reporter_country','Country code of the reporter');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','isr','Individual Safety Report identifier');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','drugname_list','Concatenated list of all drug names in the case');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','reac_pt_list','Concatenated list of all reaction preferred terms');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','casedemo_legacy','fda_dt','Date FDA received the report');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','primaryid','Primary unique identifier for the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','caseid','Case identifier - groups related reports');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','caseversion','Version number of the case report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','i_f_code','Initial/Follow-up code (I=Initial, F=Follow-up)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','event_dt','Date when the adverse event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','mfr_dt','Date manufacturer received the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','init_fda_dt','Initial FDA received date');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','fda_dt','Date FDA received the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','rept_cod','Report type code (e.g., spontaneous, study)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','auth_num','Authorization number if applicable');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','mfr_num','Manufacturer control number');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','mfr_sndr','Manufacturer sender identifier');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','lit_ref','Literature reference if report from literature');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','age','Age of the patient when event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','age_cod','Age unit code (e.g., years, months, days)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','age_grp','Age group classification');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','sex','Gender/sex of the patient (M/F/U)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','e_sub','Exposure during pregnancy flag (Y/N)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','wt','Weight of the patient');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','wt_cod','Weight unit code (e.g., kg, lbs)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','rept_dt','Report date by the reporter');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','to_mfr','Reported to manufacturer flag (Y/N)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','occp_cod','Reporter occupation code');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','reporter_country','Country code of the reporter');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','occr_country','Country where the event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','filename','Source filename from which record was extracted');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','qtr','Quarter of the year (1-4)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','qtr_var','Quarter as text (e.g., Q1, Q2, Q3, Q4)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','yr','Year as integer');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo','yr_var','Year as text string');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','isr','Individual Safety Report identifier (legacy format)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','CASE','Legacy case identifier format');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','i_f_cod','Initial/Follow-up code (legacy format)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','foll_seq','Follow-up sequence number');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','image','Image identifier or flag');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','event_dt','Date when the adverse event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','mfr_dt','Date manufacturer received the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','fda_dt','Date FDA received the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','rept_cod','Report type code (e.g., spontaneous, study)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','mfr_num','Manufacturer control number');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','mfr_sndr','Manufacturer sender identifier');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','age','Age of the patient when event occurred');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','age_cod','Age unit code (e.g., years, months, days)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','gndr_cod','Gender code (legacy format)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','e_sub','Exposure during pregnancy flag (Y/N)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','wt','Weight of the patient');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','wt_cod','Weight unit code (e.g., kg, lbs)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','rept_dt','Report date by the reporter');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','occp_cod','Reporter occupation code');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','death_dt','Death date if applicable');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','to_mfr','Reported to manufacturer flag (Y/N)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','confid','Confidentiality flag');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','reporter_country','Country code of the reporter');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','filename','Source filename from which record was extracted');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','qtr','Quarter of the year (1-4)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','qtr_var','Quarter as text (e.g., Q1, Q2, Q3, Q4)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','yr','Year as integer');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','demo_legacy','yr_var','Year as text string');

/* =========================
    DRUG & DRUG MAPPING TABLES
    ========================= */
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','combined_drug_mapping','primaryid','Primary unique identifier for the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','combined_drug_mapping','isr','Individual Safety Report identifier');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','combined_drug_mapping','drug_seq','Sequence number of the drug in the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','combined_drug_mapping','role_cod','Role of the drug in the case (e.g., suspect, concomitant)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','combined_drug_mapping','drug_name_original','Original reported drug name as submitted');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','combined_drug_mapping','lookup_value','Normalized lookup value for mapping');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','combined_drug_mapping','concept_id','Standard vocabulary concept ID (e.g., RxNorm)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','combined_drug_mapping','update_method','Method used to create the mapping (e.g., automated, manual)');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','country_code','country_name','Full name of the country');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','country_code','country_code','ISO country code (2 or 3 letter abbreviation)');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_age_keys','caseid','Case identifier used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_age_keys','event_dt','Event date used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_age_keys','sex','Sex/gender used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_age_keys','reporter_country','Reporter country used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_age_keys','default_age','Default age value to use for this key combination');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_event_dt_keys','caseid','Case identifier used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_event_dt_keys','age','Age used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_event_dt_keys','sex','Sex/gender used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_event_dt_keys','reporter_country','Reporter country used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_event_dt_keys','default_event_dt','Default event date value to use for this key combination');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_reporter_country_keys','caseid','Case identifier used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_reporter_country_keys','event_dt','Event date used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_reporter_country_keys','age','Age used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_reporter_country_keys','sex','Sex/gender used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_reporter_country_keys','default_reporter_country','Default reporter country value to use for this key combination');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_sex_keys','caseid','Case identifier used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_sex_keys','event_dt','Event date used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_sex_keys','age','Age used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_sex_keys','reporter_country','Reporter country used as lookup key');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','default_all_casedemo_sex_keys','default_sex','Default sex/gender value to use for this key combination');

-- Raw drug table (inline comments converted)
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','primaryid','Unique identifier for the individual report (joins with demo table)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','caseid','Identifier for the overall case (might group multiple reports)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','drug_seq','Sequence number of the drug in the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','role_cod','Role of the drug in the case (e.g., suspect, concomitant)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','drugname','Reported name of the drug');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','prod_ai','Active ingredient of the product');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','val_vbm','Coded value for validation (typically binary or Y/N)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','route','Route of administration (e.g., oral, intravenous)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','dose_vbm','Verbatim dose text');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','cum_dose_chr','Cumulative dose (text)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','cum_dose_unit','Unit for cumulative dose (e.g., mg, g)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','dechal','Dechallenge result (e.g., yes, no, unknown)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','rechal','Rechallenge result (e.g., yes, no, unknown)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','lot_num','Lot number of the drug product');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','exp_dt','Expiration date of the drug product');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','nda_num','New Drug Application number');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','dose_amt','Dose amount per administration');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','dose_unit','Unit for dose amount (e.g., mg, ml)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','dose_form','Dosage form (e.g., tablet, injection)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','dose_freq','Frequency of dose administration (e.g., daily, BID)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','filename','Source file from which the record was extracted');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','qtr','Reported quarter of the year');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','qtr_var','Text version of quarter (e.g., Q1, Q2)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','yr','Year of the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug','yr_var','Text version of year (e.g., 2021)');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_ai_mapping','drug_name_original','Original reported drug name from FAERS or other source');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_ai_mapping','prod_ai','Parsed or extracted active ingredient');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_ai_mapping','concept_id','Standard vocabulary concept ID (e.g., RxNorm concept_id)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_ai_mapping','update_method','Description of how the mapping was generated (e.g., NLP, manual)');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','isr','Individual Safety Report identifier (legacy format)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','drug_seq','Sequence number of the drug in the report');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','role_cod','Role of the drug in the case (e.g., suspect, concomitant)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','drugname','Reported name of the drug');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','val_vbm','Coded value for validation (typically binary or Y/N)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','route','Route of administration (e.g., oral, intravenous)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','dose_vbm','Verbatim dose text as reported');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','dechal','Dechallenge result (e.g., yes, no, unknown)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','rechal','Rechallenge result (e.g., yes, no, unknown)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','lot_num','Lot number of the drug product');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','exp_dt','Expiration date of the drug product');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','nda_num','New Drug Application number');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','filename','Source filename from which record was extracted');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','qtr','Quarter of the year (1-4)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','qtr_var','Quarter as text (e.g., Q1, Q2, Q3, Q4)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','yr','Year as integer');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_legacy','yr_var','Year as text string');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_brand_name_list','drug_name_original','Original reported drug name from FAERS');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_brand_name_list','ingredient_list','List of active ingredients for the brand name drug');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_brand_name_list','concept_id','Standard vocabulary concept ID (e.g., RxNorm)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_brand_name_list','concept_name','Standard concept name corresponding to the concept_id');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_multi_ingredient_list','drug_name_original','Original reported drug name from FAERS');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_multi_ingredient_list','ingredient_list','List of multiple active ingredients in the drug');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_multi_ingredient_list','concept_id','Standard vocabulary concept ID for multi-ingredient drug');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_multi_ingredient_list','concept_name','Standard concept name for the multi-ingredient drug');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_single_ingredient_list','drug_name_original','Original reported drug name from FAERS');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_single_ingredient_list','ingredient_list','Single active ingredient in the drug');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_single_ingredient_list','concept_id','Standard vocabulary concept ID for single ingredient');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_mapping_single_ingredient_list','concept_name','Standard concept name for the single ingredient');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_nda_mapping','drug_name_original','Original reported drug name from FAERS');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_nda_mapping','nda_num','New Drug Application number');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_nda_mapping','nda_ingredient','Active ingredient listed in the NDA');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_nda_mapping','concept_id','Standard vocabulary concept ID mapped via NDA');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_nda_mapping','update_method','Method used to create the NDA-based mapping');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_regex_mapping','drug_name_original','Original reported drug name from FAERS');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_regex_mapping','drug_name_clean','Cleaned drug name after regex processing');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_regex_mapping','concept_id','Standard vocabulary concept ID mapped via regex');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_regex_mapping','update_method','Regex method used to create the mapping');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_regex_mapping_words','drug_name_original','Original reported drug name from FAERS');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_regex_mapping_words','concept_name','Standard concept name from vocabulary');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_regex_mapping_words','concept_id','Standard vocabulary concept ID');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_regex_mapping_words','update_method','Word-based regex method used for mapping');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_regex_mapping_words','word','Individual word extracted for mapping');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_usagi_mapping','drug_name_original','Original reported drug name from FAERS');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_usagi_mapping','concept_name','Standard concept name from USAGI mapping');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_usagi_mapping','concept_class_id','Concept class identifier (e.g., Ingredient, Brand Name)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_usagi_mapping','concept_id','Standard vocabulary concept ID from USAGI');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drug_usagi_mapping','update_method','USAGI-based method used to create the mapping');

SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drugname_legacy_list','isr','Individual Safety Report identifier (legacy format)');
SELECT set_comment_if_absent('${DATABASE_SCHEMA}','drugname_legacy_list','drugname_list','Concatenated list of all drug names in the legacy case');

COMMIT;
