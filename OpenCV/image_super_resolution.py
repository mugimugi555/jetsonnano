import cv2

cap = cv2.VideoCapture(0)  # USBカメラ

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # CUDAで超解像処理
    gpu_frame = cv2.cuda_GpuMat()
    gpu_frame.upload(frame)

    upscale_factor = 2  # 2倍の高解像度化
    new_size = (frame.shape[1] * upscale_factor, frame.shape[0] * upscale_factor)
    gpu_upscaled = cv2.cuda.resize(gpu_frame, new_size, interpolation=cv2.INTER_CUBIC)

    # 結果を取得して表示
    upscaled = gpu_upscaled.download()
    cv2.imshow("Super Resolution (CUDA)", upscaled)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
