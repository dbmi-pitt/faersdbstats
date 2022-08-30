# faersdbstats
Standardize FDA LAERS database and FAERS database drugs, indications, reactions and outcomes to OMOP Common Data Model V5 concepts
and generate the unique case report counts and safety signal statistics 

### Dependencies:
* Postgres 9.1+ (create table if not exists)
* Pentaho Spoon (built w/ 8.4 then 9.2)
* AWS s3 bucket and credentials

[See our github repository's wiki for more information](../../wiki)
[Stage 1 Wiki](./Stage-1-Setup-Reference-and-Mapping-Data)
[Stage 2 Wiki](./Stage-2-Initial-Data)
[Wiki](https://github.com/dbmi-pitt/faersdbstats/wiki)