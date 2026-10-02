#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/ext-profu-benchmark.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

clang=${CLANG:-clang}
cxx=${CXX:-c++}
llvm_lib_dir=${MLIR_LIB_DIR:-$(llvm-config --libdir)}

"$clang" -target x86_64-unknown-linux-gnu -c \
    "$script_dir/../llvm/ext_profu_.ll" -o "$build_dir/ext_profu_llvm.o"
"$cxx" -x c++ -std=c++17 -O3 "$script_dir/benchmark_ext_profu_llvm.cpp" \
    -x none "$build_dir/ext_profu_llvm.o" -L"$llvm_lib_dir" \
    -Wl,-rpath,"$llvm_lib_dir" -lmlir_cuda_runtime -lcuda -lm \
    -o "$build_dir/benchmark_ext_profu_llvm"

"$build_dir/benchmark_ext_profu_llvm" "$@"