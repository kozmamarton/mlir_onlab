#!/usr/bin/env bash
# Runs the differential benchmark of every pom2k kernel on one target.
#
# For each kernel: regenerates the pipeline output without (old) and with (new)
# the custom fusion pass into src/loop_fusion/pom2k/compare/{old,new}, regenerates
# the kernel's harness, then calls <kernel dir>/run_diff_benchmark.sh. Kernels
# run one at a time to bound memory use. A summary is written to
# examples/pom2k/results/<target>/. gpu_a100 also runs each kernel's native
# CUDA reference (<kernel dir>/cuda_ref.cu) and must run on an A100 node
# (gpu_v100: the same, built for sm_70, on a V100 node);
# gpu_amd runs each kernel's native HIP reference (<kernel dir>/hip_ref.hip) on
# an AMD GPU (ROCm; chip AMDGPU_CHIP, default gfx1101).
#
# Usage:
#   run_all_benchmarks.sh --target cpu_parallel|gpu_a100|gpu_v100|gpu_amd [--size IMxJMxKB]
#                         [--samples N] [--kernels k1,k2,...] [--skip-apply]
#                         [--memory device|managed]
#
#   --kernels     default: the CASES list of apply_loop_fusion_pom2k.sh
#   --skip-apply  reuse the existing compare/{old,new} outputs
#   --memory      gpu_amd only (default device): array memory of the harness,
#                 see lib/run_diff_kernel.sh
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
MEMORY=""
usage() {
  sed -n '2,22p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}
while (($# > 0)); do
  case "$1" in
    --target) TARGET="${2-}"; shift 2 ;;
    --size) SIZE="${2-}"; shift 2 ;;
    --samples) SAMPLES="${2-}"; shift 2 ;;
    --kernels) KERNELS="${2-}"; shift 2 ;;
    --skip-apply) SKIP_APPLY=1; shift ;;
    --memory) MEMORY="${2-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage; exit 2 ;;
  esac
done
case "$TARGET" in
  cpu_parallel|gpu_a100|gpu_v100|gpu_amd) ;;
  "") echo "--target is required (implemented: cpu_parallel, gpu_a100, gpu_v100, gpu_amd)" >&2; exit 2 ;;
  *) echo "target '$TARGET' is not implemented yet (implemented: cpu_parallel, gpu_a100, gpu_v100, gpu_amd)" >&2; exit 2 ;;
esac
# Native reference of the GPU targets (column and SUMMARY field names).
REF=""
case "$TARGET" in
  gpu_a100|gpu_v100) REF="cuda" ;;
  gpu_amd) REF="hip"; MEMORY="${MEMORY:-device}" ;;
esac
if [[ -n "$MEMORY" && "$TARGET" != "gpu_amd" ]]; then
  echo "--memory is only supported for gpu_amd" >&2; exit 2
fi
RUN_ARGS=(--target "$TARGET" --size "$SIZE" --samples "$SAMPLES")
[[ -n "$MEMORY" ]] && RUN_ARGS+=(--memory "$MEMORY")

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

declare -A status mismatched old_ms new_ms speedup ref_ms speedup_ref kdir

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
  if out="$(python3 "$SCRIPT_DIR/generate_benchmarks.py" --target "$TARGET" "$k" 2>&1)"; then
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
  "${kdir[$k]}/run_diff_benchmark.sh" "${RUN_ARGS[@]}" 2>&1 | tee "$LOG_DIR/run_$k.log"
  line="$(grep '^SUMMARY ' "$LOG_DIR/run_$k.log" | tail -n 1)"
  get() { sed -nE "s/.* $1=([^ ]+).*/\1/p" <<< "$line"; }
  status[$k]="$(get status)"; status[$k]="${status[$k]:-ERROR}"
  mismatched[$k]="$(get mismatched_arrays)"
  old_ms[$k]="$(get old_median_ms)"; new_ms[$k]="$(get new_median_ms)"; speedup[$k]="$(get speedup)"
  if [[ -n "$REF" ]]; then
    ref_ms[$k]="$(get "${REF}_median_ms")"; speedup_ref[$k]="$(get "speedup_new_vs_${REF}")"
  fi
