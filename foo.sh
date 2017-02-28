#!/bin/bash
        for i in $( cat dontUpdateISIN.txt); do
#	        echo $i
		var=$(cat tbliste.csv | grep -n "$i" | grep -oEi "^[0-9]{1,3}") 
		# sed -i '$(var)d;' tbliste.csv        	
if [ "$var" != "" ];then 
	echo $var
fi
	done

