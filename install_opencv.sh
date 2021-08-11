#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/jetsonnano/main/install_opencv.sh && bash install_opencv.sh ;

# setting ###################################################

OPENCV_VERSION="4-5-3" ;

#############################################################

sudo echo ;

echo "===========================";
echo " check swap size";
echo "===========================";
SWAPLIMIT=`free -m | egrep '^Swap:' | tr -s ' ' | awk '{print $2}'` ;

echo $SWAPLIMIT;

if $SWAPLIMIT -lt 6000 ; then

  echo "not enough swap size";
  echo "auto create and reboot";
  echo "reboot finished. please retry";

  echo "===========================";
  echo " create expand swap size";
  echo "===========================";
  cd ;
  git clone https://github.com/JetsonHacksNano/installSwapfile ;
  cd installSwapfile ;
  ./installSwapfile.sh ;
  sudo reboot now ;

fi

echo "swap size is ok.";

echo "===========================";
echo " Install OpenCV Ver. ${OPENCV_VERSION}";
echo "===========================";
wget https://github.com/Qengineering/Install-OpenCV-Jetson-Nano/raw/main/OpenCV-${OPENCV_VERSION}.sh ;
sudo chmod 755 ./OpenCV-${OPENCV_VERSION}.sh ;
./OpenCV-${OPENCV_VERSION}.sh ;

echo "fisnished.";
echo "please try example programs =>";

# todo
