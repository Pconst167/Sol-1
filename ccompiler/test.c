
int main() {

	print_signed_long(4294967257L);


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


void print_signed_long(long int num) {
  char digits[10];
  int i = 0;

  if (num < 0) {
    putchar('-');
    num = -num;
  }
  else if (num == 0) {
    putchar('0');
    return;
  }

  while (num > 0) {
    digits[i] = '0' + (num % 10);
    num = num / 10;
    i++;
  }

  while (i > 0) {
    i--;
    putchar(digits[i]);
  }
}

void print_unsigned_long(unsigned long int num) {
  char digits[10];
  int i;
  i = 0;
  if(num == 0){
    putchar('0');
    return;
  }
  while (num > 0) {
    digits[i] = '0' + (num % 10);
    num = num / 10;
    i++;
  }
  // Print the digits in reverse order using putchar()
  while (i > 0) {
    i--;
    putchar(digits[i]);
  }
}
