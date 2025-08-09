cmake_minimum_required(VERSION 3.16)
project(JaugeDynamique LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Activer AUTOMOC pour la génération des méta-objets Qt
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)

# Trouver Qt6
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
)

qt_add_executable(JaugeDynamique
    Main.cpp
    speedlimitreader.cpp
)

# Configuration manuelle du module QML et des ressources
qt_add_qml_module(JaugeDynamique
    URI Jauge
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/Gauge.qml
)

qt_add_resources(JaugeDynamique "resources"
    PREFIX "/"
    FILES
        qml/Main.qml
        qml/Gauge.qml
)


target_link_libraries(JaugeDynamique PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)