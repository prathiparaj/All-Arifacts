#!/bin/bash

echo "Installing Browsers"

isApt=`command -v apt-get`
isYum=`command -v yum`

# Some of the previous commands will fail with an exit code other than zero (intentionally), 
# so we do not set error handling to stop (set e) until after they've run
set -e

if [ -n "$isApt" ] ; then
    echo "Using APT package manager"

    apt-get -y update
	
	sudo apt-get -f install
	sudo apt-get install libxss1 libappindicator1 libindicator7 -y
	wget https://mylibrary123.blob.core.windows.net/reposit/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome*.deb
	sudo apt install firefox -y
	#sudo apt-get install wine cabextract -y
	#wget https://mylibrary123.blob.core.windows.net/reposit/ies4linux.tar
	#tar zxvf ies4linux-latest.tar.gz
	#cd ies4linux-*
	#./ies4linux -y
    exit 0

elif [ -n "$isYum" ] ; then
    echo "Using YUM package manager"

    sudo yum -y update
    sudo yum clean all
	
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    	sudo yum install ./google-chrome-stable_current_*.rpm
	sudo yum install firefox
    exit 0
fi

exit 1
