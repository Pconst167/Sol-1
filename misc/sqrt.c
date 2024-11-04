#include <stdio.h>

int main(){
  float f;
  float result;  
  unsigned int i;

  scanf("%f", &f);

  i = *(unsigned int *) &f;

  i += 127 << 23;
  i >>= 1;

  result = *(float *) &i;

  printf("\nResult: %f, %x\n", result, i);


}