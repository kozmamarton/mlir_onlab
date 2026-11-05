#include "Transform/SCF/GpuCoalescedTiling.h"

#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/Debug.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/GPU/Transforms/ParallelLoopMapper.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/SCF/Transforms/Transforms.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace tutorial {

#define GEN_PASS_DEF_GPUCOALESCEDTILING
#include "Transform/SCF/Passes.h.inc"

#define DEBUG_TYPE "scf-gpu-coalesced-tiling"

namespace {

// Whether `index` is `iv` plus terms that do not scale it: `iv` itself, or a
// chain of addi (either side) / subi (minuend) reaching it, looking through
// index casts. A product such as `iv * im` is a strided use and does not count.
bool isUnitAddend(Value index, Value iv, int depth = 8) {
  if (index == iv)
    return true;
  if (depth == 0)
    return false;
  Operation *def = index.getDefiningOp();
  if (!def)
    return false;
  if (auto add = dyn_cast<arith::AddIOp>(def))
    return isUnitAddend(add.getLhs(), iv, depth - 1) ||
           isUnitAddend(add.getRhs(), iv, depth - 1);
  if (auto sub = dyn_cast<arith::SubIOp>(def))
    return isUnitAddend(sub.getLhs(), iv, depth - 1);
  if (isa<arith::IndexCastOp, arith::IndexCastUIOp, arith::ExtSIOp,
          arith::ExtUIOp>(def))
    return isUnitAddend(def->getOperand(0), iv, depth - 1);
  return false;
}

// The position of the IV of `loop` that indexes memory with unit stride: the
// one most loads and stores use as a plain addend of their last index (when
// that dimension has stride 1). Ties and loops without such accesses resolve
// to the innermost IV.
unsigned unitStrideIV(scf::ParallelOp loop) {
  ValueRange ivs = loop.getInductionVars();
  SmallVector<unsigned> votes(ivs.size(), 0);
  auto vote = [&](MemRefType type, ValueRange indices) {
    if (indices.empty() || !type.isLastDimUnitStride())
      return;
    for (auto [pos, iv] : llvm::enumerate(ivs))
      if (isUnitAddend(indices.back(), iv))
        ++votes[pos];
  };
  loop.getBody()->walk([&](Operation *op) {
    if (auto load = dyn_cast<memref::LoadOp>(op))
      vote(load.getMemRefType(), load.getIndices());
    else if (auto store = dyn_cast<memref::StoreOp>(op))
      vote(store.getMemRefType(), store.getIndices());
  });
  unsigned best = ivs.size() - 1;
  for (unsigned pos = 0; pos < ivs.size(); ++pos)
    if (votes[pos] > votes[best])
      best = pos;
  return best;
}

struct GpuCoalescedTiling
    : impl::GpuCoalescedTilingBase<GpuCoalescedTiling> {
  using GpuCoalescedTilingBase::GpuCoalescedTilingBase;

  void runOnOperation() override {
    SmallVector<int64_t> shape3d(block3d.begin(), block3d.end());
    SmallVector<int64_t> shape2d(block2d.begin(), block2d.end());
    if (shape3d.empty())
      shape3d = {32, 4, 2};
    if (shape2d.empty())
      shape2d = {32, 8};
    if (shape3d.size() != 3 || shape2d.size() != 2 || block1d <= 0 ||
        llvm::any_of(shape3d, [](int64_t s) { return s <= 0; }) ||
        llvm::any_of(shape2d, [](int64_t s) { return s <= 0; })) {
      getOperation()->emitError("block-3d needs 3 and block-2d 2 positive sizes");
      return signalPassFailure();
    }

    SmallVector<scf::ParallelOp> loops;
    getOperation()->walk([&](scf::ParallelOp loop) {
      if (loop->getParentOfType<scf::ParallelOp>() ||
          loop->hasAttr(gpu::getMappingAttrName()) ||
          loop.getNumReductions() != 0)
        return;
      bool hasNested = false;
      loop.getBody()->walk([&](scf::ParallelOp) { hasNested = true; });
      if (!hasNested)
        loops.push_back(loop);
    });

    for (scf::ParallelOp loop : loops) {
      unsigned rank = loop.getNumLoops();
      ArrayRef<int64_t> shape = rank >= 3   ? ArrayRef<int64_t>(shape3d)
                                : rank == 2 ? ArrayRef<int64_t>(shape2d)
                                            : ArrayRef<int64_t>(block1d.getValue());
      // hwDim[pos]: which of x, y, z the IV at `pos` is mapped to, or -1.
      SmallVector<int> hwDim(rank, -1);
      unsigned x = unitStrideIV(loop);
      hwDim[x] = 0;
      int next = 1;
      for (int pos = rank - 1; pos >= 0 && next < 3; --pos)
        if (static_cast<unsigned>(pos) != x)
          hwDim[pos] = next++;

      SmallVector<int64_t> tileSizes(rank, 1);
      for (unsigned pos = 0; pos < rank; ++pos)
        if (hwDim[pos] >= 0)
          tileSizes[pos] = shape[hwDim[pos]];

      LLVM_DEBUG({
        llvm::dbgs() << "TILE " << loop.getLoc() << " x=IV#" << x << " tiles=[";
        llvm::interleaveComma(tileSizes, llvm::dbgs());
        llvm::dbgs() << "]\n";
      });

      auto [outer, inner] =
          scf::tileParallelLoop(loop, tileSizes, /*noMinMaxBounds=*/false);
      if (failed(setMapping(outer, hwDim, gpu::Processor::BlockX)) ||
          failed(setMapping(inner, hwDim, gpu::Processor::ThreadX)))
        return signalPassFailure();
    }
  }

  // Maps each IV of `loop` to `first` + its hardware dimension (BlockX or
  // ThreadX, then Y, Z), or to Sequential.
  static LogicalResult setMapping(scf::ParallelOp loop, ArrayRef<int> hwDim,
                                  gpu::Processor first) {
    MLIRContext *ctx = loop.getContext();
    AffineMap id = AffineMap::getMultiDimIdentityMap(1, ctx);
    SmallVector<gpu::ParallelLoopDimMappingAttr> attrs;
    for (int dim : hwDim) {
      gpu::Processor proc =
          dim < 0 ? gpu::Processor::Sequential
                  : static_cast<gpu::Processor>(static_cast<int64_t>(first) + dim);
      attrs.push_back(gpu::ParallelLoopDimMappingAttr::get(ctx, proc, id, id));
    }
    return gpu::setMappingAttr(loop, attrs);
  }
};

}  // namespace
}  // namespace tutorial
}  // namespace mlir
