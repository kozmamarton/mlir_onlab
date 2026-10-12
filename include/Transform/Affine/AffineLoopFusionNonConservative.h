#ifndef LIB_TRANSFORM_AFFINE_AFFINELOOPFUSIONNONCONSERVATIVE_H_
#define LIB_TRANSFORM_AFFINE_AFFINELOOPFUSIONNONCONSERVATIVE_H_

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_DECL_AFFINELOOPFUSIONNONCONSERVATIVE
#include "Transform/Affine/Passes.h.inc"

}  // namespace tutorial
}  // namespace mlir

#endif  // LIB_TRANSFORM_AFFINE_AFFINELOOPFUSIONNONCONSERVATIVE_H_
