#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

DIR=$(pwd)
mkdir -p $PWD/tools

AMASS_VERSION=3.8.2

if [ $(id -u) -ne 0 ]; then
        echo "This script must be ran as root"
        exit 1
fi

echo "${RED} ######################################################### ${RESET}"
echo "${RED} #                 TOOLS FOR BUG BOUNTY                  # ${RESET}"
echo "${RED} ######################################################### ${RESET}"

logo(){
echo "${BLUE}
 __  __        __         __                
|  |/  |.----.|__|.-----.|  |--.-----.---.-.
|     < |   _||  ||__ --||     |     |  _  |
|__|\__||__|  |__||_____||__|__|__|__|___._|
'
${RESET}"
}
logo

echo "${GREEN} [+] Updating and installing dependencies ${RESET}"
echo ""

 apt-get -y update
 apt-get -y upgrade

 add-apt-repository -y ppa:apt/stable < /dev/null
 echo debconf apt/maxdownloads string 16 | debconf-set-selections
 echo debconf apt/dlflag boolean true | debconf-set-selections
 echo debconf apt/aptmanager string apt-get | debconf-set-selections
 apt install -y apt

 apt install -y apt-transport-https
 apt install -y libcurl4-openssl-dev
 apt install -y libssl-dev
 apt install -y jq
 apt install -y ruby-full
 apt install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
 apt install -y build-essential libssl-dev libffi-dev python-dev
 apt install -y python-setuptools
 apt install -y libldns-dev
 apt install -y python3-pip
 apt install -y python-dnspython
 apt install -y git
 apt install -y npm
 apt install -y nmap phantomjs 
 apt install -y gem
 apt install -y perl 
 apt install -y parallel
 apt install -y curl
pip3 install jsbeautifier
echo ""
echo ""
sar 1 1 >/dev/null

#Setting shell functions/aliases
#curl command not found 
#knockpy not working
echo "${GREEN} [+] Setting bash_profile aliases ${RESET}"
curl https://raw.githubusercontent.com/unethicalnoob/aliases/master/bashprofile > ~/.bash_profile
echo "${BLUE} If it doesn't work, set it manually ${RESET}"
echo ""
echo ""
sar 1 1 >/dev/null 

echo "${GREEN} [+] Installing Golang ${RESET}"
if [ ! -f /usr/bin/go ];then
    cd ~
    wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash
	export GOROOT=$HOME/.go
	export PATH=$GOROOT/bin:$PATH
	export GOPATH=$HOME/go
    echo 'export GOROOT=$HOME/.go' >> ~/.bash_profile
	
	echo 'export GOPATH=$HOME/go'	>> ~/.bash_profile			
	echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile
    source ~/.bash_profile 
else 
    echo "${BLUE} Golang is already installed${RESET}"
fi
    break
echo""
echo "${BLUE} Done Install Golang ${RESET}"
echo ""
echo ""
sar 1 1 >/dev/null

#Installing tools

echo "${RED} #################### ${RESET}"
echo "${RED} # Installing tools # ${RESET}"
echo "${RED} #################### ${RESET}"


echo "${GREEN} #### Basic Tools #### ${RESET}"

echo "${BLUE} Smuggler${RESET}"
git clone https://github.com/defparam/smuggler.git /opt/smuggler
cd /opt/smuggler && chmod +x smuggler
echo '#!/bin/bash' > /usr/bin/smuggler
echo 'python3 /opt/smuggler/smuggler.py "$@"' >> /usr/bin/smuggler
 chmod +x /usr/bin/smuggler
echo "${BLUE} done${RESET}"
echo ""

#install altdns
echo "${BLUE} installing altdns ${RESET}"
 pip3 install py-altdns
echo "${BLUE} done${RESET}"
echo ""

#KXSS XSS finding Tool
echo "${BLUE} installing KXSS${RESET}"
go get -u github.com/Emoe/kxss
 cp ~/go/bin/kxss /bin/
echo "${BLUE} done${RESET}"
echo ""

#KXSS XSS finding Tool
echo "${BLUE} installing Hinject${RESET}"
go get -u github.com/dwisiswant0/hinject
 cp ~/go/bin/hinject /bin/
echo "${BLUE} done${RESET}"
echo ""

#install nmap
echo "${BLUE} installing nmap${RESET}"
 apt install -y nmap
echo "${BLUE} done${RESET}"
echo ""

