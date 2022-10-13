--if LOAD_ALL_TIME drops & creates domain tables
--truncates are not needed if LOAD_ALL_TIME because dropped then created; and not needed if just adding new quarter of data

set search_path = ${DATABASE_SCHEMA};

--demo

--drop table if exists demo;
CREATE TABLE IF NOT EXISTS demo (
	primaryid varchar NULL,
	caseid varchar NULL,
	caseversion varchar NULL,
	i_f_code varchar NULL,
	event_dt varchar NULL,
	mfr_dt varchar NULL,
	init_fda_dt varchar NULL,
	fda_dt varchar NULL,
	rept_cod varchar NULL,
	auth_num varchar NULL,
	mfr_num varchar NULL,
	mfr_sndr varchar NULL,
	lit_ref varchar NULL,
	age varchar NULL,
	age_cod varchar NULL,
	age_grp varchar NULL,
	sex varchar NULL,
	e_sub varchar NULL,
	wt varchar NULL,
	wt_cod varchar NULL,
	rept_dt varchar NULL,
	to_mfr varchar NULL,
	occp_cod varchar NULL,
	reporter_country varchar NULL,
	occr_country varchar NULL,
	filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate demo;


--drug

--drop table if exists drug;
CREATE TABLE IF NOT EXISTS drug (
	primaryid varchar NULL,
	caseid varchar NULL,
	drug_seq varchar NULL,
	role_cod varchar NULL,
	drugname varchar NULL,
	prod_ai varchar NULL,
	val_vbm varchar NULL,
	route varchar NULL,
	dose_vbm varchar NULL,
	cum_dose_chr varchar NULL,
	cum_dose_unit varchar NULL,
	dechal varchar NULL,
	rechal varchar NULL,
	lot_num varchar NULL,
	exp_dt varchar NULL,
	nda_num varchar NULL,
	dose_amt varchar NULL,
	dose_unit varchar NULL,
	dose_form varchar NULL,
	dose_freq varchar NULL,
	filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate drug;


--indi

--drop table if exists indi ;
create table IF NOT EXISTS indi
(
primaryid varchar,
caseid varchar,
indi_drug_seq varchar,
indi_pt varchar,
filename varchar,
    qtr_var varchar NULL,
    yr_var varchar NULL,
qtr int NULL,
yr int NULL
);
--truncate indi;
--CREATE INDEX IF NOT EXISTS indi_caseid_idx ON frs.indi USING btree (caseid); --NOTE FRS does not exist
CREATE INDEX IF NOT EXISTS indi_filename_idx ON indi USING btree (filename);



--outc
--drop table if exists outc ;
CREATE TABLE IF NOT EXISTS outc (
	primaryid varchar NULL,
	caseid varchar NULL,
	outc_code varchar NULL,
	filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate outc;
CREATE INDEX IF NOT EXISTS outc_caseid_idx ON outc USING btree (caseid);
CREATE INDEX IF NOT EXISTS outc_filename_idx ON outc USING btree (filename);


--reac

--drop table if exists reac ;
CREATE TABLE IF NOT EXISTS reac (
	primaryid varchar NULL,
	caseid varchar NULL,
	pt varchar NULL,
	drug_rec_act varchar NULL,
	filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate reac ;
CREATE INDEX IF NOT EXISTS ix_reac_1 ON reac USING btree (upper((pt)::text));
CREATE INDEX IF NOT EXISTS ix_reac_2 ON reac USING btree (primaryid);
CREATE INDEX IF NOT EXISTS reac_caseid_idx ON reac USING btree (caseid);
CREATE INDEX IF NOT EXISTS reac_filename_idx ON reac USING btree (filename);


--rpsr

--drop table if exists rpsr;
CREATE TABLE IF NOT EXISTS rpsr (
	primaryid varchar NULL,
	caseid varchar NULL,
	rpsr_cod varchar NULL,
	filename varchar NULL,
    qtr_var varchar NULL,
    yr_var varchar NULL,
    qtr int NULL,
    yr int NULL
);
--truncate rpsr;
CREATE INDEX IF NOT EXISTS rpsr_caseid_idx ON rpsr USING btree (caseid, primaryid);
CREATE INDEX IF NOT EXISTS rpsr_filename_idx ON rpsr USING btree (filename);

--ther

--drop table if exists ther ;
CREATE TABLE IF NOT EXISTS ther (
	primaryid varchar NULL,
	caseid varchar NULL,
	dsg_drug_seq varchar NULL,
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
--truncate ther;