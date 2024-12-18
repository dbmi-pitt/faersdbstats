-- from https://github.com/rkboyce/NaPDI-pv/blob/master/deduplication-strategy/faers-deduplication-strategy-DECEMBER-2022-USES-VIGIBASE.sql

----------------------------
-- NOTE: The current deduplication process combined reports across FAERS and LAERS. 
--       In FAERS data, reports have the same caseid and these are grouped with LAERS data (which uses isr as an identifier) 
--       this assumes that cases are the same across LAERS and FAERS when they have the same event_dt, age, sex, and reporter_country are the same. 
--       However, this DOES NOT fix issues where the same event has been captured by multiple cases in FAERS e.g., where FAERS reports have the 
--       same event_dt, age, sex, and reporter_country. Also, where a lit_ref exists that indicates that the event is from a published case report
--       which tends to result in many different spontanoues reports submitted by different companies. 
--       
--       Here, we set up to handle these situations with another transform by adding to the drill down table standardized fields for
--       age, sex, weight, and lit_ref
-- 
--       We then add the use of the Vigibase table from VigiMatch which adds more sensitive deduplication 

-- PRELIMINARY - obtain lit_ref mapping to unique ids (PMID or internally created)

/* --- THIS COMMMENTED OUT SECTION WAS NOT CHANGED -- 
 * --- TODO: CREATE A FRESH WORKFLOW FOR ALL OF THIS IN PENTAHO ONCE FINALIZED

-- Export lit_ref table from CEM  
select t.lit_ref_present, t.primaryid, t.caseid, t.isr
into scratch_dedup_q1_2004_thr_q2_2022.lit_ref_present_tbl
from (
 select case when d.lit_ref is null then cast(0 as boolean) 
             else cast(1 as boolean) 
        end lit_ref_present,
        d.primaryid, 
        d.caseid,
        null::varchar isr
 from faers.demo d 
 union
 select cast(0 as boolean) lit_ref_present,
        null::varchar primaryid, 
        null::varchar caseid,
        dl.isr
from faers.demo_legacy dl 
) t
;
CREATE INDEX lit_ref_present_tbl_primaryid_idx ON scratch_dedup_q1_2004_thr_q2_2022.lit_ref_present_tbl (primaryid);
CREATE INDEX lit_ref_present_tbl_isr_idx ON scratch_dedup_q1_2004_thr_q2_2022.lit_ref_present_tbl (isr);

-- Export lit_ref table for the updated quarters in cem_2022
drop table if exists scratch_dedup_q1_2004_thr_q2_2022.lit_ref_present_tbl_new_qrtrs;
select distinct lit_ref_present, t.primaryid, t.caseid, t.isr
into scratch_dedup_q1_2004_thr_q2_2022.lit_ref_present_tbl_new_qrtrs
from (
 select cast(1 as boolean) lit_ref_present,
        d.primaryid, 
        d.caseid,
        null::varchar isr
 from faers.demo d 
 where d.lit_ref is not null and
       (
        (d.yr = 21 and d.qtr = 3) or 
        (d.yr = 21 and d.qtr = 4) or
        (d.yr = 22 and d.qtr = 1) or
        (d.yr = 22 and d.qtr = 2)
       )
) t
;
-- Updated Rows	107959

--- newer lit_ref entries for mapping
select demo.primaryid, demo.caseid, demo.lit_ref
from scratch_dedup_q1_2004_thr_q2_2022.lit_ref_present_tbl_new_qrtrs lrm inner join faers.demo on lrm.primaryid = demo.primaryid
;

-----------------------------------------------------------
-- NOTE: Using the process in the Python notebook in https://github.com/rkboyce/NaPDI-pv/tree/master/FAERS-deduplication
--       do the pub identifier mappings/creation
-----------------------------------------------------------

-- Finally, combine all lit_ref mappings into a single table for use by the dedup process. 
select primaryid, caseid, lit_ref, lit_ref_id
into scratch_dedup_q1_2004_thr_q2_2022.combined_lit_ref_to_case_mapping
from (
 select  primaryid, caseid, lit_ref, cast(pmid as int4) lit_ref_id  
 from scratch_dedup_q1_2004_thr_q2_2022.lit_ref_map 
 union
 select  primaryid, caseid, lit_ref, cast(pmid as int4) lit_ref_id 
 from scratch_dedup_q1_2004_thr_q2_2022.lit_ref_map_pmids_newer
 union
 select primaryid, caseid, lit_ref, lit_ref_id 
 from scratch_dedup_q1_2004_thr_q2_2022.lit_ref_map_no_pmids
 union
 select primaryid, caseid, lit_ref, lit_ref_id 
 from scratch_dedup_q1_2004_thr_q2_2022.lit_ref_map_no_pmids_newer
) t 
;
-- Updated Rows	581008
---------------------------------------------------------------------------------


--- DEDUPLICATION PROCESS
---   *The goal is a drill down table that includes standardized NPs and that only points to 
---    a single report for every spontanouesly reported case 

-- 1) create a new schema and copy in the vocabulary tables, index them
---- Done in postgres - scratch_dedup_q1_2004_thr_q2_2022

-- 2) Observe what variety of values are in the critical fields of the demo and demo_legacy tables 
select distinct demo.age
from faers.demo
where demo.age ~ '[a-zA-Z]+'
order by demo.age
;
-- 2 results
/*
FEW
U
*/

select distinct demo_legacy.age
  from faers.demo_legacy 
    where demo_legacy.age ~ '[a-zA-Z]+'
  order by demo_legacy.age
;
-- no results 

select distinct demo_legacy.age, demo_legacy.age_cod
  from faers.demo_legacy 
limit 1000;
-- allot of days, weeks, months in addition to years. 


select distinct demo.age_cod
from faers.demo
-- where yr in (21,22)
order by demo.age_cod
;
/*
DEC
DY
HR
MIN
MON
SEC
WK
YR
*/

select distinct demo_legacy.age_cod
  from faers.demo_legacy 
  order by demo_legacy.age_cod
;
/*
DEC
DY
HR
MIN
MON
WK
YR
 */


select distinct wt
  from faers.demo
  where wt ~ '[a-zA-Z]+'
  -- and yr in (21,22)
  order by wt
;
-- 15 results
/*
100.O
130LB
150L
6T8.0
79KG
82.2 KG
86.2KG
F
M
N/A
NAN
S
U
UNK
YR
 */


select distinct wt 
  from faers.demo_legacy 
  where wt ~ '[a-zA-Z]+'
  order by wt
;
-- no results


select distinct wt_cod
  from faers.demo
  -- where yr in (21,22)
  order by wt_cod
;
/*
GMS
IB
KG
KGS
L
L;
LBS
LG
M
MG
UNK
Y
YEAR
YEARS
YR
*/

select distinct wt_cod
  from faers.demo_legacy
  order by wt_cod
;
/*
GMS
KG
LBS
 */

select distinct sex
  from faers.demo
  -- where yr in (21,22)
  order by sex
;
/*
F
I
M
NS
P
T
UNK
*/

select distinct gndr_cod 
  from faers.demo_legacy 
  order by gndr_cod 
;
/*
F
M
NS
UNK
*/

-- 3) create temp tables that have the standardized field we are interested in. Index the ids so that we can rejoin the 
--    individual tables into a single more complete drill down table. This is more efficient than doing an update all at once

-- A helper function...
-- See Brandstetter's post to https://dba.stackexchange.com/questions/203934/postgresql-alternative-to-sql-server-s-try-cast-function
CREATE OR REPLACE FUNCTION try_cast(_in text, INOUT _out ANYELEMENT)
  LANGUAGE plpgsql AS
$func$
BEGIN
   EXECUTE format('SELECT %L::%s', $1, pg_typeof(_out))
   INTO  _out;
EXCEPTION WHEN others THEN
   -- do nothing: _out already carries default
END
$func$;
-- This function, try_cast, accepts the data in the first field and the typed default vaue as the second 
SELECT try_cast('foo', NULL::numeric);
SELECT try_cast('foo', NULL::varchar);
SELECT try_cast('foo', NULL::boolean);


select count(*)
  from faers.demo
  ;
-- 13875641 (was 12061699 for data up through Q2 2021)

select count(*)
  from faers.demo_legacy 
  ;
-- 4276200
*/

-----------------------------------------------------------------------------------------------------------------
--- **START** Take a slight detour to create a drill down table that combines drugs and NPs but still includes duplication
--- NOTE: this section is completely 
-----------------------------------------------------------------------------------------------------------------

-- normalize years and quarters 
drop table if exists scratch_dedup_q1_2004_thr_q2_2022.report_year_qrtr;
select t.report_qrtr, t.report_year, t.primaryid, t.caseid, t.isr
into scratch_dedup_q1_2004_thr_q2_2022.report_year_qrtr
from (
 select cast(regexp_replace(d.filename, '^[dD][eE][mM][oO][0-9][0-9][qQ]([0-9]).*','\1') as integer) report_qrtr,
        cast(regexp_replace(d.filename, '^[dD][eE][mM][oO]([0-9][0-9])[qQ][0-9].*','\1') as integer) report_year,
        d.primaryid, 
        d.caseid,
        null::varchar isr
 from faers.demo d
 union
 select cast(regexp_replace(dl.filename, '^[dD][eE][mM][oO][0-9][0-9][qQ]([0-9]).*','\1') as integer) report_qrtr,
        cast(regexp_replace(dl.filename, '^[dD][eE][mM][oO]([0-9][0-9])[qQ][0-9].*','\1') as integer) report_year,
        null::varchar primaryid, 
        null::varchar caseid,
        dl.isr
from faers.demo_legacy  dl
) t
;
-- Updated Rows	18151841

CREATE INDEX report_year_qrtr_primaryid_idx ON scratch_dedup_q1_2004_thr_q2_2022.report_year_qrtr (primaryid);
CREATE INDEX report_year_qrtr_isr_idx ON scratch_dedup_q1_2004_thr_q2_2022.report_year_qrtr (isr);


-- normalize age and age_cd 
select t.event_dt, t.person_age, t.person_age_code, t.primaryid, t.caseid, t.isr
into scratch_dedup_q1_2004_thr_q2_2022.event_dt_age_and_age_cd
from (
 select left(d.event_dt, 15) event_dt, 
        try_cast(d.age, null::integer) person_age, 
        left(d.age_cod, 5) person_age_code,
        d.primaryid, 
        d.caseid,
        null::varchar isr
 from faers.demo d
 union
 select left(dl.event_dt, 15) event_dt, 
        try_cast(dl.age, null::integer) person_age, 
        left(dl.age_cod, 5) person_age_code,
        null::varchar primaryid, 
        null::varchar caseid,
        dl.isr
from faers.demo_legacy  dl
) t
;
-- Updated Rows	18146760

CREATE INDEX event_dt_age_and_age_cd_primaryid_idx ON scratch_dedup_q1_2004_thr_q2_2022.event_dt_age_and_age_cd (primaryid);
CREATE INDEX event_dt_age_and_age_cd_isr_idx ON scratch_dedup_q1_2004_thr_q2_2022.event_dt_age_and_age_cd (isr);



-- normalize sex, wt, wt_cod, reporter_country 
select t.person_sex, t.person_weight, t.person_weight_code, t.report_country, t.primaryid, t.caseid, t.isr
into scratch_dedup_q1_2004_thr_q2_2022.wt_sex_rprtr_ctry
from (
 select left(d.sex, 2) person_sex,     
        try_cast(d.wt, null::numeric) person_weight, 
        case when d.wt_cod ~ 'Y.*' then null  
 		     when d.wt_cod ~ '[IL].*' then 'LBS'
 		     when d.wt_cod ~ 'M.*' then 'MG'
 		     when d.wt_cod in ('KG','KGS') then 'KG'
 		     when d.wt_cod = 'GMS' then 'GMS'
 		     else null
   	    end person_weight_code, 
        e.country_code report_country,
        d.primaryid, 
        d.caseid,
        null::varchar isr
 from faers.demo d left outer join faers.country_code e  on upper(d.reporter_country) = upper(e.country_name)
 union
 select left(dl.gndr_cod, 2) person_sex,     
        try_cast(dl.wt, null::numeric) person_weight, 
        case when dl.wt_cod ~ 'Y.*' then null  
 		     when dl.wt_cod ~ '[IL].*' then 'LBS'
 		     when dl.wt_cod ~ 'M.*' then 'MG'
 		     when dl.wt_cod in ('KG','KGS') then 'KG'
 		     when dl.wt_cod = 'GMS' then 'GMS'
 		     else null
   	    end person_weight_code, 
        el.country_code report_country,
        null::varchar primaryid, 
        null::varchar caseid,
        dl.isr
from faers.demo_legacy dl left outer join faers.country_code el on upper(dl.reporter_country) = upper(el.country_name)
) t
;
-- Updated Rows	18146900
CREATE INDEX wt_sex_rprtr_ctry_primaryid_idx ON scratch_dedup_q1_2004_thr_q2_2022.wt_sex_rprtr_ctry (primaryid);
CREATE INDEX wt_sex_rprtr_ctry_isr_idx ON scratch_dedup_q1_2004_thr_q2_2022.wt_sex_rprtr_ctry (isr);

set search_path to scratch_dec2022_np_vocab;

---- create a NP to case report mapping table
drop table if exists scratch_dec2022_np_vocab.standard_case_np;
with np_to_spell_var as (
  select distinct pt, pt_concept_id, spell_var
  from (
  select distinct c1.concept_name pt, c1.concept_id pt_concept_id,  c3.concept_name spell_var
  from staging_vocabulary.concept c1 
	 inner join staging_vocabulary.concept_relationship cr1 on c1.concept_id = cr1.concept_id_1  
     inner join staging_vocabulary.concept c2 on c2.concept_id = cr1.concept_id_2
     inner join staging_vocabulary.concept_relationship cr2 on c2.concept_id = cr2.concept_id_1
     inner join staging_vocabulary.concept c3 on c3.concept_id = cr2.concept_id_2
  where cr1.relationship_id = 'napdi_is_pt_of'
   and cr2.relationship_id = 'napdi_spell_vr'
  union  
  select distinct c1.concept_name pt, c1.concept_id pt_concept_id,  upper(regexp_replace(c2.concept_name, '\[.*\]','' )) spell_var
  from staging_vocabulary.concept c1 
	 inner join staging_vocabulary.concept_relationship cr on c1.concept_id = cr.concept_id_1  
     inner join staging_vocabulary.concept c2 on c2.concept_id = cr.concept_id_2
  where cr.relationship_id = 'napdi_is_pt_of' 
 ) p
 order by pt
)
select distinct primaryid, isr, drug_seq, role_cod, ftonp.pt_concept_id as standard_concept_id
into scratch_dec2022_np_vocab.standard_case_np
from faers.combined_drug_mapping cdm inner join np_to_spell_var ftonp on 
            upper(cdm.drug_name_original) = upper(ftonp.pt) or upper(cdm.drug_name_original) = upper(ftonp.spell_var)
where cdm.concept_id is null
;
-- Updated Rows	38222
CREATE INDEX faers_standard_case_np_concept_id_idx ON scratch_dec2022_np_vocab.standard_case_np (standard_concept_id);
CREATE INDEX faers_standard_case_np_primaryid_idx ON scratch_dec2022_np_vocab.standard_case_np (primaryid);

---- create natural product (NP)/outcome combination case counts (counts for NP concept_id - adverse reaction Meddra concept_id pairs) 
----- and store the combination case counts in a new table called standard_np_outcome_count
----- NOTE: Counts for the NPs are at the various common name mappings and not necessarily to the preferred term. 
----- NOTE: Counts in this table are only for the newly mapped NPs and not for the NPs identified in RxNorm 
drop table if exists scratch_dec2022_np_vocab.standard_np_outcome_count;
create table scratch_dec2022_np_vocab.standard_np_outcome_count as
select drug_concept_id, outcome_concept_id, count(*) as drug_outcome_pair_count, cast(null as integer) as snomed_outcome_concept_id
from (
	select 'PRIMARYID' || a.primaryid as case_key, a.standard_concept_id as drug_concept_id, b.outcome_concept_id, cast(null as integer) as snomed_outcome_concept_id
	from scratch_dec2022_np_vocab.standard_case_np a
	inner join faers.standard_case_outcome b
	on a.primaryid = b.primaryid and a.isr is null and b.isr is null
	union 
	select 'ISR' || a.isr as case_key, a.standard_concept_id as drug_concept_id, b.outcome_concept_id, cast(null as integer) as snomed_outcome_concept_id
	from scratch_dec2022_np_vocab.standard_case_np a
	inner join faers.standard_case_outcome b
	on a.isr = b.isr and a.isr is not null and b.isr is not null
) aa
group by drug_concept_id, outcome_concept_id;
-- Updated Rows	38533

select v.*, c1.concept_id, c1.concept_name,  c2.concept_id, c2.concept_name
from scratch_dec2022_np_vocab.standard_np_outcome_count v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
limit 1000;

-- Now, construct the drill down that adds the new NP mappings
set search_path to scratch_dec2022_np_vocab;

drop index if exists standard_np_outcome_count_ix_1;
create index standard_np_outcome_count_ix_1 on standard_np_outcome_count(drug_concept_id);
drop index if exists standard_np_outcome_count_ix_2;
create index standard_np_outcome_count_ix_2 on standard_np_outcome_count(outcome_concept_id);

drop table if exists standard_np_outcome_drilldown;
create table standard_np_outcome_drilldown as
select  
	concept.concept_name np_pt,
	a.drug_concept_id, 
	a.outcome_concept_id, 
	a.snomed_outcome_concept_id, 
	b.primaryid, null as isr, null as caseid
from standard_np_outcome_count a
	inner join standard_case_np b on a.drug_concept_id = b.standard_concept_id
	inner join staging_vocabulary.concept on concept.concept_id = a.drug_concept_id
	inner join faers.standard_case_outcome c on a.outcome_concept_id = c.outcome_concept_id
		        and b.primaryid = c.primaryid
union
select
	concept.concept_name np_pt,
	a.drug_concept_id,  
	a.outcome_concept_id, 
	a.snomed_outcome_concept_id,  
	null as primary_id, b.isr, null as caseid
