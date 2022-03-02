#!/usr/bin/bash

#

#-----------------------------------------------------------------------------------------------------------------------
# NOTE : https://zenn.dev/karaage0703/books/80b6999d429abc8051bb/viewer/5b814b
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
# install vscode insider
#-----------------------------------------------------------------------------------------------------------------------
cd ;
wget -O insider.deb https://update.code.visualstudio.com/latest/linux-deb-arm64/insider ;
sudo apt install -y ./insider.deb ;
sudo mv /usr/bin/code-insiders /usr/bin/code ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
code ;