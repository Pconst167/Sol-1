#include <stdio.h>

struct s{
  char c;
  int i;
};

static void main(){
  struct s mys;

  mys.c = 0;
  printf("%d\n", mys.c);

  mys.c++;
  printf("%d\n", mys.c);

  mys.c = 0;
  printf("%d\n", mys.c);

  mys.c = mys.c + 1;
  mys.c = mys.c + 1;
  mys.c = mys.c + 1;
  mys.c = mys.c + 1;

  printf("%d\n", mys.c);



}


