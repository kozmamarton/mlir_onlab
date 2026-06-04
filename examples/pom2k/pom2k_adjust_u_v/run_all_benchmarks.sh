#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
RESULTS_DIR="${RESULTS_DIR:-$SCRIPT_DIR/results}"

TXT_OUT="${TXT_OUT:-$RESULTS_DIR/results_combined.txt}"
CSV_OUT="${CSV_OUT:-$RESULTS_DIR/results_combined.csv}"
RAW_DIR="${RAW_DIR:-$RESULTS_DIR/raw}"

BUILD_CPU_SINGLE_SCRIPT="$SCRIPT_DIR/build_cpu_single_threaded.sh"
BUILD_CPU_MULTI_SCRIPT="$SCRIPT_DIR/build_cpu_multithreaded.sh"
BUILD_GPU_CUDA_SCRIPT="$SCRIPT_DIR/build_gpu.sh"

CPU_LOWER_SCRIPT="${CPU_LOWER_SCRIPT:-$PROJECT_ROOT/scripts/build_src/pom2k/lower_cpu_to_llvm.sh}"
GPU_LOWER_SCRIPT="${GPU_LOWER_SCRIPT:-$PROJECT_ROOT/scripts/build_src/pom2k/lower_gpu_to_llvm.sh}"

INPUT_MLIR="${INPUT_MLIR:-$PROJECT_ROOT/src/loop_fusion/pom2k/ext_adjust_u_v_.mlir}"

CPU_GENERATED_LL="${CPU_GENERATED_LL:-$PROJECT_ROOT/artifacts/llvm/pom2k/cpu/ext_adjust_u_v__cpu.ll}"
CPU_EXAMPLE_LL="${CPU_EXAMPLE_LL:-$SCRIPT_DIR/ext_adjust_u_v_cpu.ll}"
GPU_GENERATED_LL="${GPU_GENERATED_LL:-$PROJECT_ROOT/artifacts/llvm/pom2k/ext_adjust_u_v_.ll}"
GPU_EXAMPLE_LL="${GPU_EXAMPLE_LL:-$SCRIPT_DIR/ext_adjust_u_v_.ll}"

CPU_SINGLE_BIN="${CPU_SINGLE_BIN:-$SCRIPT_DIR/bench_cpu_single_threaded.out}"
CPU_MULTI_BIN="${CPU_MULTI_BIN:-$SCRIPT_DIR/bench_cpu_multithreaded.out}"
GPU_CUDA_BIN="${GPU_CUDA_BIN:-$SCRIPT_DIR/bench_gpu_nvcc.out}"

NOW_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

mkdir -p "$RESULTS_DIR" "$RAW_DIR"

get_cpu_model() {
  if command -v lscpu >/dev/null 2>&1; then
    lscpu | awk -F: '/Model name:/ {gsub(/^[ \t]+/, "", $2); print $2; exit}'
  elif [[ -f /proc/cpuinfo ]]; then
    awk -F: '/model name/ {gsub(/^[ \t]+/, "", $2); print $2; exit}' /proc/cpuinfo
  else
    echo "unknown"
  fi
}

get_gpu_model_nvidia() {
  if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=name --format=csv,noheader | head -n1 | sed 's/[[:space:]]*$//'
  else
    echo ""
  fi
}

csv_escape() {
  local value="$1"
  value="${value//\"/\"\"}"
  printf '"%s"' "$value"
}

append_csv_row() {
  local ts="$1"
  local bench="$2"
  local backend="$3"
  local cpu_model="$4"
  local gpu_model="$5"
  local raw_file="$6"

  {
    csv_escape "$ts"; printf ','
    csv_escape "$bench"; printf ','
    csv_escape "$backend"; printf ','
    csv_escape "$cpu_model"; printf ','
    csv_escape "$gpu_model"; printf ','
    csv_escape "$raw_file"; printf '\n'
  } >> "$CSV_OUT"
}

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Missing required file: $path" >&2
    exit 1
  fi
}

