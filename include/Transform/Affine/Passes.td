#ifndef LIB_TRANSFORM_AFFINE_PASSES_TD_
#define LIB_TRANSFORM_AFFINE_PASSES_TD_
include "mlir/IR/OpBase.td"
include "mlir/Pass/PassBase.td"

def AffineFullUnroll : Pass<"affine-full-unroll">{
  let summary = "Fully unroll all affine loops.";
  let description = [{
    Fully unroll all affine loops. (could add more docs here like code examples)
  }];
  let dependentDialects = ["mlir::affine::AffineDialect"];
}

def AffineFullUnrollPatternRewrite : Pass<"affine-full-unroll-rewrite"> {
  let summary = "Fully unroll all affine loops using the pattern rewrite engine";
  let description = [{
    Fully unroll all affine loops using the pattern rewrite engine.
  }];
  let dependentDialects = ["mlir::affine::AffineDialect"];
}

def ReinterpretFlatArrayAccess : Pass<"reinterpret-flat-array-access"> {
  let summary = "Rewrite flat affine array accesses through memref.reinterpret_cast";
  let description = [{
    Detects common flattened 2D/3D affine index patterns and rewrites accesses
    through rank-2/rank-3 memref.reinterpret_cast views so downstream affine
    analyses (like loop fusion) can reason about multi-dimensional accesses.
  }];
  let dependentDialects = [
    "mlir::affine::AffineDialect",
    "mlir::arith::ArithDialect",
    "mlir::memref::MemRefDialect"
  ];
}

#endif  // LIB_TRANSFORM_AFFINE_PASSES_TD_
