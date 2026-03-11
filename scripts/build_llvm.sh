#!/usr/bin/env bash
set -e

read -r -p "Surely want to proceed (y/n)? " ans
case "$ans" in
  [nN]) echo "Aborting."; exit 1 ;;
  *) ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
BUILD_DIR="$PROJECT_ROOT/build"

cmake -G Ninja -S "$PROJECT_ROOT" -B "$BUILD_DIR" \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DMLIR_DIR=/home/marton/uni/onlab/llvm-project/build/lib/cmake/mlir \
  -DLLVM_DIR=/home/marton/uni/onlab/llvm-project/build/lib/cmake/llvm \
  -DLLVM_BUILD_EXAMPLES=ON \
  -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_CCACHE_BUILD=OFF

cmake --build "$BUILD_DIR" --target tutorial-opt -j12