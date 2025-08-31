# 🚦 AI Speed Limit Detection with Python & Qt Dashboard  

## 📌 Description  
This project combines **Computer Vision**, **Artificial Intelligence**, and **Qt/QML** to build an application capable of:  

- 🛑 Automatically detecting speed limit signs using a **YOLOv8 trained model**.  
- 🔎 Extracting the numeric speed value using **OCR (Tesseract)**.  
- 💾 Storing the detected value in **JSON** (`vitesse_limite.json`).  
- 📊 Displaying the detected speed on a **real-time dynamic gauge** built with **Qt/QML**.  

It demonstrates how to integrate **Python (AI & computer vision)** with **C++/Qt (UI)**.  

---

## 🛠️ Technologies  
- **Python** → YOLOv8, OpenCV, PyTesseract, NumPy  
- **C++/Qt (QML)** → dynamic gauge and UI  
- **JSON** → real-time data exchange  
- **CMake** → compilation and build system  

---

## 📂 Structure du projet

- 📁 **AI-Speed-Limit-Detection-with-Python-Qt-Dashboard/**
  - ⚙️ `.vscode/` → Configuration VS Code  
  - 🖼️ `assets/signs/` → Images de panneaux de vitesse  
  - 🏗️ `build/` → Résultats de compilation (CMake)  
  - 🎨 `qml/` → Interface QML (jauge dynamique)  
  - 📄 `CMakeLists.txt` → Configuration CMake  
  - 💻 `Main.cpp` → Point d'entrée C++ (Qt app)  
  - 🐍 `Main.py` → Script Python (YOLO + OCR)  
  - 🤖 `Model.pt` → Modèle YOLOv8 entraîné  
  - 📑 `SpeedClass.txt` → Classes de vitesses (30, 50, 80, etc.)  
  - 🗂️ `data.yaml` → Configuration dataset YOLO  
  - 📦 `resources.qrc` → Ressources Qt  
  - 📊 `speed_limit_data.txt` → Données de vitesse (texte)  
  - 🔍 `speedlimitreader.cpp` → Lecteur JSON en C++  
  - 📘 `speedlimitreader.h` → Header du lecteur JSON  
  - 📌 `vitesse_limite.json` → Vitesse détectée en temps réel  

---

## ▶️ Usage  

### 1️⃣ Run the Python detection + OCR script  
```bash
python Main.py
### 2️⃣ Run the Qt app to display the dynamic gauge  
```bash
./build/JaugeDynamique.exe

---

## 📊 Exemple de workflow

1. YOLOv8 détecte un panneau **80 km/h**.  
2. L’OCR extrait la valeur **80**.  
3. La valeur est écrite dans `vitesse_limite.json`.  
4. La jauge Qt se met à jour en temps réel et affiche **80 km/h**.  

---

## 📌 Améliorations futures

- 🚗 Détection multiple de panneaux.  
- 📉 Comparaison entre les vitesses limites détectées et la vitesse réelle du véhicule.  
- 📱 Déploiement sur cartes embarquées (**Raspberry Pi / Jetson Nano**).  

---

## 👨‍💻 Auteur
Développé par **BITTA Anas**  
🎓 Étudiant en Systèmes Embarqués – Université Privée de Fès  



