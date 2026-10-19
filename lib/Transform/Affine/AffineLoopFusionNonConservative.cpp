#include "Transform/Affine/AffineLoopFusionNonConservative.h"

#include <optional>
#include <string>

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "mlir/Dialect/Affine/Analysis/AffineAnalysis.h"
#include "mlir/Dialect/Affine/Analysis/AffineStructures.h"
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

#define DEBUG_TYPE "affine-loop-fusion-non-conservative"

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
// cannot be summarised per root memref. `blocker` (optional) receives the op
// that made the summary impossible.
std::optional<MemoryFootprint> collectFootprint(AffineForOp loop,
                                                Operation **blocker = nullptr) {
  MemoryFootprint fp;
  WalkResult result = loop->walk([&](Operation *op) {
    if (op == loop.getOperation() ||
        op->hasTrait<OpTrait::HasRecursiveMemoryEffects>())
      return WalkResult::advance();
    auto iface = dyn_cast<MemoryEffectOpInterface>(op);
    if (!iface) {
      if (blocker)
        *blocker = op;
      return WalkResult::interrupt();
    }
    SmallVector<MemoryEffects::EffectInstance> effects;
    iface.getEffects(effects);
    for (auto &effect : effects) {
      Value v = effect.getValue();
      if (!v || !isa<MemRefType>(v.getType()) ||
          !isa<SideEffects::DefaultResource>(effect.getResource())) {
        if (blocker)
          *blocker = op;
        return WalkResult::interrupt();
      }
      if (isa<MemoryEffects::Read>(effect.getEffect()))
        fp.reads.insert(getRootMemref(v));
      else if (isa<MemoryEffects::Write>(effect.getEffect()))
        fp.writes.insert(getRootMemref(v));
      else {
        if (blocker)
          *blocker = op;
        return WalkResult::interrupt();
      }
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

// Returns the roots written by `a` and read by `b` when every conflict between
// the two footprints is such a RAW pair on one root; std::nullopt otherwise
// (WAR, WAW, or a conflict between distinct roots that may alias).
std::optional<SmallVector<Value>> classifyProducerConsumer(
    const MemoryFootprint &a, const MemoryFootprint &b, bool conservative) {
  SmallVector<Value> rawRoots;
  for (Value w : a.writes) {
    for (Value r : b.writes)
      if (mayAlias(w, r, conservative))
        return std::nullopt;
    for (Value r : b.reads) {
      if (!mayAlias(w, r, conservative))
        continue;
      if (w != r)
        return std::nullopt;
      rawRoots.push_back(r);
    }
  }
  for (Value w : b.writes)
    for (Value r : a.reads)
      if (mayAlias(w, r, conservative))
        return std::nullopt;
  return rawRoots;
}

// Collects the ops in `loop` that write (`wantWrites`) or read `root`. Fails
// when such an op is not an affine write/read, since the dependence analysis
// could not see it. The footprint walk already proved every op is summarisable.
LogicalResult collectRootAccesses(AffineForOp loop, Value root, bool wantWrites,
                                  SmallVectorImpl<Operation *> &accesses) {
  WalkResult result = loop->walk([&](Operation *op) {
    auto iface = dyn_cast<MemoryEffectOpInterface>(op);
    if (!iface)
      return WalkResult::advance();
    SmallVector<MemoryEffects::EffectInstance> effects;
    iface.getEffects(effects);
    for (auto &effect : effects) {
      bool kindMatches = wantWrites
                             ? isa<MemoryEffects::Write>(effect.getEffect())
                             : isa<MemoryEffects::Read>(effect.getEffect());
      if (!kindMatches || getRootMemref(effect.getValue()) != root)
        continue;
      bool affine = wantWrites ? isa<affine::AffineWriteOpInterface>(op)
                               : isa<affine::AffineReadOpInterface>(op);
      if (!affine)
        return WalkResult::interrupt();
      accesses.push_back(op);
      return WalkResult::advance();
    }
    return WalkResult::advance();
  });
  return failure(result.wasInterrupted());
}

Value getAccessMemref(Operation *op) {
  if (auto read = dyn_cast<affine::AffineReadOpInterface>(op))
    return read.getMemRef();
  return cast<affine::AffineWriteOpInterface>(op).getMemRef();
}

// Returns one memref value that stands for every access in `accesses`: the
// shared value itself, or the first of several structurally identical
// memref.reinterpret_cast views. Returns null when the accesses go through
// different index spaces.
Value canonicalAccessMemref(ArrayRef<Operation *> accesses) {
  Value first = getAccessMemref(accesses.front());
  auto firstCast = first.getDefiningOp<memref::ReinterpretCastOp>();
  for (Operation *op : accesses) {
    Value v = getAccessMemref(op);
    if (v == first)
      continue;
    auto cast = v.getDefiningOp<memref::ReinterpretCastOp>();
    if (!firstCast || !cast ||
        !OperationEquivalence::isEquivalentTo(
            firstCast, cast, OperationEquivalence::IgnoreLocations))
      return nullptr;
  }
  return first;
}

enum class ProducerConsumerVerdict {
  Legal,
  NonAffineAccess,
  ViewMismatch,
  DependenceViolated,
  AnalysisFailure,
};

const char *verdictReason(ProducerConsumerVerdict v) {
  switch (v) {
  case ProducerConsumerVerdict::Legal:
    return "legal";
  case ProducerConsumerVerdict::NonAffineAccess:
    return "producer-consumer-non-affine-access";
  case ProducerConsumerVerdict::ViewMismatch:
    return "producer-consumer-view-mismatch";
  case ProducerConsumerVerdict::DependenceViolated:
    return "producer-consumer-dependence-violated";
  case ProducerConsumerVerdict::AnalysisFailure:
    return "producer-consumer-analysis-failure";
  }
  llvm_unreachable("unknown verdict");
}

// Fusing places a's body before b's body in every iteration of one loop whose
// induction variable stands for both original ones. The fusion preserves every
// RAW dependence on `rawRoots` iff no write in `a` at iteration iv_a reaches a
// read in `b` at iteration iv_b < iv_a.
ProducerConsumerVerdict checkProducerConsumer(AffineForOp a, AffineForOp b,
                                              ArrayRef<Value> rawRoots) {
  unsigned numCommon = 0;
  for (Operation *p = a->getParentOp(); p; p = p->getParentOp())
    if (isa<AffineForOp>(p))
      ++numCommon;

  for (Value root : rawRoots) {
    SmallVector<Operation *> writes, reads;
    if (failed(collectRootAccesses(a, root, /*wantWrites=*/true, writes)) ||
        failed(collectRootAccesses(b, root, /*wantWrites=*/false, reads)))
      return ProducerConsumerVerdict::NonAffineAccess;
    if (writes.empty() || reads.empty())
      return ProducerConsumerVerdict::AnalysisFailure;

    SmallVector<Operation *> all(writes);
    all.append(reads.begin(), reads.end());
    Value memref = canonicalAccessMemref(all);
    if (!memref)
      return ProducerConsumerVerdict::ViewMismatch;

    for (Operation *w : writes) {
      affine::MemRefAccess src(w);
      src.memref = memref;
      for (Operation *r : reads) {
        affine::MemRefAccess dst(r);
        dst.memref = memref;
        affine::FlatAffineValueConstraints dep;
        affine::DependenceResult res = affine::checkMemrefAccessDependence(
            src, dst, numCommon + 1, &dep);
        if (res.value == affine::DependenceResult::Failure)
          return ProducerConsumerVerdict::AnalysisFailure;
        if (affine::noDependence(res))
          continue;
        unsigned posA, posB;
        if (!dep.findVar(a.getInductionVar(), &posA) ||
            !dep.findVar(b.getInductionVar(), &posB))
          return ProducerConsumerVerdict::AnalysisFailure;
        // iv_a - iv_b - 1 >= 0: the write happens at a later fused iteration.
        SmallVector<int64_t> ineq(dep.getNumCols(), 0);
        ineq[posA] = 1;
        ineq[posB] = -1;
        ineq.back() = -1;
        dep.addInequality(ineq);
        if (!dep.isEmpty())
          return ProducerConsumerVerdict::DependenceViolated;
      }
    }
  }
  return ProducerConsumerVerdict::Legal;
}

// Debug-only: prints every conflicting root pair between loops a and b.
[[maybe_unused]] void explainConflict(const MemoryFootprint &a,
                                      const MemoryFootprint &b,
                                      bool conservative,
                                      llvm::raw_ostream &os) {
  for (Value w : a.writes) {
    for (Value r : b.reads)
      if (mayAlias(w, r, conservative))
        os << "    RAW (a writes, b reads): " << w << "\n";
    for (Value r : b.writes)
      if (mayAlias(w, r, conservative))
        os << "    WAW (both write): " << w << "\n";
  }
  for (Value w : b.writes)
    for (Value r : a.reads)
      if (mayAlias(w, r, conservative))
        os << "    WAR (a reads, b writes): " << w << "\n";
}

// Debug-only: function name, nesting depth, sibling ordinal, step and bounds.
[[maybe_unused]] std::string describeLoop(AffineForOp loop) {
  std::string s;
  llvm::raw_string_ostream os(s);
  unsigned depth = 0;
  for (Operation *p = loop->getParentOp(); p; p = p->getParentOp())
    if (isa<AffineForOp>(p))
      ++depth;
  unsigned idx = 0;
  for (Operation &op : *loop->getBlock()) {
    if (&op == loop.getOperation())
      break;
    if (isa<AffineForOp>(op))
      ++idx;
  }
  auto fn = loop->getParentOfType<func::FuncOp>();
  os << "@" << (fn ? fn.getName() : StringRef("?")) << " depth=" << depth
     << " loop#" << idx << " step=" << loop.getStepAsInt()
     << " lb=" << loop.getLowerBoundMap() << " ub=" << loop.getUpperBoundMap();
  return os.str();
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
    [[maybe_unused]] auto reject = [&](AffineForOp b,
                                       const Twine &why) -> AffineForOp {
      LLVM_DEBUG(llvm::dbgs() << "REJECT [" << why << "]\n  a: "
                              << describeLoop(a) << "\n  b: "
                              << describeLoop(b) << "\n");
      return nullptr;
    };

    Operation *next = a->getNextNode();
    while (next && !isa<AffineForOp>(next)) {
      if (!isMemoryEffectFree(next)) {
        LLVM_DEBUG({
          Operation *cand = next;
          while (cand && !isa<AffineForOp>(cand))
            cand = cand->getNextNode();
          if (cand)
            llvm::dbgs() << "REJECT [intervening-op-with-memory-effects: "
                         << next->getName() << "]\n  a: " << describeLoop(a)
                         << "\n  b: " << describeLoop(cast<AffineForOp>(cand))
                         << "\n";
        });
        return nullptr;
      }
      next = next->getNextNode();
    }
    if (!next)
      return nullptr;
    AffineForOp b = cast<AffineForOp>(next);

    if (a.getNumResults() != 0 || b.getNumResults() != 0)
      return reject(b, "loop-has-results");
    if (a.getStepAsInt() != b.getStepAsInt())
      return reject(b, "step-mismatch");
    if (countOf(a) + countOf(b) > maxFusedLoops)
      return reject(b, Twine("max-fused-loops count=") +
                           Twine(countOf(a) + countOf(b)));
    if (a.getLowerBoundMap().getNumResults() != 1 ||
        a.getUpperBoundMap().getNumResults() != 1 ||
        b.getLowerBoundMap().getNumResults() != 1 ||
        b.getUpperBoundMap().getNumResults() != 1)
      return reject(b, "multi-result-bound");

    // Offsets of b's bounds relative to a's bounds.
    std::optional<int64_t> dl = constantDifference(
        b.getLowerBoundMap(), b.getLowerBoundOperands(), a.getLowerBoundMap(),
        a.getLowerBoundOperands());
    std::optional<int64_t> du = constantDifference(
        b.getUpperBoundMap(), b.getUpperBoundOperands(), a.getUpperBoundMap(),
        a.getUpperBoundOperands());
    if (!dl || !du)
      return reject(b, Twine("non-constant-bound-difference lower=") +
                           (dl ? "const" : "non-const") + " upper=" +
                           (du ? "const" : "non-const"));

    bool matching = *dl == 0 && *du == 0;
    bool aContainsB = *dl >= 0 && *du <= 0;
    bool bContainsA = *dl <= 0 && *du >= 0;
    if (matching ? !fuseMatchingBounds : !fuseMismatchedBounds)
      return reject(b, matching ? "matching-bounds-disabled"
                                : "mismatched-bounds-disabled");
    if (!aContainsB && !bContainsA)
      return reject(b, Twine("partial-overlap dl=") + Twine(*dl) + " du=" +
                           Twine(*du));
    // A shifted lower bound must keep the iteration phase of the step.
    if (*dl % a.getStepAsInt() != 0)
      return reject(b, Twine("lower-offset-not-multiple-of-step dl=") +
                           Twine(*dl) + " step=" + Twine(a.getStepAsInt()));

    Operation *blockerA = nullptr, *blockerB = nullptr;
    std::optional<MemoryFootprint> fa = collectFootprint(a, &blockerA);
    std::optional<MemoryFootprint> fb = collectFootprint(b, &blockerB);
    if (!fa || !fb) {
      Operation *blk = !fa ? blockerA : blockerB;
      return reject(b, Twine("footprint-unsummarizable in ") +
                           (!fa ? "a" : "b") + ": " +
                           (blk ? blk->getName().getStringRef() : "?"));
    }
    bool producerConsumer = false;
    if (hasConflict(*fa, *fb, aliasConservative)) {
      std::optional<SmallVector<Value>> rawRoots;
      if (fuseProducerConsumer)
        rawRoots = classifyProducerConsumer(*fa, *fb, aliasConservative);
      ProducerConsumerVerdict verdict =
          rawRoots ? checkProducerConsumer(a, b, *rawRoots)
                   : ProducerConsumerVerdict::AnalysisFailure;
      if (!rawRoots || verdict != ProducerConsumerVerdict::Legal) {
        LLVM_DEBUG({
          llvm::dbgs() << "REJECT [memory-conflict";
          if (fuseProducerConsumer)
            llvm::dbgs() << ": "
                         << (rawRoots ? verdictReason(verdict)
                                      : "producer-consumer-non-raw-conflict");
          llvm::dbgs() << "]\n  a: " << describeLoop(a)
                       << "\n  b: " << describeLoop(b) << "\n";
          explainConflict(*fa, *fb, aliasConservative, llvm::dbgs());
        });
        return nullptr;
      }
      producerConsumer = true;
    }

    LLVM_DEBUG(llvm::dbgs()
               << "FUSE [" << (producerConsumer ? "producer-consumer, " : "")
               << (matching ? "matching"
                            : (aContainsB ? "a-contains-b, guard b"
                                          : "b-contains-a, guard a"))
               << " dl=" << *dl << " du=" << *du << "]\n  a: "
               << describeLoop(a) << "\n  b: " << describeLoop(b) << "\n");

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
