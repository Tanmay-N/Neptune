#!/bin/bash

TARGET=$1
title=cors
mkdir -pv "${TARGET}/${title}" &>/dev/null
LOGFILE=backuplog

function ctrl_c() {
        echo "** Trapped CTRL-C, Removing Data..."
	rm -rf *.txt
	rmdir $1
}

BK=$(tput setaf 0) # Black
RD=$(tput setaf 1) # Red
GR=$(tput setaf 2) # Green
YW=$(tput setaf 3) # Yellow
BG=$(tput setab 4) # Background Color
PP=$(tput setaf 5) # purple
CY=$(tput setaf 6) # Cyan
WH=$(tput setaf 7) # White
NT=$(tput sgr0) # Netral
BD=$(tput bold) # Bold
AB=$(tput setaf 8) # abuabu

#echo -e "${NT}[${RD}!${NT}]${GR} Start On target ${NT} ./${TARGET}/no_resolve_$1.txt"
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. CORS Scanning Started '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>
if [[ -d ${TARGET} ]]; then
	echo -e "${NT}[${RD}!${NT}] ${CY} CORS SCANNING - ${GR} Started on target ./${TARGET}/no_resolve_${TARGET}.txt ${NT}" | tee -a ${LOGFILE}
	if [ -f ./${TARGET}/no_resolve_$1.txt ];then
		cat ./${TARGET}/no_resolve_$1.txt | httpx -silent | CORS-Scanner >> cors_${TARGET}.txt
		mv cors_${TARGET}.txt ./${TARGET}/cors
		echo -e "${NT}[${RD}!${NT}]${GR} File Created with ./${TARGET}/cors_${TARGET}.txt" | tee -a ${LOGFILE}
		echo -e "${NT}[${RD}+${NT}]${GR} Done..."
        fi
else
     echo "${TARGET} Not found..." | tee -a ${LOGFILE}
fi
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. CORS SCanning Completed '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>
