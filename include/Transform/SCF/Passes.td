#ifndef LIB_TRANSFORM_SCF_PASSES_TD_
#define LIB_TRANSFORM_SCF_PASSES_TD_

include "mlir/Pass/PassBase.td"

def SinkIntoNestedParallel : Pass<"scf-sink-into-nested-parallel"> {
  let summary = "Sink ops in front of a nested scf.parallel into it";
  let description = [{
    An scf.parallel whose body is ops followed by a single nested
    scf.parallel cannot be merged with it by canonicalization. This pass
    moves those ops into the innermost loop of the nested perfect chain when
    that is equivalent: every op is free of memory effects or only reads
    memrefs whose roots the nested loop does not write, and no op has a
    region. Neither loop may have reductions, and the nested bounds must not
    depend on the outer loop, as the merge pattern requires. Canonicalization
    afterwards merges the now perfect nest into one multi-dimensional loop.

    The values are recomputed in every inner iteration instead of once per
    outer iteration.
  }];
  let options = [
    Option<"aliasConservative", "alias-conservative", "bool", /*default=*/"false",
           "Assume distinct root memrefs may alias unless one of them is a "
           "distinct allocation (same model as affine-loop-fusion-non-conservative)">
  ];
}

def GpuCoalescedTiling : Pass<"scf-gpu-coalesced-tiling"> {
  let summary = "Tile and map scf.parallel nests so the stride-1 IV is threadIdx.x";
  let description = [{
    scf-parallel-loop-tiling takes one positional list of tile sizes for every
    nest, and gpu-map-parallel-loops assigns hardware ids by loop position, so
    neither can give the contiguous index of both (k, j, i) and (j, i) nests a
    32-wide x dimension. This pass picks, per outermost scf.parallel without
    reductions or nested scf.parallel, the induction variable that indexes
    memory with unit stride: the one that most memref accesses use as a plain
    addend of their last (or only) index, or the innermost one if none does.
    That IV is tiled by the x size of the block shape and mapped to block_x /
    thread_x. The remaining IVs, innermost first, get y and z; any further IVs
    stay sequential with tile size 1. The mapping attribute is written on both
    loops, so a later gpu-map-parallel-loops leaves them alone.
  }];
  let dependentDialects = ["arith::ArithDialect", "affine::AffineDialect",
                           "gpu::GPUDialect"];
  let options = [
    ListOption<"block3d", "block-3d", "int64_t",
               "Block shape (x, y, z) for nests with three or more IVs "
               "(default 32,4,2)">,
    ListOption<"block2d", "block-2d", "int64_t",
               "Block shape (x, y) for nests with two IVs (default 32,8)">,
    Option<"block1d", "block-1d", "int64_t", /*default=*/"256",
           "Block size for nests with one IV">
  ];
}

def OffloadHostLoops : Pass<"scf-offload-host-loops", "func::FuncOp"> {
  let summary = "Turn host scf.for nests over argument buffers into scf.parallel";
  let description = [{
    Only scf.parallel becomes a GPU kernel, so every scf.for left by the
    frontend runs on the host and touches the (managed) argument buffers
    there. This pass rewrites such nests into scf.parallel so they run on the
    device:

    1. A countdown scf.while whose counter lives in a scalar alloca
       (`for (k = n; k >= lo; k--)`) becomes an scf.for.
    2. Pure ops and loads of read-only scalar globals that do not depend on
       the nest are hoisted out of it.
    3. The perfect chain of scf.for / scf.parallel loops from the outermost
       loop is analysed. Several sibling scf.parallel loops in the last chain
       loop are treated as one loop over the union of their ranges. Every
       access to an argument buffer is delinearized by the stride atoms that
       multiply induction variables (im, im*jm, ...), assuming every subscript
       stays within its extent, as the C source does. An IV is parallel when,
       for every write and every access of the same buffer, some dimension
       has the subscript c*iv + r in both with the same c and the same
       loop-invariant r: equal addresses then imply equal IVs.
    4. The nest becomes one scf.parallel over the parallel IVs, with the other
       chain loops (a carried k sweep, for instance) serial inside it in their
       original order. Ops between chain loops move to their level of the new
       nest; they must be pure or read buffers the nest does not write.

    Finally, host loads of argument buffers whose values only feed a kernel
    are moved into it when nothing in between writes that buffer, so the host
    does not touch the buffer at all. Loads feeding host control flow stay.
  }];
  let dependentDialects = ["arith::ArithDialect", "scf::SCFDialect"];
  let options = [
    Option<"aliasConservative", "alias-conservative", "bool", /*default=*/"false",
           "Assume distinct root memrefs may alias unless one of them is a "
           "distinct allocation (same model as affine-loop-fusion-non-conservative)">
  ];
}

#endif  // LIB_TRANSFORM_SCF_PASSES_TD_