#Knock.py - not installed 
echo "${BLUE} downloading knockpy${RESET}"
git clone https://github.com/guelfoweb/knock.git /opt/knockpy
cd /opt/knockpy
 python setup.py install
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} downloading asnlookup${RESET}"
git clone https://github.com/yassineaboukir/asnlookup.git /opt/asnlookup
cd /opt/asnlookup
 pip3 install -r requirements.txt
echo '#!/bin/bash' > /usr/bin/asnlookup
echo 'python3 /opt/asnlookup/asnlookup.py "$@"' >> /usr/bin/asnlookup
chmod +x /usr/bin/asnlookup
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing metabigor${RESET}"
go get -u github.com/j3ssie/metabigor
 cp ~/go/bin/metabigor /bin/
echo "${BLUE} done${RESET}"

echo "--------------------------------------------------"
echo "${GREEN}#### Installing fuzzing tools ####${RESET}"
echo "---------------------------------------------------"

#install gobuster
echo "${BLUE} installing gobuster${RESET}"
 go get -u github.com/OJ/gobuster
 cp ~/go/bin/gobuster /bin/
echo "${BLUE} done${RESET}"
echo ""

#install ffuf
echo "${BLUE} installing ffuf${RESET}"
go get -u github.com/ffuf/ffuf
 cp ~/go/bin/ffuf /bin/
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing dirsearch${RESET}"
git clone https://github.com/maurosoria/dirsearch.git /opt/dirsearch
echo '#!/bin/bash' > /usr/bin/dirsearch
echo 'python3 /opt/dirsearch/dirsearch.py "$@"' >> /usr/bin/dirsearch
chmod +x /usr/bin/dirsearch
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing Oneforall${RESET}"
git clone https://gitee.com/shmilylty/OneForAll.git /opt/OneForAll
cd /opt/OneForAll/
python3 -m pip install -U pip setuptools wheel -i https://mirrors.aliyun.com/pypi/simple/
pip3 install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
echo '#!/bin/bash' > /usr/bin/oneforall
echo 'python3 /opt/OneForAll/oneforall.py "$@"' >> /usr/bin/oneforall
chmod +x /usr/bin/oneforall
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing wfuzz${RESET}"
 apt install wfuzz
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null

echo "${GREEN}#### Installing Domain Enum Tools ####${RESET}"

#install aquatone
echo "${BLUE} Installing Aquatone ${RESET}"
go get -u github.com/michenriksen/aquatone
 cp ~/go/bin/aquatone /bin/
echo "${BLUE} done ${RESET}"
echo ""

echo "${BLUE} Installing tko-subs ${RESET}"
go get github.com/anshumanbh/tko-subs
 cp ~/go/bin/tko-subs /bin/
echo "${BLUE} done ${RESET}"
echo ""

#install subDomainizer
echo "${BLUE} subdomainizer ${RESET}"
git clone https://github.com/nsonaniya2010/SubDomainizer.git /opt/SubDomainizer
cd /opt/SubDomainizer && chmod +x SubDomainizer.py
 pip3 install -r requirements.txt 
echo '#!/bin/bash' > /usr/bin/SubDomainizer
echo 'python3 /opt/SubDomainizer/SubDomainizer.py "$@"' >> /usr/bin/SubDomainizer
chmod +x /usr/bin/SubDomainizer
echo "${BLUE} done ${RESET}"
echo ""

#install massdns
echo "${BLUE} Installing massdns ${RESET}"
git clone https://github.com/blechschmidt/massdns.git /opt/massdns
cd /opt/massdns
make
echo "${BLUE} done ${RESET}"
echo ""

#install subjack1
echo "${BLUE} installing subjack [1] ${RESET}"
go get -u github.com/haccer/subjack
 cp ~/go/bin/subjack /bin/
echo "${BLUE} done ${RESET}"
echo ""

#No ned to copy just need config file...
echo "${BLUE} installing subjack [2] ${RESET}"
go get github.com/manasmbellani/subjack
echo "${BLUE} Done ${RESET}"
echo ""

echo "${BLUE} installing Sublister ${RESET}"
git clone https://github.com/aboul3la/Sublist3r.git /opt/Sublist3r
cd /opt/Sublist3r
pip3 install -r requirements.txt
cp /opt/Sublist3r/sublist3r.py /usr/local/bin/sublist3r
echo "${BLUE} done ${RESET}"
echo ""

