#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/jetsonnano/main/install_opencv.sh && bash install_opencv.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# config
#-----------------------------------------------------------------------------------------------------------------------
OPENCV_VERSION="4-5-5" ;

#-----------------------------------------------------------------------------------------------------------------------
# check swap size";
#-----------------------------------------------------------------------------------------------------------------------
sudo echo ;
SWAPLIMIT=`free -m | egrep '^Swap:' | tr -s ' ' | awk '{print $2}'` ;
echo $SWAPLIMIT;

if [ $SWAPLIMIT -lt 6000 ] ; then

  cd ;
  git clone https://github.com/JetsonHacksNano/installSwapfile ;
  cd installSwapfile ;
  ./installSwapfile.sh ;
  # sudo reboot now ;

fi

#-----------------------------------------------------------------------------------------------------------------------
# install opencv
#-----------------------------------------------------------------------------------------------------------------------
wget https://github.com/Qengineering/Install-OpenCV-Jetson-Nano/raw/main/OpenCV-${OPENCV_VERSION}.sh ;
sudo chmod 755 ./OpenCV-${OPENCV_VERSION}.sh ;
./OpenCV-${OPENCV_VERSION}.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
python3 -c "import cv2; print(cv2.__version__)" ;

# do examples
