#!/bin/bash


wget --tries 2 -N -o wgetOut 'http://www.borsaistanbul.com/datum/tbliste.zip'
cfirst="$(echo $?)"
csecond="$(echo $(grep -c 'Server file no newer' wgetOut))"
# echo $cfirst $csecond
if [[ "$cfisrt" == "0" && "$csecond" == "0" ]]; then
	unzip tbliste.zip -d ./
##  recentMd5=$(echo $(md5sum tbliste.xls) | grep -oEi '[[:alnum:]]{32}')
	in2csv -f xls tbliste.xls > tbliste.csv
	echo "tbliste.csv updated"
	git add . --all
	git commit -m "Version $(date)"
	git push 
else
	echo "No new tbliste.zip file"
fi
# read -r -d '' lastMd5 < <(cat lastMd5.txt)

# if [ $lastMd5 != $recentMd5 ]; then
#                echo expression evaluated as false
#             else
#                echo expression evaluated as true
#            fi
# xls2csv -x -s cp1254 -d utf-8  "tbliste.xls" > tb.csv

# read -r -d '' wgetOut < <(cat wgetOut)
