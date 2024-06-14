//#include <stdio.h>

struct list{
	char name[100];
	int number;
	struct list *prev;
	struct list *next;
};

struct list l[10];
struct list *p;



int main() {
	static long int aa;

	aa=1;




	return;

	//printf("Next: %x\n", *p->next);
/*
	strcpy(l[0].name, "First Item");
	strcpy(l[1].name, "Second Item");
	strcpy(l[2].name, "Third Item");
	strcpy(l[3].name, "Fourth Item");

	l[0].number = 0;
	l[1].number = 1;
	l[2].number = 2;
	l[3].number = 3;

	l[0].prev = NULL;
	l[1].prev = &l[0];
	l[2].prev = &l[1];
	l[3].prev = &l[2];

	l[0].next = &l[1];
	l[1].next = &l[2];
	l[2].next = &l[3];
	l[3].next = NULL;


	printf("List %d, Name: %s, Current: %x, Prev: %x, Next: %x\n", p->number, p->name, p, p->prev, p->next);
	p = p->next;
	printf("List %d, Name: %s, Current: %x, Prev: %x, Next: %x\n", p->number, p->name, p, p->prev, p->next);
	p = p->next;
	printf("List %d, Name: %s, Current: %x, Prev: %x, Next: %x\n", p->number, p->name, p, p->prev, p->next);
	p = p->next;
	printf("List %d, Name: %s, Current: %x, Prev: %x, Next: %x\n", p->number, p->name, p, p->prev, p->next);
	*/
}