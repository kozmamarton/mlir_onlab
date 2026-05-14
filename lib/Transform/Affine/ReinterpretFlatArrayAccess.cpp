#include "Transform/Affine/ReinterpretFlatArrayAccess.h"

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

static bool isAdd(AffineExpr expr) { return expr.getKind() == AffineExprKind::Add; }
static bool isMul(AffineExpr expr) { return expr.getKind() == AffineExprKind::Mul; }

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

static void collectAddTerms(AffineExpr expr, SmallVectorImpl<AffineExpr> &terms) {
  if (isAdd(expr)) {
    auto add = llvm::cast<AffineBinaryOpExpr>(expr);
    collectAddTerms(add.getLHS(), terms);
    collectAddTerms(add.getRHS(), terms);
    return;
  }
  terms.push_back(expr);
}

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

struct ReinterpretFlatArrayAccess
    : impl::ReinterpretFlatArrayAccessBase<ReinterpretFlatArrayAccess> {
  using ReinterpretFlatArrayAccessBase::ReinterpretFlatArrayAccessBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    SmallVector<Operation *> accesses;

    root->walk([&](Operation *op) {
      if (llvm::isa<affine::AffineLoadOp, affine::AffineStoreOp>(op))
        accesses.push_back(op);
    });

    bool changed = false;

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

      Value view = createViewForAccess(builder, op->getLoc(), memref, info);
      if (!view)
        continue;

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
