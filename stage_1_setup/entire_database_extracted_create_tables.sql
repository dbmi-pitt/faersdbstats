-- this is just only the create table statements from entire_database_ddl.sql
-- to aide in prompt buildling and the creation of column comments
-- created with awk '/CREATE TABLE/ {flag=1} flag {print} /^$/ {flag=0; print ""}' entire_database_ddl.sql > extracted_create_tables.sql
-- then find (\r?\n){2,} replace with \n\n

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.all_casedemo (
    database text COMMENT 'Database source identifier (e.g., FAERS, LAERS)',
    caseid character varying COMMENT 'Case identifier - groups related reports',
    isr character varying COMMENT 'Individual Safety Report identifier',
    caseversion character varying COMMENT 'Version number of the case report',
    i_f_code character varying COMMENT 'Initial/Follow-up code (I=Initial, F=Follow-up)',
    event_dt character varying COMMENT 'Date when the adverse event occurred',
    age character varying COMMENT 'Age of the patient when event occurred',
    sex character varying COMMENT 'Gender/sex of the patient (M/F/U)',
    reporter_country character varying COMMENT 'Country code of the reporter',
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    drugname_list text COMMENT 'Concatenated list of all drug names in the case',
    reac_pt_list text COMMENT 'Concatenated list of all reaction preferred terms',
    fda_dt character varying COMMENT 'Date FDA received the report',
    imputed_field_name text COMMENT 'Name of field that was imputed if any'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.casedemo (
    caseid character varying COMMENT 'Case identifier - groups related reports',
    caseversion character varying COMMENT 'Version number of the case report',
    i_f_code character varying COMMENT 'Initial/Follow-up code (I=Initial, F=Follow-up)',
    event_dt character varying COMMENT 'Date when the adverse event occurred',
    age character varying COMMENT 'Age of the patient when event occurred',
    sex character varying COMMENT 'Gender/sex of the patient (M/F/U)',
    reporter_country character varying COMMENT 'Country code of the reporter',
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    drugname_list text COMMENT 'Concatenated list of all drug names in the case',
    reac_pt_list text COMMENT 'Concatenated list of all reaction preferred terms',
    fda_dt character varying COMMENT 'Date FDA received the report'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.casedemo_legacy (
    "CASE" character varying COMMENT 'Legacy case identifier format',
    i_f_cod character varying COMMENT 'Initial/Follow-up code (legacy format)',
    event_dt character varying COMMENT 'Date when the adverse event occurred',
    age character varying COMMENT 'Age of the patient when event occurred',
    gndr_cod character varying COMMENT 'Gender code (legacy format)',
    reporter_country character varying COMMENT 'Country code of the reporter',
    isr character varying COMMENT 'Individual Safety Report identifier',
    drugname_list text COMMENT 'Concatenated list of all drug names in the case',
    reac_pt_list text COMMENT 'Concatenated list of all reaction preferred terms',
    fda_dt character varying COMMENT 'Date FDA received the report'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.combined_drug_mapping (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    isr character varying COMMENT 'Individual Safety Report identifier',
    drug_seq character varying COMMENT 'Sequence number of the drug in the report',
    role_cod character varying COMMENT 'Role of the drug in the case (e.g., suspect, concomitant)',
    drug_name_original character varying COMMENT 'Original reported drug name as submitted',
    lookup_value character varying COMMENT 'Normalized lookup value for mapping',
    concept_id integer COMMENT 'Standard vocabulary concept ID (e.g., RxNorm)',
    update_method character varying COMMENT 'Method used to create the mapping (e.g., automated, manual)'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.country_code (
    country_name character varying COMMENT 'Full name of the country',
    country_code character varying COMMENT 'ISO country code (2 or 3 letter abbreviation)'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.default_all_casedemo_age_keys (
    caseid character varying COMMENT 'Case identifier used as lookup key',
    event_dt character varying COMMENT 'Event date used as lookup key',
    sex character varying COMMENT 'Sex/gender used as lookup key',
    reporter_country character varying COMMENT 'Reporter country used as lookup key',
    default_age text COMMENT 'Default age value to use for this key combination'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.default_all_casedemo_event_dt_keys (
    caseid character varying COMMENT 'Case identifier used as lookup key',
    age character varying COMMENT 'Age used as lookup key',
    sex character varying COMMENT 'Sex/gender used as lookup key',
    reporter_country character varying COMMENT 'Reporter country used as lookup key',
    default_event_dt text COMMENT 'Default event date value to use for this key combination'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.default_all_casedemo_reporter_country_keys (
    caseid character varying COMMENT 'Case identifier used as lookup key',
    event_dt character varying COMMENT 'Event date used as lookup key',
    age character varying COMMENT 'Age used as lookup key',
    sex character varying COMMENT 'Sex/gender used as lookup key',
    default_reporter_country text COMMENT 'Default reporter country value to use for this key combination'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.default_all_casedemo_sex_keys (
    caseid character varying COMMENT 'Case identifier used as lookup key',
    event_dt character varying COMMENT 'Event date used as lookup key',
    age character varying COMMENT 'Age used as lookup key',
    reporter_country character varying COMMENT 'Reporter country used as lookup key',
    default_sex text COMMENT 'Default sex/gender value to use for this key combination'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.demo (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    caseid character varying COMMENT 'Case identifier - groups related reports',
    caseversion character varying COMMENT 'Version number of the case report',
    i_f_code character varying COMMENT 'Initial/Follow-up code (I=Initial, F=Follow-up)',
    event_dt character varying COMMENT 'Date when the adverse event occurred',
    mfr_dt character varying COMMENT 'Date manufacturer received the report',
    init_fda_dt character varying COMMENT 'Initial FDA received date',
    fda_dt character varying COMMENT 'Date FDA received the report',
    rept_cod character varying COMMENT 'Report type code (e.g., spontaneous, study)',
    auth_num character varying COMMENT 'Authorization number if applicable',
    mfr_num character varying COMMENT 'Manufacturer control number',
    mfr_sndr character varying COMMENT 'Manufacturer sender identifier',
    lit_ref character varying COMMENT 'Literature reference if report from literature',
    age character varying COMMENT 'Age of the patient when event occurred',
    age_cod character varying COMMENT 'Age unit code (e.g., years, months, days)',
    age_grp character varying COMMENT 'Age group classification',
    sex character varying COMMENT 'Gender/sex of the patient (M/F/U)',
    e_sub character varying COMMENT 'Exposure during pregnancy flag (Y/N)',
    wt character varying COMMENT 'Weight of the patient',
    wt_cod character varying COMMENT 'Weight unit code (e.g., kg, lbs)',
    rept_dt character varying COMMENT 'Report date by the reporter',
    to_mfr character varying COMMENT 'Reported to manufacturer flag (Y/N)',
    occp_cod character varying COMMENT 'Reporter occupation code',
    reporter_country character varying COMMENT 'Country code of the reporter',
    occr_country character varying COMMENT 'Country where the event occurred',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);
CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.demo_legacy (
    isr character varying COMMENT 'Individual Safety Report identifier (legacy format)',
    "CASE" character varying COMMENT 'Legacy case identifier format',
    i_f_cod character varying COMMENT 'Initial/Follow-up code (legacy format)',
    foll_seq character varying COMMENT 'Follow-up sequence number',
    image character varying COMMENT 'Image identifier or flag',
    event_dt character varying COMMENT 'Date when the adverse event occurred',
    mfr_dt character varying COMMENT 'Date manufacturer received the report',
    fda_dt character varying COMMENT 'Date FDA received the report',
    rept_cod character varying COMMENT 'Report type code (e.g., spontaneous, study)',
    mfr_num character varying COMMENT 'Manufacturer control number',
    mfr_sndr character varying COMMENT 'Manufacturer sender identifier',
    age character varying COMMENT 'Age of the patient when event occurred',
    age_cod character varying COMMENT 'Age unit code (e.g., years, months, days)',
    gndr_cod character varying COMMENT 'Gender code (legacy format)',
    e_sub character varying COMMENT 'Exposure during pregnancy flag (Y/N)',
    wt character varying COMMENT 'Weight of the patient',
    wt_cod character varying COMMENT 'Weight unit code (e.g., kg, lbs)',
    rept_dt character varying COMMENT 'Report date by the reporter',
    occp_cod character varying COMMENT 'Reporter occupation code',
    death_dt character varying COMMENT 'Death date if applicable',
    to_mfr character varying COMMENT 'Reported to manufacturer flag (Y/N)',
    confid character varying COMMENT 'Confidentiality flag',
    reporter_country character varying COMMENT 'Country code of the reporter',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

-- Table: drug
-- Description: Stores raw drug report entries from FAERS, including dosing, identifiers, and administrative metadata.
CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug (
    primaryid character varying,          -- Unique identifier for the individual report (joins with demo table)
    caseid character varying,             -- Identifier for the overall case (might group multiple reports)
    drug_seq character varying,           -- Sequence number of the drug in the report
    role_cod character varying,           -- Role of the drug in the case (e.g., suspect, concomitant)
    drugname character varying,           -- Reported name of the drug
    prod_ai character varying,            -- Active ingredient of the product
    val_vbm character varying,            -- Coded value for validation (typically binary or Y/N)
    route character varying,              -- Route of administration (e.g., oral, intravenous)
    dose_vbm character varying,           -- Verbatim dose text
    cum_dose_chr character varying,       -- Cumulative dose (text)
    cum_dose_unit character varying,      -- Unit for cumulative dose (e.g., mg, g)
    dechal character varying,             -- Dechallenge result (e.g., yes, no, unknown)
    rechal character varying,             -- Rechallenge result (e.g., yes, no, unknown)
    lot_num character varying,            -- Lot number of the drug product
    exp_dt character varying,             -- Expiration date of the drug product
    nda_num character varying,            -- New Drug Application number
    dose_amt character varying,           -- Dose amount per administration
    dose_unit character varying,          -- Unit for dose amount (e.g., mg, ml)
    dose_form character varying,          -- Dosage form (e.g., tablet, injection)
    dose_freq character varying,          -- Frequency of dose administration (e.g., daily, BID)
    filename character varying,           -- Source file from which the record was extracted
    qtr integer,                          -- Reported quarter of the year
    qtr_var character varying,            -- Text version of quarter (e.g., Q1, Q2)
    yr integer,                           -- Year of the report
    yr_var character varying              -- Text version of year (e.g., "2021")
);

-- Table: drug_ai_mapping
-- Description: Maps drug names and their active ingredients to standard concept IDs (e.g., RxNorm) for normalization.
CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_ai_mapping (
    drug_name_original character varying, -- Original reported drug name from FAERS or other source
    prod_ai character varying,            -- Parsed or extracted active ingredient
    concept_id integer,                   -- Standard vocabulary concept ID (e.g., RxNorm concept_id)
    update_method text                    -- Description of how the mapping was generated (e.g., NLP, manual)
);


CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_legacy (
    isr character varying COMMENT 'Individual Safety Report identifier (legacy format)',
    drug_seq character varying COMMENT 'Sequence number of the drug in the report',
    role_cod character varying COMMENT 'Role of the drug in the case (e.g., suspect, concomitant)',
    drugname character varying COMMENT 'Reported name of the drug',
    val_vbm character varying COMMENT 'Coded value for validation (typically binary or Y/N)',
    route character varying COMMENT 'Route of administration (e.g., oral, intravenous)',
    dose_vbm character varying COMMENT 'Verbatim dose text as reported',
    dechal character varying COMMENT 'Dechallenge result (e.g., yes, no, unknown)',
    rechal character varying COMMENT 'Rechallenge result (e.g., yes, no, unknown)',
    lot_num character varying COMMENT 'Lot number of the drug product',
    exp_dt character varying COMMENT 'Expiration date of the drug product',
    nda_num character varying COMMENT 'New Drug Application number',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_mapping_brand_name_list (
    drug_name_original character varying COMMENT 'Original reported drug name from FAERS',
    ingredient_list text COMMENT 'List of active ingredients for the brand name drug',
    concept_id integer COMMENT 'Standard vocabulary concept ID (e.g., RxNorm)',
    concept_name text COMMENT 'Standard concept name corresponding to the concept_id'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_mapping_multi_ingredient_list (
    drug_name_original character varying COMMENT 'Original reported drug name from FAERS',
    ingredient_list text COMMENT 'List of multiple active ingredients in the drug',
    concept_id integer COMMENT 'Standard vocabulary concept ID for multi-ingredient drug',
    concept_name text COMMENT 'Standard concept name for the multi-ingredient drug'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_mapping_single_ingredient_list (
    drug_name_original character varying COMMENT 'Original reported drug name from FAERS',
    ingredient_list text COMMENT 'Single active ingredient in the drug',
    concept_id integer COMMENT 'Standard vocabulary concept ID for single ingredient',
    concept_name text COMMENT 'Standard concept name for the single ingredient'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_nda_mapping (
    drug_name_original character varying COMMENT 'Original reported drug name from FAERS',
    nda_num character varying COMMENT 'New Drug Application number',
    nda_ingredient text COMMENT 'Active ingredient listed in the NDA',
    concept_id integer COMMENT 'Standard vocabulary concept ID mapped via NDA',
    update_method text COMMENT 'Method used to create the NDA-based mapping'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_regex_mapping (
    drug_name_original character varying COMMENT 'Original reported drug name from FAERS',
    drug_name_clean text COMMENT 'Cleaned drug name after regex processing',
    concept_id integer COMMENT 'Standard vocabulary concept ID mapped via regex',
    update_method text COMMENT 'Regex method used to create the mapping'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_regex_mapping_words (
    drug_name_original character varying COMMENT 'Original reported drug name from FAERS',
    concept_name character varying COMMENT 'Standard concept name from vocabulary',
    concept_id integer COMMENT 'Standard vocabulary concept ID',
    update_method text COMMENT 'Word-based regex method used for mapping',
    word text COMMENT 'Individual word extracted for mapping'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_usagi_mapping (
    drug_name_original text COMMENT 'Original reported drug name from FAERS',
    concept_name character varying(1000) COMMENT 'Standard concept name from USAGI mapping',
    concept_class_id character varying(500) COMMENT 'Concept class identifier (e.g., Ingredient, Brand Name)',
    concept_id integer COMMENT 'Standard vocabulary concept ID from USAGI',
    update_method text COMMENT 'USAGI-based method used to create the mapping'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drugname_legacy_list (
    isr character varying COMMENT 'Individual Safety Report identifier (legacy format)',
    drugname_list text COMMENT 'Concatenated list of all drug names in the legacy case'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drugname_list (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    drugname_list text COMMENT 'Concatenated list of all drug names in the case'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient (
    active_substance character varying COMMENT 'Active pharmaceutical ingredient name',
    brand_name character varying COMMENT 'Brand/trade name of the drug',
    eu_number character varying COMMENT 'European Union drug identification number',
    reference_name character varying COMMENT 'Reference name for the drug in EU database'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient_mapping (
    active_substance text COMMENT 'Active pharmaceutical ingredient name from EU database',
    brand_name text COMMENT 'Brand/trade name mapped to the active substance'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.indi (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    caseid character varying COMMENT 'Case identifier - groups related reports',
    indi_drug_seq character varying COMMENT 'Drug sequence number for the indication',
    indi_pt character varying COMMENT 'Indication preferred term (MedDRA PT)',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.indi_legacy (
    isr character varying COMMENT 'Individual Safety Report identifier (legacy format)',
    drug_seq character varying COMMENT 'Drug sequence number for the indication',
    indi_pt character varying COMMENT 'Indication preferred term (MedDRA PT)',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.meddra_snomed_mapping (
    snomed_concept_id integer COMMENT 'SNOMED CT concept identifier',
    snomed_concept_name character varying(255) COMMENT 'SNOMED CT concept name/description',
    snomed_concept_code character varying(50) COMMENT 'SNOMED CT concept code',
    meddra_concept_id integer COMMENT 'MedDRA concept identifier',
    meddra_concept_name character varying(255) COMMENT 'MedDRA concept name/description',
    meddra_concept_code character varying(50) COMMENT 'MedDRA concept code',
    meddra_class_id character varying(20) COMMENT 'MedDRA class identifier (e.g., PT, LLT, HLT)'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.nda (
    ingredient character varying COMMENT 'Active ingredient name',
    dfroute character varying COMMENT 'Dosage form and route of administration',
    trade_name character varying COMMENT 'Trade/brand name of the drug',
    applicant character varying COMMENT 'Company/organization that submitted the NDA',
    strength character varying COMMENT 'Drug strength/concentration',
    appl_type character varying COMMENT 'Application type (e.g., NDA, ANDA, BLA)',
    appl_no character varying COMMENT 'Application number',
    product_no character varying COMMENT 'Product number within the application',
    te_code character varying COMMENT 'Therapeutic equivalence code',
    approval_date character varying COMMENT 'Date the application was approved',
    rld character varying COMMENT 'Reference Listed Drug flag (Yes/No)',
    rs character varying COMMENT 'Reference Standard flag',
    type character varying COMMENT 'Product type classification',
    applicant_full_name character varying COMMENT 'Full name of the applicant organization',
    drug_form character varying COMMENT 'Pharmaceutical dosage form',
    route character varying COMMENT 'Route of administration'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.nda_ingredient (
    appl_no character varying COMMENT 'NDA application number',
    ingredient character varying COMMENT 'Active ingredient name',
    trade_name character varying COMMENT 'Trade/brand name associated with the ingredient'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.outc (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    caseid character varying COMMENT 'Case identifier - groups related reports',
    outc_code character varying COMMENT 'Outcome code (e.g., DE=Death, LT=Life-threatening, HO=Hospitalization)',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.outc_legacy (
    isr character varying COMMENT 'Individual Safety Report identifier (legacy format)',
    outc_cod character varying COMMENT 'Outcome code (legacy format)',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.reac (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    caseid character varying COMMENT 'Case identifier - groups related reports',
    pt character varying COMMENT 'Preferred term for the adverse reaction (MedDRA PT)',
    drug_rec_act character varying COMMENT 'Drug recurrence action taken',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.reac_legacy (
    isr character varying COMMENT 'Individual Safety Report identifier (legacy format)',
    pt character varying COMMENT 'Preferred term for the adverse reaction (MedDRA PT)',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.reac_pt_legacy_list (
    isr character varying COMMENT 'Individual Safety Report identifier (legacy format)',
    reac_pt_list text COMMENT 'Concatenated list of all reaction preferred terms for legacy case'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.reac_pt_list (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    reac_pt_list text COMMENT 'Concatenated list of all reaction preferred terms for the case'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rpsr (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    caseid character varying COMMENT 'Case identifier - groups related reports',
    rpsr_cod character varying COMMENT 'Report source code (e.g., consumer, healthcare professional)',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rpsr_legacy (
    isr character varying COMMENT 'Individual Safety Report identifier (legacy format)',
    rpsr_cod character varying COMMENT 'Report source code (legacy format)',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rxnorm_mapping_brand_name_list (
    ingredient_list text COMMENT 'List of active ingredients for RxNorm brand name mapping',
    concept_id integer COMMENT 'RxNorm concept identifier for the brand name',
    concept_name text COMMENT 'RxNorm concept name for the brand'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rxnorm_mapping_multi_ingredient_list (
    ingredient_list text COMMENT 'List of multiple active ingredients for RxNorm mapping',
    concept_id integer COMMENT 'RxNorm concept identifier for the multi-ingredient product',
    concept_name text COMMENT 'RxNorm concept name for the multi-ingredient product'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rxnorm_mapping_single_ingredient_list (
    ingredient_list text COMMENT 'Single active ingredient for RxNorm mapping',
    concept_id integer COMMENT 'RxNorm concept identifier for the single ingredient',
    concept_name text COMMENT 'RxNorm concept name for the single ingredient'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_case_adr (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    isr character varying COMMENT 'Individual Safety Report identifier',
    pt character varying COMMENT 'Preferred term for the adverse drug reaction (MedDRA PT)',
    outcome_concept_id integer COMMENT 'Standard vocabulary concept ID for the outcome',
    snomed_outcome_concept_id integer COMMENT 'SNOMED CT concept ID for the standardized outcome'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_case_drug (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    isr character varying COMMENT 'Individual Safety Report identifier',
    drug_seq character varying COMMENT 'Sequence number of the drug in the report',
    role_cod character varying COMMENT 'Role of the drug in the case (e.g., suspect, concomitant)',
    standard_concept_id integer COMMENT 'Standardized vocabulary concept ID for the drug (e.g., RxNorm)'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_case_indication (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    isr character varying COMMENT 'Individual Safety Report identifier',
    indi_drug_seq character varying COMMENT 'Drug sequence number for the indication',
    indi_pt character varying COMMENT 'Indication preferred term (MedDRA PT)',
    indication_concept_id integer COMMENT 'Standard vocabulary concept ID for the indication',
    snomed_indication_concept_id integer COMMENT 'SNOMED CT concept ID for the standardized indication'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_case_outcome_category (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    isr character varying COMMENT 'Individual Safety Report identifier',
    outc_code character varying COMMENT 'Outcome code (e.g., DE=Death, LT=Life-threatening)',
    snomed_concept_id integer COMMENT 'SNOMED CT concept ID for the standardized outcome category'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_combined_drug_mapping (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    isr character varying COMMENT 'Individual Safety Report identifier',
    drug_seq character varying COMMENT 'Sequence number of the drug in the report',
    role_cod character varying COMMENT 'Role of the drug in the case (e.g., suspect, concomitant)',
    drug_name_original character varying COMMENT 'Original reported drug name as submitted',
    lookup_value character varying COMMENT 'Normalized lookup value used for mapping',
    concept_id integer COMMENT 'Intermediate concept ID from mapping process',
    update_method character varying COMMENT 'Method used to create the mapping',
    standard_concept_id integer COMMENT 'Final standardized vocabulary concept ID (e.g., RxNorm)'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.test_table_1 (
    primaryid character varying COMMENT 'Primary unique identifier for test records',
    test_col_1 character varying COMMENT 'First test column for validation purposes',
    test_col_2 character varying COMMENT 'Second test column for validation purposes',
    filename character varying COMMENT 'Source filename for test data',
    qtr_var character varying COMMENT 'Quarter as text for test data',
    yr_var character varying COMMENT 'Year as text for test data',
    qtr integer COMMENT 'Quarter as integer for test data',
    yr integer COMMENT 'Year as integer for test data'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.test_table_2 (
    primaryid character varying COMMENT 'Primary unique identifier for test records',
    test_col_1 character varying COMMENT 'First test column for validation purposes',
    test_col_2 character varying COMMENT 'Second test column for validation purposes',
    filename character varying COMMENT 'Source filename for test data',
    qtr_var character varying COMMENT 'Quarter as text for test data',
    yr_var character varying COMMENT 'Year as text for test data',
    qtr integer COMMENT 'Quarter as integer for test data',
    yr integer COMMENT 'Year as integer for test data'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.ther (
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    caseid character varying COMMENT 'Case identifier - groups related reports',
    dsg_drug_seq character varying COMMENT 'Drug sequence number for therapy dosage information',
    start_dt character varying COMMENT 'Start date of drug therapy',
    end_dt character varying COMMENT 'End date of drug therapy',
    dur character varying COMMENT 'Duration of drug therapy',
    dur_cod character varying COMMENT 'Duration code/unit (e.g., days, weeks, months)',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.ther_legacy (
    isr character varying COMMENT 'Individual Safety Report identifier (legacy format)',
    drug_seq character varying COMMENT 'Drug sequence number for therapy information',
    start_dt character varying COMMENT 'Start date of drug therapy',
    end_dt character varying COMMENT 'End date of drug therapy',
    dur character varying COMMENT 'Duration of drug therapy',
    dur_cod character varying COMMENT 'Duration code/unit (e.g., days, weeks, months)',
    filename character varying COMMENT 'Source filename from which record was extracted',
    qtr integer COMMENT 'Quarter of the year (1-4)',
    qtr_var character varying COMMENT 'Quarter as text (e.g., Q1, Q2, Q3, Q4)',
    yr integer COMMENT 'Year as integer',
    yr_var character varying COMMENT 'Year as text string'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.unique_all_case (
    caseid character varying COMMENT 'Case identifier - unique cases across datasets',
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    isr character varying COMMENT 'Individual Safety Report identifier'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.unique_all_casedemo (
    database text COMMENT 'Database source identifier (e.g., FAERS, LAERS)',
    caseid character varying COMMENT 'Case identifier - groups related reports',
    isr character varying COMMENT 'Individual Safety Report identifier',
    caseversion character varying COMMENT 'Version number of the case report',
    i_f_code character varying COMMENT 'Initial/Follow-up code (I=Initial, F=Follow-up)',
    event_dt character varying COMMENT 'Date when the adverse event occurred',
    age character varying COMMENT 'Age of the patient when event occurred',
    sex character varying COMMENT 'Gender/sex of the patient (M/F/U)',
    reporter_country character varying COMMENT 'Country code of the reporter',
    primaryid character varying COMMENT 'Primary unique identifier for the report',
    drugname_list text COMMENT 'Concatenated list of all drug names in the case',
    reac_pt_list text COMMENT 'Concatenated list of all reaction preferred terms',
    fda_dt character varying COMMENT 'Date FDA received the report'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.usagi_import (
    source_code character varying COMMENT 'Original source code to be mapped',
    source_concept_id character varying COMMENT 'Source concept identifier if available',
    source_vocabulary_id character varying COMMENT 'Vocabulary ID for the source terminology',
    source_code_description character varying COMMENT 'Description of the source code',
    target_concept_id character varying COMMENT 'Target standard vocabulary concept ID',
    target_vocabulary_id character varying COMMENT 'Vocabulary ID for the target terminology',
    valid_start_date character varying COMMENT 'Date when the mapping becomes valid',
    valid_end_date character varying COMMENT 'Date when the mapping expires',
    invalid_reason character varying COMMENT 'Reason why mapping is invalid (if applicable)'
);

CREATE TABLE IF NOT EXISTS public.pdi_logging (
    channel_id character varying(255) COMMENT 'Unique identifier for the PDI channel/step',
    lines_read bigint COMMENT 'Number of lines read by the step',
    lines_written bigint COMMENT 'Number of lines written by the step',
    lines_updated bigint COMMENT 'Number of lines updated by the step',
    lines_input bigint COMMENT 'Number of lines input to the step',
    lines_output bigint COMMENT 'Number of lines output from the step',
    lines_rejected bigint COMMENT 'Number of lines rejected by the step',
    errors bigint COMMENT 'Number of errors encountered',
    id_job integer COMMENT 'Job identifier in PDI',
    jobname character varying(255) COMMENT 'Name of the PDI job',
    status character varying(15) COMMENT 'Execution status (e.g., running, finished, error)',
    startdate timestamp without time zone COMMENT 'Start timestamp of execution',
    enddate timestamp without time zone COMMENT 'End timestamp of execution',
    logdate timestamp without time zone COMMENT 'Log entry timestamp',
    depdate timestamp without time zone COMMENT 'Dependency date',
    replaydate timestamp without time zone COMMENT 'Replay date if applicable',
    log_field text COMMENT 'Log message text',
    id_batch integer COMMENT 'Batch identifier',
    log_date timestamp without time zone COMMENT 'Alternative log date field',
    logging_object_type character varying(255) COMMENT 'Type of logging object (e.g., JOB, TRANS)',
    object_name character varying(255) COMMENT 'Name of the object being logged',
    object_copy character varying(255) COMMENT 'Copy number of the object',
    repository_directory character varying(255) COMMENT 'Repository directory path',
    filename character varying(255) COMMENT 'Filename of the PDI object',
    object_id character varying(255) COMMENT 'Unique object identifier',
    object_revision character varying(255) COMMENT 'Object revision number',
    parent_channel_id character varying(255) COMMENT 'Parent channel identifier',
    root_channel_id character varying(255) COMMENT 'Root channel identifier',
    transname character varying(255) COMMENT 'Transformation name',
    stepname character varying(255) COMMENT 'Step name within transformation',
    result character varying(5) COMMENT 'Step execution result (e.g., Y/N)',
    nr_result_rows bigint COMMENT 'Number of result rows',
    nr_result_files bigint COMMENT 'Number of result files',
    metrics_date timestamp without time zone COMMENT 'Metrics collection date',
    metrics_code character varying(255) COMMENT 'Metrics code identifier',
    metrics_description character varying(255) COMMENT 'Description of the metric',
    metrics_subject character varying(255) COMMENT 'Subject of the metric',
    metrics_type character varying(255) COMMENT 'Type of metric collected',
    metrics_value bigint COMMENT 'Numeric value of the metric',
    seq_nr integer COMMENT 'Sequence number',
    step_copy integer COMMENT 'Step copy number',
    input_buffer_rows bigint COMMENT 'Number of rows in input buffer',
    output_buffer_rows bigint COMMENT 'Number of rows in output buffer',
    executing_server character varying(255) COMMENT 'Server where execution occurred',
    executing_user character varying(255) COMMENT 'User who executed the job/transformation',
    client character varying(255) COMMENT 'Client application identifier',
    start_job_entry character varying(255) COMMENT 'Starting job entry name',
    copy_nr integer COMMENT 'Copy number',
    "RESULT" character varying(5) COMMENT 'Overall result (duplicate field)'
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.attribute_definition (
    attribute_definition_id integer NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_description text,
    attribute_type_concept_id integer NOT NULL,
    attribute_syntax text
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.cohort_definition (
    cohort_definition_id integer NOT NULL,
    cohort_definition_name character varying(255) NOT NULL,
    cohort_definition_description text,
    definition_type_concept_id integer NOT NULL,
    cohort_definition_syntax text,
    subject_concept_id integer NOT NULL,
    cohort_initiation_date date
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept (
    concept_id integer NOT NULL COMMENT 'Unique identifier for the concept in the vocabulary',
    concept_name character varying(255) NOT NULL COMMENT 'Human-readable name/description of the concept',
    domain_id character varying(20) NOT NULL COMMENT 'Domain classification (e.g., Drug, Condition, Procedure)',
    vocabulary_id character varying(20) NOT NULL COMMENT 'Vocabulary source (e.g., SNOMED, RxNorm, ICD10CM)',
    concept_class_id character varying(20) NOT NULL COMMENT 'Class within the vocabulary (e.g., Ingredient, Brand Name)',
    standard_concept character varying(1) COMMENT 'Flag indicating if this is a standard concept (S=Standard, C=Classification)',
    concept_code character varying(50) NOT NULL COMMENT 'Original code from the source vocabulary',
    valid_start_date date NOT NULL COMMENT 'Date when the concept becomes valid',
    valid_end_date date NOT NULL COMMENT 'Date when the concept expires',
    invalid_reason character varying(1) COMMENT 'Reason why concept is invalid (D=Deleted, U=Updated)'
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept_ancestor (
    ancestor_concept_id integer NOT NULL,
    descendant_concept_id integer NOT NULL,
    min_levels_of_separation integer NOT NULL,
    max_levels_of_separation integer NOT NULL
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept_class (
    concept_class_id character varying(100) NOT NULL,
    concept_class_name character varying(255) NOT NULL,
    concept_class_concept_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept_relationship (
    concept_id_1 integer NOT NULL COMMENT 'First concept in the relationship',
    concept_id_2 integer NOT NULL COMMENT 'Second concept in the relationship',
    relationship_id character varying(20) NOT NULL COMMENT 'Type of relationship (e.g., Maps to, Is a, RxNorm has dose form)',
    valid_start_date date NOT NULL COMMENT 'Date when the relationship becomes valid',
    valid_end_date date NOT NULL COMMENT 'Date when the relationship expires',
    invalid_reason character varying(1) COMMENT 'Reason why relationship is invalid'
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept_synonym (
    concept_id integer NOT NULL,
    concept_synonym_name character varying(1000) NOT NULL,
    language_concept_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.domain (
    domain_id character varying(20) NOT NULL COMMENT 'Unique identifier for the domain (e.g., Drug, Condition)',
    domain_name character varying(255) NOT NULL COMMENT 'Human-readable name of the domain',
    domain_concept_id integer NOT NULL COMMENT 'Concept ID that represents this domain'
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.drug_strength (
    drug_concept_id integer NOT NULL COMMENT 'Concept ID for the drug product',
    ingredient_concept_id integer NOT NULL COMMENT 'Concept ID for the active ingredient',
    amount_value numeric COMMENT 'Amount of ingredient in the drug product',
    amount_unit_concept_id integer COMMENT 'Unit concept ID for the amount (e.g., mg, ml)',
    numerator_value numeric COMMENT 'Numerator value for concentration',
    numerator_unit_concept_id integer COMMENT 'Unit concept ID for numerator',
    denominator_value numeric COMMENT 'Denominator value for concentration',
    denominator_unit_concept_id integer COMMENT 'Unit concept ID for denominator',
    box_size integer COMMENT 'Number of units in the package',
    valid_start_date date NOT NULL COMMENT 'Date when the drug strength becomes valid',
    valid_end_date date NOT NULL COMMENT 'Date when the drug strength expires',
    invalid_reason character varying(1) COMMENT 'Reason why drug strength record is invalid'
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.indi (
    primaryid character varying,
    caseid character varying,
    indi_drug_seq character varying,
    indi_pt character varying,
    filename character varying
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.reac (
    primaryid character varying,
    caseid character varying,
    pt character varying,
    drug_rec_act character varying,
    filename character varying,
    qtr integer,
    yr integer,
    yr_var character varying,
    qtr_var character varying
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.relationship (
    relationship_id character varying(20) NOT NULL COMMENT 'Unique identifier for the relationship type',
    relationship_name character varying(255) NOT NULL COMMENT 'Human-readable name of the relationship',
    is_hierarchical character varying(1) NOT NULL COMMENT 'Whether the relationship defines a hierarchy (1=Yes, 0=No)',
    defines_ancestry character varying(1) NOT NULL COMMENT 'Whether this relationship defines ancestry (1=Yes, 0=No)',
    reverse_relationship_id character varying(20) NOT NULL COMMENT 'ID of the reverse relationship',
    relationship_concept_id integer NOT NULL COMMENT 'Concept ID that represents this relationship type'
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.rpsr (
    primaryid character varying,
    caseid character varying,
    rpsr_cod character varying,
    filename character varying,
    qtr integer,
    yr integer,
    qtr_var character varying,
    yr_var character varying
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.source_to_concept_map (
    source_code character varying(50) NOT NULL,
    source_concept_id integer NOT NULL,
    source_vocabulary_id character varying(20) NOT NULL,
    source_code_description character varying(255),
    target_concept_id integer NOT NULL,
    target_vocabulary_id character varying(20) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);

CREATE TABLE IF NOT EXISTS staging_vocabulary.vocabulary (
    vocabulary_id character varying(20) NOT NULL COMMENT 'Unique identifier for the vocabulary (e.g., SNOMED, RxNorm)',
    vocabulary_name character varying(255) NOT NULL COMMENT 'Full name of the vocabulary',
    vocabulary_reference character varying(255) COMMENT 'Reference or URL for the vocabulary source',
    vocabulary_version character varying(255) COMMENT 'Version of the vocabulary being used',
    vocabulary_concept_id integer NOT NULL COMMENT 'Concept ID that represents this vocabulary'
);

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.z_qa_faers_wc_import_log (
    log_filename VARCHAR(255) NOT NULL,      -- Name of the log file
    filename VARCHAR(255) NOT NULL,          -- Base name of the file without extension
    laers_or_faers VARCHAR(10) NOT NULL,     -- Type of data, e.g., 'faers'
    yr INT NOT NULL,                         -- Year of the data
    qtr INT NOT NULL,                 -- Quarter of the data (e.g., 'Q1', 'Q2')
    wc_l_count INT NOT NULL,                 -- Line count from wc -l
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp when data is inserted
);
