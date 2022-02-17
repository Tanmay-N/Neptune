#!/bin/bash

TARGET=$1
title=smuggler
mkdir -pv "${TARGET}/${title}"
dir="${TARGET}/${title}"
LOGFILE=backuplog

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. Smuggling Started '$1'"}' https://hooks.slack.com/services/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
# echo https://$1 | python3 /root/Tools/smuggler/smuggler.py > $dir/$1_smuggler
cat ./$1/no_resolve_$1.txt | httprobe --prefer-https | smuggler | tee $dir/$1_smuggler

echo "Also Do manual testing via this command: 'python3 ~/tools/Smuggler/smuggler.py'"
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. Smuggling Scanning Completed '$1'"}' https://hooks.slack.com/services/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
