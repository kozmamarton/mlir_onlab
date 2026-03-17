#ifndef LIB_DIALECT_POLY_POLYOPS_H_
#define LIB_DIALECT_POLY_POLYOPS_H_

#include "Dialect/Poly/PolyDialect.h"
#include "Dialect/Poly/PolyTraits.h"
#include "Dialect/Poly/PolyTypes.h"
#include "mlir/Interfaces/InferTypeOpInterface.h" // from @llvm-project
#include "mlir/IR/BuiltinOps.h"      // from @llvm-project
#include "mlir/IR/BuiltinTypes.h"    // from @llvm-project
#include "mlir/IR/Dialect.h"         // from @llvm-project

#define GET_OP_CLASSES
#include "Dialect/Poly/PolyOps.h.inc"

#endif // LIB_DIALECT_POLY_POLYOPS_H_
