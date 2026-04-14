-- validate_constraints.sql
--
-- Checks for and attempts to create/validate commonly-used OMOP constraints
-- (PKs, FKs, CHECKs) on the staging_vocabulary schema. When a constraint
-- cannot be created/validated it will show a short diagnostic query to
-- explain why the change failed (top sample violating rows + counts).
--
-- Usage: psql -h <host> -p <port> -U <user> -d <db> -f validate_constraints.sql
--
-- Notes:
-- * This script is idempotent: it checks for constraint existence before adding.
-- * For large tables we add FKs using NOT VALID and validate them; if validation
--   fails the script will show offending rows so you can correct or whitelist
--   them before re-validating.
-- * This script is intended for postgres as used by this project.

\echo '---- validate_constraints.sql: begin ----'

-- Helper: convenience query to test rows that violate a foreign key.
-- We use BEGIN/EXCEPTION blocks so script continues when a constraint can't be added.

-- 1) Primary keys
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pk_staging_vocabulary') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.vocabulary ADD CONSTRAINT pk_staging_vocabulary PRIMARY KEY (vocabulary_id);
      RAISE INFO 'Added pk_staging_vocabulary';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add pk_staging_vocabulary: %', SQLERRM;
      RAISE INFO 'Example non-unique vocabulary_id rows (showing duplicates):';
      FOR r IN (SELECT vocabulary_id, count(*) FROM staging_vocabulary.vocabulary GROUP BY vocabulary_id HAVING count(*)>1 ORDER BY count(*) DESC LIMIT 10) LOOP
        RAISE INFO '% (% rows)', r.vocabulary_id, r.count;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'pk_staging_vocabulary already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pk_staging_domain') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.domain ADD CONSTRAINT pk_staging_domain PRIMARY KEY (domain_id);
      RAISE INFO 'Added pk_staging_domain';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add pk_staging_domain: %', SQLERRM;
      RAISE INFO 'Example non-unique domain_id rows:';
      FOR r IN (SELECT domain_id, count(*) FROM staging_vocabulary.domain GROUP BY domain_id HAVING count(*)>1 LIMIT 10) LOOP
        RAISE INFO '% (% rows)', r.domain_id, r.count;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'pk_staging_domain already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pk_staging_concept_class') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept_class ADD CONSTRAINT pk_staging_concept_class PRIMARY KEY (concept_class_id);
      RAISE INFO 'Added pk_staging_concept_class';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add pk_staging_concept_class: %', SQLERRM;
      RAISE INFO 'Example non-unique concept_class_id rows:';
      FOR r IN (SELECT concept_class_id, count(*) FROM staging_vocabulary.concept_class GROUP BY concept_class_id HAVING count(*)>1 LIMIT 10) LOOP
        RAISE INFO '% (% rows)', r.concept_class_id, r.count;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'pk_staging_concept_class already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pk_staging_concept') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept ADD CONSTRAINT pk_staging_concept PRIMARY KEY (concept_id);
      RAISE INFO 'Added pk_staging_concept';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add pk_staging_concept: %', SQLERRM;
      RAISE INFO 'Example non-unique concept_id rows:';
      FOR r IN (SELECT concept_id, count(*) FROM staging_vocabulary.concept GROUP BY concept_id HAVING count(*)>1 ORDER BY count(*) DESC LIMIT 10) LOOP
        RAISE INFO '% (% rows)', r.concept_id, r.count;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'pk_staging_concept already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pk_staging_concept_relationship') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept_relationship ADD CONSTRAINT pk_staging_concept_relationship PRIMARY KEY (concept_id_1, concept_id_2, relationship_id);
      RAISE INFO 'Added pk_staging_concept_relationship';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add pk_staging_concept_relationship: %', SQLERRM;
      RAISE INFO 'Example duplicate relationship rows:';
      FOR r IN (SELECT concept_id_1, concept_id_2, relationship_id, count(*) FROM staging_vocabulary.concept_relationship GROUP BY concept_id_1, concept_id_2, relationship_id HAVING count(*)>1 LIMIT 10) LOOP
        RAISE INFO '(% , % , %) — %', r.concept_id_1, r.concept_id_2, r.relationship_id, r.count;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'pk_staging_concept_relationship already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pk_staging_concept_ancestor') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept_ancestor ADD CONSTRAINT pk_staging_concept_ancestor PRIMARY KEY (ancestor_concept_id, descendant_concept_id);
      RAISE INFO 'Added pk_staging_concept_ancestor';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add pk_staging_concept_ancestor: %', SQLERRM;
      RAISE INFO 'Example duplicate ancestor rows:';
      FOR r IN (SELECT ancestor_concept_id, descendant_concept_id, count(*) FROM staging_vocabulary.concept_ancestor GROUP BY ancestor_concept_id, descendant_concept_id HAVING count(*)>1 LIMIT 10) LOOP
        RAISE INFO '(% , %) — %', r.ancestor_concept_id, r.descendant_concept_id, r.count;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'pk_staging_concept_ancestor already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pk_staging_source_to_concept_map') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.source_to_concept_map ADD CONSTRAINT pk_staging_source_to_concept_map PRIMARY KEY (source_code, source_vocabulary_id);
      RAISE INFO 'Added pk_staging_source_to_concept_map';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add pk_staging_source_to_concept_map: %', SQLERRM;
      RAISE INFO 'Example duplicate source_code rows:';
      FOR r IN (SELECT source_code, source_vocabulary_id, count(*) FROM staging_vocabulary.source_to_concept_map GROUP BY source_code, source_vocabulary_id HAVING count(*)>1 LIMIT 10) LOOP
        RAISE INFO '(% , %) — %', r.source_code, r.source_vocabulary_id, r.count;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'pk_staging_source_to_concept_map already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pk_staging_drug_strength') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.drug_strength ADD CONSTRAINT pk_staging_drug_strength PRIMARY KEY (drug_concept_id, ingredient_concept_id);
      RAISE INFO 'Added pk_staging_drug_strength';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add pk_staging_drug_strength: %', SQLERRM;
      RAISE INFO 'Example duplicates:';
      FOR r IN (SELECT drug_concept_id, ingredient_concept_id, count(*) FROM staging_vocabulary.drug_strength GROUP BY drug_concept_id, ingredient_concept_id HAVING count(*)>1 LIMIT 10) LOOP
        RAISE INFO '(% , %) — %', r.drug_concept_id, r.ingredient_concept_id, r.count;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'pk_staging_drug_strength already exists';
  END IF;
