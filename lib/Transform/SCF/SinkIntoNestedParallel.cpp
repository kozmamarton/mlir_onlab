#include "Transform/SCF/SinkIntoNestedParallel.h"
#include "Transform/MemoryModel.h"

#include <optional>

#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/Debug.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_DEF_SINKINTONESTEDPARALLEL
#include "Transform/SCF/Passes.h.inc"

#define DEBUG_TYPE "scf-sink-into-nested-parallel"

namespace {

// Whether canonicalization can merge `inner` into `outer` once `inner` is the
// only op in `outer`'s body: no reductions, and the inner bounds and steps
// are not defined inside `outer`.
bool mergeable(scf::ParallelOp outer, scf::ParallelOp inner) {
  if (!outer.getInitVals().empty() || !inner.getInitVals().empty())
    return false;
  Region &region = outer.getRegion();
  return llvm::none_of(inner.getOperands(), [&](Value v) {
    return region.isAncestor(v.getParentRegion());
  });
}

// The scf.parallel that is the only op (besides the terminator) of `loop`'s
// body, or null.
scf::ParallelOp singleNested(scf::ParallelOp loop) {
  Block *body = loop.getBody();
  if (!llvm::hasSingleElement(body->without_terminator()))
    return nullptr;
  return dyn_cast<scf::ParallelOp>(body->front());
}

struct SinkIntoNestedParallel
    : impl::SinkIntoNestedParallelBase<SinkIntoNestedParallel> {
  using SinkIntoNestedParallelBase::SinkIntoNestedParallelBase;

  void runOnOperation() override {
    MemoryModel model(aliasConservative);
    // Post-order: a nest is made perfect before the loop around it is
    // handled, so ops can be sunk through the whole chain.
    getOperation()->walk(
        [&](scf::ParallelOp outer) { sinkIntoNested(outer, model); });
  }

  // Whether `op` gives the same results inside every iteration of `nested`
  // as right before it: no regions, and no memory effects other than reads
  // of roots that `nested` does not write.
  static bool sinkable(Operation *op, const MemoryFootprint &nested,
                       MemoryModel &model) {
    if (op->getNumRegions() != 0)
      return false;
    if (isMemoryEffectFree(op))
      return true;
    auto iface = dyn_cast<MemoryEffectOpInterface>(op);
    if (!iface)
      return false;
    SmallVector<MemoryEffects::EffectInstance> effects;
    iface.getEffects(effects);
    return llvm::all_of(effects, [&](MemoryEffects::EffectInstance &effect) {
      Value v = effect.getValue();
      if (!isa<MemoryEffects::Read>(effect.getEffect()) || !v ||
          !isa<MemRefType>(v.getType()) ||
          !isa<SideEffects::DefaultResource>(effect.getResource()))
        return false;
      Value root = model.root(v);
      return llvm::none_of(nested.writes,
                           [&](Value w) { return model.mayAlias(w, root); });
    });
  }

  void sinkIntoNested(scf::ParallelOp outer, MemoryModel &model) {
    Block *body = outer.getBody();
    auto nested =
        dyn_cast_or_null<scf::ParallelOp>(body->getTerminator()->getPrevNode());
    if (!nested || !mergeable(outer, nested))
      return;
    SmallVector<Operation *> ops;
    for (Operation &op : body->without_terminator())
      if (&op != nested.getOperation())
        ops.push_back(&op);
    if (ops.empty())
      return;

    std::optional<MemoryFootprint> fp = model.footprint(
        ArrayRef<Operation *>(nested.getOperation()), /*skipRoots=*/false);
    if (!fp) {
      LLVM_DEBUG(llvm::dbgs() << "SKIP [nested footprint unsummarizable] "
                              << outer.getLoc() << "\n");
      return;
    }
    for (Operation *op : ops) {
      if (!sinkable(op, *fp, model)) {
        LLVM_DEBUG(llvm::dbgs() << "SKIP [not sinkable: " << op->getName()
                                << "] " << outer.getLoc() << "\n");
        return;
      }
    }

    // Every op is used only by later ops or inside `nested`, whose bounds do
    // not use them (mergeable), so moving them all in order keeps dominance.
    scf::ParallelOp target = nested;
    while (scf::ParallelOp next = singleNested(target)) {
      if (!mergeable(target, next))
        break;
      target = next;
    }
    Operation *first = &target.getBody()->front();
    for (Operation *op : ops)
      op->moveBefore(first);
    LLVM_DEBUG(llvm::dbgs() << "SINK [" << ops.size() << " ops] "
                            << outer.getLoc() << "\n");
  }
};

}  // namespace
}  // namespace tutorial
}  // namespace mlir
