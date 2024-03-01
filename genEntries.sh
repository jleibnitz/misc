#!/usr/bin/bash
gawk 'BEGIN { 
FS="|"
UAT="suedleasing-itu.com"
PU="suedleasing.com"
}
/^[^#]/ { 
		  if ($1 == "UAT") { DOMAIN=UAT }
		  if ($1 == "INT") { DOMAIN=UAT }
		  if ($1 == "DEV") { DOMAIN=UAT }
		  if ($1 == "PU")  { DOMAIN=PU  } 		
		  ENV=$1
		  APP=$2
		  USER=$3
		  HOST=$4
		  FILENAME=sprintf("%s-%s-%s-%s", APP, ENV, USER, HOST)
		  DESCRIPTION=sprintf("%s@%s", FILENAME, HOST)
		  HOSTNAME=sprintf("%s.%s",HOST,DOMAIN)
		  printf "%s|%s|%s|%s\n",DESCRIPTION,HOSTNAME,USER,FILENAME
		 }
' "${@:--}" <environment.csv >tmp.csv

tmpREG=putty-session-template.reg

IFS="|"
while read DESCRIPTION HOSTNAME USER FILENAME
do
	if [ -f "$FILENAME.reg" ]; then
		mv $FILENAME.reg $FILENAME"_01.reg"
		FILENAME=$FILENAME"_02.reg"
	else
		FILENAME=$FILENAME".reg"
	fi
	echo "$DESCRIPTION - $tmpREG - $FILENAME"
	sed -e "s/#DESCRIPTION#/$DESCRIPTION/" -e "s/#HOSTNAME#/$HOSTNAME/" -e "s/#USER#/$USER/" $tmpREG >$FILENAME
done <tmp.csv
