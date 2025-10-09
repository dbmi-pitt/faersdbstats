-- Adds column comments for FAERS and vocabulary tables.
-- Execute after creating tables in entire_database_extracted_create_tables.sql
-- Safe to run multiple times (COMMENT ON COLUMN is idempotent / replaces prior comment).
-- Schema variable ${DATABASE_SCHEMA} is expected to be provided by the calling environment (e.g., Pentaho/Kettle).
-- Transactional for atomicity.

BEGIN;

/* =========================
   FAERS CASE / DEMO TABLES
   ========================= */
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.database IS 'Database source identifier (e.g., FAERS, LAERS)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.isr IS 'Individual Safety Report identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.caseversion IS 'Version number of the case report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.i_f_code IS 'Initial/Follow-up code (I=Initial, F=Follow-up)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.event_dt IS 'Date when the adverse event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.age IS 'Age of the patient when event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.sex IS 'Gender/sex of the patient (M/F/U)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.reporter_country IS 'Country code of the reporter';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.drugname_list IS 'Concatenated list of all drug names in the case';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.reac_pt_list IS 'Concatenated list of all reaction preferred terms';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.fda_dt IS 'Date FDA received the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.all_casedemo.imputed_field_name IS 'Name of field that was imputed if any';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.caseversion IS 'Version number of the case report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.i_f_code IS 'Initial/Follow-up code (I=Initial, F=Follow-up)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.event_dt IS 'Date when the adverse event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.age IS 'Age of the patient when event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.sex IS 'Gender/sex of the patient (M/F/U)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.reporter_country IS 'Country code of the reporter';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.drugname_list IS 'Concatenated list of all drug names in the case';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.reac_pt_list IS 'Concatenated list of all reaction preferred terms';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo.fda_dt IS 'Date FDA received the report';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy."CASE" IS 'Legacy case identifier format';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy.i_f_cod IS 'Initial/Follow-up code (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy.event_dt IS 'Date when the adverse event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy.age IS 'Age of the patient when event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy.gndr_cod IS 'Gender code (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy.reporter_country IS 'Country code of the reporter';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy.isr IS 'Individual Safety Report identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy.drugname_list IS 'Concatenated list of all drug names in the case';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy.reac_pt_list IS 'Concatenated list of all reaction preferred terms';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.casedemo_legacy.fda_dt IS 'Date FDA received the report';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.caseversion IS 'Version number of the case report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.i_f_code IS 'Initial/Follow-up code (I=Initial, F=Follow-up)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.event_dt IS 'Date when the adverse event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.mfr_dt IS 'Date manufacturer received the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.init_fda_dt IS 'Initial FDA received date';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.fda_dt IS 'Date FDA received the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.rept_cod IS 'Report type code (e.g., spontaneous, study)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.auth_num IS 'Authorization number if applicable';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.mfr_num IS 'Manufacturer control number';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.mfr_sndr IS 'Manufacturer sender identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.lit_ref IS 'Literature reference if report from literature';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.age IS 'Age of the patient when event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.age_cod IS 'Age unit code (e.g., years, months, days)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.age_grp IS 'Age group classification';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.sex IS 'Gender/sex of the patient (M/F/U)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.e_sub IS 'Exposure during pregnancy flag (Y/N)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.wt IS 'Weight of the patient';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.wt_cod IS 'Weight unit code (e.g., kg, lbs)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.rept_dt IS 'Report date by the reporter';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.to_mfr IS 'Reported to manufacturer flag (Y/N)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.occp_cod IS 'Reporter occupation code';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.reporter_country IS 'Country code of the reporter';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.occr_country IS 'Country where the event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.isr IS 'Individual Safety Report identifier (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy."CASE" IS 'Legacy case identifier format';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.i_f_cod IS 'Initial/Follow-up code (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.foll_seq IS 'Follow-up sequence number';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.image IS 'Image identifier or flag';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.event_dt IS 'Date when the adverse event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.mfr_dt IS 'Date manufacturer received the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.fda_dt IS 'Date FDA received the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.rept_cod IS 'Report type code (e.g., spontaneous, study)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.mfr_num IS 'Manufacturer control number';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.mfr_sndr IS 'Manufacturer sender identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.age IS 'Age of the patient when event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.age_cod IS 'Age unit code (e.g., years, months, days)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.gndr_cod IS 'Gender code (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.e_sub IS 'Exposure during pregnancy flag (Y/N)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.wt IS 'Weight of the patient';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.wt_cod IS 'Weight unit code (e.g., kg, lbs)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.rept_dt IS 'Report date by the reporter';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.occp_cod IS 'Reporter occupation code';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.death_dt IS 'Death date if applicable';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.to_mfr IS 'Reported to manufacturer flag (Y/N)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.confid IS 'Confidentiality flag';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.reporter_country IS 'Country code of the reporter';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.demo_legacy.yr_var IS 'Year as text string';

/* =========================
   DRUG & MAPPING TABLES
   ========================= */
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.primaryid IS 'Primary unique identifier for the individual report (joins with demo table)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.drug_seq IS 'Sequence number of the drug in the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.role_cod IS 'Role of the drug in the case (e.g., suspect, concomitant)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.drugname IS 'Reported name of the drug';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.prod_ai IS 'Active ingredient of the product';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.val_vbm IS 'Coded value for validation (typically binary or Y/N)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.route IS 'Route of administration (e.g., oral, intravenous)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.dose_vbm IS 'Verbatim dose text';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.cum_dose_chr IS 'Cumulative dose (text)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.cum_dose_unit IS 'Unit for cumulative dose (e.g., mg, g)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.dechal IS 'Dechallenge result (e.g., yes, no, unknown)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.rechal IS 'Rechallenge result (e.g., yes, no, unknown)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.lot_num IS 'Lot number of the drug product';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.exp_dt IS 'Expiration date of the drug product';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.nda_num IS 'New Drug Application number';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.dose_amt IS 'Dose amount per administration';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.dose_unit IS 'Unit for dose amount (e.g., mg, ml)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.dose_form IS 'Dosage form (e.g., tablet, injection)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.dose_freq IS 'Frequency of dose administration (e.g., daily, BID)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.filename IS 'Source file from which the record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.qtr IS 'Reported quarter of the year';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.qtr_var IS 'Text version of quarter (e.g., Q1, Q2)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.yr IS 'Year of the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug.yr_var IS 'Text version of year (e.g., 2021)';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.isr IS 'Individual Safety Report identifier (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.drug_seq IS 'Sequence number of the drug in the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.role_cod IS 'Role of the drug in the case (e.g., suspect, concomitant)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.drugname IS 'Reported name of the drug';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.val_vbm IS 'Coded value for validation (typically binary or Y/N)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.route IS 'Route of administration (e.g., oral, intravenous)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.dose_vbm IS 'Verbatim dose text as reported';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.dechal IS 'Dechallenge result (e.g., yes, no, unknown)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.rechal IS 'Rechallenge result (e.g., yes, no, unknown)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.lot_num IS 'Lot number of the drug product';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.exp_dt IS 'Expiration date of the drug product';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.nda_num IS 'New Drug Application number';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.qtr_var IS 'Quarter as text';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_legacy.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.combined_drug_mapping.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.combined_drug_mapping.isr IS 'Individual Safety Report identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.combined_drug_mapping.drug_seq IS 'Sequence number of the drug in the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.combined_drug_mapping.role_cod IS 'Role of the drug in the case (e.g., suspect, concomitant)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.combined_drug_mapping.drug_name_original IS 'Original reported drug name as submitted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.combined_drug_mapping.lookup_value IS 'Normalized lookup value for mapping';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.combined_drug_mapping.concept_id IS 'Standard vocabulary concept ID (e.g., RxNorm)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.combined_drug_mapping.update_method IS 'Method used to create the mapping (e.g., automated, manual)';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_brand_name_list.drug_name_original IS 'Original reported drug name from FAERS';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_brand_name_list.ingredient_list IS 'List of active ingredients for the brand name drug';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_brand_name_list.concept_id IS 'Standard vocabulary concept ID (e.g., RxNorm)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_brand_name_list.concept_name IS 'Standard concept name corresponding to the concept_id';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_multi_ingredient_list.drug_name_original IS 'Original reported drug name from FAERS';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_multi_ingredient_list.ingredient_list IS 'List of multiple active ingredients in the drug';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_multi_ingredient_list.concept_id IS 'Standard vocabulary concept ID for multi-ingredient drug';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_multi_ingredient_list.concept_name IS 'Standard concept name for the multi-ingredient drug';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_single_ingredient_list.drug_name_original IS 'Original reported drug name from FAERS';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_single_ingredient_list.ingredient_list IS 'Single active ingredient in the drug';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_single_ingredient_list.concept_id IS 'Standard vocabulary concept ID for single ingredient';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_mapping_single_ingredient_list.concept_name IS 'Standard concept name for the single ingredient';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_nda_mapping.drug_name_original IS 'Original reported drug name from FAERS';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_nda_mapping.nda_num IS 'New Drug Application number';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_nda_mapping.nda_ingredient IS 'Active ingredient listed in the NDA';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_nda_mapping.concept_id IS 'Standard vocabulary concept ID mapped via NDA';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_nda_mapping.update_method IS 'Method used to create the NDA-based mapping';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_regex_mapping.drug_name_original IS 'Original reported drug name from FAERS';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_regex_mapping.drug_name_clean IS 'Cleaned drug name after regex processing';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_regex_mapping.concept_id IS 'Standard vocabulary concept ID mapped via regex';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_regex_mapping.update_method IS 'Regex method used to create the mapping';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_regex_mapping_words.drug_name_original IS 'Original reported drug name from FAERS';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_regex_mapping_words.concept_name IS 'Standard concept name from vocabulary';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_regex_mapping_words.concept_id IS 'Standard vocabulary concept ID';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_regex_mapping_words.update_method IS 'Word-based regex method used for mapping';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_regex_mapping_words.word IS 'Individual word extracted for mapping';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_usagi_mapping.drug_name_original IS 'Original reported drug name from FAERS';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_usagi_mapping.concept_name IS 'Standard concept name from USAGI mapping';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_usagi_mapping.concept_class_id IS 'Concept class identifier (e.g., Ingredient, Brand Name)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_usagi_mapping.concept_id IS 'Standard vocabulary concept ID from USAGI';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drug_usagi_mapping.update_method IS 'USAGI-based method used to create the mapping';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drugname_legacy_list.isr IS 'Individual Safety Report identifier (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drugname_legacy_list.drugname_list IS 'Concatenated list of all drug names in the legacy case';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.drugname_list.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.drugname_list.drugname_list IS 'Concatenated list of all drug names in the case';

/* =========================
   EU DRUG NAME TABLES
   ========================= */
COMMENT ON COLUMN ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient.active_substance IS 'Active pharmaceutical ingredient name from EU database';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient.brand_name IS 'Brand/trade name associated with the active substance';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient.eu_number IS 'EU authorization or reference number';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient.reference_name IS 'Canonical or reference standardized name';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient_mapping.active_substance IS 'Active pharmaceutical ingredient name from EU database';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient_mapping.brand_name IS 'Brand/trade name mapped to the active substance';

/* =========================
   INDICATION / OUTCOME / REACTION / SOURCE TABLES
   ========================= */
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi.indi_drug_seq IS 'Drug sequence number for the indication';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi.indi_pt IS 'Indication preferred term (MedDRA PT)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi_legacy.isr IS 'Individual Safety Report identifier (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi_legacy.drug_seq IS 'Drug sequence number for the indication';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi_legacy.indi_pt IS 'Indication preferred term (MedDRA PT)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi_legacy.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi_legacy.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi_legacy.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi_legacy.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.indi_legacy.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc.outc_code IS 'Outcome code (e.g., DE=Death, LT=Life-threatening, HO=Hospitalization)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc_legacy.isr IS 'Individual Safety Report identifier (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc_legacy.outc_cod IS 'Outcome code (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc_legacy.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc_legacy.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc_legacy.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc_legacy.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.outc_legacy.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac.pt IS 'Preferred term for the adverse reaction (MedDRA PT)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac.drug_rec_act IS 'Drug recurrence action taken';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_legacy.isr IS 'Individual Safety Report identifier (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_legacy.pt IS 'Preferred term for the adverse reaction (MedDRA PT)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_legacy.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_legacy.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_legacy.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_legacy.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_legacy.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr.rpsr_cod IS 'Report source code (e.g., consumer, healthcare professional)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr_legacy.isr IS 'Individual Safety Report identifier (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr_legacy.rpsr_cod IS 'Report source code (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr_legacy.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr_legacy.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr_legacy.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr_legacy.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.rpsr_legacy.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_pt_legacy_list.isr IS 'Individual Safety Report identifier (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_pt_legacy_list.reac_pt_list IS 'Concatenated list of all reaction preferred terms for legacy case';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_pt_list.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.reac_pt_list.reac_pt_list IS 'Concatenated list of all reaction preferred terms for the case';

/* =========================
   STANDARD / NORMALIZED TABLES
   ========================= */
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_adr.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_adr.isr IS 'Individual Safety Report identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_adr.pt IS 'Preferred term for the adverse drug reaction (MedDRA PT)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_adr.outcome_concept_id IS 'Standard vocabulary concept ID for the outcome';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_adr.snomed_outcome_concept_id IS 'SNOMED CT concept ID for the standardized outcome';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_drug.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_drug.isr IS 'Individual Safety Report identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_drug.drug_seq IS 'Sequence number of the drug in the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_drug.role_cod IS 'Role of the drug in the case (e.g., suspect, concomitant)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_drug.standard_concept_id IS 'Standardized vocabulary concept ID for the drug (e.g., RxNorm)';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_indication.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_indication.isr IS 'Individual Safety Report identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_indication.indi_drug_seq IS 'Drug sequence number for the indication';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_indication.indi_pt IS 'Indication preferred term (MedDRA PT)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_indication.indication_concept_id IS 'Standard vocabulary concept ID for the indication';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_indication.snomed_indication_concept_id IS 'SNOMED CT concept ID for the standardized indication';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_outcome_category.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_outcome_category.isr IS 'Individual Safety Report identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_outcome_category.outc_code IS 'Outcome code (e.g., DE=Death, LT=Life-threatening)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_case_outcome_category.snomed_concept_id IS 'SNOMED CT concept ID for the standardized outcome category';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_combined_drug_mapping.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_combined_drug_mapping.isr IS 'Individual Safety Report identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_combined_drug_mapping.drug_seq IS 'Sequence number of the drug in the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_combined_drug_mapping.role_cod IS 'Role of the drug in the case (e.g., suspect, concomitant)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_combined_drug_mapping.drug_name_original IS 'Original reported drug name as submitted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_combined_drug_mapping.lookup_value IS 'Normalized lookup value used for mapping';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_combined_drug_mapping.concept_id IS 'Intermediate concept ID from mapping process';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_combined_drug_mapping.update_method IS 'Method used to create the mapping';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.standard_combined_drug_mapping.standard_concept_id IS 'Final standardized vocabulary concept ID (e.g., RxNorm)';

/* =========================
   THERAPY & TEST TABLES
   ========================= */
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.dsg_drug_seq IS 'Drug sequence number for therapy dosage information';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.start_dt IS 'Start date of drug therapy';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.end_dt IS 'End date of drug therapy';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.dur IS 'Duration of drug therapy';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.dur_cod IS 'Duration code/unit (e.g., days, weeks, months)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.isr IS 'Individual Safety Report identifier (legacy format)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.drug_seq IS 'Drug sequence number for therapy information';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.start_dt IS 'Start date of drug therapy';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.end_dt IS 'End date of drug therapy';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.dur IS 'Duration of drug therapy';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.dur_cod IS 'Duration code/unit (e.g., days, weeks, months)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.yr IS 'Year as integer';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.ther_legacy.yr_var IS 'Year as text string';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_1.primaryid IS 'Primary unique identifier for test records';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_1.test_col_1 IS 'First test column for validation purposes';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_1.test_col_2 IS 'Second test column for validation purposes';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_1.filename IS 'Source filename for test data';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_1.qtr_var IS 'Quarter as text for test data';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_1.yr_var IS 'Year as text for test data';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_1.qtr IS 'Quarter as integer for test data';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_1.yr IS 'Year as integer for test data';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_2.primaryid IS 'Primary unique identifier for test records';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_2.test_col_1 IS 'First test column for validation purposes';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_2.test_col_2 IS 'Second test column for validation purposes';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_2.filename IS 'Source filename for test data';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_2.qtr_var IS 'Quarter as text for test data';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_2.yr_var IS 'Year as text for test data';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_2.qtr IS 'Quarter as integer for test data';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.test_table_2.yr IS 'Year as integer for test data';

/* =========================
   UNIQUE / AGGREGATE TABLES
   ========================= */
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_case.caseid IS 'Case identifier - unique cases across datasets';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_case.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_case.isr IS 'Individual Safety Report identifier';

COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.database IS 'Database source identifier (e.g., FAERS, LAERS)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.isr IS 'Individual Safety Report identifier';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.caseversion IS 'Version number of the case report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.i_f_code IS 'Initial/Follow-up code (I=Initial, F=Follow-up)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.event_dt IS 'Date when the adverse event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.age IS 'Age of the patient when event occurred';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.sex IS 'Gender/sex of the patient (M/F/U)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.reporter_country IS 'Country code of the reporter';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.drugname_list IS 'Concatenated list of all drug names in the case';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.reac_pt_list IS 'Concatenated list of all reaction preferred terms';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.unique_all_casedemo.fda_dt IS 'Date FDA received the report';

/* =========================
   USAGI IMPORT TABLE
   ========================= */
COMMENT ON COLUMN ${DATABASE_SCHEMA}.usagi_import.source_code IS 'Original source code to be mapped';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.usagi_import.source_concept_id IS 'Source concept identifier if available';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.usagi_import.source_vocabulary_id IS 'Vocabulary ID for the source terminology';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.usagi_import.source_code_description IS 'Description of the source code';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.usagi_import.target_concept_id IS 'Target standard vocabulary concept ID';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.usagi_import.target_vocabulary_id IS 'Vocabulary ID for the target terminology';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.usagi_import.valid_start_date IS 'Date when the mapping becomes valid';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.usagi_import.valid_end_date IS 'Date when the mapping expires';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.usagi_import.invalid_reason IS 'Reason why mapping is invalid (if applicable)';

/* =========================
   LOGGING TABLE
   ========================= */
COMMENT ON COLUMN public.pdi_logging.channel_id IS 'Unique identifier for the PDI channel/step';
COMMENT ON COLUMN public.pdi_logging.lines_read IS 'Number of lines read by the step';
COMMENT ON COLUMN public.pdi_logging.lines_written IS 'Number of lines written by the step';
COMMENT ON COLUMN public.pdi_logging.lines_updated IS 'Number of lines updated by the step';
COMMENT ON COLUMN public.pdi_logging.lines_input IS 'Number of lines input to the step';
COMMENT ON COLUMN public.pdi_logging.lines_output IS 'Number of lines output from the step';
COMMENT ON COLUMN public.pdi_logging.lines_rejected IS 'Number of lines rejected by the step';
COMMENT ON COLUMN public.pdi_logging.errors IS 'Number of errors encountered';
COMMENT ON COLUMN public.pdi_logging.id_job IS 'Job identifier in PDI';
COMMENT ON COLUMN public.pdi_logging.jobname IS 'Name of the PDI job';
COMMENT ON COLUMN public.pdi_logging.status IS 'Execution status (e.g., running, finished, error)';
COMMENT ON COLUMN public.pdi_logging.startdate IS 'Start timestamp of execution';
COMMENT ON COLUMN public.pdi_logging.enddate IS 'End timestamp of execution';
COMMENT ON COLUMN public.pdi_logging.logdate IS 'Log entry timestamp';
COMMENT ON COLUMN public.pdi_logging.depdate IS 'Dependency date';
COMMENT ON COLUMN public.pdi_logging.replaydate IS 'Replay date if applicable';
COMMENT ON COLUMN public.pdi_logging.log_field IS 'Log message text';
COMMENT ON COLUMN public.pdi_logging.id_batch IS 'Batch identifier';
COMMENT ON COLUMN public.pdi_logging.log_date IS 'Alternative log date field';
COMMENT ON COLUMN public.pdi_logging.logging_object_type IS 'Type of logging object (e.g., JOB, TRANS)';
COMMENT ON COLUMN public.pdi_logging.object_name IS 'Name of the object being logged';
COMMENT ON COLUMN public.pdi_logging.object_copy IS 'Copy number of the object';
COMMENT ON COLUMN public.pdi_logging.repository_directory IS 'Repository directory path';
COMMENT ON COLUMN public.pdi_logging.filename IS 'Filename of the PDI object';
COMMENT ON COLUMN public.pdi_logging.object_id IS 'Unique object identifier';
COMMENT ON COLUMN public.pdi_logging.object_revision IS 'Object revision number';
COMMENT ON COLUMN public.pdi_logging.parent_channel_id IS 'Parent channel identifier';
COMMENT ON COLUMN public.pdi_logging.root_channel_id IS 'Root channel identifier';
COMMENT ON COLUMN public.pdi_logging.transname IS 'Transformation name';
COMMENT ON COLUMN public.pdi_logging.stepname IS 'Step name within transformation';
COMMENT ON COLUMN public.pdi_logging.result IS 'Step execution result (e.g., Y/N)';
COMMENT ON COLUMN public.pdi_logging.nr_result_rows IS 'Number of result rows';
COMMENT ON COLUMN public.pdi_logging.nr_result_files IS 'Number of result files';
COMMENT ON COLUMN public.pdi_logging.metrics_date IS 'Metrics collection date';
COMMENT ON COLUMN public.pdi_logging.metrics_code IS 'Metrics code identifier';
COMMENT ON COLUMN public.pdi_logging.metrics_description IS 'Description of the metric';
COMMENT ON COLUMN public.pdi_logging.metrics_subject IS 'Subject of the metric';
COMMENT ON COLUMN public.pdi_logging.metrics_type IS 'Type of metric collected';
COMMENT ON COLUMN public.pdi_logging.metrics_value IS 'Numeric value of the metric';
COMMENT ON COLUMN public.pdi_logging.seq_nr IS 'Sequence number';
COMMENT ON COLUMN public.pdi_logging.step_copy IS 'Step copy number';
COMMENT ON COLUMN public.pdi_logging.input_buffer_rows IS 'Number of rows in input buffer';
COMMENT ON COLUMN public.pdi_logging.output_buffer_rows IS 'Number of rows in output buffer';
COMMENT ON COLUMN public.pdi_logging.executing_server IS 'Server where execution occurred';
COMMENT ON COLUMN public.pdi_logging.executing_user IS 'User who executed the job/transformation';
COMMENT ON COLUMN public.pdi_logging.client IS 'Client application identifier';
COMMENT ON COLUMN public.pdi_logging.start_job_entry IS 'Starting job entry name';
COMMENT ON COLUMN public.pdi_logging.copy_nr IS 'Copy number';
COMMENT ON COLUMN public.pdi_logging."RESULT" IS 'Overall result (duplicate field)';

/* =========================
   VOCABULARY STAGING TABLES
   ========================= */
COMMENT ON COLUMN staging_vocabulary.attribute_definition.attribute_definition_id IS 'Unique identifier for the attribute definition';
COMMENT ON COLUMN staging_vocabulary.attribute_definition.attribute_name IS 'Name of the attribute';
COMMENT ON COLUMN staging_vocabulary.attribute_definition.attribute_description IS 'Description of the attribute';
COMMENT ON COLUMN staging_vocabulary.attribute_definition.attribute_type_concept_id IS 'Concept ID for the attribute type';
COMMENT ON COLUMN staging_vocabulary.attribute_definition.attribute_syntax IS 'Formal syntax definition for the attribute';

COMMENT ON COLUMN staging_vocabulary.cohort_definition.cohort_definition_id IS 'Unique identifier for the cohort definition';
COMMENT ON COLUMN staging_vocabulary.cohort_definition.cohort_definition_name IS 'Name of the cohort definition';
COMMENT ON COLUMN staging_vocabulary.cohort_definition.cohort_definition_description IS 'Description of the cohort';
COMMENT ON COLUMN staging_vocabulary.cohort_definition.definition_type_concept_id IS 'Concept ID for the type of definition';
COMMENT ON COLUMN staging_vocabulary.cohort_definition.cohort_definition_syntax IS 'Expression or syntax defining the cohort';
COMMENT ON COLUMN staging_vocabulary.cohort_definition.subject_concept_id IS 'Concept ID representing the subject type';
COMMENT ON COLUMN staging_vocabulary.cohort_definition.cohort_initiation_date IS 'Date when the cohort becomes active';

COMMENT ON COLUMN staging_vocabulary.concept.concept_id IS 'Unique identifier for the concept in the vocabulary';
COMMENT ON COLUMN staging_vocabulary.concept.concept_name IS 'Human-readable name/description of the concept';
COMMENT ON COLUMN staging_vocabulary.concept.domain_id IS 'Domain classification (e.g., Drug, Condition, Procedure)';
COMMENT ON COLUMN staging_vocabulary.concept.vocabulary_id IS 'Vocabulary source (e.g., SNOMED, RxNorm, ICD10CM)';
COMMENT ON COLUMN staging_vocabulary.concept.concept_class_id IS 'Class within the vocabulary (e.g., Ingredient, Brand Name)';
COMMENT ON COLUMN staging_vocabulary.concept.standard_concept IS 'Flag if standard concept (S=Standard, C=Classification)';
COMMENT ON COLUMN staging_vocabulary.concept.concept_code IS 'Original code from the source vocabulary';
COMMENT ON COLUMN staging_vocabulary.concept.valid_start_date IS 'Date when the concept becomes valid';
COMMENT ON COLUMN staging_vocabulary.concept.valid_end_date IS 'Date when the concept expires';
COMMENT ON COLUMN staging_vocabulary.concept.invalid_reason IS 'Reason why concept is invalid (D=Deleted, U=Updated)';

COMMENT ON COLUMN staging_vocabulary.concept_ancestor.ancestor_concept_id IS 'Concept ID of the ancestor concept';
COMMENT ON COLUMN staging_vocabulary.concept_ancestor.descendant_concept_id IS 'Concept ID of the descendant concept';
COMMENT ON COLUMN staging_vocabulary.concept_ancestor.min_levels_of_separation IS 'Minimum hierarchical separation';
COMMENT ON COLUMN staging_vocabulary.concept_ancestor.max_levels_of_separation IS 'Maximum hierarchical separation';

COMMENT ON COLUMN staging_vocabulary.concept_class.concept_class_id IS 'Unique identifier for the concept class';
COMMENT ON COLUMN staging_vocabulary.concept_class.concept_class_name IS 'Name of the concept class';
COMMENT ON COLUMN staging_vocabulary.concept_class.concept_class_concept_id IS 'Concept ID representing the concept class';

COMMENT ON COLUMN staging_vocabulary.concept_relationship.concept_id_1 IS 'First concept in the relationship';
COMMENT ON COLUMN staging_vocabulary.concept_relationship.concept_id_2 IS 'Second concept in the relationship';
COMMENT ON COLUMN staging_vocabulary.concept_relationship.relationship_id IS 'Type of relationship (e.g., Maps to, Is a)';
COMMENT ON COLUMN staging_vocabulary.concept_relationship.valid_start_date IS 'Date when the relationship becomes valid';
COMMENT ON COLUMN staging_vocabulary.concept_relationship.valid_end_date IS 'Date when the relationship expires';
COMMENT ON COLUMN staging_vocabulary.concept_relationship.invalid_reason IS 'Reason why relationship is invalid';

COMMENT ON COLUMN staging_vocabulary.concept_synonym.concept_id IS 'Concept ID associated with the synonym';
COMMENT ON COLUMN staging_vocabulary.concept_synonym.concept_synonym_name IS 'Synonymous name for the concept';
COMMENT ON COLUMN staging_vocabulary.concept_synonym.language_concept_id IS 'Language concept ID of the synonym';

COMMENT ON COLUMN staging_vocabulary.domain.domain_id IS 'Unique identifier for the domain';
COMMENT ON COLUMN staging_vocabulary.domain.domain_name IS 'Human-readable name of the domain';
COMMENT ON COLUMN staging_vocabulary.domain.domain_concept_id IS 'Concept ID that represents this domain';

COMMENT ON COLUMN staging_vocabulary.drug_strength.drug_concept_id IS 'Concept ID for the drug product';
COMMENT ON COLUMN staging_vocabulary.drug_strength.ingredient_concept_id IS 'Concept ID for the active ingredient';
COMMENT ON COLUMN staging_vocabulary.drug_strength.amount_value IS 'Amount of ingredient in the drug product';
COMMENT ON COLUMN staging_vocabulary.drug_strength.amount_unit_concept_id IS 'Unit concept ID for the amount';
COMMENT ON COLUMN staging_vocabulary.drug_strength.numerator_value IS 'Numerator value for concentration';
COMMENT ON COLUMN staging_vocabulary.drug_strength.numerator_unit_concept_id IS 'Unit concept ID for numerator';
COMMENT ON COLUMN staging_vocabulary.drug_strength.denominator_value IS 'Denominator value for concentration';
COMMENT ON COLUMN staging_vocabulary.drug_strength.denominator_unit_concept_id IS 'Unit concept ID for denominator';
COMMENT ON COLUMN staging_vocabulary.drug_strength.box_size IS 'Number of units in the package';
COMMENT ON COLUMN staging_vocabulary.drug_strength.valid_start_date IS 'Date when the drug strength becomes valid';
COMMENT ON COLUMN staging_vocabulary.drug_strength.valid_end_date IS 'Date when the drug strength expires';
COMMENT ON COLUMN staging_vocabulary.drug_strength.invalid_reason IS 'Reason why drug strength record is invalid';

COMMENT ON COLUMN staging_vocabulary.indi.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN staging_vocabulary.indi.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN staging_vocabulary.indi.indi_drug_seq IS 'Drug sequence number for the indication';
COMMENT ON COLUMN staging_vocabulary.indi.indi_pt IS 'Indication preferred term (MedDRA PT)';
COMMENT ON COLUMN staging_vocabulary.indi.filename IS 'Source filename from which record was extracted';

COMMENT ON COLUMN staging_vocabulary.reac.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN staging_vocabulary.reac.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN staging_vocabulary.reac.pt IS 'Preferred term for the adverse reaction (MedDRA PT)';
COMMENT ON COLUMN staging_vocabulary.reac.drug_rec_act IS 'Drug recurrence action taken';
COMMENT ON COLUMN staging_vocabulary.reac.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN staging_vocabulary.reac.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN staging_vocabulary.reac.yr IS 'Year as integer';
COMMENT ON COLUMN staging_vocabulary.reac.yr_var IS 'Year as text string';
COMMENT ON COLUMN staging_vocabulary.reac.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';

COMMENT ON COLUMN staging_vocabulary.relationship.relationship_id IS 'Unique identifier for the relationship type';
COMMENT ON COLUMN staging_vocabulary.relationship.relationship_name IS 'Human-readable name of the relationship';
COMMENT ON COLUMN staging_vocabulary.relationship.is_hierarchical IS 'Whether the relationship defines a hierarchy (1=Yes, 0=No)';
COMMENT ON COLUMN staging_vocabulary.relationship.defines_ancestry IS 'Whether this relationship defines ancestry (1=Yes, 0=No)';
COMMENT ON COLUMN staging_vocabulary.relationship.reverse_relationship_id IS 'ID of the reverse relationship';
COMMENT ON COLUMN staging_vocabulary.relationship.relationship_concept_id IS 'Concept ID that represents this relationship type';

COMMENT ON COLUMN staging_vocabulary.rpsr.primaryid IS 'Primary unique identifier for the report';
COMMENT ON COLUMN staging_vocabulary.rpsr.caseid IS 'Case identifier - groups related reports';
COMMENT ON COLUMN staging_vocabulary.rpsr.rpsr_cod IS 'Report source code';
COMMENT ON COLUMN staging_vocabulary.rpsr.filename IS 'Source filename from which record was extracted';
COMMENT ON COLUMN staging_vocabulary.rpsr.qtr IS 'Quarter of the year (1-4)';
COMMENT ON COLUMN staging_vocabulary.rpsr.yr IS 'Year as integer';
COMMENT ON COLUMN staging_vocabulary.rpsr.qtr_var IS 'Quarter as text (e.g., Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN staging_vocabulary.rpsr.yr_var IS 'Year as text string';

COMMENT ON COLUMN staging_vocabulary.source_to_concept_map.source_code IS 'Source code being mapped';
COMMENT ON COLUMN staging_vocabulary.source_to_concept_map.source_concept_id IS 'Source concept ID';
COMMENT ON COLUMN staging_vocabulary.source_to_concept_map.source_vocabulary_id IS 'Vocabulary ID of the source';
COMMENT ON COLUMN staging_vocabulary.source_to_concept_map.source_code_description IS 'Description of the source code';
COMMENT ON COLUMN staging_vocabulary.source_to_concept_map.target_concept_id IS 'Target concept ID';
COMMENT ON COLUMN staging_vocabulary.source_to_concept_map.target_vocabulary_id IS 'Vocabulary ID of the target';
COMMENT ON COLUMN staging_vocabulary.source_to_concept_map.valid_start_date IS 'Date mapping becomes valid';
COMMENT ON COLUMN staging_vocabulary.source_to_concept_map.valid_end_date IS 'Date mapping expires';
COMMENT ON COLUMN staging_vocabulary.source_to_concept_map.invalid_reason IS 'Reason mapping is invalid (if applicable)';

COMMENT ON COLUMN staging_vocabulary.vocabulary.vocabulary_id IS 'Unique identifier for the vocabulary (e.g., SNOMED, RxNorm)';
COMMENT ON COLUMN staging_vocabulary.vocabulary.vocabulary_name IS 'Full name of the vocabulary';
COMMENT ON COLUMN staging_vocabulary.vocabulary.vocabulary_reference IS 'Reference or URL for the vocabulary source';
COMMENT ON COLUMN staging_vocabulary.vocabulary.vocabulary_version IS 'Version of the vocabulary being used';
COMMENT ON COLUMN staging_vocabulary.vocabulary.vocabulary_concept_id IS 'Concept ID that represents this vocabulary';

/* =========================
   QA TABLE
   ========================= */
COMMENT ON COLUMN ${DATABASE_SCHEMA}.z_qa_faers_wc_import_log.log_filename IS 'Name of the log file';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.z_qa_faers_wc_import_log.filename IS 'Base name of the file without extension';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.z_qa_faers_wc_import_log.laers_or_faers IS 'Type of data, e.g., faers';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.z_qa_faers_wc_import_log.yr IS 'Year of the data';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.z_qa_faers_wc_import_log.qtr IS 'Quarter of the data (1-4)';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.z_qa_faers_wc_import_log.wc_l_count IS 'Line count from wc -l';
COMMENT ON COLUMN ${DATABASE_SCHEMA}.z_qa_faers_wc_import_log.loaded_at IS 'Timestamp when data is inserted';

COMMIT;
