# Scripts for rebuilding fda domain import files from original FDA data

## What these scripts do:
   - removes trailing $ in data section of files 
     - makes...
       - *_staged_with_lfs_only.txt 
       - (ie laers/demo/2004/Q1/DEMO04Q1_staged_with_lfs_only.txt)
   - adds filename year and qtr as data to data second
     - makes...
       - *_with_data
       - (ie laers/demo/2004/Q1/DEMO04Q1_with_data.txt)
   - creates 1 import for per domain
     - domain.txt
     - (ie laers/demo/demo.txt)

# Work-flow

<input type="checkbox"> copy these to...

    ${BASE_FILE_DIR}/data_from_fda

<input type="checkbox"> cd into...

    ${BASE_FILE_DIR}/data_from_fda/laers/demo/

### Run #\_\*.sh scripts in order... 1_\*.sh then 2_*.sh etc. (where $domain is demo, drug, etc)


<input type="checkbox"> run ${BASE_FILE_DIR}/data_from_fda/laers/$domain/1_first_2_lines_report_all_files.sh

- <input type="checkbox"> view ${BASE_FILE_DIR}/data_from_fda/laers/$domain/1_first_2_lines_report_all_files.txt

<input type="checkbox"> run ${BASE_FILE_DIR}/data_from_fda/laers/$domain/2_add_columns.sh

<input type="checkbox"> run ${BASE_FILE_DIR}/data_from_fda/laers/$domain/3_prepare_domain_import_files_for_build.sh

<input type="checkbox"> run ${BASE_FILE_DIR}/data_from_fda/laers/$domain/4_build_domain_import_file.sh

- ### notes on # scripts:
  - Watch console output from scripts
  - should be able to be again and again as they build from staged files
  - These were developed one domain at a time in alphabetical order, if you want to compare shell scripts between domains compare w/ next domain not previous


## Problemblamtic files & their issues
   - DEMO18Q1_new.txt does now unzip into it's faers/demo/18/Q1 folder
   - DEMO12Q4.txt has ' rept_dt' instead of 'rept_dt' in the header


# To-do
<input type="checkbox"> Move/Add faers/demo/./4_'s quarter checker into ./3
<input type="checkbox"> Resolve above issues