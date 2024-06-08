#include <string.h>

#define NULL 0

struct FILE {
    int fd;            // file descriptor for the open file
    unsigned char *buf;// pointer to buffer for I/O operations
    unsigned int bufsize;    // size of buffer
    unsigned int bufpos;     // position of next character in buffer
    int mode;          // file mode (read, write, append, etc.)
    int error;         // error flag
};
/*
struct va_list_t{
  char *current_arg; // pointer to current argument
};

void va_start(struct va_list_t *argp, char *first_fixed_param){
  argp->current_arg = first_fixed_param + sizeof(first_fixed_param);
}

char *va_arg(struct va_list_t *argp, unsigned int size) {
  char *p;
  p = argp->current_arg;
  argp->current_arg = argp->current_arg + size;
  return p;
}

void va_end(struct va_list_t *argp) {
  argp->current_arg = NULL;
}
*/

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

        case 'x':
          printx16(*(unsigned int*)p);
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

void printx16(int hex) {
  asm{
    meta mov d, hex
    mov b, [d]
    call print_u16x
  }
}
void printx8(char hex) {
  asm{
    meta mov d, hex
    mov bl, [d]
    call print_u8x
  }
}

int hex_to_int(char *hex_string) {
  int value = 0;
  int i;
  char hex_char;
  int len;

  len = strlen(hex_string);
  for (i = 0; i < len; i++) {
    hex_char = hex_string[i];
    if (hex_char >= 'a' && hex_char <= 'f') 
      value = (value * 16) + (hex_char - 'a' + 10);
    else if (hex_char >= 'A' && hex_char <= 'F') 
      value = (value * 16) + (hex_char - 'A' + 10);
    else 
      value = (value * 16) + (hex_char - '0');
  }
  return value;
}

int atoi(char *str) {
    int result = 0;  // Initialize result
    int sign = 1;    // Initialize sign as positive

    // Skip leading whitespaces
    while (*str == ' ') str++;

    // Check for optional sign
    if (*str == '-' || *str == '+') {
        if (*str == '-') sign = -1;
        str++;
    }

    // Loop through all digits of input string
    while (*str >= '0' && *str <= '9') {
        result = result * 10 + (*str - '0');
        str++;
    }

    return sign * result;
}

int gets(char *s){
  asm{
    meta mov d, s
    mov a, [d]
    mov d, a
    call _gets
  }
  return strlen(s);
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

char rand(){
  char sec;
  asm{
      mov al, 0
      syscall sys_rtc					; get seconds
      mov al, ah
      meta mov d, sec
      mov al, [d]
  }
  return sec;
}

void date(){
  asm{
    mov al, 0 ; print datetime
    syscall sys_datetime
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

char getchar(){
  char c;
  asm{
    call getch
    mov al, ah
    meta mov d, c
    mov [d], al
  }
  return c;
}

int scann(){
  int m;
  asm{
    call scan_u16d
    meta mov d, m
    mov [d], a
  }
  
  return m;
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

void print(char *s){
  asm{
    meta mov d, s
    mov d, [d]
    call _puts
  }
}

int loadfile(char *filename, char *destination){
  asm{
    meta mov d, destination
    mov a, [d]
    mov di, a
    meta mov d, filename
    mov d, [d]
    mov al, 20
    syscall sys_filesystem
  }
}


int create_file(char *filename, char *content){
}

int delete_file(char *filename){
  asm{
    meta mov d, filename
    mov al, 10
    syscall sys_filesystem
  }
}

struct FILE *fopen(char *filename, char *mode){

}

void fclose(struct FILE *fp){
  
}

// heap and heap_top are defined internally by the compiler
// so that 'heap' is the last variable in memory and therefore can grow upwards
// towards the stack
char *alloc(int bytes){
  heap_top = heap_top + bytes;
  return heap_top - bytes;
}

char *free(int bytes){
  return heap_top = heap_top - bytes;
}

void exit(){
  asm{
    syscall sys_terminate_proc
  }
}

void load_hex(char *destination){
  char *temp;
  
  temp = alloc(32768);

  asm{
    ; ************************************************************
    ; GET HEX FILE
    ; di = destination address
    ; return length in bytes in C
    ; ************************************************************
    _load_hex:
      push a
      push b
      push d
      push si
      push di
      sub sp, $8000      ; string data block
      mov c, 0
      mov a, sp
      inc a
      mov d, a          ; start of string data block
      call _gets        ; get program string
      mov si, a
    __load_hex_loop:
      lodsb             ; load from [SI] to AL
      cmp al, 0         ; check if ASCII 0
      jz __load_hex_ret
      mov bh, al
      lodsb
      mov bl, al
      call _atoi        ; convert ASCII byte in B to int (to AL)
      stosb             ; store AL to [DI]
      inc c
      jmp __load_hex_loop
    __load_hex_ret:
      add sp, $8000
      pop di
      pop si
      pop d
      pop b
      pop a
  }
}

unsigned char getparam(char *address){
  char data;

  asm{
    mov al, 4
    meta mov d, address
    mov d, [d]
    syscall sys_system
    meta mov d, data
    mov [d], bl
  }
  return data;
}

void clear(){
  print("\033[2J\033[H");
}

void printun(char *prompt, int n){
  print(prompt);
  printu(n);
  print("\n");
}

void printsn(char *prompt, int n){
  print(prompt);
  prints(n);
  print("\n");
}

void include_stdio_asm(){
  asm{
    .include "lib/stdio.asm"
  }
}

