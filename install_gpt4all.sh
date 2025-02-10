#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y git wget build-essential cmake \
    libopencv-dev python3-opencv python3-pip

# NVIDIAのCUDAツールキットとcuDNNをインストール（Jetson Nano向け）
sudo apt install -y nvidia-cuda-toolkit

# GPT4Allのソースコードを取得
git clone https://github.com/nomic-ai/gpt4all.git
cd gpt4all

# Pythonの依存関係をインストール
pip3 install -r requirements.txt

# モデルのダウンロード
wget -O gpt4all-model.bin https://gpt4all.io/models/gpt4all-lora-quantized.bin

# インストール確認
echo "GPT4All installed successfully. Running test:"
python3 gpt4all.py
