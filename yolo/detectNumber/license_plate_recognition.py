import cv2
import pytesseract
import numpy as np

# YOLOの設定
net = cv2.dnn.readNet("yolov4-license-plate.weights", "yolov4-license-plate.cfg")
layer_names = net.getUnconnectedOutLayersNames()

cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    height, width = frame.shape[:2]
    blob = cv2.dnn.blobFromImage(frame, 1/255.0, (416, 416), swapRB=True, crop=False)
    net.setInput(blob)
    detections = net.forward(layer_names)

    for detection in detections:
        for obj in detection:
            scores = obj[5:]
            class_id = np.argmax(scores)
            confidence = scores[class_id]

            if confidence > 0.5:
                box = obj[0:4] * np.array([width, height, width, height])
                (centerX, centerY, w, h) = box.astype("int")
                x = int(centerX - (w / 2))
                y = int(centerY - (h / 2))

                # ナンバープレートを切り出し
                plate = frame[y:y+h, x:x+w]
                gray_plate = cv2.cvtColor(plate, cv2.COLOR_BGR2GRAY)

                # OCRでナンバープレートを認識
                plate_number = pytesseract.image_to_string(gray_plate, config="--psm 7")
                
                # 結果を表示
                cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
                cv2.putText(frame, plate_number.strip(), (x, y - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    cv2.imshow("License Plate Recognition", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