echo "${BLUE} installing Subover ${RESET}"
go get -u github.com/Ice3man543/SubOver
 cp ~/go/bin/SubOver /bin/
echo "${BLUE} done ${RESET}"
echo ""

echo "${BLUE} installing spyse ${RESET}"
 pip3 install spyse.py
echo "${BLUE} done ${RESET}"
echo ""
sar 1 1 >/dev/null


echo "${GREEN} #### Installing CORS Tools #### ${RESET}"

echo "${BLUE} installing another cors scanner${RESET}"
go get -u github.com/Tanmay-N/CORS-Scanner
 cp ~/go/bin/CORS-Scanner /bin/
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null

echo "${GREEN} #### Installing XSS Tools#### ${RESET}"

echo "${BLUE} installing dalfox${RESET}"
git clone https://github.com/hahwul/dalfox /opt/dalfox
cd /opt/dalfox/ && go build dalfox.go
 cp dalfox /usr/bin/
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing Gxss${RESET}"
go get -u github.com/KathanP19/Gxss
 cp ~/go/bin/Gxss /bin/
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing XSStrike${RESET}"
git clone https://github.com/s0md3v/XSStrike.git /opt/XSStrike 
cd /opt/XSStrike
 pip3 install -r requirements.txt
echo '#!/bin/bash' > /usr/local/bin/xsstrike
echo 'python3 /opt/XSStrike/xsstrike.py "$@"' >> /usr/local/bin/xsstrike
chmod +x /usr/local/bin/xsstrike
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing XSScrapy ${RESET}"
git clone https://github.com/DanMcInerney/xsscrapy.git /opt/xsscrapy 
cd /opt/xsscrapy
 pip install -r requirements.txt
echo '#!/bin/bash' > /usr/local/bin/xsscrapy
echo 'python /opt/xsscrapy/xsscrapy.py "$@"' >> /usr/local/bin/xsscrapy
chmod +x /usr/local/bin/xsscrapy
echo "${RED}Check for scrapy.cfg in krishna main folder${RESET}"
echo "${BLUE} done${RESET}"
echo ""

#Xspear for XSS
echo "${BLUE} installing XSpear${RESET}"
 gem install XSpear
 gem install colorize
 gem install selenium-webdriver
 gem install terminal-table
 gem install progress_bar
echo "${BLUE} done${RESET}"
echo ""

#traxss
echo "${BLUE} downloading traxss${RESET}"
git clone https://github.com/M4cs/traxss.git /opt/traxss
cd /opt/traxss
 pip3 install -r requirements.txt
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null

echo "${BLUE} installing another unew ${RESET}"
go get -u github.com/dwisiswant0/unew
 cp ~/go/bin/unew /bin/
echo "${BLUE} done${RESET}"

echo "${BLUE} installing another gospider ${RESET}"
go get -u github.com/jaeles-project/gospider
 cp ~/go/bin/gospider /usr/local/bin/gospider
echo "${BLUE} done${RESET}"

echo "${GREEN} #### Installing Cloud workflow Tools #### ${RESET}"

echo "${BLUE} Instaliing awscli${RESET}"
 pip3 install awscli --upgrade --user
echo "${BLUE} Don't forget to set up AWS credentials!${RESET}"
echo "${BLUE} done${RESET}"
echo ""

#install lazys3
echo "${BLUE} lazys3${RESET}"
git clone https://github.com/nahamsec/lazys3.git /opt/lazys3
chmod +x /opt/lazys3 
echo '#!/bin/bash' > /usr/local/bin/lazys3
echo 'ruby /opt/lazys3/lazys3.rb "$@"' >> /usr/local/bin/lazys3
chmod +x /usr/local/bin/lazys3
echo "${BLUE} done${RESET}"
echo ""

#install GCPBucketBrute
echo "${BLUE} installing GCPBucketBrute${RESET}"
git clone https://github.com/RhinoSecurityLabs/GCPBucketBrute.git /opt/gcpbucketbrute
cd /opt/gcpbucketbrute
 python3 -m pip install -r requirements.txt
echo '#!/bin/bash' > /usr/local/bin/gcpbucketbrute
echo ' python3 /opt/gcpbucketbrute/gcpbucketbrute.py "$@"' >> /usr/local/bin/gcpbucketbrute
chmod +x /usr/local/bin/gcpbucketbrute
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null


