#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y build-essential pkg-config git cmake nasm yasm \
    libjpeg-dev libpng-dev libtiff-dev libopenexr-dev liblcms2-dev liblqr-1-0-dev \
    libfftw3-dev libfreetype6-dev ocl-icd-opencl-dev

# NVIDIAの開発ツールをインストール
sudo apt install -y nvidia-cuda-toolkit

# ImageMagickのソースコードを取得
git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick

# コンフィグレーション & ビルド
./configure --with-opencl
make -j$(nproc)
sudo make install
sudo ldconfig

# インストール確認
echo "ImageMagick installed successfully. Checking OpenCL support:"
convert -list configure | grep "OpenCL"
