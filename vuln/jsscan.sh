#!/bin/bash
#Run this as sudo

TARGET=$1
js=js
title=jslinks
token=token
endpoint=endpoints
mkdir -pv "${TARGET}/${js}"
mkdir -pv "${TARGET}/${js}/${title}"
mkdir -pv "${TARGET}/${js}/${token}"
mkdir -pv "${TARGET}/${js}/${endpoint}"
LOGFILE=backuplog

trap ctrl_c INT

function ctrl_c() {
        echo "** Trapped CTRL-C, Removing Data..."
	mv endpoints/* ./${TARGET}/js/jslinks/endpoints/
	exit
}

curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. JS SCanning Started '$1'"}' https://hooks.slack.com/services/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
   echo -e $red"[+]"$end $bold"Get JS"$end

    cat ./$1/httprobe_$1.txt | subjs >> ./$1/${js}/jslinks/all_jslinks.txt

    echo -e $red"[+]"$end $bold"Get Tokens"$end

    cat ./$1/xss/urls_$1.txt | sort -u | grep -P "\w+\.js(\?|$)" | sort -u > ./$1/${js}/jslinks/jsurls.txt

 cat  ./$1/httprobe_$1.txt ./$1/${js}/jslinks/jsurls.txt ./$1/${js}/jslinks/all_jslinks.txt > ./$1/${js}/jslinks/all_js_urls.txt
    sort -u ./$1/${js}/jslinks/all_js_urls.txt -o ./$1/${js}/jslinks/all_js_urls.txt
    cat ./$1/${js}/jslinks/all_js_urls.txt | zile --request >> ./$1/${js}/jslinks/all_tokens.txt
    sort -u ./$1/${js}/jslinks/all_tokens.txt -o ./$1/${js}/jslinks/all_tokens.txt

    echo -e $red"[+]"$end $bold"Get Endpoints"$end
	mkdir endpoints

    for link in $(cat ./$1/js/jslinks/all_jslinks.txt); do
        links_file=$(echo $link | sed -E 's/[\.|\/|:]+/_/g').txt
    linkfinder -i $link -o cli >> endpoints/$links_file
    done

mv endpoints ./$1/${js}/jslinks/
curl -X POST -H 'Content-type: application/json' --data '{"text":"[+] 1. JS SCanning Completed '$1'"}' https://hooks.slack.com/services/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
