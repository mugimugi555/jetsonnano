#!/bin/bash
set -e

# 必要なパッケージをインストール
sudo apt update
sudo apt install -y gstreamer1.0-tools gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly

# Jetson NanoのIPアドレスを取得
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Jetson NanoをUDPストリーミングカメラとして設定
echo "Starting Jetson Nano as a streaming camera (UDP mode)..."
gst-launch-1.0 v4l2src device=/dev/video0 ! videoconvert ! x264enc ! rtph264pay config-interval=1 ! udpsink host=$IP_ADDRESS port=5000 &

echo "UDP Streaming started. You can view the stream on another device using:"
echo "ffplay udp://$IP_ADDRESS:5000"

# Jetson NanoをHTTPストリーミングカメラとして設定
echo "Starting Jetson Nano as a streaming camera (HTTP mode)..."
gst-launch-1.0 v4l2src device=/dev/video0 ! videoconvert ! jpegenc ! multipartmux ! tcpserversink host=$IP_ADDRESS port=8080 &

echo "HTTP Streaming started. You can view the stream using:"
echo "http://$IP_ADDRESS:8080"
