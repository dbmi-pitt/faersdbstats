------------------------------
--
-- This SQL script performs two tasks:
--
-- 1) Find active OMOP CDM vocabulary standard RxNorm codes for all unique legacy LAERS and current FAERS case drugs we have mapped
-- 2) Map from the standard codes to standard codes with concept_class of 'Ingredient' or 'Clinical Drug Form' because We need to roll-up the safety signal stats that we generate to these two concept classes.
--
-- LTS COMPUTING LLC
------------------------------

set search_path = ${DATABASE_SCHEMA};

-- ====================== Create combined drug mapping table ==============================

-- create a combined drug mapping table which will have OHDSI vocabulary standard concept codes assigned to it

drop table if exists standard_combined_drug_mapping;

create table standard_combined_drug_mapping as
select a.*, cast (concept_id as integer) as standard_concept_id 
from combined_drug_mapping a;

-- Create indexes for performance
create index scdm_primaryid_idx on standard_combined_drug_mapping(primaryid);
create index scdm_isr_idx on standard_combined_drug_mapping(isr);
create index scdm_drug_name_original_idx on standard_combined_drug_mapping(upper(drug_name_original));
create index scdm_standard_concept_id_idx on standard_combined_drug_mapping(standard_concept_id);
create index scdm_concept_id_null_idx on standard_combined_drug_mapping(concept_id) where concept_id is null;
create index scdm_primaryid_isr_idx on standard_combined_drug_mapping(primaryid, isr);

-- ====================== NaPDI Mapping for unmapped drugs ==============================

-- Create temporary table for NaPDI mapping
create temp table temp_np_mapped_drug_name_original as 
select cdm.primaryid, cdm.isr, cdm.drug_name_original, cdm.lookup_value,
       c.concept_name, c.concept_class_id, c.concept_id
from standard_combined_drug_mapping cdm
left join staging_vocabulary.concept c on upper(cdm.drug_name_original) = upper(c.concept_name)
where cdm.concept_id is null
  and c.concept_id < 0;

-- Update standard_combined_drug_mapping with NaPDI mappings
update standard_combined_drug_mapping scdm
set concept_id = npmap.concept_id, -- fill in the null concept_id with the NP concept_id
    standard_concept_id = npmap.concept_id, -- although not standard according to the OMOP vocab, use the concept id as a standard concept
    update_method = 'napdi mapping'
from temp_np_mapped_drug_name_original npmap
where upper(scdm.drug_name_original) = upper(npmap.drug_name_original) 
  and scdm.concept_id is null  -- only update rows that need updating
  and ((scdm.isr is null and scdm.primaryid = npmap.primaryid)
       or (scdm.isr is not null and scdm.isr = npmap.isr));

-- ====================== Standard RxNorm Code Mapping ==============================

------------------------------------------------------
-- directly lookup the standard concept associated with the drug concepts we derived from drug name

-- Create a temporary table with RxNorm mappings
create temp table temp_rxnorm_mappings as
with input_concepts as (
select distinct scdm.standard_concept_id
from standard_combined_drug_mapping scdm
inner join staging_vocabulary.concept c 
on scdm.standard_concept_id = c.concept_id
    where scdm.concept_id is not null
and c.standard_concept is null 
      and c.vocabulary_id = 'RxNorm'
),
mappings as (
    select cr.concept_id_1, cr.concept_id_2
    from staging_vocabulary.concept_relationship cr
inner join staging_vocabulary.concept a
on cr.concept_id_1 = a.concept_id
inner join staging_vocabulary.concept b
on cr.concept_id_2 = b.concept_id
    where cr.invalid_reason is null
      and a.vocabulary_id = 'RxNorm'
and b.vocabulary_id = 'RxNorm'
and b.standard_concept = 'S'
and b.concept_class_id in ('Ingredient','Clinical Drug Form')
      and cr.concept_id_1 in (select standard_concept_id from input_concepts)
)
select * from mappings;

create index temp_rxnorm_mappings_idx on temp_rxnorm_mappings(concept_id_1);

-- Now update the standard_combined_drug_mapping with the standard concept id from the temp RxNorm mappings
update standard_combined_drug_mapping scdm 
set standard_concept_id = trm.concept_id_2
from temp_rxnorm_mappings trm
where scdm.standard_concept_id = trm.concept_id_1;

