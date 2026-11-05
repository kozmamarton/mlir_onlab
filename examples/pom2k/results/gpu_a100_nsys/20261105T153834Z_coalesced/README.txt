nsys profiles of the pom2k differential GPU harnesses after adding
scf-gpu-coalesced-tiling to scripts/build_src/pom2k/lower_gpu_a100_to_llvm.sh
(stride-1 IV on threadIdx.x; 3D block 32x4x2, 2D block 32x8x1). Host scf.for
loops are still on the host in this run.

Same setup, harness build and scripts as ../20261031T143000Z (see its README):
A100-PCIE-40GB, 1024x1024x20, 20 timed samples + 1 warm-up, nsys 2023.2.3.
