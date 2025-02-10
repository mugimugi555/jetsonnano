#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y git wget build-essential cmake \
    libopencv-dev python3-opencv python3-pip

# NVIDIAのCUDAツールキットとcuDNNをインストール（Jetson Nano向け）
sudo apt install -y nvidia-cuda-toolkit

# YOLOのソースコードを取得
git clone https://github.com/AlexeyAB/darknet.git
cd darknet

# Makefileの設定（GPU有効化）
sed -i 's/GPU=0/GPU=1/' Makefile
sed -i 's/CUDNN=0/CUDNN=1/' Makefile
sed -i 's/OPENCV=0/OPENCV=1/' Makefile

# YOLOのビルド
make -j$(nproc)

# インストール確認
echo "YOLO installed successfully. Checking version:"
./darknet detector test cfg/coco.data cfg/yolov4.cfg yolov4.weights data/dog.jpg
