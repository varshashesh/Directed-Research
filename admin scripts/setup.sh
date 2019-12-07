#! /bin/bash

if command -v git --version > /dev/null 2>&1
then
	echo "Git is installed" 
else
	echo "Git not Installed"
	read  -p "Would you like to install Git as an administrator?(y/n)" yn
	case $yn in
		[Yy]* ) sudo apt-get install git; ;;
		[nN]* ) echo "no"; ;;
	esac
fi


		
read  -p "Would you like your Git Credentials to be saved?(y/n)" yn
case $yn in
	[Yy]* ) git config --global credential.helper cache; ;;
	[nN]* ) echo "no"; ;;
esac

read  -p "Would you like to install IoT module?(y/n)" yn
case $yn in
	[Yy]* ) git clone https://github.com/ANRGUSC/iotm.git
		if [ ! -d iotm ]; then
    			echo "Error the git repository was not cloned"
		fi; ;;
	[nN]* ) echo "no"; ;;
esac

read  -p "Would you like to install I3 SDK?(y/n)" yn
case $yn in
	[Yy]* ) git clone https://github.com/ANRGUSC/I3-SDK.git
		if [ ! -d I3-SDK ]; then
   	 		echo "Error the git repository was not cloned"
		fi; ;;
	[nN]* ) echo "no"; ;;
esac

str=$(lsb_release -d --short)
echo "OS = $str "

if [[ "$str" == *"Ubuntu"* ]];
then 
	echo "Running on Ubuntu"
	read  -p "Would you like to install Docker?(y/n)" yn
	case $yn in
		[Yy]* )echo "Checking for docker."
			sudo apt-get remove docker docker-engine docker.io containerd runc
			sudo apt-get update

			echo "Installing docker"
			sudo apt-get install     apt-transport-https     ca-certificates     curl     gnupg-agent     software-properties-common

			curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
			sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
			sudo apt-get update
			sudo apt-get install docker-ce docker-ce-cli containerd.io
			sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
			
			file=/usr/local/bin/docker-compose
			if [ -f "$file" ];
			then
				echo "Docker Compose is Downloaded"
				sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
			else
				echo " Docker compose version not found "
				exit
			fi ; ;;
		[nN]* ) echo "Docker not installed"; ;;
	esac 
else
	echo "The present setup of I3 only supports Ubuntu 64bit architechture"
fi

python_version=`python --version 2>&1 | awk '{print $2}'`
if command -v python --version > /dev/null 2>&1
then
	echo "Python is available"
	echo " Python $python_version "
else
	echo "python not available"
	read  -p "Would you like to install Python Environment?(y/n)" yn
	case $yn in
		[Yy]* ) sudo apt-get python
			sudo apt install python-pip
			pip install requests
			pip install paho-mqtt; ;;
		[nN]* ) echo "Python not installed"; ;;
	esac
	
fi





