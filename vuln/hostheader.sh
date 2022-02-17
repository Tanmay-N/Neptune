#!/bin/bash

TARGET=$1
title=hostheader
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. Hostheader Started '$1'"}' https://hooks.slack.com/services/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
echo "[+] Started with the Hostheader injection..."
cat ./${TARGET}/no_resolve_${TARGET}.txt | httpx -silent | hinject | tee -a hostheader_${TARGET}.txt
mv hostheader_${TARGET}.txt ./${TARGET}/${title}
echo "[!] Done Hostheader.."
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. Hostheader Completed '$1'"}' https://hooks.slack.com/services/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
