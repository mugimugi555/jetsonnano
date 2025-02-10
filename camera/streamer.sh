#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y git wget build-essential cmake \
    libopencv-dev python3-opencv python3-pip gstreamer1.0-tools gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly

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

# Jetson Nanoをストリーミングカメラとして設定
echo "Starting Jetson Nano as a streaming camera..."
gst-launch-1.0 v4l2src device=/dev/video0 ! videoconvert ! x264enc ! rtph264pay config-interval=1 ! udpsink host=192.168.1.100 port=5000 &

echo "Streaming started. You can view the stream on another device using:"
echo "ffplay udp://192.168.1.100:5000"
