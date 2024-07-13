#include <stdio.h>

char *string;

void main(){
  int pass = 1;
  int expression = 1;

  pass = pass && expression ? 1 : 0;

  printf("result: %s\n", pass ? "passed" : "failed");
}