done

CPU_MODEL="$(lscpu 2>/dev/null | awk -F: '/Model name:/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')"
GPU=0; [[ -n "$REF" ]] && GPU=1
GPU_MODEL=""
if [[ "$TARGET" == "gpu_a100" || "$TARGET" == "gpu_v100" ]]; then
  GPU_MODEL="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -n 1)"
elif [[ "$TARGET" == "gpu_amd" ]]; then
  # Marketing name of the first GPU agent (rocminfo lists the CPU agents too).
  GPU_MODEL="$("${ROCM_PATH:-/opt/rocm}/bin/rocminfo" 2>/dev/null | awk -F: '
    /Marketing Name:/ { name = $2 }
    /Device Type:/ && $2 ~ /GPU/ { gsub(/^[ \t]+|[ \t]+$/, "", name); print name; exit }')"
fi
{
  if (( GPU )); then
    echo "pom2k differential benchmarks (old = without custom fusion pass, new = with it, $REF = native ${REF^^} reference)"
  else
    echo "pom2k differential benchmarks (old = without custom fusion pass, new = with it)"
  fi
  echo "generated_at_utc: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "target: $TARGET"
  echo "size: $SIZE"
  echo "samples: $SAMPLES"
  echo "cpu_model: ${CPU_MODEL:-unknown}"
  (( GPU )) && echo "gpu_model: $GPU_MODEL"
  [[ -n "$MEMORY" ]] && echo "memory: $MEMORY"
  echo "logs: $LOG_DIR"
  echo ""
  if (( GPU )); then
    printf '%-34s %-14s %-10s %12s %12s %12s %8s %13s\n' kernel status mismatched old_median_ms \
      new_median_ms "${REF}_median_ms" speedup "speedup_vs_$REF"
    for k in "${kernel_list[@]}"; do
      printf '%-34s %-14s %-10s %12s %12s %12s %8s %13s\n' "$k" "${status[$k]}" "${mismatched[$k]:--}" \
        "${old_ms[$k]:--}" "${new_ms[$k]:--}" "${ref_ms[$k]:--}" "${speedup[$k]:--}" \
        "${speedup_ref[$k]:--}"
    done
  else
    printf '%-34s %-14s %-10s %12s %12s %8s\n' kernel status mismatched old_median_ms new_median_ms speedup
    for k in "${kernel_list[@]}"; do
      printf '%-34s %-14s %-10s %12s %12s %8s\n' "$k" "${status[$k]}" "${mismatched[$k]:--}" \
        "${old_ms[$k]:--}" "${new_ms[$k]:--}" "${speedup[$k]:--}"
    done
  fi
  echo ""
  for s in PASS FAIL; do
    n=0; for k in "${kernel_list[@]}"; do [[ "${status[$k]}" == "$s" ]] && n=$((n + 1)); done
    echo "$s: $n"
  done
  n=0; for k in "${kernel_list[@]}"; do [[ "${status[$k]}" != PASS && "${status[$k]}" != FAIL ]] && n=$((n + 1)); done
  echo "OTHER: $n"
} > "$SUMMARY_TXT"
{
  if (( GPU )); then
    echo "kernel,target,size,samples,status,mismatched_arrays,old_median_ms,new_median_ms,${REF}_median_ms,speedup,speedup_new_vs_${REF}"
    for k in "${kernel_list[@]}"; do
      echo "$k,$TARGET,$SIZE,$SAMPLES,${status[$k]},${mismatched[$k]-},${old_ms[$k]-},${new_ms[$k]-},${ref_ms[$k]-},${speedup[$k]-},${speedup_ref[$k]-}"
    done
  else
    echo "kernel,target,size,samples,status,mismatched_arrays,old_median_ms,new_median_ms,speedup"
    for k in "${kernel_list[@]}"; do
      echo "$k,$TARGET,$SIZE,$SAMPLES,${status[$k]},${mismatched[$k]-},${old_ms[$k]-},${new_ms[$k]-},${speedup[$k]-}"
    done
  fi
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
