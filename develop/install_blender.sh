#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y build-essential git cmake libxi-dev libxxf86vm-dev \
    libxrandr-dev libxinerama-dev libxcursor-dev libdbus-1-dev \
    libpulse-dev libasound2-dev libopenal-dev libfftw3-dev \
    libopenimageio-dev libopencolorio-dev libopenvdb-dev \
    libglew-dev libegl1-mesa-dev libwayland-dev libxkbcommon-dev \
    libfreetype6-dev libtiff-dev libjpeg-dev libpng-dev libboost-all-dev \
    nvidia-cuda-toolkit

# Blenderのソースコードを取得
git clone https://git.blender.org/blender.git
cd blender

# 必要なサブモジュールを取得
git submodule update --init --recursive

# ビルドディレクトリ作成
mkdir build && cd build

# CMakeでBlenderを設定
cmake .. -DWITH_CYCLES_CUDA_BINARIES=ON -DWITH_CUDA=ON -DCMAKE_BUILD_TYPE=Release

# Blenderのビルド
make -j$(nproc)

# インストール
sudo make install

# インストール確認
echo "Blender installed successfully with GPU support. Checking version:"
blender --version
