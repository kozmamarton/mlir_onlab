#include "Transform/Affine/ReinterpretFlatArrayAccess.h"

#include "llvm/ADT/DenseMap.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_DEF_REINTERPRETFLATARRAYACCESS
#include "Transform/Affine/Passes.h.inc"

namespace {

struct FlatAccessInfo {
  unsigned rank;

  Value i;
  Value j;
  Value k;

  int64_t iOffset;
  int64_t jOffset;
  int64_t kOffset;

  Value iSize;
  Value jSize;
  Value kSize;
};

struct ParsedTerm {
  unsigned dimPos;
  int64_t offset;
  SmallVector<unsigned> symbols;
};

struct CachedView {
  Operation *insertionAnchor;
  unsigned rank;
  Value iSize;
  Value jSize;
  Value kSize;
  Value view;
};

static bool isAdd(AffineExpr expr) { return expr.getKind() == AffineExprKind::Add; }
static bool isMul(AffineExpr expr) { return expr.getKind() == AffineExprKind::Mul; }

// Matches an affine dimension, optionally shifted by an integer constant.
//
// @param expr Expression to inspect.
// @param[out] dimPos Position of the matched dimension in the affine map.
// @param[out] offset Constant added to the dimension; zero when no constant
// is present.
// @return `true` for `d` and `d + c`/`c + d`; `false` for every other
// expression, including expressions containing more than one dimension or a
// non-constant addend.
static bool matchDimPlusConst(AffineExpr expr, unsigned &dimPos, int64_t &offset) {
  if (auto d = llvm::dyn_cast<AffineDimExpr>(expr)) {
    dimPos = d.getPosition();
    offset = 0;
    return true;
  }

  if (!isAdd(expr))
    return false;

  auto bin = llvm::cast<AffineBinaryOpExpr>(expr);
  AffineExpr lhs = bin.getLHS();
  AffineExpr rhs = bin.getRHS();

  if (auto d = llvm::dyn_cast<AffineDimExpr>(lhs)) {
    if (auto c = llvm::dyn_cast<AffineConstantExpr>(rhs)) {
      dimPos = d.getPosition();
      offset = c.getValue();
      return true;
    }
  }

  if (auto d = llvm::dyn_cast<AffineDimExpr>(rhs)) {
    if (auto c = llvm::dyn_cast<AffineConstantExpr>(lhs)) {
      dimPos = d.getPosition();
      offset = c.getValue();
      return true;
    }
  }

  return false;
}

// Parses one multiplicative factor of a flat-array affine access.
//
// The accepted product contains at most one dimension-plus-constant factor,
// any number of symbol factors, and literal factors equal to one. The output
// accumulates into the supplied arguments, which allows this function to
// recurse through nested multiplication expressions.
//
// @param expr Expression or product to parse.
// @param[out] dimPos Optional dimension position; set on the first
// dimension factor and unchanged thereafter.
// @param[out] offset Offset belonging to the dimension factor.
// @param[out] symbols Positions of symbol factors in encounter order.
// @return `true` when the complete expression is composed of supported
// factors. Returns `false` for a second dimension factor, a non-unit
// constant, or any unsupported affine operation.
static bool parseProduct(AffineExpr expr, std::optional<unsigned> &dimPos,
                         int64_t &offset, SmallVectorImpl<unsigned> &symbols) {
  unsigned localDimPos = 0;
  int64_t localOffset = 0;

  if (matchDimPlusConst(expr, localDimPos, localOffset)) {
    if (dimPos.has_value())
      return false;
    dimPos = localDimPos;
    offset = localOffset;
    return true;
  }

  if (auto sym = llvm::dyn_cast<AffineSymbolExpr>(expr)) {
    symbols.push_back(sym.getPosition());
    return true;
  }

  if (auto cst = llvm::dyn_cast<AffineConstantExpr>(expr))
    return cst.getValue() == 1;

  if (!isMul(expr))
    return false;

  auto mul = llvm::cast<AffineBinaryOpExpr>(expr);
  return parseProduct(mul.getLHS(), dimPos, offset, symbols) &&
         parseProduct(mul.getRHS(), dimPos, offset, symbols);
}

// Converts one additive term into its structured representation.
//
// @param expr Additive term expected to contain one dimension factor and
// zero or more symbol factors.
// @param[out] term Parsed dimension position, dimension offset, and symbol
// positions.
// @return `true` when `expr` contains exactly one dimension factor and
// only factors accepted by parseProduct; `false` when the dimension is
// missing or the term contains an unsupported factor.
static bool parseTerm(AffineExpr expr, ParsedTerm &term) {
  std::optional<unsigned> dimPos;
  int64_t offset = 0;
  SmallVector<unsigned> symbols;

  if (!parseProduct(expr, dimPos, offset, symbols) || !dimPos.has_value())
    return false;

  term.dimPos = *dimPos;
  term.offset = offset;
  term.symbols = std::move(symbols);
  return true;
}

// Flattens a tree of additions into its non-additive leaf terms.
//
// @param expr Expression whose additions should be recursively flattened.
// @param[out] terms Destination receiving leaves from left to right.
// @return Nothing. An expression with no addition contributes itself as
// one term, and an empty input vector remains unchanged only if no leaf is
// reached (which cannot occur for a valid AffineExpr).
static void collectAddTerms(AffineExpr expr, SmallVectorImpl<AffineExpr> &terms) {
  if (isAdd(expr)) {
    auto add = llvm::cast<AffineBinaryOpExpr>(expr);
    collectAddTerms(add.getLHS(), terms);
    collectAddTerms(add.getRHS(), terms);
    return;
  }
  terms.push_back(expr);
}

// Finds the nearest enclosing affine loop whose induction variable is `iv`.
//
// @param op Operation from which the parent chain is searched. The
// operation itself is not tested.
// @param iv Induction variable to match.
// @return The nearest matching `affine.for`, or a null operation when no
// enclosing loop uses `iv` as its induction variable.
static affine::AffineForOp findParentForByIV(Operation *op, Value iv) {
  Operation *cursor = op->getParentOp();
  while (cursor) {
    if (auto forOp = llvm::dyn_cast<affine::AffineForOp>(cursor)) {
      if (forOp.getInductionVar() == iv)
        return forOp;
    }
    cursor = cursor->getParentOp();
  }
  return {};
}

// Materializes a simple affine loop bound as an index value.
//
// Constant bounds become new `arith.constant` operations. A one-result bound
// that is directly a dimension or symbol returns the corresponding bound
// operand. Compound maps and maps with no result are unsupported.
//
// @param builder Builder used for materializing constant bounds.
// @param loc Location for any operation created by this helper.
// @param forOp Loop whose bound is requested.
// @param upperBound Select the upper bound when `true`, otherwise the lower
// bound.
// @return An index `Value` for a supported bound, or a null `Value` when
// `forOp` is null, the map has anything other than one result, or its result
// cannot be mapped directly to an operand or constant.
static Value getSimpleBoundAsValue(OpBuilder &builder, Location loc,
                                   affine::AffineForOp forOp,
                                   bool upperBound) {
  if (!forOp)
    return {};

  if (upperBound && forOp.hasConstantUpperBound())
    return builder.create<arith::ConstantIndexOp>(loc, forOp.getConstantUpperBound());
  if (!upperBound && forOp.hasConstantLowerBound())
    return builder.create<arith::ConstantIndexOp>(loc, forOp.getConstantLowerBound());

  AffineMap map = upperBound ? forOp.getUpperBoundMap() : forOp.getLowerBoundMap();
  ValueRange operands = upperBound ? forOp.getUpperBoundOperands()
                                   : forOp.getLowerBoundOperands();
  if (map.getNumResults() != 1)
    return {};

  AffineExpr expr = map.getResult(0);
  if (auto d = llvm::dyn_cast<AffineDimExpr>(expr)) {
    if (d.getPosition() < operands.size())
      return operands[d.getPosition()];
    return {};
  }

  if (auto s = llvm::dyn_cast<AffineSymbolExpr>(expr)) {
    unsigned pos = map.getNumDims() + s.getPosition();
    if (pos < operands.size())
      return operands[pos];
    return {};
  }

  if (auto c = llvm::dyn_cast<AffineConstantExpr>(expr))
    return builder.create<arith::ConstantIndexOp>(loc, c.getValue());

  return {};
}

// Adds an integer offset to an index, preserving the original value at zero.
//
// @param builder Builder used to create a non-zero offset operation.
// @param loc Location for the generated `affine.apply`.
// @param base Base index value.
// @param offset Integer offset to add to `base`.
// @return `base` unchanged when `offset` is zero; otherwise the result of
// a one-dimensional `affine.apply` computing `base + offset`.
static Value createIndexWithOffset(OpBuilder &builder, Location loc, Value base,
                                   int64_t offset) {
  if (offset == 0)
    return base;
  MLIRContext *ctx = builder.getContext();
  AffineExpr d0 = getAffineDimExpr(0, ctx);
  AffineExpr c = getAffineConstantExpr(offset, ctx);
  AffineMap map = AffineMap::get(/*dimCount=*/1, /*symbolCount=*/0, d0 + c);
  return builder.create<affine::AffineApplyOp>(loc, map, ValueRange{base})
      .getResult();
}

