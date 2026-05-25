#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLE_LL="${EXAMPLE_LL:-$SCRIPT_DIR/ext_adjust_u_v_cpu.ll}"
CXX=clang++
#"$SCRIPT_DIR/../../../externals/llvm-project/build/bin/clang++"


OUT_BIN="${OUT_BIN:-$SCRIPT_DIR/benchmark_cpu_multithreaded.out}"
"$CXX" -std=c++17 -O3 "$SCRIPT_DIR/benchmark_cpu_multithreaded.cpp" "$EXAMPLE_LL" \
  -fopenmp \
  -o "$OUT_BIN"
