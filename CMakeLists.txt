cmake_minimum_required(VERSION 3.16)
project(JaugeDynamique LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Activer AUTOMOC, AUTORCC, AUTOUIC
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Qt6 standard (pas de Quick2DRenderer)
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
    Svg
)

qt_add_executable(JaugeDynamique
    main.cpp
    speedlimitreader.cpp
)

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
        assets/signs/20.svg
        assets/signs/30.svg
        assets/signs/40.svg
        assets/signs/50.svg
        assets/signs/60.svg
        assets/signs/80.svg
        assets/signs/100.svg
        assets/signs/120.svg
)

target_link_libraries(JaugeDynamique PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Svg
)
