#include "Transform/SCF/OffloadHostLoops.h"
#include "Transform/MemoryModel.h"

#include <algorithm>
#include <functional>
#include <map>
#include <optional>
#include <set>

#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/Support/Debug.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/GPU/Transforms/ParallelLoopMapper.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/Matchers.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_DEF_OFFLOADHOSTLOOPS
#include "Transform/SCF/Passes.h.inc"

#define DEBUG_TYPE "scf-offload-host-loops"

namespace {

// An opaque quantity an index is built from: an SSA value, or the value of a
// scalar global the function never writes (all loads of it are one atom).
using Atom = const void *;
// A product of atoms, sorted; the empty monomial is the constant term.
using Monomial = SmallVector<Atom, 4>;
using Poly = std::map<Monomial, int64_t>;
// Subscripts of one access, keyed by the stride atoms of their dimension.
using Dims = std::map<Monomial, Poly>;

constexpr size_t kMaxTerms = 64;

void addTo(Poly &p, const Poly &q, int64_t sign) {
  for (auto &[m, c] : q) {
    int64_t sum = (p[m] += sign * c);
    if (sum == 0)
      p.erase(m);
  }
}

std::optional<Poly> mul(const Poly &p, const Poly &q) {
  if (p.size() * q.size() > kMaxTerms)
    return std::nullopt;
  Poly r;
  for (auto &[m1, c1] : p)
    for (auto &[m2, c2] : q) {
      Monomial m(m1);
      m.append(m2.begin(), m2.end());
      llvm::sort(m);
      if ((r[m] += c1 * c2) == 0)
        r.erase(m);
    }
  return r;
}

// Whether `v` is available before `root` (it is not defined in its regions).
bool definedOutside(Value v, Operation *root) {
  if (auto arg = dyn_cast<BlockArgument>(v))
    return !root->isAncestor(arg.getOwner()->getParentOp());
  return !root->isProperAncestor(v.getDefiningOp());
}

bool isDeviceBuffer(Value root) {
  auto arg = dyn_cast<BlockArgument>(root);
  return arg && isa<func::FuncOp>(arg.getOwner()->getParentOp());
}

// The loops a nest is made of: scf.for without iter_args, or scf.parallel
// without reductions or a GPU mapping.
bool isChainLoop(Operation *op) {
  if (auto loop = dyn_cast<scf::ForOp>(op))
    return loop.getInitArgs().empty();
  if (auto loop = dyn_cast<scf::ParallelOp>(op))
    return loop.getNumReductions() == 0 &&
           !loop->hasAttr(gpu::getMappingAttrName());
  return false;
}

SmallVector<Value> ivsOf(Operation *loop) {
  if (auto f = dyn_cast<scf::ForOp>(loop))
    return {f.getInductionVar()};
  return llvm::to_vector(cast<scf::ParallelOp>(loop).getInductionVars());
}

Block *bodyOf(Operation *loop) { return &loop->getRegion(0).front(); }

struct Bounds {
  SmallVector<Value> lbs, ubs, steps;
};

Bounds boundsOf(Operation *loop) {
  if (auto f = dyn_cast<scf::ForOp>(loop))
    return {{f.getLowerBound()}, {f.getUpperBound()}, {f.getStep()}};
  auto p = cast<scf::ParallelOp>(loop);
  return {llvm::to_vector(p.getLowerBound()), llvm::to_vector(p.getUpperBound()),
          llvm::to_vector(p.getStep())};
}

// One loop of a nest's perfect chain, and the ops in its body before the next
// chain loop. Those are pure or read memrefs the nest does not write, so they
// may run at their level of the rewritten nest.
struct Level {
  Operation *loop;
  SmallVector<Value> ivs;
  SmallVector<Operation *> pre;
};

// A root loop and its chain. When `fused` is set the last level stands for
// those sibling scf.parallel ops of the previous level's body: they share the
// first one's IVs, and the ops between them form the innermost body.
struct Nest {
  Operation *root;
  SmallVector<Level> levels;
  SmallVector<scf::ParallelOp> fused;
};

struct Access {
  Operation *op;
  Value root;
  bool write;
  std::optional<Poly> flat;
};

class Analysis {
public:
  Analysis(Operation *root, MemoryModel &model,
           const llvm::DenseSet<StringAttr> &writtenGlobals,
           const llvm::DenseMap<Value, Value> &ivCanon)
      : root(root), model(model), writtenGlobals(writtenGlobals),
        ivCanon(ivCanon) {}

  // The name of the global `load` reads, when it is a scalar global the
  // function never writes.
  std::optional<StringAttr> scalarGlobal(memref::LoadOp load) {
    auto global = model.root(load.getMemref()).getDefiningOp<memref::GetGlobalOp>();
    if (!global || writtenGlobals.contains(global.getNameAttr().getAttr()))
      return std::nullopt;
    if (!llvm::all_of(load.getIndices(),
                      [](Value v) { return matchPattern(v, m_Constant()); }))
      return std::nullopt;
    return global.getNameAttr().getAttr();
  }

