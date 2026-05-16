cmake_minimum_required(VERSION 3.22)

project(sitykha-shell
    VERSION 0.1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_AUTOMOC ON)   # auto-run moc on Q_OBJECT classes
set(CMAKE_AUTORCC ON)   # auto-process .qrc resource files

find_package(Qt6 6.6 REQUIRED COMPONENTS
    Core
    Qml
    Quick
    DBus
)

qt_standard_project_setup(REQUIRES 6.6)

add_subdirectory(src/core)
