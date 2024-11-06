#include <stdio.h>
#include <math.h>

int main(){
  float f;
  float a = -3.1415926;

  for(int i = 0; i < 10; i++){
    printf("\nSin of %9f rad: %9f, Approx: %9f", a, sin(a), a - a*a*a/6 + a*a*a*a*a/120 - a*a*a*a*a*a*a/5040);
    a = a + 2*M_PI/10;
  }
}