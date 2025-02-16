# NCNN + Real-ESRGAN セットアップスクリプト

このスクリプトは、Jetson Nano や ARM デバイス上で **NCNN + Real-ESRGAN** をセットアップし、超解像画像処理を実行するためのものです。

---

## 🚀 機能
- **NCNN のインストールとビルド**
- **Real-ESRGAN-ncnn-vulkan のインストールとビルド**
- **必要な依存パッケージのインストール**
- **CMake の最新版をインストール**
- **SSHキーの作成（GitHub用）**
- **モデルファイルのダウンロード**
- **画像の超解像処理を実行**

---

## 🔧 動作環境
- **OS**: Ubuntu 20.04 / 22.04
- **ハードウェア**: Jetson Nano / Jetson Xavier / その他 ARM デバイス
- **依存ライブラリ**:
    - CMake
    - OpenCV
    - Vulkan
    - NCNN
    - Real-ESRGAN

---

## 📌 インストール手順

### 1. スクリプトのダウンロード
```sh
cd ~
git clone https://github.com/your-repo/ncnn-realesrgan-setup.git
cd ncnn-realesrgan-setup
```

### 2. 実行権限を付与
```sh
chmod +x setup_ncnn_realesrgan.sh
```

### 3. スクリプトの実行
```sh
./setup_ncnn_realesrgan.sh
```

---

## 🎯 スクリプトの処理内容

### ✅ 1. 必要なパッケージのインストール
```sh
sudo apt install -y cmake git g++ libvulkan-dev vulkan-utils libopencv-dev build-essential libssl-dev glslang-tools
```

### ✅ 2. NCNN のクローンとビルド
```sh
git clone https://github.com/Tencent/ncnn.git
cd ncnn
git submodule update --init --recursive
mkdir build && cd build
cmake -D CMAKE_BUILD_TYPE=Release -D NCNN_VULKAN=ON ..
make -j$(nproc)
sudo make install
```

### ✅ 3. CMake のアップデート
```sh
wget https://github.com/Kitware/CMake/releases/download/v3.30.4/cmake-3.30.4-Linux-aarch64.tar.gz
tar -zxvf cmake-3.30.4-Linux-aarch64.tar.gz
sudo cp -r cmake-3.30.4-Linux-aarch64/* /usr/local/
```

### ✅ 4. SSHキーの作成（GitHub用）
```sh
ssh-keygen -t rsa -b 4096 -N "" -f "$HOME/.ssh/id_rsa"
cat ~/.ssh/id_rsa.pub
```

### ✅ 5. Real-ESRGAN のクローンとビルド
```sh
git clone https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan.git --recursive
cd Real-ESRGAN-ncnn-vulkan/src/
mkdir build && cd build
cmake ..
make -j$(nproc)
```

### ✅ 6. モデルファイルのダウンロード
```sh
mkdir -p models
wget -P models "https://github.com/TheMurusTeam/FreeScaler/raw/refs/heads/main/FreeScaler/realesrgan/models/realesrgan-x4plus.bin"
wget -P models "https://github.com/TheMurusTeam/FreeScaler/raw/refs/heads/main/FreeScaler/realesrgan/models/realesrgan-x4plus.param"
```

### ✅ 7. 画像の超解像処理を実行
```sh
wget 'https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/blob/master/images/input2.jpg?raw=true' -O input.jpg
./realesrgan-ncnn-vulkan -i input.jpg -o output.jpg -s 2 -m models -n realesrgan-x4plus
```

---

## 🎉 完了後の確認
1. `output.jpg` が生成されているか確認。
2. `xdg-open output.jpg` で拡大後の画像を確認。
3. 必要に応じて `-s` オプションを変更し、倍率を変えて試す。

---

```bash
#
wget https://github.com/mugimugi555/jetsonnano/raw/refs/heads/main/ubuntu20/realesrgan/realesrgan-ncnn-vulkan
chmod +x realesrgan-ncnn-vulkan

#
wget 'https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/blob/master/images/input2.jpg?raw=true' -O input.jpg
./realesrgan-ncnn-vulkan -i input.jpg -o output.jpg -s 2 -m models -n realesrgan-x4plus
```
