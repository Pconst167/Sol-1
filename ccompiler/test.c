#include <stdio.h>

int main() {

	print_unsigned_long(42672124L);


}

void print_unsigned_long(unsigned long int num) {
  char *p;
  p = &num;


	printx8(*p);
	printx8(*(p+1));
	printx8(*(p+2));
	printx8(*(p+3));

}

void printx8(char hex) {
  asm{
    meta mov d, hex
    mov bl, [d]
    call print_u8x
  }
}
void printx16(int hex) {
  asm{
    meta mov d, hex
    mov b, [d]
    call print_u16x
  }
}

void putchar(char c){
  asm{
    meta mov d, c
    mov al, [d]
    mov ah, al
    call _putchar
  }
}

void include_stdio_asm(){
  asm{
    .include "lib/asm/stdio.asm"
  }
}

