#!/usr/bin/env bash

set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 <file.mlir> [--enable-cse] [--enable-cop]"
  echo "Example: $0 affine.mlir --enable-cse"
  exit 1
fi

FILE="$1"
shift

ENABLE_CSE=0
ENABLE_COP=0

for arg in "$@"; do
  case "$arg" in
    --enable-cse) ENABLE_CSE=1 ;;
    --enable-cop) ENABLE_COP=1 ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

passes=(
  "--lower-affine"
  "--convert-scf-to-cf"
  "--convert-cf-to-llvm"
  "--llvm-request-c-wrappers"
  "--convert-func-to-llvm"
  "--convert-arith-to-llvm"
  "--reconcile-unrealized-casts"
  "--finalize-memref-to-llvm"
)

cmd=(mlir-opt "$FILE")

for p in "${passes[@]}"; do
  cmd+=("$p")

  if [ $ENABLE_CSE -eq 1 ]; then
    cmd+=("--cse")
  fi

  if [ $ENABLE_COP -eq 1 ]; then
    cmd+=("--canonicalize")
  fi
done

"${cmd[@]}" | mlir-translate --mlir-to-llvmir