nsys profiles of the pom2k differential GPU harnesses after adding
scf-offload-host-loops and scf-gpu-coalesced-tiling to
scripts/build_src/pom2k/lower_gpu_a100_to_llvm.sh: host scf.for nests run as
device kernels (carried k sweeps serial inside one kernel), and every kernel
has the stride-1 IV on a 32-wide threadIdx.x.

Same setup, harness build and scripts as ../20261031T143000Z (see its README):
A100-PCIE-40GB, 1024x1024x20, 20 timed samples + 1 warm-up, nsys 2023.2.3.
