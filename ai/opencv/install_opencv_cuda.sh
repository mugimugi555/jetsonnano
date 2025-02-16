#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y cmake g++ wget unzip \
                    libavcodec-dev libavformat-dev libswscale-dev \
                    libgtk2.0-dev libcanberra-gtk-module \
                    libxvidcore-dev libx264-dev libjpeg-dev \
                    libpng-dev libtiff-dev libv4l-dev \
                    gstreamer1.0-tools libgstreamer1.0-dev \
                    libgstreamer-plugins-base1.0-dev

# OpenCVのソースを取得
cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.3.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.5.3.zip
unzip opencv.zip
unzip opencv_contrib.zip
mv opencv-4.5.3 opencv
mv opencv_contrib-4.5.3 opencv_contrib

# ビルド用ディレクトリを作成
cd opencv
mkdir build
cd build

# CMakeの設定
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
      -D WITH_CUDA=ON \
      -D ENABLE_FAST_MATH=1 \
      -D CUDA_FAST_MATH=1 \
      -D WITH_CUBLAS=1 \
      -D OPENCV_DNN_CUDA=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_V4L=ON \
      -D WITH_OPENGL=ON \
      -D BUILD_EXAMPLES=OFF \
      -D OPENCV_GENERATE_PKGCONFIG=ON \
      ..

# OpenCVをコンパイル（時間がかかる）
make -j$(nproc)

# OpenCVをインストール
sudo make install
sudo ldconfig

# OpenCV のバージョン確認
python3 -c "import cv2; print(cv2.__version__); print('CUDA Enabled:', cv2.cuda.getCudaEnabledDeviceCount() > 0)"
