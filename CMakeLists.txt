cmake_minimum_required(VERSION 3.16)
project(drake_extension CXX)

# N.B. This is a temporary flag. It only really applies to Linux, as Mac
# does not need X11.
option(RUN_X11_TESTS "Run tests that require X11" OFF)

include(CTest)

find_package(drake CONFIG REQUIRED)
find_package(pybind11 CONFIG REQUIRED)

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

pybind11_add_module(custom_system MODULE src/custom_system.cc)
target_link_libraries(custom_system PUBLIC drake::drake)
set_target_properties(custom_system PROPERTIES CXX_VISIBILITY_PRESET default)
target_compile_definitions(custom_system
                           PRIVATE VERSION_INFO=${EXAMPLE_VERSION_INFO})
