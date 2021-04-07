# AEOLUS

This the EMC fork of the AEOLUS system which allows you tosStandardize the FDA LAERS database and FAERS database drugs,
indications, reactions and outcomes to OMOP Common Data Model V5 concepts and generate the unique case report counts and
safety signal statistics

Original detailed documentation is in the documentation folder.

Shortened updated docs are here:

## Requirements

- Linux or Mac. This process was developed for Ubuntu 14.04 but has since also sucessfully run on MacOS Big Sur and
  Ubuntu 18.04
- PostgreSQL version 9.3 or greater

## How To Run

### Load Reference Data

- FDA Orange book
    - Load NDA reference data file into a PostgreSQL table called “nda” to look-up ingredients by NDA number Download
      the data file from the FDA Orange book website. Run `load_nda_table.sql` to load the data file:
- Country codes
    - Run `load_country_code_table.sql` to load the reference table.
- EU drug name/active ingredient table
    - Download the most recent EU drug name/active ingredient table Load the EU drug name/active ingredient reference
      table by running the script: `load_eu_drug_name_active_ingredient.sql`
- OHDSI CDMV5 Vocabulary
    - Load the latest available OHDSI CDMV5 Vocabulary tables into a separate PostgreSQL schema (e.g. cdmv5). The
      vocabulary data files and the PostgreSQL table load scripts are available from the OHDSI Athena website On the
      Athena website vocabulary download page select the MedDRA, RxNorm, SNOMED (and if you will map to ATC also
      download ATC) vocabulary (
      review the EULA link for MedDRA).
- MedDRA / Snomed mapping
    - Create the meddra / snomed mapping table by running the script `create_meddra_snomed_mapping_table.sql`

### Load Source Data

From the load_data_files_from_website_folder:

- Run `dowload_all_and_create_files.sh`
- Run all the load_current ... .sql files
- Run all the load_legacy ... .sql files
- Run delete_deleted_records.sql

### Deduplicate and Impute

From the handle_duplicate_cases folder:

- Run derive_unique_all_case.sql

### Mapping

Use this small app https://github.com/mi-erasmusmc/aioli or refer to original docs

### Standardization and statistic generation

- Run `standardize.sh`

## Contributions

Principally contributions are very welcome. If you come across issues have suggestions for improvements send a message,
raise an issue or create a pr
