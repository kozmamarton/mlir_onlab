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

def AffineLoopFusionNonConservative : Pass<"affine-loop-fusion-non-conservative", "func::FuncOp"> {
  let summary = "Fuse independent sibling affine loops, including ones with mismatched bounds";
  let description = [{
    Fuses pairs of sibling affine.for loops that have no memory conflicts
    (RAW/WAR/WAW) between them. Loops with matching bounds are concatenated;
    when one range contains the other the smaller loop body is guarded with
    an affine.if. The earlier loop is sunk to the later one, so any op with
    memory effects between the two loops blocks the fusion.
  }];
  let dependentDialects = ["mlir::affine::AffineDialect"];
  let options = [
    Option<"fuseMatchingBounds", "fuse-matching-bounds", "bool", /*default=*/"true",
           "Fuse loops whose bounds match exactly">,
    Option<"fuseMismatchedBounds", "fuse-mismatched-bounds", "bool", /*default=*/"true",
           "Fuse loops whose bounds differ by constants and one range contains the other">,
    Option<"maxFusedLoops", "max-fused-loops", "unsigned", /*default=*/"2",
           "Maximum number of original loops merged into one fused loop">,
    Option<"aliasConservative", "alias-conservative", "bool", /*default=*/"false",
           "Assume distinct root memrefs may alias unless both are only read">
  ];
}

#endif  // LIB_TRANSFORM_AFFINE_PASSES_TD_
