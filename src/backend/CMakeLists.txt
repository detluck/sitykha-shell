qt_add_qml_module(sitykha-backend
    URI Sitykha.Backend
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/Sitykha/Backend"
    SOURCES
        config/ConfigManager.cpp
        config/ConfigManager.hpp
        config/ConfigObject.cpp
        config/ConfigObject.hpp
        config/lock/LockConfig.cpp
        config/lock/LockConfig.hpp
)

target_link_libraries(sitykha-backend
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        Qt6::DBus
)

target_include_directories(sitykha-backend
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/config
        ${CMAKE_CURRENT_SOURCE_DIR}/config/lock
)

install(TARGETS sitykha-backend sitykha-backendplugin
    LIBRARY DESTINATION "${INSTALL_QMLDIR}/Sitykha/Backend"
)
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/Sitykha/Backend/qmldir"
    DESTINATION "${INSTALL_QMLDIR}/Sitykha/Backend"
)