echo "${GREEN} #### Installing CMS Tools #### ${RESET}" 
#install CMSmap
echo "${BLUE} installing CMSmap${RESET}"
git clone https://github.com/Dionach/CMSmap.git /opt/CMSmap
cd /opt/CMSmap
 pip3 install .
echo "${BLUE} done${RESET}"
echo ""


#install wpscan
echo "${BLUE} installing wpscan${RESET}"
 gem install wpscan
echo "${BLUE} done${RESET}"
echo ""

#install droopescan
echo "${BLUE} installing droopescan${RESET}"
 pip3 install droopescan
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} Adobe scanner${RESET}"
git clone https://github.com/0ang3el/aem-hacker.git /opt/aem-hacker
echo '#!/bin/bash' > /usr/local/bin/aem_discoverer
echo 'python3 /opt/aem-hacker/aem_discoverer.py "$@"' >> /usr/local/bin/aem_discoverer
chmod +x /usr/local/bin/aem_discoverer
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null


echo "${GREEN}#### Downloading Git tools ####${RESET}"

echo "${BLUE} git-scanner${RESET}"
git clone https://github.com/HightechSec/git-scanner /opt/git-scanner
cd /opt/git-scanner && chmod +x gitscanner.sh
 cp gitscanner.sh /usr/bin/gitscanner &&  chmod +x /usr/bin/gitscanner
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} gitgraber${RESET}"
git clone https://github.com/hisxo/gitGraber.git /opt/gitGraber
cd /opt/gitGraber && chmod +x gitGraber.py
 pip3 install -r requirements.txt
 ln -s /opt/gitGraber/gitGraber.py /usr/local/bin/gitGraber
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE}  GitHound${RESET}"
git clone https://github.com/tillson/git-hound.git /opt/git-hound
cd /opt/git-hound
 go build main.go && mv main githound
 mv config.example.yml config.yml
 cp githound /usr/local/bin/githound
echo "${BLUE} Create a ./config.yml or ~/.githound/config.yml${RESET}"
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} gitsearch${RESET}"
git clone https://github.com/gwen001/github-search.git /opt/github-search
cd /opt/github-search 
 pip3 install -r  requirements3.txt
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null

#-----Completed 
echo "${BLUE} installing findomain${RESET}"
cd ${DIR}/tools/
wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux
 chmod +x findomain-linux
 cp findomain-linux /usr/bin/findomain
echo "${BLUE} Add your keys in the config file"
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null

echo "${BLUE} installing gowitness${RESET}"
cd ./${DIR}/tools/
wget https://github.com/sensepost/gowitness/releases/download/2.1.2/gowitness-2.1.2-linux-amd64
 chmod +x gowitness-2.1.2-linux-amd64
 cp gowitness-2.1.2-linux-amd64 /usr/bin/gowitness
echo "${BLUE} done${RESET}"

echo "${GREEN}#### Other Tools ####${RESET}"

echo "${BLUE} installing SSRFMap ${RESET}"
git clone https://github.com/swisskyrepo/SSRFmap /opt/SSRFMap
cd /opt/SSRFMap/
 pip3 install -r requirements.txt
echo '#!/bin/bash' > /usr/bin/ssrfmap
echo 'python3 /opt/SSRFMap/ssrfmap.py "$@"' >> /usr/bin/ssrfmap
chmod +x /usr/bin/ssrfmap
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing XSRFProbe${RESET}"
 pip3 install xsrfprobe
echo "${BLUE} done${RESET}"
echo ""

#install JSParser
echo "${BLUE} installing JSParser${RESET}"
git clone https://github.com/nahamsec/JSParser.git /opt/JSParser
cd ./opt/JSParser
 python3 setup.py install
echo "${BLUE} done${RESET}"
echo ""

#install subjs
echo "${BLUE} installing subjs${RESET}"
go get -u github.com/lc/subjs
 cp ~/go/bin/subjs /usr/local/bin/subjs
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing broken-link-checker${RESET}"
 npm install broken-link-checker -g
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing pwncat${RESET}"
 pip3 install pwncat
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing Photon${RESET}"
git clone https://github.com/s0md3v/Photon.git /opt/Photon
cd /opt/Photon
 pip3 install -r requirements.txt
