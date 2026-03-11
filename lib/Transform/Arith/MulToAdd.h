#ifndef LIB_TRANSFORM_ARITH_MULTOADD_H_
#define LIB_TRANSFORM_ARITH_MULTOADD_H_

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/include/mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {
  #define GEN_PASS_DECL_MULTOADD
  #include "lib/Transform/Affine/Arith/Passes.h.inc"


} // namespace tutorial
} // namespace mlir

#endif // LIB_TRANSFORM_ARITH_MULTOADD_H_