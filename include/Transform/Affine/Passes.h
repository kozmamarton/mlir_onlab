#ifndef LIB_TRANSFORM_AFFINE_PASSES_H_
#define LIB_TRANSFORM_AFFINE_PASSES_H_

#include "Transform/Affine/AffineFullUnroll.h"
#include "Transform/Affine/AffineFullUnrollPatternRewrite.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_REGISTRATION
#define GEN_PASS_DECL_AFFINEFULLUNROLL
#include "Transform/Affine/Passes.h.inc"

}  // namespace tutorial
}  // namespace mlir

#endif  // LIB_TRANSFORM_AFFINE_PASSES_H_
