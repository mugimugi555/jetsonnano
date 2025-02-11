import cv2
import numpy as np

cap = cv2.VideoCapture(0)  # USBカメラ

# 背景除去のための GrabCut モデル初期化
mask = None

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # CUDA対応の GrabCut
    if mask is None:
        mask = np.zeros(frame.shape[:2], np.uint8)
        rect = (50, 50, frame.shape[1] - 100, frame.shape[0] - 100)
        bgd_model = np.zeros((1, 65), np.float64)
        fgd_model = np.zeros((1, 65), np.float64)
        cv2.grabCut(frame, mask, rect, bgd_model, fgd_model, 5, cv2.GC_INIT_WITH_RECT)

    # 背景を除去
    mask2 = np.where((mask == 2) | (mask == 0), 0, 1).astype("uint8")
    removed_bg = frame * mask2[:, :, np.newaxis]

    # 背景を任意の色（青色）に変更
    background = np.full(frame.shape, (255, 0, 0), dtype=np.uint8)
    final_frame = np.where(mask2[:, :, np.newaxis] == 1, removed_bg, background)

    # 映像表示
    cv2.imshow("Background Removal (CUDA)", final_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
