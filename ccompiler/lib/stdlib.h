
#define	EXIT_FAILURE	1	/* Failing exit status.  */
#define	EXIT_SUCCESS	0	/* Successful exit status.  */

/* The largest number rand will return (same as INT_MAX).  */
#define	RAND_MAX	2147483647
#define EOF -1

void exit(){
  asm{
    syscall sys_terminate_proc
  }
}

void *memset(char *s, char c, int size){
  int i;
  for(i = 0; i < size; i++){
    *(s+i) = c;
  }
  return s;
}

int atoi(char *str) {
    int result = 0;  // Initialize result
    int sign = 1;    // Initialize sign as positive

    // Skip leading whitespaces
    while (*str == ' ') str++;

    // Check for optional sign
    if (*str == '-' || *str == '+') {
        if (*str == '-') sign = -1;
        str++;
    }

    // Loop through all digits of input string
    while (*str >= '0' && *str <= '9') {
        result = result * 10 + (*str - '0');
        str++;
    }

    return sign * result;
}


/* Return a random integer between 0 and RAND_MAX inclusive.  */
int rand(){
  int  sec;
  asm{
      mov al, 0
      syscall sys_rtc					; get seconds
      mov al, ah
      ccmovd sec
      mov al, [d]
      mov ah, 0
  }
  return sec;
}



// heap and heap_top are defined internally by the compiler
// so that 'heap' is the last variable in memory and therefore can grow upwards
// towards the stack
char *alloc(int bytes){
  heap_top = heap_top + bytes;
  return heap_top - bytes;
}

/* Free a block allocated by `malloc', `realloc' or `calloc'.  */
char *free(int bytes){
  return heap_top = heap_top - bytes;
}

