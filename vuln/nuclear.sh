#!/bin/bash

TARGET=$1
title=nuclei
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'  #no color
PURPLE='\033[1;35m'
CYAN='\033[1;36m'

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. Nuclie SCanning Started '$1'"}' https://hooks.slack.com/services/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
# nuclei -c 200 -t -silent
echo -e "${GREEN}[+] ${YELLOW}Started With Nuclei SCanning..."
cat ./${TARGET}/no_resolve_$1.txt | httpx -silent | sort -u | nuclei -t ~/nuclei/nuclei-templates/cves -t ~/nuclei/nuclei-templates/default-credentials -t ~/nuclei/nuclei-templates/dns -t ~/nuclei/nuclei-templates/files -t ~/nuclei/nuclei-templates/fuzzing  -t ~/nuclei/nuclei-templates/generic-detections -t ~/nuclei/nuclei-templates/panels -t ~/nuclei/nuclei-templates/payloads -t ~/nuclei/nuclei-templates/security-misconfiguration  -t ~/nuclei/nuclei-templates/subdomain-takeover -t ~/nuclei/nuclei-templates/technologies -t ~/nuclei/nuclei-templates/tokens -t ~/nuclei/nuclei-templates/vulnerabilities -t ~/nuclei/nuclei-templates/workflows -o ./${TARGET}/${title}/nuclei1.txt

echo -e "${GREEN}[+] ${YELLOW}Started With Nuclei Second Phase SCanning."
cat ./${TARGET}/no_resolve_$1.txt | httpx -silent | xargs -n 1 gospider -o output -s ; cat output/* | egrep -o 'https?://[^ ]+' | nuclei -t ~/nuclei/nuclei-templates/ -o ./${TARGET}/${title}/nuclei2.txt

echo -e "${GREEN}[!] ${YELLOW} Done With Nuclei Scan..."

echo "${GREEN}[+] ${YELLOW} Started with Jaeles Scan.."

cat ./${TARGET}/httprobe_$1.txt | xargs -I % sh -c 'sudo /bin/jaeles -c 200 scan -s /tmp/jaeles-signatures -u % -o ./'$1'/Jaeles/'
echo -e "${GREEN}[!] ${YELLOW} Done with Jaeles Scanning"

cat ./$1/no_resolve_$1.txt | httpx -silent | anew | /bin/jaeles -c 100 scan -s /tmp/jaeles-signatures/
echo -e "${GREEN}[!] ${YELLOW} Done with Jaeles Scanning"

echo -e "${GREEN}[+] ${YELLOW}git file check started.."
cat ./$1/httprobe_$1.txt | sed 's#$#/.git/HEAD#g' | httpx -silent -content-length -status-code 301,302 -timeout 3 -retries 0 -ports 80,8080,443 -threads 500 -title | anew > ./${TARGET}/${title}/git_$1.txt
echo -e "${GREEN}[!] ${YELLOW} Done git file checker..."