from standard_np_outcome_count a
	inner join standard_case_np b on a.drug_concept_id = b.standard_concept_id
	inner join staging_vocabulary.concept on concept.concept_id = a.drug_concept_id
	inner join faers.standard_case_outcome c on a.outcome_concept_id = c.outcome_concept_id
				and b.isr = c.isr;
-- Updated Rows	192603

-- populate the caseids that have a primaryid
update standard_np_outcome_drilldown a
set caseid = b.caseid
from faers.unique_all_case b
where a.primaryid = b.primaryid;
-- 154916

-- populate the caseids that have an isr
update standard_np_outcome_drilldown a
set caseid = b.caseid
from faers.unique_all_case b
where a.isr = b.isr
and a.caseid is null;
-- 37687

CREATE INDEX standard_np_outcome_drilldown_np_pt_idx ON scratch_dec2022_np_vocab.standard_np_outcome_drilldown (np_pt);
CREATE INDEX standard_np_outcome_drilldown_np_class_outcome_id_idx ON scratch_dec2022_np_vocab.standard_np_outcome_drilldown (np_pt,outcome_concept_id);
CREATE INDEX standard_np_outcome_drilldown_drug_concept_id_idx ON scratch_dec2022_np_vocab.standard_np_outcome_drilldown (drug_concept_id);
CREATE INDEX standard_np_outcome_drilldown_drug_concept_outcome_id_idx ON scratch_dec2022_np_vocab.standard_np_outcome_drilldown (drug_concept_id,outcome_concept_id);
CREATE INDEX standard_np_outcome_drilldown_outcome_concept_id_idx ON scratch_dec2022_np_vocab.standard_np_outcome_drilldown (outcome_concept_id);
CREATE INDEX standard_np_outcome_drilldown_primaryid_idx ON scratch_dec2022_np_vocab.standard_np_outcome_drilldown (primaryid);


------------------------------------------------------------------------
-- copy the complete drill down with NP terms while adding the event_date, age, sex, weight, reporter_country, and a boolean for lit_ref
---- NOTE: in the drill down, we have the following:
----  non null primaryid and caseid 
----  non-null isr and caseid (null primaryid) 
----  non-null isr and null caseid and null primaryid 
----  BUT no occurrences of a null primaryid and null isr and non-null caseid 
select distinct primaryid, isr, caseid, np_pt, drug_concept_id, outcome_concept_id,
    report_qrtr, report_year, 
    event_dt, person_age, person_age_code, 
    person_sex, person_weight, person_weight_code, report_country, 
    lit_ref_id
into scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown   -- NOTE: schema is different so that we can compare dedup strategies
from (
 select cndod.primaryid, cndod.isr, cndod.caseid, np_pt, cndod.drug_concept_id, cndod.outcome_concept_id,
    ryq.report_qrtr, ryq.report_year, 
    edaaac.event_dt, edaaac.person_age, edaaac.person_age_code, 
    wsrc.person_sex, wsrc.person_weight, wsrc.person_weight_code, wsrc.report_country, 
    cast(lrpt.lit_ref_id as int4) lit_ref_id
 from scratch_dec2022_np_vocab.standard_np_outcome_drilldown cndod 
   inner join scratch_dedup_q1_2004_thr_q2_2022.report_year_qrtr ryq on cndod.primaryid = ryq.primaryid
   inner join scratch_dedup_q1_2004_thr_q2_2022.event_dt_age_and_age_cd edaaac on cndod.primaryid = edaaac.primaryid
   inner join scratch_dedup_q1_2004_thr_q2_2022.wt_sex_rprtr_ctry wsrc on cndod.primaryid = wsrc.primaryid  
   left join scratch_dedup_q1_2004_thr_q2_2022.combined_lit_ref_to_case_mapping lrpt on  cndod.primaryid = lrpt.primaryid
 where cndod.primaryid is not null
 union
 select cndod.primaryid, cndod.isr, cndod.caseid, '' as  np_pt, cndod.drug_concept_id, cndod.outcome_concept_id,
    ryq.report_qrtr, ryq.report_year, 
    edaaac.event_dt, edaaac.person_age, edaaac.person_age_code, 
    wsrc.person_sex, wsrc.person_weight, wsrc.person_weight_code, wsrc.report_country, 
    cast(lrpt.lit_ref_id as int4) lit_ref_id  
 from faers.standard_drug_outcome_drilldown  cndod 
   inner join scratch_dedup_q1_2004_thr_q2_2022.report_year_qrtr ryq on cndod.primaryid = ryq.primaryid
   inner join scratch_dedup_q1_2004_thr_q2_2022.event_dt_age_and_age_cd edaaac on cndod.primaryid = edaaac.primaryid
   inner join scratch_dedup_q1_2004_thr_q2_2022.wt_sex_rprtr_ctry wsrc on cndod.primaryid = wsrc.primaryid  
   left join scratch_dedup_q1_2004_thr_q2_2022.combined_lit_ref_to_case_mapping lrpt on  cndod.primaryid = lrpt.primaryid
 where cndod.primaryid is not null
 union 
 select cndod.primaryid, cndod.isr, cndod.caseid, np_pt, cndod.drug_concept_id, cndod.outcome_concept_id,
    ryq.report_qrtr, ryq.report_year, 
    edaaac.event_dt, edaaac.person_age, edaaac.person_age_code, 
    wsrc.person_sex, wsrc.person_weight, wsrc.person_weight_code, wsrc.report_country, 
    cast(null as int4) lit_ref_id 
 from scratch_dec2022_np_vocab.standard_np_outcome_drilldown cndod 
   inner join scratch_dedup_q1_2004_thr_q2_2022.report_year_qrtr ryq on cndod.isr = ryq.isr
   inner join scratch_dedup_q1_2004_thr_q2_2022.event_dt_age_and_age_cd edaaac on cndod.isr = edaaac.isr
   inner join scratch_dedup_q1_2004_thr_q2_2022.wt_sex_rprtr_ctry wsrc on cndod.isr = wsrc.isr     
 where cndod.primaryid is null 
   and cndod.isr is not null
 union
 select cndod.primaryid, cndod.isr, cndod.caseid, '' as  np_pt, cndod.drug_concept_id, cndod.outcome_concept_id,
    ryq.report_qrtr, ryq.report_year, 
    edaaac.event_dt, edaaac.person_age, edaaac.person_age_code, 
    wsrc.person_sex, wsrc.person_weight, wsrc.person_weight_code, wsrc.report_country, 
    cast(null as int4) lit_ref_id
 from faers.standard_drug_outcome_drilldown  cndod 
   inner join scratch_dedup_q1_2004_thr_q2_2022.report_year_qrtr ryq on cndod.isr = ryq.isr
   inner join scratch_dedup_q1_2004_thr_q2_2022.event_dt_age_and_age_cd edaaac on cndod.isr = edaaac.isr
   inner join scratch_dedup_q1_2004_thr_q2_2022.wt_sex_rprtr_ctry wsrc on cndod.isr = wsrc.isr     
 where cndod.primaryid is null 
   and cndod.isr is not null
) t
;
-- Updated Rows	152670188


---- Update the np_pt columns to recognize the RxNorm NP codes
-- Save the original RxNorm IDs to a separate table b/c they will be changed to NaPDI PT IDs in the drill down
drop table if exists scratch_dec2022_np_vocab.rxnorm_nps_in_standard_np_outcome_drilldown;
with np_to_rxn as (
 select c1.concept_name np_pt, c1.concept_id np_concept_id,  c2.concept_name rxnorm_concept_name, c2.concept_id rx_norm_concept_id
 from staging_vocabulary.concept c1 
	 inner join staging_vocabulary.concept_relationship cr on c1.concept_id = cr.concept_id_1  
     inner join staging_vocabulary.concept c2 on c2.concept_id = cr.concept_id_2
 where cr.relationship_id = 'napdi_np_maps_to'
)
select distinct dd.primaryid, dd.isr, np_to_rxn.np_pt, np_to_rxn.np_concept_id, np_to_rxn.rxnorm_concept_name, np_to_rxn.rx_norm_concept_id
into scratch_dec2022_np_vocab.rxnorm_nps_in_standard_np_outcome_drilldown
from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown dd 
  inner join np_to_rxn on dd.drug_concept_id = np_to_rxn.rx_norm_concept_id
  where dd.np_pt is null 
    or dd.np_pt = ''
;
-- Updated Rows	18106 (was 15098) 


select count(*)
from (
 select distinct primaryid, np_pt, np_concept_id
 from scratch_dec2022_np_vocab.rxnorm_nps_in_standard_np_outcome_drilldown  
) t
;
-- 16578 - suggests that there are  multiple rxnorm IDs for certain NPs

update scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown a
set np_pt = b.np_pt, 
    drug_concept_id = b.np_concept_id 
from scratch_dec2022_np_vocab.rxnorm_nps_in_standard_np_outcome_drilldown b
where a.primaryid = b.primaryid
  and a.drug_concept_id = b.rx_norm_concept_id
;
-- Updated Rows	77474

select count(*)
from (
 select distinct a.primaryid, a.np_pt, b.drug_concept_id 
 from scratch_dec2022_np_vocab.rxnorm_nps_in_standard_np_outcome_drilldown a 
   inner join scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown b 
      on a.primaryid = b.primaryid and a.np_pt = b.np_pt and a.np_concept_id  = b.drug_concept_id 
) t
;
-- 16165 (TODO: investigate to confirm if the fewer count than the mapped table is due to expected duplicates in the mapped table b/c of RxNorm having multiple concepts for some NPs)



----- Now, all NPs mentions that we can locate in FAERS are coded with the preferred term and preferred term concept_id from our vocabulary
----- We should not be able to index and then identify duplicates 
CREATE INDEX combined_np_drug_outcome_drilldown_np_pt_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (np_pt);
CREATE INDEX combined_np_drug_outcome_drilldown_np_class_outcome_id_idx on scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (np_pt,outcome_concept_id);
CREATE INDEX combined_np_drug_outcome_drilldown_drug_concept_id_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (drug_concept_id);
CREATE INDEX combined_np_drug_outcome_drilldown_drug_concept_outcome_id_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (drug_concept_id,outcome_concept_id);
CREATE INDEX combined_np_drug_outcome_drilldown_outcome_concept_id_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (outcome_concept_id);
CREATE INDEX combined_np_drug_outcome_drilldown_primaryid_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (primaryid);
CREATE INDEX combined_np_drug_outcome_drilldown_isr_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (isr);
CREATE INDEX combined_np_drug_outcome_drilldown_lit_ref_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (lit_ref_id);

CREATE INDEX combined_np_drug_outcome_drilldown_lit_ref_dedup_strategy_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (lit_ref_id,person_age,person_sex);
CREATE INDEX combined_np_drug_outcome_drilldown_useful_event_dt_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (char_length(event_dt));
CREATE INDEX combined_np_drug_outcome_drilldown_age_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (person_age);
CREATE INDEX combined_np_drug_outcome_drilldown_sex_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (person_sex);
CREATE INDEX combined_np_drug_outcome_drilldown_wght_idx ON scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown (person_weight);



-- 
-- clear up some storage
drop table if exists scratch_dedup_q1_2004_thr_q2_2022.report_year_qrtr;
drop table if exists scratch_dedup_q1_2004_thr_q2_2022.event_dt_age_and_age_cd;
drop table if exists scratch_dedup_q1_2004_thr_q2_2022.wt_sex_rprtr_ctry;
drop table if exists scratch_dedup_q1_2004_thr_q2_2022.lit_ref_present_tbl_new_qrtrs;

-- Fix issues with common names in the drill down where the concept_id and np_pt are not the NP preferred term:
select distinct c.concept_id, c.concept_name, c.concept_class_id, cndod.np_pt
from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
  inner join staging_vocabulary.concept c on cndod.drug_concept_id = c.concept_id 
where
   c.concept_id < 0 and
   c.concept_class_id != 'NaPDI Preferred Term'
;
/*
-7014546	CURCUMIN	NaPDI NP Spelling Variation	CURCUMIN
-7012252	Tribulus[Tribulus terrestris]	Tribulus	Tribulus[Tribulus terrestris]
-7011806	Licorice[Glycyrrhiza uralensis]	Licorice	Licorice[Glycyrrhiza uralensis]
-7011607	Camphor[Cinnamomum camphora]	Kuso-no-ki	Camphor[Cinnamomum camphora]
-7011567	Hemp[Cannabis sativa]	Hemp extract	Hemp[Cannabis sativa]
-7011401	Buchu[Agathosma betulina]	Mountain buchu	Buchu[Agathosma betulina]
 */

-- Fix
select *
from staging_vocabulary.concept c 
where c.concept_id < 0
  and c.concept_name ilike '%curcumin%'
;
-- Maps to Turmeric

select *
from staging_vocabulary.concept c 
where c.concept_id < 0
  and c.concept_name = 'Turmeric'
;
-- change drug_concept_id to -7012405

update scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown 
set drug_concept_id = -7012405,
    np_pt = 'Turmeric'
where drug_concept_id = -7014546
;
-- 7880

select * 
from staging_vocabulary.concept c
where c.concept_id < 0
 and c.concept_name in ('Tribulus','Licorice','Kuso-no-ki','Hemp extract','Mountain buchu')
;
/*
-7012349	Hemp extract	NaPDI research	NAPDI	NaPDI Preferred Term		Hemp extract	2000-01-01	2099-02-22	
-7012384	Kuso-no-ki	NaPDI research	NAPDI	NaPDI Preferred Term		Kuso-no-ki	2000-01-01	2099-02-22	
-7012481	Mountain buchu	NaPDI research	NAPDI	NaPDI Preferred Term		Mountain buchu	2000-01-01	2099-02-22	
-7012510	Licorice	NaPDI research	NAPDI	NaPDI Preferred Term		Licorice	2000-01-01	2099-02-22	
-7012579	Tribulus	NaPDI research	NAPDI	NaPDI Preferred Term		Tribulus	2000-01-01	2099-02-22	
*/

/*
 change -7012252 to -7012579 Tribulus
        -7011806 to -7012510 Licorice
        -7011607 to -7012384 Kuso-no-ki
        -7011567 to -7012349 Hemp extract
        -7011401 to -7012481 Mountain buchu
 */
update scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown 
set drug_concept_id = -7012579,
    np_pt = 'Tribulus'
where drug_concept_id = -7012252
;
-- 87

update scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown 
set drug_concept_id = -7012510,
    np_pt = 'Licorice'
where drug_concept_id = -7011806
;
-- 667

update scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown 
set drug_concept_id = -7012384,
    np_pt = 'Kuso-no-ki'
where drug_concept_id = -7011607
;
-- 2542

update scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown 
set drug_concept_id = -7012349,
    np_pt = 'Hemp extract'
where drug_concept_id = -7011567
;
-- 1101

update scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown 
set drug_concept_id = -7012481,
    np_pt = 'Mountain buchu'
where drug_concept_id = -7011401
;
-- 9 


-----------------------------------------------------------------------------------------------------------------
--- **END** Take a slight detour to create a drill down table that combines drugs and NPs but still includes duplication
-----------------------------------------------------------------------------------------------------------------

-- TODO: revise to bring in the UMC vigimatch suspected duplicates

-- 4) Identify partitions for the deduplication strategy, duplication identification strategy (see below), 
--    randomly sample 1 case from each group within the partition as representitive of the duplicates 
--     (the partitions are randomly ordered so selecting row_num 1 will be a randomly sampled case)  
--     * duplication identification: 
--      If there is a lit_ref_id: partition by lit_ref_id, person_age, and person_sex 
--      If there is NOT a lit_ref_id and char_length(event_dt) > 4: partition by event_dt, person_age, person_sex, person_weight
--------
-------  This approach adds the rank of the window function partitions so that we can calculate drug and ADR overlap 
-------  within ranks
-------
------- NOTE: The next query will further group dups using the sum of the concept_ids for drugs and ADRs
drop table if exists scratch_dedup_q2_2022_w_vigimatch.ranked_master_dup_id_table;
with k as (
 select distinct primaryid, isr, lit_ref_id, person_age, person_sex 
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
 where lit_ref_id is not null
  and primaryid is not null
  and person_age is not null
  and person_sex is not null
), k_l as (
 select primaryid, isr, cast(null as text) event_dt, lit_ref_id, person_age, person_sex, cast(null as numeric) person_weight, 
        row_number() over(partition by lit_ref_id, person_age, person_sex order by random()) as row_num, 
        dense_rank() over(order by lit_ref_id, person_age, person_sex) as rank_id, 
        'lit_ref_dup_id' as mthd
 from k
), m as (
 select distinct primaryid, isr, event_dt, person_age, person_sex, person_weight   
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
 where  lit_ref_id is null
  and char_length(event_dt) > 4
  and person_age is not null
  and person_sex is not null
  and person_weight is not null
), m_l as (
 select primaryid, isr, event_dt, cast(null as int4) lit_ref_id, person_age, person_sex, person_weight, 
        row_number() over(partition by event_dt, person_age, person_sex, person_weight order by random()) as row_num, 
        dense_rank() over(order by event_dt, person_age, person_sex, person_weight) as rank_id, 
        'non_lit_ref_dup_id' as mthd 
 from m
)
select *
into scratch_dedup_q2_2022_w_vigimatch.ranked_master_dup_id_table
from (
 select *
 from k_l 
 union
 select *
 from m_l
) t
order by event_dt, lit_ref_id, person_age, person_sex, person_weight, rank_id, row_num
;
-- Updated Rows	2387142
-- NOTE: the rank_id is not unique because there are two different methods. The rank_id starts at 1 for the ranks within each method.
--       So, a the groupings of interest for the next step is the mthd+rank_id

CREATE INDEX ranked_master_dup_id_table_mthd_idx ON scratch_dedup_q2_2022_w_vigimatch.ranked_master_dup_id_table (mthd,rank_id);

--- sanity check
select *
from scratch_dedup_q2_2022_w_vigimatch.ranked_master_dup_id_table
where mthd = 'lit_ref_dup_id'
order by event_dt, lit_ref_id, person_age, person_sex, person_weight, rank_id, row_num
limit 10000
;
/*
same lit_ref_id but notice that the rankid is different for each row b/c of differences in sec and age
185447962			-154828	73	F		1	1	lit_ref_dup_id
185448342			-154828	81	F		1	2	lit_ref_dup_id
171977676			-154827	43	M		1	3	lit_ref_dup_id
169149719			-154827	47	M		1	4	lit_ref_dup_id

same lit_ref_id but notice that the rankid are the same each row b/c no differences in sec and age 
155158115			-154825	77	M		1	5	lit_ref_dup_id
188068622			-154825	77	M		2	5	lit_ref_dup_id
 */

