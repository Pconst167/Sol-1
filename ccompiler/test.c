#include <stdio.h>

#define ARRAY_SIZE 2

enum e1_t {first, second, third, fourth, fifth};

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
  test_globalvars();
}

int test_globalvars(){
  char pass = 1;
  printf("testing global variables\n");
  printf("Set 'c0' to 'A'\n");
  c0 = 'A';
  printf("c0 value: %c", c0);
  printf(" (%s)", c0 == 'A' ? "pass\n" : "fail\n");
  pass = pass && c0 == 'A';
}