#!/usr/bin/env bash
# Runs the differential benchmark of every pom2k kernel on one target.
#
# For each kernel: regenerates the pipeline output without (old) and with (new)
# the custom fusion pass into src/loop_fusion/pom2k/compare/{old,new}, regenerates
# the kernel's harness, then calls <kernel dir>/run_diff_benchmark.sh. Kernels
# run one at a time to bound memory use. A summary is written to
# examples/pom2k/results/<target>/.
#
# Usage:
#   run_all_benchmarks.sh --target cpu_parallel [--size IMxJMxKB] [--samples N]
#                         [--kernels k1,k2,...] [--skip-apply]
#
#   --kernels     default: the CASES list of apply_loop_fusion_pom2k.sh
#   --skip-apply  reuse the existing compare/{old,new} outputs
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
APPLY_SCRIPT="$PROJECT_ROOT/scripts/build_src/pom2k/apply_loop_fusion_pom2k.sh"
INPUT_DIR="$PROJECT_ROOT/src/pom2k_generated_affine_loops/mlir"
COMPARE_DIR="$PROJECT_ROOT/src/loop_fusion/pom2k/compare"

TARGET=""
SIZE="1024x1024x20"
SAMPLES="20"
KERNELS=""
SKIP_APPLY=0
usage() {
  sed -n '2,15p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}
while (($# > 0)); do
  case "$1" in
    --target) TARGET="${2-}"; shift 2 ;;
    --size) SIZE="${2-}"; shift 2 ;;
    --samples) SAMPLES="${2-}"; shift 2 ;;
    --kernels) KERNELS="${2-}"; shift 2 ;;
    --skip-apply) SKIP_APPLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage; exit 2 ;;
  esac
done
case "$TARGET" in
  cpu_parallel) ;;
  "") echo "--target is required (implemented: cpu_parallel)" >&2; exit 2 ;;
  *) echo "target '$TARGET' is not implemented yet (implemented: cpu_parallel)" >&2; exit 2 ;;
esac

if [[ -n "$KERNELS" ]]; then
  IFS=',' read -r -a kernel_list <<< "$KERNELS"
else
  mapfile -t kernel_list < <(awk '/^CASES=\(/{f=1} /^all_cases_unused/{f=0} f' "$APPLY_SCRIPT" \
    | grep -oE 'ext_[A-Za-z0-9_]+\.mlir' | sed 's/\.mlir$//' | awk '!seen[$0]++')
fi

RESULTS_DIR="$SCRIPT_DIR/results/$TARGET"
STAMP="$(date -u +"%Y%m%dT%H%M%SZ")"
LOG_DIR="$RESULTS_DIR/logs_$STAMP"
SUMMARY_TXT="$RESULTS_DIR/summary_$STAMP.txt"
SUMMARY_CSV="$RESULTS_DIR/summary_$STAMP.csv"
mkdir -p "$LOG_DIR" "$COMPARE_DIR/old" "$COMPARE_DIR/new"

declare -A status mismatched old_ms new_ms speedup kdir

if (( ! SKIP_APPLY )); then
  echo "[apply] regenerating compare/old and compare/new for ${#kernel_list[@]} kernels"
  for k in "${kernel_list[@]}"; do
    input="$INPUT_DIR/$k.mlir"
    if [[ ! -f "$input" ]]; then
      status[$k]="NO_INPUT"; continue
    fi
    if ! DISABLE_CUSTOM_FUSION=1 OUTPUT_DIR="$COMPARE_DIR/old" \
           "$APPLY_SCRIPT" -f "$input" > "$LOG_DIR/apply_old_$k.log" 2>&1 ||
       ! OUTPUT_DIR="$COMPARE_DIR/new" \
           "$APPLY_SCRIPT" -f "$input" > "$LOG_DIR/apply_new_$k.log" 2>&1; then
      status[$k]="APPLY_FAIL"
    fi
  done
fi

