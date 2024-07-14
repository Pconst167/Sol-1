#include <stdio.h>

char *string;

void main(){
  unsigned long int i = 0;

  for(i=0; i < 4294967295; i++){
    printx32(i);
    puts("");
  }
}

