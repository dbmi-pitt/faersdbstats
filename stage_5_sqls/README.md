## [Stage 4 Domain Logging Wiki](../../../wiki/Stage-4-Domain-Logging)

## [Stage 5 Derive SQLs Wiki](../../../wiki/Stage-5-Derive-SQLs)

## [Stage 6 SQLs Log Derived Counts Wiki](../../../wiki/Stage-6-SQL-Log-Derived-Results)

##Todo:

fix this...
```
drop table if exists standard_drug_outcome_count
create table standard_drug_outcome_count as
select drug_concept_id,
    outcome_concept_id,
    count(*) as drug_outcome_pair_count,
    cast(null as integer) as snomed_outcome_concept_id
from (
        select 'PRIMARYID' || a.primaryid as case_key,
            a.standard_concept_id as drug_concept_id,
            b.outcome_concept_id,
            cast(null as integer) as snomed_outcome_concept_id
        from standard_case_drug a
            inner join standard_case_outcome b on a.primaryid = b.primaryid
            and a.isr is null
            and b.isr is null
        union
        select 'ISR' || a.isr as case_key,
            a.standard_concept_id as drug_concept_id,
            b.outcome_concept_id,
            cast(null as integer) as snomed_outcome_concept_id
        from standard_case_drug a
            inner join standard_case_outcome b on a.isr = b.isr
            and a.isr is not null
            and b.isr is not null
    ) aa
group by drug_concept_id,
    outcome_concept_id;
```

this ^^^ is not working
- `standard_case_drug` table has data but not all fields have isr (field) data ? 
    `standard_case_outcome` has data
    --


--from stage_5 ... 
```
standardize_combined_drug_mapping.sql
create table standard_case_drug as
    select distinct a.primaryid, a.isr, a.drug_seq, a.role_cod, a.standard_concept_id
        from standard_combined_drug_mapping a
    inner join staging_vocabulary.concept c
        on a.standard_concept_id = c.concept_id
            and c.concept_class_id in ('Ingredient','Clinical Drug Form')
            and c.standard_concept = S';
```

see /troubleshoot_scripts/stage_5_sqls_derive_standard_drug_outcome_contingency_table.ktr
see /troubleshoot_scripts/stage_5_sqls_derive_standard_drug_outcomes.ktr
