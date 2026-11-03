#!/usr/bin/env bash
# nsys profile of one pom2k kernel's differential GPU harness (old / new / cuda).
# Mirrors examples/pom2k/lib/run_diff_kernel.sh (same lowering + nvcc flags),
# but builds a copy of the generated harness with NVTX ranges around every
# timed call, so kernels can be attributed to a variant (old and new MLIR
# kernels have identical names). Nothing in the repo is modified.
#
# usage: profile_one.sh <kernel dir> <out dir> [size] [samples]
set -euo pipefail

KERNEL_DIR="$(cd "$1" && pwd)"
OUT="$2"
SIZE="${3:-1024x1024x20}"
SAMPLES="${4:-20}"
PROJECT_ROOT=/home/mkozma/mlir_onlab
LLVM_BIN="$PROJECT_ROOT/externals/llvm-project/build/bin"
LLVM_LIB="$PROJECT_ROOT/externals/llvm-project/build/lib"
COMPARE_DIR="$PROJECT_ROOT/src/loop_fusion/pom2k/compare"
LOWER="$PROJECT_ROOT/scripts/build_src/pom2k/lower_gpu_a100_to_llvm.sh"
LIB_DIR="$PROJECT_ROOT/examples/pom2k/lib"
CUDA=/home/shared/software/cuda/12.3
NVCC="$CUDA/bin/nvcc"
# nsys 2023.3.3 (CUDA 12.3) aborts on several of these harnesses with "Can't
# find UUID for CUDA device 0"; 2023.2.3 (CUDA 12.2) does not.
NSYS="${NSYS:-/home/shared/software/cuda/12.2/bin/nsys}"

KERNEL="$(sed -nE 's/.*KERNEL="([^"]+)".*/\1/p' "$KERNEL_DIR/run_diff_benchmark.sh")"
BUILD="$OUT/build/$KERNEL"
mkdir -p "$BUILD" "$OUT/rep" "$OUT/logs"
LOG="$OUT/logs/$KERNEL.log"
: > "$LOG"

objs=()
for variant in old new; do
  d="$BUILD/$variant"
  mkdir -p "$d"
  OUTPUT_DIR_LL="$d" OUTPUT_DIR_MLIR="$d" "$LOWER" "$COMPARE_DIR/$variant/$KERNEL.mlir" >> "$LOG" 2>&1 \
    || { echo "LOWER_FAIL $KERNEL $variant"; exit 3; }
  sed "s/@${KERNEL}(/@${KERNEL}_${variant}(/g" "$d/${KERNEL}_gpu_a100.ll" > "$d/${KERNEL}_${variant}.ll"
  "$LLVM_BIN/llc" -O3 -filetype=obj -relocation-model=pic -mtriple=x86_64-unknown-linux-gnu \
    "$d/${KERNEL}_${variant}.ll" -o "$d/${KERNEL}_${variant}.o" >> "$LOG" 2>&1
  objs+=("$d/${KERNEL}_${variant}.o")
done

# NVTX range per timed call (warm-up included; the analysis drops it).
H="$BUILD/diff_gpu_a100_nvtx.cu"
sed -e 's|#include <cuda_runtime.h>|#include <cuda_runtime.h>\n#include <nvtx3/nvToolsExt.h>|' \
    -e 's|^    callKernel(v, set);$|    nvtxRangePushA(kVariantNames[v]);\n    callKernel(v, set);\n    nvtxRangePop();|' \
    "$KERNEL_DIR/diff_gpu_a100.cu" > "$H"
[[ "$(grep -c 'nvtxRangePushA' "$H")" == "1" ]] || { echo "PATCH_FAIL $KERNEL"; exit 4; }

BIN="$BUILD/diff_gpu_a100_nvtx.out"
"$NVCC" -std=c++17 -O3 -arch=sm_80 --fmad=false -prec-sqrt=false -prec-div=true \
  -ftz=false -Xcompiler -fopenmp -I"$LIB_DIR" -I"$CUDA/include" \
  "$H" "$KERNEL_DIR/cuda_ref.cu" "${objs[@]}" \
  -L"$LLVM_LIB" -Xlinker -rpath -Xlinker "$LLVM_LIB" -lmlir_cuda_runtime -lcuda \
  -o "$BIN" >> "$LOG" 2>&1 || { echo "BUILD_FAIL $KERNEL"; exit 4; }

REP="$OUT/rep/$KERNEL"
"$NSYS" profile -t cuda,nvtx --sample=none --cpuctxsw=none --force-overwrite=true \
  -o "$REP" "$BIN" --size "$SIZE" --samples "$SAMPLES" > "$OUT/logs/$KERNEL.stdout" 2>&1 || true
grep '^SUMMARY' "$OUT/logs/$KERNEL.stdout" || { echo "RUN_FAIL $KERNEL"; exit 5; }
"$NSYS" export -t sqlite --force-overwrite=true -o "$REP.sqlite" "$REP.nsys-rep" >> "$LOG" 2>&1
echo "OK $KERNEL"