END $$;

-- 2) Useful unique constraint: vocabulary+concept_code
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_index i JOIN pg_class c ON i.indexrelid = c.oid WHERE c.relname = 'uq_concept_vocab_code') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept ADD CONSTRAINT uq_concept_vocab_code UNIQUE (vocabulary_id, concept_code);
      RAISE INFO 'Added uq_concept_vocab_code';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add uq_concept_vocab_code: %', SQLERRM;
      RAISE INFO 'Example violating rows (vocabulary, concept_code duplicates):';
      FOR r IN (SELECT vocabulary_id, concept_code, count(*) FROM staging_vocabulary.concept GROUP BY vocabulary_id, concept_code HAVING count(*)>1 LIMIT 10) LOOP
        RAISE INFO '(% , %): % duplicates', r.vocabulary_id, r.concept_code, r.count;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'uq_concept_vocab_code already exists';
  END IF;
END $$;

-- 3) CHECK constraints
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_concept_dates') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept ADD CONSTRAINT chk_concept_dates CHECK (valid_start_date <= valid_end_date);
      RAISE INFO 'Added chk_concept_dates';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add chk_concept_dates: %', SQLERRM;
      RAISE INFO 'Example rows where valid_start_date > valid_end_date:';
      FOR r IN (SELECT concept_id, valid_start_date, valid_end_date FROM staging_vocabulary.concept WHERE valid_start_date > valid_end_date LIMIT 10) LOOP
        RAISE INFO '%: % > %', r.concept_id, r.valid_start_date, r.valid_end_date;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'chk_concept_dates already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_standard_concept') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept ADD CONSTRAINT chk_standard_concept CHECK (standard_concept IN ('S','C') OR standard_concept IS NULL);
      RAISE INFO 'Added chk_standard_concept';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add chk_standard_concept: %', SQLERRM;
      RAISE INFO 'Example rows with unexpected standard_concept:';
      FOR r IN (SELECT concept_id, standard_concept FROM staging_vocabulary.concept WHERE standard_concept NOT IN ('S','C') AND standard_concept IS NOT NULL LIMIT 10) LOOP
        RAISE INFO '%: %', r.concept_id, r.standard_concept;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'chk_standard_concept already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_invalid_reason') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept ADD CONSTRAINT chk_invalid_reason CHECK (invalid_reason IN ('D','U') OR invalid_reason IS NULL);
      RAISE INFO 'Added chk_invalid_reason';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add chk_invalid_reason: %', SQLERRM;
      RAISE INFO 'Example rows with unexpected invalid_reason:';
      FOR r IN (SELECT concept_id, invalid_reason FROM staging_vocabulary.concept WHERE invalid_reason NOT IN ('D','U') AND invalid_reason IS NOT NULL LIMIT 10) LOOP
        RAISE INFO '%: %', r.concept_id, r.invalid_reason;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'chk_invalid_reason already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_relationship_flags') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.relationship ADD CONSTRAINT chk_relationship_flags CHECK (is_hierarchical IN ('1','0','Y','N') AND defines_ancestry IN ('1','0','Y','N'));
      RAISE INFO 'Added chk_relationship_flags';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add chk_relationship_flags: %', SQLERRM;
      RAISE INFO 'Example violating relationship rows:';
      FOR r IN (SELECT relationship_id, is_hierarchical, defines_ancestry FROM staging_vocabulary.relationship WHERE is_hierarchical NOT IN ('1','0','Y','N') OR defines_ancestry NOT IN ('1','0','Y','N') LIMIT 10) LOOP
        RAISE INFO '%: is_h=% , defines=%', r.relationship_id, r.is_hierarchical, r.defines_ancestry;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'chk_relationship_flags already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_concept_code_nonempty') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept ADD CONSTRAINT chk_concept_code_nonempty CHECK (length(trim(coalesce(concept_code,''))) > 0);
      RAISE INFO 'Added chk_concept_code_nonempty';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add chk_concept_code_nonempty: %', SQLERRM;
      RAISE INFO 'Example empty concept_code rows:';
      FOR r IN (SELECT concept_id FROM staging_vocabulary.concept WHERE length(trim(coalesce(concept_code,''))) = 0 LIMIT 10) LOOP
        RAISE INFO '%', r.concept_id;
      END LOOP;
    END;
  ELSE
    RAISE INFO 'chk_concept_code_nonempty already exists';
  END IF;
