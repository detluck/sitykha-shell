qt_add_library(sitykha-core STATIC
    main.cpp
)

target_link_libraries(sitykha-core
    PUBLIC
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        Qt6::DBus
)

target_include_directories(sitykha-core
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

add_subdirectory(config)
