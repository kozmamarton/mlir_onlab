#ifndef LIB_TRANSFORM_AFFINE_REINTERPRETFLATARRAYACCESS_H_
#define LIB_TRANSFORM_AFFINE_REINTERPRETFLATARRAYACCESS_H_

#include "mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_DECL_REINTERPRETFLATARRAYACCESS
#include "Transform/Affine/Passes.h.inc"

}  // namespace tutorial
}  // namespace mlir

#endif  // LIB_TRANSFORM_AFFINE_REINTERPRETFLATARRAYACCESS_H_
