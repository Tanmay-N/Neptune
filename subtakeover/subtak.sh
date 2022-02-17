#!/bin/bash

TARGET=$1
#DIR="/home/kali/go"
BASE_PATH=`pwd`

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'  #no color
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
KNOCKFILES=`echo ${TARGET} | tr '.' '_'`"*.json"
title=subtak
mkdir -pv "${TARGET}/${title}" &>/dev/null

trap ctrl_c INT

if [ ! -d ${TARGET} ]; then
  mkdir -p ${TARGET}
fi

function ctrl_c() {
        echo "** Trapped CTRL-C, Removing Data..."
	rm -rf *.txt
	rmdir ${TARGET}
}

LOGFILE=backuplog
now="$(date --date='+9 hour 30 minutes' '+%d/%b/%y %r')"

function banner() {
	echo "[$now] : [*] Takeover Started for ${TARGET} " >> $LOGFILE
	echo -e "${YELLOW}[+] [$now] Takeover Scanning Started......${NC}"
	echo "[+] sub $(cat ./${TARGET}/no_resolve_${TARGET}.txt | wc -l)" >> $LOGFILE
	echo "----------------------------------------------------------------------"
}

function tkosubs(){
  curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. Subdomain Takeover Started '$1'"}' https://hooks.slack.com/services/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
     echo -e "${YELLOW}[+] [$now] Running tko-subs against ${TARGET}"
     echo -e "${YELLOW}[+] [$now] Directory: ./${TARGET}/no_resolve_${TARGET}.txt ${NC}" >> $LOGFILE
     tko-subs -domains=./${TARGET}/no_resolve_${TARGET}.txt -data=./config/providers-data.csv -output=out.csv >> $LOGFILE
     notify "tko-subs takeover: ${TARGET}" out.csv
     echo -e "${YELLOW}[+] [$now] tkosubs has finished with ${TARGET} ${NC}"
     echo "Subjack started....."
     subjack -w ./${TARGET}/no_resolve_${TARGET}.txt -t 100 -timeout 30 -ssl -c ~/go/src/github.com/manasmbellani/subjack/fingerprints.json -v 3 | tee subjack_ssl_${TARGET}.txt >> $LOGFILE
    subjack -w ./${TARGET}/no_resolve_${TARGET}.txt -t 100 -timeout 30 -ssl -c ~/go/src/github.com/haccer/subjack/fingerprints.json -v 3 | tee subjack_no_${TARGET}.txt >> $LOGFILE
     cat subjack_ssl_${TARGET}.txt | grep -v 'Not Vulnerable' >> subjackfound_${TARGET}.txt
     cat subjack_no_${TARGET}.txt | grep -v 'Not Vulnerable' >> subjackfound_${TARGET}.txt
	echo "Subjack scanning completed" >> $LOGFILE

	echo "Started With Knock.Py"
	knockpy -j ${TARGET} >> $LOGFILE
	KNOCKFILE=`find $BASE_PATH -name $KNOCKFILES -type f`
	cat $KNOCKFILE \
        | jq '.found.subdomain[]' 2>/dev/null \
        | sed 's/"//g' \
        | sed 's/*\.//' \
        | sort -u \
        > hosts-knockpy.tmp
	COUNT_KNOCKPY=`cat hosts-knockpy.tmp | wc -l`
	cat $KNOCKFILE > knock_$1.json
	echo "[+] KnockPY: $COUNT_KNOCKPY" | tee -a $LOGFILE
	echo "Scanning  Knockpy completed.."

  	notify "subjack all subs takeover: ${TARGET}" subjack_${TARGET}.txt
	notify "subjack Found takeover: ${TARGET}" subjackfound_${TARGET}.txt
	notify "knockpy: ${TARGET}" $KNOCKFILE
	mv subjack_no_${TARGET}.txt subjack_ssl_${TARGET}.txt hosts-knockpy.tmp $KNOCKFILES out.csv subjackfound_${TARGET}.txt knock_${TARGET}.json ./${TARGET}/${title}/
  curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. Subdomain takeover completed '$1'"}' https://hooks.slack.com/services/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
}

function notify(){
#curl -s -X POST  -H 'Content-type: application/json' --data '{"text":"Allow me to reintroduce myself!"}' https://hooks.slack.com/services/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
echo "[+] Sending results to slack ..."
comment=$1
file=$2
curl -F file=@$file -F "initial_comment=$comment" -F channels=C019XGG6A0M -H "Authorization: Bearer xoxb-1364485705168-1354195141362-Wxi5IgZgcmNr2ytHXhUQ8qkH" https://slack.com/api/files.upload &>/dev/null

}

banner $1
tkosubs $1
