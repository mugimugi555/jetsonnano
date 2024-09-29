#!/bin/bash

#
cd
sudo apt install -y cmake git g++ libvulkan-dev vulkan-utils libopencv-dev
git clone https://github.com/Tencent/ncnn.git
cd ncnn
git submodule update --init --recursive
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=Release -D NCNN_VULKAN=ON ..
make -j$(nproc)
sudo make install

#
cd
cmake --version
sudo apt install -y build-essential libssl-dev
wget https://github.com/Kitware/CMake/releases/download/v3.30.4/cmake-3.30.4-Linux-aarch64.tar.gz
tar -zxvf cmake-3.30.4-Linux-aarch64.tar.gz 
cd cmake-3.30.4-linux-aarch64/
sudo cp -r * /usr/local/
cmake --version

#
cd
ssh-keygen -t rsa -b 4096
echo "========================================="
echo "SSH keys -> new SSH key -> copy next code -> Add SSH key";
echo "========================================="
cat ~/.ssh/id_rsa.pub
echo "========================================="
xdg-open https://github.com/settings/keys

#
cd
sudo apt-get install -y glslang-tools
git clone https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan.git --recursive
cd Real-ESRGAN-ncnn-vulkan/
cd src/
mkdir build
cd build
cmake ..
make -j$(nproc)

# ベースURL
base_url="https://github.com/TheMurusTeam/FreeScaler/raw/refs/heads/main/FreeScaler/realesrgan/models/"

# ダウンロードするファイルのリスト
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

# 保存先ディレクトリ
output_dir="models"

# 保存先ディレクトリが存在しない場合は作成
mkdir -p "$output_dir"

# for ループでファイルをダウンロード
for file in "${files[@]}"; do
    wget -P "$output_dir" "${base_url}${file}"
done

#
wget 'https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/blob/master/images/input2.jpg?raw=true' -O input.jpg
./realesrgan-ncnn-vulkan -i input -o output.jpg -s 2 -m models -n realesrgan-x4plus
