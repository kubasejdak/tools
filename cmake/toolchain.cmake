include(tools/cmake/utils.cmake)

macro(toolchain_addCompilationFlagsDebug)
    set(FLAGS "${ARGN}")

    foreach(FLAG IN LISTS FLAGS)
        string(APPEND CMAKE_C_FLAGS_DEBUG " ${FLAG}")
        string(APPEND CMAKE_CXX_FLAGS_DEBUG " ${FLAG}")
    endforeach()
endmacro()

macro(toolchain_addCompilationFlagsRelease)
    set(FLAGS "${ARGN}")

    foreach(FLAG IN LISTS FLAGS)
        string(APPEND CMAKE_C_FLAGS_RELEASE " ${FLAG}")
        string(APPEND CMAKE_CXX_FLAGS_RELEASE " ${FLAG}")
    endforeach()
endmacro()

function(toolchain_showConfig)
    if(NOT CMAKE_C_COMPILER)
        set(CMAKE_C_COMPILER "")
    endif()
    if(NOT CMAKE_CXX_COMPILER)
        set(CMAKE_CXX_COMPILER "")
    endif()
    if(NOT CMAKE_ASM_COMPILER)
        set(CMAKE_ASM_COMPILER "")
    endif()
    if(NOT CMAKE_RANLIB)
        set(CMAKE_RANLIB "")
    endif()
    if(NOT CMAKE_AR)
        set(CMAKE_AR "")
    endif()
    if(NOT CMAKE_OBJCOPY)
        set(CMAKE_OBJCOPY "")
    endif()
    if(NOT CMAKE_SIZE_UTIL)
        set(CMAKE_SIZE_UTIL "")
    endif()

    utils_log("Toolchain configuration:")
    utils_log("  Build type  : ${CMAKE_BUILD_TYPE}")
    utils_log("  CC          : ${CMAKE_C_COMPILER}")
    utils_log("  CXX         : ${CMAKE_CXX_COMPILER}")
    utils_log("  ASM         : ${CMAKE_ASM_COMPILER}")
    utils_log("  RANLIB      : ${CMAKE_RANLIB}")
    utils_log("  AR          : ${CMAKE_AR}")
    utils_log("  OBJCOPY     : ${CMAKE_OBJCOPY}")
    utils_log("  SIZE        : ${CMAKE_SIZE_UTIL}")
endfunction()

function(toolchain_setTargetOutputPath TARGET OUTPUT_PATH)
    get_filename_component(OUTPUT_PATH ${OUTPUT_PATH} ABSOLUTE)

    set_target_properties(${TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_PATH})
    set_target_properties(${TARGET} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_PATH})
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_PATH})

    add_custom_target(${TARGET}_path ALL COMMAND ${CMAKE_COMMAND} -E make_directory ${OUTPUT_PATH})
endfunction()

function(toolchain_showTargetConfig TARGET)
    get_property(LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)
    get_target_property(C_STANDARD ${TARGET} C_STANDARD)
    get_target_property(CXX_STANDARD ${TARGET} CXX_STANDARD)    
    get_target_property(COMPILATION_FLAGS ${TARGET} COMPILE_OPTIONS)
    get_target_property(ARCHIVE_OUTPUT ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
    get_target_property(LIBRARY_OUTPUT ${TARGET} LIBRARY_OUTPUT_DIRECTORY)
    get_target_property(RUNTIME_OUTPUT ${TARGET} RUNTIME_OUTPUT_DIRECTORY)

    if(NOT C_STANDARD)
        set(C_STANDARD "")
    endif()
    if(NOT CXX_STANDARD)
        set(CXX_STANDARD "")
    endif()
    if(NOT COMPILATION_FLAGS)
        set(COMPILATION_FLAGS "")
    endif()

    string(REGEX REPLACE ";" " " COMPILATION_FLAGS "${COMPILATION_FLAGS}")
    string(TOUPPER ${TARGET} TARGET)

    utils_log("'${TARGET}' compilation flags:")
    if(CMAKE_BUILD_TYPE MATCHES Debug)
        if("C" IN_LIST LANGUAGES)
            utils_log("  C std       : C${C_STANDARD}")
            utils_log("  CFLAGS      : ${COMPILATION_FLAGS} ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG}")
            utils_log("  C LDFLAGS   : ${CMAKE_C_LINK_FLAGS} ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
        endif()

        if("CXX" IN_LIST LANGUAGES)
            utils_log("  CXX std     : C++${CXX_STANDARD}")
            utils_log("  CXXFLAGS    : ${COMPILATION_FLAGS} ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}")
            utils_log("  CXX LDFLAGS : ${CMAKE_CXX_LINK_FLAGS} ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
        endif()
    else()
        if("C" IN_LIST LANGUAGES)
            utils_log("  C std       : C${C_STANDARD}")
            utils_log("  CFLAGS      : ${COMPILATION_FLAGS} ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE}")
            utils_log("  C LDFLAGS   : ${CMAKE_C_LINK_FLAGS} ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
        endif()

        if("CXX" IN_LIST LANGUAGES)
            utils_log("  CXX std     : C++${CXX_STANDARD}")
            utils_log("  CXXFLAGS    : ${COMPILATION_FLAGS} ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}")
            utils_log("  CXX LDFLAGS : ${CMAKE_CXX_LINK_FLAGS} ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
        endif()
    endif()

    utils_log("'${TARGET}' output paths:")
    utils_log("  Archive     : ${ARCHIVE_OUTPUT}")
    utils_log("  Library     : ${LIBRARY_OUTPUT}")
    utils_log("  Executable  : ${RUNTIME_OUTPUT}")
endfunction()
