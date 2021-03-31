-- get count_c
set search_path = faers;
drop table if exists standard_drug_outcome_count_c;
create table standard_drug_outcome_count_c as
select drug_concept_id,
       outcome_concept_id,
       (
           select sum(drug_outcome_pair_count)
           from standard_drug_outcome_count c
           where c.drug_concept_id <> a.drug_concept_id
             and c.outcome_concept_id = a.outcome_concept_id
       ) as count_c -- count of not(drug P) and outcome R
from standard_drug_outcome_count a;