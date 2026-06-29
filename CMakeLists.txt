cmake_minimum_required(VERSION 3.22)

if(NOT DEFINED VERSION)
  execute_process(COMMAND git describe --tags --abbrev=0
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        OUTPUT_VARIABLE VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  if("${VERSION}" STREQUAL "")
    set(VERSION "0.1.0")
  endif()
endif()

string(REGEX REPLACE "^v" "" VERSION "${VERSION}")

project(sitykha-shell VERSION ${VERSION} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(ENABLE_MODULES "backend;shell" CACHE STRING "Modules to build/install")
set(INSTALL_QMLDIR "usr/lib/qt6/qml" CACHE STRING "QML module install dir")
set(INSTALL_QSCONFDIR "etc/xdg/quickshell/sitykha" CACHE STRING "Quickshell config install dir")

add_compile_options(
    -Wall -Wextra -Wpedantic -Wshadow -Wconversion
    -Wold-style-cast -Wnull-dereference -Wdouble-promotion
    -Wformat=2 -Wfloat-equal -Woverloaded-virtual
    -Wsign-conversion -Wredundant-decls -Wswitch
    -Wunreachable-code
)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wunused-lambda-capture)
endif()

find_package(Qt6 6.6 REQUIRED COMPONENTS Core Qml Quick DBus Multimedia)
qt_standard_project_setup(REQUIRES 6.6)

if("backend" IN_LIST ENABLE_MODULES)
  add_subdirectory(src/backend)
endif()

if("shell" IN_LIST ENABLE_MODULES)
  foreach(dir modules services components)
    install(DIRECTORY ${dir} DESTINATION "${INSTALL_QSCONFDIR}")
  endforeach()

  install(DIRECTORY assets/wallpapers DESTINATION "${INSTALL_QSCONFDIR}/assets")

  install(FILES shell.qml DESTINATION "${INSTALL_QSCONFDIR}")
endif()
