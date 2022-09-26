./1 #!/bin/bash

source ../../faers_config.config
# cd ./laers/outc
# echo `pwd`
# exit;
echo '' > 1_first_2_lines_report_all_files.txt

#set and echo globstar settings for ** used
shopt -s globstar

for file in ./**/**/*.txt; do

# ./2012/Q1/DRUG12Q1.txt is 22 long
# ./2012/Q1/DRUG12Q1_with_data.txt is 32 long
# ./2012/Q3/DRUG12Q3_staged_with_lfs_only.txt is 43 long


    if [ "${#file}" -eq 22 ]; then
        echo $file is 22 long
        echo 'pwd in this loop is '`pwd`
        echo $file >> 1_first_2_lines_report_all_files.txt
        # sed '2,$ d' < $file >> 1_first_2_lines_report_all_files.txt
        #output first 2 lines to a file
        head -2 $file >> 1_first_2_lines_report_all_files.txt
        echo ' ' >> 1_first_2_lines_report_all_files.txt
        echo ' ' >> 1_first_2_lines_report_all_files.txt
    else
         echo SKIPPED $file is ${#file} long
    fi
done;
echo ' '
echo ' '
echo '*** select all then copy and paste the 1_first_2_lines_report.txt contents into libreoffice calc w/ $ delimiter (note excel is stubborn)'