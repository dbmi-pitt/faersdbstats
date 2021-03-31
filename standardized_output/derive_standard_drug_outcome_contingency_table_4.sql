-- get count d2
set search_path = faers;
drop table if exists standard_drug_outcome_count_d2;
create table standard_drug_outcome_count_d2 as
select drug_concept_id,
       outcome_concept_id,
       (
           select sum(drug_outcome_pair_count)
           from standard_drug_outcome_count d2
           where (d2.drug_concept_id = a.drug_concept_id)
              or (d2.outcome_concept_id = a.outcome_concept_id)
       ) as count_d2 -- count of all cases where drug P or outcome R
from standard_drug_outcome_count a;