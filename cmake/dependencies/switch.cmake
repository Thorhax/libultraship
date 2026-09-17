include(FetchContent)

set(USE_OPENGLES ON CACHE BOOL "Enable GLES3" FORCE)
set(SPDLOG_FWRITE_UNLOCKED OFF CACHE BOOL "" FORCE)
set(DISABLE_DLL_LOADER ON CACHE BOOL "Disable dynamic library loading support" FORCE)

add_compile_definitions(
    USE_OPENGLES=1
    DISABLE_DLL_LOADER=1
    _GNU_SOURCE=1
    FMT_USE_FALLBACK_FILE=1
    IMGUI_DISABLE_DEFAULT_SHELL_FUNCTIONS=1
)

find_package(SDL2 REQUIRED)

find_package(nlohmann_json QUIET)
if (NOT ${nlohmann_json_FOUND})
    FetchContent_Declare(
        nlohmann_json
        GIT_REPOSITORY https://github.com/nlohmann/json.git
        GIT_TAG v3.12.0
        GIT_SHALLOW TRUE
        OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(nlohmann_json)
endif()

find_package(tinyxml2 QUIET)
if (NOT ${tinyxml2_FOUND})
    set(tinyxml2_BUILD_TESTING OFF)
    FetchContent_Declare(
        tinyxml2
        GIT_REPOSITORY https://github.com/leethomason/tinyxml2.git
        GIT_TAG 11.0.0
        GIT_SHALLOW TRUE
        OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(tinyxml2)
endif()

find_package(spdlog QUIET)
if (NOT ${spdlog_FOUND})
    FetchContent_Declare(
        spdlog
        GIT_REPOSITORY https://github.com/gabime/spdlog.git
        GIT_TAG v1.16.0
        GIT_SHALLOW TRUE
        OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(spdlog)
endif()

find_package(libzip QUIET)
if (NOT ${libzip_FOUND})
    set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)
    set(BUILD_TOOLS OFF)
    set(BUILD_REGRESS OFF)
    set(BUILD_EXAMPLES OFF)
    set(BUILD_DOC OFF)
    set(BUILD_OSSFUZZ OFF)
    set(BUILD_SHARED_LIBS OFF)
    set(ENABLE_BZIP2 OFF)
    set(ENABLE_LZMA OFF)
    set(ENABLE_ZSTD OFF)
    set(ENABLE_COMMONCRYPTO OFF)
    set(ENABLE_GNUTLS OFF)
    set(ENABLE_MBEDTLS OFF)
    set(ENABLE_OPENSSL OFF)
    FetchContent_Declare(
        libzip
        GIT_REPOSITORY https://github.com/nih-at/libzip.git
        GIT_TAG v1.11.4
        GIT_SHALLOW TRUE
        OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(libzip)
    list(APPEND ADDITIONAL_LIB_INCLUDES ${libzip_SOURCE_DIR}/lib ${libzip_BINARY_DIR})
endif()

target_include_directories(ImGui PUBLIC ${DEVKITPRO}/portlibs/switch/include)
target_compile_definitions(ImGui PUBLIC IMGUI_IMPL_OPENGL_ES3 IMGUI_DISABLE_DEFAULT_SHELL_FUNCTIONS)
target_link_libraries(ImGui PUBLIC SDL2::SDL2 EGL GLESv2 glapi drm_nouveau)
