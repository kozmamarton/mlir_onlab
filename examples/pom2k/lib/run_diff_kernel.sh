#!/usr/bin/env bash
# Differential benchmark of one pom2k kernel: lowers the pipeline output without
# (old) and with (new) the custom fusion pass, links both into the kernel's
# generated harness, runs it and records the results.
#
# Called through <kernel dir>/run_diff_benchmark.sh, which sets KERNEL and
# KERNEL_DIR. Usage:
#   run_diff_benchmark.sh --target cpu_parallel [--size IMxJMxKB] [--samples N]
#
# Exit codes: 0 PASS, 1 FAIL (outputs differ), 2 usage error, 3 lowering failed,
# 4 build failed, 5 harness crashed or errored.
set -uo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$LIB_DIR/../../.." && pwd)"
LLVM_BIN="$PROJECT_ROOT/externals/llvm-project/build/bin"
OMP_LIB_DIR="$PROJECT_ROOT/externals/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src"
COMPARE_DIR="$PROJECT_ROOT/src/loop_fusion/pom2k/compare"
CPU_LOWER_SCRIPT="$PROJECT_ROOT/scripts/build_src/pom2k/lower_cpu_to_llvm.sh"

: "${KERNEL:?KERNEL must be set (use the kernel's run_diff_benchmark.sh)}"
: "${KERNEL_DIR:?KERNEL_DIR must be set (use the kernel's run_diff_benchmark.sh)}"

TARGET=""
SIZE="1024x1024x20"
SAMPLES="20"
usage() {
  echo "usage: $(basename "$0") --target cpu_parallel [--size IMxJMxKB] [--samples N]" >&2
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
if [[ "$TARGET" != "cpu_parallel" ]]; then
  echo "unsupported target '${TARGET}' (implemented: cpu_parallel)" >&2
  exit 2
fi

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

record() {
  local status="$1" mismatched="${2-}" old_ms="${3-}" new_ms="${4-}" speedup="${5-}"
  {
    echo "$KERNEL differential benchmark"
    echo "timestamp_utc: $TS"
    echo "target: $TARGET"
    echo "size: $SIZE"
    echo "samples: $SAMPLES"
    echo "cpu_model: $CPU_MODEL"
    echo "status: $status"
    echo "raw_output_file: $RAW_FILE"
    echo "----------------------------------------------------------------"
    [[ -f "$RAW_FILE" ]] && cat "$RAW_FILE"
  } > "$TXT_OUT"
  printf '%s\n' 'timestamp,kernel,target,size,samples,cpu_model,status,mismatched_arrays,old_median_ms,new_median_ms,speedup,raw_output_file' > "$CSV_OUT"
  printf '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"\n' \
    "$TS" "$KERNEL" "$TARGET" "$SIZE" "$SAMPLES" "$CPU_MODEL" "$status" \
    "$mismatched" "$old_ms" "$new_ms" "$speedup" "$RAW_FILE" >> "$CSV_OUT"
  echo "SUMMARY kernel=$KERNEL status=$status mismatched_arrays=${mismatched:-NA} old_median_ms=${old_ms:-NA} new_median_ms=${new_ms:-NA} speedup=${speedup:-NA}"
}

# Lower one variant and give its kernel symbol a variant suffix so that both
# variants can be linked into one binary.
lower_variant() {
  local variant="$1"
  local input="$COMPARE_DIR/$variant/$KERNEL.mlir"
  local ll_dir="$PROJECT_ROOT/artifacts/llvm/pom2k/cpu/$variant"
  local mlir_dir="$PROJECT_ROOT/artifacts/mlir/pom2k/cpu/$variant"
  local ll="$ll_dir/${KERNEL}_cpu.ll"
  local renamed="$ll_dir/${KERNEL}_cpu_${variant}.ll"
  [[ -f "$input" ]] || { echo "missing $input" >&2; return 1; }
  OUTPUT_DIR_LL="$ll_dir" OUTPUT_DIR_MLIR="$mlir_dir" \
    "$CPU_LOWER_SCRIPT" "$input" > "$LOG_DIR/lower_${variant}.log" 2>&1 || return 1
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
if ! "$LLVM_BIN/clang++" -std=c++17 -O3 "$KERNEL_DIR/diff_${TARGET}.cpp" \
    "$OLD_LL" "$NEW_LL" -fopenmp=libomp -L"$OMP_LIB_DIR" -Wl,-rpath,"$OMP_LIB_DIR" \
    -o "$BIN" > "$LOG_DIR/build.log" 2>&1; then
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
    "$(field new_median_ms)" "$(field speedup)"
  exit "$rc"
fi
if (( rc > 128 )); then
  echo "harness terminated by signal $((rc - 128))" | tee -a "$RAW_FILE"
fi
record "CRASH(rc=$rc)"
exit 5
