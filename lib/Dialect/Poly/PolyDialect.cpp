#include "include/Dialect/Poly/PolyDialect.h"

#include "include/Dialect/Poly/PolyOps.h"
#include "include/Dialect/Poly/PolyTypes.h"
#include "mlir/include/mlir/IR/Builders.h"
#include "llvm/include/llvm/ADT/TypeSwitch.h"

#include "include/Dialect/Poly/PolyDialect.cpp.inc"
#define GET_TYPEDEF_CLASSES
#include "include/Dialect/Poly/PolyTypes.cpp.inc"
#define GET_OP_CLASSES
#include "include/Dialect/Poly/PolyOps.cpp.inc"

namespace mlir {
namespace tutorial {
namespace poly {

void PolyDialect::initialize() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "include/Dialect/Poly/PolyTypes.cpp.inc"
      >();
  addOperations<
#define GET_OP_LIST
#include "include/Dialect/Poly/PolyOps.cpp.inc"
      >();
}

Operation *PolyDialect::materializeConstant(OpBuilder &builder, Attribute value,
                                            Type type, Location loc) {
  auto coeffs = dyn_cast<DenseIntElementsAttr>(value);
  if (!coeffs)
    return nullptr;
  return builder.create<ConstantOp>(loc, type, coeffs);
}

} // namespace poly
} // namespace tutorial
} // namespace mlir
