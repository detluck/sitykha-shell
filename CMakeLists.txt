cmake_minimum_required(VERSION 3.16)
project(sitykha-shell)

include(GNUInstallDirs)


set(QS_PROJECT_NAME "sitykha-shell" CACHE STRING "Quickshell project name")
set(USER_CONFIG_DIR "$ENV{HOME}/.config/${QS_PROJECT_NAME}")
set(DEFAULT_CONFIG_DIR "${CMAKE_SOURCE_DIR}/config/defaults")
set(INSTALL_QSCONFDIR "/etc/xdg/quickshell/${QS_PROJECT_NAME}" CACHE STRING "Quickshell config install dir")

add_custom_target(copy_default_configs ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory "${USER_CONFIG_DIR}"
    COMMAND ${CMAKE_COMMAND} -E copy_directory "${DEFAULT_CONFIG_DIR}" "${USER_CONFIG_DIR}"
    COMMENT "Copying default config files to ${USER_CONFIG_DIR}"
)

set(PROJECT_FILES
    shell.qml
    qmldir
)

foreach(dir IN ITEMS assets components config modules services)
    if(EXISTS "${CMAKE_SOURCE_DIR}/${dir}")
        file(GLOB_RECURSE DIR_FILES RELATIVE "${CMAKE_SOURCE_DIR}" "${dir}/*")
        list(APPEND PROJECT_FILES ${DIR_FILES})
    endif()
endforeach()

list(REMOVE_DUPLICATES PROJECT_FILES)

add_custom_target(ProjectSources SOURCES ${PROJECT_FILES})

install(FILES
    "${CMAKE_SOURCE_DIR}/shell.qml"
    "${CMAKE_SOURCE_DIR}/qmldir"
    DESTINATION "${INSTALL_QSCONFDIR}"
)

foreach(dir IN ITEMS assets components config modules services)
    if(EXISTS "${CMAKE_SOURCE_DIR}/${dir}")
        install(DIRECTORY "${CMAKE_SOURCE_DIR}/${dir}" DESTINATION "${INSTALL_QSCONFDIR}")
    endif()
endforeach()

