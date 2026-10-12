#include "Transform/Affine/AffineLoopFusionNonConservative.h"

#include <optional>

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/IR/AffineValueMap.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/IntegerSet.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/ViewLikeInterface.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_DEF_AFFINELOOPFUSIONNONCONSERVATIVE
#include "Transform/Affine/Passes.h.inc"

using affine::AffineForOp;
using affine::AffineIfOp;

namespace {

struct MemoryFootprint {
  llvm::DenseSet<Value> reads;
  llvm::DenseSet<Value> writes;
};

Value getRootMemref(Value v) {
  while (true) {
    if (auto view = v.getDefiningOp<ViewLikeOpInterface>()) {
      v = view.getViewSource();
      continue;
    }
    if (auto cast = v.getDefiningOp<memref::CastOp>()) {
      v = cast.getSource();
      continue;
    }
    return v;
  }
}

bool isDistinctAllocation(Value root) {
  Operation *def = root.getDefiningOp();
  return def && isa<memref::AllocOp, memref::AllocaOp, memref::GetGlobalOp>(def);
}

// Returns std::nullopt when the loop contains anything whose memory behaviour
// cannot be summarised per root memref.
std::optional<MemoryFootprint> collectFootprint(AffineForOp loop) {
  MemoryFootprint fp;
  WalkResult result = loop->walk([&](Operation *op) {
    if (op == loop.getOperation() ||
        op->hasTrait<OpTrait::HasRecursiveMemoryEffects>())
      return WalkResult::advance();
    auto iface = dyn_cast<MemoryEffectOpInterface>(op);
    if (!iface)
      return WalkResult::interrupt();
    SmallVector<MemoryEffects::EffectInstance> effects;
    iface.getEffects(effects);
    for (auto &effect : effects) {
      Value v = effect.getValue();
      if (!v || !isa<MemRefType>(v.getType()) ||
          !isa<SideEffects::DefaultResource>(effect.getResource()))
        return WalkResult::interrupt();
      if (isa<MemoryEffects::Read>(effect.getEffect()))
        fp.reads.insert(getRootMemref(v));
      else if (isa<MemoryEffects::Write>(effect.getEffect()))
        fp.writes.insert(getRootMemref(v));
      else
        return WalkResult::interrupt();
    }
    return WalkResult::advance();
  });
  if (result.wasInterrupted())
    return std::nullopt;
  return fp;
}

bool mayAlias(Value a, Value b, bool conservative) {
  if (a == b)
    return true;
  return conservative && !isDistinctAllocation(a) && !isDistinctAllocation(b);
}

bool hasConflict(const MemoryFootprint &a, const MemoryFootprint &b,
                 bool conservative) {
  auto conflictsWith = [&](const llvm::DenseSet<Value> &writes,
                           const MemoryFootprint &other) {
    for (Value w : writes) {
      for (Value r : other.reads)
        if (mayAlias(w, r, conservative))
          return true;
      for (Value r : other.writes)
        if (mayAlias(w, r, conservative))
          return true;
    }
    return false;
  };
  return conflictsWith(a.writes, b) || conflictsWith(b.writes, a);
}

// Returns x - y when it is a compile-time constant.
std::optional<int64_t> constantDifference(AffineMap mapX, ValueRange opsX,
                                          AffineMap mapY, ValueRange opsY) {
  affine::AffineValueMap x(mapX, opsX), y(mapY, opsY), diff;
  affine::AffineValueMap::difference(x, y, &diff);
  AffineMap map = diff.getAffineMap();
  SmallVector<Value> operands(diff.getOperands());
  affine::fullyComposeAffineMapAndOperands(&map, &operands);
  affine::canonicalizeMapAndOperands(&map, &operands);
  map = simplifyAffineMap(map);
  if (map.getNumResults() != 1)
    return std::nullopt;
  if (auto c = dyn_cast<AffineConstantExpr>(map.getResult(0)))
    return c.getValue();
  return std::nullopt;
}

struct AffineLoopFusionNonConservative
    : impl::AffineLoopFusionNonConservativeBase<AffineLoopFusionNonConservative> {
  using AffineLoopFusionNonConservativeBase::
      AffineLoopFusionNonConservativeBase;

  // Number of original loops merged into each loop; absent means 1.
  llvm::DenseMap<Operation *, unsigned> fusedCount;

  unsigned countOf(Operation *op) const {
    auto it = fusedCount.find(op);
    return it == fusedCount.end() ? 1 : it->second;
  }

  void runOnOperation() override {
    fusedCount.clear();
    for (Region &region : getOperation()->getRegions())
      for (Block &block : region)
        processBlock(block);
  }

  void processBlock(Block &block) {
    Operation *cur = block.empty() ? nullptr : &block.front();
    while (cur) {
      if (auto loop = dyn_cast<AffineForOp>(cur)) {
        if (AffineForOp fused = tryFuseWithNext(loop)) {
          cur = fused.getOperation();
          continue;
        }
      }
      cur = cur->getNextNode();
    }
    // Fusion may have made inner loops siblings, so recurse afterwards.
    for (Operation &op : block)
      for (Region &region : op.getRegions())
        for (Block &inner : region)
          processBlock(inner);
  }

  // Guards the iterations that lie inside the fused loop's bounds shifted by
  // lowerShift (>= 0) at the bottom and upperShift (<= 0) at the top.
  AffineIfOp buildGuard(AffineForOp fused, int64_t lowerShift,
                        int64_t upperShift) {
    OpBuilder builder(fused.getBody()->getTerminator());
    MLIRContext *ctx = fused.getContext();
    SmallVector<Value> operands{fused.getInductionVar()};
    SmallVector<AffineExpr> constraints;
    AffineExpr iv = getAffineDimExpr(0, ctx);

    // Bound operands are appended as extra dims of the integer set.
    auto appendBound = [&](AffineMap map, ValueRange ops) {
      unsigned base = operands.size();
      SmallVector<AffineExpr> dims, syms;
      for (unsigned k = 0; k < map.getNumDims(); ++k)
        dims.push_back(getAffineDimExpr(base + k, ctx));
      for (unsigned k = 0; k < map.getNumSymbols(); ++k)
        syms.push_back(getAffineDimExpr(base + map.getNumDims() + k, ctx));
      operands.append(ops.begin(), ops.end());
      return map.getResult(0).replaceDimsAndSymbols(dims, syms);
    };

    if (lowerShift > 0) {
      AffineExpr lb = appendBound(fused.getLowerBoundMap(),
                                  fused.getLowerBoundOperands());
      constraints.push_back(iv - lb - lowerShift);
    }
    if (upperShift < 0) {
      AffineExpr ub = appendBound(fused.getUpperBoundMap(),
                                  fused.getUpperBoundOperands());
      constraints.push_back(ub + upperShift - 1 - iv);
    }
    SmallVector<bool> isEq(constraints.size(), false);
    IntegerSet set = IntegerSet::get(operands.size(), 0, constraints, isEq);
    affine::canonicalizeSetAndOperands(&set, &operands);
    return builder.create<AffineIfOp>(fused.getLoc(), set, operands,
                                      /*withElseRegion=*/false);
  }

  void moveBody(AffineForOp src, AffineForOp fused, bool guarded,
                int64_t lowerShift, int64_t upperShift) {
    src.getInductionVar().replaceAllUsesWith(fused.getInductionVar());
    Block *dstBlock = fused.getBody();
    Operation *before = dstBlock->getTerminator();
    if (guarded) {
      AffineIfOp guard = buildGuard(fused, lowerShift, upperShift);
      dstBlock = guard.getThenBlock();
      before = dstBlock->getTerminator();
    }
    Block *srcBlock = src.getBody();
    dstBlock->getOperations().splice(
        before->getIterator(), srcBlock->getOperations(), srcBlock->begin(),
        Block::iterator(srcBlock->getTerminator()));
  }

  // Fuses `a` with the next sibling loop when allowed; returns the fused loop
  // (placed where the later loop was) or a null op.
  AffineForOp tryFuseWithNext(AffineForOp a) {
    Operation *next = a->getNextNode();
    while (next && !isa<AffineForOp>(next)) {
      if (!isMemoryEffectFree(next))
        return nullptr;
      next = next->getNextNode();
    }
    if (!next)
      return nullptr;
    AffineForOp b = cast<AffineForOp>(next);

    if (a.getNumResults() != 0 || b.getNumResults() != 0)
      return nullptr;
    if (a.getStepAsInt() != b.getStepAsInt())
      return nullptr;
    if (countOf(a) + countOf(b) > maxFusedLoops)
      return nullptr;
    if (a.getLowerBoundMap().getNumResults() != 1 ||
        a.getUpperBoundMap().getNumResults() != 1 ||
        b.getLowerBoundMap().getNumResults() != 1 ||
        b.getUpperBoundMap().getNumResults() != 1)
      return nullptr;

    // Offsets of b's bounds relative to a's bounds.
    std::optional<int64_t> dl = constantDifference(
        b.getLowerBoundMap(), b.getLowerBoundOperands(), a.getLowerBoundMap(),
        a.getLowerBoundOperands());
    std::optional<int64_t> du = constantDifference(
        b.getUpperBoundMap(), b.getUpperBoundOperands(), a.getUpperBoundMap(),
        a.getUpperBoundOperands());
    if (!dl || !du)
      return nullptr;

    bool matching = *dl == 0 && *du == 0;
    bool aContainsB = *dl >= 0 && *du <= 0;
    bool bContainsA = *dl <= 0 && *du >= 0;
    if (matching ? !fuseMatchingBounds : !fuseMismatchedBounds)
      return nullptr;
    if (!aContainsB && !bContainsA)
      return nullptr;
    // A shifted lower bound must keep the iteration phase of the step.
    if (*dl % a.getStepAsInt() != 0)
      return nullptr;

    std::optional<MemoryFootprint> fa = collectFootprint(a);
    std::optional<MemoryFootprint> fb = collectFootprint(b);
    if (!fa || !fb || hasConflict(*fa, *fb, aliasConservative))
      return nullptr;

    AffineForOp big = aContainsB ? a : b;
    OpBuilder builder(b);
    auto fused = builder.create<AffineForOp>(
        a.getLoc(), big.getLowerBoundOperands(), big.getLowerBoundMap(),
        big.getUpperBoundOperands(), big.getUpperBoundMap(), a.getStepAsInt());

    bool guardA = !matching && !aContainsB;
    bool guardB = !matching && aContainsB;
    int64_t lowerShift = aContainsB ? *dl : -*dl;
    int64_t upperShift = aContainsB ? *du : -*du;
    moveBody(a, fused, guardA, lowerShift, upperShift);
    moveBody(b, fused, guardB, lowerShift, upperShift);

    fusedCount[fused] = countOf(a) + countOf(b);
    fusedCount.erase(a);
    fusedCount.erase(b);
    a.erase();
    b.erase();
    return fused;
  }
};

}  // namespace
}  // namespace tutorial
}  // namespace mlir
