#!/bin/bash
set -e  # エラーが発生したらスクリプトを停止

# モデルの保存ディレクトリ
output_dir="models"

# https://github.com/TheMurusTeam/FreeScaler/tree/main/FreeScaler/realesrgan/models

# ベースURL
base_url="https://raw.githubusercontent.com/TheMurusTeam/FreeScaler/refs/heads/main/FreeScaler/realesrgan/models/"

# ダウンロードするファイルリスト
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

# 保存先ディレクトリが存在しない場合は作成
mkdir -p "$output_dir"

echo "=== モデルファイルのダウンロード開始 ==="

# for ループで各ファイルをダウンロード
for file in "${files[@]}"; do
    if [ ! -f "$output_dir/$file" ]; then
        echo "Downloading: $file ..."
        wget -q -P "$output_dir" "${base_url}${file}"
    else
        echo "Skipping (already exists): $file"
    fi
done

echo "=== モデルファイルのダウンロード完了 ==="
