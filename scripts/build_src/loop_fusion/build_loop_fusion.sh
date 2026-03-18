
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
  "affine-loop-fusion"
)

# Function-level passes for producer-consumer oriented loop fusion cases.
PRODUCER_FUNC_PASSES=(
  "affine-loop-fusion{mode=producer}"
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

mkdir -p "$OUTPUT_DIR"

join_by() {
  local delimiter="$1"
  shift
  local first_value="${1-}"
  shift || true
  printf '%s' "$first_value"
  printf '%s' "${@/#/$delimiter}"
}

build_func_pipeline() {
  local -n pass_list_ref="$1"
  printf 'builtin.module(func.func(%s))' "$(join_by ',' "${pass_list_ref[@]}")"
}

run_default_case() {
  local input_name="$1"
  echo "Generating ${input_name}.mlir with default affine-loop-fusion mode."
  "$MLIR_OPT" \
    "${COMMON_FLAGS[@]}" \
    -pass-pipeline="$(build_func_pipeline DEFAULT_FUNC_PASSES)" \
    < "$PROJECT_ROOT/tests/${input_name}.mlir" \
    > "$OUTPUT_DIR/${input_name}.mlir"
}

run_producer_case() {
  local input_name="$1"
  echo "Generating ${input_name}.mlir with producer affine-loop-fusion mode."
  "$MLIR_OPT" \
    "${COMMON_FLAGS[@]}" \
    -pass-pipeline="$(build_func_pipeline PRODUCER_FUNC_PASSES)" \
    < "$PROJECT_ROOT/tests/${input_name}.mlir" \
    > "$OUTPUT_DIR/${input_name}.mlir"
}

for case_name in "${DEFAULT_CASES[@]}"; do
  run_default_case "$case_name"
done

for case_name in "${PRODUCER_CASES[@]}"; do
  run_producer_case "$case_name"
done

