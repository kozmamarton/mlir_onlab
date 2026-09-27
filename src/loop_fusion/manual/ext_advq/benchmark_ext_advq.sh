#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/ext-advq-benchmark.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

cxx=${CXX:-c++}
"$cxx" -std=c++17 -O3 "$script_dir/benchmark_ext_advq.c" -lm \
    -o "$build_dir/benchmark_ext_advq"

"$build_dir/benchmark_ext_advq" "$@"