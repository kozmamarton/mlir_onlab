#ifndef LIB_TRANSFORM_SCF_SINKINTONESTEDPARALLEL_H_
#define LIB_TRANSFORM_SCF_SINKINTONESTEDPARALLEL_H_

#include "mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_DECL_SINKINTONESTEDPARALLEL
#include "Transform/SCF/Passes.h.inc"

}  // namespace tutorial
}  // namespace mlir

#endif  // LIB_TRANSFORM_SCF_SINKINTONESTEDPARALLEL_H_
