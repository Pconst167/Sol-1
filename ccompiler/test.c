#include <stdio.h>

void main(void){

	long int i, j;


	i = 0x0F0F0F0F;
	j = 0x01010101;

	printx32(i-j);
}
