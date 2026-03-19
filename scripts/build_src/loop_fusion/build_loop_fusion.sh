#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
LLVM_ROOT_DIR="$PROJECT_ROOT/externals/llvm-project"
MLIR_OPT="$LLVM_ROOT_DIR/build/bin/mlir-opt"
OUTPUT_DIR="$PROJECT_ROOT/src/loop_fusion"

# Shared mlir-opt flags applied to every generated loop-fusion example.
COMMON_FLAGS=(
  "--allow-unregistered-dialect"
  "--split-input-file"
)

# Function-level passes for the default loop-fusion mode.
DEFAULT_FUNC_PASSES=(
  "affine-loop-normalize"
  "affine-loop-fusion"
  "affine-scalrep"
  "affine-loop-tile"
  "affine-parallelize"
  "convert-parallel-loops-to-gpu"
  "lower-affine"
  #"--convert-gpu-to-rocdl"
)

# Module-level passes (run at builtin.module scope, before func.func passes).
MODULE_PASSES=(
  "inline"
)

# GPU-module-level passes (run at gpu.module scope).
GPU_MODULE_PASSES=(
  "convert-gpu-to-nvvm"
)

# Function-level passes for producer-consumer oriented loop fusion cases.
PRODUCER_FUNC_PASSES=(
  "affine-loop-normalize"
  "affine-loop-fusion{mode=producer}"
  "affine-scalrep"
  "affine-loop-tile"
  "affine-parallelize"
  "convert-parallel-loops-to-gpu"
  "lower-affine"
  #"--convert-gpu-to-rocdl"
)

DEFAULT_CASES=(
  "loop_fusion_hpc"
  "should_fuse_reduction_to_pointwise"
  "should_fuse_loop_nests_with_shifts"
  "should_fuse_at_depth_above_loop_carried_dependence"
  "mul_add_0"
  "should_not_fuse_since_non_affine_users"
)

PRODUCER_CASES=(
  "loop_fusion_producer"
  "unflatten2d_with_transpose"
)

usage() {
  cat <<EOF
Usage: $(basename "$0") [--producer] [--default] [--all]

Examples:
  $(basename "$0") --producer
  $(basename "$0") --default
  $(basename "$0") --all
EOF
}

run_default=false
run_producer=false

while (($# > 0)); do
  case "$1" in
    --producer)
      run_producer=true
      ;;
    --default)
      run_default=true
      ;;
    --all)
      run_default=true
      run_producer=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
  shift
done

if ! $run_default && ! $run_producer; then
  usage
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

join_by() {
  local delimiter="$1"
  shift
  local first_value="${1-}"
  shift || true
  printf '%s' "$first_value"
  printf '%s' "${@/#/$delimiter}"
}

build_pipeline() {
  local -n _mod_ref="$1"
  local -n _func_ref="$2"
  local -n _gpu_mod_ref="$3"
  local pipeline_parts=()

  if (( ${#_mod_ref[@]} > 0 )); then
    pipeline_parts+=("$(join_by ',' "${_mod_ref[@]}")")
  fi

  pipeline_parts+=("func.func($(join_by ',' "${_func_ref[@]}"))")

  if (( ${#_gpu_mod_ref[@]} > 0 )); then
    pipeline_parts+=("gpu.module($(join_by ',' "${_gpu_mod_ref[@]}"))")
  fi

  printf 'builtin.module(%s)' "$(join_by ',' "${pipeline_parts[@]}")"
}

run_default_case() {
  local input_name="$1"
  local _no_mod=()
  local pipeline
  local input_file="$PROJECT_ROOT/tests/${input_name}.mlir"
  local output_file="$OUTPUT_DIR/${input_name}.mlir"
  pipeline="$(build_pipeline _no_mod DEFAULT_FUNC_PASSES GPU_MODULE_PASSES)"
  echo "Generating ${input_name}.mlir with default affine-loop-fusion mode."
  printf 'Running command:\n  %s %s -pass-pipeline="%s" \\\n    < %s \\\n    > %s\n' \
    "$MLIR_OPT" "${COMMON_FLAGS[*]}" "$pipeline" "$input_file" "$output_file"
  "$MLIR_OPT" \
    "${COMMON_FLAGS[@]}" \
    -pass-pipeline="$pipeline" \
    < "$input_file" \
    > "$output_file"
}

run_producer_case() {
  local input_name="$1"
  local pipeline
  local input_file="$PROJECT_ROOT/tests/${input_name}.mlir"
  local output_file="$OUTPUT_DIR/${input_name}.mlir"
  pipeline="$(build_pipeline MODULE_PASSES PRODUCER_FUNC_PASSES GPU_MODULE_PASSES)"
  echo "Generating ${input_name}.mlir with producer affine-loop-fusion mode."
  printf 'Running command:\n  %s %s -pass-pipeline="%s" \\\n    < %s \\\n    > %s\n' \
    "$MLIR_OPT" "${COMMON_FLAGS[*]}" "$pipeline" "$input_file" "$output_file"
  "$MLIR_OPT" \
    "${COMMON_FLAGS[@]}" \
    -pass-pipeline="$pipeline" \
    < "$input_file" \
    > "$output_file"
}

if $run_default; then
  for case_name in "${DEFAULT_CASES[@]}"; do
    run_default_case "$case_name"
  done
fi

if $run_producer; then
  for case_name in "${PRODUCER_CASES[@]}"; do
    run_producer_case "$case_name"
  done
fi