echo '#!/bin/bash' > /usr/bin/photon
echo 'python3 /opt/Photon/photon.py "$@"' >> /usr/bin/photon
chmod +x /usr/bin/photon
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing hakrawler${RESET}"
git clone https://github.com/hakluke/hakrawler.git /opt/hakrawler
cd /opt/hakrawler
go build main.go && mv main hakrawler
 mv hakrawler /usr/bin/
echo "${BLUE} done${RESET}"
echo ""


echo "${BLUE} installing hakrawler${RESET}"
go get github.com/hakluke/hakcheckurl
 cp ~/go/bin/hakcheckurl /usr/local/bin/hakcheckurl
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} Paramspider${RESET}"
git clone https://github.com/devanshbatham/ParamSpider /opt/ParamSpider
cd /opt/ParamSpider
 pip3 install -r requirements.txt
echo '#!/bin/bash' > /usr/bin/paramspider
echo 'python3 /opt/ParamSpider/paramspider.py "$@"' >> /usr/bin/paramspider
chmod +x /usr/bin/paramspider
echo "${BLUE} done${RESET}"
echo ""

#--check---------------------------------
echo "${BLUE} goohak${RESET}"
git clone https://github.com/1N3/Goohak.git /opt/Goohak
cd /opt/Goohak && chmod +x goohak
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing webtech${RESET}"
 pip3 install webtech
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing gau${RESET}"
go get -u github.com/lc/gau
 cp ~/go/bin/gau /usr/local/bin/gau
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} LinkFinder${RESET}"
git clone https://github.com/GerbenJavado/LinkFinder.git /opt/LinkFinder
cd /opt/LinkFinder
 pip3 install -r requirements.txt
 python3 setup.py install
sar 1 1 >/dev/null
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} SecretFinder${RESET}"
git clone https://github.com/m4ll0k/SecretFinder.git /opt/SecretFinder
cd /opt/SecretFinder && chmod +x secretfinder
 pip3 install -r requirements.txt
echo '#!/bin/bash' > /usr/bin/SecretFinder
echo 'python3 /opt/SecretFinder/SecretFinder.py "$@"' >> /usr/bin/SecretFinder
chmod +x /usr/bin/SecretFinder
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null


echo "${GREEN}#### ProjectDiscovery Pinned Tools ####${RESET}"

echo "${BLUE} installing naabu${RESET}"
wget https://github.com/projectdiscovery/naabu/releases/download/v2.0.2/naabu_2.0.2_linux_amd64.tar.gz
tar -xvf naabu_2.0.2_linux_amd64.tar.gz
 chmod +x naabu
mv naabu /usr/local/bin/naabu
naabu -h
echo "${BLUE} done${RESET}"
echo ""


echo "${BLUE} installing dnsprobe${RESET}"
go get -u github.com/projectdiscovery/dnsprobe
 cp ~/go/bin/dnsprobe /usr/local/bin/dnsprobe
echo  "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing nuclei${RESET}"
go get -u github.com/projectdiscovery/nuclei/v2/cmd/nuclei
 cp ~/go/bin/nuclei /usr/local/bin/nuclei
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing subfinder${RESET}"
wget https://github.com/projectdiscovery/subfinder/releases/download/v2.4.5/subfinder_2.4.5_linux_amd64.tar.gz
tar -xvf subfinder_2.4.5_linux_amd64.tar.gz
 chmod +x subfinder
 mv subfinder /usr/local/bin/subfinder
subfinder -h
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing httpx${RESET}"
go get -u github.com/projectdiscovery/httpx/cmd/httpx
 cp ~/go/bin/httpx /usr/local/bin/httpx
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing shuffledns${RESET}"
go get -u github.com/projectdiscovery/shuffledns/cmd/shuffledns
 cp ~/go/bin/shuffledns /usr/local/bin/shuffledns
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing chaos-client${RESET}"
go get -u github.com/projectdiscovery/chaos-client/cmd/chaos
 cp ~/go/bin/chaos /usr/local/bin/chaos
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null


echo "${GREEN} #### Downloading wordlists #### ${RESET}"
git clone https://github.com/assetnote/commonspeak2-wordlists /opt/Wordlists/commonspeak2-wordlists
git clone https://github.com/fuzzdb-project/fuzzdb /opt/Wordlists/fuzzdb
git clone https://github.com/1N3/IntruderPayloads /opt/Wordlists/IntruderPayloads
git clone https://github.com/swisskyrepo/PayloadsAllTheThings /opt/Wordlists/PayloadsAllTheThings
git clone https://github.com/danielmiessler/SecLists /opt/Wordlists/SecLists
cd /opt/Wordlists/SecLists/Discovery/DNS/
##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
printf "${BLUE} Wordlists downloaded ${RESET}"

