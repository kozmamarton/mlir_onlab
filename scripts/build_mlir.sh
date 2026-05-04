#!/usr/bin/env bash
set -e

CPU_OFFSET=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --cpu-offset)
      CPU_OFFSET="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"; exit 1 ;;
  esac
done

JOBS=$(( $(nproc --all) - CPU_OFFSET ))
if [[ $JOBS -lt 1 ]]; then
  echo "Error: --cpu-offset $CPU_OFFSET leaves 0 or fewer jobs (total cores: $(nproc --all))"; exit 1
fi
echo "Building with $JOBS jobs (cores: $(nproc --all), offset: $CPU_OFFSET)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
BUILD_DIR="$PROJECT_ROOT/build"

cmake -G Ninja -S "$PROJECT_ROOT" -B "$BUILD_DIR" \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DMLIR_DIR=$PROJECT_ROOT/externals/llvm-project/build/lib/cmake/mlir \
  -DLLVM_DIR=$PROJECT_ROOT/externals/llvm-project/build/lib/cmake/llvm \
  -DLLVM_BUILD_EXAMPLES=ON \
  -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_CCACHE_BUILD=OFF \
  -DFETCHCONTENT_UPDATES_DISCONNECTED=ON

cmake  --build "$BUILD_DIR" --target tutorial-opt -j"$JOBS"
