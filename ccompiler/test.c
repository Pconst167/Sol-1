#include <stdio.h>

int main() {
	long int i;
	i = 0xAABBCCDDL;

	printx32(i);


}

void print_unsigned_long2(unsigned long int num) {
  char *p;
  p = &num;


	printx8(*p);
	printx8(*(p+1));
	printx8(*(p-2));
	printx8(*(p-3));

}
