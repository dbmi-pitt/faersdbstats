-- get count_a and count_b
set search_path = faers;
drop table if exists standard_drug_outcome_count_a_count_b;
create table standard_drug_outcome_count_a_count_b as
select drug_concept_id,
       outcome_concept_id,
       drug_outcome_pair_count as count_a, -- count of drug P and outcome R
       (
           select sum(drug_outcome_pair_count)
           from standard_drug_outcome_count b
           where b.drug_concept_id = a.drug_concept_id
             and b.outcome_concept_id <> a.outcome_concept_id
       )                       as count_b  -- count of drug P and not(outcome R)
from standard_drug_outcome_count a;