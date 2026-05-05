#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

INPUT_MLIR="${INPUT_MLIR:-$PROJECT_ROOT/src/loop_fusion/pom2k/ext_add_ad_2d_.mlir}"
LOWER_SCRIPT="${LOWER_SCRIPT:-$PROJECT_ROOT/scripts/build_src/pom2k/lower_gpu_to_llvm.sh}"
GENERATED_LL="${GENERATED_LL:-$PROJECT_ROOT/artifacts/llvm/pom2k/ext_add_ad_2d_.ll}"
EXAMPLE_LL="${EXAMPLE_LL:-$SCRIPT_DIR/ext_add_ad_2d_.ll}"

CUDA_ROOT="${CUDA_ROOT:-${CUDA_HOME:-/home/shared/software/cuda/12.3}}"
MLIR_LIBDIR="${MLIR_LIBDIR:-$HOME/.local/shared/lib}"
BUILD_DIR="${BUILD_DIR:-$PROJECT_ROOT/externals/llvm-project/build}"
OUT_BIN="${OUT_BIN:-$SCRIPT_DIR/bench_gpu_nvcc.out}"

echo "[1/3] Lowering to NVVM/LLVM with sm_80"
"$LOWER_SCRIPT" "$INPUT_MLIR"

if [[ -f "$GENERATED_LL" ]]; then
  cp "$GENERATED_LL" "$EXAMPLE_LL"
fi

# The generated CUDA wrapper registers a global dtor that unloads the module at
# process teardown. In this benchmark that can run after CUDA teardown has
# started, which produces a spurious cuModuleUnload failure despite a correct run.
sed -i '/@llvm.global_dtors = appending global/d' "$EXAMPLE_LL"

echo "[2/3] Checking required runtime libs"
for lib in libmlir_cuda_runtime libmlir_runner_utils libmlir_c_runner_utils; do
  if ! compgen -G "$MLIR_LIBDIR/${lib}.so*" > /dev/null && \
     ! compgen -G "$BUILD_DIR/lib/${lib}.so*" > /dev/null; then
    echo "Missing ${lib}.so in MLIR_LIBDIR=$MLIR_LIBDIR or BUILD_DIR/lib=$BUILD_DIR/lib" >&2
    echo "Set MLIR_LIBDIR or BUILD_DIR and retry." >&2
    exit 1
  fi
done

echo "[3/3] Building benchmark executable"
clang++ -std=c++17 -O2 "$SCRIPT_DIR/pom2k.cpp" "$EXAMPLE_LL" \
  -I"$CUDA_ROOT/include" \
  -L"$CUDA_ROOT/lib64" \
  -Wl,-rpath,"$CUDA_ROOT/lib64" \
  -L"$MLIR_LIBDIR" \
  -Wl,-rpath,"$MLIR_LIBDIR" \
  -L"$BUILD_DIR/lib" \
  -Wl,-rpath,"$BUILD_DIR/lib" \
  -lmlir_cuda_runtime -lmlir_runner_utils -lmlir_c_runner_utils \
  -lcudart -lcuda -ldl -lpthread \
  -o "$OUT_BIN"

echo "Built: $OUT_BIN"
echo "Run:   $OUT_BIN"
