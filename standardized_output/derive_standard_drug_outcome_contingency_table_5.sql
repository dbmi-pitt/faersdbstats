-- Only run the below query when ALL OF THE ABOVE 3 QUERIES HAVE COMPLETED!
-- combine all the counts into a single contingency table
set search_path = faers;
drop table if exists standard_drug_outcome_contingency_table;
create table standard_drug_outcome_contingency_table as -- 1 second
select ab.drug_concept_id, ab.outcome_concept_id, count_a, count_b, count_c, (count_d1 - count_d2) as count_d
from standard_drug_outcome_count_a_count_b ab
         inner join standard_drug_outcome_count_c c
                    on ab.drug_concept_id = c.drug_concept_id and ab.outcome_concept_id = c.outcome_concept_id
         inner join standard_drug_outcome_count_d1 d1
                    on ab.drug_concept_id = d1.drug_concept_id and ab.outcome_concept_id = d1.outcome_concept_id
         inner join standard_drug_outcome_count_d2 d2
                    on ab.drug_concept_id = d2.drug_concept_id and ab.outcome_concept_id = d2.outcome_concept_id;

