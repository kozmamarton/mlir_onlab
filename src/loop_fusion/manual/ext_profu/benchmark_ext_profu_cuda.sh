#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/ext-profu-cuda-benchmark.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

nvcc=${NVCC:-nvcc}
"$nvcc" -std=c++17 -O3 --fmad=false \
    "$script_dir/benchmark_ext_profu_cuda.cu" \
    -o "$build_dir/benchmark_ext_profu_cuda"

"$build_dir/benchmark_ext_profu_cuda" "$@"
