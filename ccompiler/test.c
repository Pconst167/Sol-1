
int main(){

  printf("Hello: %c %d %s", 'A', 64, "Paulo");  

  return 0;

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
        case 'd':
        case 'i':
          prints(*(int*)p);
          p = p + 2;
          break;

        case 'u':
          printu(*(unsigned int*)p);
          p = p + 2;
          break;

        case 'c':
          putchar(*(char*)p);
          p = p + 2;
          break;

        case 's':
          print(*(char**)p);
          p = p + 2;
          break;

        default:
          print("Error: Unknown argument type.\n");
      }
      fp++;
    }
    else {
      putchar(*fp);
      fp++;
    }
  }
}

void prints(int num) {
  char digits[5];
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
void print(char *s){
  asm{
    meta mov d, s
    mov d, [d]
    call _puts
  }
}
void include_stdio_asm(){
  asm{
    .include "lib/stdio.asm"
  }
}