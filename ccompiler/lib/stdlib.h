
#define	EXIT_FAILURE	1	/* Failing exit status.  */
#define	EXIT_SUCCESS	0	/* Successful exit status.  */

/* The largest number rand will return (same as INT_MAX).  */
#define	RAND_MAX	2147483647

char *base64_table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

void exit(){
  asm{
    syscall sys_terminate_proc
  }
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
      addr mov d, sec
      mov al, [d]
      mov ah, 0
  }
  return sec;
}

/* Seed the random number generator with the given number.  */
void srand (unsigned int seed){

}

/* Allocate SIZE bytes of memory.  */
void *malloc (size_t size){

}

/* Allocate NMEMB elements of SIZE bytes each, all initialized to 0.  */
void *calloc (size_t nmemb, size_t size){

}

/* Re-allocate the previously allocated block
   in PTR, making the new block SIZE bytes long.  */
void *realloc (void *ptr, size_t size){

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

void base64_encode(char *input, char *output) {
  int i = 0;
  int j = 0;
  int k;
  int input_len;
  unsigned char input_buffer[3];
  unsigned char output_buffer[4];
  input_len = strlen(input);

  while (input_len--) {
    input_buffer[i++] = *(input++);
    if (i == 3) {
      output_buffer[0] = (input_buffer[0] & 0xFC) >> 2;
      output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4);
      output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6);
      output_buffer[3] = input_buffer[2] & 0x3F;

      for (i = 0; i < 4; i++) {
        output[j++] = base64_table[output_buffer[i]];
      }
      i = 0;
    }
  }

  if (i) {
    for (k = i; k < 3; k++) {
      input_buffer[k] = '\0';
    }

    output_buffer[0] = (input_buffer[0] & 0xFC) >> 2;
    output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4);
    output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6);

    for (k = 0; k < i + 1; k++) {
      output[j++] = base64_table[output_buffer[k]];
    }

    while (i++ < 3) {
      output[j++] = '=';
    }
  }
  output[j] = '\0';
}

int base64_char_value(char c) {
  if (c >= 'A' && c <= 'Z') return c - 'A';
  if (c >= 'a' && c <= 'z') return c - 'a' + 26;
  if (c >= '0' && c <= '9') return c - '0' + 52;
  if (c == '+') return 62;
  if (c == '/') return 63;
  return -1;
}

void base64_decode(char *input, char *output) {
  int i = 0, j = 0, k = 0;
  int input_len;
  unsigned char input_buffer[4];
  unsigned char output_buffer[3];

  input_len = strlen(input);

  while (input_len-- && (input[k] != '=') && base64_char_value(input[k]) != -1) {
    input_buffer[i++] = input[k++];
    if (i == 4) {
      for (i = 0; i < 4; i++) {
        input_buffer[i] = base64_char_value(input_buffer[i]);
      }

      output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4);
      output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2);
      output_buffer[2] = ((input_buffer[2] & 0x03) << 6) + input_buffer[3];

      for (i = 0; i < 3; i++) {
        output[j++] = output_buffer[i];
      }
      i = 0;
    }
  }

  if (i) {
    for (k = i; k < 4; k++) {
      input_buffer[k] = 0;
    }

    for (k = 0; k < 4; k++) {
      input_buffer[k] = base64_char_value(input_buffer[k]);
    }

    output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4);
    output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2);

    for (k = 0; k < i - 1; k++) {
      output[j++] = output_buffer[k];
    }
  }
  output[j] = '\0';
}
