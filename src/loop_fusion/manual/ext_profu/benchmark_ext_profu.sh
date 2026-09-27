#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/ext-profu-benchmark.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

cxx=${CXX:-c++}
"$cxx" -x c++ -std=c++17 -O3 "$script_dir/benchmark_ext_profu.c" -lm \
    -o "$build_dir/benchmark_ext_profu"

"$build_dir/benchmark_ext_profu" "$@"