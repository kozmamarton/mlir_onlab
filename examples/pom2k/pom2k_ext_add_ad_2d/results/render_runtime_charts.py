#!/usr/bin/env python3
import argparse
import csv
import re
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Tuple

import matplotlib.pyplot as plt


BENCHMARK_ORDER = ["cpu_single_threaded", "cpu_multithreaded", "gpu_cuda", "gpu_amd"]
BENCHMARK_LABEL = {
    "cpu_single_threaded": "Egyszálas végrehajtás",
    "cpu_multithreaded": "Többszálas végrehajtás",
    "gpu_cuda": "GPU végrehajtás (CUDA)",
    "gpu_amd": "GPU végrehajtás (ROCm)",
}
BENCHMARK_COLOR = {
    "cpu_single_threaded": "#4E79A7",
    "cpu_multithreaded": "#A19B4F",
    "gpu_cuda": "#30B038",
    "gpu_amd": "#F23C2B",
}


def looks_like_cpu_description(text: str) -> bool:
    lower = text.lower()
    cpu_markers = ["cpu", "processor", "ryzen", "xeon", "epyc", "threadripper"]
    return any(marker in lower for marker in cpu_markers)


def parse_iso_utc(ts: str) -> datetime:
    return datetime.fromisoformat(ts.replace("Z", "+00:00"))


def parse_raw_filename_timestamp(path: Path) -> datetime:
    m = re.search(r"_(\d{8}T\d{6})Z\.log$", path.name)
    if not m:
        raise ValueError(f"A fajlnevbol nem olvashato ki idobelyeg: {path}")
    dt = datetime.strptime(m.group(1), "%Y%m%dT%H%M%S")
    return dt.replace(tzinfo=timezone.utc)


def parse_calls_and_times(raw_text: str) -> Tuple[int, float, float]:
    calls_match = re.search(
        r"Number of (?:function|kernel) calls initiated:\s*(\d+)",
        raw_text,
        flags=re.IGNORECASE,
    )
    if not calls_match:
        raise ValueError("Nem talalhato a futtatasok szama a RAW logban.")
    calls = int(calls_match.group(1))

    time_match = re.search(
        r"total:\s*([0-9.]+)\s*us\s*\(([0-9.]+)\s*ms\)\s*average:\s*([0-9.]+)\s*us\s*\(([0-9.]+)\s*ms\)",
        raw_text,
        flags=re.IGNORECASE,
    )
    if not time_match:
        raise ValueError("Nem talalhato total/average idoadat a RAW logban.")

    total_ms = float(time_match.group(2))
    avg_ms_from_log = float(time_match.group(4))
    avg_ms_from_calls = total_ms / calls if calls > 0 else avg_ms_from_log

    return calls, total_ms, avg_ms_from_calls


