#!/bin/bash

# wget`https://raw.githubusercontent.com/mugimugi555/jetsonnano/main/install.sh && bash install.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# proxy
#-----------------------------------------------------------------------------------------------------------------------
#sudo echo "Acquire::http::Proxy \"http://192.168.0.5:3142\";" | sudo tee -a /etc/apt/apt.conf.d/02proxy ;

#-----------------------------------------------------------------------------------------------------------------------
# home dir name jp 2 english
#-----------------------------------------------------------------------------------------------------------------------
LANG=C xdg-user-dirs-gtk-update ;

#-----------------------------------------------------------------------------------------------------------------------
# sudo time out
#-----------------------------------------------------------------------------------------------------------------------
echo 'Defaults timestamp_timeout = 1200' | sudo EDITOR='tee -a' visudo ;

#-----------------------------------------------------------------------------------------------------------------------
# wall paper
#-----------------------------------------------------------------------------------------------------------------------
wget http://gahag.net/img/201602/11s/gahag-0055029460-1.jpg -O /home/$USER/Pictures/1.jpg ;
gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Pictures/1.jpg" ;

#-----------------------------------------------------------------------------------------------------------------------
# setting
#-----------------------------------------------------------------------------------------------------------------------
gsettings set org.gnome.desktop.interface enable-animations false           ;
gsettings set org.gnome.desktop.session idle-delay 0                        ;
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false        ;
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 30 ;

#-----------------------------------------------------------------------------------------------------------------------
# init update
#-----------------------------------------------------------------------------------------------------------------------
sudo echo ;
sudo apt update ;
sudo apt upgrade -y ;

#-----------------------------------------------------------------------------------------------------------------------
# jtop ( gpu top )
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y python-pip ;
sudo -H pip install -U jetson-stats ;
sudo systemctl enable jetson_stats.service

#-----------------------------------------------------------------------------------------------------------------------
# software
#-----------------------------------------------------------------------------------------------------------------------
echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections ;
echo "samba-common samba-common/dhcp boolean true"           | sudo debconf-set-selections ;
echo "samba-common samba-common/do_debconf boolean true"     | sudo debconf-set-selections ;
sudo apt install -y emacs-nox htop curl git axel samba openssh-server net-tools exfat-fuse exfat-utils ffmpeg ibus-mozc imagemagick lame unar ;

#-----------------------------------------------------------------------------------------------------------------------
# youtube-dl
#-----------------------------------------------------------------------------------------------------------------------
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl ;
sudo chmod a+rx /usr/local/bin/youtube-dl ;

#-----------------------------------------------------------------------------------------------------------------------
# caps2ctrl
#-----------------------------------------------------------------------------------------------------------------------
CAPS2CTRL=$(cat<<TEXT
BACKSPACE="guess"
XKBMODEL="pc105"
XKBLAYOUT="jp"
XKBVARIANT=""
XKBOPTIONS="ctrl:nocaps"
TEXT
)

sudo echo "$CAPS2CTRL" | sudo tee /etc/default/keyboard

MYKEYBOARD=$(cat<<TEXT
<component>
  <version>2.23.2815.102+dfsg-8ubuntu1</version>
  <name>com.google.IBus.Mozc</name>
  <license>New BSD</license>
  <exec>/usr/lib/ibus-mozc/ibus-engine-mozc --ibus</exec>
  <textdomain>ibus-mozc</textdomain>
  <author>Google Inc.</author>
  <homepage>https://github.com/google/mozc</homepage>
  <description>Mozc Component</description>
<engines>
<engine>
  <description>Mozc (Japanese Input Method)</description>
  <language>ja</language>
  <symbol>&#x3042;</symbol>
  <rank>80</rank>
  <icon_prop_key>InputMode</icon_prop_key>
  <icon>/usr/share/ibus-mozc/product_icon.png</icon>
  <setup>/usr/lib/mozc/mozc_tool --mode=config_dialog</setup>
  <layout>jp</layout>
  <name>mozc-jp</name>
  <longname>Mozc</longname>
</engine>
</engines>
</component>
TEXT
)
sudo echo "$MYKEYBOARD" | sudo tee /usr/share/ibus/component/mozc.xml ;

#-----------------------------------------------------------------------------------------------------------------------
# setting jp
#-----------------------------------------------------------------------------------------------------------------------
sudo update-locale LANG=ja_JP.UTF8 ;
sudo apt install -y manpages-ja manpages-ja-dev ;
sudo update-locale LANG=ja_JP.UTF8 ;
sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime ;
sudo mkdir /usr/share/locale-langpack/ja ;
sudo apt install -y ibus-mozc language-pack-gnome-ja language-pack-gnome-ja-base language-pack-ja language-pack-ja-base fonts-takao-gothic fonts-takao-mincho $(check-language-support) ;

#-----------------------------------------------------------------------------------------------------------------------
# create 8GB swap
#-----------------------------------------------------------------------------------------------------------------------
cd ;
git clone https://github.com/JetsonHacksNano/installSwapfile ;
cd installSwapfile ;
./installSwapfile.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# vscode
#-----------------------------------------------------------------------------------------------------------------------
#cd ;
#wget -O insider.deb https://update.code.visualstudio.com/latest/linux-deb-arm64/insider ;
#sudo apt install -y ./insider.deb ;
#sudo mv /usr/bin/code-insiders /usr/bin/code ;

#-----------------------------------------------------------------------------------------------------------------------
# ai world
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y git cmake libpython3-dev python3-numpy ;
cd ;
git clone --recursive https://github.com/dusty-nv/jetson-inference ;
cd jetson-inference ;
mkdir build ;
cd build ;
cmake ../ ;
make -j$(nproc) ;
sudo make install ;
sudo ldconfig ;

#-----------------------------------------------------------------------------------------------------------------------
# alias
#-----------------------------------------------------------------------------------------------------------------------
MYALIAS=$(cat<<TEXT
alias a="axel -a -n 5"
alias u='unar'
TEXT
)
echo "$MYALIAS" >> ~/.bashrc ;

#-----------------------------------------------------------------------------------------------------------------------
# reboot
#-----------------------------------------------------------------------------------------------------------------------
sudo apt autoremove -y ;
sudo reboot now ;