-- Now, join the report drug and adr data within eacn mthd+rank_id grouping while summing the concept_ids for drugs and adrs
-- The trick then is to use the the first_value window function over the partition of the sums for drug and adrs
-- The results is a table that has the first identifier (primaryid or isr) for each drug/adr sums partition 
-- This effectively keeps the ids for reports that:
--   1) are the first ids in the partition of duplicates based on either criterion, or 
--   2) are not duplicated based on either (lit_ref_id, age, sex, drugs, adrs) or (event_date, age, sex, drugs, adrs)
drop table if exists scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table;
with d_pid_1 as ( 
 select cndod.primaryid, sum(cndod.drug_concept_id) drug_id_sum, sum(cndod.outcome_concept_id) adr_id_sum,
       rm1.row_num, rm1.mthd, rm1.rank_id
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
   inner join scratch_dedup_q2_2022_w_vigimatch.ranked_master_dup_id_table rm1 on cndod.primaryid = rm1.primaryid  
 where cndod.primaryid is not null
 group by cndod.primaryid, rm1.row_num, rm1.mthd, rm1.rank_id
), d_isr_1 as (  --- NOTE: there is no lit_ref_id for LAERS data so, we don't have a CTE for that case!
 select cndod.isr, sum(cndod.drug_concept_id) drug_id_sum, sum(cndod.outcome_concept_id) adr_id_sum,
       rm1.row_num, rm1.mthd, rm1.rank_id
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
   inner join scratch_dedup_q2_2022_w_vigimatch.ranked_master_dup_id_table rm1 on cndod.isr = rm1.isr 
 where cndod.primaryid is null 
 group by cndod.isr, rm1.row_num, rm1.mthd, rm1.rank_id
)
select primaryid, isr, drug_id_sum, adr_id_sum, mthd, rank_id, row_num,
        first_value(primaryid) over(partition by drug_id_sum, adr_id_sum, mthd, rank_id) as first_primaryid,
        first_value(isr) over(partition by drug_id_sum, adr_id_sum, mthd, rank_id) as first_isr
into scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table
from ( 
  select primaryid, cast(null as varchar) isr, drug_id_sum, adr_id_sum, row_num, mthd, rank_id
  from d_pid_1
  union
  select cast(null as varchar) primaryid, isr, drug_id_sum, adr_id_sum, row_num, mthd, rank_id
  from d_isr_1
) t
order by mthd, rank_id, row_num
;
-- Updated Rows	2387142
CREATE INDEX duplicate_lookup_table_primaryid_idx ON scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table (primaryid);
CREATE INDEX duplicate_lookup_table_isr_idx ON scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table (isr);
CREATE INDEX duplicate_lookup_table_first_primaryid_idx ON scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table (first_primaryid);
CREATE INDEX duplicate_lookup_table_first_isr_idx ON scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table (first_isr);


-- example cases

-- Case 1
select cndod.primaryid, cndod.drug_concept_id, cndod.outcome_concept_id,
       rm1.row_num, rm1.mthd, rm1.rank_id
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
   inner join scratch_dedup_q2_2022_w_vigimatch.ranked_master_dup_id_table rm1 on cndod.primaryid  = rm1.primaryid  
 where rm1.rank_id = 9386 and rm1.mthd = 'lit_ref_dup_id'
 ;
/*
172577291	1304919	35205180	1	lit_ref_dup_id	9386
172577291	1344905	35205180	1	lit_ref_dup_id	9386
169615133	1304919	35205180	2	lit_ref_dup_id	9386
169615133	1344905	35205180	2	lit_ref_dup_id	9386
 */

--- shows that the first_primaryid filters the duplicate
select distinct cndod.primaryid, cndod.drug_concept_id, cndod.outcome_concept_id
from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
   inner join scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt on cndod.primaryid  = dlt.first_primaryid  
where cndod.primaryid in ('172577291','169615133') 
;
/*
172577291	1304919	35205180
172577291	1344905	35205180
 */
--

-- Case 2
select cndod.isr, cndod.drug_concept_id, cndod.outcome_concept_id,
       rm1.row_num, rm1.mthd, rm1.rank_id
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
   inner join scratch_dedup_q2_2022_w_vigimatch.ranked_master_dup_id_table rm1 on cndod.isr = rm1.isr 
 where rm1.rank_id = 9007 and rm1.mthd = 'non_lit_ref_dup_id'
 ;
/*
4442188	1589505	35506577	1	non_lit_ref_dup_id	9007
4442188	1589505	36211195	1	non_lit_ref_dup_id	9007
4442188	1589505	36818708	1	non_lit_ref_dup_id	9007
4442188	1589505	36818840	1	non_lit_ref_dup_id	9007
4442188	1589505	36818844	1	non_lit_ref_dup_id	9007
4442188	1589505	37119545	1	non_lit_ref_dup_id	9007
4442188	1589505	37521618	1	non_lit_ref_dup_id	9007
4396012	1589505	36818703	2	non_lit_ref_dup_id	9007
4396012	1589505	36818708	2	non_lit_ref_dup_id	9007
4396012	1589505	36818840	2	non_lit_ref_dup_id	9007
4396012	1589505	36818844	2	non_lit_ref_dup_id	9007
4396012	1589505	37119545	2	non_lit_ref_dup_id	9007
4396012	1589505	37521618	2	non_lit_ref_dup_id	9007
5030849	1549786	35104187	3	non_lit_ref_dup_id	9007
5030849	1549786	35104868	3	non_lit_ref_dup_id	9007
5030849	1549786	35707907	3	non_lit_ref_dup_id	9007
5030849	1549786	35708171	3	non_lit_ref_dup_id	9007
5030849	1549786	35909445	3	non_lit_ref_dup_id	9007
5030849	1549786	36311824	3	non_lit_ref_dup_id	9007
5030849	1549786	36313240	3	non_lit_ref_dup_id	9007
5030849	1549786	36316089	3	non_lit_ref_dup_id	9007
5030849	1549786	36316367	3	non_lit_ref_dup_id	9007
5030849	1549786	36516876	3	non_lit_ref_dup_id	9007
5030849	1549786	36516951	3	non_lit_ref_dup_id	9007
5030849	1549786	36617426	3	non_lit_ref_dup_id	9007
5030849	1549786	36718498	3	non_lit_ref_dup_id	9007
5030849	1711947	35104187	3	non_lit_ref_dup_id	9007
5030849	1711947	35104868	3	non_lit_ref_dup_id	9007
5030849	1711947	35707907	3	non_lit_ref_dup_id	9007
5030849	1711947	35708171	3	non_lit_ref_dup_id	9007
5030849	1711947	35909445	3	non_lit_ref_dup_id	9007
5030849	1711947	36311824	3	non_lit_ref_dup_id	9007
5030849	1711947	36313240	3	non_lit_ref_dup_id	9007
5030849	1711947	36316089	3	non_lit_ref_dup_id	9007
5030849	1711947	36316367	3	non_lit_ref_dup_id	9007
5030849	1711947	36516876	3	non_lit_ref_dup_id	9007
5030849	1711947	36516951	3	non_lit_ref_dup_id	9007
5030849	1711947	36617426	3	non_lit_ref_dup_id	9007
5030849	1711947	36718498	3	non_lit_ref_dup_id	9007
5030849	1762711	35104187	3	non_lit_ref_dup_id	9007
5030849	1762711	35104868	3	non_lit_ref_dup_id	9007
5030849	1762711	35707907	3	non_lit_ref_dup_id	9007
5030849	1762711	35708171	3	non_lit_ref_dup_id	9007
5030849	1762711	35909445	3	non_lit_ref_dup_id	9007
5030849	1762711	36311824	3	non_lit_ref_dup_id	9007
5030849	1762711	36313240	3	non_lit_ref_dup_id	9007
5030849	1762711	36316089	3	non_lit_ref_dup_id	9007
5030849	1762711	36316367	3	non_lit_ref_dup_id	9007
5030849	1762711	36516876	3	non_lit_ref_dup_id	9007
5030849	1762711	36516951	3	non_lit_ref_dup_id	9007
5030849	1762711	36617426	3	non_lit_ref_dup_id	9007
5030849	1762711	36718498	3	non_lit_ref_dup_id	9007
5030849	19097684	35104187	3	non_lit_ref_dup_id	9007
5030849	19097684	35104868	3	non_lit_ref_dup_id	9007
5030849	19097684	35707907	3	non_lit_ref_dup_id	9007
5030849	19097684	35708171	3	non_lit_ref_dup_id	9007
5030849	19097684	35909445	3	non_lit_ref_dup_id	9007
5030849	19097684	36311824	3	non_lit_ref_dup_id	9007
5030849	19097684	36313240	3	non_lit_ref_dup_id	9007
5030849	19097684	36316089	3	non_lit_ref_dup_id	9007
5030849	19097684	36316367	3	non_lit_ref_dup_id	9007
5030849	19097684	36516876	3	non_lit_ref_dup_id	9007
5030849	19097684	36516951	3	non_lit_ref_dup_id	9007
5030849	19097684	36617426	3	non_lit_ref_dup_id	9007
5030849	19097684	36718498	3	non_lit_ref_dup_id	9007
 */

---- shows that non-duplicated reports are recovered by first_isr
select distinct cndod.isr, cndod.drug_concept_id, cndod.outcome_concept_id
from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
   inner join scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt on cndod.isr  = dlt.first_isr  
where cndod.isr in ('4396012','5030849','4442188') 
;
/*
4396012	1589505	36818703
4396012	1589505	36818708
4396012	1589505	36818840
4396012	1589505	36818844
4396012	1589505	37119545
4396012	1589505	37521618
4442188	1589505	35506577
4442188	1589505	36211195
4442188	1589505	36818708
4442188	1589505	36818840
4442188	1589505	36818844
4442188	1589505	37119545
4442188	1589505	37521618
5030849	1549786	35104187
5030849	1549786	35104868
5030849	1549786	35707907
5030849	1549786	35708171
5030849	1549786	35909445
5030849	1549786	36311824
5030849	1549786	36313240
5030849	1549786	36316089
5030849	1549786	36316367
5030849	1549786	36516876
5030849	1549786	36516951
5030849	1549786	36617426
5030849	1549786	36718498
5030849	1711947	35104187
5030849	1711947	35104868
5030849	1711947	35707907
5030849	1711947	35708171
5030849	1711947	35909445
5030849	1711947	36311824
5030849	1711947	36313240
5030849	1711947	36316089
5030849	1711947	36316367
5030849	1711947	36516876
5030849	1711947	36516951
5030849	1711947	36617426
5030849	1711947	36718498
5030849	1762711	35104187
5030849	1762711	35104868
5030849	1762711	35707907
5030849	1762711	35708171
5030849	1762711	35909445
5030849	1762711	36311824
5030849	1762711	36313240
5030849	1762711	36316089
5030849	1762711	36316367
5030849	1762711	36516876
5030849	1762711	36516951
5030849	1762711	36617426
5030849	1762711	36718498
5030849	19097684	35104187
5030849	19097684	35104868
5030849	19097684	35707907
5030849	19097684	35708171
5030849	19097684	35909445
5030849	19097684	36311824
5030849	19097684	36313240
5030849	19097684	36316089
5030849	19097684	36316367
5030849	19097684	36516876
5030849	19097684	36516951
5030849	19097684	36617426
5030849	19097684	36718498
 */

----------
select * 
from (
 select distinct cndod.primaryid, cast(null as varchar) isr, cndod.drug_concept_id, cndod.outcome_concept_id
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
   inner join scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt on cndod.primaryid  = dlt.first_primaryid  
 where cndod.primaryid in ('185447962','185448342','206341551','206429421','142499111')
 union
 select distinct cast(null as varchar) primaryid, cndod.isr, cndod.drug_concept_id, cndod.outcome_concept_id
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod 
   inner join scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt on cndod.isr  = dlt.first_isr
 where cndod.isr in ('8506428','6816868','6784302','4442188','5030849')
) t
order by t.primaryid, t.isr
;
-- not duplicates - all of these show up: [pids] 142499111, 185448342, 185447962 / [isrs] 8506428, 4442188, 5030849
-- duplicates - starred show up, others do not: [pids] (206429421, 206341551*) / [isrs] (6816868, 6784302*) 

/*
 select cndod1.primaryid, cndod1.isr, cndod1.caseid, cndod1.np_pt, cndod1.drug_concept_id, cndod1.outcome_concept_id, cndod1.report_qrtr, cndod1.report_year, cndod1.event_dt, cndod1.person_age, cndod1.person_age_code, cndod1.person_sex, cndod1.person_weight, cndod1.person_weight_code, cndod1.report_country, cndod1.lit_ref_id  -- obtains records from the duplicate candidates with primaryids
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod1 
  inner join scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt on cndod1.primaryid  = dlt.first_primaryid
  where cndod1.primaryid is not null;
*/


---------------------------------------
-- Integrate Vigimatch deduplication with our method
---------------------------------------

-- what should we expect?
select count(distinct u.safetyreportid)
from scratch_dedup_q1_2004_thr_q2_2022.suspected_duplicates sd 
   inner join scratch_dedup_q1_2004_thr_q2_2022.uscdersafetyreportid u on sd.umcreportid = u.umcreportid 
;
-- 157860 faers duplicates identified from 

-- What has been mapped to Vigibase using primaryid?
select distinct cndod.primaryid, cast(substring(cndod.primaryid, 1, length(cndod.primaryid) - 1) as integer) umc_safetyreportid 
into scratch_dedup_q2_2022_w_vigimatch.unique_primary_id
from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod
;
-- Updated Rows	11130891
CREATE INDEX unique_primary_id_primaryid_idx ON scratch_dedup_q2_2022_w_vigimatch.unique_primary_id (primaryid);
CREATE INDEX unique_primary_id_umc_safetyreportid_idx ON scratch_dedup_q2_2022_w_vigimatch.unique_primary_id (umc_safetyreportid);

-- What has been mapped to Vigibase using isr?
select distinct cndod.isr 
into scratch_dedup_q2_2022_w_vigimatch.unique_isr
from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod
;
-- Updated Rows	2836122	
CREATE INDEX unique_primary_id_isr_idx ON scratch_dedup_q2_2022_w_vigimatch.unique_isr (isr);


drop table if exists scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup;
with prim_to_umc_primaryid as( 
 select distinct cndod.primaryid, u.safetyreportid, u.umcreportid
 from scratch_dedup_q2_2022_w_vigimatch.unique_primary_id cndod
     inner join scratch_dedup_q1_2004_thr_q2_2022.uscdersafetyreportid u 
         on cndod.umc_safetyreportid  = u.safetyreportid -- necessary b.c. the UMC data does not have the version number appended to the caseid
 ), susp_dups_umc_primaryid as ( 
 select prim_to_umc_primaryid.primaryid, cast(null as varchar) isr, prim_to_umc_primaryid.umcreportid, sd.suspected_duplicate_report_id
 from prim_to_umc_primaryid inner join scratch_dedup_q1_2004_thr_q2_2022.suspected_duplicates sd 
    on prim_to_umc_primaryid.umcreportid = sd.umcreportid 
), prim_to_umc_isr as( 
 select distinct cndod.isr, u.safetyreportid, u.umcreportid
 from scratch_dedup_q2_2022_w_vigimatch.unique_isr cndod
     inner join scratch_dedup_q1_2004_thr_q2_2022.uscdersafetyreportid u 
         on cast(cndod.isr as integer) = u.safetyreportid -- the append of version is not an issue for LAERS data 
 ), susp_dups_umc_isr as ( 
 select cast(null as varchar) primaryid, prim_to_umc_isr.isr, prim_to_umc_isr.umcreportid, sd.suspected_duplicate_report_id
 from prim_to_umc_isr inner join scratch_dedup_q1_2004_thr_q2_2022.suspected_duplicates sd 
    on prim_to_umc_isr.umcreportid = sd.umcreportid 
)
select *, cast(null as varchar) sus_dup_primaryid, cast(null as varchar) sus_dup_isr
into scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup
from ( 
 select *
 from susp_dups_umc_primaryid
 union 
 select *
 from susp_dups_umc_isr
) t
;
-- Updated Rows	163538
CREATE INDEX faers_umc_duplicate_lookup_primaryid_idx ON scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup (primaryid);
CREATE INDEX faers_umc_duplicate_lookup_isr_idx ON scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup (isr);
CREATE INDEX faers_umc_duplicate_lookup_sus_dup_primaryid_idx ON scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup (sus_dup_primaryid);
CREATE INDEX faers_umc_duplicate_lookup_sus_dup_isr_idx ON scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup (sus_dup_isr);
CREATE INDEX faers_umc_duplicate_lookup_suspected_duplicate_report_id_idx ON scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup (suspected_duplicate_report_id);

select count(distinct isr) from scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup fudl where isr is not null; 
-- 19473
select count(distinct primaryid)  from scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup fudl where primaryid is not null; 
-- 95512

-- since the total (114985) is less than 163538, it should mean that there are some dups that cross primaryid and isr
select * 
from scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup lu1 
   inner join scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup lu2 
       on lu1.suspected_duplicate_report_id = lu2.suspected_duplicate_report_id
where lu1.primaryid is not null
  and lu2.isr is not null 
order by lu1.suspected_duplicate_report_id
;
/*
primaryid	isr	umcreportid	suspected_duplicate_report_id	sus_dup_primaryid	sus_dup_isr	primaryid	isr	umcreportid	suspected_duplicate_report_id
58836144		5991523	366377				5883614	5991523	366377
66797037		6668359	425191				6679703	6668359	425191
66797037		6668359	425195				6679703	6668359	425195
81550682		12308459	492084				8155068	12308459	492084
*/



-- select count(*)
select *
from scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup a
   inner join scratch_dedup_q1_2004_thr_q2_2022.uscdersafetyreportid u on a.suspected_duplicate_report_id = u.umcreportid
   inner join scratch_dedup_q2_2022_w_vigimatch.unique_primary_id b on u.safetyreportid = b.umc_safetyreportid
