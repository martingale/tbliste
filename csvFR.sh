while read line
do
    mydate=$(grep -Po "[0-9]{2}/[0-9]{2}/[12]{1}[0-9][0-9][0-9]" <<< "$line")
##  mydate=$(grep -Po '[0-9]+/[0-9]+/[0-9]+' <<< "$line") # gets 8/1/13
  if [[ ! -z "$mydate" ]]; then #in case there is date to process
     newdate=$(date -d "$mydate" "+%Y-%m-%d") # converts to 2013-08-01
     sed -i "s#$mydate#$newdate#" tbliste.csv # replaces in the text (-i option)
  fi
done < tbliste.csv
