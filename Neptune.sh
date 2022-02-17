#!/bin/bash
# Created By - Tanmay Nashte

echo `
┏━┳┓╋╋╋┏┓
┃┃┃┣━┳━┫┗┳┳┳━┳┳━┓
┃┃┃┃┻┫╋┃┏┫┃┃┃┃┃┻┫
┗┻━┻━┫┏┻━┻━┻┻━┻━┛
╋╋╋╋╋┗┛ `
echo ' Automated with <3 by TanmayN  (@Tanmayn)'

dir=$(pwd)
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
output=output
mkdir -pv "${dir}/${output}"

for url in $1; do
	 echo '---------------------------------------------'
         echo  "${red} Started SCanning... : ${green} ${url} ${reset}"
         echo '---------------------------------------------'
         echo '---------------------------------------------------------------------'
         echo  "${red} Performing : ${green} Subdomain Scanning & Resolving ${reset}"
         echo '---------------------------------------------------------------------'
  	 $dir/ownscript/ownscript2.sh $url;
	 echo '----------------------------------------------------------'
   echo '----------------------------------------------------------'
   echo  "${red} Scanning : ${green} Aquatone  SCreenshot ${reset}"
   echo '---------------------------------------------------------'
   $dir/vuln/aquatone.sh $url;
echo '---------------------------------------------------------'
         echo '----------------------------------------------------------'
         echo  "${red} Scanning : ${green} Scanning for Subdomain Takeover ${reset}"
         echo '---------------------------------------------------------'
         $dir/subtakeover/subtak.sh $url;
	 echo '---------------------------------------------------------'
	 echo '---------------------------------------------------------'
         echo  "${red} Performing : ${green} Scanning for CORS Misconfiguration ${reset}"
         echo '---------------------------------------------------------'
         $dir/vuln/cors.sh $url;
	 echo '---------------------------------------------------------'
   echo '----------------------------------------------------------'
   echo  "${red} Scanning : ${green} github recon started ${reset}"
   echo '---------------------------------------------------------'
   $dir/vuln/gitsec.sh $url;
echo '---------------------------------------------------------'
echo '---------------------------------------------------------'
         echo  "${red} Performing : ${green} Scanning for XSS Vuln ${reset}"
         echo '---------------------------------------------------------'
         $dir/vuln/xss.sh $url;
 	 echo '---------------------------------------------------------'
         echo  "${red} Performing : ${green} Scanning for ssti Vuln ${reset}"
         echo '---------------------------------------------------------'
         $dir/vuln/ssti.sh $url;
	 echo '---------------------------------------------------------'
 	 echo '---------------------------------------------------------'
         echo  "${red} Performing : ${green} Scanning Jsscanning started ${reset}"
         echo '---------------------------------------------------------'
	 $dir/vuln/jsscan.sh $url;
 	 echo '---------------------------------------------------------'
 	 echo  "${red} Performing : ${green} Scanning with Host Header Injection Vuln ${reset}"
         echo '---------------------------------------------------------'
         $dir/vuln/hostheader.sh $url;
	 echo '---------------------------------------------------------'
	 echo  "${red} Performing : ${green} Scanning with nuclei Vuln ${reset}"
         echo '---------------------------------------------------------'
         $dir/vuln/nuclear.sh $url;
	 echo '---------------------------------------------------------'
	 echo  "${red} Performing : ${green} Scanning with ffuf Vuln ${reset}"
         echo '---------------------------------------------------------'
         $dir/vuln/ffuf2.sh $url;
	 echo '---------------------------------------------------------'
 	 echo  "${red} Performing : ${green} Scanning with Cloudflare IP Vuln ${reset}"
         echo '---------------------------------------------------------'
         $dir/vuln/cfcheck.sh $url;
	 echo '---------------------------------------------------------'
	 echo '---------------------------------------------------------'
 	 echo  "${red} Performing : ${green} Discovery with AEM Vuln ${reset}"
         echo '---------------------------------------------------------'
         $dir/cve/AEMDiscovery.sh $url;
	 echo '---------------------------------------------------------'
	 echo  "${red} Performing : ${green} Smuggler Vuln ${reset}"
         echo '---------------------------------------------------------'
         sudo $dir/vuln/smuggler.sh $url;
	 echo '---------------------------------------------------------'
done

slackbot(){
	date=$(date +'%Y-%m-%d_%H-%M-%S')
	echo "Genrating .zip file for $1"
	zip -r $1_${date}.zip $1 > temp
	comment=$1
	file=$1_${date}.zip

	echo "[+] Sending results to slack..."
	curl -F file=@$file -F "initial_comment=$comment" -F channels=C01B6NJ662C -H "Authorization: Bearer <slack-token>" https://slack.com/api/files.upload &>/dev/null
	mv ${file} ${output}/
	mv $1 ${output}/

	echo -e "\n\n${BLUE}[*] File $1_${date}.Zip Sending To Slack Has Been Done..! ${RESET}"
}

slackbot $1
