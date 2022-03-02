#!/bin/bash

#

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
