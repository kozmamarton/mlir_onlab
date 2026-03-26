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

# Function-level passes.
FUNC_PASSES=(
  "affine-loop-normalize"
  "loop-invariant-code-motion"
  "affine-loop-fusion"
  "mem2reg"
  "affine-scalrep" # cleans up useles write/read pairs after loop fusion
  #"affine-loop-tile" #option: cache size? ---
  "affine-parallelize" #option: parallel-reductions?
  "scf-parallel-loop-fusion"
  "lower-affine"
  #-affine-pipeline-data-transfer #try?
)

# Passes to insert between each function-level pass (after each func.func pass).
INBETWEEN_FUNC_PASSES=(
  "cse"
  "canonicalize"
)

# Module-level passes run before func.func passes.
PRE_FUNC_MODULE_PASSES=(
  "inline"
  "canonicalize"
)

# Module-level passes run after func.func passes.
POST_FUNC_MODULE_PASSES=(
  "convert-parallel-loops-to-gpu"
  "gpu-kernel-outlining"
)

# Test cases to process.
CASES=(
  "should_fuse_reduction_to_pointwise"
  "should_fuse_loop_nests_with_shifts"
  "should_fuse_at_depth_above_loop_carried_dependence"
  "mul_add_0"
  "should_not_fuse_since_non_affine_users"
  "loop_fusion_producer"
  "unflatten2d_with_transpose"
)

usage() {
  cat <<EOF
Usage: $(basename "$0") [-f <PATH>] [-f <PATH>] ...

Options:
  -f, --file <PATH>    Process either a built-in case name or an explicit .mlir file.
                       Built-in cases use tests/<name>.mlir; explicit files are processed
                       via their absolute path.
                       If not provided, all built-in test cases are processed.
  -h, --help           Show this help message.

Examples:
  $(basename "$0")                                    # Process all cases
  $(basename "$0") -f loop_fusion_hpc                 # Process only loop_fusion_hpc
  $(basename "$0") -f loop_fusion_hpc -f mul_add_0   # Process two built-in cases
  $(basename "$0") -f /tmp/example.mlir              # Process one explicit file
EOF
}

declare -a builtin_cases_to_process=()
declare -a explicit_files_to_process=()

to_abs_path() {
  local path="$1"
  local dir

  if [[ "$path" = /* ]]; then
    dir="$(cd "$(dirname "$path")" && pwd)"
  else
    dir="$(cd "$PROJECT_ROOT/$(dirname "$path")" && pwd)"
  fi

  printf '%s/%s\n' "$dir" "$(basename "$path")"
}

resolve_explicit_file() {
  local raw_path="$1"
  local candidate

  if [[ "$raw_path" = /* ]]; then
    candidate="$raw_path"
  else
    candidate="$PROJECT_ROOT/$raw_path"
  fi

  if [[ -f "$candidate" ]]; then
    to_abs_path "$candidate"
    return 0
  fi

  if [[ "$candidate" != *.mlir && -f "${candidate}.mlir" ]]; then
    to_abs_path "${candidate}.mlir"
    return 0
  fi

  return 1
}

while (($# > 0)); do
  case "$1" in
    -f|--file)
      if [[ -z "${2-}" ]]; then
        echo "Error: -f/--file requires an argument" >&2
        usage
        exit 1
      fi
      if [[ "$2" == */* || "$2" == .* || "$2" == *.mlir ]]; then
        if resolved_file="$(resolve_explicit_file "$2")"; then
          explicit_files_to_process+=("$resolved_file")
        else
          echo "Error: explicit file not found: $2" >&2
          exit 1
        fi
      else
        builtin_cases_to_process+=("$2")
      fi
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: Unknown option '$1'" >&2
      usage
      exit 1
      ;;
  esac
done

# If no specific targets were provided, use all built-in cases.
if (( ${#builtin_cases_to_process[@]} == 0 && ${#explicit_files_to_process[@]} == 0 )); then
  builtin_cases_to_process=("${CASES[@]}")
fi

mkdir -p "$OUTPUT_DIR"

join_by() {
  local IFS="$1"; shift
  printf '%s' "$*"
}

build_func_passes_with_inbetween() {
  local -n _funcs="$1"
  local -n _between="$2"
  local result=()

  for pass in "${_funcs[@]}"; do
   result+=("$pass")
   result+=("${_between[@]}")
  
  done

  join_by ',' "${result[@]}"
}

build_pipeline() {
  local -n _pre_mod="$1"
  local -n _post_mod="$2"
  local parts=()

  (( ${#_pre_mod[@]} )) && parts+=("$(join_by ',' "${_pre_mod[@]}")")
  parts+=("func.func($(build_func_passes_with_inbetween "$3" "$4"))")
  (( ${#_post_mod[@]} )) && parts+=("$(join_by ',' "${_post_mod[@]}")")

  printf 'builtin.module(%s)' "$(join_by ',' "${parts[@]}")"
}

run_builtin_case() {
  local input_name="$1"
  local pipeline
  local input_file="$PROJECT_ROOT/tests/${input_name}.mlir"
  local output_file="$OUTPUT_DIR/${input_name}.mlir"
  pipeline="$(build_pipeline PRE_FUNC_MODULE_PASSES POST_FUNC_MODULE_PASSES FUNC_PASSES INBETWEEN_FUNC_PASSES)"
  echo "Generating ${input_name}.mlir"
  printf 'Running command:\n  %s %s -pass-pipeline="%s" \\\n    < %s \\\n    > %s\n' \
    "$MLIR_OPT" "${COMMON_FLAGS[*]}" "$pipeline" "$input_file" "$output_file"
  "$MLIR_OPT" \
    "${COMMON_FLAGS[@]}" \
    -pass-pipeline="$pipeline" \
    < "$input_file" \
    > "$output_file"
}

run_explicit_file() {
  local input_file="$1"
  local pipeline
  local input_name
  local output_file

  input_name="$(basename "$input_file" .mlir)"
  output_file="$OUTPUT_DIR/${input_name}.mlir"
  pipeline="$(build_pipeline PRE_FUNC_MODULE_PASSES POST_FUNC_MODULE_PASSES FUNC_PASSES INBETWEEN_FUNC_PASSES)"
  echo "Generating ${input_name}.mlir"
  printf 'Running command:\n  %s %s -pass-pipeline="%s" \\\n+    < %s \\\n+    > %s\n' \
    "$MLIR_OPT" "${COMMON_FLAGS[*]}" "$pipeline" "$input_file" "$output_file"
  "$MLIR_OPT" \
    "${COMMON_FLAGS[@]}" \
    -pass-pipeline="$pipeline" \
    < "$input_file" \
    > "$output_file"
}

for case_name in "${builtin_cases_to_process[@]}"; do
  run_builtin_case "$case_name"
done

for input_file in "${explicit_files_to_process[@]}"; do
  run_explicit_file "$input_file"
done

