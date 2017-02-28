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
	ssconvert -O 'separator=; locale=en_US.UTF-8' tbliste.xls tbliste.txt
	mv tbliste.txt  tbliste.csv
#	libreoffice --headless --convert-to csv --outdir . *.xls
#	in2csv -f xls tbliste.xls > tbliste.csv
	sed -i 's/[^;]*;//' tbliste.csv	# delete 1st column.
	sed -i '1d;4d' tbliste.csv # delete 1st and 4th rows.
        sed -i '/^;;;/d' ./tbliste.csv # delete the empty csv lines ";;;;"
#        cat tbliste.csv | egrep -i "^[A-Z0-9]{12,},,.*$" > tbliste.tmp 
	# remove ayristirilabilir kupon things.
#	mv ./tbliste.tmp ./tbliste.csv
	sed -i 's/"//g' tbliste.csv

	for i in `seq 1 10`;
        do
                sed -ri 's/([0-9][0-9][0-9][0-9])\/([0-9][0-9])\/([0-9][0-9])(.*)$/\3\.\2\.\1\4/g' tbliste.csv
        done   
	 grep  -E "[A-Z 0-9]{11}|^ISIN[[:space:]]+[CK]od" tbliste.csv > temp.csv # remove the lines occuring after excel alt+Enter oddies
         mv temp.csv tbliste.csv
# Remove the exceptional ISINs so that they shall not be updated
	for i in $( cat dontUpdateISIN.txt); do
                var=$(cat tbliste.csv | grep -n "$i" | grep -oEi "^[0-9]{1,3}")
		if [ "$var" != "" ];then
			sed -i '$(var)d;' tbliste.csv	
		fi
        done
# End of remove the exceptional ##
	iconv tbliste.csv -f UTF-8 -t WINDOWS-1254//TRANSLIT -o tbliste_WIN1254.csv # finally, convert the encosing 
	echo "tbliste.csv updated"
	cut -d ";" -f 1-29 < tbliste_WIN1254.csv > foo.csv &&  mv foo.csv tbliste_WIN1254.csv # remove the columns after 29th column (@ 2017-02-28)
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
