; --- FILENAME: programs/wireworld.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int i; 
  sub sp, 2
; grid[5][5] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $5
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $5
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; grid[6][5] = ELECTRON_HEAD; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $6
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $5
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 2; ELECTRON_HEAD
  pop d
  mov [d], b
; grid[7][5] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $7
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $5
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; grid[6][6] = ELECTRON_TAIL; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $6
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $6
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 3; ELECTRON_TAIL
  pop d
  mov [d], b
; grid[6][7] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $6
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $7
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; grid[5][10] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $5
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $a
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; grid[6][10] = ELECTRON_HEAD; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $6
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $a
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 2; ELECTRON_HEAD
  pop d
  mov [d], b
; grid[7][10] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $7
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $a
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; grid[6][11] = ELECTRON_TAIL; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $6
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $b
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 3; ELECTRON_TAIL
  pop d
  mov [d], b
; grid[6][12] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $6
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $c
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; for (i = 8; i <= 14; i++) { 
_for1_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $8
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $e
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
; grid[7][i] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $7
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
_for1_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for1_cond
_for1_exit:
; grid[7][15] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $7
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $f
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; grid[6][15] = ELECTRON_TAIL; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $6
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $f
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 3; ELECTRON_TAIL
  pop d
  mov [d], b
; grid[8][15] = ELECTRON_TAIL; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $8
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $f
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 3; ELECTRON_TAIL
  pop d
  mov [d], b
; grid[6][16] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $6
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $10
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; grid[8][16] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $8
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov b, $10
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; for (i = 17; i <= 25; i++) { 
_for2_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $11
  pop d
  mov [d], b
_for2_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $19
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for2_exit
_for2_block:
; grid[7][i] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov b, $7
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
_for2_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for2_cond
_for2_exit:
; while (1) { 
_while3_cond:
  mov b, $1
  cmp b, 0
  je _while3_exit
_while3_block:
; print_grid(); 
  call print_grid
; iterate(); 
  call iterate
  jmp _while3_cond
_while3_exit:
; return 0; 
  mov b, $0
  leave
  syscall sys_terminate_proc

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; char *psrc; 
  sub sp, 2
; char *pdest; 
  sub sp, 2
; psrc = src; 
  lea d, [bp + -1] ; $psrc
  push d
  lea d, [bp + 7] ; $src
  mov b, [d]
  pop d
  mov [d], b
; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  pop d
  mov [d], b
; while(*psrc) *pdest++ = *psrc++; 
_while4_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while4_exit
_while4_block:
; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  dec b
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while4_cond
_while4_exit:
; *pdest = '\0'; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

strcmp:
  enter 0 ; (push bp; mov bp, sp)
; while (*s1 && (*s1 == *s2)) { 
_while5_cond:
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while5_exit
_while5_block:
; s1++; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $s1
  mov [d], b
  dec b
; s2++; 
  lea d, [bp + 7] ; $s2
  mov b, [d]
  inc b
  lea d, [bp + 7] ; $s2
  mov [d], b
  dec b
  jmp _while5_cond
_while5_exit:
; return *s1 - *s2; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  leave
  ret

strncmp:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

strcat:
  enter 0 ; (push bp; mov bp, sp)
; int dest_len; 
  sub sp, 2
; int i; 
  sub sp, 2
; dest_len = strlen(dest); 
  lea d, [bp + -1] ; $dest_len
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
; for (i = 0; src[i] != 0; i=i+1) { 
_for6_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for6_cond:
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for6_exit
_for6_block:
; dest[dest_len + i] = src[i]; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for6_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _for6_cond
_for6_exit:
; dest[dest_len + i] = 0; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
; return dest; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; int length; 
  sub sp, 2
; length = 0; 
  lea d, [bp + -1] ; $length
  push d
  mov b, $0
  pop d
  mov [d], b
; while (str[length] != 0) { 
_while7_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $length
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while7_exit
_while7_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  dec b
  jmp _while7_cond
_while7_exit:
; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  syscall sys_terminate_proc
; --- END INLINE ASM SEGMENT

  leave
  ret

memset:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < size; i++){ 
_for8_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for8_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 8] ; $size
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for8_exit
_for8_block:
; *(s+i) = c; 
  lea d, [bp + 5] ; $s
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  push b
  lea d, [bp + 7] ; $c
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for8_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for8_cond
_for8_exit:
; return s; 
  lea d, [bp + 5] ; $s
  mov b, [d]
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
; int result = 0;  // Initialize result 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $result
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int sign = 1;    // Initialize sign as positive 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; while (*str == ' ') str++; 
_while9_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while9_exit
_while9_block:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while9_cond
_while9_exit:
; if (*str == '-' || *str == '+') { 
_if10_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if10_exit
_if10_true:
; if (*str == '-') sign = -1; 
_if11_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if11_exit
_if11_true:
; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
  jmp _if11_exit
_if11_exit:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _if10_exit
_if10_exit:
; while (*str >= '0' && *str <= '9') { 
_while12_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while12_exit
_while12_block:
; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while12_cond
_while12_exit:
; return sign * result; 
  lea d, [bp + -3] ; $sign
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -1] ; $result
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  leave
  ret

rand:
  enter 0 ; (push bp; mov bp, sp)
; int  sec; 
  sub sp, 2

; --- BEGIN INLINE ASM SEGMENT
  mov al, 0
  syscall sys_rtc					
  mov al, ah
  lea d, [bp + -1] ; $sec
  mov al, [d]
  mov ah, 0
; --- END INLINE ASM SEGMENT

; return sec; 
  lea d, [bp + -1] ; $sec
  mov b, [d]
  leave
  ret

alloc:
  enter 0 ; (push bp; mov bp, sp)
; heap_top = heap_top + bytes; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; return heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  leave
  ret

free:
  enter 0 ; (push bp; mov bp, sp)
; return heap_top = heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  leave
  ret

fopen:
  enter 0 ; (push bp; mov bp, sp)
; FILE *fp; 
  sub sp, 2
; fp = alloc(sizeof(int)); 
  lea d, [bp + -1] ; $fp
  push d
  mov b, 2
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b
  leave
  ret

printf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 2
  sub sp, 2
; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  pop d
  mov [d], b
; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for13_init:
_for13_cond:
_for13_block:
; if(!*format_p) break; 
_if14_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if14_else
_if14_true:
; break; 
  jmp _for13_exit ; for break
  jmp _if14_exit
_if14_else:
; if(*format_p == '%'){ 
_if15_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if15_else
_if15_true:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch16_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch16_comparisons:
  cmp bl, $6c
  je _switch16_case0
  cmp bl, $4c
  je _switch16_case1
  cmp bl, $64
  je _switch16_case2
  cmp bl, $69
  je _switch16_case3
  cmp bl, $75
  je _switch16_case4
  cmp bl, $78
  je _switch16_case5
  cmp bl, $63
  je _switch16_case6
  cmp bl, $73
  je _switch16_case7
  jmp _switch16_default
  jmp _switch16_exit
_switch16_case0:
_switch16_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if17_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $69
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if17_else
_if17_true:
; print_signed_long(*(long *)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  snex b
  mov c, b
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call print_signed_long
  add sp, 4
  jmp _if17_exit
_if17_else:
; if(*format_p == 'u') 
_if18_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $75
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if18_else
_if18_true:
; print_unsigned_long(*(unsigned long *)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov bh, 0
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call print_unsigned_long
  add sp, 4
  jmp _if18_exit
_if18_else:
; if(*format_p == 'x') 
_if19_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $78
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_else
_if19_true:
; printx32(*(long int *)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call printx32
  add sp, 4
  jmp _if19_exit
_if19_else:
; err("Unexpected format in printf."); 
  mov b, _s0 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if19_exit:
_if18_exit:
_if17_exit:
; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $4
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch16_exit ; case break
_switch16_case2:
_switch16_case3:
; print_signed(*(int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print_signed
  add sp, 2
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch16_exit ; case break
_switch16_case4:
; print_unsigned(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print_unsigned
  add sp, 2
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch16_exit ; case break
_switch16_case5:

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov b, [d]
  call print_u16x
; --- END INLINE ASM SEGMENT

; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch16_exit ; case break
_switch16_case6:

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM SEGMENT

; p = p + 1; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch16_exit ; case break
_switch16_case7:

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov d, [d]
  call _puts
; --- END INLINE ASM SEGMENT

; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch16_exit ; case break
_switch16_default:
; print("Error: Unknown argument type.\n"); 
  mov b, _s1 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch16_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if15_exit
_if15_else:
; putchar(*format_p); 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_if15_exit:
_if14_exit:
_for13_update:
  jmp _for13_cond
_for13_exit:
  leave
  ret

scanf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 2
  sub sp, 2
; char c; 
  sub sp, 1
; int i; 
  sub sp, 2
; char input_string[  512                    ]; 
  sub sp, 512
; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  pop d
  mov [d], b
; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for20_init:
_for20_cond:
_for20_block:
; if(!*format_p) break; 
_if21_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if21_else
_if21_true:
; break; 
  jmp _for20_exit ; for break
  jmp _if21_exit
_if21_else:
; if(*format_p == '%'){ 
_if22_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if22_else
_if22_true:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch23_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch23_comparisons:
  cmp bl, $6c
  je _switch23_case0
  cmp bl, $4c
  je _switch23_case1
  cmp bl, $64
  je _switch23_case2
  cmp bl, $69
  je _switch23_case3
  cmp bl, $75
  je _switch23_case4
  cmp bl, $78
  je _switch23_case5
  cmp bl, $63
  je _switch23_case6
  cmp bl, $73
  je _switch23_case7
  jmp _switch23_default
  jmp _switch23_exit
_switch23_case0:
_switch23_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i'); 
_if24_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $69
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if24_else
_if24_true:
; ; 
  jmp _if24_exit
_if24_else:
; if(*format_p == 'u'); 
_if25_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $75
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if25_else
_if25_true:
; ; 
  jmp _if25_exit
_if25_else:
; if(*format_p == 'x'); 
_if26_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $78
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if26_else
_if26_true:
; ; 
  jmp _if26_exit
_if26_else:
; err("Unexpected format in printf."); 
  mov b, _s0 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if26_exit:
_if25_exit:
_if24_exit:
; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $4
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch23_exit ; case break
_switch23_case2:
_switch23_case3:
; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
  call scann
  pop d
  mov [d], b
; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  mov [d], b
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch23_exit ; case break
_switch23_case4:
; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
  call scann
  pop d
  mov [d], b
; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  mov [d], b
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch23_exit ; case break
_switch23_case5:
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch23_exit ; case break
_switch23_case6:
; c = getchar(); 
  lea d, [bp + -4] ; $c
  push d
  call getchar
  pop d
  mov [d], bl
; **(char **)p = *(char *)c; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -4] ; $c
  mov bl, [d]
  mov bh, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], b
; p = p + 1; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch23_exit ; case break
_switch23_case7:
; gets(input_string); 
  lea d, [bp + -518] ; $input_string
  mov b, d
  swp b
  push b
  call gets
  add sp, 2
; strcpy(*(char **)p, input_string); 
  lea d, [bp + -518] ; $input_string
  mov b, d
  swp b
  push b
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call strcpy
  add sp, 4
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch23_exit ; case break
_switch23_default:
; print("Error: Unknown argument type.\n"); 
  mov b, _s1 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch23_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if22_exit
_if22_else:
; putchar(*format_p); 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_if22_exit:
_if21_exit:
_for20_update:
  jmp _for20_cond
_for20_exit:
  leave
  ret

sprintf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 2
  sub sp, 2
; char *sp; 
  sub sp, 2
; sp = dest; 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  pop d
  mov [d], b
; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 7] ; $format
  mov b, [d]
  pop d
  mov [d], b
; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 7] ; $format
  mov b, d
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for27_init:
_for27_cond:
_for27_block:
; if(!*format_p) break; 
_if28_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if28_else
_if28_true:
; break; 
  jmp _for27_exit ; for break
  jmp _if28_exit
_if28_else:
; if(*format_p == '%'){ 
_if29_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if29_else
_if29_true:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch30_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch30_comparisons:
  cmp bl, $6c
  je _switch30_case0
  cmp bl, $4c
  je _switch30_case1
  cmp bl, $64
  je _switch30_case2
  cmp bl, $69
  je _switch30_case3
  cmp bl, $75
  je _switch30_case4
  cmp bl, $78
  je _switch30_case5
  cmp bl, $63
  je _switch30_case6
  cmp bl, $73
  je _switch30_case7
  jmp _switch30_default
  jmp _switch30_exit
_switch30_case0:
_switch30_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if31_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $69
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if31_else
_if31_true:
; print_signed_long(*(long *)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  snex b
  mov c, b
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call print_signed_long
  add sp, 4
  jmp _if31_exit
_if31_else:
; if(*format_p == 'u') 
_if32_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $75
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if32_else
_if32_true:
; print_unsigned_long(*(unsigned long *)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov bh, 0
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call print_unsigned_long
  add sp, 4
  jmp _if32_exit
_if32_else:
; if(*format_p == 'x') 
_if33_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $78
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if33_else
_if33_true:
; printx32(*(long int *)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call printx32
  add sp, 4
  jmp _if33_exit
_if33_else:
; err("Unexpected format in printf."); 
  mov b, _s0 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if33_exit:
_if32_exit:
_if31_exit:
; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $4
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch30_exit ; case break
_switch30_case2:
_switch30_case3:
; sp = sp + sprint_signed(sp, *(int*)p); 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + -5] ; $sp
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $sp
  mov b, [d]
  swp b
  push b
  call sprint_signed
  add sp, 4
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch30_exit ; case break
_switch30_case4:
; sp = sp + sprint_unsigned(sp, *(unsigned int*)p); 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + -5] ; $sp
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $sp
  mov b, [d]
  swp b
  push b
  call sprint_unsigned
  add sp, 4
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch30_exit ; case break
_switch30_case5:

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov b, [d]
  call print_u16x
; --- END INLINE ASM SEGMENT

; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch30_exit ; case break
_switch30_case6:
; *sp++ = *(char *)p; 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  inc b
  lea d, [bp + -5] ; $sp
  mov [d], b
  dec b
  push b
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; p = p + 1; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch30_exit ; case break
_switch30_case7:
; int len = strlen(*(char **)p); 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -7] ; $len
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; strcpy(sp, *(char **)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $sp
  mov b, [d]
  swp b
  push b
  call strcpy
  add sp, 4
; sp = sp + len; 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + -5] ; $sp
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $len
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch30_exit ; case break
_switch30_default:
; print("Error: Unknown argument type.\n"); 
  mov b, _s1 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch30_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if29_exit
_if29_else:
; *sp++ = *format_p++; 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  inc b
  lea d, [bp + -5] ; $sp
  mov [d], b
  dec b
  push b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_if29_exit:
_if28_exit:
_for27_update:
  jmp _for27_cond
_for27_exit:
; *sp = '\0'; 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
; return sp - dest; // return total number of chars written 
  lea d, [bp + -5] ; $sp
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $dest
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  leave
  ret

err:
  enter 0 ; (push bp; mov bp, sp)
; print(e); 
  lea d, [bp + 5] ; $e
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

printx32:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d+2]
  call print_u16x
  mov b, [d]
  call print_u16x
; --- END INLINE ASM SEGMENT

  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d]
  call print_u16x
; --- END INLINE ASM SEGMENT

  leave
  ret

printx8:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov bl, [d]
  call print_u8x
; --- END INLINE ASM SEGMENT

  leave
  ret

hex_str_to_int:
  enter 0 ; (push bp; mov bp, sp)
; int value = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $value
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i; 
  sub sp, 2
; char hex_char; 
  sub sp, 1
; int len; 
  sub sp, 2
; len = strlen(hex_string); 
  lea d, [bp + -6] ; $len
  push d
  lea d, [bp + 5] ; $hex_string
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
; for (i = 0; i < len; i++) { 
_for34_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for34_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for34_exit
_for34_block:
; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
  lea d, [bp + 5] ; $hex_string
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; if (hex_char >= 'a' && hex_char <= 'f')  
_if35_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $66
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if35_else
_if35_true:
; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, a
  mov a, b
  mov b, $a
  add b, a
  pop a
; --- END TERMS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if35_exit
_if35_else:
; if (hex_char >= 'A' && hex_char <= 'F')  
_if36_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $46
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if36_else
_if36_true:
; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, a
  mov a, b
  mov b, $a
  add b, a
  pop a
; --- END TERMS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if36_exit
_if36_else:
; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_if36_exit:
_if35_exit:
_for34_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  dec b
  jmp _for34_cond
_for34_exit:
; return value; 
  lea d, [bp + -1] ; $value
  mov b, [d]
  leave
  ret

gets:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _gets
; --- END INLINE ASM SEGMENT

; return strlen(s); 
  lea d, [bp + 5] ; $s
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  leave
  ret

print_signed:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if37_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if37_else
_if37_true:
; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  neg b
  pop d
  mov [d], b
  jmp _if37_exit
_if37_else:
; if (num == 0) { 
_if38_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if38_exit
_if38_true:
; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
; return; 
  leave
  ret
  jmp _if38_exit
_if38_exit:
_if37_exit:
; while (num > 0) { 
_while39_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while39_exit
_while39_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  dec b
  jmp _while39_cond
_while39_exit:
; while (i > 0) { 
_while40_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while40_exit
_while40_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while40_cond
_while40_exit:
  leave
  ret

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10]; 
  sub sp, 10
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if41_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  mov c, 0
  cmp32 ga, cb
  slt ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if41_else
_if41_true:
; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  neg b
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if41_exit
_if41_else:
; if (num == 0) { 
_if42_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  mov c, 0
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if42_exit
_if42_true:
; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
; return; 
  leave
  ret
  jmp _if42_exit
_if42_exit:
_if41_exit:
; while (num > 0) { 
_while43_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  mov c, 0
  sgt
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while43_exit
_while43_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add a, b
  push a
  mov a, g
  mov b, c
  adc a, b
  mov c, a
  pop b
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  dec b
  jmp _while43_cond
_while43_exit:
; while (i > 0) { 
_while44_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while44_exit
_while44_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  inc b
; putchar(digits[i]); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while44_cond
_while44_exit:
  leave
  ret

print_unsigned_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10]; 
  sub sp, 10
; int i; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -11] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
; if(num == 0){ 
_if45_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  mov c, 0
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if45_exit
_if45_true:
; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
; return; 
  leave
  ret
  jmp _if45_exit
_if45_exit:
; while (num > 0) { 
_while46_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  mov c, 0
  sgu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while46_exit
_while46_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add a, b
  push a
  mov a, g
  mov b, c
  adc a, b
  mov c, a
  pop b
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  dec b
  jmp _while46_cond
_while46_exit:
; while (i > 0) { 
_while47_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while47_exit
_while47_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  inc b
; putchar(digits[i]); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while47_cond
_while47_exit:
  leave
  ret

sprint_unsigned:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i; 
  sub sp, 2
; int len = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -8] ; $len
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
; if(num == 0){ 
_if48_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if48_exit
_if48_true:
; *dest++ = '0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  mov b, $30
  pop d
  mov [d], bl
; return 1; 
  mov b, $1
  leave
  ret
  jmp _if48_exit
_if48_exit:
; while (num > 0) { 
_while49_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while49_exit
_while49_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $num
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 7] ; $num
  push d
  lea d, [bp + 7] ; $num
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  dec b
  jmp _while49_cond
_while49_exit:
; while (i > 0) { 
_while50_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while50_exit
_while50_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
; *dest++ = digits[i]; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; len++; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  inc b
  lea d, [bp + -8] ; $len
  mov [d], b
  dec b
  jmp _while50_cond
_while50_exit:
; *dest = '\0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
; return len; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  leave
  ret

print_unsigned:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
; if(num == 0){ 
_if51_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if51_exit
_if51_true:
; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
; return; 
  leave
  ret
  jmp _if51_exit
_if51_exit:
; while (num > 0) { 
_while52_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while52_exit
_while52_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  dec b
  jmp _while52_cond
_while52_exit:
; while (i > 0) { 
_while53_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while53_exit
_while53_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while53_cond
_while53_exit:
  leave
  ret

sprint_signed:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int len = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -8] ; $len
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if54_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if54_else
_if54_true:
; *dest++ = '-'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  mov b, $2d
  pop d
  mov [d], bl
; num = -num; 
  lea d, [bp + 7] ; $num
  push d
  lea d, [bp + 7] ; $num
  mov b, [d]
  neg b
  pop d
  mov [d], b
; len++; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  inc b
  lea d, [bp + -8] ; $len
  mov [d], b
  dec b
  jmp _if54_exit
_if54_else:
; if (num == 0) { 
_if55_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if55_exit
_if55_true:
; *dest++ = '0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  mov b, $30
  pop d
  mov [d], bl
; *dest = '\0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
; return 1; 
  mov b, $1
  leave
  ret
  jmp _if55_exit
_if55_exit:
_if54_exit:
; while (num > 0) { 
_while56_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while56_exit
_while56_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $num
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 7] ; $num
  push d
  lea d, [bp + 7] ; $num
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  dec b
  jmp _while56_cond
_while56_exit:
; while (i > 0) { 
_while57_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while57_exit
_while57_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
; *dest++ = digits[i]; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; len++; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  inc b
  lea d, [bp + -8] ; $len
  mov [d], b
  dec b
  jmp _while57_cond
_while57_exit:
; *dest = '\0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
; return len; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  leave
  ret

date:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  mov al, 0 
  syscall sys_datetime
; --- END INLINE ASM SEGMENT

  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM SEGMENT

  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
; char c; 
  sub sp, 1

; --- BEGIN INLINE ASM SEGMENT
  call getch
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM SEGMENT

; return c; 
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  leave
  ret

scann:
  enter 0 ; (push bp; mov bp, sp)
; int m; 
  sub sp, 2

; --- BEGIN INLINE ASM SEGMENT
  call scan_u16d
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM SEGMENT

; return m; 
  lea d, [bp + -1] ; $m
  mov b, [d]
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _puts
  mov a, $0A00
  syscall sys_io
; --- END INLINE ASM SEGMENT

  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
  call _puts
; --- END INLINE ASM SEGMENT

  leave
  ret

getparam:
  enter 0 ; (push bp; mov bp, sp)
; char data; 
  sub sp, 1

; --- BEGIN INLINE ASM SEGMENT
  mov al, 4
  lea d, [bp + 5] ; $address
  mov d, [d]
  syscall sys_system
  lea d, [bp + 0] ; $data
  mov [d], bl
; --- END INLINE ASM SEGMENT

; return data; 
  lea d, [bp + 0] ; $data
  mov bl, [d]
  mov bh, 0
  leave
  ret

clear:
  enter 0 ; (push bp; mov bp, sp)
; print("\033[2J\033[H"); 
  mov b, _s2 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
; return i < 0 ? -i : i; 
_ternary58_cond:
  lea d, [bp + 5] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary58_false
_ternary58_true:
  lea d, [bp + 5] ; $i
  mov b, [d]
  neg b
  jmp _ternary58_exit
_ternary58_false:
  lea d, [bp + 5] ; $i
  mov b, [d]
_ternary58_exit:
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
.include "lib/asm/stdio.asm"
; --- END INLINE ASM SEGMENT

  leave
  ret

print_grid:
  enter 0 ; (push bp; mov bp, sp)
; for (y = 0; y < 20; ++y) { 
_for59_init:
  mov d, _y ; $y
  push d
  mov b, $0
  pop d
  mov [d], b
_for59_cond:
  mov d, _y ; $y
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $14
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for59_exit
_for59_block:
; for (x = 0; x < 40; ++x) { 
_for60_init:
  mov d, _x ; $x
  push d
  mov b, $0
  pop d
  mov [d], b
_for60_cond:
  mov d, _x ; $x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for60_exit
_for60_block:
; switch (grid[y][x]) { 
_switch61_expr:
  mov d, _grid_data ; $grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
_switch61_comparisons:
  cmp b, 0
  je _switch61_case0
  cmp b, 1
  je _switch61_case1
  cmp b, 2
  je _switch61_case2
  cmp b, 3
  je _switch61_case3
  jmp _switch61_exit
_switch61_case0:
; c = ' '; break; 
  mov d, _c ; $c
  push d
  mov b, $20
  pop d
  mov [d], bl
; break; 
  jmp _switch61_exit ; case break
_switch61_case1:
; c = '*'; break; 
  mov d, _c ; $c
  push d
  mov b, $2a
  pop d
  mov [d], bl
; break; 
  jmp _switch61_exit ; case break
_switch61_case2:
; c = 'H'; break; 
  mov d, _c ; $c
  push d
  mov b, $48
  pop d
  mov [d], bl
; break; 
  jmp _switch61_exit ; case break
_switch61_case3:
; c = 'T'; break; 
  mov d, _c ; $c
  push d
  mov b, $54
  pop d
  mov [d], bl
; break; 
  jmp _switch61_exit ; case break
_switch61_exit:
; putchar(c); 
  mov d, _c ; $c
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
_for60_update:
  mov d, _x ; $x
  mov b, [d]
  inc b
  mov [d], b
  jmp _for60_cond
_for60_exit:
; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
_for59_update:
  mov d, _y ; $y
  mov b, [d]
  inc b
  mov [d], b
  jmp _for59_cond
_for59_exit:
; return; 
  leave
  ret

iterate:
  enter 0 ; (push bp; mov bp, sp)
; for (y = 0; y < 20; ++y){ 
_for62_init:
  mov d, _y ; $y
  push d
  mov b, $0
  pop d
  mov [d], b
_for62_cond:
  mov d, _y ; $y
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $14
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for62_exit
_for62_block:
; for (x = 0; x < 40; ++x){ 
_for63_init:
  mov d, _x ; $x
  push d
  mov b, $0
  pop d
  mov [d], b
_for63_cond:
  mov d, _x ; $x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for63_exit
_for63_block:
; head_count = 0; 
  mov d, _head_count ; $head_count
  push d
  mov b, $0
  pop d
  mov [d], b
; for (dy = -1; dy <= 1; dy++){ 
_for64_init:
  mov d, _dy ; $dy
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
_for64_cond:
  mov d, _dy ; $dy
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for64_exit
_for64_block:
; for (dx = -1; dx <= 1; dx++) { 
_for65_init:
  mov d, _dx ; $dx
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
_for65_cond:
  mov d, _dx ; $dx
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for65_exit
_for65_block:
; if (dx == 0 && dy == 0) continue; 
_if66_cond:
  mov d, _dx ; $dx
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _dy ; $dy
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if66_exit
_if66_true:
; continue; 
  jmp _for65_update ; for continue
  jmp _if66_exit
_if66_exit:
; nx = x + dx; 
  mov d, _nx ; $nx
  push d
  mov d, _x ; $x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _dx ; $dx
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ny = y + dy; 
  mov d, _ny ; $ny
  push d
  mov d, _y ; $y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _dy ; $dy
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (nx >= 0 && nx < 40 && ny >= 0 && ny < 20 && grid[ny][nx] == ELECTRON_HEAD){ 
_if67_cond:
  mov d, _nx ; $nx
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _nx ; $nx
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _ny ; $ny
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _ny ; $ny
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $14
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _grid_data ; $grid
  push a
  push d
  mov d, _ny ; $ny
  mov b, [d]
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _nx ; $nx
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, 2; ELECTRON_HEAD
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if67_exit
_if67_true:
; head_count++; 
  mov d, _head_count ; $head_count
  mov b, [d]
  inc b
  mov d, _head_count ; $head_count
  mov [d], b
  dec b
  jmp _if67_exit
_if67_exit:
_for65_update:
  mov d, _dx ; $dx
  mov b, [d]
  inc b
  mov d, _dx ; $dx
  mov [d], b
  dec b
  jmp _for65_cond
_for65_exit:
_for64_update:
  mov d, _dy ; $dy
  mov b, [d]
  inc b
  mov d, _dy ; $dy
  mov [d], b
  dec b
  jmp _for64_cond
_for64_exit:
; switch (grid[y][x]) { 
_switch68_expr:
  mov d, _grid_data ; $grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
_switch68_comparisons:
  cmp b, 0
  je _switch68_case0
  cmp b, 1
  je _switch68_case1
  cmp b, 2
  je _switch68_case2
  cmp b, 3
  je _switch68_case3
  jmp _switch68_exit
_switch68_case0:
; new_grid[y][x] = EMPTY; break; 
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 0; EMPTY
  pop d
  mov [d], b
; break; 
  jmp _switch68_exit ; case break
_switch68_case1:
; new_grid[y][x] = (head_count == 1 || head_count == 2) ? ELECTRON_HEAD : CONDUCTOR; break; 
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
_ternary69_cond:
  mov d, _head_count ; $head_count
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _head_count ; $head_count
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _ternary69_false
_ternary69_true:
  mov b, 2; ELECTRON_HEAD
  jmp _ternary69_exit
_ternary69_false:
  mov b, 1; CONDUCTOR
_ternary69_exit:
  pop d
  mov [d], b
; break; 
  jmp _switch68_exit ; case break
_switch68_case2:
; new_grid[y][x] = ELECTRON_TAIL; break; 
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 3; ELECTRON_TAIL
  pop d
  mov [d], b
; break; 
  jmp _switch68_exit ; case break
_switch68_case3:
; new_grid[y][x] = CONDUCTOR; break; 
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, 1; CONDUCTOR
  pop d
  mov [d], b
; break; 
  jmp _switch68_exit ; case break
_switch68_exit:
_for63_update:
  mov d, _x ; $x
  mov b, [d]
  inc b
  mov [d], b
  jmp _for63_cond
_for63_exit:
_for62_update:
  mov d, _y ; $y
  mov b, [d]
  inc b
  mov [d], b
  jmp _for62_cond
_for62_exit:
; for (y = 0; y < 20; ++y) { 
_for70_init:
  mov d, _y ; $y
  push d
  mov b, $0
  pop d
  mov [d], b
_for70_cond:
  mov d, _y ; $y
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $14
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for70_exit
_for70_block:
; for (x = 0; x < 40; ++x) { 
_for71_init:
  mov d, _x ; $x
  push d
  mov b, $0
  pop d
  mov [d], b
_for71_cond:
  mov d, _x ; $x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for71_exit
_for71_block:
; grid[y][x] = new_grid[y][x]; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
_for71_update:
  mov d, _x ; $x
  mov b, [d]
  inc b
  mov [d], b
  jmp _for71_cond
_for71_exit:
_for70_update:
  mov d, _y ; $y
  mov b, [d]
  inc b
  mov [d], b
  jmp _for70_cond
_for70_exit:
; return; 
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_grid_data: .fill 1600, 0
_new_grid_data: .fill 1600, 0
_x: .fill 2, 0
_y: .fill 2, 0
_dx: .fill 2, 0
_dy: .fill 2, 0
_nx: .fill 2, 0
_ny: .fill 2, 0
_head_count: .fill 2, 0
_c: .fill 1, 0
_s0: .db "Unexpected format in printf.", 0
_s1: .db "Error: Unknown argument type.\n", 0
_s2: .db "\033[2J\033[H", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
