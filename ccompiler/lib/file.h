struct FILE {
    int fd;            // file descriptor for the open file
    unsigned char *buf;// pointer to buffer for I/O operations
    unsigned int bufsize;    // size of buffer
    unsigned int bufpos;     // position of next character in buffer
    int mode;          // file mode (read, write, append, etc.)
    int error;         // error flag
};

int loadfile(char *filename, char *destination){
  asm{
    addr mov d, destination
    mov a, [d]
    mov di, a
    addr mov d, filename
    mov d, [d]
    mov al, 20
    syscall sys_filesystem
  }
}

int create_file(char *filename, char *content){
}

int delete_file(char *filename){
  asm{
    addr mov d, filename
    mov al, 10
    syscall sys_filesystem
  }
}

struct FILE *fopen(char *filename, char *mode){

}

void fclose(struct FILE *fp){
  
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