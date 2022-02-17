#!/bin/bash

TARGET=$1
title=autorecon
mkdir -pv "${TARGET}/${title}"
filename=./${TARGET}/no_resolve_$1.txt

echo "[+] Started SCanning on Autorecon"
while read line; do
	autorecon $line 
done < $filename

echo "[!] Done Autorecon.."
mv results ./${TARGET}/${title}