  Atom atomOf(Value v) {
    Atom a = v.getAsOpaquePointer();
    atomValues.try_emplace(a, v);
    return a;
  }

  std::optional<Poly> poly(Value v) {
    if (auto it = ivCanon.find(v); it != ivCanon.end())
      v = it->second;
    if (auto it = cache.find(v); it != cache.end())
      return it->second;
    std::optional<Poly> p = compute(v);
    cache[v] = p;
    return p;
  }

  // The address `indices` select in `memref`, in elements of its root.
  std::optional<Poly> flatIndex(Value memref, ValueRange indices) {
    Value v = memref;
    while (auto cast = v.getDefiningOp<memref::CastOp>())
      v = cast.getSource();
    if (auto view = v.getDefiningOp<memref::ReinterpretCastOp>()) {
      std::optional<int64_t> offset =
          getConstantIntValue(view.getMixedOffsets().front());
      auto srcType = cast<MemRefType>(view.getSource().getType());
      if (!offset || *offset != 0 || srcType.getRank() != 1 ||
          !srcType.getLayout().isIdentity() ||
          view.getSource().getDefiningOp<ViewLikeOpInterface>())
        return std::nullopt;
      Poly flat;
      for (auto [index, stride] : llvm::zip(indices, view.getMixedStrides())) {
        std::optional<Poly> s;
        if (std::optional<int64_t> c = getConstantIntValue(stride))
          s = Poly{{Monomial{}, *c}};
        else
          s = poly(cast<Value>(stride));
        std::optional<Poly> i = poly(index);
        if (!s || !i)
          return std::nullopt;
        for (auto &[m, c] : *s)
          if (!m.empty())
            for (Atom a : m)
              strideAtoms.insert(a);
        std::optional<Poly> term = mul(*i, *s);
        if (!term)
          return std::nullopt;
        addTo(flat, *term, 1);
      }
      return flat;
    }
    if (v.getDefiningOp<ViewLikeOpInterface>())
      return std::nullopt;
    auto type = cast<MemRefType>(v.getType());
    if (!type.getLayout().isIdentity())
      return std::nullopt;
    if (type.getRank() == 0)
      return Poly{};
    if (type.getRank() == 1)
      return poly(indices.front());
    if (!type.hasStaticShape())
      return std::nullopt;
    Poly flat;
    int64_t stride = 1;
    for (int d = type.getRank() - 1; d >= 0; --d) {
      std::optional<Poly> i = poly(indices[d]);
      if (!i)
        return std::nullopt;
      std::optional<Poly> term = mul(*i, Poly{{Monomial{}, stride}});
      if (!term)
        return std::nullopt;
      addTo(flat, *term, 1);
      stride *= type.getDimSize(d);
    }
    return flat;
  }

  // Whether `a` has the same value in every iteration of the nest.
  bool invariant(Atom a) {
    auto it = atomValues.find(a);
    return it == atomValues.end() || definedOutside(it->second, root);
  }

  bool invariant(const Monomial &m) {
    return llvm::all_of(m, [&](Atom a) { return invariant(a); });
  }

  // Splits `flat` into per-dimension subscripts. Under the assumption that
  // every subscript stays within its extent, two accesses of one root touch
  // the same element only if all their subscripts are equal.
  Dims delinearize(const Poly &flat) {
    Dims dims;
    for (auto &[m, c] : flat) {
      Monomial key, rest;
      for (Atom a : m)
        (strideAtoms.contains(a) ? key : rest).push_back(a);
      dims[key][rest] += c;
    }
    return dims;
  }

  // Records which atoms multiply an IV: they are strides, not offsets.
  void noteStrides(const Poly &flat, const llvm::DenseSet<Atom> &ivAtoms) {
    for (auto &[m, c] : flat)
      if (llvm::any_of(m, [&](Atom a) { return ivAtoms.contains(a); }))
        for (Atom a : m)
          if (!ivAtoms.contains(a))
            strideAtoms.insert(a);
  }

  llvm::DenseSet<Atom> strideAtoms;

private:
  std::optional<Poly> compute(Value v) {
    APInt cst;
    if (matchPattern(v, m_ConstantInt(&cst)))
      return Poly{{Monomial{}, cst.getSExtValue()}};
    Operation *def = v.getDefiningOp();
    if (!def)
      return Poly{{Monomial{atomOf(v)}, 1}};
    if (isa<arith::IndexCastOp, arith::IndexCastUIOp, arith::ExtSIOp,
            arith::ExtUIOp, arith::TruncIOp>(def))
      return poly(def->getOperand(0));
    if (isa<arith::AddIOp, arith::SubIOp, arith::MulIOp>(def)) {
      std::optional<Poly> l = poly(def->getOperand(0));
      std::optional<Poly> r = poly(def->getOperand(1));
      if (!l || !r)
        return std::nullopt;
      if (isa<arith::MulIOp>(def))
        return mul(*l, *r);
      Poly p = *l;
      addTo(p, *r, isa<arith::AddIOp>(def) ? 1 : -1);
      if (p.size() > kMaxTerms)
        return std::nullopt;
      return p;
    }
    if (auto load = dyn_cast<memref::LoadOp>(def))
      if (std::optional<StringAttr> name = scalarGlobal(load))
        return Poly{{Monomial{name->getAsOpaquePointer()}, 1}};
    return Poly{{Monomial{atomOf(v)}, 1}};
  }