-- Check how many rows were updated
select count(*) as rows_updated
from standard_combined_drug_mapping scdm
inner join temp_rxnorm_mappings trm on scdm.standard_concept_id = trm.concept_id_1;

drop table temp_rxnorm_mappings;

------------------------------------------------------
-- convert standard branded drug form to standard ingredient or standard clinical drug form

with cte1 as ( -- this is the 'input' set of non standard concepts that we want to process
select distinct scdm.standard_concept_id
from standard_combined_drug_mapping scdm
INNER JOIN staging_vocabulary.concept c 
on scdm.standard_concept_id = c.concept_id 
and scdm.concept_id is not null 
and c.concept_class_id  = 'Branded Drug Form' 
),
cte2 as ( -- this is the 'output' set of standard concepts that we have found for the 'input' set of concepts
select concept_id_1, concept_id_2
from staging_vocabulary.concept_relationship  cr
inner join staging_vocabulary.concept a
on cr.concept_id_1 = a.concept_id
and cr.invalid_reason is null
and a.vocabulary_id = 'RxNorm'
inner join staging_vocabulary.concept b
on cr.concept_id_2 = b.concept_id
and b.vocabulary_id = 'RxNorm'
and b.standard_concept = 'S'
and b.concept_class_id in ('Ingredient','Clinical Drug Form')
and concept_id_1 in (select standard_concept_id from cte1)
)
update standard_combined_drug_mapping scdm 
set standard_concept_id = concept_id_2 -- update the standard concept id to the standard concept id we found
from cte2
where scdm.standard_concept_id = cte2.concept_id_1;

------------------------------------------------------
-- convert precise ingredient to standard ingredient or clinical drug form

with cte1 as ( -- this is the 'input' set of non standard concepts that we want to process
select distinct scdm.standard_concept_id
from standard_combined_drug_mapping scdm
INNER JOIN staging_vocabulary.concept c
on scdm.standard_concept_id = c.concept_id
and scdm.concept_id is not null
and c.concept_class_id  = 'Precise Ingredient'
),
cte2 as ( -- this is the 'output' set of standard concepts that we have found for the 'input' set of concepts
select c1.concept_id as concept_id_1, c2.concept_id as concept_id_2
from staging_vocabulary.concept c1
inner join staging_vocabulary.concept c2
on c2.concept_name = regexp_replace(c1.concept_name, ' decanoate$| hemihydrate$| aluminum$| tetrahydrate$| hexahydrate$| oxilate$| pivalate$| sulphonate$| anhydrous$| valerate$| dihydrate$| saccharate$| diacetate$| monosodium$| palmitate$| monophosphate$| stearate$| disodium$| propionate$| bitartrate$| pamoate$| dimesylate$| methylsulfate$| hydrobromide$| malate$| monohydrate$| silicate$| calcium$| magnesium$| tannate$| carbonate$| mesylate$| succinate$| potassium$| maleate$| benzoate$| nitrate$| citrate$| hydrate$| tartrate$| acetate$| phosphate$| dihydrochloride$| hydrochloride$| HCL$| chloride$| trihydrate$| besylate$| fumarate$| lactate$| gluconate$| bromide$| sulfate$| sodium$', '', 'i') 
where c1.vocabulary_id = 'RxNorm'
and c1.concept_class_id = 'Precise Ingredient'
and c2.vocabulary_id = 'RxNorm'
and c2.standard_concept = 'S'
and c2.concept_class_id in ('Ingredient','Clinical Drug Form')
and c1.concept_id in (select standard_concept_id from cte1)
)
update standard_combined_drug_mapping scdm
set standard_concept_id = concept_id_2 -- update the standard concept id to the standard concept id we found
from cte2
where scdm.standard_concept_id = cte2.concept_id_1;

------------------------------------------------------
-- convert brand name to standard ingredient or standard clinical drug form

