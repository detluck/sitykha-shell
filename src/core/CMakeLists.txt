qt_add_qml_module(sitykha-core
    URI Sitykha.Core
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/Sitykha/Core"
    SOURCES
        config/ConfigManager.cpp
        config/ConfigManager.hpp
        config/ConfigObject.cpp
        config/ConfigObject.hpp
        config/lock/LockConfig.cpp
        config/lock/LockConfig.hpp
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
        qml/services/Pathes.qml
)

target_link_libraries(sitykha-core
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        Qt6::DBus
)

target_include_directories(sitykha-core
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/config
        ${CMAKE_CURRENT_SOURCE_DIR}/config/lock
)

install(TARGETS sitykha-core sitykha-coreplugin
    LIBRARY DESTINATION "${INSTALL_QMLDIR}/Sitykha/Core"
)
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/Sitykha/Core/qmldir"
    DESTINATION "${INSTALL_QMLDIR}/Sitykha/Core"
)

