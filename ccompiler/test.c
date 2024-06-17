#include <stdio.h>

struct t_structTest3{
  char c;
  int i;
  int m[5];
} st1;

void main(){
  int pass[10];
  int i;
  int nbr_tests = 10;
  for(i = 0; i < nbr_tests; i++){
    pass[i] = -1;
  }

  for(i = 0; i < nbr_tests; i++){
    printf("Test %d, Result: %u\n", i, pass[i]);
  }
}