;
-- 133057

-- select count(*)
select *
from scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup a
   inner join scratch_dedup_q1_2004_thr_q2_2022.uscdersafetyreportid u on a.suspected_duplicate_report_id = u.umcreportid
   inner join scratch_dedup_q2_2022_w_vigimatch.unique_isr b on u.safetyreportid = cast(b.isr as integer)
;
-- 17697

with tpid as (
 select a.primaryid, a.isr, a.umcreportid, a.suspected_duplicate_report_id, b.primaryid sus_dup_primaryid, a.sus_dup_isr
 from scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup a
   inner join scratch_dedup_q1_2004_thr_q2_2022.uscdersafetyreportid u on a.suspected_duplicate_report_id = u.umcreportid
   inner join scratch_dedup_q2_2022_w_vigimatch.unique_primary_id b on u.safetyreportid = b.umc_safetyreportid
), tisr as (
  select a.primaryid, a.isr, a.umcreportid, a.suspected_duplicate_report_id, a.sus_dup_primaryid , b.isr sus_dup_isr
  from scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup a
   inner join scratch_dedup_q1_2004_thr_q2_2022.uscdersafetyreportid u on a.suspected_duplicate_report_id = u.umcreportid
   inner join scratch_dedup_q2_2022_w_vigimatch.unique_isr b on u.safetyreportid = cast(b.isr as integer)
)
select *
into scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup
from (
 select *
  from tpid
  union
 select *
  from tisr
) t
;
-- Updated Rows	150754 -- no loss of data!  

-- The suspected duplicates has 670K rows but only 131161 that map over to FAERS
select *
from scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup
order by umcreportid 
;
;
-- Updated Rows	131161 (the suspected duplicates has 670K rows)

-- remove this intermediate table
drop table scratch_dedup_q2_2022_w_vigimatch.faers_umc_duplicate_lookup;

-- index the dup table we will use moving forward
CREATE INDEX complete_faers_umc_duplicate_lookup_primaryid_idx ON scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup (primaryid);
CREATE INDEX complete_faers_umc_duplicate_lookup_isr_idx ON scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup (isr);
CREATE INDEX complete_faers_umc_duplicate_lookup_sus_dup_primaryid_idx ON scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup (sus_dup_primaryid);
CREATE INDEX complete_faers_umc_duplicate_lookup_sus_dup_isr_idx ON scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup (sus_dup_isr);

-- Case 1 - there are additional duplicates to ones to records scanned by lit_ref or eventdate
/* 
 Two cases from the duplicate_lookup_table - notice that the first 2 rows have
      a first_primaryid that is the selected case to include from among the dups 
      the third row, no duplicate found.
  
  Remember that the duplicate_look_up_table is restricted to reports where 
  (lit_ref_id is not null OR char_length(event_dt) > 4) 
  AND
  (
   person_age is not null
   AND
   person_sex is not null
   AND
   person_weight is not null
  )
primaryid	isr	drug_id_sum	adr_id_sum	mthd	rank_id	row_num	first_primaryid	first_isr
206341551		1304107	43053854	lit_ref_dup_id	12	1	206341551	
206429421		1304107	43053854	lit_ref_dup_id	12	2	206341551		
185447962		75970310	143846698	lit_ref_dup_id	1	1	185447962	
*/

-- Case 2 - there are duplicates to ones that we did not scan b.c they did not meet the inclusion criteria mentioned above
select count(*)
from scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl
   left join scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table rmdit   
     on cfudl.primaryid = rmdit.primaryid  --- don't forget to do the same with isr! 
where cfudl.primaryid is not null and rmdit.primaryid is null
;
/* 78884
 
primaryid	isr	umcreportid	suspected_duplicate_report_id	sus_dup_primaryid
100496731		12777338	12615765	98830421
100576781		13128977	12994991	100461372
100576781		13128977	17385088	119494451
 */

select count(*)
from scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl
   left join scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table rmdit   
     on cfudl.isr = rmdit.isr  --- don't forget to do the same with primaryid! 
where cfudl.primaryid is null and rmdit.isr is null 
;
/* 12498
primaryid	isr	umcreportid	suspected_duplicate_report_id	sus_dup_primaryid	sus_dup_isr
4451729	5805662	5998894		5752240
5240313	6111944	6111490		6026844
5296198	6939717	6638201		6635513
5296198	6939717	6640733		6633475
*/

--- flipped question 
select count(*)
from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table rmtid
   left join  scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl  
     on cfudl.primaryid = rmtid.primaryid  --- don't forget to do the same with isr! 
where rmtid.primaryid is not null 
  and cfudl.primaryid is null
;
-- 1691564

select count(*)
from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table rmtid
   left join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl   
     on cfudl.isr = rmtid.isr  --- don't forget to do the same with primaryid! 
where rmtid.primaryid is null and cfudl.isr is null 
;
-- 657907

---
-- How often is the case that the id picked in the deduplicated drill down table is a
-- suspected duplicate in the vigimatch data and so we would need to update the primaryid 
-- to be the one that vigimatch uses?
-- select count(*)
select dlt.first_primaryid, cfudl.suspected_duplicate_report_id, cfudl.primaryid 
from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt 
  inner join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl 
     on dlt.first_primaryid = cfudl.sus_dup_primaryid
where cfudl.primaryid is not null
limit 20
;
-- 45180 records
/* -- sample of 20 rows
first_primaryid	suspected_duplicate_report_id	primaryid
100037561	12809157	131558381
100055672	13032754	107632901
100059041	12673223	96577482
100067621	12607990	100184671
100071542	13128138	104849103
100073683	13075345	101456251
100073861	12838652	100470891
100094862	12780331	90515341
100101563	13527620	161643911
100106191	12782376	99187761
100106822	13953221	100184351
100107322	13143139	95111281
100114421	12621266	98357832
100116423	13088549	96559551
100121111	12621291	110091911
100121111	12621291	110091911
100121111	12621291	110091911
100121111	12621291	110091911
100121653	13144812	94510831
100122872	12816227	102573151
*/

-- These interesting cases are where the primaryid we picked represents a possible duplicate from LAERS
-- In this case, we should go with vigimatch
select count(*)
-- select dlt.first_primaryid, cfudl.suspected_duplicate_report_id, cfudl.primaryid, cfudl.isr 
from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt 
  inner join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl 
     on dlt.first_primaryid = cfudl.sus_dup_primaryid
where cfudl.primaryid is null
-- limit 20
;
-- 418

-- isr dups from vigimatch
select count(*)
-- select dlt.first_isr, cfudl.suspected_duplicate_report_id, cfudl.isr 
from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt 
  inner join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl 
     on dlt.first_isr = cfudl.sus_dup_isr
where cfudl.isr is not null
-- limit 20
;
-- 3250 
/*
first_isr	suspected_duplicate_report_id	isr
6978002	6921338	5122258
6026844	6111490	5240313
5521188	5124120	5521366
6148159	7092960	5651405
6550588	6537654	5651549
5762574	5883920	5653259
5694779	5872349	5654007
5705613	5816686	5654988
5687035	7245617	5656621
5651055	5785738	5657193
5936659	6170232	5657677
5828555	5924833	5658200
5681287	5798716	5659196
5692931	5806260	5661766
5676512	5797541	5663775
5652878	5785880	5663952
5682047	5816559	5665542
5801259	5908766	5665568
5655782	5790288	5667004
5653642	5787526	5672720
 */

-- These interesting cases are where the isr we picked represents a possible duplicate in FAERS 
-- because our method is more precise, we should accept our isr as the correct report 
select count(*)
-- select dlt.first_isr, cfudl.suspected_duplicate_report_id, cfudl.primaryid, cfudl.isr 
from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt 
  inner join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl 
     on dlt.first_isr = cfudl.sus_dup_isr
where cfudl.isr is null
-- limit 20
;
-- 785


-- Strategy - create a table the same shape as suspected_duplicate_report_id so that
--  the code that functions for creating a deduplicated drill down functions. 
--  Do a union:
--    1) for cases where the duplication does not cross betwen LAERS and FAERS   
--       a - (45180) add the sus_dup_primaryid to the new tables primaryid column while
--         taking the primaryid (which is unique from vigimatch) and using that for the new tables first_primaryid column. 
--       b - (3250) Similarly, add the sus_dup_isr to the new tables isr column while
--         taking the isr (which is unique from vigimatch) and using that for the new tables first_isr column.
--       Note - make the values of the mthd column have the string 'umc_vigimatch'.
--    2) (418) for cases where our dedup was identified in FAERS but vigimatch identified a dup in LAERS
--       - add the sus_dup_primaryid to the new tables primaryid column while
--         taking the isr (which is unique from vigimatch) and using that for the new tables first_isr column. 
--       - make the values of the mthd column have the string 'umc_vigimatch'.
--    3) (785) for cases where our dedup was identified in LAERS but vigimatch identified a dup in FAERS
--       - keep our first_isr column but add a record that takes the primaryid (which is unique from vigimatch) 
--       - as the primaryid
--       - make the mthd column = concat(mthd, '+vigimatch')
--    4) for cases where there is no way to cross-walk our duplications and vigimatches
--       a - use vigimatches first_* as the first_primaryid or first_isr and put the sus_dup_*
--         in the primaryid or isr column as appropriate 
--       b - add in the remaining record from the duplicate_lookup_table
--  
-- output table columns: primaryid	isr	drug_id_sum	adr_id_sum	mthd	rank_id	row_num	first_primaryid	first_isr
drop table if exists scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup;
with s1a as (
  select cfudl.sus_dup_primaryid primaryid, 
         cast(null as varchar) isr, 
         cast(null as int8) drug_id_sum, cast(null as int8) adr_id_sum,
         'umc_vigimatch' mthd, 
         cast(null as int8) rank_id, cast(null as int8) row_num,
         cfudl.primaryid  first_primaryid,
         cast(null as varchar) first_isr       
  from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt 
     inner join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl 
       on dlt.first_primaryid = cfudl.sus_dup_primaryid
   where cfudl.primaryid is not null
), s1b as (
  select cast(null as varchar) primaryid,
  	     cfudl.sus_dup_isr isr,  
         cast(null as int8) drug_id_sum, cast(null as int8) adr_id_sum,
         'umc_vigimatch' mthd, 
         cast(null as int8) rank_id, cast(null as int8) row_num,
         cast(null as varchar) first_primaryid,
         cfudl.isr  first_isr 
  from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt 
     inner join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl 
       on dlt.first_isr = cfudl.sus_dup_isr
   where cfudl.isr is not null
), s2 as (
  select cfudl.sus_dup_primaryid primaryid, 
         cast(null as varchar) isr, 
         cast(null as int8) drug_id_sum, cast(null as int8) adr_id_sum,
         'umc_vigimatch' mthd, 
         cast(null as int8) rank_id, cast(null as int8) row_num,
         cast(null as varchar) first_primaryid,
         cfudl.isr  first_isr
  from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt 
    inner join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl 
       on dlt.first_primaryid = cfudl.sus_dup_primaryid
   where cfudl.primaryid is null
), s3 as (
  select cfudl.primaryid,  
         cast(null as varchar) isr, 
         cast(null as int8) drug_id_sum, cast(null as int8) adr_id_sum,
         concat(mthd, '+vigimatch') mthd, 
         cast(null as int8) rank_id, cast(null as int8) row_num,
         cast(null as varchar) first_primaryid,
         dlt.first_isr          
  from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table dlt 
    inner join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl 
       on dlt.first_isr = cfudl.sus_dup_isr
  where cfudl.isr is null
), s4a_primaryid as (
  select cfudl.sus_dup_primaryid primaryid, 
         cast(null as varchar) isr, 
         cast(null as int8) drug_id_sum, cast(null as int8) adr_id_sum,
         'umc_vigimatch' mthd, 
         cast(null as int8) rank_id, cast(null as int8) row_num,
         cfudl.primaryid  first_primaryid,
         cast(null as varchar) first_isr
  from scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl
     left join scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table rmdit   
       on cfudl.primaryid = rmdit.primaryid   
  where cfudl.primaryid is not null 
     and (
          rmdit.primaryid is null   -- Should attend to the case where the primaryid is our method's duplicate_lookup_table with no dup
          or 
          rmdit.primaryid = rmdit.first_primaryid
         )           
), s4a_isr as (
  select cast(null as varchar) primaryid,
  	     cfudl.sus_dup_isr isr,  
         cast(null as int8) drug_id_sum, cast(null as int8) adr_id_sum,
         'umc_vigimatch' mthd, 
         cast(null as int8) rank_id, cast(null as int8) row_num,
         cast(null as varchar) first_primaryid,
         cfudl.isr  first_isr 
  from scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl
    left join scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table rmdit   
       on cfudl.isr = rmdit.isr   
  where cfudl.primaryid is null 
      and 
        (
          rmdit.isr is null  -- Should attend to the case where the primaryid is our method's duplicate_lookup_table with no dup
          or
          rmdit.isr = rmdit.first_isr
        )
), s4b_primaryid as (
 select rmtid.primaryid, 
        rmtid.isr, 
        drug_id_sum, adr_id_sum,
        mthd, 
        rank_id, row_num,
        first_primaryid,
        first_isr
 from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table rmtid
   left join  scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl  
     on cfudl.primaryid = rmtid.primaryid 
 where rmtid.primaryid is not null 
   and cfudl.primaryid is null
), s4b_isr as (
 select rmtid.primaryid, 
        rmtid.isr, 
        drug_id_sum, adr_id_sum,
        mthd, 
        rank_id, row_num,
        first_primaryid,
        first_isr 
from scratch_dedup_q2_2022_w_vigimatch.duplicate_lookup_table rmtid
   left join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup cfudl   
     on cfudl.isr = rmtid.isr  
where rmtid.primaryid is null and cfudl.isr is null
)  
select t.primaryid, t.isr, 
 	   max(t.drug_id_sum) drug_id_sum, max(t.adr_id_sum) adr_id_sum, -- needed to deal with situations where both our method and the umc method  
	   min(mthd) mthd,                                               -- return a result. This favors our method for all fields except primaryid/isr 
	   max(t.rank_id) rank_id, max(t.row_num) row_num,               -- where the lowest id is selected (implying the earliest record in the group of selection)
	   min(t.first_primaryid) first_primaryid, min(t.first_isr) first_isr
into scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup
from (
 select *
 from s1a
 union
 select *
 from s1b
 union
 select *
 from s2
 union
 select *
 from s3
 union
 select *
 from s4a_primaryid
 union
 select *
 from s4a_isr
 union
 select *
 from s4b_primaryid
 union
 select *
 from s4b_isr
) t
group by t.primaryid, t.isr
;
-- Updated Rows	2444734


--------------------------------------------------------------
-- Create a deduplicated drill-down table - this one removes the caseid column so count comparisons have to use unique primaryid and isr counts rather than rows
drop table if exists scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown;
create table scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown as 
--
-- NOTE: The two CTEs are needed b/c we have cases where a given primaryid is the first_primaryid in one dup record while also the primaryid in another
-- or a given isr is the first_isr in one dup record while also the isr in another. Here is an example:
-- select *
-- from scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup ualcdl1
--   left join scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup ualcdl2 
--     on ualcdl1.first_primaryid = ualcdl2.primaryid 
-- where ualcdl1.first_primaryid in ('179138883','179262441')
-- ;
-- primaryid	isr	drug_id_sum	adr_id_sum	mthd	rank_id	row_num	first_primaryid	first_isr	primaryid	isr	drug_id_sum	adr_id_sum	mthd	rank_id	row_num	first_primaryid	first_isr
-- 179262441		-6788834	435166608	lit_ref_dup_id	27217	9	179138883										
-- 178896671		-6788834	435166608	lit_ref_dup_id	27217	1	179262441		179262441		-6788834	435166608	lit_ref_dup_id	27217	9	179138883	
--
with transitive_map_primaryid as ( 
 select ualcdl1.primaryid l_primaryid, ualcdl1.first_primaryid l_first_primaryid,
        ualcdl2.primaryid r_primaryid, ualcdl2.first_primaryid r_first_primaryid
 from scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup ualcdl1
  left join scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup ualcdl2 
    on ualcdl1.first_primaryid = ualcdl2.primaryid 
), transitive_map_isr as ( 
 select ualcdl1.isr l_isr, ualcdl1.first_isr l_first_isr,
        ualcdl2.isr r_isr, ualcdl2.first_isr r_first_isr
 from scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup ualcdl1
  left join scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup ualcdl2 
    on ualcdl1.first_isr = ualcdl2.isr
)
select distinct *
from (
 -- obtains records from the duplicate candidates with primaryids - replaces the primaryid of dups with one from a random selection from the dups
select case when dlt.r_first_primaryid is not null then dlt.r_first_primaryid
            else dlt.l_first_primaryid
       end primaryid,
       cndod1.isr, 
       cndod1.np_pt, cndod1.drug_concept_id, cndod1.outcome_concept_id, cndod1.report_qrtr, cndod1.report_year, cndod1.event_dt, cndod1.person_age, cndod1.person_age_code, cndod1.person_sex, cndod1.person_weight, cndod1.person_weight_code, cndod1.report_country, cndod1.lit_ref_id
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod1 
  inner join transitive_map_primaryid dlt on cndod1.primaryid  = dlt.l_first_primaryid
 union
 -- obtains records from the non-duplicates with primaryids 
 -- NOTE: non-duplication is determined by not finding the primaryid in either the main dedup table or the umc mapping
 select cndod2.primaryid, 
        cndod2.isr, 
        cndod2.np_pt, cndod2.drug_concept_id, cndod2.outcome_concept_id, cndod2.report_qrtr, cndod2.report_year, cndod2.event_dt, cndod2.person_age, cndod2.person_age_code, cndod2.person_sex, cndod2.person_weight, cndod2.person_weight_code, cndod2.report_country, cndod2.lit_ref_id       
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod2 
  left join scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup dlt on cndod2.primaryid  = dlt.primaryid
  left join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup umc_dups on cndod2.primaryid = umc_dups.primaryid
  where cndod2.primaryid is not null
    and 
    ( 
      dlt.primaryid is null
      and 
      umc_dups.primaryid is null
    )
 union
  -- obtains records from the duplicate candidates with NULL primaryids  - replaces the isr of dups with one from a random selection from the dups
 select cast(null as varchar) primaryid,
       case when dlt.r_first_isr is not null then dlt.r_first_isr
            else dlt.l_first_isr
       end isr, 
       cndod3.np_pt, cndod3.drug_concept_id, cndod3.outcome_concept_id, cndod3.report_qrtr, cndod3.report_year, cndod3.event_dt, cndod3.person_age, cndod3.person_age_code, cndod3.person_sex, cndod3.person_weight, cndod3.person_weight_code, cndod3.report_country, cndod3.lit_ref_id
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod3 
  inner join transitive_map_isr dlt on cndod3.isr  = dlt.l_first_isr
 union
 -- obtains records from the non-duplicates with NULL isr
 -- NOTE:  non-duplication is determined by not finding the primaryid in either the main dedup table or the umc mapping
 select cast(null as varchar) primaryid,
        cndod4.isr, 
        cndod4.np_pt, cndod4.drug_concept_id, cndod4.outcome_concept_id, cndod4.report_qrtr, cndod4.report_year, cndod4.event_dt, cndod4.person_age, cndod4.person_age_code, cndod4.person_sex, cndod4.person_weight, cndod4.person_weight_code, cndod4.report_country, cndod4.lit_ref_id  
 from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod4 
  left join scratch_dedup_q2_2022_w_vigimatch.umc_and_lit_combined_duplicate_lookup dlt on cndod4.isr  = dlt.isr
  left join scratch_dedup_q2_2022_w_vigimatch.complete_faers_umc_duplicate_lookup umc_dups on cndod4.isr = umc_dups.isr
  where cndod4.primaryid is null  
    and
    (
     dlt.isr is null 
     and 
     umc_dups.isr is null
    )
 ) t
