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
        config/appearance/GlobalThemeConfig.cpp
        config/appearance/GlobalThemeConfig.hpp
        config/pathes/PathConfig.hpp
        config/pathes/PathConfig.cpp
        services/UserInfo.hpp
        services/UserInfo.cpp
        models/KeyboardModel.hpp
        models/KeyboardModel.cpp
        models/WallpaperModel.hpp
        models/WallpaperModel.cpp
)

qt_add_resources(sitykha-backend "ui_icons"
    PREFIX "/icons"
    BASE "${CMAKE_SOURCE_DIR}/assets/icons"
    FILES
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/arrow-right.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/backspace.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/catppuccin.png"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/enter-key.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/enter.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/eye-cl.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/eye-o.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/handwriting.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/hidekeyboard.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/keyboard.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/language.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/password.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/selectionhandle.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/settings.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/shift-fill.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/shift-upper.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/shift.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/spinner.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/textmode.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/lock/user-default.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/power/power-reboot.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/power/power-suspend.svg"
        "${CMAKE_SOURCE_DIR}/assets/icons/power/power.svg"

)

#qt_add_resources(sitykha-backend "ui_images"
#    PREFIX "/images"
#    BASE "${CMAKE_SOURCE_DIR}/assets/images"
#    FILES
#)

qt_add_resources(sitykha-backend "ui_fonts"
    PREFIX "/fonts"
    BASE "${CMAKE_SOURCE_DIR}/assets/fonts"
    FILES
        "${CMAKE_SOURCE_DIR}/assets/fonts/redhat/RedHatDisplay-Regular.otf"
        "${CMAKE_SOURCE_DIR}/assets/fonts/redhat/RedHatDisplay-Medium.otf"
        "${CMAKE_SOURCE_DIR}/assets/fonts/redhat/RedHatDisplay-SemiBold.otf"
        "${CMAKE_SOURCE_DIR}/assets/fonts/redhat/RedHatDisplay-Bold.otf"
        "${CMAKE_SOURCE_DIR}/assets/fonts/redhat/RedHatDisplay-Black.otf"
)

target_link_libraries(sitykha-backend
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        Qt6::DBus
        Qt6::Multimedia
)

target_include_directories(sitykha-backend
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/config
        ${CMAKE_CURRENT_SOURCE_DIR}/config/lock
        ${CMAKE_CURRENT_SOURCE_DIR}/services
        ${CMAKE_CURRENT_SOURCE_DIR}/models
        ${CMAKE_CURRENT_SOURCE_DIR}/config/appearance
        ${CMAKE_CURRENT_SOURCE_DIR}/config/pathes 
)

install(TARGETS sitykha-backend sitykha-backendplugin
    LIBRARY DESTINATION "${INSTALL_QMLDIR}/Sitykha/Backend"
)
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/Sitykha/Backend/qmldir"
    DESTINATION "${INSTALL_QMLDIR}/Sitykha/Backend"
)
