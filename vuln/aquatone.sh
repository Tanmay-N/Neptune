#!/bin/bash
TARGET=$1
title=ssti
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog


    echo -e $red"[+]"$end $bold"Taking Screenshots of "$end

    cat ./$1/httprobe_$1.txt | aquatone -silent --ports xlarge -out ./$1/aquatone/ -scan-timeout 500 -screenshot-timeout 50000 -http-timeout 6000

echo "[!] Done ..."