echo "[generate] harnesses"
gen_kernels=()
for k in "${kernel_list[@]}"; do
  [[ -n "${status[$k]-}" ]] && continue
  if ! grep -q "func.func @$k(" "$COMPARE_DIR/new/$k.mlir" 2>/dev/null; then
    status[$k]="NO_FUNCTION"; continue
  fi
  gen_kernels+=("$k")
done
for k in "${gen_kernels[@]}"; do
  if out="$(python3 "$SCRIPT_DIR/generate_benchmarks.py" "$k" 2>&1)"; then
    kdir[$k]="$PROJECT_ROOT/${out#"$k: "}"
  else
    echo "$out" | tee "$LOG_DIR/generate_$k.log" >&2
    status[$k]="GENERATE_FAIL"
  fi
done

for k in "${kernel_list[@]}"; do
  [[ -n "${status[$k]-}" ]] && { echo "[$k] skipped: ${status[$k]}"; continue; }
  echo ""
  echo "================ $k ================"
  "${kdir[$k]}/run_diff_benchmark.sh" --target "$TARGET" --size "$SIZE" \
    --samples "$SAMPLES" 2>&1 | tee "$LOG_DIR/run_$k.log"
  line="$(grep '^SUMMARY ' "$LOG_DIR/run_$k.log" | tail -n 1)"
  get() { sed -nE "s/.* $1=([^ ]+).*/\1/p" <<< "$line"; }
  status[$k]="$(get status)"; status[$k]="${status[$k]:-ERROR}"
  mismatched[$k]="$(get mismatched_arrays)"
  old_ms[$k]="$(get old_median_ms)"; new_ms[$k]="$(get new_median_ms)"; speedup[$k]="$(get speedup)"
done

CPU_MODEL="$(lscpu 2>/dev/null | awk -F: '/Model name:/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')"
{
  echo "pom2k differential benchmarks (old = without custom fusion pass, new = with it)"
  echo "generated_at_utc: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "target: $TARGET"
  echo "size: $SIZE"
  echo "samples: $SAMPLES"
  echo "cpu_model: ${CPU_MODEL:-unknown}"
  echo "logs: $LOG_DIR"
  echo ""
  printf '%-34s %-14s %-10s %12s %12s %8s\n' kernel status mismatched old_median_ms new_median_ms speedup
  for k in "${kernel_list[@]}"; do
    printf '%-34s %-14s %-10s %12s %12s %8s\n' "$k" "${status[$k]}" "${mismatched[$k]:--}" \
      "${old_ms[$k]:--}" "${new_ms[$k]:--}" "${speedup[$k]:--}"
  done
  echo ""
  for s in PASS FAIL; do
    n=0; for k in "${kernel_list[@]}"; do [[ "${status[$k]}" == "$s" ]] && n=$((n + 1)); done
    echo "$s: $n"
  done
  n=0; for k in "${kernel_list[@]}"; do [[ "${status[$k]}" != PASS && "${status[$k]}" != FAIL ]] && n=$((n + 1)); done
  echo "OTHER: $n"
} > "$SUMMARY_TXT"
{
  echo "kernel,target,size,samples,status,mismatched_arrays,old_median_ms,new_median_ms,speedup"
  for k in "${kernel_list[@]}"; do
    echo "$k,$TARGET,$SIZE,$SAMPLES,${status[$k]},${mismatched[$k]-},${old_ms[$k]-},${new_ms[$k]-},${speedup[$k]-}"
  done
} > "$SUMMARY_CSV"
cp "$SUMMARY_TXT" "$RESULTS_DIR/summary_latest.txt"
cp "$SUMMARY_CSV" "$RESULTS_DIR/summary_latest.csv"

echo ""
cat "$SUMMARY_TXT"
echo ""
echo "TXT: $SUMMARY_TXT"
echo "CSV: $SUMMARY_CSV"
for k in "${kernel_list[@]}"; do
  [[ "${status[$k]}" == "PASS" || "${status[$k]}" == "NO_FUNCTION" ]] || exit 1
done
exit 0