  Operation *root;
  MemoryModel &model;
  const llvm::DenseSet<StringAttr> &writtenGlobals;
  const llvm::DenseMap<Value, Value> &ivCanon;
  llvm::DenseMap<Value, std::optional<Poly>> cache;
  llvm::DenseMap<Atom, Value> atomValues;
};

bool includes(const Monomial &big, const Monomial &small) {
  return std::includes(big.begin(), big.end(), small.begin(), small.end());
}

struct OffloadHostLoops : impl::OffloadHostLoopsBase<OffloadHostLoops> {
  using OffloadHostLoopsBase::OffloadHostLoopsBase;

  llvm::DenseSet<Atom> strideSeed;

  void runOnOperation() override {
    func::FuncOp func = getOperation();
    MemoryModel model(aliasConservative);

    SmallVector<scf::WhileOp> whiles;
    func.walk([&](scf::WhileOp w) { whiles.push_back(w); });
    for (scf::WhileOp w : whiles)
      (void)countdownWhileToFor(w);

    llvm::DenseSet<StringAttr> writtenGlobals;
    func.walk([&](memref::StoreOp store) {
      if (auto g = model.root(store.getMemref()).getDefiningOp<memref::GetGlobalOp>())
        writtenGlobals.insert(g.getNameAttr().getAttr());
    });

    // Atoms that multiply an IV anywhere in the function are strides, also in
    // nests where they only scale an offset (row `im` of `i + im`).
    {
      llvm::DenseMap<Value, Value> none;
      Analysis whole(func, model, writtenGlobals, none);
      llvm::DenseSet<Atom> ivAtoms;
      func.walk([&](Operation *op) {
        if (isa<scf::ForOp, scf::ParallelOp>(op))
          for (Value iv : ivsOf(op))
            ivAtoms.insert(whole.atomOf(iv));
      });
      func.walk([&](Operation *op) {
        std::optional<Poly> flat;
        if (auto load = dyn_cast<memref::LoadOp>(op))
          flat = whole.flatIndex(load.getMemref(), load.getIndices());
        else if (auto store = dyn_cast<memref::StoreOp>(op))
          flat = whole.flatIndex(store.getMemref(), store.getIndices());
        if (flat)
          whole.noteStrides(*flat, ivAtoms);
      });
      strideSeed = whole.strideAtoms;
    }

    for (Operation *root : outermostLoops(func.getBody()))
      offloadOrDescend(root, model, writtenGlobals);

    SmallVector<scf::ParallelOp> kernels;
    func.walk([&](scf::ParallelOp p) {
      if (!p->getParentOfType<scf::ParallelOp>())
        kernels.push_back(p);
    });
    for (scf::ParallelOp p : kernels)
      sinkScalarLoads(p, model);
  }

  // scf.for / scf.while ops in `region` not nested in another loop.
  static SmallVector<Operation *> outermostLoops(Region &region) {
    SmallVector<Operation *> loops;
    region.walk<WalkOrder::PreOrder>([&](Operation *op) {
      if (isa<scf::ParallelOp>(op))
        return WalkResult::skip();
      if (isa<scf::ForOp, scf::WhileOp>(op)) {
        loops.push_back(op);
        return WalkResult::skip();
      }
      return WalkResult::advance();
    });
    return loops;
  }

  void offloadOrDescend(Operation *root, MemoryModel &model,
                        const llvm::DenseSet<StringAttr> &writtenGlobals) {
    if (isa<scf::ForOp>(root) && offload(root, model, writtenGlobals))
      return;
    for (Region &region : root->getRegions())
      for (Operation *inner : outermostLoops(region))
        offloadOrDescend(inner, model, writtenGlobals);
  }

  //===------------------------------------------------------------------===//
  // Countdown scf.while to scf.for.
  //===------------------------------------------------------------------===//