;  
-- Updated Rows	146954935 (was 147486869)
CREATE INDEX dedup_combined_np_drug_adr_drilldown_primaryid_idx ON scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown (primaryid);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_isr_idx ON scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown (isr);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_drug_concept_id_idx ON scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown (drug_concept_id);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_outcome_concept_id_idx ON scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown (outcome_concept_id);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_report_qrtr_idx ON scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown (report_qrtr);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_report_year_idx ON scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown (report_year);

-- Updated Rows	XXYY which is XXYY records (not reports!) XXYY% less that the run with just our method (XXYY) 
-- and XXYY fewer than (XXYY% of)  
select count(*) from scratch_dedup_q2_2022_w_vigimatch.combined_np_drug_outcome_drilldown cndod; 
-- 152670188


-- in terms of record counts - 
----- by primaryid: 11130879 - XXYY = XXYY fewer
----- by isr:  2836116 - XXYY = XXYY fewer
----- combined: 248774 fewer (1.8%)
select count(distinct primaryid) from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown where primaryid is not null; 
--  10885185
select count(distinct isr) from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown where primaryid is  null; 
-- 2815304

-- XXYY reports after deduplication

------ old non-deduplicated counts -----
select count(distinct primaryid) from scratch_dedup_q1_2004_thr_q2_2022.combined_np_drug_outcome_drilldown where primaryid is not null; 
-- 11130879
select count(distinct isr) from scratch_dedup_q1_2004_thr_q2_2022.combined_np_drug_outcome_drilldown where primaryid is  null; 
-- 2836116

-- OLD DATA 13966995 total reports non-deduplicated


------------------------------------------------------------------ 
-- 5) Generate counts, PRR, and ROR over the deduplicated data over all quarters of data

drop table if exists scratch_dedup_q2_2022_w_vigimatch.standard_np_drug_outcome_count;
create table scratch_dedup_q2_2022_w_vigimatch.standard_np_drug_outcome_count as
select drug_concept_id, outcome_concept_id, count(*) as drug_outcome_pair_count, cast(null as integer) as snomed_outcome_concept_id
from (
	select 'PRIMARYID' || cndod.primaryid as case_key, cndod.drug_concept_id, cndod.outcome_concept_id, cast(null as integer) as snomed_outcome_concept_id
	from  scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown  cndod
	where cndod.primaryid is not null
	union
	select 'ISR' || cndod.isr as case_key, cndod.drug_concept_id, cndod.outcome_concept_id, cast(null as integer) as snomed_outcome_concept_id
	from  scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown  cndod
	where cndod.primaryid is null	
) aa
group by drug_concept_id, outcome_concept_id;
-- Updated Rows	5406838	

---- sanity check on counts before proceeding. The ranking of the drug-ADR counts should be very similar to 
---- the OLD cem data. The newer counts should be similar but the ranking the same
select c1.concept_name, c2.concept_name, sdoc.*
from scratch_dedup_q2_2022_w_vigimatch.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'simvastatin'
 order by sdoc.drug_outcome_pair_count desc
;
/* 
NEW data (lower counts due to older drug, no new indications, and greater deduplication?)
simvastatin	Nausea	1539403	35708202	12133
simvastatin	Fatigue	1539403	35809076	12120
simvastatin	Dyspnoea	1539403	35205038	11387
simvastatin	Drug ineffective	1539403	35809327	10667
simvastatin	Dizziness	1539403	35205025	10577
simvastatin	Diarrhoea	1539403	35708093	10449
simvastatin	Asthenia	1539403	35809072	8787
simvastatin	Myalgia	1539403	36516837	8426
simvastatin	Fall	1539403	36211297	8414
simvastatin	Pain	1539403	35809243	8310	

OLD data
simvastatin	Nausea	1539403	35708202	12321
simvastatin	Fatigue	1539403	35809076	12231
simvastatin	Dyspnoea	1539403	35205038	11506
simvastatin	Drug ineffective	1539403	35809327	10839
simvastatin	Dizziness	1539403	35205025	10740
simvastatin	Diarrhoea	1539403	35708093	10598
simvastatin	Asthenia	1539403	35809072	8851
simvastatin	Fall	1539403	36211297	8625  
 */

select c1.concept_name, c2.concept_name, sdoc.*
from scratch_dedup_q2_2022_w_vigimatch.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'colchicine'
 order by sdoc.drug_outcome_pair_count desc
;
/*
NEW data (some higher counts due to new indication (trials with COVID) that overcomes greater deduplication? Notice some new high counts e.g. athralgia)
colchicine	Diarrhoea	1101554	35708093	1837
colchicine	Nausea	1101554	35708202	1371
colchicine	Drug ineffective	1101554	35809327	1262
colchicine	Fatigue	1101554	35809076	1148
colchicine	Off label use	1101554	37522220	1047
colchicine	Gout	1101554	36416695	1022
colchicine	Dyspnoea	1101554	35205038	995
colchicine	Arthralgia	1101554	36516812	931
colchicine	Drug interaction	1101554	35809310	889
colchicine	Acute kidney injury	1101554	37080784	879	

OLD data 
colchicine	Diarrhoea	1101554	35708093	1792
colchicine	Nausea	1101554	35708202	1310
colchicine	Drug ineffective	1101554	35809327	1181
colchicine	Fatigue	1101554	35809076	1048
colchicine	Dyspnoea	1101554	35205038	1012
colchicine	Gout	1101554	36416695	1008
colchicine	Acute kidney injury	1101554	37080784	909
colchicine	Drug interaction	1101554	35809310	898
colchicine	Vomiting	1101554	35708208	871
colchicine	Off label use	1101554	37522220	869
*/


select c1.concept_name, c2.concept_name, sdoc.*
from scratch_dedup_q2_2022_w_vigimatch.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'tizanidine'
 order by sdoc.drug_outcome_pair_count desc
;
/*
NEW data (lower counts due to older drug, no new indications, and greater deduplication?)
tizanidine	Pain	778474	35809243	2412
tizanidine	Fatigue	778474	35809076	2370
tizanidine	Nausea	778474	35708202	2238
tizanidine	Drug ineffective	778474	35809327	2185
tizanidine	Headache	778474	36718132	2071
tizanidine	Fall	778474	36211297	1864
tizanidine	Dizziness	778474	35205025	1539
tizanidine	Diarrhoea	778474	35708093	1422
tizanidine	Depression	778474	36918942	1322
tizanidine	Asthenia	778474	35809072	1255	

OLD data
tizanidine	Fatigue	778474	35809076	2450
tizanidine	Pain	778474	35809243	2448
tizanidine	Nausea	778474	35708202	2361
tizanidine	Drug ineffective	778474	35809327	2249
tizanidine	Headache	778474	36718132	2148
tizanidine	Fall	778474	36211297	2001
tizanidine	Dizziness	778474	35205025	1625
tizanidine	Diarrhoea	778474	35708093	1500
tizanidine	Depression	778474	36918942	1391
tizanidine	Vomiting	778474	35708208	1320
*/

select c1.concept_name, c2.concept_name, sdoc.*
from scratch_dedup_q2_2022_w_vigimatch.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'Hemp extract' 
 order by sdoc.drug_outcome_pair_count desc
;
/*
NEW data -- drug abuse rose quite a bit but other ADR counts really similar
Hemp extract	Drug abuse	-7012349	36919127	1072
Hemp extract	Pain	-7012349	35809243	625
Hemp extract	Drug ineffective	-7012349	35809327	612
Hemp extract	Nausea	-7012349	35708202	601
Hemp extract	Substance abuse	-7012349	36919132	592
Hemp extract	Fatigue	-7012349	35809076	517
Hemp extract	Drug dependence	-7012349	36919128	446
Hemp extract	Toxicity to various agents	-7012349	42889647	429
Hemp extract	Off label use	-7012349	37522220	404
Hemp extract	Anxiety	-7012349	36918858	402	
 
   
OLD data 
Hemp extract	Drug abuse	-7000994	36919127	710
Hemp extract	Drug ineffective	-7000994	35809327	602
Hemp extract	Pain	-7000994	35809243	602
Hemp extract	Substance abuse	-7000994	36919132	574
Hemp extract	Nausea	-7000994	35708202	562
Hemp extract	Fatigue	-7000994	35809076	494
Hemp extract	Toxicity to various agents	-7000994	42889647	439
Hemp extract	Completed suicide	-7000994	36919230	412
Hemp extract	Off label use	-7000994	37522220	386
Hemp extract	Drug dependence	-7000994	36919128	379
*/

select c1.concept_name, c2.concept_name, sdoc.*
from scratch_dedup_q2_2022_w_vigimatch.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'Kratom'
 order by sdoc.drug_outcome_pair_count desc
;
/*
NEW data (very similar counts - looks like some deduplication)
Kratom	Death	-7012469	35809059	111
Kratom	Toxicity to various agents	-7012469	42889647	87
Kratom	Drug dependence	-7012469	36919128	53
Kratom	Accidental death	-7012469	35809056	35
Kratom	Drug abuse	-7012469	36919127	33
Kratom	Vomiting	-7012469	35708208	32
Kratom	Anxiety	-7012469	36918858	27
Kratom	Seizure	-7012469	36776613	27
Kratom	Withdrawal syndrome	-7012469	35809377	26
Kratom	Drug withdrawal syndrome	-7012469	35809369	23	

OLD data
Kratom	Death	-7001114	35809059	113
Kratom	Toxicity to various agents	-7001114	42889647	95
Kratom	Drug dependence	-7001114	36919128	48
Kratom	Drug abuse	-7001114	36919127	41
Kratom	Accidental death	-7001114	35809056	37
Kratom	Vomiting	-7001114	35708208	31
Kratom	Seizure	-7001114	36776613	28
Kratom	Anxiety	-7001114	36918858	23
Kratom	Nausea	-7001114	35708202	22
Kratom	Drug withdrawal syndrome	-7001114	35809369	20
*/
---- end of sanity check on counts before proceeding


set search_path to scratch_dedup_q2_2022_w_vigimatch;

drop index if exists standard_np_drug_outcome_count_ix;
create index standard_np_drug_outcome_count_ix on standard_np_drug_outcome_count(drug_concept_id, outcome_concept_id);
drop index if exists standard_np_drug_outcome_count_2_ix;
create index standard_np_drug_outcome_count_2_ix on standard_np_drug_outcome_count(drug_concept_id);
drop index if exists standard_np_drug_outcome_count_3_ix;
create index standard_np_drug_outcome_count_3_ix on standard_np_drug_outcome_count(outcome_concept_id);
drop index if exists standard_np_drug_outcome_count_4_ix;
create index standard_np_drug_outcome_count_4_ix on standard_np_drug_outcome_count(drug_outcome_pair_count);
analyze verbose standard_np_drug_outcome_count;
-- 



-- get count_d1 
drop table if exists standard_np_drug_outcome_count_d1;
create table standard_np_drug_outcome_count_d1 as
with cte as (
  select sum(drug_outcome_pair_count) as count_d1 from standard_np_drug_outcome_count 
)  
select drug_concept_id, outcome_concept_id, count_d1
from standard_np_drug_outcome_count a,  cte; -- we need the same total for all rows so do cross join!
-- 5406838

-- get count_a and count_b 
set search_path = scratch_dedup_q2_2022_w_vigimatch;
drop table if exists standard_np_drug_outcome_count_a_count_b;
create table standard_np_drug_outcome_count_a_count_b as
select drug_concept_id, outcome_concept_id, 
drug_outcome_pair_count as count_a, -- count of drug P and outcome R
(
	select sum(drug_outcome_pair_count)
	from standard_np_drug_outcome_count b
	where b.drug_concept_id = a.drug_concept_id and b.outcome_concept_id <> a.outcome_concept_id 
) as count_b -- count of drug P and not(outcome R)
from standard_np_drug_outcome_count a;
-- 5406838

-- get count_c 
set search_path = scratch_dedup_q2_2022_w_vigimatch;
drop table if exists standard_np_drug_outcome_count_c;
create table standard_np_drug_outcome_count_c as
select drug_concept_id, outcome_concept_id, 
(
	select sum(drug_outcome_pair_count) 
	from standard_np_drug_outcome_count c
	where c.drug_concept_id <> a.drug_concept_id and c.outcome_concept_id = a.outcome_concept_id 
) as count_c -- count of not(drug P) and outcome R
from standard_np_drug_outcome_count a; 
-- Updated Rows	5406838

-- get count d2 
set search_path = scratch_dedup_q2_2022_w_vigimatch;
drop table if exists standard_np_drug_outcome_count_d2;
create table standard_np_drug_outcome_count_d2 as
select drug_concept_id, outcome_concept_id, 
(
	select sum(drug_outcome_pair_count)
	from standard_np_drug_outcome_count d2
	where (d2.drug_concept_id = a.drug_concept_id) or (d2.outcome_concept_id = a.outcome_concept_id)
) as count_d2 -- count of all cases where drug P or outcome R 
from standard_np_drug_outcome_count a;
-- Updated Rows	5406838


--=============

-- Only run the below query when ALL OF THE ABOVE 3 QUERIES HAVE COMPLETED!
-- combine all the counts into a single contingency table
set search_path = scratch_dedup_q2_2022_w_vigimatch;

drop table if exists standard_np_outcome_contingency_table;

create table standard_np_outcome_contingency_table as		
select ab.drug_concept_id, ab.outcome_concept_id, count_a, count_b, count_c, (count_d1 - count_d2) as count_d
from standard_np_drug_outcome_count_a_count_b ab
inner join standard_np_drug_outcome_count_c c
on ab.drug_concept_id = c.drug_concept_id and ab.outcome_concept_id = c.outcome_concept_id
inner join standard_np_drug_outcome_count_d1 d1
on ab.drug_concept_id = d1.drug_concept_id and ab.outcome_concept_id = d1.outcome_concept_id
inner join standard_np_drug_outcome_count_d2 d2
on ab.drug_concept_id = d2.drug_concept_id and ab.outcome_concept_id = d2.outcome_concept_id;
-- Updated Rows	5406838

--- COUNT comparisons between old and newer data -- ~200K less in the newer pull
-- OLD CEM
select count(*)
from faers.standard_drug_outcome_contingency_table sdoct 
;
-- 5628714

--- Step 5

------ Create a statistics table called standard_np_outcome_stats (using the counts from the previously 
------ calculated 2x2 contingency table) with the following statistics for each natural product (np)/outcome pair:

-- 1) Case count
-- 2) Proportional Reporting Ratio (PRR) along with the 95% CI upper and lower values
-- 3) Reporting Odds Ratio (ROR) along with the 95% CI upper and lower values
--
-- PRR for pair:(drug P, outcome R) is calculated as (A / (A + B)) / (C / (C + D)
--
-- ROR for pair:(drug P, outcome R) is calculated as (A / C) / (B / D)
--
-- Where:
--		A = case_count for the pair:(drug P, outcome R)
--		B = sum(case_count) for all pairs:(drug P, all outcomes except outcome R)
--		C = sum(case_count) for all pairs:(all drugs except drug P, outcome R)
--		D = sum(case_count) for all pairs:(all drugs except drug P, all outcomes except outcome R)
--
-- Note if C is 0 then the resulting PRR and ROR values will be null. Potentially a relatively high constant value
-- could be assigned instead, to indicate a potential PRR and ROR signal in these cases.
--
--
-- Standard deviations are obtained from Douglas G Altman's Practical Statistics for Medical Research. 1999. Chapter 10.11. Page 267 
--
------------------------------
SET search_path = scratch_dedup_q2_2022_w_vigimatch;

drop table if exists standard_np_outcome_statistics;

create table standard_np_outcome_statistics as
select 
drug_concept_id, outcome_concept_id, cast(null as integer) as snomed_outcome_concept_id,
count_a as case_count,
round((count_a / (count_a + count_b)) / (count_c / (count_c + count_d)),5) as prr,
round(exp(ln((count_a / (count_a + count_b)) / (count_c / (count_c + count_d)))+1.96*sqrt((1.0/count_a)-(1.0/(count_a+count_b))+(1.0/count_c)-(1.0/(count_c+count_d)))),5) as prr_95_percent_upper_confidence_limit,
round(exp(ln((count_a / (count_a + count_b)) / (count_c / (count_c + count_d)))-1.96*sqrt((1.0/count_a)-(1.0/(count_a+count_b))+(1.0/count_c)-(1.0/(count_c+count_d)))),5) as prr_95_percent_lower_confidence_limit,
round(((count_a / count_c) / (count_b / count_d)),5) as ror,
round(exp((ln((count_a / count_c) / (count_b / count_d)))+1.96*sqrt((1.0/count_a)+(1.0/count_b)+(1.0/count_c)+(1.0/count_d))),5) as ror_95_percent_upper_confidence_limit,
round(exp((ln((count_a / count_c) / (count_b / count_d)))-1.96*sqrt((1.0/count_a)+(1.0/count_b)+(1.0/count_c)+(1.0/count_d))),5) as ror_95_percent_lower_confidence_limit
from standard_np_outcome_contingency_table;
-- Updated Rows	5406838	





-- N) export to AWS, -139,  and clone to run cumulative statistics 

