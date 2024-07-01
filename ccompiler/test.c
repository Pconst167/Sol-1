#include <stdio2.h>

#define def1 char

#define def2 char
// error: var_type is a char and is being pushed into printf as a one byte, but printf is printing 2 bytes and incrementing pointer by 2 hence error
void main(){
	120 + myfunc(1);
  printf("Hello");

  print_signed(123);


  strcpy("Hello", "World");


  strcat("Hi", "Hello");

  print_signed(555);
}


int myfunc(int a){

}