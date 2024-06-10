
int main() {
	int a = 555, b = 444;
	char c = 'H';

	prin(a, b);
	putchar(c);
	//gcd(100, 10);

    return 0;
}

void prin(int a, int b){
	printu(a);
	printu(b);
}


int gcd(int a, int b) {
    if (b == 0) {
        return a;
    }
    return gcd(b, a % b);
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
