🚦 AI Speed Limit Detection with Python & Qt Dashboard
📌 Description

This project combines Computer Vision, Artificial Intelligence, and Qt/QML to build an application capable of:

Automatically detecting speed limit signs using a YOLOv8 trained model.

Extracting the numeric speed value using OCR (Tesseract).

Storing the detected value in JSON (vitesse_limite.json).

Displaying the detected speed on a real-time dynamic gauge built with Qt/QML.

It demonstrates how to integrate Python (AI & computer vision) with C++/Qt (user interface).

🛠️ Technologies

Python: YOLOv8, OpenCV, PyTesseract, NumPy.

C++/Qt (QML): dynamic gauge and UI.

JSON: real-time data exchange.

CMake: project compilation for the C++/Qt part.

📂 Project Structure

AI-Speed-Limit-Detection-with-Python-Qt-Dashboard/
│── .vscode/                # VS Code configuration
│── assets/signs/           # Speed limit sign images
│── build/                  # Build output (CMake)
│── qml/                    # QML interface (dynamic gauge)
│── CMakeLists.txt          # CMake configuration
│── Main.cpp                # C++ entry point (Qt app)
│── Main.py                 # Python script (YOLO + OCR)
│── Model.pt                # Trained YOLOv8 model
│── SpeedClass.txt          # Speed classes (30, 50, 80, etc.)
│── data.yaml               # YOLO dataset configuration
│── resources.qrc           # Qt resources
│── speed_limit_data.txt    # Speed data text file
│── speedlimitreader.cpp    # C++/JSON data reader
│── speedlimitreader.h      # C++ header for JSON reader
│── vitesse_limite.json     # Real-time detected speed

▶️ Usage

Run the Python detection + OCR script:

python Main.py

Run the Qt app to display the dynamic gauge:

./build/JaugeDynamique.exe

📊 Example Workflow

YOLOv8 detects a “80 km/h” sign.

OCR extracts the value 80.

Value is written to vitesse_limite.json.

The Qt gauge updates in real-time to display 80 km/h.

(Screenshots or demo GIFs can be added here)

📌 Future Improvements

Multi-sign detection.

Compare detected speed limits with the vehicle’s actual speed.

👨‍💻 Author

Developed by BITTA Anas

Embedded Systems Engineering Student – Université Privée de Fès.
