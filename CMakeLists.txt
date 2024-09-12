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


if (NOT SKBUILD)
  message(WARNING "\
  This CMake file is meant to be executed using 'scikit-build'. Running
  it directly will almost certainly not produce the desired result. If
  you are a user trying to install this package, please use the command
  below, which will install all necessary build dependencies, compile
  the package in an isolated environment, and then install it.
  =====================================================================
   $ pip install .
  =====================================================================
  If you are a software developer, and this is your own package, then
  it is usually much more efficient to install the build dependencies
  in your environment once and use the following command that avoids
  a costly creation of a new virtual environment at every compilation:
  =====================================================================
   $ pip install nanobind scikit-build-core[pyproject]
   $ pip install --no-build-isolation -ve .
  =====================================================================
  You may optionally add -Ceditable.rebuild=true to auto-rebuild when
  the package is imported. Otherwise, you need to re-run the above
  after editing C++ files.")
endif()


include(CTest)

find_package(drake CONFIG REQUIRED)

# Try to import all Python components potentially needed by nanobind
find_package(Python 3.12
  REQUIRED COMPONENTS Interpreter Development.Module)
find_package(pybind11 CONFIG REQUIRED)

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)


# Add a library using FindPython's tooling (pybind11 also provides a helper like
# this)
pybind11_add_module(drake_extension_ext MODULE src/drake_extension_ext.cpp)
target_link_libraries(drake_extension_ext PUBLIC drake::drake)
set_target_properties(drake_extension_ext PROPERTIES CXX_VISIBILITY_PRESET default)

# This is passing in the version as a define just as an example
target_compile_definitions(drake_extension_ext PRIVATE VERSION_INFO=${PROJECT_VERSION})

# Install directive for scikit-build-core
install(TARGETS drake_extension_ext LIBRARY DESTINATION drake_extension)
