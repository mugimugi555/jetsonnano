import cv2

# Haarcascade（顔検出用モデル）をロード
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")

# USBカメラを開く
cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # グレースケール変換（顔検出の精度向上）
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # 顔を検出
    faces = face_cascade.detectMultiScale(gray, 1.1, 4)

    # 顔を矩形で囲む
    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 2)

    # 映像を表示
    cv2.imshow("Face Recognition", frame)

    # `q` キーで終了
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
