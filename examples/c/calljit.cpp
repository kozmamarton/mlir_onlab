#include <chrono>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>

#define N 12
#define F64 double
#define JIT _mlir_ciface_jit
#define MEMREF Memref3D

struct Memref3D {
  F64 *ptrToData;
  F64 *alignedPtrToData;
  int offset;
  long shape[3];
  long stride[3];
};

extern "C" void JIT(struct MEMREF *, struct MEMREF *);
int c(int x, int y, int z) { return z * N * N + y * N + x; }
int main() {

  F64 *x = new F64[N * N * N];
  F64 *y = new F64[N * N * N];

  struct MEMREF xMemref = {x, x, 0, {N, N, N}, {N, N, N}};
  struct MEMREF yMemref = {y, y, 0, {N, N, N}, {N, N, N}};

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      for (int k = 0; k < N; k++) {
        double val =
            i == 0 || j == 0 || k == 0 || i == N - 1 || j == N - 1 || k == N - 1
                ? 1.0
                : 0.0;
        x[c(i, j, k)] = val;
      }
    }
  }

  auto start = std::chrono::steady_clock::now();

  for (unsigned i = 0; i < 10000000; i++) {
    JIT(&xMemref, &yMemref);
  }

  auto end = std::chrono::steady_clock::now();

  auto elapsed_us =
    std::chrono::duration_cast<std::chrono::microseconds>(end - start);
  auto elapsed_ms = 
    std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
  std::printf("Time = %lld us or %lld ms\n ", static_cast<long long>(elapsed_us.count()),static_cast<long long>(elapsed_ms.count()) );

  // for (int i = 0; i < N * N * N; i++) {
  //   printf("%f\t", yMemref.ptrToData[i]);
  // }
  /*
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      for (int k = 0; k < N; k++) {
        printf("%f\t", xMemref.ptrToData[c(i, j, k)]);
      }
      printf("\n");
    }
    printf("\n");
  }*/
}

// clang++ -O3 calljit.cpp jit.ll -o result.out && ./result.out
