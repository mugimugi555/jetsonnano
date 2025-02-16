#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y build-essential pkg-config git cmake \
    libjpeg-dev libpng-dev libtiff-dev libopenexr-dev liblcms2-dev liblqr-1-0-dev \
    libfftw3-dev libfreetype6-dev ocl-icd-opencl-dev \
    libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev \
    libtbb2 libtbb-dev libdc1394-22-dev libv4l-dev libxvidcore-dev libx264-dev \
    libatlas-base-dev gfortran python3-dev

# NVIDIAの開発ツールをインストール
sudo apt install -y nvidia-cuda-toolkit

# OpenCVのソースコードを取得
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout 4.x
mkdir build && cd build

# OpenCVのビルド
cmake -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D WITH_CUDA=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 \
      -D WITH_CUBLAS=1 -D WITH_OPENCL=ON ..
make -j$(nproc)
sudo make install
sudo ldconfig

# インストール確認
echo "OpenCV installed successfully. Checking CUDA support:"
pkg-config --modversion opencv4
