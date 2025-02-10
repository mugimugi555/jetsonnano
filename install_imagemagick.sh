#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y build-essential pkg-config git cmake nasm yasm \
    libx264-dev libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev \
    libmp3lame-dev libopus-dev libass-dev libssl-dev zlib1g-dev \
    libjpeg-dev libpng-dev libtiff-dev libopenexr-dev liblcms2-dev liblqr-1-0-dev libfftw3-dev libfreetype6-dev \
    ocl-icd-opencl-dev

# NVIDIAの開発ツールをインストール
sudo apt install -y nvidia-cuda-toolkit

# FFmpegのソースコードを取得
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg

# コンフィグレーション & ビルド
./configure --enable-nonfree --enable-gpl --enable-libx264 --enable-libx265 \
            --enable-libvpx --enable-libfdk-aac --enable-libmp3lame --enable-libopus \
            --enable-libass --enable-cuda --enable-cuvid --enable-nvenc \
            --extra-cflags=-I/usr/local/cuda/include \
            --extra-ldflags=-L/usr/local/cuda/lib64
make -j$(nproc)
sudo make install

# インストール確認
echo "FFmpeg installed successfully. Checking NVENC support:"
ffmpeg -encoders | grep nvenc

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
