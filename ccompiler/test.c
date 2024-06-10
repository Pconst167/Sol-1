#include <stdio.h>


void main(void){
	char *s = "hello World";
	char *p;

	p = func(s);

	printf(p);

	return 0;
}

char *func(char m[]){
	printf(m);
	return m;
}