#!/usr/bin/env bash
# Differential benchmark of one pom2k kernel: lowers the pipeline output without
# (old) and with (new) the custom fusion pass, links both into the kernel's
# generated harness, runs it and records the results. On gpu_a100 the harness
# also runs the kernel's native CUDA reference (<kernel dir>/cuda_ref.cu).
#
# Called through <kernel dir>/run_diff_benchmark.sh, which sets KERNEL and
# KERNEL_DIR. Usage:
#   run_diff_benchmark.sh --target cpu_parallel|gpu_a100 [--size IMxJMxKB] [--samples N]
#
# Exit codes: 0 PASS, 1 FAIL (outputs differ), 2 usage error, 3 lowering failed,
# 4 build failed, 5 harness crashed or errored, 6 no CUDA reference (gpu_a100).
set -uo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$LIB_DIR/../../.." && pwd)"
LLVM_BIN="$PROJECT_ROOT/externals/llvm-project/build/bin"
LLVM_LIB="$PROJECT_ROOT/externals/llvm-project/build/lib"
OMP_LIB_DIR="$PROJECT_ROOT/externals/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src"
COMPARE_DIR="$PROJECT_ROOT/src/loop_fusion/pom2k/compare"
CPU_LOWER_SCRIPT="$PROJECT_ROOT/scripts/build_src/pom2k/lower_cpu_to_llvm.sh"
GPU_LOWER_SCRIPT="$PROJECT_ROOT/scripts/build_src/pom2k/lower_gpu_a100_to_llvm.sh"
# The CUDA toolkit libmlir_cuda_runtime was built against (see the LLVM build's
# CMakeCache.txt, CUDAToolkit_BIN_DIR).
NVCC="${NVCC:-/home/shared/software/cuda/12.3/bin/nvcc}"

: "${KERNEL:?KERNEL must be set (use the kernel's run_diff_benchmark.sh)}"
: "${KERNEL_DIR:?KERNEL_DIR must be set (use the kernel's run_diff_benchmark.sh)}"

TARGET=""
SIZE="1024x1024x20"
SAMPLES="20"
usage() {
  echo "usage: $(basename "$0") --target cpu_parallel|gpu_a100 [--size IMxJMxKB] [--samples N]" >&2
}
while (($# > 0)); do
  case "$1" in
    --target) TARGET="${2-}"; shift 2 ;;
    --size) SIZE="${2-}"; shift 2 ;;
    --samples) SAMPLES="${2-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage; exit 2 ;;
  esac
done
case "$TARGET" in
  cpu_parallel) LOWER_SCRIPT="$CPU_LOWER_SCRIPT"; ARCH_DIR="cpu"; LL_SUFFIX="cpu"; HARNESS="diff_cpu_parallel.cpp" ;;
  gpu_a100) LOWER_SCRIPT="$GPU_LOWER_SCRIPT"; ARCH_DIR="gpu_a100"; LL_SUFFIX="gpu_a100"; HARNESS="diff_gpu_a100.cu" ;;
  *) echo "unsupported target '${TARGET}' (implemented: cpu_parallel, gpu_a100)" >&2; exit 2 ;;
esac

RESULTS_DIR="$KERNEL_DIR/results/diff_$TARGET"
RAW_DIR="$RESULTS_DIR/raw"
LOG_DIR="$RESULTS_DIR/logs"
mkdir -p "$RAW_DIR" "$LOG_DIR"
STAMP="$(date -u +"%Y%m%dT%H%M%SZ")"
TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
RAW_FILE="$RAW_DIR/${STAMP}.log"
TXT_OUT="$RESULTS_DIR/results_combined.txt"
CSV_OUT="$RESULTS_DIR/results_combined.csv"
BIN="$KERNEL_DIR/diff_${TARGET}.out"

CPU_MODEL="$(lscpu 2>/dev/null | awk -F: '/Model name:/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')"
CPU_MODEL="${CPU_MODEL:-unknown}"
GPU_MODEL=""
if [[ "$TARGET" == "gpu_a100" ]]; then
  GPU_MODEL="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -n 1)"
  GPU_MODEL="${GPU_MODEL:-unknown}"
