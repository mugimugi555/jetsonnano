#!/bin/bash
set -e  # エラー発生時にスクリプトを停止

# ===============================
# Jetson Nano Setup Script
# Qengineering/Jetson-Nano-Ubuntu-20-image
# https://github.com/Qengineering/Jetson-Nano-Ubuntu-20-image
# ===============================

echo "システムのセットアップを開始..."

# --- UbuntuをCLIモードに変更する場合（オプション） ---
# CLIモードに変更する場合、以下を手動で実行：
# sudo systemctl set-default multi-user
# shutdown -r now

# --- 環境変数の設定（LD_PRELOAD） ---
LD_PRELOAD_PATH="/usr/lib/aarch64-linux-gnu/libGLdispatch.so.0:/usr/lib/aarch64-linux-gnu/libgomp.so.1"
if ! grep -q "export LD_PRELOAD=$LD_PRELOAD_PATH" ~/.bashrc; then
    echo "export LD_PRELOAD=$LD_PRELOAD_PATH" >> ~/.bashrc
    source ~/.bashrc
fi

# --- GStreamer のキャッシュ削除（不要ならコメントアウト可） ---
rm -rf ~/.cache/gstreamer-1.0/

# ===============================
# Stable Diffusion WebUI のセットアップ
# ===============================

echo "Stable Diffusion WebUI をクローン..."
cd ~
if [ ! -d "stable-diffusion-webui" ]; then
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
else
    echo "stable-diffusion-webui フォルダはすでに存在します。"
fi
cd stable-diffusion-webui

# ===============================
# 必要なシステムパッケージのインストール
# ===============================

echo "システムパッケージをインストール..."
sudo apt update
sudo apt install -y \
    python3-pip libjpeg-dev libopenblas-dev libopenmpi-dev libomp-dev \
    libavcodec-dev libavformat-dev libswscale-dev zlib1g-dev libpython3-dev

# ===============================
# PyTorch のインストール
# ===============================

echo "PyTorch をインストール..."
sudo -H pip3 install -U future wheel mock pillow testresources setuptools==58.3.0 Cython gdown

# PyTorch の `.whl` ファイルをダウンロードしてインストール
if [ ! -f "torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl" ]; then
    echo "PyTorch のバイナリをダウンロード中..."
    gdown https://drive.google.com/uc?id=1e9FDGt2zGS5C5Pms7wzHYRb0HuupngK1
fi
echo "PyTorch をインストール..."
sudo -H pip3 install torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl
rm -f torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl  # インストール後に削除

# ===============================
# Torchvision のインストール
# ===============================

echo "Torchvision をインストール..."
if [ ! -f "torchvision-0.14.0a0+5ce4506-cp38-cp38-linux_aarch64.whl" ]; then
    echo "Torchvision のバイナリをダウンロード中..."
    gdown https://drive.google.com/uc?id=19UbYsKHhKnyeJ12VPUwcSvoxJaX7jQZ2
fi
echo "Torchvision をインストール..."
sudo -H pip3 install torchvision-0.14.0a0+5ce4506-cp38-cp38-linux_aarch64.whl
rm -f torchvision-0.14.0a0+5ce4506-cp38-cp38-linux_aarch64.whl  # インストール後に削除

# ===============================
# 必須ライブラリのインストール
# ===============================

echo "Python 必須ライブラリをインストール..."
pip3 install -U numpy==1.22.1 scipy==1.9.1 pillow==9.0.1
sudo -H pip3 install jetson-stats

# ===============================
# Stable Diffusion WebUI の起動
# ===============================

echo "Stable Diffusion WebUI を起動..."
COMMANDLINE_ARGS="--listen --lowvram --ckpt-dir ./models --skip-version-check --skip-torch-cuda-test --precision full --no-half"
REQS_FILE="requirements.txt"
python3 launch.py

echo "セットアップ完了！ 🚀"
