#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_BIN="${OUT_BIN:-$SCRIPT_DIR/benchmark_cpu_single_threaded.out}"

g++ -x c++ -std=c++17 -O3 "$SCRIPT_DIR/benchmark_cpu_single_threaded.cpp" -lm -o "$OUT_BIN"
