#include <stdio.h>

struct s1{
	int a[2];
	char c[33];
};

struct s2{
	char a[10];
	struct s1 ss[3];
	struct s1 sss[3];
	int b[3];
};

int main() {

	struct s2 s[5];

	s[0].a[0] = 'A';
	s[1].a[1] = 'B';
	s[2].ss[1].a[1] = 'Z';
	s[3].sss[1].c[2]='H';
	s[0].b[2]=123;

	printf("%c\n", s[0].a[0]);
	printf("%c\n", s[1].a[1]);
	printf("%c\n", s[2].ss[1].a[1]);
	printf("%c\n", s[3].sss[1].c[2]);
	printf("%d\n", s[0].b[2]);

}

