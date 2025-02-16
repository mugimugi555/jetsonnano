#!/bin/bash
set -e  # エラーが発生したらスクリプトを停止

# ===================================
# Jetson Nano セットアップスクリプト
# ===================================

# --- システム依存パッケージのインストール ---
echo "システム依存パッケージをインストール中..."
sudo apt update
sudo apt install -y \
    python3-pip libjpeg-dev libopenblas-dev libopenmpi-dev libomp-dev \
    libavcodec-dev libavformat-dev libswscale-dev zlib1g-dev libpython3-dev

# --- LD_PRELOAD の設定 ---
LD_PRELOAD_PATH="/usr/lib/aarch64-linux-gnu/libgomp.so.1"
if ! grep -q "export LD_PRELOAD=$LD_PRELOAD_PATH" ~/.bashrc; then
    echo "export LD_PRELOAD=$LD_PRELOAD_PATH" >> ~/.bashrc
    source ~/.bashrc
fi

# ===================================
# PyTorch のインストール
# ===================================

echo "PyTorch をインストール中..."
sudo -H pip3 install -U future wheel mock pillow testresources
sudo -H pip3 install setuptools==58.3.0 Cython gdown

# PyTorch の `.whl` ファイルをダウンロードしてインストール
if [ ! -f "torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl" ]; then
    echo "PyTorch のバイナリをダウンロード中..."
    gdown https://drive.google.com/uc?id=1e9FDGt2zGS5C5Pms7wzHYRb0HuupngK1
fi
echo "PyTorch をインストール中..."
sudo -H pip3 install torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl
rm -f torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl  # インストール後に削除

# ===================================
# Torchvision のインストール
# ===================================

echo "Torchvision をインストール中..."
if [ ! -f "torchvision-0.14.0a0+5ce4506-cp38-cp38-linux_aarch64.whl" ]; then
    echo "Torchvision のバイナリをダウンロード中..."
    gdown https://drive.google.com/uc?id=19UbYsKHhKnyeJ12VPUwcSvoxJaX7jQZ2
fi
echo "Torchvision をインストール中..."
sudo -H pip3 install torchvision-0.14.0a0+5ce4506-cp38-cp38-linux_aarch64.whl
rm -f torchvision-0.14.0a0+5ce4506-cp38-cp38-linux_aarch64.whl  # インストール後に削除

# ===================================
# 必須ライブラリのインストール
# ===================================

echo "Python 必須ライブラリをインストール中..."
pip3 install -U numpy==1.22.1 scipy==1.9.1 pillow==9.0.1
sudo -H pip3 install jetson-stats

# ===================================
# Hugging Face Diffusers のインストール
# ===================================

echo "Hugging Face の Diffusers と Accelerate をインストール中..."
pip3 install -U git+https://github.com/huggingface/diffusers.git@main
pip3 install -U git+https://github.com/huggingface/accelerate.git@main

# ===================================
# セットアップ完了
# ===================================

echo "セットアップ完了！ 🚀"
