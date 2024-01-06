
<html>
<title>Sol-1 74 Series Logic Homebrew CPU - 2.5MHz</title>
	
<head>
<meta name="keywords" content="homebrew cpu,homebuilt cpu,ttl,alu,homebuilt computer,homebrew computer,74181,Sol-1, Sol, electronics, hardware, engineering, programming, assembly, cpu, logic">
<link rel="icon" href="http://sol-1.org/images/2.jpg">	

<style>

    table a,
table a:visited,
table a:active {
    color: rgb(250,250,250) !important;
}
table a:hover{
  color:white !important;
}
</style>
</head>

<body>


<?php
	include("menu.php");
?>

</br>

<table width="1000">
<tr><td>
<pre>
<b>stdio.h:</b>

#include <string.h>

#define NULL 0

struct va_list{
  char *p; // pointer to current argument

};
struct FILE {
    int fd;            // file descriptor for the open file
    unsigned char *buf;// pointer to buffer for I/O operations
    unsigned int bufsize;    // size of buffer
    unsigned int bufpos;     // position of next character in buffer
    int mode;          // file mode (read, write, append, etc.)
    int error;         // error flag
};

inline int va_arg(struct va_list *arg, int size){
  int val;
  if(size == 1){
    val = *(char*)arg->p;
  }
  else if(size == 2){
    val = *(int*)arg->p;
  }
  else{
    print("Unknown type size in va_arg() call. Size needs to be either 1 or 2.");
  }
  arg->p = arg->p + size;
  return val;
}

