#include <stdio.h>
#include <stdint.h>
#include <chrono>

#define I32 uint32_t
#define INTREF i_32

struct i_32 {
  I32 data;
};

extern "C" i_32 just_power_of_two(struct i_32);

const uint32_t TEST_VEC_SIZE = 100000;

int main() {
  INTREF test_vec[TEST_VEC_SIZE] = {};
  for (uint32_t i = 0; i < TEST_VEC_SIZE; i++) {
    test_vec[i] = {i + 1};
  }

  auto start = std::chrono::high_resolution_clock::now();

  for (uint32_t i = 0; i < TEST_VEC_SIZE; i++) {
    auto res = just_power_of_two(test_vec[i]);
    printf("Result no.%u : %u\n", i + 1, res.data);
  }

  auto end = std::chrono::high_resolution_clock::now();

  auto duration_us =
      std::chrono::duration_cast<std::chrono::microseconds>(end - start);
  auto duration_ms =
      std::chrono::duration_cast<std::chrono::milliseconds>(end - start);

  printf("\nFull run time: %lld us\n", (long long)duration_us.count());
  printf("Full run time: %lld ms\n", (long long)duration_ms.count());

  return 0;
}