  // Rewrites the C `for (k = init; k >= lower; k--)` the frontend leaves as
  //   memref.store %init, %A[]
  //   scf.while { %v = load %A[]; cmpi sge %v, lower; scf.condition }
  //   do { ...load %A[]...; store (load %A[]) - 1, %A[] }
  // with %A a scalar alloca used nowhere else, into an scf.for over the trip
  // count whose body uses k = init - iv.
  static LogicalResult countdownWhileToFor(scf::WhileOp w) {
    if (w->getNumOperands() || w->getNumResults())
      return failure();
    Block &before = w.getBefore().front();
    Block &after = w.getAfter().front();
    auto cond = cast<scf::ConditionOp>(before.getTerminator());
    auto cmp = cond.getCondition().getDefiningOp<arith::CmpIOp>();
    APInt lower;
    if (!cond.getArgs().empty() || before.getOperations().size() != 3 || !cmp ||
        cmp.getPredicate() != arith::CmpIPredicate::sge ||
        !matchPattern(cmp.getRhs(), m_ConstantInt(&lower)))
      return failure();
    auto head = cmp.getLhs().getDefiningOp<memref::LoadOp>();
    if (!head || head->getBlock() != &before)
      return failure();
    Value counter = head.getMemref();
    auto alloca = counter.getDefiningOp<memref::AllocaOp>();
    if (!alloca || alloca.getType().getRank() != 0)
      return failure();

    auto dec = dyn_cast_or_null<memref::StoreOp>(after.getTerminator()->getPrevNode());
    APInt step;
    if (!dec || dec.getMemref() != counter || after.getTerminator()->getNumOperands())
      return failure();
    auto addi = dec.getValue().getDefiningOp<arith::AddIOp>();
    if (!addi || !matchPattern(addi.getRhs(), m_ConstantInt(&step)) ||
        !step.isAllOnes())
      return failure();
    auto decLoad = addi.getLhs().getDefiningOp<memref::LoadOp>();
    if (!decLoad || decLoad.getMemref() != counter)
      return failure();

    // Stores before the loop; only the last one is observed, by the loop.
    SmallVector<memref::StoreOp> stores;
    SmallVector<memref::LoadOp> loads;
    for (Operation *user : counter.getUsers()) {
      if (user == dec || user == head)
        continue;
      if (auto load = dyn_cast<memref::LoadOp>(user)) {
        if (!w.getAfter().isAncestor(load->getParentRegion()))
          return failure();
        loads.push_back(load);
        continue;
      }
      auto store = dyn_cast<memref::StoreOp>(user);
      if (!store || store.getMemref() != counter ||
          store->getBlock() != w->getBlock() || !store->isBeforeInBlock(w))
        return failure();
      stores.push_back(store);
    }
    if (stores.empty())
      return failure();
    memref::StoreOp init = *llvm::max_element(
        stores, [](memref::StoreOp a, memref::StoreOp b) {
          return a->isBeforeInBlock(b);
        });

    OpBuilder b(w);
    Location loc = w.getLoc();
    Type type = init.getValue().getType();
    Value start = init.getValue();
    if (!type.isIndex())
      start = arith::IndexCastOp::create(b, loc, b.getIndexType(), start);
    Value c0 = arith::ConstantIndexOp::create(b, loc, 0);
    Value c1 = arith::ConstantIndexOp::create(b, loc, 1);
    Value low = arith::ConstantIndexOp::create(b, loc, lower.getSExtValue());
    Value trip = arith::AddIOp::create(
        b, loc, arith::SubIOp::create(b, loc, start, low), c1);
    trip = arith::MaxSIOp::create(b, loc, trip, c0);
    auto loop = scf::ForOp::create(b, loc, c0, trip, c1);
    b.setInsertionPointToStart(loop.getBody());
    Value k = arith::SubIOp::create(b, loc, start, loop.getInductionVar());
    if (!type.isIndex())
      k = arith::IndexCastOp::create(b, loc, type, k);

    Operation *term = loop.getBody()->getTerminator();
    for (Operation &op : llvm::make_early_inc_range(after.without_terminator()))
      op.moveBefore(term);
    dec.erase();
    for (memref::LoadOp load : loads) {
      load.replaceAllUsesWith(k);
      load.erase();
    }
    if (addi->use_empty())
      addi.erase();
    w.erase();
    for (memref::StoreOp store : stores)
      store.erase();
    if (alloca->use_empty())
      alloca.erase();
    LLVM_DEBUG(llvm::dbgs() << "WHILE->FOR " << loc << "\n");
    return success();
  }

  //===------------------------------------------------------------------===//
  // Offloading a host loop nest.
  //===------------------------------------------------------------------===//

  // Moves pure ops and loads of read-only scalar globals that do not depend
  // on the nest out of it, so inner bounds become invariant and no global is
  // read on the device.
  static void hoistInvariants(Operation *root, Analysis &analysis) {
    llvm::SetVector<Operation *> hoist;
    root->walk<WalkOrder::PreOrder>([&](Operation *op) {
      if (op == root || op->getNumRegions() != 0 ||
          op->hasTrait<OpTrait::IsTerminator>())
        return;
      auto load = dyn_cast<memref::LoadOp>(op);
      if (!isPure(op) && !isa<memref::GetGlobalOp>(op) &&
          !(load && analysis.scalarGlobal(load)))
        return;
      if (llvm::all_of(op->getOperands(), [&](Value v) {
            return definedOutside(v, root) || hoist.contains(v.getDefiningOp());
          }))
        hoist.insert(op);
    });
    for (Operation *op : hoist)
      op->moveBefore(root);
  }