    // Recognizes a supported flat-array access and fills its multidimensional
    // interpretation.
    //
    // The map must have one result that is a sum of one plain term, one term with
    // one symbol, and optionally one term with two symbols. These terms describe
    // the innermost `i` dimension, the `j` dimension, and optionally the `k`
    // dimension. For rank two, the enclosing `j` loop's upper bound supplies the
    // outer size. For rank three, the enclosing `k` loop's upper bound supplies
    // the outer size and the second symbol supplies the `j` size.
    //
    // @param map Affine access map to parse.
    // @param mapOperands Values bound to the map dimensions and symbols.
    // @param at Operation being rewritten, used to find enclosing loops and its
    // location.
    // @param builder Builder used to materialize bound values.
    // @param[out] info Parsed indices, offsets, sizes, and inferred rank.
    // @return `true` and initializes `info` for a supported rank-2 or rank-3
    // access. Returns `false` for multiple map results, unsupported terms,
    // duplicate term categories, missing operands, mismatched symbols, or a
    // missing/non-simple enclosing loop bound.
static bool parseFlatAccess(AffineMap map, ValueRange mapOperands, Operation *at,
                            OpBuilder &builder, FlatAccessInfo &info) {
  if (map.getNumResults() != 1)
    return false;

  SmallVector<AffineExpr> terms;
  collectAddTerms(map.getResult(0), terms);

  SmallVector<ParsedTerm> parsedTerms;
  parsedTerms.reserve(terms.size());
  for (AffineExpr termExpr : terms) {
    ParsedTerm term;
    if (!parseTerm(termExpr, term))
      return false;
    parsedTerms.push_back(std::move(term));
  }

  const ParsedTerm *plain = nullptr;
  const ParsedTerm *oneSym = nullptr;
  const ParsedTerm *twoSym = nullptr;

  for (const ParsedTerm &term : parsedTerms) {
    if (term.symbols.empty()) {
      if (plain)
        return false;
      plain = &term;
      continue;
    }
    if (term.symbols.size() == 1) {
      if (oneSym)
        return false;
      oneSym = &term;
      continue;
    }
    if (term.symbols.size() == 2) {
      if (twoSym)
        return false;
      twoSym = &term;
      continue;
    }
    return false;
  }

  if (!plain || !oneSym)
    return false;

  if (plain->dimPos >= map.getNumDims() || oneSym->dimPos >= map.getNumDims())
    return false;

  info.i = mapOperands[plain->dimPos];
  info.j = mapOperands[oneSym->dimPos];
  info.iOffset = plain->offset;
  info.jOffset = oneSym->offset;
  info.iSize = mapOperands[map.getNumDims() + oneSym->symbols[0]];

  if (!twoSym) {
    info.rank = 2;
    auto jLoop = findParentForByIV(at, info.j);
    info.jSize = getSimpleBoundAsValue(builder, at->getLoc(), jLoop, /*upperBound=*/true);
    if (!info.jSize)
      return false;
    return true;
  }

  if (twoSym->dimPos >= map.getNumDims() || twoSym->symbols.size() != 2)
    return false;
  if (twoSym->symbols[0] != oneSym->symbols[0])
    return false;

  info.rank = 3;
  info.k = mapOperands[twoSym->dimPos];
  info.kOffset = twoSym->offset;
  info.jSize = mapOperands[map.getNumDims() + twoSym->symbols[1]];

  auto kLoop = findParentForByIV(at, info.k);
  info.kSize = getSimpleBoundAsValue(builder, at->getLoc(), kLoop, /*upperBound=*/true);
  if (!info.kSize)
    return false;

  return true;
}

// Builds the strided memref type used for a multidimensional reinterpretation.
//
// The shape is dynamic in every dimension. Rank two uses strides
// `[dynamic, 1]`; rank three uses `[dynamic, dynamic, 1]`. The element type
// and memory space are preserved from the one-dimensional source type.
//
// @param ctx Context in which the layout and type are created.
// @param srcType Source one-dimensional memref type.
// @param rank Target rank, expected to be two or three for callers in this
// pass.
// @return A strided memref type with zero offset and dynamic shape/outer
// strides. This helper does not validate `rank`; other ranks produce a shape
// of that rank but use the rank-three stride fallback.
static MemRefType buildReinterpretedType(MLIRContext *ctx, MemRefType srcType,
                                         unsigned rank) {
  SmallVector<int64_t> shape(rank, ShapedType::kDynamic);
  SmallVector<int64_t> strides;
  if (rank == 2)
    strides = {ShapedType::kDynamic, 1};
  else
    strides = {ShapedType::kDynamic, ShapedType::kDynamic, 1};

  auto layout = StridedLayoutAttr::get(ctx, 0, strides);
  return MemRefType::get(shape, srcType.getElementType(), layout,
                         srcType.getMemorySpace());
}

// Creates a `memref.reinterpret_cast` view for a parsed flat access.
//
// Rank two creates a `[j, i]` view with strides `[iSize, 1]`. Rank three
// creates a `[k, j, i]` view with strides `[iSize * jSize, iSize, 1]`.
// The source offset is always zero; sizes and strides are taken from `info`.
//
// @param builder Builder used to create the view and any rank-three stride
// multiplication.
// @param loc Location for generated operations.
// @param base Flat memref to reinterpret.
// @param info Parsed access metadata, including rank and dimension sizes.
// @return The result of a `memref.reinterpret_cast`, or a null `Value` if
// `base` is not a `MemRefType`. The helper assumes `info` contains the
// required values for its rank.
static Value createViewForAccess(OpBuilder &builder, Location loc, Value base,
                                 const FlatAccessInfo &info) {
  auto srcType = llvm::dyn_cast<MemRefType>(base.getType());
  if (!srcType)
    return {};

  MemRefType viewType = buildReinterpretedType(builder.getContext(), srcType, info.rank);

  OpFoldResult offset = builder.getIndexAttr(0);
  SmallVector<OpFoldResult> sizes;
  SmallVector<OpFoldResult> strides;

  if (info.rank == 2) {
    sizes = {info.jSize, info.iSize};
    strides = {info.iSize, builder.getIndexAttr(1)};
  } else {
    Value kStride = builder.create<arith::MulIOp>(loc, info.iSize, info.jSize);
    sizes = {info.kSize, info.jSize, info.iSize};
    strides = {kStride, info.iSize, builder.getIndexAttr(1)};
  }

  auto cast = builder.create<memref::ReinterpretCastOp>(loc, viewType, base, offset,
                                                         sizes, strides);
  return cast.getResult();
}

// Returns the loop before which a view for `info` can be materialized.
//
// @param op Access rewritten by the pass.
// @param info Parsed access metadata.
// @return The loop carrying the outermost reinterpreted dimension: `j` for a
// rank-2 access and `k` for a rank-3 access. Returns a null operation when the
// corresponding induction variable has no enclosing affine loop.
static affine::AffineForOp getViewInsertionLoop(Operation *op,
                                                const FlatAccessInfo &info) {
  return findParentForByIV(op, info.rank == 2 ? info.j : info.k);
}

// Checks whether a cached view has the same source layout and loop scope.
//
// @param cached Cached reinterpret-cast view.
// @param insertionAnchor Loop before which a new view would be created.
// @param info Parsed access metadata for the candidate view.
// @return `true` when `cached` can represent `info` at `insertionAnchor`.
// For rank two, `kSize` is ignored; for rank three, all three sizes must
// match.
static bool matchesCachedView(const CachedView &cached,
                              Operation *insertionAnchor,
                              const FlatAccessInfo &info) {
  return cached.insertionAnchor == insertionAnchor &&
         cached.rank == info.rank && cached.iSize == info.iSize &&
         cached.jSize == info.jSize &&
         (info.rank == 2 || cached.kSize == info.kSize);
}

struct ReinterpretFlatArrayAccess
    : impl::ReinterpretFlatArrayAccessBase<ReinterpretFlatArrayAccess> {
  using ReinterpretFlatArrayAccessBase::ReinterpretFlatArrayAccessBase;

  // Rewrites supported one-dimensional affine loads and stores in place.
  //
  // Each supported access is replaced by a zero-offset
  // `memref.reinterpret_cast` view followed by a conventional rank-two or
  // rank-three affine load/store. The original dimension offsets are retained
  // through `affine.apply` operations when non-zero. Unsupported accesses are
  // left unchanged, including non-memref values, memrefs with rank other than
  // one, maps that do not match the supported flat-access form, and accesses
  // whose required loop bounds cannot be materialized.
  //
  // @return Nothing. The pass mutates the operation tree directly; the
  // local change flag is intentionally not exposed as a pass result.
  void runOnOperation() override {
    Operation *root = getOperation();
    SmallVector<Operation *> accesses;

    root->walk([&](Operation *op) {
      if (llvm::isa<affine::AffineLoadOp, affine::AffineStoreOp>(op))
        accesses.push_back(op);
    });

    bool changed = false;
    DenseMap<Value, SmallVector<CachedView>> viewCache;

    for (Operation *op : accesses) {
      if (!op || op->getBlock() == nullptr)
        continue;

      Value memref;
      AffineMap map;
      ValueRange mapOperands;

      if (auto load = llvm::dyn_cast<affine::AffineLoadOp>(op)) {
        memref = load.getMemRef();
        map = load.getAffineMap();
        mapOperands = load.getMapOperands();
      } else if (auto store = llvm::dyn_cast<affine::AffineStoreOp>(op)) {
        memref = store.getMemRef();
        map = store.getAffineMap();
        mapOperands = store.getMapOperands();
      } else {
        continue;
      }

      auto memrefType = llvm::dyn_cast<MemRefType>(memref.getType());
      if (!memrefType || memrefType.getRank() != 1)
        continue;

      FlatAccessInfo info;
      OpBuilder builder(op);
      if (!parseFlatAccess(map, mapOperands, op, builder, info))
        continue;

      auto insertionLoop = getViewInsertionLoop(op, info);
      if (!insertionLoop)
        continue;
      Operation *insertionAnchor = insertionLoop.getOperation();

      Value view;
      SmallVector<CachedView> &cachedViews = viewCache[memref];
      for (const CachedView &cached : cachedViews) {
        if (matchesCachedView(cached, insertionAnchor, info)) {
          view = cached.view;
          break;
        }
      }

      if (!view) {
        OpBuilder viewBuilder(insertionAnchor);
        view = createViewForAccess(viewBuilder, op->getLoc(), memref, info);
        if (!view)
          continue;
        cachedViews.push_back({insertionAnchor, info.rank, info.iSize,
                               info.jSize, info.kSize, view});
      }

      Value i = createIndexWithOffset(builder, op->getLoc(), info.i, info.iOffset);
      Value j = createIndexWithOffset(builder, op->getLoc(), info.j, info.jOffset);

      if (auto load = llvm::dyn_cast<affine::AffineLoadOp>(op)) {
        if (info.rank == 2) {
          auto newLoad = builder.create<affine::AffineLoadOp>(op->getLoc(), view,
                                                              ValueRange{j, i});
          load.replaceAllUsesWith(newLoad.getResult());
          load.erase();
          changed = true;
          continue;
        }

        Value k = createIndexWithOffset(builder, op->getLoc(), info.k, info.kOffset);
        auto newLoad = builder.create<affine::AffineLoadOp>(op->getLoc(), view,
                                                            ValueRange{k, j, i});
        load.replaceAllUsesWith(newLoad.getResult());
        load.erase();
        changed = true;
        continue;
      }

      auto store = llvm::cast<affine::AffineStoreOp>(op);
      if (info.rank == 2) {
        builder.create<affine::AffineStoreOp>(op->getLoc(), store.getValueToStore(),
                                              view, ValueRange{j, i});
        store.erase();
        changed = true;
        continue;
      }

      Value k = createIndexWithOffset(builder, op->getLoc(), info.k, info.kOffset);
      builder.create<affine::AffineStoreOp>(op->getLoc(), store.getValueToStore(),
                                            view, ValueRange{k, j, i});
      store.erase();
      changed = true;
    }

    (void)changed;
  }
};

} // namespace

} // namespace tutorial
} // namespace mlir