END $$;

-- 4) Foreign keys (add not validated first, then validate — show violations if can't validate)
-- fk: concept.vocabulary_id -> vocabulary(vocabulary_id)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_concept_vocabulary') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept ADD CONSTRAINT fk_concept_vocabulary FOREIGN KEY (vocabulary_id) REFERENCES staging_vocabulary.vocabulary(vocabulary_id) NOT VALID;
      RAISE INFO 'Added fk_concept_vocabulary (NOT VALID)';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add fk_concept_vocabulary: %', SQLERRM;
    END;
  ELSE
    RAISE INFO 'fk_concept_vocabulary already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_concept_vocabulary' AND NOT convalidated) THEN
    BEGIN
      BEGIN
        ALTER TABLE staging_vocabulary.concept VALIDATE CONSTRAINT fk_concept_vocabulary;
        RAISE INFO 'Validated fk_concept_vocabulary';
      EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'fk_concept_vocabulary validation failed: %', SQLERRM;
        RAISE INFO 'Sample invalid child rows (vocabulary_id not found in vocabulary):';
        FOR r IN (SELECT c.* FROM staging_vocabulary.concept c LEFT JOIN staging_vocabulary.vocabulary v ON c.vocabulary_id = v.vocabulary_id WHERE v.vocabulary_id IS NULL LIMIT 10) LOOP
          RAISE INFO '%', row_to_json(r);
        END LOOP;
      END;
    END;
END $$;

-- fk: concept.domain_id -> domain(domain_id)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_concept_domain') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept ADD CONSTRAINT fk_concept_domain FOREIGN KEY (domain_id) REFERENCES staging_vocabulary.domain(domain_id) NOT VALID;
      RAISE INFO 'Added fk_concept_domain (NOT VALID)';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add fk_concept_domain: %', SQLERRM;
    END;
  ELSE
    RAISE INFO 'fk_concept_domain already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_concept_domain' AND NOT convalidated) THEN
    BEGIN
      BEGIN
        ALTER TABLE staging_vocabulary.concept VALIDATE CONSTRAINT fk_concept_domain;
        RAISE INFO 'Validated fk_concept_domain';
      EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'fk_concept_domain validation failed: %', SQLERRM;
        RAISE INFO 'Sample invalid child rows (domain_id not found in domain):';
        FOR r IN (SELECT c.* FROM staging_vocabulary.concept c LEFT JOIN staging_vocabulary.domain d ON c.domain_id = d.domain_id WHERE d.domain_id IS NULL LIMIT 10) LOOP
          RAISE INFO '%', row_to_json(r);
        END LOOP;
      END;
    END;
END $$;

