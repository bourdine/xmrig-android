cmake_minimum_required(VERSION 3.22.1)
project("miner")

# Устанавливаем стандарт C++
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Рекурсивно добавляем все исходные файлы XMRig
file(GLOB_RECURSE XMRIG_SOURCES
    "xmrig/src/*.cpp"
    "xmrig/src/*.c"
    "xmrig/src/3rdparty/*.cpp"
    "xmrig/src/3rdparty/*.c"
    "xmrig/src/backend/*.cpp"
    "xmrig/src/base/*.cpp"
    "xmrig/src/crypto/*.cpp"
    "xmrig/src/net/*.cpp"
    "xmrig/src/summary/*.cpp"
)

# Ваши JNI-файлы
list(APPEND MINER_SOURCES
    miner.cpp
    logging.cpp
    ${XMRIG_SOURCES}
)

add_library(miner SHARED ${MINER_SOURCES})

# Подключаем заголовочные файлы
target_include_directories(miner PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/xmrig/src
    ${CMAKE_CURRENT_SOURCE_DIR}/xmrig/src/3rdparty
)

# Подключаем необходимые библиотеки
find_library(LOG_LIB log)
target_link_libraries(miner
    android
    ${LOG_LIB}
    z  # для сжатия
    dl # dynamic linker
)

# Опции компиляции для XMRig
target_compile_options(miner PRIVATE
    -O3
    -funroll-loops
    -fomit-frame-pointer
    -DNDEBUG
    -DXMRIG_ARM
    -DXMRIG_64_BIT
    -DXMRIG_OS_ANDROID
)

# Для архитектуры ARM64
if(CMAKE_ANDROID_ARCH_ABI STREQUAL arm64-v8a)
    target_compile_options(miner PRIVATE -march=armv8.2a+crypto)
endif()