fi

record() {
  local status="$1" mismatched="${2-}" old_ms="${3-}" new_ms="${4-}" speedup="${5-}"
  local cuda_ms="${6-}" speedup_cuda="${7-}"
  {
    echo "$KERNEL differential benchmark"
    echo "timestamp_utc: $TS"
    echo "target: $TARGET"
    echo "size: $SIZE"
    echo "samples: $SAMPLES"
    echo "cpu_model: $CPU_MODEL"
    [[ -n "$GPU_MODEL" ]] && echo "gpu_model: $GPU_MODEL"
    echo "status: $status"
    echo "raw_output_file: $RAW_FILE"
    echo "----------------------------------------------------------------"
    [[ -f "$RAW_FILE" ]] && cat "$RAW_FILE"
  } > "$TXT_OUT"
  if [[ "$TARGET" == "gpu_a100" ]]; then
    printf '%s\n' 'timestamp,kernel,target,size,samples,cpu_model,gpu_model,status,mismatched_arrays,old_median_ms,new_median_ms,cuda_median_ms,speedup,speedup_new_vs_cuda,raw_output_file' > "$CSV_OUT"
    printf '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"\n' \
      "$TS" "$KERNEL" "$TARGET" "$SIZE" "$SAMPLES" "$CPU_MODEL" "$GPU_MODEL" "$status" \
      "$mismatched" "$old_ms" "$new_ms" "$cuda_ms" "$speedup" "$speedup_cuda" "$RAW_FILE" >> "$CSV_OUT"
    echo "SUMMARY kernel=$KERNEL status=$status mismatched_arrays=${mismatched:-NA} old_median_ms=${old_ms:-NA} new_median_ms=${new_ms:-NA} cuda_median_ms=${cuda_ms:-NA} speedup=${speedup:-NA} speedup_new_vs_cuda=${speedup_cuda:-NA}"
    return
  fi
  printf '%s\n' 'timestamp,kernel,target,size,samples,cpu_model,status,mismatched_arrays,old_median_ms,new_median_ms,speedup,raw_output_file' > "$CSV_OUT"
  printf '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"\n' \
    "$TS" "$KERNEL" "$TARGET" "$SIZE" "$SAMPLES" "$CPU_MODEL" "$status" \
    "$mismatched" "$old_ms" "$new_ms" "$speedup" "$RAW_FILE" >> "$CSV_OUT"
  echo "SUMMARY kernel=$KERNEL status=$status mismatched_arrays=${mismatched:-NA} old_median_ms=${old_ms:-NA} new_median_ms=${new_ms:-NA} speedup=${speedup:-NA}"
}

if [[ "$TARGET" == "gpu_a100" && ! -f "$KERNEL_DIR/cuda_ref.cu" ]]; then
  echo "missing native CUDA reference $KERNEL_DIR/cuda_ref.cu" >&2
  record NO_CUDA_REF
  exit 6
fi

