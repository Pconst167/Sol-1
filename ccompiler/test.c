#include<stdio.h>

char s1[256];

void main(void){

	sprintf(s1, "Integer: %d, Char: %c, String: %s\n\n",  2341, 'G', "Hello World!");

	printf(s1);
}