
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
LLVM_ROOT_DIR="$PROJECT_ROOT/externals/llvm-project"

#  -pass-pipeline='builtin.module(func.func(affine-loop-fusion))' 
#  -affine-loop-fusion
#  -allow-unregistered-dialect
#  -split-input-file
APPLIED_PASSES=(
  "--allow-unregistered-dialect"
  "--split-input-file"
  # Normalization
  "--affine-loop-normalize"
  # Fusion & optimization

  "--affine-loop-fusion"
  "--affine-scalrep"

  # Lowering
  #"--lower-affine"

)

echo "Executing transformations on loop fusion example 1."

"$LLVM_ROOT_DIR/build/bin/mlir-opt" "${APPLIED_PASSES[@]}" \
  < "$LLVM_ROOT_DIR/mlir/test/Dialect/Affine/loop-fusion.mlir" \
  > "$PROJECT_ROOT/src/loop_fusion/loop-fusion.mlir"

echo "Executing transformations on loop fusion example 2."

"$LLVM_ROOT_DIR/build/bin/mlir-opt" "${APPLIED_PASSES[@]}" \
  < "$LLVM_ROOT_DIR/mlir/test/Dialect/Affine/loop-fusion-2.mlir" \
  > "$PROJECT_ROOT/src/loop_fusion/loop-fusion-2.mlir"

echo "Executing transformations on loop fusion example 3."

"$LLVM_ROOT_DIR/build/bin/mlir-opt" "${APPLIED_PASSES[@]}" \
  < "$LLVM_ROOT_DIR/mlir/test/Dialect/Affine/loop-fusion-3.mlir" \
  > "$PROJECT_ROOT/src/loop_fusion/loop-fusion-3.mlir"