with cte1 as ( -- this is the 'input' set of non standard concepts that we want to process
select distinct scdm.standard_concept_id
from standard_combined_drug_mapping scdm
INNER JOIN staging_vocabulary.concept c 
on scdm.standard_concept_id = c.concept_id 
and scdm.concept_id is not null 
and c.concept_class_id  = 'Brand Name' 
and c.invalid_reason is null
),
cte2 as ( -- this is the 'output' set of standard concepts that we have found for the 'input' set of concepts
select concept_id_1, concept_id_2
from staging_vocabulary.concept_relationship  cr
left outer join staging_vocabulary.concept a
on cr.concept_id_1 = a.concept_id
and a.vocabulary_id = 'RxNorm'
inner join staging_vocabulary.concept b
on cr.concept_id_2 = b.concept_id
and b.vocabulary_id = 'RxNorm'
and b.standard_concept = 'S'
and b.concept_class_id in ('Ingredient','Clinical Drug Form')
and concept_id_1 in (select standard_concept_id from cte1)
and relationship_id = 'Tradename of'
)
update standard_combined_drug_mapping scdm 
set standard_concept_id = concept_id_2 -- update the standard concept id to the standard concept id we found
from cte2
where scdm.standard_concept_id = cte2.concept_id_1;

------------------------------------------------------
-- map to the standard ingredient for a single ingredient brand name that has been updated
--'Concept replaced by' -> 'Tradename of' and standard_concept = 'S' and invalid_reason is null
with cte1 as ( -- this is the 'input' set of non standard concepts that we want to process
select distinct scdm.standard_concept_id
from standard_combined_drug_mapping scdm
INNER JOIN staging_vocabulary.concept c 
on scdm.standard_concept_id = c.concept_id 
and scdm.concept_id is not null 
and c.concept_class_id  = 'Brand Name' 
and c.invalid_reason = 'U'
),
cte2 as
(select concept_id_1, concept_id_2 from staging_vocabulary.concept_relationship a
inner join staging_vocabulary.concept b
on a.concept_id_1 = b.concept_id
inner join staging_vocabulary.concept c
on a.concept_id_2 = c.concept_id
and b.vocabulary_id = 'RxNorm'
and c.vocabulary_id = 'RxNorm'
where a.relationship_id = 'Concept replaced by'
and a.concept_id_1 in (select standard_concept_id from cte1)
),
cte3 as 
(select cr.concept_id_1 -- this cte eliminates brands with multi-ingredient drugs
from cte2
inner join staging_vocabulary.concept_relationship cr
on cte2.concept_id_2 = cr.concept_id_1   
inner join staging_vocabulary.concept b
on cr.concept_id_2 = b.concept_id
and cr.relationship_id = 'Tradename of' 
and b.vocabulary_id = 'RxNorm'
and b.standard_concept = 'S' and b.invalid_reason is null
group by cr.concept_id_1 
having count(cr.concept_id_1) = 1 
)
update standard_combined_drug_mapping scdm 
set standard_concept_id = b.concept_id -- update the standard concept id to the standard concept id we found
from cte3
inner join cte2
on cte2.concept_id_2 = cte3.concept_id_1
inner join staging_vocabulary.concept_relationship cr
on cte2.concept_id_2 = cr.concept_id_1   
inner join staging_vocabulary.concept b
on cr.concept_id_2 = b.concept_id
and cr.relationship_id = 'Tradename of' 
and b.vocabulary_id = 'RxNorm'
and b.standard_concept = 'S' and b.invalid_reason is null
where scdm.standard_concept_id = cte2.concept_id_1;

------------------------------------------------------
-- map to the standard ingredient for a brand name that has been deleted
--'Concept replaced by' -> 'Tradename of' -> 'Form of'
with cte1 as ( -- this is the 'input' set of non standard concepts that we want to process
select distinct scdm.standard_concept_id
from standard_combined_drug_mapping scdm
INNER JOIN staging_vocabulary.concept c 
on scdm.standard_concept_id = c.concept_id 
and scdm.concept_id is not null 
and c.concept_class_id  = 'Brand Name' 
and c.invalid_reason = 'D'
),
cte2 as
(select concept_id_1, concept_id_2 
from staging_vocabulary.concept_relationship a
inner join staging_vocabulary.concept b
on a.concept_id_1 = b.concept_id
inner join staging_vocabulary.concept c
on a.concept_id_2 = c.concept_id
and b.vocabulary_id = 'RxNorm'
and c.vocabulary_id = 'RxNorm'
where a.relationship_id = 'Tradename of'
and a.concept_id_1 in (select standard_concept_id from cte1)
)
update standard_combined_drug_mapping scdm 
set standard_concept_id = b.concept_id -- update the standard concept id to the standard concept id we found
from cte2
inner join staging_vocabulary.concept_relationship cr
on cte2.concept_id_2 = cr.concept_id_1   
inner join staging_vocabulary.concept b
on cr.concept_id_2 = b.concept_id
and cr.relationship_id = 'Form of' 
and b.vocabulary_id = 'RxNorm'
and b.standard_concept = 'S' and b.invalid_reason is null
where scdm.standard_concept_id = cte2.concept_id_1;
------------------------------------------------------
-- convert U or D status concepts to standard ingredient or clinical drug form

