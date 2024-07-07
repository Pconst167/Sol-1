#include <stdio.h>

struct t_s{
  char c;
  int i;
  char *m;
};

struct t_s my_struct[10] = {
  {'a', 123, "hello"},
  {'b', 456, "world"}  
};

char mm[10]={'a','b','c'};

static void main(){


  printf("%c %d %s\n", my_struct[0].c, my_struct[0].i, my_struct[0].m);

  return;

  printf("%c %d %s\n", my_struct[1].c, my_struct[1].i, my_struct[1].m);
}


