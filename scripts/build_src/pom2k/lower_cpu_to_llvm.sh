#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
	echo "Usage: $(basename "$0") <file1.mlir> [file2.mlir ... fileN.mlir]" >&2
	echo "Example: $(basename "$0") src/loop_fusion/a.mlir src/loop_fusion/b.mlir" >&2
	exit 1
fi

INPUT_FILES=()
while [[ $# -gt 0 ]]; do
	current="$1"
	shift

	if [[ -d "$current" ]]; then
		found_in_dir=0
		for file in "$current"/*.mlir; do
			if [[ -f "$file" ]]; then
				INPUT_FILES+=("$file")
				found_in_dir=1
			fi
		done

		if [[ $found_in_dir -eq 0 ]]; then
			echo "Skipping directory with no .mlir files: $current" >&2
		fi
		continue
	fi

	if [[ ! -f "$current" ]]; then
		echo "Skipping non-existing file: $current" >&2
		continue
	fi

	if [[ "$current" != *.mlir ]]; then
		echo "Skipping non-mlir file: $current" >&2
		continue
	fi

	INPUT_FILES+=("$current")
done

if [[ ${#INPUT_FILES[@]} -eq 0 ]]; then
	echo "Error: no valid .mlir input files were provided" >&2
	exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
LLVM_ROOT_DIR="$PROJECT_ROOT/externals/llvm-project"
MLIR_OPT="$LLVM_ROOT_DIR/build/bin/mlir-opt"
MLIR_TRANSLATE="$LLVM_ROOT_DIR/build/bin/mlir-translate"
OUTPUT_DIR_LL="$PROJECT_ROOT/artifacts/llvm/pom2k/cpu"
OUTPUT_DIR_MLIR="$PROJECT_ROOT/artifacts/mlir/pom2k/cpu"
mkdir -p "$OUTPUT_DIR_LL"
mkdir -p "$OUTPUT_DIR_MLIR"

# Coarse parallel lowering by default. Enable tiling only when explicitly
# requested because aggressive tiling can over-shard work and increase
# OpenMP runtime overhead.


PIPELINE_PASSES=(
	"lower-affine"
	"canonicalize"
	"cse"
	#"scf-parallel-loop-tiling"
	"canonicalize"
	"cse"
	"scf-parallel-loop-fusion"
	"canonicalize"
	"cse"
	"convert-scf-to-openmp"
	"canonicalize"
	"cse"
	"reconcile-unrealized-casts"
  "convert-scf-to-cf"
	"reconcile-unrealized-casts"
	"canonicalize"
	"cse"
	"loop-invariant-code-motion"
  "convert-math-to-llvm"
  "convert-arith-to-llvm"
  "finalize-memref-to-llvm"
	"reconcile-unrealized-casts"
  "convert-openmp-to-llvm"
  "convert-cf-to-llvm"
  "convert-func-to-llvm"
  "reconcile-unrealized-casts"
	"canonicalize"
	"cse"
	"loop-invariant-code-motion"
)

MLIR_OPT_FLAGS=(
 # "--split-input-file"
  "--allow-unregistered-dialect"
)

join_by() {
	local IFS="$1"
	shift
	printf '%s' "$*"
}

PIPELINE="builtin.module($(join_by ',' "${PIPELINE_PASSES[@]}"))"

for INPUT_FILE in "${INPUT_FILES[@]}"; do
	INPUT_DIR="$(dirname "$INPUT_FILE")"
	INPUT_BASE="$(basename "$INPUT_FILE" .mlir)"
	CPU_FILE="$OUTPUT_DIR_MLIR/${INPUT_BASE}-llvm.mlir"
	LLVM_FILE="$OUTPUT_DIR_LL/${INPUT_BASE}_cpu.ll"

  echo "$MLIR_OPT $INPUT_FILE \
		${MLIR_OPT_FLAGS[*]} \
		--pass-pipeline=$PIPELINE \
		-o $CPU_FILE"
	"$MLIR_OPT" "$INPUT_FILE" \
		"${MLIR_OPT_FLAGS[@]}" \
		--pass-pipeline="$PIPELINE" \
		-o "$CPU_FILE"

  echo "$MLIR_TRANSLATE $CPU_FILE \
    --mlir-to-llvmir \
    -o $LLVM_FILE"

	"$MLIR_TRANSLATE" "$CPU_FILE" \
		--mlir-to-llvmir \
		-o "$LLVM_FILE"

	echo "Wrote: $CPU_FILE"
	echo "Wrote: $LLVM_FILE"
done
