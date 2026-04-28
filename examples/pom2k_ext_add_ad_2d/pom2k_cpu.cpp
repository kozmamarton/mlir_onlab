#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>

namespace
{

  int im = 0;
  int jm = 0;

  inline std::size_t acc2(int i, int j)
  {
    return static_cast<std::size_t>(j) * static_cast<std::size_t>(im) +
           static_cast<std::size_t>(i);
  }

  void ext_add_ad_2d_(float *adx2d, float *ady2d, const float *advua,
                      const float *advva)
  {
    for (int j = 0; j < jm; ++j)
    {
      for (int i = 0; i < im; ++i)
      {
        const std::size_t index = acc2(i, j);
        adx2d[index] -= advua[index];
        ady2d[index] -= advva[index];
      }
    }
  }

  void print_first_10(const std::string &label, const float *values,
                      std::size_t size)
  {
    const std::size_t count = std::min<std::size_t>(10, size);
    std::cout << label << " [0.." << (count == 0 ? 0 : count - 1) << "]: ";
    for (std::size_t index = 0; index < count; ++index)
    {
      std::cout << std::fixed << std::setprecision(6) << values[index];
      if (index + 1 != count)
      {
        std::cout << ", ";
      }
    }
    std::cout << "\n";
  }

} // namespace

constexpr int rows = 16978;
constexpr int cols = 16978;
constexpr int64_t numOfSamples = 10;

int main()
{

  im = rows;
  jm = cols;

  const std::size_t elementCount =
      static_cast<std::size_t>(im) * static_cast<std::size_t>(jm);

  float *adx2d = new float[elementCount];
  float *ady2d = new float[elementCount];
  float *advua = new float[elementCount];
  float *advva = new float[elementCount];

  for (std::size_t index = 0; index < elementCount; ++index)
  {
    const float x = static_cast<float>(index % static_cast<std::size_t>(im));
    const float y = static_cast<float>(index / static_cast<std::size_t>(im));
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

  int64_t elapsedUsTotal = 0;

  for (auto i = 0; i < numOfSamples; i++)
  {
    const auto start = std::chrono::high_resolution_clock::now();
    ext_add_ad_2d_(adx2d, ady2d, advua, advva);
    const auto end = std::chrono::high_resolution_clock::now();
    elapsedUsTotal += std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
  }

  const auto elapsedMs = static_cast<double>(elapsedUsTotal) * 1e-3;
  const auto averageElapsedUs = elapsedUsTotal / numOfSamples;
  const auto averageElapsedMs = static_cast<double>(averageElapsedUs) * 1e-3;
  std::cout << '\n'
            << "Number of function calls initiated: " << numOfSamples
            << "\ncpu call time: " << " total: " << elapsedUsTotal << " us (" << elapsedMs << " ms)"
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
