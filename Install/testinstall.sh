#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

DIR=$(pwd)
mkdir -p $PWD/tools

echo "${BLUE} smuggler${RESET}"
git clone https://github.com/defparam/smuggler.git /opt/smuggler
cd /opt/smuggler && chmod +x smuggler
echo '#!/bin/bash' > /usr/bin/smuggler
echo 'python3 /opt/smuggler/smuggler.py "$@"' >> /usr/bin/smuggler
sudo chmod +x /usr/bin/smuggler
echo "${BLUE} done${RESET}"
echo ""
sar 1 1 >/dev/null