with cte1 as ( -- this is the 'input' set of non standard concepts that we want to process
select distinct scdm.standard_concept_id
from standard_combined_drug_mapping scdm
INNER JOIN staging_vocabulary.concept c 
on scdm.standard_concept_id = c.concept_id 
and scdm.concept_id is not null 
and c.invalid_reason in ('U','D')
),
cte2 as ( -- this is the 'output' set of standard concepts that we have found for the 'input' set of concepts
select concept_id_1, concept_id_2
from staging_vocabulary.concept_relationship  cr
left outer join staging_vocabulary.concept a
on cr.concept_id_1 = a.concept_id
and a.vocabulary_id = 'RxNorm'
inner join staging_vocabulary.concept b
on cr.concept_id_2 = b.concept_id
and b.vocabulary_id = 'RxNorm'
and b.standard_concept = 'S'
and b.concept_class_id in ('Ingredient','Clinical Drug Form')
and concept_id_1 in (select standard_concept_id from cte1)
)
update standard_combined_drug_mapping scdm 
set standard_concept_id = concept_id_2 -- update the standard concept id to the standard concept id we found
from cte2
where scdm.standard_concept_id = cte2.concept_id_1;

------------------------------------------------------
-- convert the standard clinical drug form concepts (that we derived in all the previous logic) with only a single ingredient, to standard ingredient
-- note RxNorm multi-ingredient drugs have a "/" char separating the ingredients in the clinical drug form name

with cte1 as ( -- this is the 'input' set of non standard concepts that we want to process
select distinct scdm.standard_concept_id
from standard_combined_drug_mapping scdm
INNER JOIN staging_vocabulary.concept c 
on scdm.standard_concept_id = c.concept_id 
and scdm.concept_id is not null 
and c.concept_class_id  = 'Clinical Drug Form' 
and c.concept_name not like '%/%'
),
cte2 as ( -- this is the 'output' set of standard concepts that we have found for the 'input' set of concepts
select concept_id_1, concept_id_2
from staging_vocabulary.concept_relationship  cr
left outer join staging_vocabulary.concept a
on cr.concept_id_1 = a.concept_id
and a.vocabulary_id = 'RxNorm'
inner join staging_vocabulary.concept b
on cr.concept_id_2 = b.concept_id
and b.vocabulary_id = 'RxNorm'
and b.standard_concept = 'S'
and b.concept_class_id in ('Ingredient')
and concept_id_1 in (select standard_concept_id from cte1)
)
update standard_combined_drug_mapping scdm 
set standard_concept_id = concept_id_2 -- update the standard concept id to the standard concept id we found
from cte2
where scdm.standard_concept_id = cte2.concept_id_1;

-------------------------------------------------------
-- these updates correct some edge cases around updated and deleted status concepts 
-- that are non-trivial to map directly using the concept_relationship table
-- potentially these cases could otherwise be handled via manual usagi mapping

