#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
	echo "Usage: $(basename "$0") <file1.mlir|directory> [file2.mlir|directory ...]" >&2
	exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
LOOP_FUSION_SCRIPT="$SCRIPT_DIR/apply_loop_fusion_pom2k.sh"
LOWER_SCRIPT="$SCRIPT_DIR/lower_gpu_to_llvm.sh"
FUSED_OUTPUT_DIR="$PROJECT_ROOT/src/loop_fusion/manual/mlir"

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

for INPUT_FILE in "${INPUT_FILES[@]}"; do
	INPUT_DIR="$(cd "$(dirname "$INPUT_FILE")" && pwd)"
	INPUT_BASE="$(basename "$INPUT_FILE" .mlir)"
	ABS_INPUT_FILE="$INPUT_DIR/$(basename "$INPUT_FILE")"
	FUSED_INPUT_FILE="$FUSED_OUTPUT_DIR/${INPUT_BASE}.mlir"

	echo "Applying loop fusion to $INPUT_BASE"
	"$LOOP_FUSION_SCRIPT" --file "$ABS_INPUT_FILE"
	echo "Lowering fused MLIR for $INPUT_BASE"
	"$LOWER_SCRIPT" "$FUSED_INPUT_FILE"
done