#include "Transform/Affine/AffineLoopFusionNonConservative.h"
#include "Transform/MemoryModel.h"

#include <optional>
#include <string>
#include <utility>

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "mlir/Dialect/Affine/Analysis/AffineAnalysis.h"
#include "mlir/Dialect/Affine/Analysis/AffineStructures.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/IR/AffineValueMap.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/IRMapping.h"
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

enum class DepKind { RAW, WAR, WAW };

const char *depKindName(DepKind k) {
  switch (k) {
  case DepKind::RAW:
    return "RAW";
  case DepKind::WAR:
    return "WAR";
  case DepKind::WAW:
    return "WAW";
  }
  llvm_unreachable("unknown dependence kind");
}

using RootConflict = std::pair<Value, DepKind>;

// The shared memory model plus the queries the fusion legality checks need.
class FusionMemoryModel : public MemoryModel {
public:
  using MemoryModel::MemoryModel;
  using MemoryModel::footprint;

  std::optional<MemoryFootprint> footprint(AffineForOp loop,
                                           Operation **blocker = nullptr) {
    return footprint(ArrayRef<Operation *>(loop.getOperation()),
                     /*skipRoots=*/true, blocker);
  }

  bool hasConflict(const MemoryFootprint &a, const MemoryFootprint &b) const {
    return !conflictKinds(a, b).empty();
  }

  // Kinds of conflicts between `a` (executed first) and `b`.
  SmallVector<DepKind> conflictKinds(const MemoryFootprint &a,
                                     const MemoryFootprint &b) const {
    SmallVector<DepKind> kinds;
    auto any = [&](const llvm::DenseSet<Value> &x,
                   const llvm::DenseSet<Value> &y) {
      return llvm::any_of(x, [&](Value v) {
        return llvm::any_of(y, [&](Value w) { return mayAlias(v, w); });
      });
    };
    if (any(a.writes, b.reads))
      kinds.push_back(DepKind::RAW);
    if (any(a.reads, b.writes))
      kinds.push_back(DepKind::WAR);
    if (any(a.writes, b.writes))
      kinds.push_back(DepKind::WAW);
    return kinds;
  }

  // Every conflict as (root, kind) when all of them are on one shared root;
  // std::nullopt when two distinct roots that may alias conflict.
  std::optional<SmallVector<RootConflict>>
  sameRootConflicts(const MemoryFootprint &a, const MemoryFootprint &b) const {
    SmallVector<RootConflict> out;
    auto add = [&](Value w, Value r, DepKind kind) {
      if (!mayAlias(w, r))
        return true;
      if (w != r)
        return false;
      RootConflict c{w, kind};
      if (!llvm::is_contained(out, c))
        out.push_back(c);
      return true;
    };
    for (Value w : a.writes) {
      for (Value r : b.reads)
        if (!add(w, r, DepKind::RAW))
          return std::nullopt;
      for (Value r : b.writes)
        if (!add(w, r, DepKind::WAW))
          return std::nullopt;
    }
    for (Value w : b.writes)
      for (Value r : a.reads)
        if (!add(w, r, DepKind::WAR))
          return std::nullopt;
    return out;
  }


  // Collects the ops in `loop` that write (`wantWrites`) or read `root`. Fails
  // when such an op is not an affine write/read, since the dependence analysis
  // could not see it.
  LogicalResult collectRootAccesses(AffineForOp loop, Value root,
                                    bool wantWrites,
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
        if (!kindMatches || this->root(effect.getValue()) != root)
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

  // Debug-only: prints every conflicting root pair between loops a and b.
  void explainConflict(const MemoryFootprint &a, const MemoryFootprint &b,
                       llvm::raw_ostream &os) const {
    for (Value w : a.writes) {
      for (Value r : b.reads)
        if (mayAlias(w, r))
          os << "    RAW (a writes, b reads): " << w << "\n";
      for (Value r : b.writes)
        if (mayAlias(w, r))
          os << "    WAW (both write): " << w << "\n";
    }
    for (Value w : b.writes)
      for (Value r : a.reads)
        if (mayAlias(w, r))
          os << "    WAR (a reads, b writes): " << w << "\n";
  }
};

// Decides whether two SSA values are equal at runtime. Without `equateReloads`
// only identical values and structurally identical memref.reinterpret_cast
// views qualify. With it, pure ops with equivalent operands are equivalent,
// and so are two loads of the same location when nothing between them may
// write the loaded memref.
class ValueEquivalence {
public:
  ValueEquivalence(MemoryModel &model, bool equateReloads)
      : model(model), equateReloads(equateReloads) {}

