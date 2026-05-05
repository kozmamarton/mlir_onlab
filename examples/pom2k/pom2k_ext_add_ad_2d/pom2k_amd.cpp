#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <string>

extern "C" {
int im[1];
int jm[1];

void ext_add_ad_2d_(void *arg0, void *arg1, int64_t arg2, int64_t arg3,
                    int64_t arg4, void *arg5, void *arg6, int64_t arg7,
                    int64_t arg8, int64_t arg9, void *arg10, void *arg11,
                    int64_t arg12, int64_t arg13, int64_t arg14, void *arg15,
                    void *arg16, int64_t arg17, int64_t arg18, int64_t arg19);

void *mgpuStreamCreate();
void mgpuStreamDestroy(void *stream);
void mgpuStreamSynchronize(void *stream);
void *mgpuMemAlloc(uint64_t sizeBytes, void *stream, bool isHostShared);
void mgpuMemFree(void *ptr, void *stream);
void mgpuMemcpy(void *dst, void *src, size_t sizeBytes, void *stream);
}

struct ExtAddAd2DCallArgs {
  void *adx2d_alloc;
  void *adx2d_aligned;
  int64_t adx2d_offset;
  int64_t adx2d_size;
  int64_t adx2d_stride;

  void *ady2d_alloc;
  void *ady2d_aligned;
  int64_t ady2d_offset;
  int64_t ady2d_size;
  int64_t ady2d_stride;

  void *advua_alloc;
  void *advua_aligned;
  int64_t advua_offset;
  int64_t advua_size;
  int64_t advua_stride;

  void *advva_alloc;
  void *advva_aligned;
  int64_t advva_offset;
  int64_t advva_size;
  int64_t advva_stride;
};

struct DeviceBuffer {
  void *ptr = nullptr;
  size_t bytes = 0;
};

static void check_ptr(const void *ptr, const char *what) {
  if (!ptr) {
    throw std::runtime_error(std::string("Allocation failed: ") + what);
  }
}

static void print_first_10(const std::string &label, const float *data,
                           std::size_t size) {
  const std::size_t count = std::min<std::size_t>(10, size);
  std::cout << label << " [0.." << (count == 0 ? 0 : count - 1) << "]: ";
  for (std::size_t i = 0; i < count; ++i) {
    std::cout << std::fixed << std::setprecision(6) << data[i];
    if (i + 1 != count)
      std::cout << ", ";
  }
  std::cout << "\n";
}

int main() {
  constexpr int rows = 16978;
  constexpr int cols = 16978;
  constexpr int64_t numOfSamples = 10;
  const std::size_t n = static_cast<std::size_t>(rows) * static_cast<std::size_t>(cols);
  const std::size_t nbytes = n * sizeof(float);

  im[0] = rows;
  jm[0] = cols;

  void *stream = mgpuStreamCreate();
  check_ptr(stream, "mgpuStreamCreate");

  DeviceBuffer adx2d{mgpuMemAlloc(nbytes, stream, false), nbytes};
  DeviceBuffer ady2d{mgpuMemAlloc(nbytes, stream, false), nbytes};
  DeviceBuffer advua{mgpuMemAlloc(nbytes, stream, false), nbytes};
  DeviceBuffer advva{mgpuMemAlloc(nbytes, stream, false), nbytes};
  check_ptr(adx2d.ptr, "adx2d");
  check_ptr(ady2d.ptr, "ady2d");
  check_ptr(advua.ptr, "advua");
  check_ptr(advva.ptr, "advva");

  float *h_adx2d = new float[n];
  float *h_ady2d = new float[n];
  float *h_advua = new float[n];
  float *h_advva = new float[n];

  for (std::size_t idx = 0; idx < n; ++idx) {
    const float x = static_cast<float>(idx % cols);
    const float y = static_cast<float>(idx / cols);
    h_adx2d[idx] = 0.1f * x;
    h_ady2d[idx] = -0.2f * y;
    h_advua[idx] = std::sin(0.01f * static_cast<float>(idx));
    h_advva[idx] = std::cos(0.01f * static_cast<float>(idx));
  }

  mgpuMemcpy(adx2d.ptr, h_adx2d, nbytes, stream);
  mgpuMemcpy(ady2d.ptr, h_ady2d, nbytes, stream);
  mgpuMemcpy(advua.ptr, h_advua, nbytes, stream);
  mgpuMemcpy(advva.ptr, h_advva, nbytes, stream);
  mgpuStreamSynchronize(stream);

  std::cout << '\n';
  std::cout << "Input snapshots (first 10 values each) (of " << rows * cols << " total):\n";
  print_first_10("adx2d(before)", h_adx2d, n);
  print_first_10("ady2d(before)", h_ady2d, n);

  ExtAddAd2DCallArgs args{
      adx2d.ptr, adx2d.ptr, 0, static_cast<int64_t>(n), 1,
      ady2d.ptr, ady2d.ptr, 0, static_cast<int64_t>(n), 1,
      advua.ptr, advua.ptr, 0, static_cast<int64_t>(n), 1,
      advva.ptr, advva.ptr, 0, static_cast<int64_t>(n), 1,
  };
  int64_t elapsedUsTotal = 0;
  for (auto i = 0; i < numOfSamples; i++) {
    const auto start = std::chrono::high_resolution_clock::now();
    ext_add_ad_2d_(args.adx2d_alloc, args.adx2d_aligned, args.adx2d_offset, args.adx2d_size, args.adx2d_stride,
                   args.ady2d_alloc, args.ady2d_aligned, args.ady2d_offset, args.ady2d_size, args.ady2d_stride,
                   args.advua_alloc, args.advua_aligned, args.advua_offset, args.advua_size, args.advua_stride,
                   args.advva_alloc, args.advva_aligned, args.advva_offset, args.advva_size, args.advva_stride);
    mgpuStreamSynchronize(stream);
    const auto end = std::chrono::high_resolution_clock::now();
    elapsedUsTotal += std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
  }

  mgpuMemcpy(h_adx2d, adx2d.ptr, nbytes, stream);
  mgpuMemcpy(h_ady2d, ady2d.ptr, nbytes, stream);
  mgpuStreamSynchronize(stream);

  const auto elapsedMs = static_cast<double>(elapsedUsTotal) * 1e-3;
  const auto averageElapsedUs = elapsedUsTotal / numOfSamples;
  const auto averageElapsedMs = static_cast<double>(averageElapsedUs) * 1e-3;
  std::cout << '\n'
            << "Number of function calls initiated: " << numOfSamples
            << "\ngpu call time - amd:"
            << " total: " << elapsedUsTotal << " us (" << elapsedMs << " ms)"
            << " average: " << averageElapsedUs << " us (" << averageElapsedMs << " ms)\n\n";

  std::cout << "Output snapshots (same buffers after call, first 10 values each):\n";
  print_first_10("adx2d(after)", h_adx2d, n);
  print_first_10("ady2d(after)", h_ady2d, n);

  mgpuMemFree(adx2d.ptr, stream);
  mgpuMemFree(ady2d.ptr, stream);
  mgpuMemFree(advua.ptr, stream);
  mgpuMemFree(advva.ptr, stream);
  mgpuStreamDestroy(stream);

  delete[] h_adx2d;
  delete[] h_ady2d;
  delete[] h_advua;
  delete[] h_advva;

  return 0;
}