void printf(char *format, ...){
  char *p;
  char *fp;
  int i;
  fp = format;
  p = &format;

  for(;;){
    if(!*fp) break;
    if(*fp == '%'){
      fp++;
      switch(*fp){
        case 'd':
        case 'i':
          p = p - 2;
          prints(*(int*)p);
          break;

        case 'u':
          p = p - 2;
          printu(*(unsigned int*)p);
          break;

        case 'x':
          p = p - 2;
          printx16(*(unsigned int*)p);
          break;

        case 'c':
          p = p - 2;
          putchar(*(char*)p);
          break;

        case 's':
          p = p - 2;
          print(*(char**)p);
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

void include_stdio_asm(){
  asm{
    .include "lib/stdio.asm"
  }
}
<hr>
</pre>
</td></tr>

<tr><td>
<pre>
string.h:

void strcpy(char *dest, char *src) {
  char *psrc;
  char *pdest;
  psrc = src;
  pdest = dest;

  while(*psrc) *pdest++ = *psrc++;
  *pdest = '\0';
}

int strcmp(char *s1, char *s2) {
  while (*s1 && (*s1 == *s2)) {
    s1++;
    s2++;
  }
  return *s1 - *s2;
}

char *strcat(char *dest, char *src) {
    int dest_len;
    int i;
    dest_len = strlen(dest);
    
    for (i = 0; src[i] != 0; i=i+1) {
        dest[dest_len + i] = src[i];
    }
    dest[dest_len + i] = 0;
    
    return dest;
}

int strlen(char *str) {
    int length;
    length = 0;
    
    while (str[length] != 0) {
        length++;
    }
    
    return length;
}
<hr>
</pre>
</td></tr>
<tr><td>
<pre>
ctype.h:

void include_ctype_lib(){
  asm{
    .include "lib/ctype.asm"
  }
}

char is_space(char c){
  return c == ' ' || c == '\t' || c == '\n' || c == '\r';
}

char is_digit(char c){
  return c >= '0' && c <= '9';
}

char is_alpha(char c){
  return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_');
}

char is_delimiter(char c){
  if(
    c == '@' ||
    c == '#' ||
    c == '$' ||
    c == '+' ||
    c == '-' ||
    c == '*' ||
    c == '/' ||
    c == '%' ||
    c == '[' ||
    c == ']' ||
    c == '(' ||
    c == ')' ||
    c == '{' ||
    c == '}' ||
    c == ':' ||
    c == ';' ||
    c == '<' ||
    c == '>' ||
    c == '=' ||
    c == '!' ||
    c == '^' ||
    c == '&' ||
    c == '|' ||
    c == '~' ||
    c == '.'
  ) 
    return 1;
  else 
    return 0;
}
</pre>
<hr>
</td></tr>

<tr><td>
<pre>
token.h:

#include "lib/ctype.h"
#include "lib/stdio.h"

enum t_token{
  TOK_UNDEF, PLUS, MINUS, STAR, FSLASH, INCREMENT, DECREMENT, MOD,
  EQUAL, NOT_EQUAL, LESS_THAN, LESS_THAN_OR_EQUAL, GREATER_THAN, GREATER_THAN_OR_EQUAL,
  LOGICAL_AND, LOGICAL_OR, LOGICAL_NOT,
  ASSIGNMENT, DOLLAR, CARET, AT, HASH,
  AMPERSAND, BITWISE_XOR, BITWISE_OR, BITWISE_NOT, BITWISE_SHL, BITWISE_SHR,
  OPENING_PAREN, CLOSING_PAREN,
  OPENING_BRACE, CLOSING_BRACE,
  OPENING_BRACKET, CLOSING_BRACKET,
  COLON, SEMICOLON, COMMA, DOT
};

enum t_token_type{
  TYPE_UNDEF, DELIMITER,
  CHAR_CONST, STRING_CONST, INTEGER_CONST,
  IDENTIFIER, END
};


int tok;
int toktype;
char *prog;
char token[256];
char string_const[256];

void back(void){
  char *t;
  t = token;

  while(*t++) prog--;
  tok = TOK_UNDEF;
  toktype = TYPE_UNDEF;
  token[0] = '\0';
}

void get_path(){
  char *t;
  *token = '\0';
  t = token;
  
/* Skip whitespaces */
  while(is_space(*prog)) prog++;
  if(*prog == '\0'){
    return;
  }
  while(
    (*prog >= 'a' && *prog <= 'z') ||
    (*prog >= 'A' && *prog <= 'Z') ||
    (*prog >= '0' && *prog <= '9') ||
    *prog == '/' || 
    *prog == '_' ||
    *prog == '-' ||
    *prog == '.'
  ){
    *t++ = *prog++;
  }
  *t = '\0';
}

void get(){
  char *t;
  // skip blank spaces

  *token = '\0';
  tok = 0;
  toktype = 0;
  t = token;
  
/* Skip whitespaces */
  while(is_space(*prog)) prog++;

  if(*prog == '\0'){
    toktype = END;
    return;
  }
  
  if(is_digit(*prog)){
    while(is_digit(*prog)){
      *t++ = *prog++;
    }
    *t = '\0';
    toktype = INTEGER_CONST;
    return; // return to avoid *t = '\0' line at the end of function
  }
  else if(is_alpha(*prog)){
    while(is_alpha(*prog) || is_digit(*prog)){
      *t++ = *prog++;
    }
    *t = '\0';
    toktype = IDENTIFIER;
  }
  else if(*prog == '\"'){
    *t++ = '\"';
    prog++;
    while(*prog != '\"' && *prog){
      *t++ = *prog++;
    }
    if(*prog != '\"') error("Double quotes expected");
    *t++ = '\"';
    prog++;
    toktype = STRING_CONST;
    *t = '\0';
    convert_constant(); // converts this string token qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
  }
  else if(*prog == '#'){
    *t++ = *prog++;
    tok = HASH;
    toktype = DELIMITER;  
  }
  else if(*prog == '{'){
    *t++ = *prog++;
    tok = OPENING_BRACE;
    toktype = DELIMITER;  
  }
  else if(*prog == '}'){
    *t++ = *prog++;
    tok = CLOSING_BRACE;
    toktype = DELIMITER;  
  }
  else if(*prog == '['){
    *t++ = *prog++;
    tok = OPENING_BRACKET;
    toktype = DELIMITER;  
  }
  else if(*prog == ']'){
    *t++ = *prog++;
    tok = CLOSING_BRACKET;
    toktype = DELIMITER;  
  }
  else if(*prog == '='){
    *t++ = *prog++;
    if (*prog == '='){
      *t++ = *prog++;
      tok = EQUAL;
    }
    else 
      tok = ASSIGNMENT;
    toktype = DELIMITER;  
  }
  else if(*prog == '&'){
    *t++ = *prog++;
    if(*prog == '&'){
      *t++ = *prog++;
      tok = LOGICAL_AND;
    }
    else
      tok = AMPERSAND;
    toktype = DELIMITER;  
  }
  else if(*prog == '|'){
    *t++ = *prog++;
    if (*prog == '|'){
      *t++ = *prog++;
      tok = LOGICAL_OR;
    }
    else 
      tok = BITWISE_OR;
    toktype = DELIMITER;  
  }
  else if(*prog == '~'){
    *t++ = *prog++;
    tok = BITWISE_NOT;
    toktype = DELIMITER;  
  }
  else if(*prog == '<'){
    *t++ = *prog++;
    if (*prog == '='){
      *t++ = *prog++;
      tok = LESS_THAN_OR_EQUAL;
    }
    else if (*prog == '<'){
      *t++ = *prog++;
      tok = BITWISE_SHL;
    }
    else
      tok = LESS_THAN;
    toktype = DELIMITER;  
  }
  else if(*prog == '>'){
    *t++ = *prog++;
    if (*prog == '='){
      *t++ = *prog++;
      tok = GREATER_THAN_OR_EQUAL;
    }
    else if (*prog == '>'){
      *t++ = *prog++;
      tok = BITWISE_SHR;
    }
    else 
      tok = GREATER_THAN;
    toktype = DELIMITER;  
  }
  else if(*prog == '!'){
    *t++ = *prog++;
    if(*prog == '='){
      *t++ = *prog++;
      tok = NOT_EQUAL;
    }
    else 
      tok = LOGICAL_NOT;
    toktype = DELIMITER;  
  }
  else if(*prog == '+'){
    *t++ = *prog++;
    if(*prog == '+'){
      *t++ = *prog++;
      tok = INCREMENT;
    }
    else 
      tok = PLUS;
    toktype = DELIMITER;  
  }
  else if(*prog == '-'){
    *t++ = *prog++;
    if(*prog == '-'){
      *t++ = *prog++;
      tok = DECREMENT;
    }
    else 
      tok = MINUS;
    toktype = DELIMITER;  
  }
  else if(*prog == '$'){
    *t++ = *prog++;
    tok = DOLLAR;
    toktype = DELIMITER;  
  }
  else if(*prog == '^'){
    *t++ = *prog++;
    tok = BITWISE_XOR;
    toktype = DELIMITER;  
  }
  else if(*prog == '@'){
    *t++ = *prog++;
    tok = AT;
    toktype = DELIMITER;  
  }
  else if(*prog == '*'){
    *t++ = *prog++;
    tok = STAR;
    toktype = DELIMITER;  
  }
  else if(*prog == '/'){
    *t++ = *prog++;
    tok = FSLASH;
    toktype = DELIMITER;  
  }
  else if(*prog == '%'){
    *t++ = *prog++;
    tok = MOD;
    toktype = DELIMITER;  
  }
  else if(*prog == '('){
    *t++ = *prog++;
    tok = OPENING_PAREN;
    toktype = DELIMITER;  
  }
  else if(*prog == ')'){
    *t++ = *prog++;
    tok = CLOSING_PAREN;
    toktype = DELIMITER;  
  }
  else if(*prog == ';'){
    *t++ = *prog++;
    tok = SEMICOLON;
    toktype = DELIMITER;  
  }
  else if(*prog == ':'){
    *t++ = *prog++;
    tok = COLON;
    toktype = DELIMITER;  
  }
  else if(*prog == ','){
    *t++ = *prog++;
    tok = COMMA;
    toktype = DELIMITER;  
  }
  else if(*prog == '.'){
    *t++ = *prog++;
    tok = DOT;
    toktype = DELIMITER;  
  }

  *t = '\0';
}

// converts a literal string or char constant into constants with true escape sequences
void convert_constant(){
  char *s;
  char *t;
  
  t = token;
  s = string_const;
  if(toktype == CHAR_CONST){
    t++;
    if(*t == '\\'){
      t++;
      switch(*t){
        case '0':
          *s++ = '\0';
          break;
        case 'a':
          *s++ = '\a';
          break;
        case 'b':
          *s++ = '\b';
          break;  
        case 'f':
          *s++ = '\f';
          break;
        case 'n':
          *s++ = '\n';
          break;
        case 'r':
          *s++ = '\r';
          break;
        case 't':
          *s++ = '\t';
          break;
        case 'v':
          *s++ = '\v';
          break;
        case '\\':
          *s++ = '\\';
          break;
        case '\'':
          *s++ = '\'';
          break;
        case '\"':
          *s++ = '\"';
      }
    }
    else{
      *s++ = *t;
    }
  }
  else if(toktype == STRING_CONST){
    t++;
    while(*t != '\"' && *t){
      *s++ = *t++;
    }
  }
  
  *s = '\0';
}

void error(char *msg){
  printf("\nError: ");
  printf(msg);
  printf("\n");

}
</pre>
<hr>
</td></tr>


<tr><td>
<pre>
system.h:

int file_exists(char *filename){
  int file_exists;
  asm{
    @filename
    mov d, [d]
    mov al, 21
    syscall sys_filesystem
    @file_exists
    mov [d], a
  }
  return file_exists;
}

void cd_to_dir(char *dir){
  int dirID;
  asm{
    @dir
    mov d, [d]
    mov al, 19
    syscall sys_filesystem ; get dirID in 'A'
    @dirID
    mov d, [d]
    mov [d], a ; set dirID
  }
  if(dirID != -1){
    asm{
      mov b, a
      mov al, 3
      syscall sys_filesystem
    }
  }
}

void print_cwd(){
  asm{
    mov al, 18
    syscall sys_filesystem        ; print current directory
  }
}

int spawn_new_proc(char *executable_path, char *args){
  asm{
    @args
    mov b, [d]
    @executable_path
    mov d, [d]
    syscall sys_spawn_proc
  }
}
</pre>
<hr>
</td></tr>
</table>

<?php include("footer.php"); ?>
</body>
</html>

