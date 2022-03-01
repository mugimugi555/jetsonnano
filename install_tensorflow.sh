#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/jetsonnano/main/install_tensorflow.sh && bash install_tensorflow.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# note
# for jetson nano and python 3.6 ( cp36 aarch64 )
# https://github.com/PINTO0309/Tensorflow-bin/tree/main/previous_versions
# https://developer.download.nvidia.com/compute/redist/jp/v461/tensorflow/
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
# download install shell
#-----------------------------------------------------------------------------------------------------------------------
cd ;
wget https://developer.download.nvidia.com/compute/redist/jp/v461/tensorflow/tensorflow-2.7.0+nv22.1-cp36-cp36m-linux_aarch64.whl ;
wget https://developer.download.nvidia.com/compute/redist/jp/v461/pytorch/torch-1.11.0a0+17540c5-cp36-cp36m-linux_aarch64.whl ;

#-----------------------------------------------------------------------------------------------------------------------
# install tensorflow 2.5 about 30 minutes
#-----------------------------------------------------------------------------------------------------------------------
#sudo apt install -y libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev ;
sudo apt install -y \
  libhdf5-serial-dev hdf5-tools libhdf5-dev \
  zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran ;
pip cache purge ;
/usr/bin/python3 -m pip install --upgrade pip ;
#python3 -m pip install h5py
python3 -m pip install \
  tensorflow-hub \
  tensorflow-datasets \
  tensorflow-2.7.0+nv22.1-cp36-cp36m-linux_aarch64.whl \
  torch-1.11.0a0+17540c5-cp36-cp36m-linux_aarch64.whl ;

#-----------------------------------------------------------------------------------------------------------------------
# check install tensorflow
#-----------------------------------------------------------------------------------------------------------------------
python3 -c 'import tensorflow as tf; print(tf.__version__)'  # for Python 3

#pip uninstall numpy
#pip install numpy
