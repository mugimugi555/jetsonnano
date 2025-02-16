#!/bin/bash
set -e  # エラーが発生したらスクリプトを停止

echo "=== NCNN + Real-ESRGAN 環境セットアップを開始 ==="

# ===================================
# 1. 必要な依存パッケージのインストール
# ===================================
echo "=== 依存パッケージをインストール中 ==="
sudo apt update
sudo apt install -y cmake git g++ libvulkan-dev vulkan-utils libopencv-dev build-essential libssl-dev glslang-tools

# ===================================
# 2. NCNNのクローンとビルド
# ===================================
echo "=== NCNNをクローンしてビルド ==="
cd "$HOME"
if [ ! -d "ncnn" ]; then
    git clone https://github.com/Tencent/ncnn.git
else
    echo "ncnn フォルダは既に存在します。スキップします。"
fi
cd ncnn
git submodule update --init --recursive
mkdir -p build && cd build
cmake -D CMAKE_BUILD_TYPE=Release -D NCNN_VULKAN=ON ..
make -j$(nproc)
sudo make install

# ===================================
# 3. CMakeのアップデート
# ===================================
echo "=== CMakeのバージョンをアップデート ==="
CMAKE_VERSION="3.30.4"
cd "$HOME"
if ! cmake --version | grep -q "$CMAKE_VERSION"; then
    wget -nc "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-aarch64.tar.gz"
    tar -zxvf "cmake-${CMAKE_VERSION}-Linux-aarch64.tar.gz"
    sudo cp -r "cmake-${CMAKE_VERSION}-Linux-aarch64"/* /usr/local/
else
    echo "CMake は最新バージョンです。スキップします。"
fi
cmake --version

# ===================================
# 4. SSHキーの作成と設定
# ===================================
echo "=== SSHキーの作成 ==="
if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
    ssh-keygen -t rsa -b 4096 -N "" -f "$HOME/.ssh/id_rsa"
fi
echo "========================================="
echo "GitHubに SSHキーを追加してください: $HOME/.ssh/id_rsa.pub"
echo "========================================="
cat "$HOME/.ssh/id_rsa.pub"
echo "========================================="
xdg-open https://github.com/settings/keys || echo "GitHubのSSHキー設定ページを開いてください: https://github.com/settings/keys"

# ===================================
# 5. Real-ESRGAN-ncnn-vulkanのクローンとビルド
# ===================================
echo "=== Real-ESRGAN-ncnn-vulkan をクローンしてビルド ==="
cd "$HOME"
if [ ! -d "Real-ESRGAN-ncnn-vulkan" ]; then
    git clone https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan.git --recursive
else
    echo "Real-ESRGAN-ncnn-vulkan フォルダは既に存在します。スキップします。"
fi
cd Real-ESRGAN-ncnn-vulkan/src/
mkdir -p build && cd build
cmake ..
make -j$(nproc)

# ===================================
# 6. モデルファイルのダウンロード
# ===================================
echo "=== モデルファイルをダウンロード中 ==="
base_url="https://github.com/TheMurusTeam/FreeScaler/raw/refs/heads/main/FreeScaler/realesrgan/models/"
output_dir="$HOME/Real-ESRGAN-ncnn-vulkan/models"
mkdir -p "$output_dir"

files=(
    "realesr-animevideov3-x2.bin"
    "realesr-animevideov3-x2.param"
    "realesr-animevideov3-x3.bin"
    "realesr-animevideov3-x3.param"
    "realesr-animevideov3-x4.bin"
    "realesr-animevideov3-x4.param"
    "realesrgan-x4plus-anime.bin"
    "realesrgan-x4plus-anime.param"
    "realesrgan-x4plus.bin"
    "realesrgan-x4plus.param"
)

for file in "${files[@]}"; do
    if [ ! -f "$output_dir/$file" ]; then
        wget -P "$output_dir" "${base_url}${file}"
    else
        echo "$file は既にダウンロード済みです。スキップします。"
    fi
done

# ===================================
# 7. Real-ESRGANの実行
# ===================================
echo "=== 画像の拡大処理を実行中 ==="
input_image="$HOME/input.jpg"
output_image="$HOME/output.jpg"

if [ ! -f "$input_image" ]; then
    wget 'https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/blob/master/images/input2.jpg?raw=true' -O "$input_image"
fi

xdg-open "$input_image" &
"$HOME/Real-ESRGAN-ncnn-vulkan/realesrgan-ncnn-vulkan" -i "$input_image" -o "$output_image" -s 2 -m "$output_dir" -n realesrgan-x4plus
xdg-open "$output_image" &

echo "=== 完了しました ==="
