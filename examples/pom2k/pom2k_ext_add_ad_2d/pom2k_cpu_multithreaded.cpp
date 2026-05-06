#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>


extern "C" {
// The lowered function reads these globals to determine launch grid sizes.
int im[1];
int jm[1];

void ext_add_ad_2d_(void* arg0, void* arg1, int64_t arg2, int64_t arg3, int64_t arg4,
                                        void* arg5, void* arg6, int64_t arg7, int64_t arg8, int64_t arg9,
                                        void* arg10, void* arg11, int64_t arg12, int64_t arg13, int64_t arg14,
                                        void* arg15, void* arg16, int64_t arg17, int64_t arg18, int64_t arg19);
}

struct ExtAddAd2DCallArgs {
    void* adx2d_alloc;
    void* adx2d_aligned;
    int64_t adx2d_offset;
    int64_t adx2d_size;
    int64_t adx2d_stride;

    void* ady2d_alloc;
    void* ady2d_aligned;
    int64_t ady2d_offset;
    int64_t ady2d_size;
    int64_t ady2d_stride;

    void* advua_alloc;
    void* advua_aligned;
    int64_t advua_offset;
    int64_t advua_size;
    int64_t advua_stride;

    void* advva_alloc;
    void* advva_aligned;
    int64_t advva_offset;
    int64_t advva_size;
    int64_t advva_stride;
};


void print_first_10(const std::string& label, const float* values,
                    std::size_t size) {
  const std::size_t count = std::min<std::size_t>(10, size);
  std::cout << label << " [0.." << (count == 0 ? 0 : count - 1) << "]: ";
  for (std::size_t index = 0; index < count; ++index) {
    std::cout << std::fixed << std::setprecision(6) << values[index];
    if (index + 1 != count) {
      std::cout << ", ";
    }
  }
  std::cout << "\n";
}

int main() {
  constexpr int rows = 16978;
  constexpr int cols = 16978;
  constexpr int64_t numOfSamples = 10;

  im[0] = rows;
  jm[0] = cols;

  const std::size_t elementCount =
      static_cast<std::size_t>(im[0]) * static_cast<std::size_t>(jm[0]);

  float* adx2d = new float[elementCount];
  float* ady2d = new float[elementCount];
  float* advua = new float[elementCount];
  float* advva = new float[elementCount];

  for (std::size_t index = 0; index < elementCount; ++index) {
    const float x = static_cast<float>(index % static_cast<std::size_t>(im[0]));
    const float y = static_cast<float>(index / static_cast<std::size_t>(im[0]));
    adx2d[index] = 0.1f * x;
    ady2d[index] = -0.2f * y;
    advua[index] = std::sin(0.01f * static_cast<float>(index));
    advva[index] = std::cos(0.01f * static_cast<float>(index));
  }

  std::cout << '\n';
  std::cout << "Input snapshots (first 10 values each) (of " << rows * cols << " total):\n";
  print_first_10("adx2d(before)", adx2d, elementCount);
  print_first_10("ady2d(before)", ady2d, elementCount);
 // print_first_10("advua(before)", advua, elementCount);
 // print_first_10("advva(before)", advva, elementCount);
  ExtAddAd2DCallArgs args{
      adx2d, adx2d, 0, static_cast<int64_t>(elementCount), 1,
      ady2d, ady2d, 0, static_cast<int64_t>(elementCount), 1,
      advua, advua, 0, static_cast<int64_t>(elementCount), 1,
      advva, advva, 0, static_cast<int64_t>(elementCount), 1,
  };
  int64_t elapsedUsTotal = 0;
  for (auto i = 0; i < numOfSamples; i++) {
    const auto start = std::chrono::high_resolution_clock::now();
    ext_add_ad_2d_(args.adx2d_alloc, args.adx2d_aligned, args.adx2d_offset, args.adx2d_size,
                   args.adx2d_stride, args.ady2d_alloc, args.ady2d_aligned,
                   args.ady2d_offset, args.ady2d_size, args.ady2d_stride,
                   args.advua_alloc, args.advua_aligned, args.advua_offset,
                   args.advua_size, args.advua_stride, args.advva_alloc,
                   args.advva_aligned, args.advva_offset, args.advva_size,
                   args.advva_stride);
    const auto end = std::chrono::high_resolution_clock::now();
    elapsedUsTotal += std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
  }

  const auto elapsedMs = static_cast<double>(elapsedUsTotal) * 1e-3;
  const auto averageElapsedUs = elapsedUsTotal / numOfSamples;
  const auto averageElapsedMs = static_cast<double>(averageElapsedUs) * 1e-3;
  std::cout << '\n'
            << "Number of function calls initiated: " << numOfSamples
            << "\ncpu call time - multithreaded:"
            << " total: " << elapsedUsTotal << " us (" << elapsedMs << " ms)"
            << " average: " << averageElapsedUs << "us (" << averageElapsedMs << " ms)\n\n";

  std::cout << "Output snapshots (same buffers after call, first 10 values each):\n";
  print_first_10("adx2d(after)", adx2d, elementCount);
  print_first_10("ady2d(after)", ady2d, elementCount);
 // print_first_10("advua(after)", advua, elementCount);
 // print_first_10("advva(after)", advva, elementCount);

  delete[] adx2d;
  delete[] ady2d;
  delete[] advua;
  delete[] advva;

  return 0;
}