-- fk concept.concept_class_id -> concept_class(concept_class_id)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_concept_class') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept ADD CONSTRAINT fk_concept_class FOREIGN KEY (concept_class_id) REFERENCES staging_vocabulary.concept_class(concept_class_id) NOT VALID;
      RAISE INFO 'Added fk_concept_class (NOT VALID)';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add fk_concept_class: %', SQLERRM;
    END;
  ELSE
    RAISE INFO 'fk_concept_class already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_concept_class' AND NOT convalidated) THEN
    BEGIN
      BEGIN
        ALTER TABLE staging_vocabulary.concept VALIDATE CONSTRAINT fk_concept_class;
        RAISE INFO 'Validated fk_concept_class';
      EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'fk_concept_class validation failed: %', SQLERRM;
        RAISE INFO 'Sample invalid child rows (concept_class_id not found in concept_class):';
        FOR r IN (SELECT c.* FROM staging_vocabulary.concept c LEFT JOIN staging_vocabulary.concept_class cc ON c.concept_class_id = cc.concept_class_id WHERE cc.concept_class_id IS NULL LIMIT 10) LOOP
          RAISE INFO '%', row_to_json(r);
        END LOOP;
      END;
    END;
END $$;

-- fk: concept_relationship concept_id_1 and concept_id_2 reference concept
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cr_concept_1') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept_relationship ADD CONSTRAINT fk_cr_concept_1 FOREIGN KEY (concept_id_1) REFERENCES staging_vocabulary.concept(concept_id) NOT VALID;
      RAISE INFO 'Added fk_cr_concept_1 (NOT VALID)';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add fk_cr_concept_1: %', SQLERRM;
    END;
  ELSE
    RAISE INFO 'fk_cr_concept_1 already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cr_concept_1' AND NOT convalidated) THEN
    BEGIN
      BEGIN
        ALTER TABLE staging_vocabulary.concept_relationship VALIDATE CONSTRAINT fk_cr_concept_1;
        RAISE INFO 'Validated fk_cr_concept_1';
      EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'fk_cr_concept_1 validation failed: %', SQLERRM;
        RAISE INFO 'Sample concept_relationship rows with missing concept_id_1:';
        FOR r IN (SELECT cr.* FROM staging_vocabulary.concept_relationship cr LEFT JOIN staging_vocabulary.concept c ON cr.concept_id_1 = c.concept_id WHERE c.concept_id IS NULL LIMIT 10) LOOP
          RAISE INFO '%', row_to_json(r);
        END LOOP;
      END;
    END;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cr_concept_2') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept_relationship ADD CONSTRAINT fk_cr_concept_2 FOREIGN KEY (concept_id_2) REFERENCES staging_vocabulary.concept(concept_id) NOT VALID;
      RAISE INFO 'Added fk_cr_concept_2 (NOT VALID)';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add fk_cr_concept_2: %', SQLERRM;
    END;
  ELSE
    RAISE INFO 'fk_cr_concept_2 already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cr_concept_2' AND NOT convalidated) THEN
    BEGIN
      BEGIN
        ALTER TABLE staging_vocabulary.concept_relationship VALIDATE CONSTRAINT fk_cr_concept_2;
        RAISE INFO 'Validated fk_cr_concept_2';
      EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'fk_cr_concept_2 validation failed: %', SQLERRM;
        RAISE INFO 'Sample concept_relationship rows with missing concept_id_2:';
        FOR r IN (SELECT cr.* FROM staging_vocabulary.concept_relationship cr LEFT JOIN staging_vocabulary.concept c ON cr.concept_id_2 = c.concept_id WHERE c.concept_id IS NULL LIMIT 10) LOOP
          RAISE INFO '%', row_to_json(r);
        END LOOP;
      END;
    END;
END $$;

-- fk: concept_synonym -> concept
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_concept_synonym_concept') THEN
    BEGIN
      ALTER TABLE staging_vocabulary.concept_synonym ADD CONSTRAINT fk_concept_synonym_concept FOREIGN KEY (concept_id) REFERENCES staging_vocabulary.concept(concept_id) NOT VALID;
      RAISE INFO 'Added fk_concept_synonym_concept (NOT VALID)';
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Could not add fk_concept_synonym_concept: %', SQLERRM;
    END;
  ELSE
    RAISE INFO 'fk_concept_synonym_concept already exists';
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_concept_synonym_concept' AND NOT convalidated) THEN
    BEGIN
      BEGIN
        ALTER TABLE staging_vocabulary.concept_synonym VALIDATE CONSTRAINT fk_concept_synonym_concept;
        RAISE INFO 'Validated fk_concept_synonym_concept';
      EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'fk_concept_synonym_concept validation failed: %', SQLERRM;
        RAISE INFO 'Sample concept_synonym rows with missing concept_id:';
        FOR r IN (SELECT s.* FROM staging_vocabulary.concept_synonym s LEFT JOIN staging_vocabulary.concept c ON s.concept_id = c.concept_id WHERE c.concept_id IS NULL LIMIT 10) LOOP
          RAISE INFO '%', row_to_json(r);
        END LOOP;
      END;
    END;
END $$;

\echo '---- validate_constraints.sql: end ----'
