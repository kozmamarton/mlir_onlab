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

#endif  // LIB_TRANSFORM_SCF_PASSES_TD_
