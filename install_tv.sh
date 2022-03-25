#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/jetsonnano/main/install_tv.sh && bash install_tv.sh ;

# https://blog.ch3cooh.jp/entry/2021/04/06/200732

#-----------------------------------------------------------------------------------------------------------------------
# install PX-S1UD
#-----------------------------------------------------------------------------------------------------------------------
wget http://plex-net.co.jp/plex/px-s1ud/PX-S1UD_driver_Ver.1.0.1.zip ;
unzip PX-S1UD_driver_Ver.1.0.1.zip ;
sudo cp PX-S1UD_driver_Ver.1.0.1/x64/amd64/isdbt_rio.inp /lib/firmware/ ;
rm PX-S1UD_driver_Ver.1.0.1.zip ;
rm -rf PX-S1UD_driver_Ver.1.0.1 ;
dmesg | grep PX-S1UD ;

#-----------------------------------------------------------------------------------------------------------------------
# install docker
#-----------------------------------------------------------------------------------------------------------------------
curl -fsSL get.docker.com -o get-docker.sh ;
sh get-docker.sh ;
sudo usermod -aG docker $(whoami) ;
docker version ;

#-----------------------------------------------------------------------------------------------------------------------
# install docker compose
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y python3 python3-pip ;
sudo pip3 install docker-compose ;
sudo systemctl restart docker ;
sudo docker-compose version ;

#-----------------------------------------------------------------------------------------------------------------------
# install docker-mirakurun-epgstation
#-----------------------------------------------------------------------------------------------------------------------

# git clone
mkdir ~/tv ;
cd ~/tv ;
git clone https://github.com/CH3COOH/docker-mirakurun-epgstation.git ;
sudo chown $USER:$USER docker-mirakurun-epgstation ;

# copy sample tuner config
cd docker-mirakurun-epgstation ;
cp epgstation/config/operatorLogConfig.sample.yml   epgstation/config/operatorLogConfig.yml   ;
cp epgstation/config/epgUpdaterLogConfig.sample.yml epgstation/config/epgUpdaterLogConfig.yml ;
cp epgstation/config/serviceLogConfig.sample.yml    epgstation/config/serviceLogConfig.yml    ;

# install docker-mirakurun-epgstation
cd ~/tv/docker-mirakurun-epgstation ;
sudo docker-compose run --rm -e SETUP=true mirakurun ;
sudo docker-compose up -d ;

# channel scan
curl -X PUT "http://localhost:40772/api/config/channels/scan" ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
MY_HOST_NAME=`hostname` ;
echo "======================================" ;
echo "visit => http://$MY_HOST_NAME.local:8888/" ;
echo "======================================" ;