  // The chain of perfectly nested loops starting at `root`.
  static Nest buildNest(Operation *root, llvm::DenseMap<Value, Value> &ivCanon) {
    Nest nest{root, {}, {}};
    Operation *cur = root;
    auto boundsOutside = [&](Operation *loop) {
      Bounds b = boundsOf(loop);
      for (ValueRange vs : {ValueRange(b.lbs), ValueRange(b.ubs), ValueRange(b.steps)})
        for (Value v : vs)
          if (!definedOutside(v, root))
            return false;
      return true;
    };
    while (true) {
      nest.levels.push_back({cur, ivsOf(cur), {}});
      Block *body = bodyOf(cur);
      SmallVector<Operation *> loops;
      for (Operation &op : body->without_terminator()) {
        bool hasLoop = false;
        op.walk([&](Operation *inner) {
          if (isa<scf::ForOp, scf::ParallelOp, scf::WhileOp>(inner))
            hasLoop = true;
        });
        if (hasLoop)
          loops.push_back(&op);
      }
      Operation *last = body->getTerminator()->getPrevNode();
      if (loops.size() == 1 && loops.front() == last && isChainLoop(last) &&
          boundsOutside(last)) {
        for (Operation &op : body->without_terminator())
          if (&op != last)
            nest.levels.back().pre.push_back(&op);
        cur = last;
        continue;
      }
      if (loops.size() >= 2 && llvm::all_of(loops, [&](Operation *op) {
            auto p = dyn_cast<scf::ParallelOp>(op);
            auto first = dyn_cast<scf::ParallelOp>(loops.front());
            return p && first && isChainLoop(p) && boundsOutside(p) &&
                   p.getNumLoops() == first.getNumLoops() &&
                   llvm::all_of(p.getStep(), [](Value s) {
                     return matchPattern(s, m_One());
                   });
          })) {
        for (Operation *op : loops)
          nest.fused.push_back(cast<scf::ParallelOp>(op));
        scf::ParallelOp first = nest.fused.front();
        for (scf::ParallelOp p : nest.fused)
          for (auto [iv, canon] :
               llvm::zip(p.getInductionVars(), first.getInductionVars()))
            if (iv != canon)
              ivCanon[iv] = canon;
        Level fusedLevel{first, ivsOf(first), {}};
        for (Operation &op : body->without_terminator()) {
          if (&op == first.getOperation())
            break;
          fusedLevel.pre.push_back(&op);
        }
        nest.levels.push_back(fusedLevel);
      }
      return nest;
    }
  }

  // Ops of the fused level's parent body after the first fused loop: the
  // other fused loops and the ops between them.
  static SmallVector<Operation *> fusedTail(const Nest &nest) {
    SmallVector<Operation *> tail;
    Block *body = nest.fused.front()->getBlock();
    for (Operation *op = nest.fused.front()->getNextNode();
         op != body->getTerminator(); op = op->getNextNode())
      tail.push_back(op);
    return tail;
  }