sar 1 1 >/dev/null



echo "${GREEN} #### Installing tomnomnom tools #### ${RESET}"
echo "${GREEN}   check out his other tools as well  ${RESET}"

echo "${BLUE} installing meg${RESET}"
go get -u github.com/tomnomnom/meg
 cp  ~/go/bin/meg /usr/local/bin/meg
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing assetfinder${RESET}"
go get -u github.com/tomnomnom/assetfinder
 cp  ~/go/bin/assetfinder /usr/local/bin/assetfinder
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing waybackurls${RESET}"
go get -u github.com/tomnomnom/waybackurls
 cp  ~/go/bin/waybackurls /usr/local/bin/waybackurls
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing gf${RESET}"
go get -u github.com/tomnomnom/gf
 cp ~/go/bin/gf /usr/local/bin/gf
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing httprobe${RESET}"
go get -u github.com/tomnomnom/httprobe
 cp ~/go/bin/httprobe /usr/local/bin/httprobe
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing concurl${RESET}"
go get -u github.com/tomnomnom/hacks/concurl
 cp ~/go/bin/unfurl /usr/local/bin/unfurl
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing unfurl${RESET}"
go get -u github.com/tomnomnom/unfurl
 cp ~/go/bin/unfurl /usr/local/bin/unfurl
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing anti-burl${RESET}"
go get -u github.com/tomnomnom/hacks/anti-burl
 cp ~/go/bin/anti-burl /usr/local/bin/anti-burl
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing filter-resolved${RESET}"
go get github.com/tomnomnom/hacks/filter-resolved
 cp ~/go/bin/filter-resolved /usr/local/bin/filter-resolved
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing fff${RESET}"
go get -u github.com/tomnomnom/fff
 cp ~/go/bin/fff /usr/local/bin/fff
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing qsreplace${RESET}"
go get -u github.com/tomnomnom/qsreplace
 cp ~/go/bin/qsreplace /usr/local/bin/qsreplace
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null

echo "${GREEN} #### Other other Tools #### ${RESET}"

echo "${BLUE} installing arjun${RESET}"
git clone https://github.com/s0md3v/Arjun.git /opt/Arjun
echo '#!/bin/bash' > /usr/bin/arjun
echo 'python3 /opt/Arjun/arjun.py "$@"' >> /usr/bin/arjun
chmod +x /usr/bin/arjun
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing cf-check${RESET}"
go get -u github.com/dwisiswant0/cf-check
 cp ~/go/bin/cf-check /usr/local/bin/cf-check
echo "${BLUE} done${RESET}"
echo ""


echo "${BLUE} installing Urlprobe${RESET}"
go get -u github.com/1ndianl33t/urlprobe
 cp ~/go/bin/urlprobe /usr/local/bin/urlprobe
echo "${BLUE} done${RESET}"
echo ""

echo "${BLUE} installing amass${RESET}"
cd ~ && echo -e "Downloading amass version ${AMASS_VERSION} ..." && wget -q https://github.com/OWASP/Amass/releases/download/v${AMASS_VERSION}/amass_linux_amd64.zip && unzip amass_linux_amd64.zip && mv amass_linux_amd64/amass /usr/bin/

cd ~ && rm -rf amass_linux_amd64* amass_linux_amd64.zip*
echo "${BLUE} done${RESET}"
echo ""
unzip -q temp.zip && 

#Need Changes for Path -----------------------------------
printf "${RED}[+] Installing autorecon , please wait ... \n${GREEN}"
git clone https://github.com/Tib3rius/AutoRecon.git /opt/autorecon
pip3 install -r /opt/autorecon/requirements.txt
echo '#!/bin/bash' > /usr/bin/autorecon
echo 'python3 /opt/autorecon/src/autorecon/autorecon.py "$@"' >> /usr/bin/autorecon
chmod +x /usr/bin/autorecon
sar 1 1 >/dev/null
  
echo "-------------------------------------------------------------------------------------------"
echo "${GREEN} use the command 'source ~/.bash_profile' for the shell functions to work ${RESET}"
echo ""
echo "${GREEN}[+] Done...${RESET}"

