-- we need the same total for all rows so do cross join!

--============= On a 4+ CPU postgresql server, run the following 3 queries in 3 different postgresql sessions so they run concurrently!

-- get count_a and count_b 

drop table if exists standard_drug_outcome_count_a_count_b;
create table standard_drug_outcome_count_a_count_b as
	select drug_concept_id, outcome_concept_id, 
		drug_outcome_pair_count as count_a, -- count of drug P and outcome R
			(
				select sum(drug_outcome_pair_count)
				from standard_drug_outcome_count b
				where b.drug_concept_id = a.drug_concept_id and b.outcome_concept_id <> a.outcome_concept_id 
			) as count_b -- count of drug P and not(outcome R)
	from standard_drug_outcome_count a;