  bool offload(Operation *root, MemoryModel &model,
               const llvm::DenseSet<StringAttr> &writtenGlobals) {
    llvm::DenseMap<Value, Value> ivCanon;
    {
      llvm::DenseMap<Value, Value> none;
      Analysis hoister(root, model, writtenGlobals, none);
      hoistInvariants(root, hoister);
    }
    Nest nest = buildNest(root, ivCanon);
    Analysis analysis(root, model, writtenGlobals, ivCanon);
    analysis.strideAtoms = strideSeed;
    auto skip = [&](StringRef why) {
      LLVM_DEBUG(llvm::dbgs() << "SKIP [" << why << "] " << root->getLoc() << "\n");
      return false;
    };

    // Every loop IV inside the nest, canonical.
    llvm::DenseSet<Atom> ivAtoms;
    root->walk([&](Operation *op) {
      if (isa<scf::ForOp, scf::ParallelOp>(op))
        for (Value iv : ivsOf(op))
          ivAtoms.insert(analysis.atomOf(ivCanon.lookup(iv) ? ivCanon.lookup(iv) : iv));
    });

    // Bodies of all but the last level: an alloca there would be shared by
    // the iterations of the levels below it. Allocas deeper in are private.
    llvm::DenseSet<Block *> chainBodies;
    for (size_t i = 0; i + 1 < nest.levels.size(); ++i)
      chainBodies.insert(bodyOf(nest.levels[i].loop));

    SmallVector<Access> accesses;
    bool usesDevice = false;
    const char *blocker = nullptr;
    root->walk([&](Operation *op) {
      if (blocker)
        return;
      Value memref;
      ValueRange indices;
      bool write = false;
      if (auto load = dyn_cast<memref::LoadOp>(op)) {
        memref = load.getMemref();
        indices = load.getIndices();
      } else if (auto store = dyn_cast<memref::StoreOp>(op)) {
        memref = store.getMemref();
        indices = store.getIndices();
        write = true;
      } else if (auto alloca = dyn_cast<memref::AllocaOp>(op)) {
        if (chainBodies.contains(alloca->getBlock()))
          blocker = "alloca shared between iterations";
        return;
      } else if (auto p = dyn_cast<scf::ParallelOp>(op)) {
        if (p.getNumReductions() != 0)
          blocker = "nested reduction";
        return;
      } else {
        if (!isMemoryEffectFree(op) &&
            !op->hasTrait<OpTrait::HasRecursiveMemoryEffects>())
          blocker = "unsupported memory effect";
        return;
      }
      Value r = model.root(memref);
      if (auto alloca = r.getDefiningOp<memref::AllocaOp>()) {
        if (!root->isProperAncestor(alloca))
          blocker = "host stack memref";
        return;
      }
      if (!isDeviceBuffer(r)) {
        blocker = "global or non-argument memref on the device";
        return;
      }
      usesDevice = true;
      accesses.push_back({op, r, write, analysis.flatIndex(memref, indices)});
    });
    if (blocker)
      return skip(blocker);
    if (!usesDevice)
      return skip("no device buffer");
    for (Access &a : accesses)
      if (a.flat)
        analysis.noteStrides(*a.flat, ivAtoms);
    for (Access &a : accesses)
      if (a.flat)
        for (auto &[m, c] : *a.flat)
          for (Atom atom : m)
            if (analysis.strideAtoms.contains(atom) && !analysis.invariant(atom))
              return skip("variant stride");

    llvm::DenseSet<Value> written;
    for (Access &a : accesses)
      if (a.write)
        written.insert(a.root);

    // Per root, whether its dimensions form one basis (1, s1, s1*s2, ...).
    llvm::DenseMap<Value, bool> basisOk;
    llvm::DenseMap<Operation *, Dims> dims;
    {
      llvm::DenseMap<Value, std::set<Monomial>> keys;
      for (Access &a : accesses) {
        if (!a.flat)
          continue;
        Dims d = analysis.delinearize(*a.flat);
        for (auto &[key, sub] : d)
          keys[a.root].insert(key);
        dims[a.op] = std::move(d);
      }
      for (auto &[r, ks] : keys) {
        SmallVector<Monomial> sorted(ks.begin(), ks.end());
        llvm::sort(sorted, [](const Monomial &a, const Monomial &b) {
          return a.size() < b.size();
        });
        bool ok = true;
        for (size_t i = 1; i < sorted.size(); ++i)
          ok &= sorted[i].size() > sorted[i - 1].size() &&
                includes(sorted[i], sorted[i - 1]);
        basisOk[r] = ok;
      }
    }

    // Whether equal addresses of `w` and `a` imply equal `x`.
    auto pins = [&](Value x, const Access &w, const Access &a) {
      if (!w.flat || !a.flat || !basisOk.lookup(w.root))
        return false;
      Monomial xm{analysis.atomOf(x)};
      const Dims &dw = dims[w.op], &da = dims[a.op];
      for (auto &[key, sw] : dw) {
        auto it = da.find(key);
        if (it == da.end())
          continue;
        const Poly &sa = it->second;
        auto cw = sw.find(xm), ca = sa.find(xm);
        if (cw == sw.end() || ca == sa.end() || cw->second != ca->second)
          continue;
        Poly rw = sw, ra = sa;
        rw.erase(xm);
        ra.erase(xm);
        if (rw != ra || !llvm::all_of(rw, [&](auto &term) {
              return analysis.invariant(term.first);
            }))
          continue;
        return true;
      }
      return false;
    };
    auto parallelizable = [&](Value x) {
      for (const Access &w : accesses) {
        if (!w.write)
          continue;
        for (const Access &a : accesses) {
          if (!model.mayAlias(w.root, a.root))
            continue;
          if (w.root != a.root || !pins(x, w, a))
            return false;
        }
      }
      return true;
    };

    // Ops that move to another level of the rewritten nest must not observe
    // the nest's writes.
    auto sinkable = [&](Operation *op) {
      if (op->getNumRegions() != 0)
        return false;
      if (isPure(op))
        return true;
      auto load = dyn_cast<memref::LoadOp>(op);
      return load && !written.contains(model.root(load.getMemref()));
    };
    for (size_t i = 0; i < nest.levels.size(); ++i) {
      bool isFusedLevel = !nest.fused.empty() && i + 1 == nest.levels.size();
      bool ok = llvm::all_of(nest.levels[i].pre, sinkable);
      if (ok && isFusedLevel)
        ok = llvm::all_of(fusedTail(nest), [&](Operation *op) {
          auto p = dyn_cast<scf::ParallelOp>(op);
          return (p && llvm::is_contained(nest.fused, p)) || sinkable(op);
        });
      if (ok)
        continue;
      // The chain ends above: this level (or, for fused loops, the level
      // holding them) is cloned whole as the innermost body.
      if (isFusedLevel)
        nest.levels.pop_back();
      else
        nest.levels.resize(i + 1);
      nest.levels.back().pre.clear();
      nest.fused.clear();
      break;
    }

    llvm::DenseSet<Value> par;
    for (Level &level : nest.levels)
      for (Value iv : level.ivs)
        if (parallelizable(iv))
          par.insert(iv);
    if (par.empty())
      return skip("no parallel IV");

    rewrite(nest, par);
    return true;
  }