  bool equivalent(Value x, Value y, unsigned depth = 0) {
    if (x == y)
      return true;
    Operation *dx = x.getDefiningOp(), *dy = y.getDefiningOp();
    if (!dx || !dy || x.getType() != y.getType() || depth > kMaxDepth)
      return false;
    if (!equateReloads) {
      auto cx = dyn_cast<memref::ReinterpretCastOp>(dx);
      auto cy = dyn_cast<memref::ReinterpretCastOp>(dy);
      return cx && cy &&
             OperationEquivalence::isEquivalentTo(
                 cx, cy, OperationEquivalence::IgnoreLocations);
    }
    if (cast<OpResult>(x).getResultNumber() !=
        cast<OpResult>(y).getResultNumber())
      return false;
    auto operandsEquivalent = [&](Value l, Value r) {
      return success(equivalent(l, r, depth + 1));
    };
    auto structurallyEqual = [&]() {
      return OperationEquivalence::isEquivalentTo(
          dx, dy, operandsEquivalent, /*markEquivalent=*/nullptr,
          OperationEquivalence::IgnoreLocations);
    };
    if (isa<affine::AffineReadOpInterface, memref::LoadOp>(dx)) {
      if (!structurallyEqual())
        return false;
      Value memref = isa<memref::LoadOp>(dx)
                         ? cast<memref::LoadOp>(dx).getMemRef()
                         : cast<affine::AffineReadOpInterface>(dx).getMemRef();
      return !model.mayWriteBetween(dx, dy, model.root(memref));
    }
    if (dx->getNumRegions() != 0 || !isMemoryEffectFree(dx) ||
        !isMemoryEffectFree(dy))
      return false;
    return structurallyEqual();
  }

  // Replaces each value in `ops` by an equivalent value from `reference`.
  SmallVector<Value> canonicalize(ValueRange ops, ArrayRef<Value> reference) {
    SmallVector<Value> out(ops.begin(), ops.end());
    for (Value &v : out)
      for (Value r : reference)
        if (equivalent(v, r)) {
          v = r;
          break;
        }
    return out;
  }

private:
  static constexpr unsigned kMaxDepth = 16;
  MemoryModel &model;
  bool equateReloads;
};

Value getAccessMemref(Operation *op) {
  if (auto read = dyn_cast<affine::AffineReadOpInterface>(op))
    return read.getMemRef();
  return cast<affine::AffineWriteOpInterface>(op).getMemRef();
}

// Returns one memref value that stands for every access in `accesses`, or null
// when the accesses go through index spaces not proven identical.
Value canonicalAccessMemref(ArrayRef<Operation *> accesses,
                            ValueEquivalence &eq) {
  Value first = getAccessMemref(accesses.front());
  for (Operation *op : accesses)
    if (!eq.equivalent(first, getAccessMemref(op)))
      return nullptr;
  return first;
}

enum class DependenceVerdict {
  Legal,
  NonAffineAccess,
  ViewMismatch,
  DependenceViolated,
  AnalysisFailure,
};

const char *verdictReason(DependenceVerdict v) {
  switch (v) {
  case DependenceVerdict::Legal:
    return "legal";
  case DependenceVerdict::NonAffineAccess:
    return "non-affine-access";
  case DependenceVerdict::ViewMismatch:
    return "view-mismatch";
  case DependenceVerdict::DependenceViolated:
    return "dependence-violated";
  case DependenceVerdict::AnalysisFailure:
    return "analysis-failure";
  }
  llvm_unreachable("unknown verdict");
}

// Fusing places a's body before b's body in every iteration of one loop whose
// induction variable stands for both original ones. A dependence (of any kind)
// from an access in `a` at iteration iv_a to an access in `b` at iv_b keeps its
// order iff iv_a <= iv_b, so the fusion is legal iff no dependent pair has
// iv_a > iv_b.
DependenceVerdict checkDependences(AffineForOp a, AffineForOp b,
                                   ArrayRef<RootConflict> conflicts,
                                   FusionMemoryModel &model,
                                   ValueEquivalence &eq) {
  unsigned numCommon = 0;
  for (Operation *p = a->getParentOp(); p; p = p->getParentOp())
    if (isa<AffineForOp>(p))
      ++numCommon;

  for (auto [root, kind] : conflicts) {
    bool srcWrites = kind != DepKind::WAR;
    bool dstWrites = kind != DepKind::RAW;
    SmallVector<Operation *> srcOps, dstOps;
    if (failed(model.collectRootAccesses(a, root, srcWrites, srcOps)) ||
        failed(model.collectRootAccesses(b, root, dstWrites, dstOps)))
      return DependenceVerdict::NonAffineAccess;
    if (srcOps.empty() || dstOps.empty())
      return DependenceVerdict::AnalysisFailure;

    SmallVector<Operation *> all(srcOps);
    all.append(dstOps.begin(), dstOps.end());
    Value memref = canonicalAccessMemref(all, eq);
    if (!memref)
      return DependenceVerdict::ViewMismatch;

    for (Operation *s : srcOps) {
      affine::MemRefAccess src(s);
      src.memref = memref;
      for (Operation *d : dstOps) {
        affine::MemRefAccess dst(d);
        dst.memref = memref;
        affine::FlatAffineValueConstraints dep;
        affine::DependenceResult res = affine::checkMemrefAccessDependence(
            src, dst, numCommon + 1, &dep);
        if (res.value == affine::DependenceResult::Failure)
          return DependenceVerdict::AnalysisFailure;
        if (affine::noDependence(res))
          continue;
        unsigned posA, posB;
        if (!dep.findVar(a.getInductionVar(), &posA) ||
            !dep.findVar(b.getInductionVar(), &posB))
          return DependenceVerdict::AnalysisFailure;
        // iv_a - iv_b - 1 >= 0: the source access runs at a later fused
        // iteration than the destination access.
        SmallVector<int64_t> ineq(dep.getNumCols(), 0);
        ineq[posA] = 1;
        ineq[posB] = -1;
        ineq.back() = -1;
        dep.addInequality(ineq);
        if (!dep.isEmpty())
          return DependenceVerdict::DependenceViolated;
      }
    }
  }
  return DependenceVerdict::Legal;
}

std::string joinKinds(ArrayRef<DepKind> kinds) {
  SmallVector<std::string> names;
  for (DepKind k : kinds)
    names.push_back(depKindName(k));
  return llvm::join(names, ",");
}

std::string joinKinds(ArrayRef<RootConflict> conflicts) {
  SmallVector<DepKind> kinds;
  for (auto [root, kind] : conflicts)
    if (!llvm::is_contained(kinds, kind))
      kinds.push_back(kind);
  return joinKinds(kinds);
}

// A fusion candidate: a loop, optionally inside a guard this pass built
// around it. Fusing pushes the guard into the fused loop's body.
struct GuardedLoop {
  AffineForOp loop;
  AffineIfOp guard; // null when the loop is not guarded