# Lower one variant and give its kernel symbol a variant suffix so that both
# variants can be linked into one binary. (On the GPU the embedded cubin and
# its loader are internal symbols, so only the entry point needs renaming.)
lower_variant() {
  local variant="$1"
  local input="$COMPARE_DIR/$variant/$KERNEL.mlir"
  local ll_dir="$PROJECT_ROOT/artifacts/llvm/pom2k/$ARCH_DIR/$variant"
  local mlir_dir="$PROJECT_ROOT/artifacts/mlir/pom2k/$ARCH_DIR/$variant"
  local ll="$ll_dir/${KERNEL}_${LL_SUFFIX}.ll"
  local renamed="$ll_dir/${KERNEL}_${LL_SUFFIX}_${variant}.ll"
  [[ -f "$input" ]] || { echo "missing $input" >&2; return 1; }
  OUTPUT_DIR_LL="$ll_dir" OUTPUT_DIR_MLIR="$mlir_dir" \
    "$LOWER_SCRIPT" "$input" > "$LOG_DIR/lower_${variant}.log" 2>&1 || return 1
  sed "s/@${KERNEL}(/@${KERNEL}_${variant}(/g" "$ll" > "$renamed" || return 1
  local defs remaining
  defs="$(grep -c "^define .*@${KERNEL}_${variant}(" "$renamed")"
  remaining="$(grep -c "@${KERNEL}(" "$renamed")"
  if [[ "$defs" != "1" || "$remaining" != "0" ]]; then
    echo "symbol rename failed in $renamed (definitions=$defs, leftovers=$remaining)" >&2
    return 1
  fi
  echo "$renamed"
}

echo "[$KERNEL] lowering old and new variants"
OLD_LL="$(lower_variant old)" || { record LOWER_FAIL; exit 3; }
NEW_LL="$(lower_variant new)" || { record LOWER_FAIL; exit 3; }

echo "[$KERNEL] building $BIN"
build_cpu() {
  "$LLVM_BIN/clang++" -std=c++17 -O3 "$KERNEL_DIR/$HARNESS" \
    "$OLD_LL" "$NEW_LL" -fopenmp=libomp -L"$OMP_LIB_DIR" -Wl,-rpath,"$OMP_LIB_DIR" \
    -o "$BIN"
}
# The LLVM build has no clang/opt, so the lowered host code is compiled with
# llc; the inputs still carry Polygeist's arm64-apple-macosx triple, which is
# overridden. The CUDA reference is compiled with the floating-point semantics
# of the MLIR NVVM lowering: no FMA contraction and libdevice's default
# (approximate) sqrt; division and denormal handling are IEEE in both.
build_gpu() {
  local old_obj="${OLD_LL%.ll}.o" new_obj="${NEW_LL%.ll}.o"
  local llc=("$LLVM_BIN/llc" -O3 -filetype=obj -relocation-model=pic -mtriple=x86_64-unknown-linux-gnu)
  "${llc[@]}" "$OLD_LL" -o "$old_obj" &&
  "${llc[@]}" "$NEW_LL" -o "$new_obj" &&
  "$NVCC" -std=c++17 -O3 -arch=sm_80 --fmad=false -prec-sqrt=false -prec-div=true \
    -ftz=false -Xcompiler -fopenmp -I"$LIB_DIR" \
    "$KERNEL_DIR/$HARNESS" "$KERNEL_DIR/cuda_ref.cu" "$old_obj" "$new_obj" \
    -L"$LLVM_LIB" -Xlinker -rpath -Xlinker "$LLVM_LIB" -lmlir_cuda_runtime -lcuda \
    -o "$BIN"
}
if [[ "$TARGET" == "gpu_a100" ]]; then build_fn=build_gpu; else build_fn=build_cpu; fi
if ! "$build_fn" > "$LOG_DIR/build.log" 2>&1; then
  cat "$LOG_DIR/build.log" >&2
  record BUILD_FAIL
  exit 4
fi

echo "[$KERNEL] running $BIN --size $SIZE --samples $SAMPLES"
"$BIN" --size "$SIZE" --samples "$SAMPLES" 2>&1 | tee "$RAW_FILE"
rc="${PIPESTATUS[0]}"

summary="$(grep '^SUMMARY ' "$RAW_FILE" | tail -n 1)"
field() { sed -nE "s/.* $1=([^ ]+).*/\1/p" <<< "$summary"; }
if [[ "$rc" == "0" || "$rc" == "1" ]] && [[ -n "$summary" ]]; then
  record "$(field status)" "$(field mismatched_arrays)" "$(field old_median_ms)" \
    "$(field new_median_ms)" "$(field speedup)" "$(field cuda_median_ms)" \
    "$(field speedup_new_vs_cuda)"
  exit "$rc"
fi
if (( rc > 128 )); then
  echo "harness terminated by signal $((rc - 128))" | tee -a "$RAW_FILE"
fi
record "CRASH(rc=$rc)"
exit 5
