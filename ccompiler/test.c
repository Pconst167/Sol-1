#include <stdio.h>

int main(){

  myfunc(1, 2, 'a', 255, 65535, 'b');

  return 0;

}

int myfunc(int a, int b, ...){

}


  //printf("Int : %d, %i, %u, %x\n", 0xFFFF, 65535, 0xFFFF, 65535);
  //printf("Char: %c, %c, %c, %c, %c, %c\n", 'a', 'b', 'c', 'd', 'e', 'f');
  //printf("Str : %s, %s\n\n", "Hello World this is a string.", "String 2!");


/*
// Define the type for a list of arguments
typedef struct {
    char *stack_pointer;
} va_list;

// Initialize the va_list variable to point to the first variable argument
#define va_start(ap, last) (ap = (va_list){.stack_pointer = (char *)&(last) + sizeof(last)})

// Access the next argument and typecast to the expected type, 
// increment the stack_pointer based on the size of the type
#define va_arg(ap, type) (*(type *)((ap.stack_pointer += sizeof(type)) - sizeof(type)))

// Clean up the list
#define va_end(ap) (ap = (va_list){.stack_pointer = NULL})

*/


