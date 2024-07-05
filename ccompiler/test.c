#include <stdio.h>
#include <ctype.h>

void main(){
  int i, j;

  struct _FILE fp;


  for(i=0;i<30;i++){
    for(j=0;j<80;j++){
      putchar('#');

    }
    putchar('\n');
  }
}
