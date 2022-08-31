------------------------------
--
-- This SQL script computes the 2x2 contingency table for all unique legacy and current case drug/outcome pairs in a table called standard_drug_current_outcome_contingency_table
--
--
-- LTS COMPUTING LLC
------------------------------

set search_path = ${DATABASE_SCHEMA};

--drop index if exists standard_drug_outcome_count_ix;
create index if not exists standard_drug_outcome_count_ix on standard_drug_outcome_count(drug_concept_id, outcome_concept_id);

--drop index if exists standard_drug_outcome_count_2_ix;
create index if not exists standard_drug_outcome_count_2_ix on standard_drug_outcome_count(drug_concept_id);
--drop index if exists standard_drug_outcome_count_3_ix;
create index if not exists standard_drug_outcome_count_3_ix on standard_drug_outcome_count(outcome_concept_id);
--drop index if exists standard_drug_outcome_count_4_ix;
create index if not exists standard_drug_outcome_count_4_ix on standard_drug_outcome_count(drug_outcome_pair_count);
analyze verbose standard_drug_outcome_count;

-- get count_d1 
drop table if exists standard_drug_outcome_count_d1;
create table standard_drug_outcome_count_d1 as
	with cte as (
		select sum(drug_outcome_pair_count) as count_d1 from standard_drug_outcome_count 
		)  
	select drug_concept_id, outcome_concept_id, count_d1
		from standard_drug_outcome_count a,  cte; 
