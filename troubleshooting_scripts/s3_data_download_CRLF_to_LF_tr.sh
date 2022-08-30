#!/bin/bash

#set and echo globstar settings for ** used
shopt -s globstar 

cd faers

data_from_s3_root_above_laers_faers=`pwd`;
headempty=0

for laers_faers in faers; do
    laers_faers=faers
    for domain in demo drug; do
        echo 'domain is '$domain;
        cd $domain
        echo pwd is `pwd`
            for file in ./**/*_staged_with_lfs_only.txt; do
                echo 'about to rm '"$file"
                rm $file
            done;
                    for name in ./**/*.txt; do
            # thefilename=${name:0:-4};
            echo 'the name of txt file found is '$name
            thefilename=${name: 10}
            thefilenamebase=${name:10:8}
            year='$'${name: 4:2}
            qtr='$'${name: 8:1}
            thefilenamedata='$'"${thefilename}""$qtr""$year"
            #delete last runs
            echo `ls`


            if [[ "${#thefilename}" -gt 11 ]]; then
                echo 'thefilename is long ENOUGHHHHHHHHHHHHHH'
                echo 'thefilename is '$thefilename;
                echo 'thefilenamedata is '$thefilenamedata;


                echo '################################# name10:2 is '${name:10:2};
                #remove CRLF and build out something like DE_lf.txt for staging purposes to avoid aws cli sync redownloading data files
                tr -d '\015' <$name >"${name::-4}"_staged_with_lfs_only.txt
                # tr -d '\015' <$name >"${thefilename:0:2}"_lf.txt
                # sed "s|$|\$newcolumn|g" "${thefilename:10:2}"_lf.txt > "$domain"_final.txt
                sed -i "s|$|$thefilenamedata|g" "${name::-4}"_staged_with_lfs_only.txt


                if [ $headempty = 0 ]; then
                    echo 'head is empty'
                    #build out header (1st line of txt file)
                    header="$(head -1 --quiet ${name})"
                    #remove \r
                    header="${header%%[[:cntrl:]]}"
                    #append column header $filename
                    header+=\$filename
                    #add year and quarter
                    header+=\$yr\$qtr                        
                    
                    #init/touch/make the domain.txt / demo.txt w/ just a header line
                    echo $header > ${domain}.txt                            
                    echo "${domain}.txt" is the domain.txt

                    # echo '#################################thefilename0:2 is '${thefilename:0:2};
                    # echo '################################# name10:2 is '${name:10:2};
                    # #remove CRLF and build out something like DE_lf.txt for staging purposes to avoid aws cli sync redownloading data files
                    # tr -d '\015' <$name >"$name"_staged_with_lfs_only.txt
                    # # tr -d '\015' <$name >"${thefilename:0:2}"_lf.txt
                    # # sed "s|$|\$newcolumn|g" "${thefilename:10:2}"_lf.txt > "$domain"_final.txt
                    # sed -i "s|$|\$newcolumn|g" "$name"_staged_with_lfs_only.txt
                    # sed -i "s|$|\$newcolumn|g" "${thefilename:0:2}"_lf.txt

                    #replace first occurence of $thefilenamedata
                    # sed -i "0,/$thefilenamedata/{s/$thefilenamedata//}" $name

                    headempty=1 &&
                    #tail outputs last -n+2 lines of a file (shows all lines of report from the second line onwards) # --quiet does not output the filename                    
                    # tail -n +2 --quiet $name >> $domain.txt
                    tail -n +2 --quiet "${name::-4}"_staged_with_lfs_only.txt >> $domain.txt

                    #replace first occurence of $thefilenamedata
                    # sed -i "0,/$thefilenamedata/{s/$thefilenamedata//}" $domain.txt
                else
                    echo 'head is not empty'
                    #tail outputs last -n+2 lines of a file (shows all lines of report from the second line onwards) # --quiet does not output the filename
                    #output starting at line #2
                    
                    # tail -n +2 --quiet $name >> $domain.txt
                    # tail -n +2 --quiet $name >> "${name::-4}"_staged_with_lfs_only.txt
                    tail -n +2 --quiet "${name::-4}"_staged_with_lfs_only.txt >> $domain.txt
                    
                fi #end if [ $headempty = 0 ]; then
            else
                echo 'name is short '$name
                fi #end if [[ "${#thefilename}" -gt 7 ]]; then 

            # cd $data_from_s3_root_above_laers_faers/$laers_faers/$domain
            done; #end .txt file loop
            # move up to level above $domain so we can cd into next domain
            headempty=0
        cd ..
        done; #end domain loop
        cd $data_from_s3_root_above_laers_faers
    done; #end laers faers; do