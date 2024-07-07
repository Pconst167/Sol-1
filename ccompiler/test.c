#include <stdio.h>

static char m[10] = {1, 2, 3, {1, 2, 3}, 1, {1, 2, 3}};

static void main(){
  static char m2[10] = {1, 2, 3, {1, 2, 3}, 1, {1, 2, 3}};

  m2[1];

}


