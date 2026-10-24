#ifndef LIB_TRANSFORM_SCF_PASSES_H_
#define LIB_TRANSFORM_SCF_PASSES_H_

#include "Transform/SCF/SinkIntoNestedParallel.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_REGISTRATION
#include "Transform/SCF/Passes.h.inc"

}  // namespace tutorial
}  // namespace mlir

#endif  // LIB_TRANSFORM_SCF_PASSES_H_
