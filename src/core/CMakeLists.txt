# 1. Defined as SHARED library to act as a QML plugin for quickshell
qt_add_library(sitykha-core SHARED)

# 2. Link the libraries
target_link_libraries(sitykha-core
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        Qt6::DBus
)

# 3. Setup the include paths so your Q_MOC_INCLUDE works
target_include_directories(sitykha-core
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${CMAKE_CURRENT_SOURCE_DIR}/config
        ${CMAKE_CURRENT_SOURCE_DIR}/config/lock
)

# 4. Attach the QML module to the library
qt6_add_qml_module(sitykha-core
    URI Sitykha.Core
    VERSION 1.0
    OUTPUT_DIRECTORY Sitykha/Core
    SOURCES
        config/ConfigManager.cpp
        config/ConfigManager.hpp
        config/ConfigObject.cpp
        config/ConfigObject.hpp
        config/lock/LockConfig.hpp
        config/lock/LockConfig.cpp
    QML_FILES
        qml/lockscreen/Lock.qml
        qml/lockscreen/components/Avatar.qml
        qml/lockscreen/components/IconButton.qml
        qml/lockscreen/components/Input.qml

        qml/lockscreen/components/LayoutSelector.qml
        qml/lockscreen/components/LockScreen.qml
        qml/lockscreen/components/LoginScreen.qml
        qml/lockscreen/components/MenuArea.qml
        qml/lockscreen/components/PowerMenu.qml
        qml/lockscreen/components/Spinner.qml
        qml/lockscreen/components/UserSelector.qml
)


