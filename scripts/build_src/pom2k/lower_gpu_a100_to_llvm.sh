#!/usr/bin/env bash
set -euo pipefail

# Lowers pom2k pipeline outputs (scf.parallel loops) to LLVM IR for NVIDIA A100
# (sm_80). The host code calls into libmlir_cuda_runtime; the device code is
# embedded as a cubin. Same GPU pipeline as lower_gpu_to_llvm.sh, but with the
# A100 chip and with output directories that can be overridden (used by the
# differential benchmarks in examples/pom2k).
#
# scf-offload-host-loops (tutorial-opt) first turns the scf.for nests left on
# the host into scf.parallel (keeping carried k sweeps serial inside them) and
# moves host loads that only feed a kernel into it, so the lowered function
# does not touch the argument buffers on the CPU.
# scf-gpu-coalesced-tiling (tutorial-opt) then tiles and maps each scf.parallel so
# its stride-1 IV is threadIdx.x with a 32-wide block x: 32x4x2 for 3D nests,
# 32x8x1 for 2D, like launch() in examples/pom2k/lib/pom2k_cuda.cuh. Any loop
# it skips is mapped by gpu-map-parallel-loops with an explicit policy.

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
MLIR_OPT="${TUTORIAL_OPT:-$PROJECT_ROOT/build/tools/tutorial-opt}"
MLIR_TRANSLATE="$LLVM_ROOT_DIR/build/bin/mlir-translate"
OUTPUT_DIR_LL="${OUTPUT_DIR_LL:-$PROJECT_ROOT/artifacts/llvm/pom2k/gpu_a100}"
OUTPUT_DIR_MLIR="${OUTPUT_DIR_MLIR:-$PROJECT_ROOT/artifacts/mlir/pom2k/gpu_a100}"
mkdir -p "$OUTPUT_DIR_LL"
mkdir -p "$OUTPUT_DIR_MLIR"

PIPELINE_PASSES=(
  "func.func(scf-offload-host-loops, canonicalize, cse, scf-gpu-coalesced-tiling{block-3d=32,4,2 block-2d=32,8}, gpu-map-parallel-loops{mapping-policy=innermost-first})"
  "canonicalize"
  "cse"
  "convert-parallel-loops-to-gpu"
  "canonicalize"
  "cse"
  "gpu-kernel-outlining"
  "canonicalize"
  "cse"
  "gpu-lower-to-nvvm-pipeline{cubin-chip=sm_80 opt-level=3}"
)

MLIR_OPT_FLAGS=(
  "--allow-unregistered-dialect"
)

join_by() {
	local IFS="$1"
	shift 
	printf '%s' "$*"
}

PIPELINE="builtin.module($(join_by ',' "${PIPELINE_PASSES[@]}"))"

for INPUT_FILE in "${INPUT_FILES[@]}"; do
	INPUT_BASE="$(basename "$INPUT_FILE" .mlir)"
	NVVM_FILE="$OUTPUT_DIR_MLIR/${INPUT_BASE}-nvvm.mlir"
	LLVM_FILE="$OUTPUT_DIR_LL/${INPUT_BASE}_gpu_a100.ll"

	echo "$MLIR_OPT $INPUT_FILE \
		${MLIR_OPT_FLAGS[*]} \
		--pass-pipeline=$PIPELINE \
		-o $NVVM_FILE"
	"$MLIR_OPT" "$INPUT_FILE" \
		"${MLIR_OPT_FLAGS[@]}" \
		--pass-pipeline="$PIPELINE" \
		-o "$NVVM_FILE"

	echo "$MLIR_TRANSLATE $NVVM_FILE \
    --mlir-to-llvmir \
    -o $LLVM_FILE"
	"$MLIR_TRANSLATE" "$NVVM_FILE" \
		--mlir-to-llvmir \
		-o "$LLVM_FILE"

	echo "Wrote: $NVVM_FILE"
	echo "Wrote: $LLVM_FILE"
done
