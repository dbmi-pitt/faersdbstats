--brian buck changes
--commented out drop's and truncates
--added "if not exists" to creates
--index and binary tree commented out

set search_path = ${DATABASE_SCHEMA};
--demo

--drop table if exists demo_legacy;
CREATE TABLE IF NOT EXISTS demo_legacy (
    isr varchar NULL,
    "CASE" varchar NULL,
    i_f_cod varchar NULL,
    foll_seq varchar NULL,
    image varchar NULL,
    event_dt varchar NULL,
    mfr_dt varchar NULL,
    fda_dt varchar NULL,
    rept_cod varchar NULL,
    mfr_num varchar NULL,
    mfr_sndr varchar NULL,
    age varchar NULL,
    age_cod varchar NULL,
    gndr_cod varchar NULL,
    e_sub varchar NULL,
    wt varchar NULL,
    wt_cod varchar NULL,
    rept_dt varchar NULL,
    occp_cod varchar NULL,
    death_dt varchar NULL,
    to_mfr varchar NULL,
    confid varchar NULL,
    reporter_country varchar NULL,
    filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate demo_legacy;


--drug
--drop table if exists drug_legacy;
create table IF NOT EXISTS drug_legacy
(
    ISR varchar,
    DRUG_SEQ varchar,
    ROLE_COD varchar,
    DRUGNAME varchar,
    VAL_VBM varchar,
    ROUTE varchar,
    DOSE_VBM varchar,
    DECHAL varchar,
    RECHAL varchar,
    LOT_NUM varchar,
    EXP_DT varchar,
    NDA_NUM varchar,
    FILENAME varchar,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate drug_legacy;

--indi

--drop table if exists indi_legacy;
CREATE TABLE IF NOT EXISTS indi_legacy (
    isr varchar NULL,
    drug_seq varchar NULL,
    indi_pt varchar NULL,
    filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate indi_legacy;


--outc
--drop table if exists outc_legacy;
CREATE TABLE IF NOT EXISTS outc_legacy (
    isr varchar NULL,
    outc_cod varchar NULL,
    filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate outc_legacy;


--reac
--drop table if exists reac_legacy;
CREATE TABLE IF NOT EXISTS reac_legacy (
    isr varchar NULL,
    pt varchar NULL,
    filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);

--truncate reac_legacy;

--CREATE INDEX ix_reac_legacy_1 ON reac_legacy USING btree (upper((pt)::text));
--CREATE INDEX ix_reac_legacy_2 ON reac_legacy USING btree (isr);


--reac_pt_legacy
--drop table if exists reac_pt_legacy_list ;
CREATE TABLE IF NOT EXISTS reac_pt_legacy_list (
    isr varchar NULL,
    reac_pt_list text NULL
);
--truncate reac_pt_legacy_list;


--rpsr_legacy
--drop table if exists rpsr_legacy;
CREATE TABLE IF NOT EXISTS rpsr_legacy (
    isr varchar NULL,
    rpsr_cod varchar NULL,
    filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate rpsr_legacy;


--ther_legacy
--drop table if exists ther_legacy ;
CREATE TABLE IF NOT EXISTS ther_legacy (
    isr varchar NULL,
    drug_seq varchar NULL,
    start_dt varchar NULL,
    end_dt varchar NULL,
    dur varchar NULL,
    dur_cod varchar NULL,
    filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate ther_legacy ;


--all_casedemo
--drop table if exists all_casedemo;
CREATE TABLE IF NOT EXISTS all_casedemo (
    "database" text NULL,
    caseid varchar NULL,
    isr varchar NULL,
    caseversion varchar NULL,
    i_f_code varchar NULL,
    event_dt varchar NULL,
    age varchar NULL,
    sex varchar NULL,
    reporter_country varchar NULL,
    primaryid varchar NULL,
    drugname_list text NULL,
    reac_pt_list text NULL,
    fda_dt varchar NULL,
    imputed_field_name text NULL
);
--truncate all_casedemo;