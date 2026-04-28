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

read -r -p "Surely want to proceed (y/n)? " ans
case "$ans" in
  [nN]) echo "Aborting."; exit 1 ;;
  *) ;;
esac

JOBS=$(( $(nproc --all) - CPU_OFFSET ))
if [[ $JOBS -lt 1 ]]; then
  echo "Error: --cpu-offset $CPU_OFFSET leaves 0 or fewer jobs (total cores: $(nproc --all))"; exit 1
fi
echo "Building with $JOBS jobs (cores: $(nproc --all), offset: $CPU_OFFSET)"



SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"          # parent of scripts/
LLVM_SRC_DIR="$(cd "${SCRIPT_DIR}/../../llvm" && pwd)"

cmake -G Ninja -S "$LLVM_SRC_DIR" -B "$BUILD_DIR" \
  -DCMAKE_INSTALL_PREFIX=/home/mkozma/.local/ \
  -DLLVM_ENABLE_PROJECTS="mlir" \
  -DLLVM_BUILD_EXAMPLES=ON \
  -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_CUDA_COMPILER=nvcc \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_CCACHE_BUILD=OFF \
  -DMLIR_ENABLE_CUDA_RUNNER=ON \
  -DMLIR_ENABLE_EXECUTION_ENGINE=ON \
  -DPARTIAL_SOURCES_INTENDED=ON

cmake --build "$BUILD_DIR" --target check-mlir -j"$JOBS"

