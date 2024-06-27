; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; long int i, j; 
  sub sp, 4
  sub sp, 4
; i = 0x0F0F0F0F; 
  lea d, [bp + -3] ; $i
  push d
  mov b, 3855
  mov c, 3855
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; j = 0x01010101; 
  lea d, [bp + -7] ; $j
  push d
  mov b, 257
  mov c, 257
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; printx32(i-j); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $i
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $j
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sbb32 ga, cb
  mov b, a
  mov c, g
  pop g
  pop a
; --- END TERMS
  mov a, c
  swp a
  push a
  swp b
  push b
  call printx32
  add sp, 4
; --- END FUNCTION CALL
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
  mov c, 0
  pop d
  mov [d], b
; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while(*psrc) *pdest++ = *psrc++; 
_while1_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while1_exit
_while1_block:
; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  dec b
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while1_cond
_while1_exit:
; *pdest = '\0'; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov c, 0
  push b
  mov b, $0
  mov c, 0
  pop d
  mov [d], bl
  leave
  ret

strcmp:
  enter 0 ; (push bp; mov bp, sp)
; while (*s1 && (*s1 == *s2)) { 
_while2_cond:
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov c, 0
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
  je _while2_exit
_while2_block:
; s1++; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $s1
  mov [d], b
  dec b
; s2++; 
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 7] ; $s2
  mov [d], b
  dec b
  jmp _while2_cond
