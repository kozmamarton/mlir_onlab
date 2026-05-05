#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_BIN="${OUT_BIN:-$SCRIPT_DIR/bench_cpu_single_threaded.out}"

g++ -x c++ -std=c++17 -O3 "$SCRIPT_DIR/pom2k_cpu.cpp" -lm -o "$OUT_BIN"
