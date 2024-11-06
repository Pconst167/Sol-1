#include <stdio.h>
#include <math.h>

int main(){
  float f = 0.0;

/*
  for(int i = 0; i < 100; i++){
    printf("\nExp of %9f: %9f, Approx: %9f", f, exp(f), 1 + f + f*f/2 + f*f*f/6 + f*f*f*f/24 + f*f*f*f*f/120 + f*f*f*f*f*f/720 + f*f*f*f*f*f*f/5040);
    f = f + 0.1;
  }

  */

  for(int i = 0; i < 100; i++){
    printf("\nExp of %9f: %9f, Approx: %9f", f, exp(f), pow(1+ f/2000, 2000));
    f = f + 0.1;
  }


}