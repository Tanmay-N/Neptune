#!/bin/bash
# bash ownscript2.sh <target>

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'  #no color
PURPLE='\033[1;35m'
CYAN='\033[1;36m'

trap ctrl_c INT

if [ ! -d $1 ]; then
  mkdir -p $1;
fi

function ctrl_c() {
        echo "** Trapped CTRL-C, Removing Data..."
	rm -rf *.txt
	rmdir $1
}

LOGFILE=backuplog_ownscript
now="$(date --date='+9 hour 30 minutes' '+%d/%b/%y %r')"
dir=$(pwd)
BASE_PATH=`pwd`

printE() {
    echo -e "[$now] [!] $1 " >> $LOGFILE
}

 print() {
   echo -e "[$now] [+] $1" >> $LOGFILE
}

CMD=0
check() {
  if [[ $? == 0 ]]; then
        print "[$((CMD += 1))] $1 executed successfully!"
  else
        printE "[$((CMD += 1))] $1 encountered an error!"
  fi
}

function banner(){
  curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. ownscript2 Started '$1'"}' https://hooks.slack.com/services/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
	echo "[$now] : -----> Ownscript Scanning Started for $1 ....................................." >> $LOGFILE
	echo -e "${YELLOW}[+] [$now] Ownscript Scanning Started......${NC}"
}

function 1crt(){
	echo "[$now] : 1crt function started" >> $LOGFILE
	curl -s "https://crt.sh/?q=%25.$1&output=json"| jq -r '.[].name_value' 2>/dev/null | sed 's/\*\.//g' | sort -u | grep -o "\w.*$1" > crt_$1.txt
	echo -e "[+] Crt.sh Over => $(wc -l crt_$1.txt | awk '{ print $1}')" >> $LOGFILE
	echo "[$now] : 1crt function started" >> $LOGFILE
	check "1crt"
}

function 2warchive(){
	echo "[$now] : 2warchive function started" >> $LOGFILE
	curl -s "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" | sort | sed -e 's_https*://__' -e "s/\/.*//" -e 's/:.*//' -e 's/^www\.//' |sort -u > warchive_$1.txt
	echo "[+] Web.Archive.org Over => $(wc -l warchive_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 2warchive finised" >> $LOGFILE
	check "2warchive"
}

function 3amass(){
	echo "[$now] : 3amass function started" >> $LOGFILE
        amass enum --passive -d $1 -config ./config/config.ini -o amass_$1.txt &>/dev/null
        echo -e "[+] MassScan Over => $(wc -l amass_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 3amass finised" >> $LOGFILE
	check "3amass"
}

function 4subfinder(){
	echo "[$now] : 4subfinder function started" >> $LOGFILE
	subfinder -silent -d $1 -o subfinder_$1.txt &>/dev/null
	echo "[+] Subfinder Over => $(wc -l subfinder_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 4subfinder finised" >> $LOGFILE
	check "4subfinder"
}

function 5threatcrowd(){
	echo "[$now] : 5threatcrowd function started" >> $LOGFILE
	curl -s "https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1"|jq -r '.subdomains' 2>/dev/null |grep -o "\w.*$1" > threatcrowd_$1.txt
	echo "[+] Threatcrowd.org Over => $(wc -l threatcrowd_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 5threatcrowd finised" >> $LOGFILE
	check "5threatcrowd"
}

function 6hackertarget(){
	echo "[$now] : 6hackertarget function started" >> $LOGFILE
	curl -s "https://api.hackertarget.com/hostsearch/?q=$1"|grep -o "\w.*$1"> hackertarget_$1.txt
    echo "[+] Hackertarget.com Over => $(wc -l hackertarget_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 6hackertarget finised" >> $LOGFILE
	check "6hackertarget"

}

function 7virustotal(){
	echo "[$now] : 7virustotal function started" >> $LOGFILE
		curl -s "https://www.virustotal.com/ui/domains/$1/subdomains?limit=40" | jq -r '.' 2>/dev/null | grep id | grep -o "\w.*$1" | cut -d '"' -f3 | egrep -v " " > virustotal_$1.txt
 		echo "[+] Virustotal Over => $(wc -l virustotal_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 7virustotal finised" >> $LOGFILE
	check "7virustotal"

}

function 8gau(){
	echo "[$now] : 8gau function started" >> $LOGFILE
    gau -subs $1 | cut -d / -f 3 | sort -u > gau_$1.txt
    echo "[+] gau Over => $(wc -l gau_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 8gau finised" >> $LOGFILE
	check "8gau"
}

