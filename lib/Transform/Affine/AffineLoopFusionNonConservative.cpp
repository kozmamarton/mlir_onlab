#include "Transform/Affine/AffineLoopFusionNonConservative.h"

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

struct MemoryFootprint {
  llvm::DenseSet<Value> reads;
  llvm::DenseSet<Value> writes;
};

using RootConflict = std::pair<Value, DepKind>;

// Resolves memrefs to the root they view and decides whether two roots may
// alias. Separate memref.get_global ops of one symbol return the same memory,
// so they all resolve to the first such value seen in the function.
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
                                   MemoryModel &model, ValueEquivalence &eq) {
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

struct FusionPlan {
  int64_t dl = 0, du = 0;
  bool matching = false;
  bool aContainsB = false;
  std::string dependences; // conflict kinds proven legal, empty if none
};

struct AffineLoopFusionNonConservative
    : impl::AffineLoopFusionNonConservativeBase<
          AffineLoopFusionNonConservative> {
  using AffineLoopFusionNonConservativeBase::
      AffineLoopFusionNonConservativeBase;

  // Number of original loops merged into each loop; absent means 1.
  llvm::DenseMap<Operation *, unsigned> fusedCount;
  std::optional<MemoryModel> model;

  unsigned countOf(Operation *op) const {
    auto it = fusedCount.find(op);
    return it == fusedCount.end() ? 1 : it->second;
  }

  void runOnOperation() override {
    fusedCount.clear();
    model.emplace(aliasConservative);
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

  // Evaluates every fusion rule for the sibling pair (a, b) with `gap` the ops
  // between them. Returns a plan when all rules pass; otherwise appends one
  // reason per failing rule to `reasons`. Every rule is evaluated even after a
  // failure so the debug output shows all blockers, with a note on rules that
  // a currently disabled option would relax.
  std::optional<FusionPlan> evaluatePair(AffineForOp a, AffineForOp b,
                                         ArrayRef<Operation *> gap,
                                         SmallVectorImpl<std::string> &reasons,
                                         bool &memoryReason) {
    MemoryModel &mm = *model;
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
      if (!off.dl || !off.du) {
        std::string why = ("non-constant-bound-difference lower=" +
                           Twine(off.dl ? "const" : "non-const") +
                           " upper=" + (off.du ? "const" : "non-const"))
                              .str();
        if (!equateReloads) {
          ValueEquivalence probe(mm, /*equateReloads=*/true);
          BoundOffsets withReloads = boundOffsets(a, b, probe);
          if (withReloads.dl && withReloads.du)
            why += " (equate-reloads would make it constant)";
        }
        reasons.push_back(why);
      } else {
        plan.dl = *off.dl;
        plan.du = *off.du;
        plan.matching = plan.dl == 0 && plan.du == 0;
        plan.aContainsB = plan.dl >= 0 && plan.du <= 0;
        bool bContainsA = plan.dl <= 0 && plan.du >= 0;
        if (plan.matching ? !fuseMatchingBounds : !fuseMismatchedBounds)
          reasons.push_back(plan.matching ? "matching-bounds-disabled"
                                          : "mismatched-bounds-disabled");
        if (!plan.aContainsB && !bContainsA)
          reasons.push_back(("partial-overlap dl=" + Twine(plan.dl) +
                             " du=" + Twine(plan.du))
                                .str());
        // A shifted lower bound must keep the iteration phase of the step.
        if (plan.dl % a.getStepAsInt() != 0)
          reasons.push_back(("lower-offset-not-multiple-of-step dl=" +
                             Twine(plan.dl) +
                             " step=" + Twine(a.getStepAsInt()))
                                .str());
      }
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

  // Fuses `a` with the next sibling loop when allowed; returns the fused loop
  // (placed where the later loop was) or a null op.
  AffineForOp tryFuseWithNext(AffineForOp a) {
    SmallVector<Operation *> gap;
    Operation *next = a->getNextNode();
    while (next && !isa<AffineForOp>(next)) {
      gap.push_back(next);
      next = next->getNextNode();
    }
    if (!next)
      return nullptr;
    AffineForOp b = cast<AffineForOp>(next);

    SmallVector<std::string> reasons;
    bool memoryReason = false;
    std::optional<FusionPlan> plan =
        evaluatePair(a, b, gap, reasons, memoryReason);
    if (!plan) {
      LLVM_DEBUG({
        llvm::dbgs() << "REJECT [" << llvm::join(reasons, "; ") << "]\n  a: "
                     << describeLoop(a) << "\n  b: " << describeLoop(b)
                     << "\n";
        std::optional<MemoryFootprint> fa = model->footprint(a);
        std::optional<MemoryFootprint> fb = model->footprint(b);
        if (memoryReason && fa && fb)
          model->explainConflict(*fa, *fb, llvm::dbgs());
      });
      return nullptr;
    }

    LLVM_DEBUG(llvm::dbgs()
               << "FUSE ["
               << (plan->dependences.empty()
                       ? std::string()
                       : "dependences " + plan->dependences + " legal, ")
               << (gap.empty() ? "" : "across gap, ")
               << (plan->matching ? "matching"
                                  : (plan->aContainsB ? "a-contains-b, guard b"
                                                      : "b-contains-a, guard a"))
               << " dl=" << plan->dl << " du=" << plan->du << "]\n  a: "
               << describeLoop(a) << "\n  b: " << describeLoop(b) << "\n");

    AffineForOp big = plan->aContainsB ? a : b;
    OpBuilder builder(b);
    auto fused = builder.create<AffineForOp>(
        a.getLoc(), big.getLowerBoundOperands(), big.getLowerBoundMap(),
        big.getUpperBoundOperands(), big.getUpperBoundMap(), a.getStepAsInt());

    bool guardA = !plan->matching && !plan->aContainsB;
    bool guardB = !plan->matching && plan->aContainsB;
    int64_t lowerShift = plan->aContainsB ? plan->dl : -plan->dl;
    int64_t upperShift = plan->aContainsB ? plan->du : -plan->du;
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
