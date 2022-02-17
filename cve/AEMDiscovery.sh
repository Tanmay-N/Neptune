#!/bin/sh

TARGET=$1
title=AEM
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. AEM Scanning Started '$1'"}' https://hooks.slack.com/services/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
echo "[+] Started with AEM Discovery on httprobe_${TARGET}.txt"

aem_discoverer --file ./${TARGET}/httprobe_${TARGET}.txt --workers 150 | tee -a AEM_${TARGET}.txt

mv AEM_${TARGET}.txt ./${TARGET}/${title}/

echo "[!] Done AEM"
curl -X POST -H 'Content-type: application/json' --data '{"text":"[!] 1. AEM completed '$1'"}' https://hooks.slack.com/services/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
