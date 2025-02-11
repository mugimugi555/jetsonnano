# 🚀 OpenCV CUDA

[タイトル画像](assets/images/header.png)

## **📌 概要**
このプロジェクトでは、Jetson Nano などの CUDA 対応デバイスで **GPU 最適化された OpenCV** を使用するためのインストール方法と、
リアルタイムで **CUDA フィルターを適用する Python プログラム** について説明します。

✅ **CUDA 対応の OpenCV をインストール**  
✅ **OpenCV CUDA フィルター一覧**  
✅ **Python プログラムを実行して GPU フィルターを適用**  

---

## **📌 1️⃣ CUDA 対応 OpenCV のインストール**
### **🔧 インストール手順**

以下のコマンドを実行することで、CUDA 対応の OpenCV をインストールできます。

```bash
chmod +x install_opencv_cuda.sh
./install_opencv_cuda.sh
```

✅ **このスクリプトは OpenCV をソースからビルドし、CUDA サポートを有効化します**  
✅ **インストール完了後、CUDA が有効か確認するには以下のコマンドを実行してください。**  

```bash
python3 -c "import cv2; print(cv2.__version__); print('CUDA Enabled:', cv2.cuda.getCudaEnabledDeviceCount() > 0)"
```

✅ **CUDA が有効なら `True` が表示されます**

---

## **📌 2️⃣ OpenCV CUDA フィルター一覧**

| フィルター名 | 説明 |
|-------------|------|
| `cuda_GaussianBlur` | ぼかし |
| `cuda_Canny` | エッジ検出 |
| `cuda_BilateralFilter` | ノイズ除去 |
| `cuda_Sobel` | 輝度勾配（エッジ強調） |
| `cuda_Laplacian` | 輪郭抽出 |
| `cuda_CvtColor` | グレースケール変換 |
| `cuda_HistogramEqualization` | コントラスト強調 |
| `cuda_Threshold` | 2値化 |
| `cuda_WarpAffine` | 変形（回転・スケール） |

✅ **これらのフィルターを利用することで、画像処理のパフォーマンスを大幅に向上できます**

---

## **📌 3️⃣ Python プログラムの起動方法**

### **🔧 GPU フィルターを適用する Python スクリプトの実行**
以下のコマンドを実行して、リアルタイムで CUDA フィルターを適用できます。

```bash
python3 camera_filters_cuda.py
```

✅ **USB カメラの映像をリアルタイムで処理し、CUDA フィルターを適用します**  
✅ **複数のフィルターを 3x3 のグリッドで並べて表示**

[タイトル画像](assets/images/footer.png)
