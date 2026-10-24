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
    an affine.if. A guard whose body is a single loop is pushed into that
    loop's body when it fuses with a sibling, so guarded nests fuse down to
    the innermost loops with one merged affine.if per body. The earlier loop
    is sunk to the later one, so any op with memory effects between the two
    loops blocks the fusion.

    With fuse-producer-consumer, a pair whose only conflicts are RAW (the
    earlier loop writes a memref that the later loop only reads) is also
    fused when affine dependence analysis proves that every value read at
    fused iteration i is written at an iteration <= i. fuse-war-waw applies
    the same check to WAR and WAW pairs.

    With fuse-across-intervening-ops, ops with memory effects between the
    loops are allowed when they commute with the earlier loop. With
    equate-reloads, re-loads of an unchanged location count as equal values
    when comparing loop bounds and reinterpret_cast views.

    With fuse-symbolic-bounds, pairs whose bound difference is not a constant
    or whose ranges only partially overlap are fused over the hull of both
    ranges (affine.min/max of symbol bounds) with every body guarded by its
    own range. With require-perfect-nests, a fusion is undone when the fused
    nest, after its inner loops were fused, has more imperfectly nested
    levels than the two input nests.
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
           "Assume distinct root memrefs may alias unless both are only read">,
    Option<"fuseProducerConsumer", "fuse-producer-consumer", "bool", /*default=*/"false",
           "Also fuse RAW producer-consumer pairs when affine dependence analysis "
           "proves the fused order preserves every dependence">,
    Option<"fuseWarWaw", "fuse-war-waw", "bool", /*default=*/"false",
           "Also fuse same-root WAR/WAW pairs when affine dependence analysis "
           "proves the fused order preserves every dependence">,
    Option<"fuseAcrossInterveningOps", "fuse-across-intervening-ops", "bool", /*default=*/"false",
           "Allow ops with memory effects between the two loops when they "
           "commute with the earlier loop (no RAW/WAR/WAW against its footprint)">,
    Option<"equateReloads", "equate-reloads", "bool", /*default=*/"false",
           "Treat loads of the same location as equal values when nothing "
           "between them may write it (used for loop bounds and memref views)">,
    Option<"fuseSymbolicBounds", "fuse-symbolic-bounds", "bool", /*default=*/"false",
           "Also fuse pairs whose bound difference is not a compile-time "
           "constant or whose ranges only partially overlap, over the hull of "
           "both ranges (affine.min/max bounds) with every body guarded">,
    Option<"requirePerfectNests", "require-perfect-nests", "bool", /*default=*/"false",
           "Undo a fusion when the inner loops of the fused nest do not fuse "
           "into a perfect nest, so fusion never leaves loops nested in a loop "
           "with other loops or effectful ops">
  ];
}

#endif  // LIB_TRANSFORM_AFFINE_PASSES_TD_
