#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y git wget build-essential cmake \
    libopencv-dev python3-opencv python3-pip gstreamer1.0-tools gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly

# NVIDIAのCUDAツールキットとcuDNNをインストール（Jetson Nano向け）
sudo apt install -y nvidia-cuda-toolkit

# Jetson Nanoをストリーミングカメラとして設定
echo "Starting Jetson Nano as a streaming camera..."
gst-launch-1.0 v4l2src device=/dev/video0 ! videoconvert ! x264enc ! rtph264pay config-interval=1 ! udpsink host=192.168.1.100 port=5000 &

echo "Streaming started. You can view the stream on another device using:"
echo "ffplay udp://192.168.1.100:5000"

# 顔検出を追加（OpenCV使用）
echo "Starting face detection..."
python3 -c "import cv2; cap = cv2.VideoCapture(0); face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'); while True: ret, frame = cap.read(); if not ret: break; gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY); faces = face_cascade.detectMultiScale(gray, 1.1, 4); for (x, y, w, h) in faces: cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 2); cv2.imshow('Face Detection', frame); if cv2.waitKey(1) & 0xFF == ord('q'): break; cap.release(); cv2.destroyAllWindows()"

echo "Face detection started. Press 'q' to exit."