-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- So, we need to rerun the signals with data up through Q3 2021 since 
-- there was a shift to use 'HERBALS\MITRAGYNINE' and similar to code the NP 
---------------------------------------------------------------------------------

create schema scratch_signals_q12004_thru_q32021;

-- create a new drilldown that just has q12004 thru q32021
select count(t.*)
from (
 select *
  from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown dcndad  
  where dcndad.report_year = 22
  union 
 select *
  from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown dcndad  
  where dcndad.report_year = 21 
    and dcndad.report_qrtr = 4
) t
;
-- this number of reports will be removed: 11579033
    
with rprts_to_exclude as (
 select *
 from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown dcndad  
 where dcndad.report_year = 22
 union 
 select *
 from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown dcndad  
 where dcndad.report_year = 21 
   and dcndad.report_qrtr = 4
)
select *
into scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown
from (
 select dcndad2.*
 from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown dcndad2
    left join rprts_to_exclude on dcndad2.primaryid = rprts_to_exclude.primaryid
 where dcndad2.primaryid is not null 
   and rprts_to_exclude.primaryid is null 
 union 
 select dcndad3.*
 from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown dcndad3
 where dcndad3.primaryid is null 
   and dcndad3.isr is not null 
) t
;
-- count of records: 135375646
-- 146954935 (q1 2004 thru q1 2022) - 11579033 (q4 2021 and q1 2022) = 135375902 (256 more than what we got back)

-- (q1 2004 thru q1 2022)
select count(*)
from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown
;
-- 146954935

-- (removing q4 2021 and q1 2022)
select count(*)
from scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown
;
-- 135375646

CREATE INDEX dedup_combined_np_drug_adr_drilldown_primaryid_idx ON scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown (primaryid);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_isr_idx ON scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown (isr);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_drug_concept_id_idx ON scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown (drug_concept_id);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_outcome_concept_id_idx ON scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown (outcome_concept_id);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_report_qrtr_idx ON scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown (report_qrtr);
CREATE INDEX dedup_combined_np_drug_adr_drilldown_report_year_idx ON scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown (report_year);


-- Generate counts, PRR, and ROR over the deduplicated data over quarters of data from Q1 2004 through Q3 2021
drop table if exists scratch_signals_q12004_thru_q32021.standard_np_drug_outcome_count;
create table scratch_signals_q12004_thru_q32021.standard_np_drug_outcome_count as
select drug_concept_id, outcome_concept_id, count(*) as drug_outcome_pair_count, cast(null as integer) as snomed_outcome_concept_id
from (
	select 'PRIMARYID' || cndod.primaryid as case_key, cndod.drug_concept_id, cndod.outcome_concept_id, cast(null as integer) as snomed_outcome_concept_id
	from  scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown  cndod
	where cndod.primaryid is not null
	union
	select 'ISR' || cndod.isr as case_key, cndod.drug_concept_id, cndod.outcome_concept_id, cast(null as integer) as snomed_outcome_concept_id
	from  scratch_signals_q12004_thru_q32021.dedup_combined_np_drug_adr_drilldown  cndod
	where cndod.primaryid is null	
) aa
group by drug_concept_id, outcome_concept_id;
-- Updated Rows	5235621


---- sanity check on counts before proceeding. 
select c1.concept_name, c2.concept_name, sdoc.*
from scratch_signals_q12004_thru_q32021.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'simvastatin'
 order by sdoc.drug_outcome_pair_count desc
;
/* 
-- All quarters
simvastatin	Nausea	1539403	35708202	12133
simvastatin	Fatigue	1539403	35809076	12120
simvastatin	Dyspnoea	1539403	35205038	11387
simvastatin	Drug ineffective	1539403	35809327	10667
simvastatin	Dizziness	1539403	35205025	10577
simvastatin	Diarrhoea	1539403	35708093	10449
simvastatin	Asthenia	1539403	35809072	8787
simvastatin	Myalgia	1539403	36516837	8426
simvastatin	Fall	1539403	36211297	8414
simvastatin	Pain	1539403	35809243	8310	

-- thru Q3 2021
simvastatin	Nausea	1539403	35708202	11776
simvastatin	Fatigue	1539403	35809076	11705
simvastatin	Dyspnoea	1539403	35205038	11082
simvastatin	Drug ineffective	1539403	35809327	10393
simvastatin	Dizziness	1539403	35205025	10344
simvastatin	Diarrhoea	1539403	35708093	10087
simvastatin	Asthenia	1539403	35809072	8530
simvastatin	Myalgia	1539403	36516837	8285
simvastatin	Flushing	1539403	35809130	8228
simvastatin	Fall	1539403	36211297	8131 
 */

select c1.concept_name, c2.concept_name, sdoc.*
from scratch_signals_q12004_thru_q32021.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'colchicine'
 order by sdoc.drug_outcome_pair_count desc
;
/*
-- All quarters
colchicine	Diarrhoea	1101554	35708093	1837
colchicine	Nausea	1101554	35708202	1371
colchicine	Drug ineffective	1101554	35809327	1262
colchicine	Fatigue	1101554	35809076	1148
colchicine	Off label use	1101554	37522220	1047
colchicine	Gout	1101554	36416695	1022
colchicine	Dyspnoea	1101554	35205038	995
colchicine	Arthralgia	1101554	36516812	931
colchicine	Drug interaction	1101554	35809310	889
colchicine	Acute kidney injury	1101554	37080784	879	

-- thru Q3 2021
colchicine	Diarrhoea	1101554	35708093	1704
colchicine	Nausea	1101554	35708202	1234
colchicine	Drug ineffective	1101554	35809327	1139
colchicine	Fatigue	1101554	35809076	991
colchicine	Gout	1101554	36416695	977
colchicine	Dyspnoea	1101554	35205038	931
colchicine	Off label use	1101554	37522220	863
colchicine	Drug interaction	1101554	35809310	840
colchicine	Arthralgia	1101554	36516812	820
colchicine	Vomiting	1101554	35708208	812

*/


select c1.concept_name, c2.concept_name, sdoc.*
from scratch_signals_q12004_thru_q32021.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'tizanidine'
 order by sdoc.drug_outcome_pair_count desc
;
/*
-- All quarters
tizanidine	Pain	778474	35809243	2412
tizanidine	Fatigue	778474	35809076	2370
tizanidine	Nausea	778474	35708202	2238
tizanidine	Drug ineffective	778474	35809327	2185
tizanidine	Headache	778474	36718132	2071
tizanidine	Fall	778474	36211297	1864
tizanidine	Dizziness	778474	35205025	1539
tizanidine	Diarrhoea	778474	35708093	1422
tizanidine	Depression	778474	36918942	1322
tizanidine	Asthenia	778474	35809072	1255	

-- thru Q3 2021
tizanidine	Pain	778474	35809243	2257
tizanidine	Fatigue	778474	35809076	2211
tizanidine	Nausea	778474	35708202	2134
tizanidine	Drug ineffective	778474	35809327	2082
tizanidine	Headache	778474	36718132	1973
tizanidine	Fall	778474	36211297	1759
tizanidine	Dizziness	778474	35205025	1462
tizanidine	Diarrhoea	778474	35708093	1357
tizanidine	Depression	778474	36918942	1247
tizanidine	Asthenia	778474	35809072	1169
*/

select c1.concept_name, c2.concept_name, sdoc.*
from scratch_signals_q12004_thru_q32021.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'Hemp extract' 
 order by sdoc.drug_outcome_pair_count desc
;
/*
-- All quarters
Hemp extract	Drug abuse	-7012349	36919127	1072
Hemp extract	Pain	-7012349	35809243	625
Hemp extract	Drug ineffective	-7012349	35809327	612
Hemp extract	Nausea	-7012349	35708202	601
Hemp extract	Substance abuse	-7012349	36919132	592
Hemp extract	Fatigue	-7012349	35809076	517
Hemp extract	Drug dependence	-7012349	36919128	446
Hemp extract	Toxicity to various agents	-7012349	42889647	429
Hemp extract	Off label use	-7012349	37522220	404
Hemp extract	Anxiety	-7012349	36918858	402	
 
-- thru Q3 2021   
Hemp extract	Drug abuse	-7012349	36919127	673
Hemp extract	Pain	-7012349	35809243	577
Hemp extract	Drug ineffective	-7012349	35809327	575
Hemp extract	Substance abuse	-7012349	36919132	556
Hemp extract	Nausea	-7012349	35708202	539
Hemp extract	Fatigue	-7012349	35809076	464
Hemp extract	Drug dependence	-7012349	36919128	373
Hemp extract	Toxicity to various agents	-7012349	42889647	365
Hemp extract	Off label use	-7012349	37522220	355
Hemp extract	Anxiety	-7012349	36918858	352

*/

select c1.concept_name, c2.concept_name, sdoc.*
from scratch_signals_q12004_thru_q32021.standard_np_drug_outcome_count sdoc inner join staging_vocabulary.concept c1  
   on sdoc.drug_concept_id = c1.concept_id inner join staging_vocabulary.concept c2
   on sdoc.outcome_concept_id  = c2.concept_id
 where c1.concept_name = 'Kratom'
 order by sdoc.drug_outcome_pair_count desc
;
/*
-- All quarters
Kratom	Death	-7012469	35809059	111
Kratom	Toxicity to various agents	-7012469	42889647	87
Kratom	Drug dependence	-7012469	36919128	53
Kratom	Accidental death	-7012469	35809056	35
Kratom	Drug abuse	-7012469	36919127	33
Kratom	Vomiting	-7012469	35708208	32
Kratom	Anxiety	-7012469	36918858	27
Kratom	Seizure	-7012469	36776613	27
Kratom	Withdrawal syndrome	-7012469	35809377	26
Kratom	Drug withdrawal syndrome	-7012469	35809369	23	

-- thru Q3 2021
Kratom	Death	-7012469	35809059	111
Kratom	Toxicity to various agents	-7012469	42889647	87
Kratom	Drug dependence	-7012469	36919128	53
Kratom	Accidental death	-7012469	35809056	35
Kratom	Drug abuse	-7012469	36919127	33
Kratom	Vomiting	-7012469	35708208	32
Kratom	Anxiety	-7012469	36918858	27
Kratom	Seizure	-7012469	36776613	27
Kratom	Withdrawal syndrome	-7012469	35809377	26
Kratom	Drug withdrawal syndrome	-7012469	35809369	23
Kratom	Nausea	-7012469	35708202	22

*/
---- end of sanity check on counts before proceeding


set search_path to scratch_signals_q12004_thru_q32021;

drop index if exists standard_np_drug_outcome_count_ix;
create index standard_np_drug_outcome_count_ix on standard_np_drug_outcome_count(drug_concept_id, outcome_concept_id);
drop index if exists standard_np_drug_outcome_count_2_ix;
create index standard_np_drug_outcome_count_2_ix on standard_np_drug_outcome_count(drug_concept_id);
drop index if exists standard_np_drug_outcome_count_3_ix;
create index standard_np_drug_outcome_count_3_ix on standard_np_drug_outcome_count(outcome_concept_id);
drop index if exists standard_np_drug_outcome_count_4_ix;
create index standard_np_drug_outcome_count_4_ix on standard_np_drug_outcome_count(drug_outcome_pair_count);
analyze verbose standard_np_drug_outcome_count;
-- 



-- get count_d1 
drop table if exists standard_np_drug_outcome_count_d1;
create table standard_np_drug_outcome_count_d1 as
with cte as (
  select sum(drug_outcome_pair_count) as count_d1 from standard_np_drug_outcome_count 
)  
select drug_concept_id, outcome_concept_id, count_d1
from standard_np_drug_outcome_count a,  cte; -- we need the same total for all rows so do cross join!
-- 5235621


-- get count_a and count_b 
set search_path = scratch_signals_q12004_thru_q32021;
drop table if exists standard_np_drug_outcome_count_a_count_b;
create table standard_np_drug_outcome_count_a_count_b as
select drug_concept_id, outcome_concept_id, 
drug_outcome_pair_count as count_a, -- count of drug P and outcome R
(
	select sum(drug_outcome_pair_count)
	from standard_np_drug_outcome_count b
	where b.drug_concept_id = a.drug_concept_id and b.outcome_concept_id <> a.outcome_concept_id 
) as count_b -- count of drug P and not(outcome R)
from standard_np_drug_outcome_count a;
-- 5235621


-- get count_c 
set search_path = scratch_signals_q12004_thru_q32021;
drop table if exists standard_np_drug_outcome_count_c;
create table standard_np_drug_outcome_count_c as
select drug_concept_id, outcome_concept_id, 
(
	select sum(drug_outcome_pair_count) 
	from standard_np_drug_outcome_count c
	where c.drug_concept_id <> a.drug_concept_id and c.outcome_concept_id = a.outcome_concept_id 
) as count_c -- count of not(drug P) and outcome R
from standard_np_drug_outcome_count a; 
-- Updated Rows	5235621

select count(*) from standard_np_drug_outcome_count_c;

-- get count d2 
set search_path = scratch_signals_q12004_thru_q32021;
drop table if exists standard_np_drug_outcome_count_d2;
create table standard_np_drug_outcome_count_d2 as
select drug_concept_id, outcome_concept_id, 
(
	select sum(drug_outcome_pair_count)
	from standard_np_drug_outcome_count d2
	where (d2.drug_concept_id = a.drug_concept_id) or (d2.outcome_concept_id = a.outcome_concept_id)
) as count_d2 -- count of all cases where drug P or outcome R 
from standard_np_drug_outcome_count a;
-- Updated Rows	5235621



--=============

-- Only run the below query when ALL OF THE ABOVE 3 QUERIES HAVE COMPLETED!
-- combine all the counts into a single contingency table
set search_path = scratch_signals_q12004_thru_q32021;

drop table if exists standard_np_outcome_contingency_table;

create table standard_np_outcome_contingency_table as		
select ab.drug_concept_id, ab.outcome_concept_id, count_a, count_b, count_c, (count_d1 - count_d2) as count_d
from standard_np_drug_outcome_count_a_count_b ab
inner join standard_np_drug_outcome_count_c c
on ab.drug_concept_id = c.drug_concept_id and ab.outcome_concept_id = c.outcome_concept_id
inner join standard_np_drug_outcome_count_d1 d1
on ab.drug_concept_id = d1.drug_concept_id and ab.outcome_concept_id = d1.outcome_concept_id
inner join standard_np_drug_outcome_count_d2 d2
on ab.drug_concept_id = d2.drug_concept_id and ab.outcome_concept_id = d2.outcome_concept_id;
-- Updated Rows	5235621


--------------------------------------------------------------------------------------------

----------------------
-- PV signals for Kratom - SOC level
with signals as ( 
 select c1.concept_id np_pt_concept_id, c1.concept_name np_pt, 
        c2.concept_id outcome_concept_id, c2.concept_name outcome_concept_name, 
        v.case_count, v.ror, v.ror_95_percent_lower_confidence_limit, v.ror_95_percent_upper_confidence_limit 
 from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_statistics v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
 where v.drug_concept_id  = -7012469
   and v.ror_95_percent_lower_confidence_limit > 1.0
   and v.case_count >= 5
)
select  np_pt_concept_id,  np_pt, 
        c3.concept_name SOC, 
        outcome_concept_name PT, outcome_concept_id,        
        case_count, 
        ror, ror_95_percent_lower_confidence_limit, ror_95_percent_upper_confidence_limit
from signals 
    inner join staging_vocabulary.concept c1 on outcome_concept_name = c1.concept_name
    inner join staging_vocabulary.concept_ancestor ca on c1.concept_id = ca.descendant_concept_id
    inner join staging_vocabulary.concept c2 on ca.ancestor_concept_id = c2.concept_id
    inner join staging_vocabulary.concept_ancestor ca2 on c2.concept_id = ca2.descendant_concept_id
    inner join staging_vocabulary.concept c3 on ca2.ancestor_concept_id = c3.concept_id
where c3.concept_class_id = 'SOC' 
    and c2.concept_class_id = 'HLT'
group by np_pt_concept_id,  np_pt, SOC, PT,  
        outcome_concept_id, outcome_concept_name,
        case_count,
        ror, ror_95_percent_lower_confidence_limit, ror_95_percent_upper_confidence_limit
