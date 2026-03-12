#ifndef LIB_TRANSFORM_ARITH_PASSES_H_
#define LIB_TRANSFORM_ARITH_PASSES_H_

#include "include/Transform/Arith/MulToAdd.h"
#include "include/Transform/Arith/MulToAddPdll.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_REGISTRATION
#include "include/Transform/Arith/Passes.h.inc"

}  // namespace tutorial
}  // namespace mlir

#endif  // LIB_TRANSFORM_ARITH_PASSES_H_
