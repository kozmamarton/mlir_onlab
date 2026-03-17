#include "Dialect/Noisy/NoisyDialect.h"

#include "Dialect/Noisy/NoisyOps.h"
#include "Dialect/Noisy/NoisyTypes.h"
#include "mlir/IR/Builders.h"
#include "llvm/ADT/TypeSwitch.h"

#include "Dialect/Noisy/NoisyDialect.cpp.inc"
#define GET_TYPEDEF_CLASSES
#include "Dialect/Noisy/NoisyTypes.cpp.inc"
#define GET_OP_CLASSES
#include "Dialect/Noisy/NoisyOps.cpp.inc"

namespace mlir {
namespace tutorial {
namespace noisy {

void NoisyDialect::initialize() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "lib/Dialect/Noisy/NoisyTypes.cpp.inc"
      >();
  addOperations<
#define GET_OP_LIST
#include "lib/Dialect/Noisy/NoisyOps.cpp.inc"
      >();
}

} // namespace noisy
} // namespace tutorial
} // namespace mlir
