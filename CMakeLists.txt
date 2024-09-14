# Inspired and adapted from:
# https://github.com/wjakob/nanobind_example/blob/master/CMakeLists.txt
# and
# https://github.com/pybind/scikit_build_example/blob/master/CMakeLists.txt
cmake_minimum_required(VERSION 3.16...3.27)

# Scikit-build-core sets these values for you, or you can just hard-code the
# name and version.
project(
  ${SKBUILD_PROJECT_NAME}
  VERSION ${SKBUILD_PROJECT_VERSION}
  LANGUAGES CXX)

include(CTest)
option(RUN_X11_TESTS "Run tests that require X11" OFF)
find_package(drake CONFIG REQUIRED)

execute_process(COMMAND ${Python3_EXECUTABLE}-config --exec-prefix
  OUTPUT_VARIABLE PYTHON_EXEC_PREFIX
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
list(APPEND CMAKE_PREFIX_PATH "${PYTHON_EXEC_PREFIX}")

get_filename_component(PYTHONPATH
  "${drake_DIR}/../../python${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}/site-packages"
  REALPATH
)

# Find the module development requirements (requires FindPython from 3.17 or
# scikit-build-core's built-in backport)
find_package(Python REQUIRED COMPONENTS Interpreter Development.Module)
find_package(pybind11 CONFIG REQUIRED)

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)


# Add a library using FindPython's tooling (pybind11 also provides a helper like
# this)
python_add_library(_ext MODULE src/ext.cpp WITH_SOABI)
target_link_libraries(_ext PUBLIC drake::drake pybind11::headers)
set_target_properties(_ext PROPERTIES CXX_VISIBILITY_PRESET default)

# This is passing in the version as a define just as an example
target_compile_definitions(_ext PRIVATE VERSION_INFO=${PROJECT_VERSION})

# The install directory is the output (wheel) directory
install(TARGETS _ext DESTINATION drake_extension)
