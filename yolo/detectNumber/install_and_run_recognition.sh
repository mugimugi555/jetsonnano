#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y python3-opencv python3-pip wget tesseract-ocr

# OpenCVのCUDAが有効か確認
python3 -c "import cv2; print('CUDA Enabled:', cv2.cuda.getCudaEnabledDeviceCount() > 0)"

# YOLOモデルをダウンロード
wget -O yolov4-license-plate.weights https://some-pretrained-model-url.com
wget -O yolov4-license-plate.cfg https://some-config-url.com

# 実行メニュー
echo "Select an AI recognition program:"
echo "1) Car Distance Estimation (カメラで車間距離推定)"
echo "2) License Plate Recognition (YOLOでナンバープレート認識)"
read -p "Enter the number (1-2): " choice

case $choice in
    1) python3 car_distance_estimation.py ;;
    2) python3 license_plate_recognition.py ;;
    *) echo "Invalid selection"; exit 1 ;;
esac