function 9dnsbuffer(){
	echo "[$now] : 9dnsbuffer function started" >> $LOGFILE
	curl -s "https://dns.bufferover.run/dns?q=.$1" | jq -r .FDNS_A[] 2>/dev/null | cut -d ',' -f2 | grep -o "\w.*$1" | sort -u > dnsbuffer_$1.txt
	curl -s "https://dns.bufferover.run/dns?q=.$1" | jq -r .RDNS[] 2>/dev/null | cut -d ',' -f2 | grep -o "\w.*$1" | sort -u >> dnsbuffer_$1.txt
	curl -s "https://tls.bufferover.run/dns?q=.$1" | jq -r .Results 2>/dev/null | cut -d ',' -f3 |grep -o "\w.*$1"| sort -u >> dnsbuffer_$1.txt
	sort -u dnsbuffer_$1.txt -o dnsbuffer_$1.txt
	echo "[+] Dns.bufferover.run Over => $(wc -l dnsbuffer_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 9dnsbuffer finised" >> $LOGFILE
	check "9dnsbuffer"
}

function 10certspotter(){
	echo "[$now] : 10certspotter function started" >> $LOGFILE
	curl -s "https://certspotter.com/api/v0/certs?domain=$1" | jq -r '.[].dns_names[]' 2>/dev/null | grep -o "\w.*$1" | sort -u > certspotter_$1.txt
	echo "[+] Certspotter.com Over => $(wc -l certspotter_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 10certspotter finised" >> $LOGFILE
	check "10certspotter"
 }

function 11anubisdb(){
	echo "[$now] : 11anubisdb function started" >> $LOGFILE
	curl -s "https://jldc.me/anubis/subdomains/$1" | jq -r '.' 2>/dev/null | grep -o "\w.*$1" > anubisdb_$1.txt
 	echo "[+] Anubis-DB(jonlu.ca) Over => $(wc -l anubisdb_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 11anubisdb finised" >> $LOGFILE
    	check "11anubisdb"
}

function 12alienvault(){
	echo "[$now] : 12alienvault function started" >> $LOGFILE
		curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$1/passive_dns"|jq '.passive_dns[].hostname' 2>/dev/null |grep -o "\w.*$1"|sort -u > alienvault_$1.txt
 		echo "[+] Alienvault(otx) Over => $(wc -l alienvault_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 12alienvault finised" >> $LOGFILE
        check "12alienvault"
}

function 13urlscan(){
	echo "[$now] : 13urlscan function started" >> $LOGFILE
	curl -s "https://urlscan.io/api/v1/search/?q=domain:$1"|jq '.results[].page.domain' 2>/dev/null |grep -o "\w.*$1"|sort -u > urlscan_$1.txt
	echo "[+] Urlscan.io Over => $(wc -l urlscan_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 13urlscan finised" >> $LOGFILE
       check "13urlscan"
}

function 14threatminer(){
	echo "[$now] : 14threatminer function started" >> $LOGFILE
	curl -s "https://api.threatminer.org/v2/domain.php?q=$1&rt=5" | jq -r '.results[]' 2>/dev/null | grep -o "\w.*$1"|sort -u > threatminer_$1.txt
	echo "[+] Threatminer Over => $(wc -l threatminer_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 14threatminer finised" >> $LOGFILE
        check "14threatminer"
}

function 15riddler() {
    echo "[$now] : 15riddler function started" >> $LOGFILE
    curl -s "https://riddler.io/search/exportcsv?q=pld:$1" | grep -o "\w.*$1" | awk -F, '{print $6}' | sort -u > riddler_$1.txt
	echo "[+] Riddler.io Over => $(wc -l riddler_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 15riddler finised" >> $LOGFILE
        check "15riddler"
}

