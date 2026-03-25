cmake_minimum_required(VERSION 3.20.0)

project(mlir-tutorial LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ standard to conform to")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(BUILD_DEPS OFF CACHE BOOL "Build external dependencies")
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG OFF)

# Resolve package locations relative to this repository by default.
set(_LLVM_BUILD_DIR "${PROJECT_SOURCE_DIR}/externals/llvm-project/build")
set(_DEFAULT_MLIR_DIR "${_LLVM_BUILD_DIR}/lib/cmake/mlir")
set(_DEFAULT_LLVM_DIR "${_LLVM_BUILD_DIR}/lib/cmake/llvm")

if(NOT DEFINED MLIR_DIR OR MLIR_DIR STREQUAL "")
  set(MLIR_DIR "${_DEFAULT_MLIR_DIR}" CACHE PATH "MLIR CMake directory")
else()
  set(MLIR_DIR "${MLIR_DIR}" CACHE PATH "MLIR CMake directory")
endif()

if(NOT DEFINED LLVM_DIR OR LLVM_DIR STREQUAL "")
  set(LLVM_DIR "${_DEFAULT_LLVM_DIR}" CACHE PATH "LLVM CMake directory")
else()
  set(LLVM_DIR "${LLVM_DIR}" CACHE PATH "LLVM CMake directory")
endif()

find_package(LLVM REQUIRED CONFIG)
find_package(MLIR REQUIRED CONFIG)

# Prevent repeated evaluation in subdirectories
set(MLIR_DIR ${MLIR_DIR} CACHE INTERNAL "")
set(LLVM_DIR ${LLVM_DIR} CACHE INTERNAL "")
set(PROJECT_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)

message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")

include(AddLLVM)
include(AddMLIR)
include(TableGen)

include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/externals/llvm-project)
include_directories(${PROJECT_BINARY_DIR})
include_directories(${PROJECT_SOURCE_DIR}/include)
include_directories(${PROJECT_BINARY_DIR}/lib)
list(APPEND MLIR_TABLEGEN_FLAGS
  -I${PROJECT_SOURCE_DIR}/include
)

if(NOT BUILD_DEPS)
  find_package(ortools CONFIG QUIET)
endif()

if(NOT ortools_FOUND)
  include(FetchContent)
  set(FETCHCONTENT_UPDATES_DISCONNECTED ON CACHE BOOL
      "Do not update already-fetched dependencies during configure")
  FetchContent_Declare(
    or-tools
    GIT_REPOSITORY https://github.com/google/or-tools.git
    GIT_TAG        v9.11
  )
  # OR-Tools uses BUILD_DEPS internally to decide whether to fetch its own
  # transitive deps (absl, protobuf, re2, eigen, etc.). Force it ON so they
  # are built from source rather than required as system packages.
  set(BUILD_DEPS ON CACHE BOOL "" FORCE)
  message(STATUS "or-tools not found on system, fetching from source...")
  FetchContent_MakeAvailable(or-tools)
  message(STATUS "Done fetching or-tools")
else()
  message(STATUS "Found system or-tools: ${ortools_DIR}")
endif()

add_subdirectory(tests)
add_subdirectory(tools)
add_subdirectory(lib)