# 1. CHANGE THIS TO EXECUTABLE!
qt_add_executable(sitykha-core
    main.cpp
)

# 2. Link the libraries (PRIVATE is correct for executables)
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
)

# 4. Attach the QML module directly to the executable
qt6_add_qml_module(sitykha-core
    URI Sitykha.Core
    VERSION 1.0
    SOURCES
        config/ConfigManager.cpp
        config/ConfigManager.hpp
        config/ConfigObject.cpp
        config/ConfigObject.hpp
        config/LockConfig.hpp
)
