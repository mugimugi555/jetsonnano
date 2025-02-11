import cv2
import numpy as np

# CUDAが利用可能かチェック
if cv2.cuda.getCudaEnabledDeviceCount() == 0:
    print("CUDAが利用できません。CPUで処理します。")
    use_cuda = False
else:
    print("CUDA対応GPUを検出。CUDAを使用します。")
    use_cuda = True

cap = cv2.VideoCapture(0)  # USBカメラを開く

while True:
    ret, frame = cap.read()
    if not ret:
        break

    if use_cuda:
        gpu_frame = cv2.cuda_GpuMat()
        gpu_frame.upload(frame)

        # 1. GaussianBlur（ぼかし）
        gpu_blurred = cv2.cuda_GaussianBlur(gpu_frame, (15, 15), 0)

        # 2. Canny（エッジ検出）
        gpu_edges = cv2.cuda_Canny(gpu_frame, 100, 200)

        # 3. Bilateral Filter（ノイズ除去）
        gpu_bilateral = cv2.cuda.bilateralFilter(gpu_frame, 15, 75, 75)

        # 4. Sobel（輝度勾配）
        gpu_sobel_x = cv2.cuda.Sobel(gpu_frame, cv2.CV_8U, 1, 0, ksize=3)
        gpu_sobel_y = cv2.cuda.Sobel(gpu_frame, cv2.CV_8U, 0, 1, ksize=3)

        # 5. Laplacian（輪郭抽出）
        gpu_laplacian = cv2.cuda.Laplacian(gpu_frame, cv2.CV_8U, ksize=3)

        # 6. グレースケール変換
        gpu_gray = cv2.cuda.cvtColor(gpu_frame, cv2.COLOR_BGR2GRAY)

        # 7. ヒストグラム平坦化（コントラスト強調）
        gpu_hist_eq = cv2.cuda.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8)).apply(gpu_gray)

        # 8. 2値化（Threshold）
        _, gpu_thresh = cv2.cuda.threshold(gpu_gray, 127, 255, cv2.THRESH_BINARY)

        # 9. WarpAffine（画像変形）
        matrix = np.float32([[1, 0, 50], [0, 1, 30]])  # 平行移動
        gpu_warp = cv2.cuda.warpAffine(gpu_frame, matrix, (frame.shape[1], frame.shape[0]))

        # CPUに戻して表示用に変換
        blurred = gpu_blurred.download()
        edges = cv2.cvtColor(gpu_edges.download(), cv2.COLOR_GRAY2BGR)
        bilateral = gpu_bilateral.download()
        sobel_x = gpu_sobel_x.download()
        sobel_y = gpu_sobel_y.download()
        laplacian = gpu_laplacian.download()
        hist_eq = cv2.cvtColor(gpu_hist_eq, cv2.COLOR_GRAY2BGR)
        thresh = cv2.cvtColor(gpu_thresh.download(), cv2.COLOR_GRAY2BGR)
        warp = gpu_warp.download()

        # 3x3 のグリッドに並べる
        row1 = np.hstack((blurred, edges, bilateral))
        row2 = np.hstack((sobel_x, sobel_y, laplacian))
        row3 = np.hstack((hist_eq, thresh, warp))
        combined = np.vstack((row1, row2, row3))

    else:
        # CPUで処理（GPUがない場合）
        blurred = cv2.GaussianBlur(frame, (15, 15), 0)
        edges = cv2.Canny(frame, 100, 200)
        bilateral = cv2.bilateralFilter(frame, 15, 75, 75)
        sobel_x = cv2.Sobel(frame, cv2.CV_8U, 1, 0, ksize=3)
        sobel_y = cv2.Sobel(frame, cv2.CV_8U, 0, 1, ksize=3)
        laplacian = cv2.Laplacian(frame, cv2.CV_8U, ksize=3)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        hist_eq = cv2.equalizeHist(gray)
        _, thresh = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)
        matrix = np.float32([[1, 0, 50], [0, 1, 30]])
        warp = cv2.warpAffine(frame, matrix, (frame.shape[1], frame.shape[0]))

        hist_eq = cv2.cvtColor(hist_eq, cv2.COLOR_GRAY2BGR)
        thresh = cv2.cvtColor(thresh, cv2.COLOR_GRAY2BGR)

        row1 = np.hstack((blurred, edges, bilateral))
        row2 = np.hstack((sobel_x, sobel_y, laplacian))
        row3 = np.hstack((hist_eq, thresh, warp))
        combined = np.vstack((row1, row2, row3))

    # 映像表示
    cv2.imshow("CUDA GPU Filters", combined)

    # 'q' で終了
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
