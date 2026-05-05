#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../" && pwd)"

EXAMPLE_CPP="${EXAMPLE_CPP:-$SCRIPT_DIR/pom2k_amd.cpp}"
EXAMPLE_LL="${EXAMPLE_LL:-$SCRIPT_DIR/ext_add_ad_2d_amd.ll}"
BUILD_DIR="${BUILD_DIR:-$PROJECT_ROOT/externals/llvm-project/build}"
MLIR_LIBDIR="${MLIR_LIBDIR:-$BUILD_DIR/lib}"
ROCM_PATH="${ROCM_PATH:-/opt/rocm}"
OUT_BIN="${OUT_BIN:-$SCRIPT_DIR/bench_gpu_amd.out}"
CLANGXX="${CLANGXX:-$BUILD_DIR/bin/clang++}"

if [[ ! -f "$EXAMPLE_CPP" ]]; then
  echo "Missing source file: $EXAMPLE_CPP" >&2
  exit 1
fi

if [[ ! -f "$EXAMPLE_LL" ]]; then
  echo "Missing LLVM IR file: $EXAMPLE_LL" >&2
  exit 1
fi

# The generated wrapper registers a global dtor that unloads the module at process teardown.
# That can fire after runtime shutdown and produce a benign unload error.
TMP_LL="$(mktemp /tmp/ext_add_ad_2d_amd.XXXXXX.ll)"
trap 'rm -f "$TMP_LL"' EXIT
cp "$EXAMPLE_LL" "$TMP_LL"
sed -i '/@llvm.global_dtors = appending global/d' "$TMP_LL"

echo "[1/3] Checking required MLIR runtime libs"
for lib in libmlir_rocm_runtime libmlir_runner_utils libmlir_c_runner_utils; do
  if ! compgen -G "$MLIR_LIBDIR/${lib}.so*" > /dev/null && \
     ! compgen -G "$BUILD_DIR/lib/${lib}.so*" > /dev/null; then
    echo "Missing ${lib}.so in MLIR_LIBDIR=$MLIR_LIBDIR or BUILD_DIR/lib=$BUILD_DIR/lib" >&2
    echo "This build needs LLVM/MLIR configured with -DMLIR_ENABLE_ROCM_RUNNER=ON." >&2
    exit 1
  fi
done

echo "[2/3] Checking ROCm user-space runtime"
if [[ ! -d "$ROCM_PATH" ]]; then
  echo "ROCM_PATH not found: $ROCM_PATH" >&2
  echo "Install ROCm userspace (HIP runtime) and/or set ROCM_PATH." >&2
  exit 1
fi

echo "[3/3] Building AMD benchmark executable"
"$CLANGXX" -std=c++17 -O3 "$EXAMPLE_CPP" "$TMP_LL" \
  -L"$MLIR_LIBDIR" \
  -Wl,-rpath,"$MLIR_LIBDIR" \
  -L"$BUILD_DIR/lib" \
  -Wl,-rpath,"$BUILD_DIR/lib" \
  -L"$ROCM_PATH/lib" \
  -L"$ROCM_PATH/lib64" \
  -Wl,-rpath,"$ROCM_PATH/lib" \
  -Wl,-rpath,"$ROCM_PATH/lib64" \
  -lmlir_rocm_runtime -lmlir_runner_utils -lmlir_c_runner_utils \
  -ldl -lpthread \
  -o "$OUT_BIN"

echo "Built: $OUT_BIN"
echo "Run:   $OUT_BIN"
