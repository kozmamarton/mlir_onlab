#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
LLVM_ROOT_DIR="$PROJECT_ROOT/externals/llvm-project"
MLIR_OPT="$LLVM_ROOT_DIR/build/bin/mlir-opt"
OUTPUT_DIR="$PROJECT_ROOT/src/loop_fusion/pom2k"
BUILTIN_INPUT_BASE_DIR="$PROJECT_ROOT/src/pom2k_generated_affine_loops/mlir"

# Shared mlir-opt flags applied to every generated loop-fusion example.
COMMON_FLAGS=(
  "--allow-unregistered-dialect"
 # "--split-input-file"
 "--debug"
 "--debug-only=affine-parallelize,scf-parallel-loop-fusion"
)

# Function-level passes.
FUNC_PASSES=(
  "affine-raise-from-memref"
  "affine-loop-normalize"
  "loop-invariant-code-motion"
  "affine-loop-invariant-code-motion"
  "affine-loop-fusion"
  "mem2reg"
  "affine-scalrep" # cleans up useles write/read pairs after loop fusion
  "affine-parallelize" #option: parallel-reductions?
  "lower-affine"
	#"scf-parallel-loop-tiling"
	"scf-parallel-loop-fusion"
  # Note: scf-parallel-loop-fusion is intentionally not run here. The pass
  # operates on scf.parallel and is more effective in the lowering pipeline,
  # right before convert-scf-to-openmp.
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

)

# Test cases to process.
CASES=("ext_adjust_u_v_.mlir")

CASES_N=(
  "ext_aam_.mlir"         "ext_advv_.mlir"          "ext_etf_update_.mlir"                  "ext_smol_adif_.mlir"
  "ext_add_ad_2d_.mlir"   "ext_apply_filter_.mlir"  "ext_final_internal_update_.mlir"       "ext_time_internal_forward_.mlir"
  "ext_adjust_u_v_.mlir"  "ext_baropg_.mlir"        "ext_flux_update_.mlir"                 "ext_uaf_.mlir"
  "ext_advave_.mlir"      "ext_bcond_1_.mlir"       "ext_init_horizontal_velocities_.mlir"  "ext_update_turbulane_.mlir"
  "ext_advct_.mlir"       "ext_bcond_2_.mlir"       "ext_init_internal_.mlir"               "ext_update_u_v_.mlir"
  "ext_advq_.mlir"        "ext_bcond_3_.mlir"       "ext_profq_.mlir"                       "ext_updeta_t_s_.mlir"
  "ext_advt1_.mlir"       "ext_bcond_5_.mlir"       "ext_proft_.mlir"                       "ext_vaf_.mlir"
  "ext_advt2_.mlir"       "ext_dens_.mlir"          "ext_profu_.mlir"                       "ext_vert_avgs_.mlir"
  "ext_advu_.mlir"        "ext_elf_update_.mlir"    "ext_profv_.mlir"                       "ext_vertvl_.mlir"
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
  local input_file="$BUILTIN_INPUT_BASE_DIR/${input_name}"
  local output_file="$OUTPUT_DIR/${input_name}"
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