order by ror_95_percent_lower_confidence_limit desc
;
/* -- SOC mapped ADR signals - TODO: remove duplicate PTs after selecting a preferred MedDRA SOC
-7012469	Kratom	General disorders and administration site conditions	Accidental death	35809056	35	573.07522	409.64788	801.70123
-7012469	Kratom	Injury, poisoning and procedural complications	Accidental death	35809056	35	573.07522	409.64788	801.70123
-7012469	Kratom	Product issues	Product complaint	42891594	12	105.08824	59.54458	185.46671
-7012469	Kratom	Investigations	Drug screen positive	36316280	15	73.70409	44.32822	122.54705
-7012469	Kratom	General disorders and administration site conditions	Withdrawal syndrome	35809377	26	28.91391	19.62951	42.58967
-7012469	Kratom	Psychiatric disorders	Withdrawal syndrome	35809377	26	28.91391	19.62951	42.58967
-7012469	Kratom	Psychiatric disorders	Drug use disorder	1199426	5	45.87067	19.06420	110.37016
-7012469	Kratom	Social circumstances	Alcohol use	37420495	5	43.76674	18.18999	105.30668
-7012469	Kratom	Injury, poisoning and procedural complications	Toxicity to various agents	42889647	87	18.87690	15.21767	23.41603
-7012469	Kratom	Psychiatric disorders	Dependence	36919126	7	31.00760	14.75857	65.14663
-7012469	Kratom	Psychiatric disorders	Drug abuse	36919127	33	17.30359	12.26173	24.41859
-7012469	Kratom	General disorders and administration site conditions	Drug withdrawal syndrome neonatal	35809370	9	20.70411	10.75382	39.86118
-7012469	Kratom	Pregnancy, puerperium and perinatal conditions	Drug withdrawal syndrome neonatal	35809370	9	20.70411	10.75382	39.86118
-7012469	Kratom	Psychiatric disorders	Drug withdrawal syndrome neonatal	35809370	9	20.70411	10.75382	39.86118
-7012469	Kratom	Psychiatric disorders	Drug dependence	36919128	53	13.12223	9.98381	17.24720
-7012469	Kratom	Surgical and medical procedures	Caesarean section	37521618	6	20.33911	9.12420	45.33870
-7012469	Kratom	Nervous system disorders	Seizure	36776613	27	10.51361	7.18901	15.37567
-7012469	Kratom	General disorders and administration site conditions	Drug withdrawal syndrome	35809369	23	10.34566	6.85645	15.61050
-7012469	Kratom	Psychiatric disorders	Drug withdrawal syndrome	35809369	23	10.34566	6.85645	15.61050
-7012469	Kratom	Injury, poisoning and procedural complications	Serotonin syndrome	36718458	8	13.15640	6.56878	26.35054
-7012469	Kratom	Musculoskeletal and connective tissue disorders	Serotonin syndrome	36718458	8	13.15640	6.56878	26.35054
-7012469	Kratom	Nervous system disorders	Serotonin syndrome	36718458	8	13.15640	6.56878	26.35054
-7012469	Kratom	Hepatobiliary disorders	Acute hepatic failure	35909513	5	15.31215	6.36487	36.83685
-7012469	Kratom	General disorders and administration site conditions	Death	35809059	111	7.55508	6.23449	9.15538
-7012469	Kratom	Nervous system disorders	Unresponsive to stimuli	36718371	10	11.27208	6.05409	20.98743
-7012469	Kratom	Cardiac disorders	Cardio-respiratory arrest	35204970	13	9.33424	5.40897	16.10806
-7012469	Kratom	Respiratory, thoracic and mediastinal disorders	Cardio-respiratory arrest	35204970	13	9.33424	5.40897	16.10806
-7012469	Kratom	Respiratory, thoracic and mediastinal disorders	Respiratory arrest	37219893	9	10.21901	5.30803	19.67363
-7012469	Kratom	Nervous system disorders	Generalised tonic-clonic seizure	36776531	5	12.50145	5.19661	30.07462
-7012469	Kratom	Blood and lymphatic system disorders	Coagulopathy	35104161	7	10.32126	4.91303	21.68285
-7012469	Kratom	Social circumstances	Impaired work ability	37420530	6	9.94835	4.46309	22.17514
-7012469	Kratom	Psychiatric disorders	Mood swings	36919052	7	9.20621	4.38227	19.34027
-7012469	Kratom	Hepatobiliary disorders	Drug-induced liver injury	42889495	6	9.52301	4.27228	21.22700
-7012469	Kratom	Injury, poisoning and procedural complications	Drug-induced liver injury	42889495	6	9.52301	4.27228	21.22700
-7012469	Kratom	Social circumstances	Economic problem	37420362	8	8.44072	4.21440	16.90532
-7012469	Kratom	General disorders and administration site conditions	Irritability	35809139	10	6.78465	3.64401	12.63209
-7012469	Kratom	Psychiatric disorders	Irritability	35809139	10	6.78465	3.64401	12.63209
-7012469	Kratom	Cardiac disorders	Cardiac arrest	35204966	15	5.72228	3.44229	9.51242
-7012469	Kratom	Injury, poisoning and procedural complications	Intentional overdose	36211492	8	6.86558	3.42796	13.75049
-7012469	Kratom	Renal and urinary disorders	Chromaturia	37019416	5	7.79218	3.23914	18.74512
-7012469	Kratom	Psychiatric disorders	Psychotic disorder	36919149	6	6.93981	3.11343	15.46880
-7012469	Kratom	Injury, poisoning and procedural complications	Intentional product misuse	45885696	10	5.77379	3.10109	10.74998
-7012469	Kratom	Musculoskeletal and connective tissue disorders	Restless legs syndrome	36516858	5	7.44905	3.09651	17.91964
-7012469	Kratom	Nervous system disorders	Restless legs syndrome	36516858	5	7.44905	3.09651	17.91964
-7012469	Kratom	General disorders and administration site conditions	Completed suicide	36919230	11	5.47727	3.02767	9.90878
-7012469	Kratom	Psychiatric disorders	Completed suicide	36919230	11	5.47727	3.02767	9.90878
-7012469	Kratom	Injury, poisoning and procedural complications	Foetal exposure during pregnancy	42889636	9	5.38355	2.79641	10.36421
-7012469	Kratom	Pregnancy, puerperium and perinatal conditions	Foetal exposure during pregnancy	42889636	9	5.38355	2.79641	10.36421
-7012469	Kratom	Cardiac disorders	Pulmonary oedema	35205259	9	5.30888	2.75763	10.22045
-7012469	Kratom	Respiratory, thoracic and mediastinal disorders	Pulmonary oedema	35205259	9	5.30888	2.75763	10.22045
-7012469	Kratom	General disorders and administration site conditions	Hyperhidrosis	35809134	16	4.23163	2.58664	6.92276
-7012469	Kratom	Skin and subcutaneous tissue disorders	Hyperhidrosis	35809134	16	4.23163	2.58664	6.92276
-7012469	Kratom	Nervous system disorders	Restlessness	36718368	6	5.61742	2.52017	12.52111
-7012469	Kratom	Psychiatric disorders	Restlessness	36718368	6	5.61742	2.52017	12.52111
-7012469	Kratom	Nervous system disorders	Agitation	36718347	10	4.61110	2.47662	8.58517
-7012469	Kratom	Psychiatric disorders	Agitation	36718347	10	4.61110	2.47662	8.58517
-7012469	Kratom	Psychiatric disorders	Anger	36919042	5	5.94523	2.47140	14.30189
-7012469	Kratom	Blood and lymphatic system disorders	Jaundice	35104306	5	5.65715	2.35166	13.60886
-7012469	Kratom	Hepatobiliary disorders	Jaundice	35104306	5	5.65715	2.35166	13.60886
-7012469	Kratom	Skin and subcutaneous tissue disorders	Jaundice	35104306	5	5.65715	2.35166	13.60886
-7012469	Kratom	Psychiatric disorders	Panic attack	36918904	5	5.04542	2.09737	12.13725
-7012469	Kratom	Psychiatric disorders	Anxiety	36918858	27	3.02169	2.06621	4.41901
-7012469	Kratom	Social circumstances	Loss of personal independence in daily activities	1197924	7	4.32731	2.05990	9.09056
-7012469	Kratom	General disorders and administration site conditions	Night sweats	35809151	5	4.75558	1.97688	11.43998
-7012469	Kratom	Skin and subcutaneous tissue disorders	Night sweats	35809151	5	4.75558	1.97688	11.43998
-7012469	Kratom	Injury, poisoning and procedural complications	Overdose	36211496	16	3.12727	1.91159	5.11605
-7012469	Kratom	Gastrointestinal disorders	Vomiting	35708208	32	2.37068	1.67119	3.36294
-7012469	Kratom	Psychiatric disorders	Aggression	36919059	5	3.81966	1.58783	9.18850
-7012469	Kratom	Nervous system disorders	Tremor	36718265	13	2.67173	1.54824	4.61049
-7012469	Kratom	Nervous system disorders	Disturbance in attention	36718180	5	3.49222	1.45172	8.40080
-7012469	Kratom	Psychiatric disorders	Disturbance in attention	36718180	5	3.49222	1.45172	8.40080
-7012469	Kratom	Investigations	Heart rate increased	36311983	8	2.76722	1.38169	5.54214
-7012469	Kratom	Psychiatric disorders	Hallucination	36918984	6	2.86338	1.28463	6.38234
-7012469	Kratom	Injury, poisoning and procedural complications	Maternal exposure during pregnancy	42889640	6	2.83306	1.27103	6.31476
-7012469	Kratom	Pregnancy, puerperium and perinatal conditions	Maternal exposure during pregnancy	42889640	6	2.83306	1.27103	6.31476
-7012469	Kratom	Psychiatric disorders	Depression	36918942	16	2.05738	1.25761	3.36576
-7012469	Kratom	Respiratory, thoracic and mediastinal disorders	Rhinorrhoea	37219959	5	2.90956	1.20951	6.99915
-7012469	Kratom	General disorders and administration site conditions	Decreased appetite	36416514	14	1.98041	1.17046	3.35085
-7012469	Kratom	Metabolism and nutrition disorders	Decreased appetite	36416514	14	1.98041	1.17046	3.35085
-7012469	Kratom	General disorders and administration site conditions	Drug interaction	35809310	12	2.00428	1.13605	3.53605
-7012469	Kratom	Investigations	Hepatic enzyme increased	36313585	6	2.36964	1.06312	5.28180
-7012469	Kratom	Cardiac disorders	Palpitations	35205034	7	2.21861	1.05612	4.66068
-7012469	Kratom	General disorders and administration site conditions	Feeling abnormal	35809083	11	1.81184	1.00154	3.27770
*/


-- Set up for O/E with shrinkage calculations
-- Example: a1 <- obsexp_shrink_signal(c("Kratom (any role) - ADR X"=cell A), cell B, cell C, cell D)
create TEMPORARY SEQUENCE sid START 1;
with signals as ( 
 select c1.concept_id np_pt_concept_id, c1.concept_name np_pt, 
        c2.concept_id outcome_concept_id, c2.concept_name outcome_concept_name, 
        v.case_count, v.ror, v.ror_95_percent_lower_confidence_limit, v.ror_95_percent_upper_confidence_limit 
 from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_statistics v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
 where c1.concept_id = -7012469 -- limits vocab to Kratom
  and  v.ror_95_percent_lower_confidence_limit > 1.0
  and v.case_count >= 5
)
select concat('k', cast(nextval('sid') as text), '<- obsexp_shrink_signal(c("', np_pt, '(any role) - ', outcome_concept_name, '"=', count_a, '), ',
              count_b, ', ', count_c, ', ', count_d, ')')
from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_contingency_table snoct 
  inner join signals on signals.np_pt_concept_id = snoct.drug_concept_id and signals.outcome_concept_id = snoct.outcome_concept_id
;
drop sequence sid;
-- 
/*
k1<- obsexp_shrink_signal(c("Kratom(any role) - Loss of personal independence in daily activities"=7), 1775, 133719, 146727639)
k2<- obsexp_shrink_signal(c("Kratom(any role) - Drug use disorder"=5), 1777, 9008, 146852350)
k3<- obsexp_shrink_signal(c("Kratom(any role) - Coagulopathy"=7), 1775, 56093, 146805265)
k4<- obsexp_shrink_signal(c("Kratom(any role) - Jaundice"=5), 1777, 73009, 146788349)
k5<- obsexp_shrink_signal(c("Kratom(any role) - Cardiac arrest"=15), 1767, 217545, 146643813)
k6<- obsexp_shrink_signal(c("Kratom(any role) - Cardio-respiratory arrest"=13), 1769, 115532, 146745826)
k7<- obsexp_shrink_signal(c("Kratom(any role) - Palpitations"=7), 1775, 260588, 146600770)
k8<- obsexp_shrink_signal(c("Kratom(any role) - Pulmonary oedema"=9), 1773, 140289, 146721069)
k9<- obsexp_shrink_signal(c("Kratom(any role) - Vomiting"=32), 1750, 1124113, 145737245)
k10<- obsexp_shrink_signal(c("Kratom(any role) - Accidental death"=35), 1747, 5134, 146856224)
k11<- obsexp_shrink_signal(c("Kratom(any role) - Death"=111), 1671, 1280010, 145581348)
k12<- obsexp_shrink_signal(c("Kratom(any role) - Feeling abnormal"=11), 1771, 501737, 146359621)
k13<- obsexp_shrink_signal(c("Kratom(any role) - Hyperhidrosis"=16), 1766, 313762, 146547596)
k14<- obsexp_shrink_signal(c("Kratom(any role) - Irritability"=10), 1772, 122055, 146739303)
k15<- obsexp_shrink_signal(c("Kratom(any role) - Night sweats"=5), 1777, 86842, 146774516)
k16<- obsexp_shrink_signal(c("Kratom(any role) - Drug interaction"=12), 1770, 495097, 146366261)
k17<- obsexp_shrink_signal(c("Kratom(any role) - Drug withdrawal syndrome"=23), 1759, 185380, 146675978)
k18<- obsexp_shrink_signal(c("Kratom(any role) - Drug withdrawal syndrome neonatal"=9), 1773, 35998, 146825360)
k19<- obsexp_shrink_signal(c("Kratom(any role) - Withdrawal syndrome"=26), 1756, 75167, 146786191)
k20<- obsexp_shrink_signal(c("Kratom(any role) - Acute hepatic failure"=5), 1777, 26982, 146834376)
k21<- obsexp_shrink_signal(c("Kratom(any role) - Intentional overdose"=8), 1774, 96401, 146764957)
k22<- obsexp_shrink_signal(c("Kratom(any role) - Overdose"=16), 1766, 424244, 146437114)
k23<- obsexp_shrink_signal(c("Kratom(any role) - Heart rate increased"=8), 1774, 238942, 146622416)
k24<- obsexp_shrink_signal(c("Kratom(any role) - Hepatic enzyme increased"=6), 1776, 209081, 146652277)
k25<- obsexp_shrink_signal(c("Kratom(any role) - Drug screen positive"=15), 1767, 16913, 146844445)
k26<- obsexp_shrink_signal(c("Kratom(any role) - Decreased appetite"=14), 1768, 584877, 146276481)
k27<- obsexp_shrink_signal(c("Kratom(any role) - Restless legs syndrome"=5), 1777, 55453, 146805905)
k28<- obsexp_shrink_signal(c("Kratom(any role) - Disturbance in attention"=5), 1777, 118233, 146743125)
k29<- obsexp_shrink_signal(c("Kratom(any role) - Tremor"=13), 1769, 402845, 146458513)
k30<- obsexp_shrink_signal(c("Kratom(any role) - Agitation"=10), 1772, 179518, 146681840)
k31<- obsexp_shrink_signal(c("Kratom(any role) - Restlessness"=6), 1776, 88271, 146773087)
k32<- obsexp_shrink_signal(c("Kratom(any role) - Unresponsive to stimuli"=10), 1772, 73489, 146787869)
k33<- obsexp_shrink_signal(c("Kratom(any role) - Serotonin syndrome"=8), 1774, 50322, 146811036)
k34<- obsexp_shrink_signal(c("Kratom(any role) - Generalised tonic-clonic seizure"=5), 1777, 33047, 146828311)
k35<- obsexp_shrink_signal(c("Kratom(any role) - Seizure"=27), 1755, 214589, 146646769)
k36<- obsexp_shrink_signal(c("Kratom(any role) - Anxiety"=27), 1755, 743941, 146117417)
k37<- obsexp_shrink_signal(c("Kratom(any role) - Panic attack"=5), 1777, 81856, 146779502)
k38<- obsexp_shrink_signal(c("Kratom(any role) - Depression"=16), 1766, 643894, 146217464)
k39<- obsexp_shrink_signal(c("Kratom(any role) - Hallucination"=6), 1776, 173071, 146688287)
k40<- obsexp_shrink_signal(c("Kratom(any role) - Anger"=5), 1777, 69473, 146791885)
k41<- obsexp_shrink_signal(c("Kratom(any role) - Mood swings"=7), 1775, 62884, 146798474)
k42<- obsexp_shrink_signal(c("Kratom(any role) - Aggression"=5), 1777, 108105, 146753253)
k43<- obsexp_shrink_signal(c("Kratom(any role) - Dependence"=7), 1775, 18676, 146842682)
k44<- obsexp_shrink_signal(c("Kratom(any role) - Drug abuse"=33), 1749, 159964, 146701394)
k45<- obsexp_shrink_signal(c("Kratom(any role) - Drug dependence"=53), 1729, 342269, 146519089)
k46<- obsexp_shrink_signal(c("Kratom(any role) - Psychotic disorder"=6), 1776, 71459, 146789899)
k47<- obsexp_shrink_signal(c("Kratom(any role) - Completed suicide"=11), 1771, 166351, 146695007)
k48<- obsexp_shrink_signal(c("Kratom(any role) - Chromaturia"=5), 1777, 53012, 146808346)
k49<- obsexp_shrink_signal(c("Kratom(any role) - Respiratory arrest"=9), 1773, 72915, 146788443)
k50<- obsexp_shrink_signal(c("Kratom(any role) - Rhinorrhoea"=5), 1777, 141887, 146719471)
k51<- obsexp_shrink_signal(c("Kratom(any role) - Economic problem"=8), 1774, 78421, 146782937)
k52<- obsexp_shrink_signal(c("Kratom(any role) - Alcohol use"=5), 1777, 9441, 146851917)
k53<- obsexp_shrink_signal(c("Kratom(any role) - Impaired work ability"=6), 1776, 49856, 146811502)
k54<- obsexp_shrink_signal(c("Kratom(any role) - Caesarean section"=6), 1776, 24390, 146836968)
k55<- obsexp_shrink_signal(c("Kratom(any role) - Drug-induced liver injury"=6), 1776, 52082, 146809276)
k56<- obsexp_shrink_signal(c("Kratom(any role) - Foetal exposure during pregnancy"=9), 1773, 138345, 146723013)
k57<- obsexp_shrink_signal(c("Kratom(any role) - Maternal exposure during pregnancy"=6), 1776, 174921, 146686437)
k58<- obsexp_shrink_signal(c("Kratom(any role) - Toxicity to various agents"=87), 1695, 398242, 146463116)
k59<- obsexp_shrink_signal(c("Kratom(any role) - Product complaint"=12), 1770, 9474, 146851884)
k60<- obsexp_shrink_signal(c("Kratom(any role) - Intentional product misuse"=10), 1772, 143403, 146717955)
*/



------------------- SCRATCH  ----------------
select distinct c.concept_name, count(distinct d.primaryid) faers_case_cnt, count(distinct d.isr) laers_case_cnt 
from scratch_dedup_q2_2022_w_vigimatch.dedup_combined_np_drug_adr_drilldown d  
  inner join staging_vocabulary.concept c on c.concept_id = d.drug_concept_id 