  // The op that is a sibling of the other candidates.
  Operation *op() {
    return guard ? guard.getOperation() : loop.getOperation();
  }
};

// Debug-only: function name, nesting depth, sibling ordinal, step and bounds.
[[maybe_unused]] std::string describeLoop(GuardedLoop c) {
  std::string s;
  llvm::raw_string_ostream os(s);
  AffineForOp loop = c.loop;
  unsigned depth = 0;
  for (Operation *p = loop->getParentOp(); p; p = p->getParentOp())
    if (isa<AffineForOp>(p))
      ++depth;
  unsigned idx = 0;
  for (Operation &op : *c.op()->getBlock()) {
    if (&op == c.op())
      break;
    if (isa<AffineForOp>(op))
      ++idx;
  }
  auto fn = loop->getParentOfType<func::FuncOp>();
  os << "@" << (fn ? fn.getName() : StringRef("?")) << " depth=" << depth
     << " loop#" << idx << (c.guard ? " guarded" : "")
     << " step=" << loop.getStepAsInt() << " lb=" << loop.getLowerBoundMap()
     << " ub=" << loop.getUpperBoundMap();
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

struct BoundOffsets {
  std::optional<int64_t> dl, du;
};

// Offsets of b's bounds relative to a's bounds, with b's bound operands first
// replaced by equivalent operands of a's bounds.
BoundOffsets boundOffsets(AffineForOp a, AffineForOp b, ValueEquivalence &eq) {
  SmallVector<Value> reference(a.getLowerBoundOperands());
  llvm::append_range(reference, a.getUpperBoundOperands());
  SmallVector<Value> bl = eq.canonicalize(b.getLowerBoundOperands(), reference);
  SmallVector<Value> bu = eq.canonicalize(b.getUpperBoundOperands(), reference);
  return {constantDifference(b.getLowerBoundMap(), bl, a.getLowerBoundMap(),
                             a.getLowerBoundOperands()),
          constantDifference(b.getUpperBoundMap(), bu, a.getUpperBoundMap(),
                             a.getUpperBoundOperands())};
}

// b's bounds minus a's bounds. A missing offset is not a compile-time constant
// and the fused loop takes the affine.min (lower) or affine.max (upper) of
// both bounds instead.
struct FusionPlan {
  std::optional<int64_t> dl, du;
  std::string dependences; // conflict kinds proven legal, empty if none

  bool constant() const { return dl && du; }
  bool matching() const { return constant() && *dl == 0 && *du == 0; }
  bool aContainsB() const { return constant() && *dl >= 0 && *du <= 0; }
  bool bContainsA() const { return constant() && *dl <= 0 && *du >= 0; }
};

// One condition of a guard: iv >= map + shift when `lower`, otherwise
// iv < map + shift, with `map` a single-result bound map over `operands`.
struct GuardBound {
  AffineMap map;
  SmallVector<Value> operands;
  int64_t shift;
  bool lower;
};

// Bound conditions that keep `loop`'s own iterations when its body moves into
// a fused loop running over [lb, ub). An offset is the loop's bound minus the
// fused loop's bound (>= 0 for the lower, <= 0 for the upper bound);
// std::nullopt means the fused bound is an affine.min/max, so the loop's own
// bound is checked.
SmallVector<GuardBound> guardBounds(AffineForOp fused, AffineForOp loop,
                                    std::optional<int64_t> lowerOffset,
                                    std::optional<int64_t> upperOffset) {
  SmallVector<GuardBound> bounds;
  if (!lowerOffset)
    bounds.push_back({loop.getLowerBoundMap(),
                      llvm::to_vector(loop.getLowerBoundOperands()), 0, true});
  else if (*lowerOffset > 0)
    bounds.push_back({fused.getLowerBoundMap(),
                      llvm::to_vector(fused.getLowerBoundOperands()),
                      *lowerOffset, true});
  if (!upperOffset)
    bounds.push_back({loop.getUpperBoundMap(),
                      llvm::to_vector(loop.getUpperBoundOperands()), 0, false});
  else if (*upperOffset < 0)
    bounds.push_back({fused.getUpperBoundMap(),
                      llvm::to_vector(fused.getUpperBoundOperands()),
                      *upperOffset, false});
  return bounds;
}

// Number of loops in the nest under `root` (inclusive) whose body holds a loop
// but is not exactly one directly nested loop plus region-free ops that at
// most read memory. Such loops stay wrapped around a loop after
// parallelization; the read-only ops are left for sink-into-nested-parallel.
unsigned countImperfectLevels(Operation *root) {
  auto readOnly = [](Operation &op) {
    if (op.getNumRegions() != 0)
      return false;
    if (isMemoryEffectFree(&op))
      return true;
    auto iface = dyn_cast<MemoryEffectOpInterface>(op);
    return iface && iface.onlyHasEffect<MemoryEffects::Read>();
  };
  unsigned count = 0;
  root->walk([&](AffineForOp loop) {
    unsigned loops = 0;
    bool other = false;
    for (Operation &op : loop.getBody()->without_terminator()) {
      if (isa<AffineForOp>(op)) {
        ++loops;
      } else if (op.walk([](AffineForOp) { return WalkResult::interrupt(); })
                     .wasInterrupted()) {
        ++loops;
        other = true;
      } else if (!readOnly(op)) {
        other = true;
      }
    }
    if (loops != 0 && (loops != 1 || other))
      ++count;
  });
  return count;
}

// Inserts the affine.min (`lower`) or affine.max of two single-result bound
// maps before `builder`'s insertion point. Every operand must be a valid
// symbol, so the result is one as well and can bound an affine.for.
Value buildHullBound(OpBuilder &builder, Location loc, AffineMap x,
                     ValueRange xOperands, AffineMap y, ValueRange yOperands,
                     bool lower) {
  MLIRContext *ctx = builder.getContext();
  SmallVector<Value> operands;
  SmallVector<AffineExpr> results;
  auto add = [&](AffineMap map, ValueRange ops) {
    unsigned base = operands.size();
    SmallVector<AffineExpr> dims, syms;
    for (unsigned k = 0; k < map.getNumDims(); ++k)
      dims.push_back(getAffineSymbolExpr(base + k, ctx));
    for (unsigned k = 0; k < map.getNumSymbols(); ++k)
      syms.push_back(getAffineSymbolExpr(base + map.getNumDims() + k, ctx));
    operands.append(ops.begin(), ops.end());
    results.push_back(map.getResult(0).replaceDimsAndSymbols(dims, syms));
  };
  add(x, xOperands);
  add(y, yOperands);
  AffineMap map = AffineMap::get(0, operands.size(), results, ctx);
  affine::canonicalizeMapAndOperands(&map, &operands);
  if (lower)
    return builder.create<affine::AffineMinOp>(loc, map, operands);
  return builder.create<affine::AffineMaxOp>(loc, map, operands);
}

struct AffineLoopFusionNonConservative
    : impl::AffineLoopFusionNonConservativeBase<
          AffineLoopFusionNonConservative> {
  using AffineLoopFusionNonConservativeBase::
      AffineLoopFusionNonConservativeBase;

  // Number of original loops merged into each loop; absent means 1.
  llvm::DenseMap<Operation *, unsigned> fusedCount;
  // Guards built by this pass. Only these are pushed down into a fused loop.
  llvm::DenseSet<Operation *> guards;
  std::optional<FusionMemoryModel> model;

  unsigned countOf(Operation *op) const {
    auto it = fusedCount.find(op);
    return it == fusedCount.end() ? 1 : it->second;
  }

  void runOnOperation() override {
    fusedCount.clear();
    guards.clear();
    model.emplace(aliasConservative);
    for (Region &region : getOperation()->getRegions())
      for (Block &block : region)
        processBlock(block);
  }

  // An affine.for, or a guard of this pass whose body is exactly one
  // affine.for.
  std::optional<GuardedLoop> asCandidate(Operation *op) const {
    if (auto loop = dyn_cast<AffineForOp>(op))
      return GuardedLoop{loop, nullptr};
    auto guard = dyn_cast<AffineIfOp>(op);
    if (!guard || !guards.contains(op))
      return std::nullopt;
    Block *then = guard.getThenBlock();
    auto loop = dyn_cast<AffineForOp>(then->front());
    if (!loop || loop->getNextNode() != then->getTerminator())
      return std::nullopt;
    return GuardedLoop{loop, guard};
  }

  void processBlock(Block &block) {
    Operation *cur = block.empty() ? nullptr : &block.front();
    while (cur) {
      if (std::optional<GuardedLoop> candidate = asCandidate(cur)) {
        Operation *restored = nullptr;
        if (AffineForOp fused = tryFuseWithNext(*candidate, restored)) {
          cur = fused.getOperation();
          continue;
        }
        if (restored)
          cur = restored;
      }
      cur = cur->getNextNode();
    }
    // Fusion may have made inner loops siblings, so recurse afterwards.
    for (Operation &op : block)
      for (Region &region : op.getRegions())
        for (Block &inner : region)
          processBlock(inner);
  }

  // Detached copies of a fusion's two candidates, put back when
  // require-perfect-nests undoes the fusion.
  struct NestSnapshot {
    Operation *a, *b;
    Operation *aPos; // op `a` is restored before; null: before the fused loop
    unsigned imperfect; // imperfect levels of the two input nests
    SmallVector<std::pair<Operation *, unsigned>> counts; // copies' fusedCount
    SmallVector<Operation *> guardCopies; // copies of this pass's guards
  };

  NestSnapshot takeSnapshot(GuardedLoop a, GuardedLoop b,
                            ArrayRef<Operation *> gap) {
    IRMapping mapping;
    NestSnapshot s{a.op()->clone(mapping), b.op()->clone(mapping),
                   gap.empty() ? nullptr : gap.front(),
                   countImperfectLevels(a.op()) + countImperfectLevels(b.op()),
                   {}, {}};
    for (Operation *top : {a.op(), b.op()}) {
      top->walk([&](Operation *op) {
        if (auto it = fusedCount.find(op); it != fusedCount.end())
          s.counts.push_back({mapping.lookup(op), it->second});
        if (guards.contains(op))
          s.guardCopies.push_back(mapping.lookup(op));
      });
    }
    return s;
  }

  // Replaces `fused` (and the hull bounds built for it) by the snapshot's
  // copies at the original positions. Returns the restored first candidate.
  Operation *restoreSnapshot(NestSnapshot &s, AffineForOp fused) {
    fused->walk([&](Operation *op) {
      fusedCount.erase(op);
      guards.erase(op);
    });
    auto &ops = fused->getBlock()->getOperations();
    ops.insert(Block::iterator(s.aPos ? s.aPos : fused.getOperation()), s.a);
    ops.insert(Block::iterator(fused.getOperation()), s.b);
    SmallVector<Value> bounds(fused->getOperands());
    fused.erase();
    for (Value v : bounds)
      if (Operation *def = v.getDefiningOp();
          isa_and_nonnull<affine::AffineMinOp, affine::AffineMaxOp>(def) &&
          def->use_empty())
        def->erase();
    for (auto [op, n] : s.counts)
      fusedCount[op] = n;
    guards.insert(s.guardCopies.begin(), s.guardCopies.end());
    return s.a;
  }

  // Builds one guard at the end of the fused loop's body that combines the
  // conditions of `oldGuard` (when non-null) and `bounds`. Returns null when
  // there is no condition.
  AffineIfOp buildGuard(AffineForOp fused, AffineIfOp oldGuard,
                        ArrayRef<GuardBound> bounds) {
    MLIRContext *ctx = fused.getContext();
    SmallVector<Value> operands;
    SmallVector<AffineExpr> constraints;
    SmallVector<bool> isEq;

    // Appends `ops` (`numDims` dims, then symbols) as extra dims of the set
    // and rewrites `exprs`, written over `ops`, to use them.
    auto append = [&](ArrayRef<AffineExpr> exprs, unsigned numDims,
                      unsigned numSymbols, ValueRange ops) {
      unsigned base = operands.size();
      SmallVector<AffineExpr> dims, syms;
      for (unsigned k = 0; k < numDims; ++k)
        dims.push_back(getAffineDimExpr(base + k, ctx));
      for (unsigned k = 0; k < numSymbols; ++k)
        syms.push_back(getAffineDimExpr(base + numDims + k, ctx));
      operands.append(ops.begin(), ops.end());
      return llvm::map_to_vector(exprs, [&](AffineExpr e) {
        return e.replaceDimsAndSymbols(dims, syms);
      });
    };

    if (oldGuard) {
      IntegerSet old = oldGuard.getIntegerSet();
      llvm::append_range(constraints,
                         append(old.getConstraints(), old.getNumDims(),
                                old.getNumSymbols(), oldGuard.getOperands()));
      llvm::append_range(isEq, old.getEqFlags());
    }
    if (!bounds.empty()) {
      AffineExpr iv =
          append(getAffineDimExpr(0, ctx), 1, 0, fused.getInductionVar())[0];
      for (const GuardBound &b : bounds) {
        AffineExpr e = append(b.map.getResult(0), b.map.getNumDims(),
                              b.map.getNumSymbols(), b.operands)[0];
        constraints.push_back(b.lower ? iv - e - b.shift
                                      : e + b.shift - 1 - iv);
        isEq.push_back(false);
      }
    }
    if (constraints.empty())
      return nullptr;

    IntegerSet set = IntegerSet::get(operands.size(), 0, constraints, isEq);
    affine::canonicalizeSetAndOperands(&set, &operands);
    OpBuilder builder(fused.getBody()->getTerminator());
    auto guard = builder.create<AffineIfOp>(fused.getLoc(), set, operands,
                                            /*withElseRegion=*/false);
    guards.insert(guard);
    return guard;
  }

  void moveBody(GuardedLoop src, AffineForOp fused,
                ArrayRef<GuardBound> bounds) {
    src.loop.getInductionVar().replaceAllUsesWith(fused.getInductionVar());
    Block *dstBlock = fused.getBody();
    Operation *before = dstBlock->getTerminator();
    if (AffineIfOp guard = buildGuard(fused, src.guard, bounds)) {
      dstBlock = guard.getThenBlock();
      before = dstBlock->getTerminator();
    }
    Block *srcBlock = src.loop.getBody();
    dstBlock->getOperations().splice(
        before->getIterator(), srcBlock->getOperations(), srcBlock->begin(),
        Block::iterator(srcBlock->getTerminator()));
  }

  // Evaluates every fusion rule for the sibling pair (a, b) with `gap` the ops
  // between them. Returns a plan when all rules pass; otherwise appends one
  // reason per failing rule to `reasons`. Every rule is evaluated even after a
  // failure so the debug output shows all blockers, with a note on rules that
  // a currently disabled option would relax.
  std::optional<FusionPlan> evaluatePair(AffineForOp a, AffineForOp b,
                                         ArrayRef<Operation *> gap,
                                         SmallVectorImpl<std::string> &reasons,
                                         bool &memoryReason) {
    FusionMemoryModel &mm = *model;
    ValueEquivalence eq(mm, equateReloads);
    Operation *blockerA = nullptr, *blockerB = nullptr;
    std::optional<MemoryFootprint> fa = mm.footprint(a, &blockerA);
    std::optional<MemoryFootprint> fb = mm.footprint(b, &blockerB);

    // The earlier loop is sunk past the gap, so the gap must commute with it.
    auto effectful = llvm::find_if(
        gap, [](Operation *op) { return !isMemoryEffectFree(op); });
    if (effectful != gap.end()) {
      std::string verdict;
      Operation *blockerX = nullptr;
      std::optional<MemoryFootprint> fx =
          mm.footprint(gap, /*skipRoots=*/false, &blockerX);
      if (!fx)
        verdict = ("intervening-op-unsummarizable: " +
                   blockerX->getName().getStringRef())
                      .str();
      else if (!fa)
        verdict = "intervening-op-unchecked: earlier loop unsummarizable";
      else if (SmallVector<DepKind> kinds = mm.conflictKinds(*fa, *fx);
               !kinds.empty())
        verdict = "intervening-op-conflict: " + joinKinds(kinds);
      if (!fuseAcrossInterveningOps)
        reasons.push_back(("intervening-op-with-memory-effects: " +
                           (*effectful)->getName().getStringRef() + " (" +
                           (verdict.empty() ? "would commute" : verdict) +
                           ")")
                              .str());
      else if (!verdict.empty())
        reasons.push_back(verdict);
    }

    if (a.getNumResults() != 0 || b.getNumResults() != 0)
      reasons.push_back("loop-has-results");
    if (a.getStepAsInt() != b.getStepAsInt())
      reasons.push_back("step-mismatch");
    if (countOf(a) + countOf(b) > maxFusedLoops)
      reasons.push_back(
          ("max-fused-loops count=" + Twine(countOf(a) + countOf(b))).str());

    FusionPlan plan;
    bool singleResultBounds = a.getLowerBoundMap().getNumResults() == 1 &&
                              a.getUpperBoundMap().getNumResults() == 1 &&
                              b.getLowerBoundMap().getNumResults() == 1 &&
                              b.getUpperBoundMap().getNumResults() == 1;
    if (!singleResultBounds) {
      reasons.push_back("multi-result-bound");
    } else {
      BoundOffsets off = boundOffsets(a, b, eq);
      plan.dl = off.dl;
      plan.du = off.du;
      // Pairs whose fused loop is neither loop's range run over the hull of
      // both ranges with every body guarded (fuse-symbolic-bounds).
      std::string hullReason;
      if (!plan.constant()) {
        hullReason = ("non-constant-bound-difference lower=" +
                      Twine(off.dl ? "const" : "non-const") +
                      " upper=" + (off.du ? "const" : "non-const"))
                         .str();
        if (!equateReloads) {
          ValueEquivalence probe(mm, /*equateReloads=*/true);
          BoundOffsets withReloads = boundOffsets(a, b, probe);
          if (withReloads.dl && withReloads.du)
            hullReason += " (equate-reloads would make it constant)";
        }
      } else if (!plan.aContainsB() && !plan.bContainsA()) {
        hullReason = ("partial-overlap dl=" + Twine(*plan.dl) +
                      " du=" + Twine(*plan.du))
                         .str();
      }
      if (!hullReason.empty()) {
        // An affine.min/max bound needs symbol operands, and a lower bound
        // of unknown offset keeps the step phase only for step 1.
        auto symbols = [](ValueRange ops) {
          return llvm::all_of(
              ops, [](Value v) { return affine::isValidSymbol(v); });
        };
        std::string hullBlocker;
        if ((!off.dl && !(symbols(a.getLowerBoundOperands()) &&
                          symbols(b.getLowerBoundOperands()))) ||
            (!off.du && !(symbols(a.getUpperBoundOperands()) &&
                          symbols(b.getUpperBoundOperands()))))
          hullBlocker = "hull-bound-not-symbolic";
        else if (!off.dl && a.getStepAsInt() != 1)
          hullBlocker = ("non-constant-lower-offset-with-step step=" +
                         Twine(a.getStepAsInt()))
                            .str();
        if (!fuseSymbolicBounds)
          reasons.push_back(hullReason +
                            (hullBlocker.empty()
                                 ? " (fuse-symbolic-bounds would allow it)"
                                 : ""));
        else if (!hullBlocker.empty())
          reasons.push_back(hullBlocker);
      }
      if (plan.matching() ? !fuseMatchingBounds : !fuseMismatchedBounds)
        reasons.push_back(plan.matching() ? "matching-bounds-disabled"
                                          : "mismatched-bounds-disabled");
      // A shifted lower bound must keep the iteration phase of the step.
      if (plan.dl && *plan.dl % a.getStepAsInt() != 0)
        reasons.push_back(("lower-offset-not-multiple-of-step dl=" +
                           Twine(*plan.dl) +
                           " step=" + Twine(a.getStepAsInt()))
                              .str());
    }

    if (!fa || !fb) {
      Operation *blk = !fa ? blockerA : blockerB;
      reasons.push_back(
          ("footprint-unsummarizable in " + Twine(!fa ? "a" : "b") + ": " +
           (blk ? blk->getName().getStringRef() : StringRef("?")))
              .str());
    } else if (mm.hasConflict(*fa, *fb)) {
      memoryReason = true;
      std::optional<SmallVector<RootConflict>> conflicts =
          mm.sameRootConflicts(*fa, *fb);
      if (!conflicts) {
        reasons.push_back("memory-conflict: cross-root-may-alias");
      } else {
        DependenceVerdict verdict = checkDependences(a, b, *conflicts, mm, eq);
        SmallVector<DepKind> disabled;
        for (auto [root, kind] : *conflicts) {
          bool enabled =
              kind == DepKind::RAW ? fuseProducerConsumer : fuseWarWaw;
          if (!enabled && !llvm::is_contained(disabled, kind))
            disabled.push_back(kind);
        }
        std::string kinds = joinKinds(*conflicts);
        if (!disabled.empty())
          reasons.push_back("memory-conflict: " + kinds + " (" +
                            joinKinds(disabled) + " disabled; legality=" +
                            verdictReason(verdict) + ")");
        else if (verdict != DependenceVerdict::Legal)
          reasons.push_back("memory-conflict: " + kinds + ": " +
                            verdictReason(verdict));
        else
          plan.dependences = kinds;
      }
    }

    if (!reasons.empty())
      return std::nullopt;
    return plan;
  }

  // Fuses `a` with the next sibling candidate when allowed; returns the fused
  // loop (placed where the later candidate was) or a null op. Each candidate's
  // guard is pushed into the fused loop's body, merged with any new bound
  // guard into one affine.if. The rules are checked on the loops themselves:
  // the dependence analysis sees the guard conditions in the iteration domain.
  // With require-perfect-nests the fused body is processed right away, and
  // the fusion is undone when the nest has more imperfect levels than the two
  // inputs had; `restored` then receives the restored copy of `a`.
  AffineForOp tryFuseWithNext(GuardedLoop a, Operation *&restored) {
    SmallVector<Operation *> gap;
    Operation *next = a.op()->getNextNode();
    std::optional<GuardedLoop> candidate;
    while (next && !(candidate = asCandidate(next))) {
      gap.push_back(next);
      next = next->getNextNode();
    }
    if (!candidate)
      return nullptr;
    GuardedLoop b = *candidate;

    SmallVector<std::string> reasons;
    bool memoryReason = false;
    std::optional<FusionPlan> plan =
        evaluatePair(a.loop, b.loop, gap, reasons, memoryReason);
    if (!plan) {
      LLVM_DEBUG({
        llvm::dbgs() << "REJECT [" << llvm::join(reasons, "; ") << "]\n  a: "
                     << describeLoop(a) << "\n  b: " << describeLoop(b)
                     << "\n";
        std::optional<MemoryFootprint> fa = model->footprint(a.loop);
        std::optional<MemoryFootprint> fb = model->footprint(b.loop);
        if (memoryReason && fa && fb)
          model->explainConflict(*fa, *fb, llvm::dbgs());
      });
      return nullptr;
    }

    LLVM_DEBUG({
      auto offset = [](std::optional<int64_t> d) {
        return d ? std::to_string(*d) : std::string("?");
      };
      llvm::dbgs() << "FUSE ["
                   << (plan->dependences.empty()
                           ? std::string()
                           : "dependences " + plan->dependences + " legal, ")
                   << (gap.empty() ? "" : "across gap, ")
                   << (plan->matching()     ? "matching"
                       : plan->aContainsB() ? "a-contains-b, guard b"
                       : plan->bContainsA() ? "b-contains-a, guard a"
                                            : "hull, guard both")
                   << " dl=" << offset(plan->dl) << " du=" << offset(plan->du)
                   << "]\n  a: " << describeLoop(a)
                   << "\n  b: " << describeLoop(b) << "\n";
    });

    std::optional<NestSnapshot> snapshot;
    if (requirePerfectNests)
      snapshot = takeSnapshot(a, b, gap);

    // The fused loop starts with the loop starting first and ends with the
    // loop ending last (a's bound on a tie); an unknown offset takes the
    // affine.min/max of both.
    MLIRContext *ctx = &getContext();
    Location loc = a.loop.getLoc();
    OpBuilder builder(b.op());
    AffineMap symbolMap = AffineMap::get(0, 1, getAffineSymbolExpr(0, ctx));
    AffineMap lbMap = symbolMap, ubMap = symbolMap;
    SmallVector<Value> lbOperands, ubOperands;
    if (plan->dl) {
      AffineForOp first = *plan->dl >= 0 ? a.loop : b.loop;
      lbMap = first.getLowerBoundMap();
      lbOperands = llvm::to_vector(first.getLowerBoundOperands());
    } else {
      lbOperands.push_back(buildHullBound(
          builder, loc, a.loop.getLowerBoundMap(),
          a.loop.getLowerBoundOperands(), b.loop.getLowerBoundMap(),
          b.loop.getLowerBoundOperands(), /*lower=*/true));
    }
    if (plan->du) {
      AffineForOp last = *plan->du > 0 ? b.loop : a.loop;
      ubMap = last.getUpperBoundMap();
      ubOperands = llvm::to_vector(last.getUpperBoundOperands());
    } else {
      ubOperands.push_back(buildHullBound(
          builder, loc, a.loop.getUpperBoundMap(),
          a.loop.getUpperBoundOperands(), b.loop.getUpperBoundMap(),
          b.loop.getUpperBoundOperands(), /*lower=*/false));
    }
    auto fused = builder.create<AffineForOp>(loc, lbOperands, lbMap,
                                             ubOperands, ubMap,
                                             a.loop.getStepAsInt());

    // Offsets of each loop's bounds from the fused loop's bounds.
    std::optional<int64_t> aLower, bLower, aUpper, bUpper;
    if (plan->dl) {
      aLower = std::max<int64_t>(-*plan->dl, 0);
      bLower = std::max<int64_t>(*plan->dl, 0);
    }
    if (plan->du) {
      aUpper = std::min<int64_t>(-*plan->du, 0);
      bUpper = std::min<int64_t>(*plan->du, 0);
    }
    SmallVector<GuardBound> aBounds = guardBounds(fused, a.loop, aLower, aUpper);
    SmallVector<GuardBound> bBounds = guardBounds(fused, b.loop, bLower, bUpper);
    moveBody(a, fused, aBounds);
    moveBody(b, fused, bBounds);

    fusedCount[fused] = countOf(a.loop) + countOf(b.loop);
    for (GuardedLoop c : {a, b}) {
      fusedCount.erase(c.loop);
      c.loop.erase();
      if (c.guard) {
        guards.erase(c.guard);
        c.guard.erase();
      }
    }

    if (snapshot) {
      processBlock(*fused.getBody());
      unsigned imperfect = countImperfectLevels(fused);
      if (imperfect > snapshot->imperfect) {
        LLVM_DEBUG(llvm::dbgs()
                   << "UNDO [require-perfect-nests: imperfect levels "
                   << snapshot->imperfect << " -> " << imperfect << "]\n");
        restored = restoreSnapshot(*snapshot, fused);
        return nullptr;
      }
      snapshot->a->erase();
      snapshot->b->erase();
    }
    return fused;
  }
};

}  // namespace
}  // namespace tutorial
}  // namespace mlir
