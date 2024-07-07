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

static void main(){

  printf("%c %d %s\n", 'H', 123, "hello");
}


