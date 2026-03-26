#include <chrono>
#include <cstdint>
#include <cuda_runtime.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>

#define N 102
#define F64 double
#define JIT _mlir_ciface_jit

struct Memref3D {
  F64 *allocated;
  F64 *aligned;
  int64_t offset;
  int64_t sizes[3];
  int64_t strides[3];
};

extern "C" void JIT(Memref3D *, Memref3D *);

int main() {
  F64 *x1 = new F64[N * N * N];
  F64 *y1 = new F64[N * N * N];

  F64 *x = nullptr;
  F64 *y = nullptr;

  cudaMalloc((void **)&x, N * N * N * sizeof(F64));
  cudaMalloc((void **)&y, N * N * N * sizeof(F64));

  Memref3D xMemref = {x, x, 0, {N, N, N}, {N * N, N, 1}};

  Memref3D yMemref = {y, y, 0, {N, N, N}, {N * N, N, 1}};

  for (int i = 0; i < N * N * N; i++) {
    x1[i] = static_cast<double>(i % 5);
  }

  cudaMemcpy(x, x1, N * N * N * sizeof(F64), cudaMemcpyHostToDevice);

  auto start = std::chrono::high_resolution_clock::now();

  JIT(&xMemref, &yMemref);
  cudaDeviceSynchronize();

  auto end = std::chrono::high_resolution_clock::now();
  auto elapsed =
      std::chrono::duration_cast<std::chrono::milliseconds>(end - start);

  printf("Time = %lld ms\n", static_cast<long long>(elapsed.count()));

  cudaMemcpy(y1, y, N * N * N * sizeof(F64), cudaMemcpyDeviceToHost);

  for (int i = 0; i < N * N * N; i++) {
    printf("%f\t", y1[i]);
  }

  cudaFree(x);
  cudaFree(y);
  delete[] x1;
  delete[] y1;

  return 0;
}
// nvcc -c -I/usr/local/cuda-11.2/include cudajit.cu -arch=sm_60 -o cudajit.o

// clang++ cudajit.cpp cudajit.ll -o result.out && ./result.out
// nvcc cudakernel.o cudajit.o wrapper.o -lcuda  $(llvm-config --ldflags --libs)
// -ltinfo