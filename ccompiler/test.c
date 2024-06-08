#include <stdio.h>

struct s1{
  char c;
  int i;
};

typedef struct s1 my_struct1[10][5];
typedef struct s1 my_struct2[20][6];

int main(){
  int aa;

  printf("Char: %c, String: %s, Integer: %d", 'A', "Paulo", 1);

}