where d.drug_concept_id < 0
group by c.concept_name 
order by c.concept_name asc
;
-- 
/*
*/


-- Set up for O/E with shrinkage calculations
-- Example: a1 <- obsexp_shrink_signal(c("Kratom (any role) - ADR X"=cell A), cell B, cell C, cell D)
create TEMPORARY SEQUENCE sid START 1;
with signals as ( 
 select c1.concept_id np_pt_concept_id, c1.concept_name np_pt, 
        c2.concept_id outcome_concept_id, c2.concept_name outcome_concept_name, 
        v.case_count, v.ror, v.ror_95_percent_lower_confidence_limit, v.ror_95_percent_upper_confidence_limit 
 from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_statistics v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
 where c1.concept_id = -7001796 -- limits vocab to Kratom
  and  v.ror_95_percent_lower_confidence_limit > 1.0
  and v.case_count >= 5
)
select concat('k', cast(nextval('sid') as text), '<- obsexp_shrink_signal(c("', np_pt, '(any role) - ', outcome_concept_name, '"=', count_a, '), ',
              count_b, ', ', count_c, ', ', count_d, ')')
from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_contingency_table snoct 
  inner join signals on signals.np_pt_concept_id = snoct.drug_concept_id and signals.outcome_concept_id = snoct.outcome_concept_id
;
drop sequence sid;
-- 
/*

 */

-- Kratom signals at PT and HLT (lower 95% CI bounds > 1.0 and more than 5 reports ) NOTE: There is some multi-hierarchical relationshios which increases the counts
with signals as ( 
 select c1.concept_id np_pt_concept_id, c1.concept_name np_pt, 
        c2.concept_id outcome_concept_id, c2.concept_name outcome_concept_name, 
        v.case_count, v.ror, v.ror_95_percent_lower_confidence_limit, v.ror_95_percent_upper_confidence_limit 
 from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_statistics v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
 where c1.concept_id = -7001796 -- limits vocab to Kratom
  and  v.ror_95_percent_lower_confidence_limit > 1.0
  and v.case_count >= 5
)
select  np_pt_concept_id,  np_pt, 
        c2.concept_name HLT, 
        outcome_concept_name PT, outcome_concept_id,        
        case_count, 
        ror, ror_95_percent_lower_confidence_limit, ror_95_percent_upper_confidence_limit
from signals 
    inner join staging_vocabulary.concept c1 on outcome_concept_name = c1.concept_name
    inner join staging_vocabulary.concept_ancestor ca on c1.concept_id = ca.descendant_concept_id
    inner join staging_vocabulary.concept c2 on ca.ancestor_concept_id = c2.concept_id
    inner join staging_vocabulary.concept_ancestor ca2 on c2.concept_id = ca2.descendant_concept_id
    inner join staging_vocabulary.concept c3 on ca2.ancestor_concept_id = c3.concept_id
where c3.concept_class_id = 'SOC' 
    and c2.concept_class_id = 'HLT'
group by np_pt_concept_id,  np_pt, HLT, PT,  
        outcome_concept_id, outcome_concept_name,
        case_count,
        ror, ror_95_percent_lower_confidence_limit, ror_95_percent_upper_confidence_limit
order by np_pt, HLT asc
;
-- 
/*
np_pt_concept_id	np_pt	hlt	pt	outcome_concept_id	case_count	ror	ror_95_percent_lower_confidence_limit	ror_95_percent_upper_confidence_limit 

 */

-- same thing but at the SOC level (note: some PTs map to more than one SOC)
with signals as ( 
 select c1.concept_id np_pt_concept_id, c1.concept_name np_pt, 
        c2.concept_id outcome_concept_id, c2.concept_name outcome_concept_name, 
        v.case_count, v.ror, v.ror_95_percent_lower_confidence_limit, v.ror_95_percent_upper_confidence_limit 
 from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_statistics v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
 where c1.concept_id = -7001796 -- limits vocab to Kratom
  and  v.ror_95_percent_lower_confidence_limit > 1.0
  and v.case_count >= 5
)
select  np_pt_concept_id,  np_pt, 
        c3.concept_name SOC, 
        outcome_concept_name PT, outcome_concept_id,        
        case_count, 
        ror, ror_95_percent_lower_confidence_limit, ror_95_percent_upper_confidence_limit
from signals 
    inner join staging_vocabulary.concept c1 on outcome_concept_name = c1.concept_name
    inner join staging_vocabulary.concept_ancestor ca on c1.concept_id = ca.descendant_concept_id
    inner join staging_vocabulary.concept c2 on ca.ancestor_concept_id = c2.concept_id
    inner join staging_vocabulary.concept_ancestor ca2 on c2.concept_id = ca2.descendant_concept_id
    inner join staging_vocabulary.concept c3 on ca2.ancestor_concept_id = c3.concept_id
where c3.concept_class_id = 'SOC' 
    and c2.concept_class_id = 'HLT'
group by np_pt_concept_id,  np_pt, SOC, PT,  
        outcome_concept_id, outcome_concept_name,
        case_count,
        ror, ror_95_percent_lower_confidence_limit, ror_95_percent_upper_confidence_limit
order by np_pt, SOC asc
;
--  bc  of the multi-hierarchy 
/*
np_pt_concept_id	np_pt	soc	pt	outcome_concept_id	case_count	ror	ror_95_percent_lower_confidence_limit	ror_95_percent_upper_confidence_limit  

 */


-------
-- Canagliflozin
select * 
from staging_vocabulary.concept c 
where c.concept_id = '43526465'
;


select c1.concept_id ingr_concept_id, c1.concept_name ingr_pt, 
        c2.concept_id adr_concept_id, c2.concept_name adr_concept_name, 
        v.case_count, v.ror, v.ror_95_percent_lower_confidence_limit, v.ror_95_percent_upper_confidence_limit 
 from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_statistics v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
 where c1.concept_id = '43526465' -- limits vocab to canagliflozin
  and  v.ror_95_percent_lower_confidence_limit > 1.0
  and v.case_count >= 5
  and c2.concept_name  ilike '%amputation%'
 order by v.ror_95_percent_lower_confidence_limit desc
 ;
/*
*/  

create TEMPORARY SEQUENCE sid START 1;
with signals as ( 
 select c1.concept_id ingr_concept_id, c1.concept_name ingr_pt, 
        c2.concept_id adr_concept_id, c2.concept_name adr_concept_name, 
        v.case_count, v.ror, v.ror_95_percent_lower_confidence_limit, v.ror_95_percent_upper_confidence_limit 
 from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_statistics v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
 where c1.concept_id = '43526465' -- limits vocab to canagliflozin
  and  v.ror_95_percent_lower_confidence_limit > 1.0
  and v.case_count >= 5
  and c2.concept_name  ilike '%amputation%'
)
select concat('k', cast(nextval('sid') as text), '<- obsexp_shrink_signal(c("', ingr_pt, '(any role) - ', adr_concept_name, '"=', count_a, '), ',
              count_b, ', ', count_c, ', ', count_d, ')')
from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_contingency_table snoct 
  inner join signals on signals.ingr_concept_id = snoct.drug_concept_id and signals.adr_concept_id = snoct.outcome_concept_id
;
drop sequence sid;
/*

 */



-----------------------------
-- Empaglifozin
select * 
from staging_vocabulary.concept c 
where c.concept_code = '1545653'
;


select c1.concept_id ingr_concept_id, c1.concept_name ingr_pt, 
        c2.concept_id adr_concept_id, c2.concept_name adr_concept_name, 
        v.case_count, v.ror, v.ror_95_percent_lower_confidence_limit, v.ror_95_percent_upper_confidence_limit 
 from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_statistics v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
 where c1.concept_code = '1545653' -- limits vocab to Empaglifozin
  and  v.ror_95_percent_lower_confidence_limit > 1.0
  and v.case_count >= 5
  and c2.concept_name  ilike '%amputation%'
 order by v.ror_95_percent_lower_confidence_limit desc
 ;
/*

 */  

create TEMPORARY SEQUENCE sid START 1;
with signals as ( 
 select c1.concept_id ingr_concept_id, c1.concept_name ingr_pt, 
        c2.concept_id adr_concept_id, c2.concept_name adr_concept_name, 
        v.case_count, v.ror, v.ror_95_percent_lower_confidence_limit, v.ror_95_percent_upper_confidence_limit 
 from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_statistics v 
   inner join staging_vocabulary.concept c1 on v.drug_concept_id = c1.concept_id 
   inner join staging_vocabulary.concept c2 on v.outcome_concept_id = c2.concept_id
 where c1.concept_code = '1545653' -- limits vocab to Empaglifozin
  and  v.ror_95_percent_lower_confidence_limit > 1.0
  and v.case_count >= 5
  and c2.concept_name  ilike '%amputation%'
)
select concat('k', cast(nextval('sid') as text), '<- obsexp_shrink_signal(c("', ingr_pt, '(any role) - ', adr_concept_name, '"=', count_a, '), ',
              count_b, ', ', count_c, ', ', count_d, ')')
from scratch_dedup_q2_2022_w_vigimatch.standard_np_outcome_contingency_table snoct 
  inner join signals on signals.ingr_concept_id = snoct.drug_concept_id and signals.adr_concept_id = snoct.outcome_concept_id
;
drop sequence sid;


------------------------------------------
-- subs.suspected_duplicates definition
CREATE TABLE scratch_dedup_q2_2022_w_vigimatch.suspected_duplicates (
	umcreportid int4 NULL,
	suspected_duplicate_report_id int4 NULL
);
CREATE INDEX suspected_duplicates_umcreportid_idx ON scratch_dedup_q2_2022_w_vigimatch.suspected_duplicates USING btree (umcreportid);

CREATE TABLE scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid (
	umcreportid int4 NOT NULL,
	safetyreportid int8 NULL
);
CREATE INDEX uscdersafetyreportid_umcreportid_idx ON scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid USING btree (umcreportid);

--- LOAD OF THE DATA FROM vigibase_sept_2022

-- How many of the kratom reports are present in the duplication table?
select count(*)
from scratch_dedup_q2_2022_w_vigimatch.kratom_test_dedup_method_v2 ktdmv
; -- 561

with k_faers_to_umc as ( -- 525 rows returned from 
 select u.*, ktdmv.primaryid, cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) faers_caseid
 from scratch_dedup_q2_2022_w_vigimatch.kratom_test_dedup_method_v2 ktdmv  
     inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u 
        on cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) = u.safetyreportid 
), umc_dups as ( -- 41 rows returned from this query if ran with the k_faers_to_umc
 select k_faers_to_umc.primaryid, k_faers_to_umc.faers_caseid,
        k_faers_to_umc.umcreportid, 
        sd.suspected_duplicate_report_id
 from k_faers_to_umc inner join scratch_dedup_q2_2022_w_vigimatch.suspected_duplicates sd 
    on k_faers_to_umc.umcreportid = sd.umcreportid 
)
select umc_dups.primaryid, 
	   umc_dups.faers_caseid, 
	   umc_dups.umcreportid, 
       umc_dups.suspected_duplicate_report_id suspected_dup_umcreportid, 
       u.safetyreportid suspected_dup_faers_caseid,
       ktdmv.primaryid suspected_dup_faers_primaryid
from umc_dups inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u
       on umc_dups.suspected_duplicate_report_id = u.umcreportid
   inner join scratch_dedup_q2_2022_w_vigimatch.kratom_test_dedup_method_v2 ktdmv 
       on u.safetyreportid  = cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer)
; -- 41 before joining back to the kratom table, 29 afterward (some are probably already deduplicated)


------------
-- How many of the cannabis reports are present in the duplication table?
select count(*)
from scratch_dedup_q2_2022_w_vigimatch.hemp_test_dedup_method_v2 ktdmv
; -- 6490

with k_faers_to_umc as ( --  
 select u.*, ktdmv.primaryid, cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) faers_caseid
 from scratch_dedup_q2_2022_w_vigimatch.hemp_test_dedup_method_v2 ktdmv  
     inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u 
        on cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) = u.safetyreportid 
), umc_dups as ( -- 491   rows returned from this query if ran with the k_faers_to_umc
 select k_faers_to_umc.primaryid, k_faers_to_umc.faers_caseid,
        k_faers_to_umc.umcreportid, 
        sd.suspected_duplicate_report_id
 from k_faers_to_umc inner join scratch_dedup_q2_2022_w_vigimatch.suspected_duplicates sd 
    on k_faers_to_umc.umcreportid = sd.umcreportid 
)
select umc_dups.primaryid, 
	   umc_dups.faers_caseid, 
	   umc_dups.umcreportid, 
       umc_dups.suspected_duplicate_report_id suspected_dup_umcreportid, 
       u.safetyreportid suspected_dup_faers_caseid,
       ktdmv.primaryid suspected_dup_faers_primaryid
from umc_dups inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u
       on umc_dups.suspected_duplicate_report_id = u.umcreportid
   inner join scratch_dedup_q2_2022_w_vigimatch.hemp_test_dedup_method_v2 ktdmv 
       on u.safetyreportid  = cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer)
order by umc_dups.primaryid
; --  


---------------------
-- How many of the canaglifozin reports are present in the duplication table?
select count(*)
from scratch_dedup_q2_2022_w_vigimatch.canagliflozin_test_dedup_method  ktdmv
; -- 27230

with k_faers_to_umc as ( -- 23756 rows returned from query crosswalking faers and vigibase
 select u.*, ktdmv.primaryid, cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) faers_caseid
 from scratch_dedup_q2_2022_w_vigimatch.canagliflozin_test_dedup_method ktdmv  
     inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u 
        on cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) = u.safetyreportid 
), umc_dups as ( -- 609 rows returned from this query if ran with the k_faers_to_umc
 select k_faers_to_umc.primaryid, k_faers_to_umc.faers_caseid,
        k_faers_to_umc.umcreportid, 
        sd.suspected_duplicate_report_id
 from k_faers_to_umc inner join scratch_dedup_q2_2022_w_vigimatch.suspected_duplicates sd 
    on k_faers_to_umc.umcreportid = sd.umcreportid 
)
select umc_dups.primaryid, 
	   umc_dups.faers_caseid, 
	   umc_dups.umcreportid, 
       umc_dups.suspected_duplicate_report_id suspected_dup_umcreportid, 
       u.safetyreportid suspected_dup_faers_caseid,
       ktdmv.primaryid suspected_dup_faers_primaryid
from umc_dups inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u
       on umc_dups.suspected_duplicate_report_id = u.umcreportid
    inner join scratch_dedup_q2_2022_w_vigimatch.canagliflozin_test_dedup_method ktdmv 
       on u.safetyreportid  = cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer)
order by umc_dups.primaryid
; --  609 before joining back to the canaglifozin table, 571 afterward (some are probably already deduplicated)


--

-- How many of the dapaglifozin reports are present in the duplication table?
select count(*)
from scratch_dedup_q2_2022_w_vigimatch.dapagliflozin_test_dedup_method  ktdmv
; -- 19047

with k_faers_to_umc as ( -- 9662 rows returned from query crosswalking faers and vigibase
 select u.*, ktdmv.primaryid, cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) faers_caseid
 from scratch_dedup_q2_2022_w_vigimatch.dapagliflozin_test_dedup_method ktdmv  
     inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u 
        on cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) = u.safetyreportid 
), umc_dups as ( -- 197 rows returned from this query if ran with the k_faers_to_umc
 select k_faers_to_umc.primaryid, k_faers_to_umc.faers_caseid,
        k_faers_to_umc.umcreportid, 
        sd.suspected_duplicate_report_id
 from k_faers_to_umc inner join scratch_dedup_q2_2022_w_vigimatch.suspected_duplicates sd 
    on k_faers_to_umc.umcreportid = sd.umcreportid 
)
select umc_dups.primaryid, 
	   umc_dups.faers_caseid, 
	   umc_dups.umcreportid, 
       umc_dups.suspected_duplicate_report_id suspected_dup_umcreportid, 
       u.safetyreportid suspected_dup_faers_caseid,
       ktdmv.primaryid suspected_dup_faers_primaryid
from umc_dups inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u
       on umc_dups.suspected_duplicate_report_id = u.umcreportid
    inner join scratch_dedup_q2_2022_w_vigimatch.dapagliflozin_test_dedup_method ktdmv 
       on u.safetyreportid  = cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer)
order by umc_dups.primaryid
; --  196 before joining back to the dapaglifozin table,  183 afterward (some are probably already deduplicated)



--

-- How many of the empagliflozin reports are present in the duplication table?
select count(*)
from scratch_dedup_q2_2022_w_vigimatch.empagliflozin_test_dedup_method  ktdmv
; -- 28458

with k_faers_to_umc as ( -- 17105 rows returned from query crosswalking faers and vigibase
 select u.*, ktdmv.primaryid, cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) faers_caseid
 from scratch_dedup_q2_2022_w_vigimatch.empagliflozin_test_dedup_method ktdmv  
     inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u 
        on cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer) = u.safetyreportid 
), umc_dups as ( -- 311 rows returned from this query if ran with the k_faers_to_umc
 select k_faers_to_umc.primaryid, k_faers_to_umc.faers_caseid,
        k_faers_to_umc.umcreportid, 
        sd.suspected_duplicate_report_id
 from k_faers_to_umc inner join scratch_dedup_q2_2022_w_vigimatch.suspected_duplicates sd 
    on k_faers_to_umc.umcreportid = sd.umcreportid 
)
select umc_dups.primaryid, 
	   umc_dups.faers_caseid, 
	   umc_dups.umcreportid, 
       umc_dups.suspected_duplicate_report_id suspected_dup_umcreportid, 
       u.safetyreportid suspected_dup_faers_caseid,
       ktdmv.primaryid suspected_dup_faers_primaryid
from umc_dups inner join scratch_dedup_q2_2022_w_vigimatch.uscdersafetyreportid u
       on umc_dups.suspected_duplicate_report_id = u.umcreportid
    inner join scratch_dedup_q2_2022_w_vigimatch.empagliflozin_test_dedup_method ktdmv 
       on u.safetyreportid  = cast(substring(ktdmv.primaryid, 1, length(ktdmv.primaryid) - 1) as integer)
order by umc_dups.primaryid
; --  309 before joining back to the dapaglifozin table, 293 afterward (some are probably already deduplicated)
