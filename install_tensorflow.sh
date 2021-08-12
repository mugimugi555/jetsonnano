#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/jetsonnano/main/install_tensorflow.sh && bash install_tensorflow.sh ;

# for jetson nano and python 3.6

echo "=========================================";
echo "setup tensorflow 2.5 for python 3.6 cpu arm 64bit";
echo "if you want other arch , please visit here";
echo "https://github.com/PINTO0309/Tensorflow-bin";
echo "=========================================";

cd ;
wget https://raw.githubusercontent.com/PINTO0309/Tensorflow-bin/main/tensorflow-2.5.0-cp36-none-linux_aarch64_download.sh ;
bash tensorflow-2.5.0-cp36-none-linux_aarch64_download.sh ;

echo "=========================================";
echo " install tensorflow 2.5 about 30 minutes";
echo "=========================================";
sudo apt install -y libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev ;
pip cache purge ;
/usr/bin/python3 -m pip install --upgrade pip ;
#python3 -m pip install h5py
python3 -m pip install tensorflow-hub tensorflow-datasets tensorflow-2.5.0-cp36-none-linux_aarch64.whl ;

echo "=========================================";
echo " check install tensorflow";
echo "=========================================";
python3 -c 'import tensorflow as tf; print(tf.__version__)'  # for Python 3

echo "=========================================";
echo " if has error please input next command";
echo "=========================================";
echo "pip uninstall numpy";
echo "pip install numpy";
