#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/jetsonnano/main/install_tensorflow.sh && bash install_tensorflow.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# note
# https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform/index.html
# https://github.com/PINTO0309/Tensorflow-bin/tree/main/previous_versions
# https://developer.download.nvidia.com/compute/redist/jp/v461/tensorflow/
#-----------------------------------------------------------------------------------------------------------------------

JETSON_VERSION=461 ;

#-----------------------------------------------------------------------------------------------------------------------
# install library
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran ;

#-----------------------------------------------------------------------------------------------------------------------
# install python library
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y python3-pip ;
sudo pip3 install -U pip testresources setuptools==49.6.0 ; 
sudo pip3 install -U --no-deps numpy==1.19.4 future==0.18.2 mock==3.0.5 keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==0.4.0 protobuf pybind11 cython pkgconfig ;

#-----------------------------------------------------------------------------------------------------------------------
# install no-build-isolation h5py==3.1.0
#-----------------------------------------------------------------------------------------------------------------------
sudo env H5PY_SETUP_REQUIRES=0 pip3 install -U --no-build-isolation h5py==3.1.0

#-----------------------------------------------------------------------------------------------------------------------
# install tensorflow
#-----------------------------------------------------------------------------------------------------------------------
sudo pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v$JETSON_VERSION tensorflow ;
sudo pip3 install tensorflow-hub tensorflow-datasets ;

#-----------------------------------------------------------------------------------------------------------------------
# check install tensorflow
#-----------------------------------------------------------------------------------------------------------------------
python3 -c 'import tensorflow as tf; print(tf.__version__)' ;
