#include <stdio.h>

#define I32 __uint32_t
#define INTREF i_32

struct i_32{
  I32 data;
};

extern "C" i_32 just_power_of_two(struct i_32);

const unsigned int TEST_VEC_SIZE = 100;
int main(){

  INTREF test_vec[TEST_VEC_SIZE] = {};
  for(unsigned int i = 0; i<TEST_VEC_SIZE;i++){
    test_vec[i] = {i+1};
  }

  //printf("%a",test_vec);

  for(int i = 0; i<TEST_VEC_SIZE;i++){
    auto res = just_power_of_two(test_vec[i]);
    printf("Result no.%u : %u\n",i+1,res.data);
  }
  return 0;
}


