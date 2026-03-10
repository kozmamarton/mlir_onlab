#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

"$PROJECT_ROOT/build/tools/tutorial-opt" --mul-to-add \
  < "$PROJECT_ROOT/tests/mul_to_add.mlir" \
  > "$PROJECT_ROOT/src/mul_to_add/mul_to_add.mlir"

echo | "$PROJECT_ROOT/scripts/lower_to_llvm.sh" \
  "$PROJECT_ROOT/src/mul_to_add/mul_to_add.mlir" \
  --enable-cse \
  --enable-cop \
  > "$PROJECT_ROOT/artifacts/llvm/mul_to_add.ll"

clang++ -O3 \
  "$PROJECT_ROOT/src/mul_to_add/mul_to_add.cpp" \
  "$PROJECT_ROOT/artifacts/llvm/mul_to_add.ll" \
  -o "$PROJECT_ROOT/artifacts/bin/mul_to_add.o"