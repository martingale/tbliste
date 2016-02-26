#!/bin/bash
cd /home/c1/bondProject/tbliste
wget --tries=2 --timeout=5 -N -o wgetOut http://www.borsaistanbul.com/datum/tbliste.zip
cfirst="$(echo $?)"
csecond="$(echo $(grep -c 'Server file no newer' wgetOut))"
 echo $cfirst $csecond
if [ $csecond -eq 0 ] && [ $cfirst -eq 0 ]; then
	unzip -o tbliste.zip -d ./
       ##  recentMd5=$(echo $(md5sum tbliste.xls) | grep -oEi '[[:alnum:]]{32}')
	sleep 0
	in2csv -f xls tbliste.xls > tbliste.csv
	sed -i 's/[^,]*,//' tbliste.csv	# delete 1st column.
	sed -i '1d;4d' tbliste.csv # delete 1st and 4th rows.
        cat tbliste.csv | egrep -i "^[A-Z0-9]{12,},,.*$" > tbliste.tmp 
	# remove ayristirilabilir kupon things.
	mv ./tbliste.tmp ./tbliste.csv 
	echo "tbliste.csv updated"
	git add . --all
	git commit -m "Version $(date)"
	git push 
	echo $(date) $':\tThe file is updated in local folder and written to github repo martingale/tbliste' >> log.out
else
	echo $(date) $':\tNo new tbliste.zip file' >> log.out
fi


# read -r -d '' lastMd5 < <(cat lastMd5.txt)

# if [ $lastMd5 != $recentMd5 ]; then
#                echo expression evaluated as false
#             else
#                echo expression evaluated as true
#            fi
# xls2csv -x -s cp1254 -d utf-8  "tbliste.xls" > tb.csv

# read -r -d '' wgetOut < <(cat wgetOut)
