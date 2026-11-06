#include "Transform/MemoryModel.h"

#include "mlir/Analysis/AliasAnalysis.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_DEF_AFFINESCALREPDISTINCTROOTS
#include "Transform/Affine/Passes.h.inc"

namespace {

// Alias implementation answering NoAlias for memrefs whose roots differ and
// MayAlias otherwise (deferring to the other implementations).
class DistinctRootAliasAnalysis {
public:
  AliasResult alias(Value lhs, Value rhs) {
    if (!isa<BaseMemRefType>(lhs.getType()) ||
        !isa<BaseMemRefType>(rhs.getType()))
      return AliasResult::MayAlias;
    return model.root(lhs) == model.root(rhs) ? AliasResult::MayAlias
                                              : AliasResult::NoAlias;
  }
  ModRefResult getModRef(Operation *, Value) {
    return ModRefResult::getModAndRef();
  }

private:
  MemoryModel model{/*conservative=*/false};
};

struct AffineScalrepDistinctRoots
    : impl::AffineScalrepDistinctRootsBase<AffineScalrepDistinctRoots> {
  void runOnOperation() override {
    func::FuncOp f = getOperation();
    AliasAnalysis aa(f);
    aa.addAnalysisImplementation(DistinctRootAliasAnalysis());
    DominanceInfo dom(f);
    PostDominanceInfo postDom(f);
    affine::affineScalarReplace(f, dom, postDom, aa);
  }
};

} // namespace
} // namespace tutorial
} // namespace mlir
