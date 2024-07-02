#include <stdio2.h>

struct bytes{
  char lsb;
  char msb;
};

union u_t{
  struct bytes bytes;
  int i;
};

union u_t u;


void main(){

  u.bytes.lsb = 0xCD;
  u.bytes.msb = 0xAB;

  printf("\nc1: %x, c2: %x\n", u.bytes.msb, u.bytes.lsb);
  printf("\ninteger val: %x\n", u.i);


  return;
}

