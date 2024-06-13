#include <stdio.h>

int main() {
	long int i;
	char c;
	int j;

	i = 0xAABBCCDDL;
	c = 0xAE;
	j = 0x1234;

	printx32(0x1234);

	printf("Value: %lx", (char)i);

}