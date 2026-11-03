nsys profiles of the pom2k differential GPU harnesses (old = pipeline output without
the custom fusion pass, new = with it, cuda = native CUDA reference).

Setup: NVIDIA A100-PCIE-40GB (driver 580.95.05), size 1024x1024x20, 20 timed samples
per variant (+1 warm-up, dropped). Harness built exactly like lib/run_diff_kernel.sh
(CUDA 12.3 nvcc), but from a copy with an NVTX range ("old"/"new"/"cuda") around
each timed call. Profiled with nsys 2023.2.3 (-t cuda,nvtx); nsys 2023.3.3 crashes
on 6 of these binaries ("Can't find UUID for CUDA device 0").

Files
  summary.txt / summary.csv  per-kernel medians (summary.csv also has per-API host time)
  samples.csv                one row per timed call: wall, kernel sum, GPU span/idle,
                             pre/post, unified-memory traffic
  launches.csv               every GPU kernel launch inside a timed call (grid, block,
                             regs, duration)
  api_per_sample.csv         CUDA runtime/driver API time per timed call
  nsys-rep/                  raw reports (open in nsys-ui; `nsys export -t sqlite` for SQL)
  harness_stdout/            harness output under nsys (correctness table + its timing)
  scripts/                   profile_one.sh <kernel dir> <out dir>; analyze.py <out dir>
