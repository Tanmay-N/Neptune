#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

DIR=$(pwd)
mkdir -p $PWD/tools

echo -ne $GREEN"[+] "$ENDCOLOR; echo "Installing feroxbuster"
 wget https://github.com/epi052/feroxbuster/releases/download/v1.5.2/x86_64-linux-feroxbuster.zip -P ~/opt/feroxbuster
 unzip ~/opt/x86_64-linux-feroxbuster.zip -d ~/go/bin/
 chmod 777 ~/go/bin/feroxbuster
echo "done "
echo " "
echo " "
echo "[+] check for githound config......"

apt install scrot
