#ifndef LIB_TRANSFORM_MEMORYMODEL_H_
#define LIB_TRANSFORM_MEMORYMODEL_H_

#include <optional>
#include <utility>

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/Operation.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/ViewLikeInterface.h"

namespace mlir {
namespace tutorial {

// Root memrefs read and written by a set of ops.
struct MemoryFootprint {
  llvm::DenseSet<Value> reads;
  llvm::DenseSet<Value> writes;
};

// Resolves memrefs to the root they view and decides whether two roots may
// alias. Separate memref.get_global ops of one symbol return the same memory,
// so they all resolve to the first such value seen. Distinct roots never alias
// unless `conservative`; then they may alias unless one of them is a distinct
// allocation.
class MemoryModel {
public:
  explicit MemoryModel(bool conservative) : conservative(conservative) {}

  Value root(Value v) {
    while (true) {
      if (auto view = v.getDefiningOp<ViewLikeOpInterface>()) {
        v = view.getViewSource();
        continue;
      }
      if (auto cast = v.getDefiningOp<memref::CastOp>()) {
        v = cast.getSource();
        continue;
      }
      break;
    }
    if (auto global = v.getDefiningOp<memref::GetGlobalOp>())
      return globalRoots.try_emplace(global.getNameAttr(), v).first->second;
    return v;
  }

  static bool isDistinctAllocation(Value root) {
    Operation *def = root.getDefiningOp();
    return def &&
           isa<memref::AllocOp, memref::AllocaOp, memref::GetGlobalOp>(def);
  }

  bool mayAlias(Value a, Value b) const {
    if (a == b)
      return true;
    return conservative && !isDistinctAllocation(a) &&
           !isDistinctAllocation(b);
  }

  // Footprint of `ops` and everything nested in them (excluding the ops
  // themselves when `skipRoots`). std::nullopt when some op's memory behaviour
  // cannot be summarised per root memref; `blocker` then receives that op.
  std::optional<MemoryFootprint> footprint(ArrayRef<Operation *> ops,
                                           bool skipRoots,
                                           Operation **blocker = nullptr) {
    MemoryFootprint fp;
    for (Operation *top : ops) {
      WalkResult result = top->walk([&](Operation *op) {
        if ((skipRoots && op == top) || addEffects(op, fp))
          return WalkResult::advance();
        if (blocker)
          *blocker = op;
        return WalkResult::interrupt();
      });
      if (result.wasInterrupted())
        return std::nullopt;
    }
    return fp;
  }

  // Whether an op strictly between `x` and `y` may write `root`. Ops in
  // different blocks are treated as separated by a write.
  bool mayWriteBetween(Operation *x, Operation *y, Value root) {
    if (x->getBlock() != y->getBlock())
      return true;
    if (y->isBeforeInBlock(x))
      std::swap(x, y);
    for (Operation *op = x->getNextNode(); op != y; op = op->getNextNode()) {
      std::optional<MemoryFootprint> fp =
          footprint(ArrayRef<Operation *>(op), /*skipRoots=*/false);
      if (!fp)
        return true;
      if (llvm::any_of(fp->writes, [&](Value w) { return mayAlias(w, root); }))
        return true;
    }
    return false;
  }

private:
  // Adds the effects of `op` itself (not of nested ops) to `fp`. Returns false
  // when they cannot be summarised per root memref.
  bool addEffects(Operation *op, MemoryFootprint &fp) {
    if (op->hasTrait<OpTrait::HasRecursiveMemoryEffects>())
      return true;
    auto iface = dyn_cast<MemoryEffectOpInterface>(op);
    if (!iface)
      return false;
    SmallVector<MemoryEffects::EffectInstance> effects;
    iface.getEffects(effects);
    for (auto &effect : effects) {
      Value v = effect.getValue();
      if (!v || !isa<MemRefType>(v.getType()) ||
          !isa<SideEffects::DefaultResource>(effect.getResource()))
        return false;
      if (isa<MemoryEffects::Read>(effect.getEffect()))
        fp.reads.insert(root(v));
      else if (isa<MemoryEffects::Write>(effect.getEffect()))
        fp.writes.insert(root(v));
      else
        return false;
    }
    return true;
  }

  bool conservative;
  llvm::DenseMap<Attribute, Value> globalRoots;
};

}  // namespace tutorial
}  // namespace mlir

#endif  // LIB_TRANSFORM_MEMORYMODEL_H_