  // Replaces the nest by one scf.parallel over the IVs in `par`, with the
  // other chain loops serial inside it in their original order.
  static void rewrite(Nest &nest, const llvm::DenseSet<Value> &par) {
    Operation *root = nest.root;
    OpBuilder b(root);
    Location loc = root->getLoc();
    IRMapping map;

    // Bounds of the parallel IVs; for fused loops the union of their ranges.
    SmallVector<Value> lbs, ubs, steps, oldIvs;
    for (Level &level : nest.levels) {
      bool isFused = !nest.fused.empty() &&
                     level.loop == nest.fused.front().getOperation();
      Bounds bounds = boundsOf(level.loop);
      for (auto [d, iv] : llvm::enumerate(level.ivs)) {
        if (!par.contains(iv))
          continue;
        Value lb = bounds.lbs[d], ub = bounds.ubs[d];
        if (isFused)
          for (scf::ParallelOp p : nest.fused) {
            if (p.getLowerBound()[d] != lb)
              lb = arith::MinSIOp::create(b, loc, lb, p.getLowerBound()[d]);
            if (p.getUpperBound()[d] != ub)
              ub = arith::MaxSIOp::create(b, loc, ub, p.getUpperBound()[d]);
          }
        lbs.push_back(lb);
        ubs.push_back(ub);
        steps.push_back(bounds.steps[d]);
        oldIvs.push_back(iv);
      }
    }
    auto kernel = scf::ParallelOp::create(b, loc, lbs, ubs, steps);
    for (auto [old, iv] : llvm::zip(oldIvs, kernel.getInductionVars()))
      map.map(old, iv);
    b.setInsertionPoint(kernel.getBody()->getTerminator());

    for (Level &level : nest.levels) {
      bool isFused = !nest.fused.empty() &&
                     level.loop == nest.fused.front().getOperation();
      Bounds bounds = boundsOf(level.loop);
      for (auto [d, iv] : llvm::enumerate(level.ivs)) {
        if (par.contains(iv))
          continue;
        Value lb = map.lookupOrDefault(bounds.lbs[d]);
        Value ub = map.lookupOrDefault(bounds.ubs[d]);
        if (isFused)
          for (scf::ParallelOp p : nest.fused) {
            if (p.getLowerBound()[d] != bounds.lbs[d])
              lb = arith::MinSIOp::create(b, loc, lb, map.lookupOrDefault(p.getLowerBound()[d]));
            if (p.getUpperBound()[d] != bounds.ubs[d])
              ub = arith::MaxSIOp::create(b, loc, ub, map.lookupOrDefault(p.getUpperBound()[d]));
          }
        auto serial = scf::ForOp::create(b, loc, lb, ub,
                                         map.lookupOrDefault(bounds.steps[d]));
        map.map(iv, serial.getInductionVar());
        b.setInsertionPoint(serial.getBody()->getTerminator());
      }
      for (Operation *op : level.pre)
        b.clone(*op, map);
    }

    Level &last = nest.levels.back();
    if (nest.fused.empty()) {
      for (Operation &op : bodyOf(last.loop)->without_terminator())
        b.clone(op, map);
    } else {
      SmallVector<Operation *> body{nest.fused.front()};
      body.append(fusedTail(nest));
      for (Operation *op : body) {
        auto p = dyn_cast<scf::ParallelOp>(op);
        if (!p || !llvm::is_contained(nest.fused, p)) {
          b.clone(*op, map);
          continue;
        }
        // Each loop runs on its own range of the union.
        OpBuilder::InsertionGuard guard(b);
        Value cond;
        auto addCond = [&](arith::CmpIPredicate pred, Value iv, Value bound) {
          Value c = arith::CmpIOp::create(b, loc, pred, iv, bound);
          cond = cond ? arith::AndIOp::create(b, loc, cond, c).getResult() : c;
        };
        for (auto [d, iv] : llvm::enumerate(p.getInductionVars())) {
          Value newIv = map.lookup(last.ivs[d]);
          map.map(iv, newIv);
          Value lb = p.getLowerBound()[d], ub = p.getUpperBound()[d];
          if (llvm::any_of(nest.fused, [&](scf::ParallelOp q) {
                return q.getLowerBound()[d] != lb;
              }))
            addCond(arith::CmpIPredicate::sge, newIv, lb);
          if (llvm::any_of(nest.fused, [&](scf::ParallelOp q) {
                return q.getUpperBound()[d] != ub;
              }))
            addCond(arith::CmpIPredicate::slt, newIv, ub);
        }
        if (cond) {
          auto guarded = scf::IfOp::create(b, loc, cond, /*withElseRegion=*/false);
          b.setInsertionPoint(guarded.thenBlock()->getTerminator());
        }
        for (Operation &inner : p.getBody()->without_terminator())
          b.clone(inner, map);
      }
    }

    // Parallel loops left inside the body run serially in each thread.
    SmallVector<scf::ParallelOp> nested;
    kernel.getBody()->walk([&](scf::ParallelOp p) { nested.push_back(p); });
    for (scf::ParallelOp p : nested)
      parallelToFor(p);

    LLVM_DEBUG({
      llvm::dbgs() << "OFFLOAD " << loc << " parallel=" << oldIvs.size()
                   << " serial=";
      unsigned serial = 0;
      for (Level &level : nest.levels)
        serial += level.ivs.size();
      llvm::dbgs() << serial - oldIvs.size() << "\n";
    });
    root->erase();
  }

