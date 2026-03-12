cmake_minimum_required(VERSION 3.20.0)

project(mlir-tutorial LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ standard to conform to")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(BUILD_DEPS OFF CACHE BOOL "Build external dependencies")
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG OFF)

# Pin package locations to avoid filesystem search
set(MLIR_DIR "/home/marton/uni/onlab/llvm-project/build/lib/cmake/mlir"
    CACHE PATH "MLIR CMake directory")

set(LLVM_DIR "/home/marton/uni/onlab/llvm-project/build/lib/cmake/llvm"
    CACHE PATH "LLVM CMake directory")

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
list(APPEND MLIR_TABLEGEN_FLAGS
  -I${PROJECT_SOURCE_DIR}/include
)

if(BUILD_DEPS)
  include(FetchContent)

  set(FETCHCONTENT_UPDATES_DISCONNECTED ON CACHE BOOL
      "Do not update already-fetched dependencies during configure")

  FetchContent_Declare(
    or-tools
    GIT_REPOSITORY https://github.com/google/or-tools.git
    GIT_TAG        v9.11
  )

  message(STATUS "Fetching or-tools...")
  FetchContent_MakeAvailable(or-tools)
  message(STATUS "Done fetching or-tools")
endif()

add_subdirectory(tests)
add_subdirectory(tools)
add_subdirectory(lib)