run_and_capture() {
  local name="$1"
  local backend="$2"
  local bin="$3"
  local gpu_model="$4"

  local ts
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  local raw_file="$RAW_DIR/${name}_$(date -u +"%Y%m%dT%H%M%SZ").log"

  echo "[$name] Running: $bin"
  "$bin" | tee "$raw_file"

  {
    echo ""
    echo "================================================================"
    echo "timestamp_utc: $ts"
    echo "benchmark: $name"
    echo "backend: $backend"
    echo "cpu_model: $CPU_MODEL"
    echo "gpu_model: ${gpu_model:-N/A}"
    echo "raw_output_file: $raw_file"
    echo "----------------------------------------------------------------"
    cat "$raw_file"
  } >> "$TXT_OUT"

  append_csv_row "$ts" "$name" "$backend" "$CPU_MODEL" "${gpu_model:-N/A}" "$raw_file"
}

CPU_MODEL="$(get_cpu_model)"
NVIDIA_GPU_MODEL="$(get_gpu_model_nvidia)"

{
  echo "pom2k_adjust_u_v benchmark run"
  echo "generated_at_utc: $NOW_UTC"
  echo "cpu_model: $CPU_MODEL"
  if [[ -n "$NVIDIA_GPU_MODEL" ]]; then
    echo "gpu_model: $NVIDIA_GPU_MODEL"
  else
    echo "gpu_model: N/A"
  fi
  echo ""
} > "$TXT_OUT"

printf '%s\n' 'timestamp,benchmark,backend,cpu_model,gpu_model,raw_output_file' > "$CSV_OUT"

require_file "$INPUT_MLIR"
require_file "$CPU_LOWER_SCRIPT"
require_file "$GPU_LOWER_SCRIPT"
require_file "$BUILD_CPU_SINGLE_SCRIPT"
require_file "$BUILD_CPU_MULTI_SCRIPT"
require_file "$BUILD_GPU_CUDA_SCRIPT"

# Build required LLVM IR for CPU benchmark.
echo "[prep] Lowering CPU LLVM IR"
"$CPU_LOWER_SCRIPT" "$INPUT_MLIR"
require_file "$CPU_GENERATED_LL"
cp "$CPU_GENERATED_LL" "$CPU_EXAMPLE_LL"

# Build required LLVM IR for CUDA benchmark.
if [[ -n "$NVIDIA_GPU_MODEL" ]]; then
  echo "[prep] Lowering CUDA LLVM IR"
  "$GPU_LOWER_SCRIPT" "$INPUT_MLIR"
  require_file "$GPU_GENERATED_LL"
  cp "$GPU_GENERATED_LL" "$GPU_EXAMPLE_LL"
else
  echo "[prep] Skipping CUDA LLVM IR generation: no NVIDIA GPU detected"
fi
# Build and run CPU single-thread benchmark.
echo "[build] CPU single-threaded"
"$BUILD_CPU_SINGLE_SCRIPT"
require_file "$CPU_SINGLE_BIN"
run_and_capture "cpu_single_threaded" "cpu" "$CPU_SINGLE_BIN" ""

# Build and run CPU multithread benchmark.
echo "[build] CPU multithreaded"
"$BUILD_CPU_MULTI_SCRIPT"
require_file "$CPU_MULTI_BIN"
run_and_capture "cpu_multithreaded" "cpu_openmp" "$CPU_MULTI_BIN" ""

# Auto-detect NVIDIA runtime and run CUDA benchmark if available.
if [[ -n "$NVIDIA_GPU_MODEL" ]]; then
  echo "[build] GPU CUDA"
  "$BUILD_GPU_CUDA_SCRIPT"
  require_file "$GPU_CUDA_BIN"
  run_and_capture "gpu_cuda" "cuda" "$GPU_CUDA_BIN" "$NVIDIA_GPU_MODEL"
else
  echo "[skip] CUDA benchmark skipped: nvidia-smi not found or no NVIDIA GPU detected"
  {
    echo ""
    echo "================================================================"
    echo "timestamp_utc: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo "benchmark: gpu_cuda"
    echo "backend: cuda"
    echo "cpu_model: $CPU_MODEL"
    echo "gpu_model: N/A"
    echo "raw_output_file: N/A"
    echo "status: skipped (nvidia-smi not found or no NVIDIA GPU detected)"
  } >> "$TXT_OUT"
  append_csv_row "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "gpu_cuda" "cuda" "$CPU_MODEL" "N/A" "N/A"
fi

echo ""
echo "Done."
echo "TXT: $TXT_OUT"
echo "CSV: $CSV_OUT"
echo "RAW: $RAW_DIR"
