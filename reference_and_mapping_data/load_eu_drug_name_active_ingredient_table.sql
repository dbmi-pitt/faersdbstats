-- Create a cross-walk table to map from EU drug name to active ingredient. 
-- It is populated data from the EU community registry full active substances list
--
-- http://ec.europa.eu/health/documents/community-register/html/reg_index_inn.htm
--
-- LTS Computing LLC
-----------------------------------------------------------------------------------------------
set search_path = faers;

drop table if exists eu_drug_name_active_ingredient;
create table eu_drug_name_active_ingredient 
(
	active_substance varchar,
	brand_name varchar,
	eu_number varchar,
	human_or_veterinary varchar,
	procedure_type varchar,
	details varchar
);

-- eliminate any invalid utf8 characters using the following command
-- iconv -f utf-8 -t utf-8 -c EU_registered_drugs_by_active_ingredient.txt >EU_registered_drugs_by_active_ingredient_utf8.txt
truncate eu_drug_name_active_ingredient;
COPY eu_drug_name_active_ingredient FROM 'eu_registered_drugs.tsv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'"';

-- set nulls where value is -
update eu_drug_name_active_ingredient set brand_name = null where brand_name = '-';
update eu_drug_name_active_ingredient set eu_number = null where eu_number = '-';

-- create the mapping table with the distinct EU drug names and active ingredient(s)
drop table if exists eu_drug_name_active_ingredient_mapping;
create table eu_drug_name_active_ingredient_mapping as
select distinct upper(active_substance) as active_substance, upper(brand_name) as brand_name
from eu_drug_name_active_ingredient
-- where human_or_veterinary = 'Human' and upper(active_substance) <> 'NOT APPLICABLE' and brand_name is not null
where upper(active_substance) <> 'NOT APPLICABLE' and brand_name is not null
order by 1,2;



