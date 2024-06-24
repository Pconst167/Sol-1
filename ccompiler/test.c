#include <stdio.h>

char s[256];

void main(void){

	sprintf(s, "Integer: %d, Char: %c, String: %s\n\n",  2341, 'G', "Hello World!");

	printf("Final String: %s", s);

}