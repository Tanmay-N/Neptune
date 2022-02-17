#!/bin/bash

TARGET=$1
title=cfcheck
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. cf-check Started '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>
echo "[+] Started with the cf-check ..."
cat ./${TARGET}/no_resolve_${TARGET}.txt | httpx -silent | cf-check | anew | naabu -silent -verify | httpx -silent >> cfcheck_${TARGET}.txt

echo "Checking for Title..."
cat cfcheck_${TARGET}.txt | http-title >> title_${TARGET}.txt

mv cfcheck_${TARGET}.txt title_${TARGET}.txt ./${TARGET}/${title}
echo "[!] Done cf-check.."
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. cf-check Completed '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>
