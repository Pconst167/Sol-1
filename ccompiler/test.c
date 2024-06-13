#include <stdio.h>

struct s{
	char c;
	int a;
	char *sp;
	struct{
		char cc;
		int aa;
	} s2;
};

int main() {
	long int i;
	char c;
	int j;

	i = 0xAABBCCDDL;
	c = 0xAE;
	j = 0x1234;

	//printx32(0x12345678);

	struct s ms;

	ms.c = 'A';
	ms.a = 65535;
	ms.sp = &ms;
	ms.s2.cc = 'Z';
	ms.s2.aa = 32765;


	printf("Value: %c\n", ms.c);
	printf("Value: %d\n", ms.a);
	printf("Value: %x\n", ms.sp);
	printf("Value: %c\n", ms.s2.cc);
	printf("Value: %d\n", ms.s2.aa);

}