#!/usr/bin/env python3
"""Attribute nsys events to the NVTX ranges (one per timed harness call) of the
pom2k differential GPU harness and write raw + summary tables.

usage: analyze.py <out dir>   (reads <out dir>/rep/*.sqlite)

Per NVTX range (variant x sample; the first range per variant is the warm-up
and is dropped):
  wall_ms        host time of the call (range duration, includes the final
                 cudaDeviceSynchronize of callKernel)
  kernel_ms      sum of GPU kernel durations launched from inside the range
  gpu_span_ms    first kernel start -> last kernel end
  gpu_idle_ms    gpu_span_ms - kernel_ms (gaps between back-to-back kernels)
  pre_ms         range start -> first kernel start
  post_ms        last kernel end -> range end
  memcpy_*       memcpy activity (incl. unified-memory migrations) overlapping
                 the range on the GPU timeline
  api_*          host time per CUDA runtime/driver API inside the range
"""
import csv
import glob
import os
import sqlite3
import statistics
import sys
from collections import defaultdict

OUT = sys.argv[1]
VARIANTS = ["old", "new", "cuda"]


def med(xs):
    return statistics.median(xs) if xs else float("nan")


def analyze(db_path):
    kernel = os.path.basename(db_path)[: -len(".sqlite")]
    c = sqlite3.connect(db_path)
    strings = dict(c.execute("select id, value from StringIds"))
    ranges = c.execute(
        "select start, end, text, globalTid from NVTX_EVENTS "
        "where text in ('old','new','cuda') and end is not null order by start"
    ).fetchall()
    api = c.execute(
        "select start, end, globalTid, correlationId, nameId from CUPTI_ACTIVITY_KIND_RUNTIME order by start"
    ).fetchall()
    tables = {r[0] for r in c.execute("select name from sqlite_master where type='table'")}
    # nsys omits the table when no kernel ran at all (e.g. ext_etf_update_,
    # whose selectors take none of its branches).
    kernels = {
        r[0]: r[1:]
        for r in c.execute(
            "select correlationId, start, end, shortName, gridX, gridY, gridZ, blockX, blockY, blockZ, "
            "registersPerThread from CUPTI_ACTIVITY_KIND_KERNEL"
        )
    } if "CUPTI_ACTIVITY_KIND_KERNEL" in tables else {}
    memcpys = c.execute(
        "select start, end, bytes, copyKind, migrationCause from CUPTI_ACTIVITY_KIND_MEMCPY order by start"
    ).fetchall()

    seen = defaultdict(int)
    samples, launches, apis = [], [], []
    ai = 0
    for rs, re_, var, tid in ranges:
        idx = seen[var]
        seen[var] += 1
        while ai < len(api) and api[ai][0] < rs:
            ai += 1
        j = ai
        in_api = []
        while j < len(api) and api[j][0] < re_:
            if api[j][2] == tid:
                in_api.append(api[j])
            j += 1
        if idx == 0:  # warm-up
            continue
        sample = idx  # 1-based sample number
        api_time = defaultdict(float)
        api_count = defaultdict(int)
        ks = []
        for s, e, _, corr, nid in in_api:
            name = strings[nid]
            api_time[name] += (e - s) / 1e6
            api_count[name] += 1
            if corr in kernels:
                ks.append(kernels[corr])
        ks.sort()
        for n, (ks_, ke, sn, gx, gy, gz, bx, by, bz, regs) in enumerate(ks):
            launches.append(
                dict(kernel=kernel, variant=var, sample=sample, launch=n, name=strings[sn],
                     grid=f"{gx}x{gy}x{gz}", block=f"{bx}x{by}x{bz}", regs=regs,
                     start_ns=ks_, duration_us=(ke - ks_) / 1e3)
            )
        kms = sum(k[1] - k[0] for k in ks) / 1e6
        span = (ks[-1][1] - ks[0][0]) / 1e6 if ks else 0.0
        mc = [m for m in memcpys if m[1] > rs and m[0] < re_]
        row = dict(
            kernel=kernel, variant=var, sample=sample,
            wall_ms=(re_ - rs) / 1e6, n_kernels=len(ks), kernel_ms=kms,
            gpu_span_ms=span, gpu_idle_ms=span - kms,
            pre_ms=(ks[0][0] - rs) / 1e6 if ks else float("nan"),
            post_ms=(re_ - ks[-1][1]) / 1e6 if ks else float("nan"),
            memcpy_n=len(mc), memcpy_bytes=sum(m[2] for m in mc),
            memcpy_ms=sum(m[1] - m[0] for m in mc) / 1e6,
            # unified-memory migrations: 11 = host->device, 12 = device->host;
            # migrationCause 2 = page fault (host/GPU touched non-resident data)
            um_htod_bytes=sum(m[2] for m in mc if m[3] == 11),
            um_dtoh_bytes=sum(m[2] for m in mc if m[3] == 12),
            um_faults=sum(1 for m in mc if m[4] == 2),
        )
        samples.append(row)
        for name in api_time:
            apis.append(dict(kernel=kernel, variant=var, sample=sample, api=name,
                             calls=api_count[name], total_ms=api_time[name]))
    return kernel, samples, launches, apis


def write_csv(path, rows):
    if not rows:
        return
    with open(path, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)


