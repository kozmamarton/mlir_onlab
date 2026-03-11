#!/usr/bin/env bash

set -euo pipefail

# Usage:
#   ./run_tblgen.sh <tablegen_file> [llvm_project_root]
#
# Examples:
#   ./run_tblgen.sh ./include/MyDialect/MyDialectOps.td
#   ./run_tblgen.sh ./include/MyDialect/MyDialectOps.td /home/marton/uni/onlab/llvm-project

DEFAULT_LLVM_PROJECT="/home/marton/uni/onlab/llvm-project"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <tablegen_file> [llvm_project_root]"
  exit 1
fi

if ! command -v mlir-tblgen >/dev/null 2>&1; then
  echo "Error: mlir-tblgen not found in PATH"
  exit 1
fi

TD_FILE="$(realpath "$1")"

MLIR_INCLUDE_DIR="$DEFAULT_LLVM_PROJECT/mlir/include"
LLVM_INCLUDE_DIR="$DEFAULT_LLVM_PROJECT/llvm/include"

if [ ! -f "$TD_FILE" ]; then
  echo "Error: TableGen file not found: $TD_FILE"
  exit 1
fi
# -gen-op-decls \

mlir-tblgen \
  "$TD_FILE" \
  -gen-op-decls \
  -gen-pass-decls \
  -I "$MLIR_INCLUDE_DIR" \
  -I "$LLVM_INCLUDE_DIR"