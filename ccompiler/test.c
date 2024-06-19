#include <stdio.h>

#define ARRAY_SIZE 2

char c0;
int i0;

char     c_array0[ARRAY_SIZE];
int      i_array0[ARRAY_SIZE];
char   *cp_array0[ARRAY_SIZE];
int    *ip_array0[ARRAY_SIZE];
char **cpp_array0[ARRAY_SIZE];
int  **ipp_array0[ARRAY_SIZE];

char     cc_array0[ARRAY_SIZE][ARRAY_SIZE];
int      ii_array0[ARRAY_SIZE][ARRAY_SIZE];
char   *ccp_array0[ARRAY_SIZE][ARRAY_SIZE];
int    *iip_array0[ARRAY_SIZE][ARRAY_SIZE];
char **ccpp_array0[ARRAY_SIZE][ARRAY_SIZE];
int  **iipp_array0[ARRAY_SIZE][ARRAY_SIZE];

struct st0_t{
  char c;
  int i;

  char     c_array0[ARRAY_SIZE];
  int      i_array0[ARRAY_SIZE];
  char   *cp_array0[ARRAY_SIZE];
  int    *ip_array0[ARRAY_SIZE];
  char **cpp_array0[ARRAY_SIZE];
  int  **ipp_array0[ARRAY_SIZE];

  char     cc_array0[ARRAY_SIZE][ARRAY_SIZE];
  int      ii_array0[ARRAY_SIZE][ARRAY_SIZE];
  char   *ccp_array0[ARRAY_SIZE][ARRAY_SIZE];
  int    *iip_array0[ARRAY_SIZE][ARRAY_SIZE];
  char **ccpp_array0[ARRAY_SIZE][ARRAY_SIZE];
  int  **iipp_array0[ARRAY_SIZE][ARRAY_SIZE];
} st0;

void main(){
  long int a, b;

  a = 0xF0000000;
  b = 1;
  printf("Result: %d\n", a || b);
  printf("Result: %d\n", a && b);
}
