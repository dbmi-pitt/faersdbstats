set search_path = faers;

drop index if exists standard_drug_outcome_count_ix;
create index standard_drug_outcome_count_ix on standard_drug_outcome_count (drug_concept_id, outcome_concept_id);
drop index if exists standard_drug_outcome_count_2_ix;
create index standard_drug_outcome_count_2_ix on standard_drug_outcome_count (drug_concept_id);
drop index if exists standard_drug_outcome_count_3_ix;
create index standard_drug_outcome_count_3_ix on standard_drug_outcome_count (outcome_concept_id);
drop index if exists standard_drug_outcome_count_4_ix;
create index standard_drug_outcome_count_4_ix on standard_drug_outcome_count (drug_outcome_pair_count);
analyze verbose standard_drug_outcome_count;

-- get count_d1
drop table if exists standard_drug_outcome_count_d1;
create table standard_drug_outcome_count_d1 as
with cte as (
    select sum(drug_outcome_pair_count) as count_d1 from standard_drug_outcome_count
)
select drug_concept_id, outcome_concept_id, count_d1
from standard_drug_outcome_count a,
     cte; -- we need the same total for all rows so do cross join!