_while2_exit:
; return *s1 - *s2; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov c, 0
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
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for (i = 0; src[i] != 0; i=i+1) { 
_for3_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  mov c, 0
  pop d
  mov [d], b
_for3_cond:
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for3_exit
_for3_block:
; dest[dest_len + i] = src[i]; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
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
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for3_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _for3_cond
_for3_exit:
; dest[dest_len + i] = 0; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  mov c, 0
  pop d
  mov [d], bl
; return dest; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
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
  mov c, 0
  pop d
  mov [d], b
; while (str[length] != 0) { 
_while4_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while4_exit
_while4_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  dec b
  jmp _while4_cond
_while4_exit:
; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
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
_for5_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  mov c, 0
  pop d
  mov [d], b
_for5_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 8] ; $size
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for5_exit
_for5_block:
; *(s+i) = c; 
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  push b
  lea d, [bp + 7] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for5_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for5_cond
_for5_exit:
; return s; 
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
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
  mov c, 0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int sign = 1;    // Initialize sign as positive 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  mov c, 0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; while (*str == ' ') str++; 
_while6_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $20
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while6_exit
_while6_block:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while6_cond
_while6_exit:
; if (*str == '-' || *str == '+') { 
_if7_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if7_exit
_if7_true:
; if (*str == '-') sign = -1; 
_if8_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if8_exit
_if8_true:
; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  mov c, 0
  neg b
  pop d
  mov [d], b
  jmp _if8_exit
_if8_exit:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _if7_exit
_if7_exit:
; while (*str >= '0' && *str <= '9') { 
_while9_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $30
  mov c, 0
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $39
  mov c, 0
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while9_exit
_while9_block:
; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mov c, 0
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
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $30
  mov c, 0
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
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while9_cond
_while9_exit:
; return sign * result; 
  lea d, [bp + -3] ; $sign
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
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
  mov c, 0
  leave
  ret

alloc:
  enter 0 ; (push bp; mov bp, sp)
; heap_top = heap_top + bytes; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; return heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  mov c, 0
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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  mov c, 0
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
; static int max_handle = 0; 
  sub sp, 2
; fp = alloc(sizeof(FILE)); 
  lea d, [bp + -1] ; $fp
  push d
; --- START FUNCTION CALL
  mov b, 260
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; strcpy(fp->filename, filename); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $filename
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $fp
  mov d, [d]
  add d, 2
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; fp->handle = max_handle; 
  lea d, [bp + -1] ; $fp
  mov d, [d]
  add d, 0
  push d
  mov d, st_fopen_max_handle ; static max_handle
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; fp->mode = mode; 
  lea d, [bp + -1] ; $fp
  mov d, [d]
  add d, 258
  push d
  lea d, [bp + 7] ; $mode
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; fp->loc = 0; 
  lea d, [bp + -1] ; $fp
  mov d, [d]
  add d, 259
  push d
  mov b, $0
  mov c, 0
  pop d
  mov [d], bl
; max_handle++; 
  mov d, st_fopen_max_handle ; static max_handle
  mov b, [d]
  mov c, 0
  inc b
  mov d, st_fopen_max_handle ; static max_handle
  mov [d], b
  dec b
  leave
  ret

fclose:
  enter 0 ; (push bp; mov bp, sp)
; free(sizeof(FILE)); 
; --- START FUNCTION CALL
  mov b, 260
  swp b
  push b
  call free
  add sp, 2
; --- END FUNCTION CALL
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
  mov c, 0
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
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for10_init:
_for10_cond:
_for10_block:
; if(!*format_p) break; 
_if11_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if11_else
_if11_true:
; break; 
  jmp _for10_exit ; for break
  jmp _if11_exit
_if11_else:
; if(*format_p == '%'){ 
_if12_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $25
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if12_else
_if12_true:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch13_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch13_comparisons:
  cmp bl, $6c
  je _switch13_case0
  cmp bl, $4c
  je _switch13_case1
  cmp bl, $64
  je _switch13_case2
  cmp bl, $69
  je _switch13_case3
  cmp bl, $75
  je _switch13_case4
  cmp bl, $78
  je _switch13_case5
  cmp bl, $63
  je _switch13_case6
  cmp bl, $73
  je _switch13_case7
  jmp _switch13_default
  jmp _switch13_exit
_switch13_case0:
_switch13_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if14_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $69
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if14_else
_if14_true:
; print_signed_long(*(long *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  snex b
  mov c, b
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_signed_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if14_exit
_if14_else:
; if(*format_p == 'u') 
_if15_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $75
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if15_else
_if15_true:
; print_unsigned_long(*(unsigned long *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov bh, 0
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_unsigned_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if15_exit
_if15_else:
; if(*format_p == 'x') 
_if16_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $78
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if16_else
_if16_true:
; printx32(*(long int *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call printx32
  add sp, 4
; --- END FUNCTION CALL
  jmp _if16_exit
_if16_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s0 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if16_exit:
_if15_exit:
_if14_exit:
; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $4
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_case2:
_switch13_case3:
; print_signed(*(int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call print_signed
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_case4:
; print_unsigned(*(unsigned int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_case5:

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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_case6:

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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_case7:

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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s1 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch13_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if12_exit
_if12_else:
; putchar(*format_p); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_if12_exit:
_if11_exit:
_for10_update:
  jmp _for10_cond
_for10_exit:
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
  mov c, 0
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
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for17_init:
_for17_cond:
_for17_block:
; if(!*format_p) break; 
_if18_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if18_else
_if18_true:
; break; 
  jmp _for17_exit ; for break
  jmp _if18_exit
_if18_else:
; if(*format_p == '%'){ 
_if19_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $25
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_else
_if19_true:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch20_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch20_comparisons:
  cmp bl, $6c
  je _switch20_case0
  cmp bl, $4c
  je _switch20_case1
  cmp bl, $64
  je _switch20_case2
  cmp bl, $69
  je _switch20_case3
  cmp bl, $75
  je _switch20_case4
  cmp bl, $78
  je _switch20_case5
  cmp bl, $63
  je _switch20_case6
  cmp bl, $73
  je _switch20_case7
  jmp _switch20_default
  jmp _switch20_exit
_switch20_case0:
_switch20_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i'); 
_if21_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $69
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if21_else
_if21_true:
; ; 
  jmp _if21_exit
_if21_else:
; if(*format_p == 'u'); 
_if22_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $75
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if22_else
_if22_true:
; ; 
  jmp _if22_exit
_if22_else:
; if(*format_p == 'x'); 
_if23_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $78
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if23_else
_if23_true:
; ; 
  jmp _if23_exit
_if23_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s0 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if23_exit:
_if22_exit:
_if21_exit:
; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $4
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch20_exit ; case break
_switch20_case2:
_switch20_case3:
; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
; --- START FUNCTION CALL
  call scann
  pop d
  mov [d], b
; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch20_exit ; case break
_switch20_case4:
; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
; --- START FUNCTION CALL
  call scann
  pop d
  mov [d], b
; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch20_exit ; case break
_switch20_case5:
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch20_exit ; case break
_switch20_case6:
; c = getchar(); 
  lea d, [bp + -4] ; $c
  push d
; --- START FUNCTION CALL
  call getchar
  pop d
  mov [d], bl
; **(char **)p = *(char *)c; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -4] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch20_exit ; case break
_switch20_case7:
; gets(input_string); 
; --- START FUNCTION CALL
  lea d, [bp + -518] ; $input_string
  mov b, d
  mov c, 0
  swp b
  push b
  call gets
  add sp, 2
; --- END FUNCTION CALL
; strcpy(*(char **)p, input_string); 
; --- START FUNCTION CALL
  lea d, [bp + -518] ; $input_string
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch20_exit ; case break
_switch20_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s1 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch20_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if19_exit
_if19_else:
; putchar(*format_p); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_if19_exit:
_if18_exit:
_for17_update:
  jmp _for17_cond
_for17_exit:
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
  mov c, 0
  pop d
  mov [d], b
; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 7] ; $format
  mov b, [d]
  mov c, 0
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
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for24_init:
_for24_cond:
_for24_block:
; if(!*format_p) break; 
_if25_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if25_else
_if25_true:
; break; 
  jmp _for24_exit ; for break
  jmp _if25_exit
_if25_else:
; if(*format_p == '%'){ 
_if26_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $25
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if26_else
_if26_true:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch27_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch27_comparisons:
  cmp bl, $6c
  je _switch27_case0
  cmp bl, $4c
  je _switch27_case1
  cmp bl, $64
  je _switch27_case2
  cmp bl, $69
  je _switch27_case3
  cmp bl, $75
  je _switch27_case4
  cmp bl, $78
  je _switch27_case5
  cmp bl, $63
  je _switch27_case6
  cmp bl, $73
  je _switch27_case7
  jmp _switch27_default
  jmp _switch27_exit
_switch27_case0:
_switch27_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if28_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $69
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if28_else
_if28_true:
; print_signed_long(*(long *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  snex b
  mov c, b
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_signed_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if28_exit
_if28_else:
; if(*format_p == 'u') 
_if29_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $75
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if29_else
_if29_true:
; print_unsigned_long(*(unsigned long *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov bh, 0
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_unsigned_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if29_exit
_if29_else:
; if(*format_p == 'x') 
_if30_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $78
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if30_else
_if30_true:
; printx32(*(long int *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call printx32
  add sp, 4
; --- END FUNCTION CALL
  jmp _if30_exit
_if30_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s0 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if30_exit:
_if29_exit:
_if28_exit:
; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $4
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch27_exit ; case break
_switch27_case2:
_switch27_case3:
; sp = sp + sprint_signed(sp, *(int*)p); 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call sprint_signed
  add sp, 4
; --- END FUNCTION CALL
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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch27_exit ; case break
_switch27_case4:
; sp = sp + sprint_unsigned(sp, *(unsigned int*)p); 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call sprint_unsigned
  add sp, 4
; --- END FUNCTION CALL
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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch27_exit ; case break
_switch27_case5:

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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch27_exit ; case break
_switch27_case6:
; *sp++ = *(char *)p; 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -5] ; $sp
  mov [d], b
  dec b
  push b
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch27_exit ; case break
_switch27_case7:
; int len = strlen(*(char **)p); 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -7] ; $len
  push d
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; strcpy(sp, *(char **)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; sp = sp + len; 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $len
  mov b, [d]
  mov c, 0
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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch27_exit ; case break
_switch27_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s1 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch27_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if26_exit
_if26_else:
; *sp++ = *format_p++; 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -5] ; $sp
  mov [d], b
  dec b
  push b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_if26_exit:
_if25_exit:
_for24_update:
  jmp _for24_cond
_for24_exit:
; *sp = '\0'; 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  push b
  mov b, $0
  mov c, 0
  pop d
  mov [d], bl
; return sp - dest; // return total number of chars written 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  leave
  ret

err:
  enter 0 ; (push bp; mov bp, sp)
; print(e); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $e
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
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
  mov c, 0
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
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $hex_string
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for (i = 0; i < len; i++) { 
_for31_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  mov c, 0
  pop d
  mov [d], b
_for31_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for31_exit
_for31_block:
; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
  lea d, [bp + 5] ; $hex_string
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (hex_char >= 'a' && hex_char <= 'f')  
_if32_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $61
  mov c, 0
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
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $66
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if32_else
_if32_true:
; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $10
  mov c, 0
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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $61
  mov c, 0
  sub a, b
  mov b, a
  mov a, b
  mov b, $a
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if32_exit
_if32_else:
; if (hex_char >= 'A' && hex_char <= 'F')  
_if33_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $41
  mov c, 0
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
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $46
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if33_else
_if33_true:
; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $10
  mov c, 0
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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $41
  mov c, 0
  sub a, b
  mov b, a
  mov a, b
  mov b, $a
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if33_exit
_if33_else:
; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $10
  mov c, 0
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
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $30
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_if33_exit:
_if32_exit:
_for31_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  dec b
  jmp _for31_cond
_for31_exit:
; return value; 
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
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
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
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
  mov c, 0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if34_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if34_else
_if34_true:
; putchar('-'); 
; --- START FUNCTION CALL
  mov b, $2d
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  neg b
  pop d
  mov [d], b
  jmp _if34_exit
_if34_else:
; if (num == 0) { 
_if35_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if35_exit
_if35_true:
; putchar('0'); 
; --- START FUNCTION CALL
  mov b, $30
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if35_exit
_if35_exit:
_if34_exit:
; while (num > 0) { 
_while36_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while36_exit
_while36_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov b, $30
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mov c, 0
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
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mov c, 0
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  dec b
  jmp _while36_cond
_while36_exit:
; while (i > 0) { 
_while37_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while37_exit
_while37_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while37_cond
_while37_exit:
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
  mov c, 0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if38_cond:
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
  mov c, 0
  cmp32 ga, cb
  slt ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if38_else
_if38_true:
; putchar('-'); 
; --- START FUNCTION CALL
  mov b, $2d
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
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
  mov b, 0
  mov [d + 2], b
  jmp _if38_exit
_if38_else:
; if (num == 0) { 
_if39_cond:
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
  mov c, 0
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if39_exit
_if39_true:
; putchar('0'); 
; --- START FUNCTION CALL
  mov b, $30
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if39_exit
_if39_exit:
_if38_exit:
; while (num > 0) { 
_while40_cond:
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
  mov c, 0
  cmp32 ga, cb
  sgt
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while40_exit
_while40_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov b, $30
  mov c, 0
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
  mov c, 0
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add32 cb, ga
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
  mov c, 0
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
  mov c, 0
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  dec b
  jmp _while40_cond
_while40_exit:
; while (i > 0) { 
_while41_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while41_exit
_while41_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  inc b
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while41_cond
_while41_exit:
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
  mov c, 0
  pop d
  mov [d], b
; if(num == 0){ 
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
; --- START FUNCTION CALL
  mov b, $30
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if42_exit
_if42_exit:
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
  mov c, 0
  cmp32 ga, cb
  sgu
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
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov b, $30
  mov c, 0
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
  mov c, 0
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add32 cb, ga
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
  mov c, 0
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
  mov c, 0
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
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
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
  mov c, 0
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  inc b
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while44_cond
_while44_exit:
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
  mov c, 0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  mov c, 0
  pop d
  mov [d], b
; if(num == 0){ 
_if45_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if45_exit
_if45_true:
; *dest++ = '0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  mov b, $30
  mov c, 0
  pop d
  mov [d], bl
; return 1; 
  mov b, $1
  mov c, 0
  leave
  ret
  jmp _if45_exit
_if45_exit:
; while (num > 0) { 
_while46_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while46_exit
_while46_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov b, $30
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mov c, 0
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
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mov c, 0
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  dec b
  jmp _while46_cond
_while46_exit:
; while (i > 0) { 
_while47_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while47_exit
_while47_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
; *dest++ = digits[i]; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
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
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; len++; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -8] ; $len
  mov [d], b
  dec b
  jmp _while47_cond
_while47_exit:
; *dest = '\0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  push b
  mov b, $0
  mov c, 0
  pop d
  mov [d], bl
; return len; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
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
  mov c, 0
  pop d
  mov [d], b
; if(num == 0){ 
_if48_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if48_exit
_if48_true:
; putchar('0'); 
; --- START FUNCTION CALL
  mov b, $30
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if48_exit
_if48_exit:
; while (num > 0) { 
_while49_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
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
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov b, $30
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mov c, 0
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
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mov c, 0
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
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
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
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
  mov c, 0
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while50_cond
_while50_exit:
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
  mov c, 0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int len = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -8] ; $len
  push d
  mov b, $0
  mov c, 0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if51_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if51_else
_if51_true:
; *dest++ = '-'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  mov b, $2d
  mov c, 0
  pop d
  mov [d], bl
; num = -num; 
  lea d, [bp + 7] ; $num
  push d
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
  neg b
  pop d
  mov [d], b
; len++; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -8] ; $len
  mov [d], b
  dec b
  jmp _if51_exit
_if51_else:
; if (num == 0) { 
_if52_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if52_exit
_if52_true:
; *dest++ = '0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  mov b, $30
  mov c, 0
  pop d
  mov [d], bl
; *dest = '\0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  push b
  mov b, $0
  mov c, 0
  pop d
  mov [d], bl
; return 1; 
  mov b, $1
  mov c, 0
  leave
  ret
  jmp _if52_exit
_if52_exit:
_if51_exit:
; while (num > 0) { 
_while53_cond:
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while53_exit
_while53_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov b, $30
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mov c, 0
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
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  mov c, 0
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  dec b
  jmp _while53_cond
_while53_exit:
; while (i > 0) { 
_while54_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while54_exit
_while54_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
; *dest++ = digits[i]; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
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
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; len++; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -8] ; $len
  mov [d], b
  dec b
  jmp _while54_cond
_while54_exit:
; *dest = '\0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  push b
  mov b, $0
  mov c, 0
  pop d
  mov [d], bl
; return len; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
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
  mov c, 0
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
  mov c, 0
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
  mov c, 0
  leave
  ret

clear:
  enter 0 ; (push bp; mov bp, sp)
; print("\033[2J\033[H"); 
; --- START FUNCTION CALL
  mov b, _s2 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
; return i < 0 ? -i : i; 
_ternary55_cond:
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary55_false
_ternary55_true:
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
  neg b
  jmp _ternary55_exit
_ternary55_false:
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
_ternary55_exit:
  leave
  ret

loadfile:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 7] ; $destination
  mov a, [d]
  mov di, a
  lea d, [bp + 5] ; $filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem
; --- END INLINE ASM SEGMENT

  leave
  ret

create_file:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

delete_file:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $filename
  mov al, 10
  syscall sys_filesystem
; --- END INLINE ASM SEGMENT

  leave
  ret

load_hex:
  enter 0 ; (push bp; mov bp, sp)
; char *temp; 
  sub sp, 2
; temp = alloc(32768); 
  lea d, [bp + -1] ; $temp
  push d
; --- START FUNCTION CALL
  mov b, $8000
  mov c, 0
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b

; --- BEGIN INLINE ASM SEGMENT
  
  
  
_load_hex:
  lea d, [bp + 5] ; $destination
  mov d, [d]
  mov di, d
  lea d, [bp + -1] ; $temp
  mov d, [d]
  mov c, 0
  mov a, sp
  inc a
  mov d, a          
  call _gets        
  mov si, a
__load_hex_loop:
  lodsb             
  cmp al, 0         
  jz __load_hex_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        
  stosb             
  inc c
  jmp __load_hex_loop
__load_hex_ret:
; --- END INLINE ASM SEGMENT

  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
.include "lib/asm/stdio.asm"
; --- END INLINE ASM SEGMENT

  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
st_fopen_max_handle: .dw 0
_s0: .db "Unexpected format in printf.", 0
_s1: .db "Error: Unknown argument type.\n", 0
_s2: .db "\033[2J\033[H", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