def main():
    all_samples, all_launches, all_apis, summary = [], [], [], []
    for db in sorted(glob.glob(os.path.join(OUT, "rep", "*.sqlite"))):
        kernel, samples, launches, apis = analyze(db)
        all_samples += samples
        all_launches += launches
        all_apis += apis
        row = dict(kernel=kernel)
        for v in VARIANTS:
            ss = [s for s in samples if s["variant"] == v]
            for key in ["n_kernels", "kernel_ms", "wall_ms", "gpu_span_ms", "gpu_idle_ms",
                        "pre_ms", "post_ms", "memcpy_n", "memcpy_bytes", "memcpy_ms",
                        "um_htod_bytes", "um_dtoh_bytes", "um_faults"]:
                row[f"{v}_{key}"] = med([s[key] for s in ss])
            row[f"{v}_kernel_ms_min"] = min((s["kernel_ms"] for s in ss), default=float("nan"))
            row[f"{v}_kernel_ms_max"] = max((s["kernel_ms"] for s in ss), default=float("nan"))
            row[f"{v}_samples"] = len(ss)
            # median per-sample API time, top host-side APIs
            per = defaultdict(list)
            for a in apis:
                if a["variant"] == v:
                    per[a["api"]].append(a["total_ms"])
            for name, xs in per.items():
                row[f"{v}_api_{name}_ms"] = sum(xs) / max(len(ss), 1)
        o, n, cu = row["old_kernel_ms"], row["new_kernel_ms"], row["cuda_kernel_ms"]
        row["kernel_speedup_new_vs_old"] = o / n if n else float("nan")
        row["kernel_ratio_cuda_vs_new"] = cu / n if n else float("nan")
        row["kernel_ratio_cuda_vs_old"] = cu / o if o else float("nan")
        summary.append(row)

    write_csv(os.path.join(OUT, "samples.csv"), all_samples)
    write_csv(os.path.join(OUT, "launches.csv"), all_launches)
    write_csv(os.path.join(OUT, "api_per_sample.csv"), all_apis)
    keys = []
    for r in summary:
        keys += [k for k in r if k not in keys]
    with open(os.path.join(OUT, "summary.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=keys, restval="")
        w.writeheader()
        w.writerows(summary)

    hdr = (f"{'kernel':34} {'#k old/new/cu':>14} {'old_k_ms':>10} {'new_k_ms':>10} {'cuda_k_ms':>10} "
           f"{'new/old':>8} {'cu/new':>8} | {'old_wall':>9} {'new_wall':>9} {'cu_wall':>9} "
           f"{'old_ovh':>9} {'new_ovh':>9} {'cu_ovh':>8}")
    lines = [hdr, "-" * len(hdr)]
    for r in summary:
        nk = f"{r['old_n_kernels']:.0f}/{r['new_n_kernels']:.0f}/{r['cuda_n_kernels']:.0f}"
        lines.append(
            f"{r['kernel']:34} {nk:>14} {r['old_kernel_ms']:10.4f} {r['new_kernel_ms']:10.4f} "
            f"{r['cuda_kernel_ms']:10.4f} {r['kernel_speedup_new_vs_old']:8.3f} "
            f"{r['kernel_ratio_cuda_vs_new']:8.3f} | {r['old_wall_ms']:9.3f} {r['new_wall_ms']:9.3f} "
            f"{r['cuda_wall_ms']:9.3f} {r['old_wall_ms'] - r['old_kernel_ms']:9.3f} "
            f"{r['new_wall_ms'] - r['new_kernel_ms']:9.3f} {r['cuda_wall_ms'] - r['cuda_kernel_ms']:8.3f}"
        )
    hdr2 = (f"{'kernel':34} {'variant':7} {'wall_ms':>9} {'kernel_ms':>10} {'idle_btw':>9} {'pre':>7} "
            f"{'post':>7} {'um_faults':>9} {'um_dtoh_MB':>10} {'um_htod_MB':>10} {'memcpy_ms':>9}")
    lines += ["", "Non-kernel time inside a call (medians): idle_btw = GPU idle between the call's kernels, "
              "pre/post = call start -> first kernel / last kernel -> call end", "", hdr2, "-" * len(hdr2)]
    for r in summary:
        for v in VARIANTS:
            lines.append(
                f"{r['kernel']:34} {v:7} {r[v + '_wall_ms']:9.3f} {r[v + '_kernel_ms']:10.4f} "
                f"{r[v + '_gpu_idle_ms']:9.3f} {r[v + '_pre_ms']:7.3f} {r[v + '_post_ms']:7.3f} "
                f"{r[v + '_um_faults']:9.0f} {r[v + '_um_dtoh_bytes'] / 2**20:10.2f} "
                f"{r[v + '_um_htod_bytes'] / 2**20:10.2f} {r[v + '_memcpy_ms']:9.3f}"
            )
    txt = "\n".join(lines)
    with open(os.path.join(OUT, "summary.txt"), "w") as f:
        f.write("medians over timed samples; k_ms = summed GPU kernel time per call; "
                "new/old = kernel speedup of new over old; cu/new = cuda kernel time / new kernel time; "
                "ovh = wall - kernel time\n\n" + txt + "\n")
    print(txt)


main()
