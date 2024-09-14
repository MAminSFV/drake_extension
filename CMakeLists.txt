# Inspired and adapted from:
# https://github.com/wjakob/nanobind_example/blob/master/CMakeLists.txt
# and
# https://github.com/pybind/scikit_build_example/blob/master/CMakeLists.txt
cmake_minimum_required(VERSION 3.16...3.27)

# Scikit-build-core sets these values for you, or you can just hard-code the
# name and version.
project(drake_extension LANGUAGES CXX)

include(CTest)
option(RUN_X11_TESTS "Run tests that require X11" OFF)
find_package(drake CONFIG REQUIRED)
find_package(pybind11 CONFIG REQUIRED)

execute_process(COMMAND ${Python3_EXECUTABLE}-config --exec-prefix
  OUTPUT_VARIABLE PYTHON_EXEC_PREFIX
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
list(APPEND CMAKE_PREFIX_PATH "${PYTHON_EXEC_PREFIX}")

get_filename_component(PYTHONPATH
  "${drake_DIR}/../../python${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}/site-packages"
  REALPATH
)

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)


# Add a library using FindPython's tooling (pybind11 also provides a helper like
# this)
pybind11_add_module(drake_extension MODULE src/drake_extension.cpp)
target_link_libraries(drake_extension PUBLIC drake::drake)
set_target_properties(drake_extension PROPERTIES CXX_VISIBILITY_PRESET default)
