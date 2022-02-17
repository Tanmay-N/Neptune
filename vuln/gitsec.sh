#!/bin/sh

TARGET=$1
title=gitsec
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog
dir=$(pwd)

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. gitsec Scanning Started with custom script '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>
echo "[+] Started Scanning with gitsec"
cat ./$1/no_resolve_$1.txt | git-hound --dig-commits --dig-files | tee -a ./$1/${title}/githound_$1.txt
echo "[*] Done Scanning"
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. gitsec Scanning Completed '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>