  static void parallelToFor(scf::ParallelOp p) {
    OpBuilder b(p);
    IRMapping map;
    for (auto [iv, lb, ub, step] :
         llvm::zip(p.getInductionVars(), p.getLowerBound(), p.getUpperBound(),
                   p.getStep())) {
      auto loop = scf::ForOp::create(b, p.getLoc(), lb, ub, step);
      map.map(iv, loop.getInductionVar());
      b.setInsertionPoint(loop.getBody()->getTerminator());
    }
    for (Operation &op : p.getBody()->without_terminator())
      b.clone(op, map);
    p.erase();
  }

  //===------------------------------------------------------------------===//
  // Sinking host loads of scalars into kernels.
  //===------------------------------------------------------------------===//

  // Moves loads of function-argument memrefs that run on the host only to
  // feed `kernel` (and the pure ops between them and the kernel) into it, so
  // the host never touches those buffers. A load is moved only when nothing
  // between it and the kernel, and nothing in the kernel, writes its root.
  static void sinkScalarLoads(scf::ParallelOp kernel, MemoryModel &model) {
    std::optional<MemoryFootprint> inside =
        model.footprint(ArrayRef<Operation *>(kernel.getOperation()), false);
    if (!inside)
      return;
    llvm::DenseMap<Value, bool> memo;
    std::function<bool(Value)> sinks = [&](Value v) -> bool {
      if (auto it = memo.find(v); it != memo.end())
        return it->second;
      memo[v] = false;
      Operation *def = v.getDefiningOp();
      if (!def || def->getNumRegions() != 0 || kernel->isAncestor(def))
        return false;
      bool result = false;
      if (auto load = dyn_cast<memref::LoadOp>(def)) {
        Value r = model.root(load.getMemref());
        Operation *anchor = kernel;
        while (anchor && anchor->getBlock() != load->getBlock())
          anchor = anchor->getParentOp();
        result = isDeviceBuffer(r) && anchor && load->isBeforeInBlock(anchor) &&
                 !inside->writes.contains(r) &&
                 !model.mayWriteBetween(load, anchor, r);
        if (result && anchor != kernel.getOperation()) {
          std::optional<MemoryFootprint> around =
              model.footprint(ArrayRef<Operation *>(anchor), false);
          result = around && !around->writes.contains(r);
        }
      } else if (isPure(def)) {
        // Its other operands are defined before it, so outside the kernel.
        for (Value o : def->getOperands())
          result |= sinks(o);
      }
      return memo[v] = result;
    };

    SmallVector<Value> roots;
    kernel.getBody()->walk([&](Operation *op) {
      for (Value v : op->getOperands())
        if (!kernel->isAncestor(v.getParentBlock()->getParentOp()) && sinks(v) &&
            !llvm::is_contained(roots, v))
          roots.push_back(v);
    });
    if (roots.empty())
      return;

    OpBuilder b = OpBuilder::atBlockBegin(kernel.getBody());
    IRMapping map;
    std::function<Value(Value)> clone = [&](Value v) -> Value {
      if (Value m = map.lookupOrNull(v))
        return m;
      if (!memo.lookup(v))
        return v;
      Operation *def = v.getDefiningOp();
      for (Value o : def->getOperands())
        map.map(o, clone(o));
      Operation *copy = b.clone(*def, map);
      for (auto [o, n] : llvm::zip(def->getResults(), copy->getResults()))
        map.map(o, n);
      return map.lookup(v);
    };
    for (Value v : roots) {
      Value inner = clone(v);
      v.replaceUsesWithIf(inner, [&](OpOperand &use) {
        return kernel->isProperAncestor(use.getOwner());
      });
    }
    LLVM_DEBUG(llvm::dbgs() << "SINK LOADS [" << roots.size() << "] "
                            << kernel.getLoc() << "\n");
  }
};

}  // namespace
}  // namespace tutorial
}  // namespace mlir
