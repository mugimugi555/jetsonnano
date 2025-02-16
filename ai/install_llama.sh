#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y git wget build-essential cmake \
    libopencv-dev python3-opencv python3-pip

# NVIDIAのCUDAツールキットとcuDNNをインストール（Jetson Nano向け）
sudo apt install -y nvidia-cuda-toolkit

# Llama.cppのソースコードを取得
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp

# Llama.cppのビルド
make -j$(nproc)

# モデルのダウンロード
wget -O ggml-model.bin https://huggingface.co/TheBloke/Llama-2-7B-GGML/resolve/main/llama-2-7b.ggmlv3.q4_0.bin

# インストール確認
echo "Llama.cpp installed successfully. Running test:"
./main -m ggml-model.bin -p "こんにちは、Jetson NanoでLLMを動かしています。"
