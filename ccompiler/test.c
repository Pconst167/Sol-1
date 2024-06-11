
int main() {

	printf("Value: %ld", 4294967257L);


}
void printf(char *format, ...){
  char *p, *fp;
  int i;

  fp = format;
  p = &format + 2;

// printf("%i %d %d", 124, 1234, 65535);
  for(;;){
    if(!*fp) break;
    else if(*fp == '%'){
      fp++;
      switch(*fp){
        case 'l':
        case 'L':
          fp++;
          if(*fp == 'd' || *fp == 'i'){
            print_signed_long(*(long *)p);
            p = p + 4;
          }
          else if(*fp == 'u'){
            print_unsigned_long(*(unsigned long *)p);
            p = p + 4;
          }
          break;

        default:
      }
      fp++;
    }
    else {
      putchar(*fp);
      fp++;
    }
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


void print_signed_long(int num) {
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

void print_unsigned_long(unsigned int num) {
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

void print_unsigned(unsigned int num) {
  char digits[5];
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