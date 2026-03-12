#ifndef LIB_TRANSFORM_AFFINE_AFFINEFULLUNROLL_H_
#define LIB_TRANSFORM_AFFINE_AFFINEFULLUNROLL_H_
#include "mlir/Pass/Pass.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"

namespace mlir {
namespace tutorial {
#define GEN_PASS_DECL_AFFINEFULLUNROLL
#include "include/Transform/Affine/Passes.h.inc"

  }  // namespace mlir
} // namespace mlir
#endif  // LIB_TRANSFORM_AFFINE_AFFINEFULLUNROLL_H_