def load_csv_rows(csv_path: Path) -> List[Dict[str, str]]:
    with csv_path.open("r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        return list(reader)


def collect_rows_from_results(results_dir: Path, csv_glob: str) -> List[Dict[str, str]]:
    all_rows: List[Dict[str, str]] = []
    csv_files = sorted(results_dir.glob(csv_glob))
    if not csv_files:
        raise FileNotFoundError(
            f"Nem talalhato CSV a mintara: {results_dir}/{csv_glob}"
        )

    for csv_file in csv_files:
        rows = load_csv_rows(csv_file)
        for row in rows:
            row_copy = dict(row)
            row_copy["_source_csv"] = str(csv_file)
            all_rows.append(row_copy)

    return all_rows


def pick_nearest_raw_file(raw_dir: Path, benchmark: str, ts: datetime) -> Path:
    candidates = sorted(raw_dir.glob(f"{benchmark}_*.log"))
    if not candidates:
        raise FileNotFoundError(f"Nincs matching RAW log ehhez: {benchmark}")

    def distance(candidate: Path) -> float:
        c_ts = parse_raw_filename_timestamp(candidate)
        return abs((c_ts - ts).total_seconds())

    return min(candidates, key=distance)


def resolve_raw_file(row: Dict[str, str], raw_dir: Path) -> Path:
    benchmark = row["benchmark"].strip()
    ts = parse_iso_utc(row["timestamp"].strip())
    raw_path_str = row.get("raw_output_file", "").strip().strip('"')

    if raw_path_str and raw_path_str.upper() != "N/A":
        candidate = Path(raw_path_str)
        if candidate.exists():
            return candidate

    return pick_nearest_raw_file(raw_dir, benchmark, ts)


def hardware_label_for_row(row: Dict[str, str]) -> str:
    benchmark = row["benchmark"].strip()
    cpu_model = row.get("cpu_model", "").strip().strip('"')
    gpu_model = row.get("gpu_model", "").strip().strip('"')

    if benchmark == "cpu_single_threaded":
        return cpu_model if cpu_model and cpu_model.upper() != "N/A" else "CPU"
    if benchmark == "cpu_multithreaded":
        return cpu_model if cpu_model and cpu_model.upper() != "N/A" else "CPU"

    if not gpu_model or gpu_model.upper() == "N/A":
        return ""
    if looks_like_cpu_description(gpu_model):
        return "NVIDIA GPU" if benchmark == "gpu_cuda" else "AMD GPU (ROCm)"
    return gpu_model


def build_points(csv_rows: List[Dict[str, str]], raw_dir: Path):
    points = []
    seen_measurements = set()

    sorted_rows = sorted(
        [r for r in csv_rows if r.get("benchmark", "").strip() in BENCHMARK_ORDER],
        key=lambda r: parse_iso_utc(r["timestamp"].strip()),
    )
    if not sorted_rows:
        raise ValueError("Nem talalhato feldolgozhato benchmark sor a CSV-kben.")

    for row in sorted_rows:
        benchmark = row["benchmark"].strip()
        raw_file = resolve_raw_file(row, raw_dir)
        dedupe_key = (benchmark, str(raw_file.resolve()))
        if dedupe_key in seen_measurements:
            continue

        label = hardware_label_for_row(row)
        if benchmark == "gpu_cuda" and not label:
            continue

        raw_text = raw_file.read_text(encoding="utf-8")
        calls, total_ms, avg_ms = parse_calls_and_times(raw_text)
        timestamp = row["timestamp"].strip().strip('"')

        seen_measurements.add(dedupe_key)

        points.append(
            {
                "benchmark": benchmark,
                "label": label,
                "timestamp": timestamp,
                "calls": calls,
                "total_ms": total_ms,
                "avg_ms": avg_ms,
                "source_csv": row.get("_source_csv", ""),
                "raw_file": str(raw_file),
            }
        )

    return points


def render_one_chart(points, metric: str, output_path: Path, title: str, dpi: int):
    labels = [p["label"] for p in points]
    values = [p["avg_ms"] if metric == "avg" else p["total_ms"] for p in points]
    colors = [BENCHMARK_COLOR[p["benchmark"]] for p in points]

    fig, ax = plt.subplots(figsize=(16, 8))
    x = list(range(len(points)))
    bars = ax.bar(x, values, color=colors)

    ylabel = "Végrehajtási idő [ms/hívás]" if metric == "avg" else "Végrehajtási idő [ms]"
    ax.set_title(title)
    ax.set_xlabel("Használt hardver")
    ax.set_ylabel(ylabel)
    ax.grid(axis="y", linestyle="--", alpha=0.35)
    ax.set_xticks(x)
    ax.set_xticklabels(labels, rotation=25, ha="right")

    max_y = max(values) if values else 1.0
    text_offset = max(max_y * 0.02, 1.0)
    for bar, v in zip(bars, values):
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            bar.get_height() + text_offset,
            f"{v:.3f}",
            ha="center",
            va="bottom",
            fontsize=10,
        )

    legend_handles = [
        plt.Line2D([0], [0], color=BENCHMARK_COLOR[b], lw=8)
        for b in BENCHMARK_ORDER
    ]
    legend_labels = [BENCHMARK_LABEL[b] for b in BENCHMARK_ORDER]
    ax.legend(legend_handles, legend_labels, title="Végrehajtás típusa", loc="upper right")

    fig.tight_layout()
    fig.savefig(output_path, dpi=dpi)
    plt.close(fig)


def main():
    parser = argparse.ArgumentParser(
        description="Diagram renderelese a results_combined*.csv + RAW log struktura alapjan."
    )
    parser.add_argument(
        "--results-dir",
        type=Path,
        required=True,
        help="A results mappa eleresi utja.",
    )
    parser.add_argument(
        "--csv-glob",
        type=str,
        default="results_combined*.csv",
        help="CSV minta a results mappan belul.",
    )
    parser.add_argument(
        "--raw-dir",
        type=Path,
        help="A results/raw mappa eleresi utja. Ha nincs megadva, a results-dir/raw lesz hasznalva.",
    )
    parser.add_argument(
        "--metric",
        choices=["avg", "total"],
        default="avg",
        help="A kirajzolt metrika: avg vagy total.",
    )
    parser.add_argument(
        "--output",
        type=Path,
        required=True,
        help="Kimeneti PNG fajl eleresi utja.",
    )
    parser.add_argument("--dpi", type=int, default=300)
    parser.add_argument(
        "--title",
        type=str,
        default="POM2K benchmark végrehajtási idő hardverenként",
    )

    args = parser.parse_args()

    raw_dir = args.raw_dir if args.raw_dir else args.results_dir / "raw"
    csv_rows = collect_rows_from_results(args.results_dir, args.csv_glob)
    points = build_points(csv_rows, raw_dir)
    render_one_chart(points, args.metric, args.output, args.title, args.dpi)

    print(f"Elkészült diagram: {args.output}")
    for p in points:
        print(
            f"{p['timestamp']} | {p['benchmark']}: calls={p['calls']}, "
            f"total_ms={p['total_ms']:.3f}, avg_ms={p['avg_ms']:.3f}, "
            f"csv={p['source_csv']}, raw={p['raw_file']}"
        )


if __name__ == "__main__":
    main()
