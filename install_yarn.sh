#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/jetsonnano/main/install_yarn.sh && bash install_yarn.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# add repository
#-----------------------------------------------------------------------------------------------------------------------
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null ;
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list ;

#-----------------------------------------------------------------------------------------------------------------------
# install yarn
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y yarn ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
yarn -v ;