-- map concept "Valproate sodium" to "Valproate"
update standard_combined_drug_mapping set standard_concept_id = 745466 where standard_concept_id = 40239960;
-- map concept "Aricept" to "donepezil"
update standard_combined_drug_mapping set standard_concept_id = 715997 where standard_concept_id = 40011116;
-- map concept "Rabeprazole Sodium" to "rabeprazole"
update standard_combined_drug_mapping set standard_concept_id = 911735 where standard_concept_id = 40077081;
-- map concept "Naprosyn" to "Naproxen"
update standard_combined_drug_mapping set standard_concept_id = 1115008 where standard_concept_id = 40064300;
-- map concept "Tazocin" to "Piperacillin / tazobactam Injectable Solution"
update standard_combined_drug_mapping set standard_concept_id = 40077118 where standard_concept_id = 40091355;
-- map concept "Azulfidine EN-tabs" to "Sulfasalazine"
update standard_combined_drug_mapping set standard_concept_id = 964339 where standard_concept_id = 40013106;
-- map concept "Valproic Acid Syrup" to "Valproate"
update standard_combined_drug_mapping set standard_concept_id = 745466 where standard_concept_id = 40086873;
-- map concept "Valproic Acid 500 MG" to "Valproate"
update standard_combined_drug_mapping set standard_concept_id = 745466 where standard_concept_id = 40086835;
-- map concept "Senna" to "standardized senna concentrate"
update standard_combined_drug_mapping set standard_concept_id = 19086491 where standard_concept_id = 40080434;
-- map concept "Vancocin HCl" to "Vancomycin"
update standard_combined_drug_mapping set standard_concept_id = 1707687 where standard_concept_id = 40086904;
-- map concept "Isopropyl Alcohol" updated to different standard concept "Isopropyl Alcohol"
update standard_combined_drug_mapping set standard_concept_id = 19028106 where standard_concept_id = 40126573;
-- map concept "Risedronate Sodium" to standard concept "Risedronate"
update standard_combined_drug_mapping set standard_concept_id = 1516800 where standard_concept_id = 40079926;
-- map concept "Allegra D" to standard concept "fexofenadine / Pseudoephedrine Extended Release Oral Tablet"
update standard_combined_drug_mapping set standard_concept_id = 40129571 where standard_concept_id = 40223264;

------------------------------------------------------
-- Map RxNorm concepts to NaPDI preferred terms where relationships exist
-- This provides additional standardization by mapping to NaPDI concepts when available

with cte1 as ( -- Find RxNorm concepts that have NaPDI mappings
    select distinct scdm.standard_concept_id
    from standard_combined_drug_mapping scdm
    inner join staging_vocabulary.concept c1 
        on scdm.standard_concept_id = c1.concept_id
    inner join staging_vocabulary.concept_relationship cr 
        on cr.concept_id_2 = scdm.standard_concept_id
    inner join staging_vocabulary.concept c2 
        on cr.concept_id_1 = c2.concept_id
    where c1.vocabulary_id in ('RxNorm','RxNorm Extension')
      and cr.relationship_id = 'napdi_np_maps_to'
      -- and c2.concept_class_id = 'NaPDI Preferred Term'  -- Focus on preferred terms
      and scdm.concept_id is not null
),
cte2 as ( -- Get the NaPDI preferred term mappings
    select cr.concept_id_2 as rxnorm_concept_id, 
           cr.concept_id_1 as napdi_concept_id
    from staging_vocabulary.concept_relationship cr
    inner join staging_vocabulary.concept c2 
        on cr.concept_id_1 = c2.concept_id
    where cr.relationship_id = 'napdi_np_maps_to'
      and c2.concept_class_id = 'NaPDI Preferred Term'
      and cr.concept_id_2 in (select standard_concept_id from cte1)
)
update standard_combined_drug_mapping scdm 
set standard_concept_id = cte2.napdi_concept_id
from cte2
where scdm.standard_concept_id = cte2.rxnorm_concept_id;

-------------------------------------------------------
-- create final table with just the standard ingredient and clinical drug form of the drugs

drop table if exists standard_case_drug;

create table standard_case_drug as
select distinct a.primaryid, a.isr, a.drug_seq, a.role_cod, a.standard_concept_id
from standard_combined_drug_mapping a
inner join staging_vocabulary.concept c
on a.standard_concept_id = c.concept_id
and (
    (c.concept_class_id in ('Ingredient','Clinical Drug Form')
     and c.standard_concept = 'S')
    or
    c.concept_class_id in ('NaPDI NP Combination Product','NaPDI NP Spelling Variation','NaPDI Preferred Term','NaPDI NP Constituent')
);

-- Create indexes for the final table
create index scd_primaryid_idx on standard_case_drug(primaryid);
create index scd_isr_idx on standard_case_drug(isr);
create index scd_standard_concept_id_idx on standard_case_drug(standard_concept_id);
create index scd_role_cod_idx on standard_case_drug(role_cod);
