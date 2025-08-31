import cv2
import pandas as pd
from ultralytics import YOLO
import cvzone
import numpy as np
import pytesseract
from datetime import datetime
import json

# Configuration de Tesseract
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# Chargement du modèle YOLO
model = YOLO('Model.pt')

# Affiche les coordonnées de la souris (optionnel)
def RGB(event, x, y, flags, param):
    if event == cv2.EVENT_MOUSEMOVE:
        point = [x, y]
        print(point)

cv2.namedWindow('RGB')
cv2.setMouseCallback('RGB', RGB)

# Capture vidéo
cap = cv2.VideoCapture(0)

# Chargement des classes
with open("SpeedClass.txt", "r") as my_file:
    class_list = my_file.read().split("\n")

# Initialisation
count = 0
list1 = []
processed_numbers = set()

# Boucle principale
while True:    
    ret, frame = cap.read()
    count += 1
    if count % 3 != 0:
        continue
    if not ret:
        break

    frame = cv2.resize(frame, (1020, 500))
    results = model.predict(frame)
    a = results[0].boxes.data
    a = a.cpu()
    px = pd.DataFrame(a).astype("float")

    for index, row in px.iterrows():
        x1 = int(row[0])
        y1 = int(row[1])
        x2 = int(row[2])
        y2 = int(row[3])
        
        d = int(row[5])
        c = class_list[d]

        crop = frame[y1:y2, x1:x2]
        gray = cv2.cvtColor(crop, cv2.COLOR_BGR2GRAY)
        gray = cv2.bilateralFilter(gray, 10, 20, 20)
        _, binary = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        text = pytesseract.image_to_string(binary, config="--oem 3 --psm 8 -c tessedit_char_whitelist=0123456789").strip()
        text = text.replace("(", "").replace(")", "").replace(",", "")

        if text and text not in processed_numbers:
            processed_numbers.add(text)
            list1.append(text)
            current_datetime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

            try:
                vitesse_num = int(text)
                vitesses_valides = {20, 30, 40, 50, 60, 80, 100, 120}

                if vitesse_num in vitesses_valides:
                    data = {
                        "vitesse_limite": vitesse_num,
                        "timestamp": current_datetime
                    }

                    with open("vitesse_limite.json", "w") as json_file:
                        json.dump(data, json_file)

                    with open("speed_limit_data.txt", "a") as file:
                        file.write(f"{text}\t{current_datetime}\n")

                    print(f"✅ Vitesse limite détectée : {vitesse_num} km/h")
                else:
                    print(f"⛔ Vitesse détectée non valide : {vitesse_num} km/h → ignorée")
            except ValueError:
                print(f"⚠️ OCR incorrect : {text}")

            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 1)
            cv2.imshow('crop', crop)

    # Affichage
    cv2.imshow("RGB", frame)
    if cv2.waitKey(1) & 0xFF == 27:
        break

cap.release()
cv2.destroyAllWindows()
