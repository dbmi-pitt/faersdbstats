#!/bin/sh

cd deleted || exit

#Round about way to merge into a single file with check to make sure each entry is on a new line
awk 1 ./*.txt >temp.txt
tr -d '\015' <temp.txt >all_deleted_cases.txt
rm temp.txt