function 16dnsdumpster() {
	echo "[$now] : 16dnsdumpster function started" >> $LOGFILE
	cmdtoken=$(curl -ILs https://dnsdumpster.com | grep csrftoken | cut -d " " -f2 | cut -d "=" -f2 | tr -d ";")
	curl -s --header "Host:dnsdumpster.com" --referer https://dnsdumpster.com --user-agent "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:45.0) Gecko/20100101 Firefox/45.0" --data "csrfmiddlewaretoken=$cmdtoken&targetip=$1" --cookie "csrftoken=$cmdtoken; _ga=GA1.2.1737013576.1458811829; _gat=1" https://dnsdumpster.com > dnsdumpster.html
	cat dnsdumpster.html | grep "https://api.hackertarget.com/httpheaders" | grep -o "\w.*$1" | cut -d "/" -f7 | sort -u > dnsdumper_$1.txt
	rm dnsdumpster.html
	echo "[+] Dnsdumpster Over => $(wc -l dnsdumper_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 16dnsdumpster finised" >> $LOGFILE
  	check "16dnsdumpster"
}

function 17rapiddns() {
	echo "[$now] : 17rapiddns function started" >> $LOGFILE
	curl -s "https://rapiddns.io/subdomain/$1?full=1#result" | grep -oaEi "https?://[^\"\\'> ]+" | grep $1 | cut -d "/" -f3 | sort -u >rapiddns_$1.txt
	echo "[+] Rapiddns Over => $(wc -l rapiddns_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 17rapiddns finised" >> $LOGFILE
	check "17rapiddns"
}

function 18oneforall() {
	echo "[$now] : 18oneforall function started" >> $LOGFILE
	oneforall --target $1 run &>/dev/null
	cat /opt/OneForAll/results/*.txt > allonefor_$1.txt
	cat allonefor_$1.txt | grep $1 | sort -u > oneforall_$1.txt
	rm -rf allonefor_$1.txt
	echo -e "[+] oneforall Over => $(wc -l oneforall_$1.txt | awk '{ print $1}')" >> $LOGFILE
        echo "[$now] : 18oneforall finised" >> $LOGFILE
	check "18oneforall"
}

function 20abuseipdb(){
	echo "[$now] : 20abuseipdb function started" >> $LOGFILE
	curl -s https://www.abuseipdb.com/whois/$1 | grep -E '<li>.*</li>' | grep -E -v '<li><a.*</li>' | grep -E -v 'client.*Prohibited' | grep -E -v 'server.*Prohibited' | sed 's/<li>//g' | sed 's/<\/li>//g' | sed "s/$/.$1/g" >> abuseipdb_$1.txt
	echo -e "[+] Abuseipdb Over => $(wc -l abuseipdb_$1.txt | awk '{ print $1}')" >> $LOGFILE
	 echo "[$now] : 20abuseipdb finised" >> $LOGFILE
	check "20abuseipdb"
}

function 21knock() {
	echo "[$now] : 21knock function started" >> $LOGFILE
	KNOCKFILES=`echo $1 | tr '.' '_'`"*.json"
	knockpy -j $1 &>/dev/null
	KNOCKFILE=`find $BASE_PATH -name $KNOCKFILES -type f`
	cat $KNOCKFILE \
        | jq '.found.subdomain[]' 2>/dev/null \
        | sed 's/"//g' \
        | sed 's/*\.//' \
        | sort -u \
        > knockpy_$1.txt
	echo -e "[+] 21knock Over => $(wc -l knockpy_$1.txt | awk '{ print $1}')" >> $LOGFILE
	rm -rf *.json
	echo "[$now] : 21knock finised" >> $LOGFILE
	check "21knock"
}

# Saves all the data and perform httprobe
function httprobesub(){
	echo "[$now] : httprobesub function started" >> $LOGFILE
	echo -e "${YELLOW}[*] httprobe Started To Check Live Sites....${NC}"
	cat no_resolve_$1.txt | httprobe > httprobe_$1.txt
	echo -e "${YELLOW}[+] ${CYAN} Below are the Live Sites ${GREEN}"
	cat httprobe_$1.txt | cut -d "/" -f3 | sort -u | tee $1.txt
        echo "[$now] : httprobesub finised" >> $LOGFILE
     	check "httprobesub"
}

function tnotify(){
#curl -s -X POST  -H 'Content-type: application/json' --data '{"text":"Allow me to reintroduce myself!"}' https://hooks.slack.com/services/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
echo "[+] Sending results to slack ..."
comment=$1
file=$2
curl -F file=@$file -F "initial_comment=$comment" -F channels=C01AM0MKTT6 -H "Authorization: Bearer xoxb-1364485705168-1354195141362-Wxi5IgZgcmNr2ytHXhUQ8qkH" https://slack.com/api/files.upload >> $LOGFILE
}

# Display the Results of subdomain
function subsave(){
	echo "[$now] : httprobesub function started" >> $LOGFILE
	httprobesub $1
	echo -e "${NC}============================================================================"
	echo -e "${YELLOW}[+] ${BLUE}Results Are: ${NC}"
	echo -e "============================================================================"
	echo -e "${YELLOW}[*] ${NC}Detect Subdomain ${GREEN} $(wc -l no_resolve_$1.txt | awk '{ print $1}' )" "=> ${1} ${NC}"
	echo -e "${YELLOW}[+] ${NC}File Location : ${GREEN} "$(pwd)/"no_resolve_$1.txt ${NC}"
	echo -e "============================================================================"
	echo -e "${YELLOW}[*] ${NC}Detected Alive Subdomain ${GREEN}$(wc -l $1.txt | awk '{ print $1 }' )" "=> ${1} ${NC}"
	tnotify "Detect Alive Subdomain $(wc -l $1.txt | awk '{ print $1 }') => $1"
	echo -e "${YELLOW}[+] ${NC}File Location : ${GREEN}"$(pwd)/"$1.txt ${NC}"
	echo -e "============================================================================="
	echo -e "${YELLOW}[+] ${NC}Httprobe File Location : ${GREEN}"$(pwd)/"httprobe_$1.txt ${NC}"
 	echo "[$now] : httprobesub finised" >> $LOGFILE
 	check "subsave"
	echo -e "${YELLOW}[+] ${NC}Sending Notification ${GREEN} Slack Group ${NC}"
	tnotify "Detected Subdomain $(wc -l no_resolve_$1.txt | awk '{ print $1}')" no_resolve_$1.txt
	tnotify "Detect Alive Subdomain $(wc -l $1.txt | awk '{ print $1 }')" httprobe_$1.txt
}

banner $1

export LOGFILE
export now

# Expoted Function
export -f 1crt && export -f 2warchive && export -f 3amass && export -f 4subfinder && export -f 5threatcrowd && export -f 6hackertarget && export -f 7virustotal && export -f 8gau && export -f 9dnsbuffer && export -f 10certspotter && export -f 11anubisdb && export -f 12alienvault && export -f 13urlscan && export -f 14threatminer && export -f 15riddler && export -f 16dnsdumpster && export -f 17rapiddns && export -f 18oneforall && export -f 20abuseipdb && export -f 21knock && export -f check && export -f print && export -f printE

# Parallel Processing #--eta show timinings
parallel ::: 1crt 2warchive 3amass 4subfinder 5threatcrowd 6hackertarget 7virustotal 8gau 9dnsbuffer 10certspotter 11anubisdb 12alienvault 13urlscan 14threatminer 15riddler 16dnsdumpster 17rapiddns 18oneforall 20abuseipdb 21knock ::: $1

echo "[$now] : All process finised" >> $LOGFILE
check "All Process"

# 1crt $1
# 2warchive $1
# 3amass $1
# 4subfinder $1
# 5threatcrowd $1
# 6hackertarget $1
# 7virustotal $1
# 8gau $1
# 9dnsbuffer $1
#10certspotter $1
#11anubisdb $1
#12alienvault $1
#13urlscan $1
#14threatminer $1
#15riddler $1
#16dnsdumpster $1
#17rapiddns $1

# view all the data -v select all lines that do not begin with @ and //|:|,| |_|\|/
cat crt_$1.txt warchive_$1.txt amass_$1.txt subfinder_$1.txt threatcrowd_$1.txt hackertarget_$1.txt virustotal_$1.txt gau_$1.txt dnsbuffer_$1.txt certspotter_$1.txt alienvault_$1.txt urlscan_$1.txt threatminer_$1.txt riddler_$1.txt dnsdumper_$1.txt rapiddns_$1.txt anubisdb_$1.txt oneforall_$1.txt abuseipdb_$1.txt knockpy_$1.txt | sort -u| grep -v "@" | egrep -v "//|:|,| |_|\|/" | sed '/^$/d' > no_resolve_$1.txt

echo "[$now] : no_resolve_$1.txt Created Successfully" >> $LOGFILE
check "no_resolve_$1.txt Files Created"

subsave $1

cp crt_$1.txt warchive_$1.txt amass_$1.txt subfinder_$1.txt threatcrowd_$1.txt hackertarget_$1.txt virustotal_$1.txt gau_$1.txt dnsbuffer_$1.txt certspotter_$1.txt alienvault_$1.txt urlscan_$1.txt threatminer_$1.txt riddler_$1.txt dnsdumper_$1.txt rapiddns_$1.txt anubisdb_$1.txt httprobe_$1.txt $1.txt no_resolve_$1.txt oneforall_$1.txt abuseipdb_$1.txt knockpy_$1.txt ${LOGFILE} $1/

echo "[$now] : Copying cat files finised" >> $LOGFILE
check "Copy Finished"

rm -rf crt_$1.txt warchive_$1.txt amass_$1.txt subfinder_$1.txt threatcrowd_$1.txt hackertarget_$1.txt virustotal_$1.txt gau_$1.txt dnsbuffer_$1.txt certspotter_$1.txt alienvault_$1.txt urlscan_$1.txt threatminer_$1.txt riddler_$1.txt dnsdumper_$1.txt rapiddns_$1.txt anubisdb_$1.txt httprobe_$1.txt $1.txt no_resolve_$1.txt oneforall_$1.txt abuseipdb_$1.txt knockpy_$1.txt

echo "[$now] : Files Removed Finised" >> $LOGFILE
check "Files Removed"

rm -rf ${LOGFILE}
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] Ownscript Completed '$1'"}' https://hooks.slack.com/services/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
