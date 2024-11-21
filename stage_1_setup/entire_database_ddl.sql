--
-- PostgreSQL database dump
--

-- Dumped from database version 12.20 (Ubuntu 12.20-1.pgdg20.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ${DATABASE_SCHEMA}; Type: SCHEMA; Schema: -; Owner: ${DATABASE_USERNAME}
--

CREATE SCHEMA IF NOT EXISTS ${DATABASE_SCHEMA};


ALTER SCHEMA ${DATABASE_SCHEMA} OWNER TO ${DATABASE_USERNAME};

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: staging_vocabulary; Type: SCHEMA; Schema: -; Owner: ${DATABASE_USERNAME}
--

CREATE SCHEMA IF NOT EXISTS staging_vocabulary;


ALTER SCHEMA staging_vocabulary OWNER TO ${DATABASE_USERNAME};

-- SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: all_casedemo; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.all_casedemo (
    database text,
    caseid character varying,
    isr character varying,
    caseversion character varying,
    i_f_code character varying,
    event_dt character varying,
    age character varying,
    sex character varying,
    reporter_country character varying,
    primaryid character varying,
    drugname_list text,
    reac_pt_list text,
    fda_dt character varying,
    imputed_field_name text
);


ALTER TABLE ${DATABASE_SCHEMA}.all_casedemo OWNER TO ${DATABASE_USERNAME};

--
-- Name: casedemo; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.casedemo (
    caseid character varying,
    caseversion character varying,
    i_f_code character varying,
    event_dt character varying,
    age character varying,
    sex character varying,
    reporter_country character varying,
    primaryid character varying,
    drugname_list text,
    reac_pt_list text,
    fda_dt character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.casedemo OWNER TO ${DATABASE_USERNAME};

--
-- Name: casedemo_legacy; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.casedemo_legacy (
    "CASE" character varying,
    i_f_cod character varying,
    event_dt character varying,
    age character varying,
    gndr_cod character varying,
    reporter_country character varying,
    isr character varying,
    drugname_list text,
    reac_pt_list text,
    fda_dt character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.casedemo_legacy OWNER TO ${DATABASE_USERNAME};

--
-- Name: combined_drug_mapping; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.combined_drug_mapping (
    primaryid character varying,
    isr character varying,
    drug_seq character varying,
    role_cod character varying,
    drug_name_original character varying,
    lookup_value character varying,
    concept_id integer,
    update_method character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.combined_drug_mapping OWNER TO ${DATABASE_USERNAME};

--
-- Name: country_code; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.country_code (
    country_name character varying,
    country_code character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.country_code OWNER TO ${DATABASE_USERNAME};

--
-- Name: default_all_casedemo_age_keys; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.default_all_casedemo_age_keys (
    caseid character varying,
    event_dt character varying,
    sex character varying,
    reporter_country character varying,
    default_age text
);


ALTER TABLE ${DATABASE_SCHEMA}.default_all_casedemo_age_keys OWNER TO ${DATABASE_USERNAME};

--
-- Name: default_all_casedemo_event_dt_keys; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.default_all_casedemo_event_dt_keys (
    caseid character varying,
    age character varying,
    sex character varying,
    reporter_country character varying,
    default_event_dt text
);


ALTER TABLE ${DATABASE_SCHEMA}.default_all_casedemo_event_dt_keys OWNER TO ${DATABASE_USERNAME};

--
-- Name: default_all_casedemo_reporter_country_keys; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.default_all_casedemo_reporter_country_keys (
    caseid character varying,
    event_dt character varying,
    age character varying,
    sex character varying,
    default_reporter_country text
);


ALTER TABLE ${DATABASE_SCHEMA}.default_all_casedemo_reporter_country_keys OWNER TO ${DATABASE_USERNAME};

--
-- Name: default_all_casedemo_sex_keys; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.default_all_casedemo_sex_keys (
    caseid character varying,
    event_dt character varying,
    age character varying,
    reporter_country character varying,
    default_sex text
);


ALTER TABLE ${DATABASE_SCHEMA}.default_all_casedemo_sex_keys OWNER TO ${DATABASE_USERNAME};

--
-- Name: demo; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.demo (
    primaryid character varying,
    caseid character varying,
    caseversion character varying,
    i_f_code character varying,
    event_dt character varying,
    mfr_dt character varying,
    init_fda_dt character varying,
    fda_dt character varying,
    rept_cod character varying,
    auth_num character varying,
    mfr_num character varying,
    mfr_sndr character varying,
    lit_ref character varying,
    age character varying,
    age_cod character varying,
    age_grp character varying,
    sex character varying,
    e_sub character varying,
    wt character varying,
    wt_cod character varying,
    rept_dt character varying,
    to_mfr character varying,
    occp_cod character varying,
    reporter_country character varying,
    occr_country character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.demo OWNER TO ${DATABASE_USERNAME};

--
-- Name: demo_legacy; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.demo_legacy (
    isr character varying,
    "CASE" character varying,
    i_f_cod character varying,
    foll_seq character varying,
    image character varying,
    event_dt character varying,
    mfr_dt character varying,
    fda_dt character varying,
    rept_cod character varying,
    mfr_num character varying,
    mfr_sndr character varying,
    age character varying,
    age_cod character varying,
    gndr_cod character varying,
    e_sub character varying,
    wt character varying,
    wt_cod character varying,
    rept_dt character varying,
    occp_cod character varying,
    death_dt character varying,
    to_mfr character varying,
    confid character varying,
    reporter_country character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.demo_legacy OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug (
    primaryid character varying,
    caseid character varying,
    drug_seq character varying,
    role_cod character varying,
    drugname character varying,
    prod_ai character varying,
    val_vbm character varying,
    route character varying,
    dose_vbm character varying,
    cum_dose_chr character varying,
    cum_dose_unit character varying,
    dechal character varying,
    rechal character varying,
    lot_num character varying,
    exp_dt character varying,
    nda_num character varying,
    dose_amt character varying,
    dose_unit character varying,
    dose_form character varying,
    dose_freq character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.drug OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_ai_mapping; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_ai_mapping (
    drug_name_original character varying,
    prod_ai character varying,
    concept_id integer,
    update_method text
);


ALTER TABLE ${DATABASE_SCHEMA}.drug_ai_mapping OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_legacy; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_legacy (
    isr character varying,
    drug_seq character varying,
    role_cod character varying,
    drugname character varying,
    val_vbm character varying,
    route character varying,
    dose_vbm character varying,
    dechal character varying,
    rechal character varying,
    lot_num character varying,
    exp_dt character varying,
    nda_num character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.drug_legacy OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_mapping_brand_name_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_mapping_brand_name_list (
    drug_name_original character varying,
    ingredient_list text,
    concept_id integer,
    concept_name text
);


ALTER TABLE ${DATABASE_SCHEMA}.drug_mapping_brand_name_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_mapping_multi_ingredient_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_mapping_multi_ingredient_list (
    drug_name_original character varying,
    ingredient_list text,
    concept_id integer,
    concept_name text
);


ALTER TABLE ${DATABASE_SCHEMA}.drug_mapping_multi_ingredient_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_mapping_single_ingredient_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_mapping_single_ingredient_list (
    drug_name_original character varying,
    ingredient_list text,
    concept_id integer,
    concept_name text
);


ALTER TABLE ${DATABASE_SCHEMA}.drug_mapping_single_ingredient_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_nda_mapping; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_nda_mapping (
    drug_name_original character varying,
    nda_num character varying,
    nda_ingredient text,
    concept_id integer,
    update_method text
);


ALTER TABLE ${DATABASE_SCHEMA}.drug_nda_mapping OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_regex_mapping; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_regex_mapping (
    drug_name_original character varying,
    drug_name_clean text,
    concept_id integer,
    update_method text
);


ALTER TABLE ${DATABASE_SCHEMA}.drug_regex_mapping OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_regex_mapping_words; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_regex_mapping_words (
    drug_name_original character varying,
    concept_name character varying,
    concept_id integer,
    update_method text,
    word text
);


ALTER TABLE ${DATABASE_SCHEMA}.drug_regex_mapping_words OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_usagi_mapping; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drug_usagi_mapping (
    drug_name_original text,
    concept_name character varying(1000),
    concept_class_id character varying(500),
    concept_id integer,
    update_method text
);


ALTER TABLE ${DATABASE_SCHEMA}.drug_usagi_mapping OWNER TO ${DATABASE_USERNAME};

--
-- Name: drugname_legacy_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drugname_legacy_list (
    isr character varying,
    drugname_list text
);


ALTER TABLE ${DATABASE_SCHEMA}.drugname_legacy_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: drugname_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.drugname_list (
    primaryid character varying,
    drugname_list text
);


ALTER TABLE ${DATABASE_SCHEMA}.drugname_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: eu_drug_name_active_ingredient; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient (
    active_substance character varying,
    brand_name character varying,
    eu_number character varying,
    reference_name character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient OWNER TO ${DATABASE_USERNAME};

--
-- Name: eu_drug_name_active_ingredient_mapping; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient_mapping (
    active_substance text,
    brand_name text
);


ALTER TABLE ${DATABASE_SCHEMA}.eu_drug_name_active_ingredient_mapping OWNER TO ${DATABASE_USERNAME};

--
-- Name: indi; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.indi (
    primaryid character varying,
    caseid character varying,
    indi_drug_seq character varying,
    indi_pt character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.indi OWNER TO ${DATABASE_USERNAME};

--
-- Name: indi_legacy; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.indi_legacy (
    isr character varying,
    drug_seq character varying,
    indi_pt character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.indi_legacy OWNER TO ${DATABASE_USERNAME};

--
-- Name: meddra_snomed_mapping; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.meddra_snomed_mapping (
    snomed_concept_id integer,
    snomed_concept_name character varying(255),
    snomed_concept_code character varying(50),
    meddra_concept_id integer,
    meddra_concept_name character varying(255),
    meddra_concept_code character varying(50),
    meddra_class_id character varying(20)
);


ALTER TABLE ${DATABASE_SCHEMA}.meddra_snomed_mapping OWNER TO ${DATABASE_USERNAME};

--
-- Name: nda; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.nda (
    ingredient character varying,
    dfroute character varying,
    trade_name character varying,
    applicant character varying,
    strength character varying,
    appl_type character varying,
    appl_no character varying,
    product_no character varying,
    te_code character varying,
    approval_date character varying,
    rld character varying,
    rs character varying,
    type character varying,
    applicant_full_name character varying,
    drug_form character varying,
    route character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.nda OWNER TO ${DATABASE_USERNAME};

--
-- Name: nda_ingredient; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.nda_ingredient (
    appl_no character varying,
    ingredient character varying,
    trade_name character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.nda_ingredient OWNER TO ${DATABASE_USERNAME};

--
-- Name: outc; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.outc (
    primaryid character varying,
    caseid character varying,
    outc_code character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.outc OWNER TO ${DATABASE_USERNAME};

--
-- Name: outc_legacy; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.outc_legacy (
    isr character varying,
    outc_cod character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.outc_legacy OWNER TO ${DATABASE_USERNAME};

--
-- Name: reac; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.reac (
    primaryid character varying,
    caseid character varying,
    pt character varying,
    drug_rec_act character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.reac OWNER TO ${DATABASE_USERNAME};

--
-- Name: reac_legacy; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.reac_legacy (
    isr character varying,
    pt character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.reac_legacy OWNER TO ${DATABASE_USERNAME};

--
-- Name: reac_pt_legacy_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.reac_pt_legacy_list (
    isr character varying,
    reac_pt_list text
);


ALTER TABLE ${DATABASE_SCHEMA}.reac_pt_legacy_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: reac_pt_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.reac_pt_list (
    primaryid character varying,
    reac_pt_list text
);


ALTER TABLE ${DATABASE_SCHEMA}.reac_pt_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: rpsr; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rpsr (
    primaryid character varying,
    caseid character varying,
    rpsr_cod character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.rpsr OWNER TO ${DATABASE_USERNAME};

--
-- Name: rpsr_legacy; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rpsr_legacy (
    isr character varying,
    rpsr_cod character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.rpsr_legacy OWNER TO ${DATABASE_USERNAME};

--
-- Name: rxnorm_mapping_brand_name_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rxnorm_mapping_brand_name_list (
    ingredient_list text,
    concept_id integer,
    concept_name text
);


ALTER TABLE ${DATABASE_SCHEMA}.rxnorm_mapping_brand_name_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: rxnorm_mapping_multi_ingredient_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rxnorm_mapping_multi_ingredient_list (
    ingredient_list text,
    concept_id integer,
    concept_name text
);


ALTER TABLE ${DATABASE_SCHEMA}.rxnorm_mapping_multi_ingredient_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: rxnorm_mapping_single_ingredient_list; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.rxnorm_mapping_single_ingredient_list (
    ingredient_list text,
    concept_id integer,
    concept_name text
);


ALTER TABLE ${DATABASE_SCHEMA}.rxnorm_mapping_single_ingredient_list OWNER TO ${DATABASE_USERNAME};

--
-- Name: standard_case_adr; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_case_adr (
    primaryid character varying,
    isr character varying,
    pt character varying,
    outcome_concept_id integer,
    snomed_outcome_concept_id integer
);


ALTER TABLE ${DATABASE_SCHEMA}.standard_case_adr OWNER TO ${DATABASE_USERNAME};

--
-- Name: standard_case_drug; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_case_drug (
    primaryid character varying,
    isr character varying,
    drug_seq character varying,
    role_cod character varying,
    standard_concept_id integer
);


ALTER TABLE ${DATABASE_SCHEMA}.standard_case_drug OWNER TO ${DATABASE_USERNAME};

--
-- Name: standard_case_indication; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_case_indication (
    primaryid character varying,
    isr character varying,
    indi_drug_seq character varying,
    indi_pt character varying,
    indication_concept_id integer,
    snomed_indication_concept_id integer
);


ALTER TABLE ${DATABASE_SCHEMA}.standard_case_indication OWNER TO ${DATABASE_USERNAME};

--
-- Name: standard_case_outcome_category; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_case_outcome_category (
    primaryid character varying,
    isr character varying,
    outc_code character varying,
    snomed_concept_id integer
);


ALTER TABLE ${DATABASE_SCHEMA}.standard_case_outcome_category OWNER TO ${DATABASE_USERNAME};

--
-- Name: standard_combined_drug_mapping; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.standard_combined_drug_mapping (
    primaryid character varying,
    isr character varying,
    drug_seq character varying,
    role_cod character varying,
    drug_name_original character varying,
    lookup_value character varying,
    concept_id integer,
    update_method character varying,
    standard_concept_id integer
);


ALTER TABLE ${DATABASE_SCHEMA}.standard_combined_drug_mapping OWNER TO ${DATABASE_USERNAME};

--
-- Name: test_table_1; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.test_table_1 (
    primaryid character varying,
    test_col_1 character varying,
    test_col_2 character varying,
    filename character varying,
    qtr_var character varying,
    yr_var character varying,
    qtr integer,
    yr integer
);


ALTER TABLE ${DATABASE_SCHEMA}.test_table_1 OWNER TO ${DATABASE_USERNAME};

--
-- Name: test_table_2; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.test_table_2 (
    primaryid character varying,
    test_col_1 character varying,
    test_col_2 character varying,
    filename character varying,
    qtr_var character varying,
    yr_var character varying,
    qtr integer,
    yr integer
);


ALTER TABLE ${DATABASE_SCHEMA}.test_table_2 OWNER TO ${DATABASE_USERNAME};

--
-- Name: ther; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.ther (
    primaryid character varying,
    caseid character varying,
    dsg_drug_seq character varying,
    start_dt character varying,
    end_dt character varying,
    dur character varying,
    dur_cod character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.ther OWNER TO ${DATABASE_USERNAME};

--
-- Name: ther_legacy; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.ther_legacy (
    isr character varying,
    drug_seq character varying,
    start_dt character varying,
    end_dt character varying,
    dur character varying,
    dur_cod character varying,
    filename character varying,
    qtr integer,
    qtr_var character varying,
    yr integer,
    yr_var character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.ther_legacy OWNER TO ${DATABASE_USERNAME};

--
-- Name: unique_all_case; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.unique_all_case (
    caseid character varying,
    primaryid character varying,
    isr character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.unique_all_case OWNER TO ${DATABASE_USERNAME};

--
-- Name: unique_all_casedemo; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.unique_all_casedemo (
    database text,
    caseid character varying,
    isr character varying,
    caseversion character varying,
    i_f_code character varying,
    event_dt character varying,
    age character varying,
    sex character varying,
    reporter_country character varying,
    primaryid character varying,
    drugname_list text,
    reac_pt_list text,
    fda_dt character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.unique_all_casedemo OWNER TO ${DATABASE_USERNAME};

--
-- Name: usagi_import; Type: TABLE; Schema: ${DATABASE_SCHEMA}; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS ${DATABASE_SCHEMA}.usagi_import (
    source_code character varying,
    source_concept_id character varying,
    source_vocabulary_id character varying,
    source_code_description character varying,
    target_concept_id character varying,
    target_vocabulary_id character varying,
    valid_start_date character varying,
    valid_end_date character varying,
    invalid_reason character varying
);


ALTER TABLE ${DATABASE_SCHEMA}.usagi_import OWNER TO ${DATABASE_USERNAME};

--
-- Name: pdi_logging; Type: TABLE; Schema: public; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS public.pdi_logging (
    channel_id character varying(255),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    id_job integer,
    jobname character varying(255),
    status character varying(15),
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    logdate timestamp without time zone,
    depdate timestamp without time zone,
    replaydate timestamp without time zone,
    log_field text,
    id_batch integer,
    log_date timestamp without time zone,
    logging_object_type character varying(255),
    object_name character varying(255),
    object_copy character varying(255),
    repository_directory character varying(255),
    filename character varying(255),
    object_id character varying(255),
    object_revision character varying(255),
    parent_channel_id character varying(255),
    root_channel_id character varying(255),
    transname character varying(255),
    stepname character varying(255),
    result character varying(5),
    nr_result_rows bigint,
    nr_result_files bigint,
    metrics_date timestamp without time zone,
    metrics_code character varying(255),
    metrics_description character varying(255),
    metrics_subject character varying(255),
    metrics_type character varying(255),
    metrics_value bigint,
    seq_nr integer,
    step_copy integer,
    input_buffer_rows bigint,
    output_buffer_rows bigint,
    executing_server character varying(255),
    executing_user character varying(255),
    client character varying(255),
    start_job_entry character varying(255),
    copy_nr integer,
    "RESULT" character varying(5)
);


ALTER TABLE public.pdi_logging OWNER TO ${DATABASE_USERNAME};

--
-- Name: attribute_definition; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.attribute_definition (
    attribute_definition_id integer NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_description text,
    attribute_type_concept_id integer NOT NULL,
    attribute_syntax text
);


ALTER TABLE staging_vocabulary.attribute_definition OWNER TO ${DATABASE_USERNAME};

--
-- Name: cohort_definition; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.cohort_definition (
    cohort_definition_id integer NOT NULL,
    cohort_definition_name character varying(255) NOT NULL,
    cohort_definition_description text,
    definition_type_concept_id integer NOT NULL,
    cohort_definition_syntax text,
    subject_concept_id integer NOT NULL,
    cohort_initiation_date date
);


ALTER TABLE staging_vocabulary.cohort_definition OWNER TO ${DATABASE_USERNAME};

--
-- Name: concept; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept (
    concept_id integer NOT NULL,
    concept_name character varying(255) NOT NULL,
    domain_id character varying(20) NOT NULL,
    vocabulary_id character varying(20) NOT NULL,
    concept_class_id character varying(20) NOT NULL,
    standard_concept character varying(1),
    concept_code character varying(50) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);


ALTER TABLE staging_vocabulary.concept OWNER TO ${DATABASE_USERNAME};

--
-- Name: concept_ancestor; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept_ancestor (
    ancestor_concept_id integer NOT NULL,
    descendant_concept_id integer NOT NULL,
    min_levels_of_separation integer NOT NULL,
    max_levels_of_separation integer NOT NULL
);


ALTER TABLE staging_vocabulary.concept_ancestor OWNER TO ${DATABASE_USERNAME};

--
-- Name: concept_class; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept_class (
    concept_class_id character varying(100) NOT NULL,
    concept_class_name character varying(255) NOT NULL,
    concept_class_concept_id integer NOT NULL
);


ALTER TABLE staging_vocabulary.concept_class OWNER TO ${DATABASE_USERNAME};

--
-- Name: concept_relationship; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept_relationship (
    concept_id_1 integer NOT NULL,
    concept_id_2 integer NOT NULL,
    relationship_id character varying(20) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);


ALTER TABLE staging_vocabulary.concept_relationship OWNER TO ${DATABASE_USERNAME};

--
-- Name: concept_synonym; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.concept_synonym (
    concept_id integer NOT NULL,
    concept_synonym_name character varying(1000) NOT NULL,
    language_concept_id integer NOT NULL
);


ALTER TABLE staging_vocabulary.concept_synonym OWNER TO ${DATABASE_USERNAME};

--
-- Name: domain; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.domain (
    domain_id character varying(20) NOT NULL,
    domain_name character varying(255) NOT NULL,
    domain_concept_id integer NOT NULL
);


ALTER TABLE staging_vocabulary.domain OWNER TO ${DATABASE_USERNAME};

--
-- Name: drug_strength; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.drug_strength (
    drug_concept_id integer NOT NULL,
    ingredient_concept_id integer NOT NULL,
    amount_value numeric,
    amount_unit_concept_id integer,
    numerator_value numeric,
    numerator_unit_concept_id integer,
    denominator_value numeric,
    denominator_unit_concept_id integer,
    box_size integer,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);


ALTER TABLE staging_vocabulary.drug_strength OWNER TO ${DATABASE_USERNAME};

--
-- Name: indi; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.indi (
    primaryid character varying,
    caseid character varying,
    indi_drug_seq character varying,
    indi_pt character varying,
    filename character varying
);


ALTER TABLE staging_vocabulary.indi OWNER TO ${DATABASE_USERNAME};

--
-- Name: reac; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

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


ALTER TABLE staging_vocabulary.reac OWNER TO ${DATABASE_USERNAME};

--
-- Name: relationship; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.relationship (
    relationship_id character varying(20) NOT NULL,
    relationship_name character varying(255) NOT NULL,
    is_hierarchical character varying(1) NOT NULL,
    defines_ancestry character varying(1) NOT NULL,
    reverse_relationship_id character varying(20) NOT NULL,
    relationship_concept_id integer NOT NULL
);


ALTER TABLE staging_vocabulary.relationship OWNER TO ${DATABASE_USERNAME};

--
-- Name: rpsr; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

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


ALTER TABLE staging_vocabulary.rpsr OWNER TO ${DATABASE_USERNAME};

--
-- Name: source_to_concept_map; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

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


ALTER TABLE staging_vocabulary.source_to_concept_map OWNER TO ${DATABASE_USERNAME};

--
-- Name: vocabulary; Type: TABLE; Schema: staging_vocabulary; Owner: ${DATABASE_USERNAME}
--

CREATE TABLE IF NOT EXISTS staging_vocabulary.vocabulary (
    vocabulary_id character varying(20) NOT NULL,
    vocabulary_name character varying(255) NOT NULL,
    vocabulary_reference character varying(255),
    vocabulary_version character varying(255),
    vocabulary_concept_id integer NOT NULL
);


ALTER TABLE staging_vocabulary.vocabulary OWNER TO ${DATABASE_USERNAME};


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

