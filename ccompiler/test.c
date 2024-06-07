
int main(){

  myfunc(1, 2, 255, 65535, 127);

  return 0;

}

int myfunc(int a, int b, ...){
  int aa, bb, cc;
  int *p;

  p = &a;

  printu(*(p+2));
  puts("\n\r");
  printu(*(p+4));
  puts("\n\r");
  printu(*(p+6));

}


void printu(unsigned int num) {
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
    .include "lib/stdio.asm"
  }
}

void puts(char *s){
  asm{
    meta mov d, s
    mov a, [d]
    mov d, a
    call _puts
    mov a, $0A00
    syscall sys_io
  }
}