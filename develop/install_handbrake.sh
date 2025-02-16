#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y build-essential pkg-config git cmake nasm yasm \
    libx264-dev libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev \
    libmp3lame-dev libopus-dev libass-dev libssl-dev zlib1g-dev \
    ocl-icd-opencl-dev

# NVIDIAの開発ツールをインストール
sudo apt install -y nvidia-cuda-toolkit

# HandBrakeのソースコードを取得
git clone https://github.com/HandBrake/HandBrake.git
cd HandBrake

# コンフィグレーション & ビルド
./configure --enable-nvenc --enable-qsv
make -j$(nproc)
sudo make install

# インストール確認
echo "HandBrake installed successfully. Checking NVENC support:"
HandBrakeCLI --help | grep nvenc
