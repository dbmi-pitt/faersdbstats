# OMOP staging_vocabulary constraints (validate_constraints.sql)

## Summary ✅
This folder contains documentation for `validate_constraints.sql` which was added to help:
- Add and validate key constraints (PKs, unique), check constraints, and foreign keys for the `staging_vocabulary` schema used by the `omop_vocab_load` Pentaho job.
- Diagnose constraint failures by printing example violating rows and counts so you can clean data before re-validating.

Script location:
- `stage_1_setup/omop_vocab_scripts/validate_constraints.sql`

Why it's useful:
- OMOP vocabulary imports are large (millions of rows); adding and validating constraints gradually preserves data correctness while avoiding long locks or full-table scans when unnecessary.
- The script uses `NOT VALID` for large foreign keys and then attempts `VALIDATE` so you can see what to fix without dropping or failing the whole load.

---

## What the script does (high-level)
1. Adds primary keys for reference tables and candidate PKs for larger tables.
2. Adds a helpful unique index on `(vocabulary_id, concept_code)` for `staging_vocabulary.concept`.
3. Adds CHECK constraints recommended by the OMOP CDM (examples: `valid_start_date <= valid_end_date`, `standard_concept` allowed values, `invalid_reason` allowed values, etc.).
4. Adds FK constraints referencing small reference tables (e.g., `vocabulary`, `domain`) with `NOT VALID` then attempts to `VALIDATE` them.
5. For FK validation failures, the script prints sample rows violating the constraint (first 10 by default) and prints counts for duplicate PK candidates.

---

## How to run (recommended)
Use the same environment variables used in your `omop_vocab_load.kjb` job. Example (bash):

```bash
export PGPASSWORD="${DATABASE_PASSWORD}"
psql -h "${DATABASE_HOST}" -p "${DATABASE_PORT}" -U "${DATABASE_USERNAME}" -d "${DATABASE_NAME}" -f stage_1_setup/omop_vocab_scripts/validate_constraints.sql
```

If you use Pentaho you can add a shell step to run the script after loads and indexes are recreated.

---

## Interpreting output
- `RAISE INFO` prints what got created/validated.
- `RAISE WARNING` prints why a step failed and is followed by diagnostic rows.
- For PK/UNIQUE failures, the script prints duplicates and counts.
- For FK failures, the script prints sample child rows with NULL/invalid parent references.

If validation fails:
- Inspect the sample rows.
- Option A: Fix the CSV or source data and re-load.
- Option B: Move violating rows into an exceptions table for later resolution:
  - Example: create `staging_vocabulary.exceptions_*` table and copy rows there.
- Re-run validation: `ALTER TABLE <table> VALIDATE CONSTRAINT <constraint_name>`.

---

## Notes & recommendations 🔧
- The script is idempotent and safe to re-run; it detects existing constraints by name.
- Large FK validations will create locking and may take a while — run validation during an off-peak window.
- If a table is extremely large (e.g., `concept`), you may prefer to:
  - Add FK with `NOT VALID` then run `VALIDATE` for each partition (if partitioned) or during low-traffic windows.
  - Use `CONCURRENT` indexing strategies (for indexes) to reduce downtime.
- The `NOT VALID` strategy reduces downtime but must be followed by `VALIDATE` to enforce the constraint long-term.

---

## Next steps (optional)
- Add `apply_constraints.sql` for a no-diagnostic apply step to run post-cleanup.
- Add a Pentaho job entry to run the validation script — you can add an SQL or shell step after `Create staging_vocabulary indexes` (use `USE DB` pattern consistent with other steps).
- Run `DataQualityDashboard` for a comprehensive set of checks after final constraints are applied.

---

## Contact/credits
This script and docs were added by the team maintaining `omop_vocab_load` as part of improving OMOP vocabulary import integrity. If you want changes to the constraints list or naming convention, file an issue or send a PR in the repo.
