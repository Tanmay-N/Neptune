#!/bin/sh

TARGET=$1
title=Secret
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog

echo -e "[Caution] Please run this thread seprately becuase it takes lot of time.."
echo "[+] Started with Secret on httprobe_${TARGET}.txt"

parallel -j 12 "secretfinder -i {} -e -o cli 2> /dev/null" :::: ./$1/httprobe_$1.txt | tee -a $1_secretfinder.txt 
cat $1_secretfinder.txt | grep 'google_api' -B 1 | sort -u > $1_gesec_gapi.txt

mv $1_secretfinder.txt $1_gesec_gapi.txt ./${TARGET}/${title}/

echo "[!] Done Secret"
