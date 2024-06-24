; --- FILENAME: games/startrek
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; intro(); 
  call intro
; new_game(); 
  call new_game
; return (0); 
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
_while1_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while1_exit
_while1_block:
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
  jmp _while1_cond
_while1_exit:
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
_while2_cond:
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
  je _while2_exit
_while2_block:
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
  jmp _while2_cond
_while2_exit:
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
_for3_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for3_cond:
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
  je _for3_exit
_for3_block:
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
_for3_update:
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
  jmp _for3_cond
_for3_exit:
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
_while4_cond:
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
  je _while4_exit
_while4_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  dec b
  jmp _while4_cond
_while4_exit:
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
_for5_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for5_cond:
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
  je _for5_exit
_for5_block:
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
_for5_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for5_cond
_for5_exit:
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
_while6_cond:
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
  je _while6_exit
_while6_block:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
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
  je _if7_exit
_if7_true:
; if (*str == '-') sign = -1; 
_if8_cond:
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
  je _if8_exit
_if8_true:
; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
  jmp _if8_exit
_if8_exit:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
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
  je _while9_exit
_while9_block:
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
  jmp _while9_cond
_while9_exit:
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
_for10_init:
_for10_cond:
_for10_block:
; if(!*format_p) break; 
_if11_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
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
  je _if12_else
_if12_true:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch13_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
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
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if14_cond:
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
  je _if14_else
_if14_true:
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
  jmp _if14_exit
_if14_else:
; if(*format_p == 'u') 
_if15_cond:
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
  je _if15_else
_if15_true:
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
  jmp _if15_exit
_if15_else:
; if(*format_p == 'x') 
_if16_cond:
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
  je _if16_else
_if16_true:
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
  jmp _if16_exit
_if16_else:
; err("Unexpected format in printf."); 
  mov b, _s30 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if16_exit:
_if15_exit:
_if14_exit:
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
  jmp _switch13_exit ; case break
_switch13_case2:
_switch13_case3:
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
  jmp _switch13_exit ; case break
_switch13_case4:
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
  jmp _switch13_exit ; case break
_switch13_default:
; print("Error: Unknown argument type.\n"); 
  mov b, _s31 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch13_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if12_exit
_if12_else:
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
_for17_init:
_for17_cond:
_for17_block:
; if(!*format_p) break; 
_if18_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
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
  je _if19_else
_if19_true:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch20_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
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
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i'); 
_if21_cond:
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
  je _if21_else
_if21_true:
; ; 
  jmp _if21_exit
_if21_else:
; if(*format_p == 'u'); 
_if22_cond:
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
  je _if22_else
_if22_true:
; ; 
  jmp _if22_exit
_if22_else:
; if(*format_p == 'x'); 
_if23_cond:
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
  je _if23_else
_if23_true:
; ; 
  jmp _if23_exit
_if23_else:
; err("Unexpected format in printf."); 
  mov b, _s30 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if23_exit:
_if22_exit:
_if21_exit:
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
  jmp _switch20_exit ; case break
_switch20_case2:
_switch20_case3:
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
  jmp _switch20_exit ; case break
_switch20_case4:
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
  jmp _switch20_exit ; case break
_switch20_case5:
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
  jmp _switch20_exit ; case break
_switch20_case6:
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
  jmp _switch20_exit ; case break
_switch20_case7:
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
  jmp _switch20_exit ; case break
_switch20_default:
; print("Error: Unknown argument type.\n"); 
  mov b, _s31 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch20_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if19_exit
_if19_else:
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
_for24_init:
_for24_cond:
_for24_block:
; if(!*format_p) break; 
_if25_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
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
  je _if26_else
_if26_true:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch27_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
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
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if28_cond:
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
  je _if28_else
_if28_true:
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
  jmp _if28_exit
_if28_else:
; if(*format_p == 'u') 
_if29_cond:
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
  je _if29_else
_if29_true:
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
  jmp _if29_exit
_if29_else:
; if(*format_p == 'x') 
_if30_cond:
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
  je _if30_else
_if30_true:
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
  jmp _if30_exit
_if30_else:
; err("Unexpected format in printf."); 
  mov b, _s30 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if30_exit:
_if29_exit:
_if28_exit:
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
  jmp _switch27_exit ; case break
_switch27_case2:
_switch27_case3:
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
  jmp _switch27_exit ; case break
_switch27_case4:
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
  jmp _switch27_exit ; case break
_switch27_case6:
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
  jmp _switch27_exit ; case break
_switch27_case7:
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
  jmp _switch27_exit ; case break
_switch27_default:
; print("Error: Unknown argument type.\n"); 
  mov b, _s31 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch27_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if26_exit
_if26_else:
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
_if26_exit:
_if25_exit:
_for24_update:
  jmp _for24_cond
_for24_exit:
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
_for31_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for31_cond:
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
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; if (hex_char >= 'a' && hex_char <= 'f')  
_if32_cond:
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
  je _if32_else
_if32_true:
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
  jmp _if32_exit
_if32_else:
; if (hex_char >= 'A' && hex_char <= 'F')  
_if33_cond:
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
  je _if33_else
_if33_true:
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
  jmp _if33_exit
_if33_else:
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
_if33_exit:
_if32_exit:
_for31_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  dec b
  jmp _for31_cond
_for31_exit:
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
_if34_cond:
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
  je _if34_else
_if34_true:
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
  jmp _if34_exit
_if34_else:
; if (num == 0) { 
_if35_cond:
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
  je _if35_exit
_if35_true:
; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
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
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
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
  jmp _while36_cond
_while36_exit:
; while (i > 0) { 
_while37_cond:
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
  je _while37_exit
_while37_block:
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
  cmp32 ga, cb
  slt ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if38_else
_if38_true:
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
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if39_exit
_if39_true:
; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
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
  jmp _while40_cond
_while40_exit:
; while (i > 0) { 
_while41_cond:
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
  je _while41_exit
_while41_block:
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
_if45_cond:
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
  je _if45_exit
_if45_true:
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
  jmp _if45_exit
_if45_exit:
; while (num > 0) { 
_while46_cond:
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
  je _while46_exit
_while46_block:
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
  jmp _while46_cond
_while46_exit:
; while (i > 0) { 
_while47_cond:
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
  je _while47_exit
_while47_block:
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
  jmp _while47_cond
_while47_exit:
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
_if48_cond:
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
  je _if48_exit
_if48_true:
; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
; return; 
  leave
  ret
  jmp _if48_exit
_if48_exit:
; while (num > 0) { 
_while49_cond:
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
_if51_cond:
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
  je _if51_else
_if51_true:
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
  jmp _if51_exit
_if51_else:
; if (num == 0) { 
_if52_cond:
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
  je _if52_exit
_if52_true:
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
  jmp _if52_exit
_if52_exit:
_if51_exit:
; while (num > 0) { 
_while53_cond:
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
  je _while53_exit
_while53_block:
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
  jmp _while53_cond
_while53_exit:
; while (i > 0) { 
_while54_cond:
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
  je _while54_exit
_while54_block:
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
  jmp _while54_cond
_while54_exit:
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
  mov b, _s32 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
; return i < 0 ? -i : i; 
_ternary55_cond:
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
  je _ternary55_false
_ternary55_true:
  lea d, [bp + 5] ; $i
  mov b, [d]
  neg b
  jmp _ternary55_exit
_ternary55_false:
  lea d, [bp + 5] ; $i
  mov b, [d]
_ternary55_exit:
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
.include "lib/asm/stdio.asm"
; --- END INLINE ASM SEGMENT

  leave
  ret

include_ctype_lib:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
.include "lib/asm/ctype.asm"
; --- END INLINE ASM SEGMENT

  leave
  ret

is_space:
  enter 0 ; (push bp; mov bp, sp)
; return c == ' ' || c == '\t' || c == '\n' || c == '\r'; 
  lea d, [bp + 5] ; $c
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $9
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

is_digit:
  enter 0 ; (push bp; mov bp, sp)
; return c >= '0' && c <= '9'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  leave
  ret

is_alpha:
  enter 0 ; (push bp; mov bp, sp)
; return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_'); 
  lea d, [bp + 5] ; $c
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
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
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
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

tolower:
  enter 0 ; (push bp; mov bp, sp)
; if (ch >= 'A' && ch <= 'Z')  
_if56_cond:
  lea d, [bp + 5] ; $ch
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
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if56_else
_if56_true:
; return ch - 'A' + 'a'; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, a
  mov a, b
  mov b, $61
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if56_exit
_if56_else:
; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if56_exit:
  leave
  ret

toupper:
  enter 0 ; (push bp; mov bp, sp)
; if (ch >= 'a' && ch <= 'z')  
_if57_cond:
  lea d, [bp + 5] ; $ch
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
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if57_else
_if57_true:
; return ch - 'a' + 'A'; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, a
  mov a, b
  mov b, $41
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if57_exit
_if57_else:
; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if57_exit:
  leave
  ret

is_delimiter:
  enter 0 ; (push bp; mov bp, sp)
; if( 
_if58_cond:
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $23
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
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
  mov a, b
  lea d, [bp + 5] ; $c
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
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
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
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $5b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $5d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $29
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $7b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $7d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $3a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $21
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $5e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $7e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if58_else
_if58_true:
; return 1; 
  mov b, $1
  leave
  ret
  jmp _if58_exit
_if58_else:
; return 0; 
  mov b, $0
  leave
  ret
_if58_exit:
  leave
  ret

TO_FIXED:
  enter 0 ; (push bp; mov bp, sp)
; return x * 10; 
  lea d, [bp + 5] ; $x
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
  leave
  ret

FROM_FIXED:
  enter 0 ; (push bp; mov bp, sp)
; return x / 10; 
  lea d, [bp + 5] ; $x
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  leave
  ret

TO_FIXED00:
  enter 0 ; (push bp; mov bp, sp)
; return x * 100; 
  lea d, [bp + 5] ; $x
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  leave
  ret

FROM_FIXED00:
  enter 0 ; (push bp; mov bp, sp)
; return x / 100; 
  lea d, [bp + 5] ; $x
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  leave
  ret

get_rand:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int        r = rand(); 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $r
  push d
  call rand
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; r = (r >> 8) | (r << 8); 
  lea d, [bp + -1] ; $r
  push d
  lea d, [bp + -1] ; $r
  mov b, [d]
; --- START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push a
  mov a, b
  lea d, [bp + -1] ; $r
  mov b, [d]
; --- START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  or b, a ; |
  pop a
  pop d
  mov [d], b
; return ((r % spread) + 1); 
  lea d, [bp + -1] ; $r
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $spread
  mov b, [d]
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  leave
  ret

rand8:
  enter 0 ; (push bp; mov bp, sp)
; return (get_rand(8)); 
  mov b, $8
  swp b
  push b
  call get_rand
  add sp, 2
  leave
  ret

input:
  enter 0 ; (push bp; mov bp, sp)
; int c; 
  sub sp, 2
; while((c = getchar()) != '\n') { 
_while59_cond:
  lea d, [bp + -1] ; $c
  push d
  call getchar
  pop d
  mov [d], b
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while59_exit
_while59_block:
; if (c ==   -1  ) 
_if60_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  neg b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if60_exit
_if60_true:
; exit(); 
  call exit
  jmp _if60_exit
_if60_exit:
; if (l > 1) { 
_if61_cond:
  lea d, [bp + 7] ; $l
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if61_exit
_if61_true:
; *b++ = c; 
  lea d, [bp + 5] ; $b
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $b
  mov [d], b
  dec b
  push b
  lea d, [bp + -1] ; $c
  mov b, [d]
  pop d
  mov [d], bl
; l--; 
  lea d, [bp + 7] ; $l
  mov bl, [d]
  mov bh, 0
  dec b
  lea d, [bp + 7] ; $l
  mov [d], b
  inc b
  jmp _if61_exit
_if61_exit:
  jmp _while59_cond
_while59_exit:
; *b = 0; 
  lea d, [bp + 5] ; $b
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

yesno:
  enter 0 ; (push bp; mov bp, sp)
; char b[2]; 
  sub sp, 2
; input(b,2); 
  mov b, $2
  push bl
  lea d, [bp + -1] ; $b
  mov b, d
  swp b
  push b
  call input
  add sp, 3
; if (tolower(*b) == 'y') 
_if62_cond:
  lea d, [bp + -1] ; $b
  mov b, d
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call tolower
  add sp, 1
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $79
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if62_exit
_if62_true:
; return 1; 
  mov b, $1
  leave
  ret
  jmp _if62_exit
_if62_exit:
; return 0; 
  mov b, $0
  leave
  ret

input_f00:
  enter 0 ; (push bp; mov bp, sp)
; int       v; 
  sub sp, 2
; char buf[8]; 
  sub sp, 8
; char *x; 
  sub sp, 2
; input(buf, 8); 
  mov b, $8
  push bl
  lea d, [bp + -9] ; $buf
  mov b, d
  swp b
  push b
  call input
  add sp, 3
; x = buf; 
  lea d, [bp + -11] ; $x
  push d
  lea d, [bp + -9] ; $buf
  mov b, d
  pop d
  mov [d], b
; if (!is_digit(*x)) 
_if63_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if63_exit
_if63_true:
; return -1; 
  mov b, $1
  neg b
  leave
  ret
  jmp _if63_exit
_if63_exit:
; v = 100 * (*x++ - '0'); 
  lea d, [bp + -1] ; $v
  push d
  mov b, $64
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -11] ; $x
  mov b, [d]
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
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
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; if (*x == 0) 
_if64_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if64_exit
_if64_true:
; return v; 
  lea d, [bp + -1] ; $v
  mov b, [d]
  leave
  ret
  jmp _if64_exit
_if64_exit:
; if (*x++ != '.') 
_if65_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if65_exit
_if65_true:
; return -1; 
  mov b, $1
  neg b
  leave
  ret
  jmp _if65_exit
_if65_exit:
; if (!is_digit(*x)) 
_if66_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if66_exit
_if66_true:
; return -1; 
  mov b, $1
  neg b
  leave
  ret
  jmp _if66_exit
_if66_exit:
; v = v + 10 * (*x++ - '0'); 
  lea d, [bp + -1] ; $v
  push d
  lea d, [bp + -1] ; $v
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $a
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -11] ; $x
  mov b, [d]
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
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
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (!*x) 
_if67_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if67_exit
_if67_true:
; return v; 
  lea d, [bp + -1] ; $v
  mov b, [d]
  leave
  ret
  jmp _if67_exit
_if67_exit:
; if (!is_digit(*x)) 
_if68_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if68_exit
_if68_true:
; return -1; 
  mov b, $1
  neg b
  leave
  ret
  jmp _if68_exit
_if68_exit:
; v = v + *x++ - '0'; 
  lea d, [bp + -1] ; $v
  push d
  lea d, [bp + -1] ; $v
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $x
  mov b, [d]
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  add b, a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; return v; 
  lea d, [bp + -1] ; $v
  mov b, [d]
  leave
  ret

input_int:
  enter 0 ; (push bp; mov bp, sp)
; char x[8]; 
  sub sp, 8
; input(x, 8); 
  mov b, $8
  push bl
  lea d, [bp + -7] ; $x
  mov b, d
  swp b
  push b
  call input
  add sp, 3
; if (!is_digit(*x)) 
_if69_cond:
  lea d, [bp + -7] ; $x
  mov b, d
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if69_exit
_if69_true:
; return -1; 
  mov b, $1
  neg b
  leave
  ret
  jmp _if69_exit
_if69_exit:
; return atoi(x); 
  lea d, [bp + -7] ; $x
  mov b, d
  swp b
  push b
  call atoi
  add sp, 2
  leave
  ret

print100:
  enter 0 ; (push bp; mov bp, sp)
; static char buf[16]; 
  sub sp, 16
; char *p = buf; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $p
  push d
  mov d, st_print100_buf_dt ; static buf
  mov b, d
  pop d
  mov [d], bl
; --- END LOCAL VAR INITIALIZATION
; if (v < 0) { 
_if70_cond:
  lea d, [bp + 5] ; $v
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
  je _if70_exit
_if70_true:
; v = -v; 
  lea d, [bp + 5] ; $v
  push d
  lea d, [bp + 5] ; $v
  mov b, [d]
  neg b
  pop d
  mov [d], b
; *p++ = '-'; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  dec b
  push b
  mov b, $2d
  pop d
  mov [d], bl
  jmp _if70_exit
_if70_exit:
; p = p + sprintf(p, "%d.%d", v / 100, v%100); 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $v
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  swp b
  push b
  lea d, [bp + 5] ; $v
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  swp b
  push b
  mov b, _s33 ; "%d.%d"
  swp b
  push b
  lea d, [bp + -1] ; $p
  mov b, [d]
  swp b
  push b
  call sprintf
  add sp, 8
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; return buf; 
  mov d, st_print100_buf_dt ; static buf
  mov b, d
  leave
  ret

inoperable:
  enter 0 ; (push bp; mov bp, sp)
; if (damage[u] < 0) { 
_if71_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if71_exit
_if71_true:
; printf("%s %s inoperable.\n", 
_ternary73_cond:
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary73_false
_ternary73_true:
  mov b, _s34 ; "are"
  jmp _ternary73_exit
_ternary73_false:
  mov b, _s35 ; "is"
_ternary73_exit:
  swp b
  push b
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, _s36 ; "%s %s inoperable.\n"
  swp b
  push b
  call printf
  add sp, 6
; return 1; 
  mov b, $1
  leave
  ret
  jmp _if71_exit
_if71_exit:
; return 0; 
  mov b, $0
  leave
  ret

intro:
  enter 0 ; (push bp; mov bp, sp)
; showfile("startrek.intro"); 
  mov b, _s37 ; "startrek.intro"
  swp b
  push b
  call showfile
  add sp, 2
; if (yesno()) 
_if74_cond:
  call yesno
  cmp b, 0
  je _if74_exit
_if74_true:
; showfile("startrek.doc"); 
  mov b, _s38 ; "startrek.doc"
  swp b
  push b
  call showfile
  add sp, 2
  jmp _if74_exit
_if74_exit:
; showfile("startrek.logo"); 
  mov b, _s39 ; "startrek.logo"
  swp b
  push b
  call showfile
  add sp, 2
; stardate = TO_FIXED((get_rand(20) + 20) * 100); 
  mov d, _stardate ; $stardate
  push d
  mov b, $14
  swp b
  push b
  call get_rand
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $14
  add b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  swp b
  push b
  call TO_FIXED
  add sp, 2
  pop d
  mov [d], b
  leave
  ret

new_game:
  enter 0 ; (push bp; mov bp, sp)
; char cmd[4]; 
  sub sp, 4
; initialize(); 
  call initialize
; new_quadrant(); 
  call new_quadrant
; short_range_scan(); 
  call short_range_scan
; while (1) { 
_while75_cond:
  mov b, $1
  cmp b, 0
  je _while75_exit
_while75_block:
; if (shield + energy <= 10 && (energy < 10 || damage[7] < 0)) { 
_if76_cond:
  mov d, _shield ; $shield
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $7
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if76_exit
_if76_true:
; showfile("startrek.fatal"); 
  mov b, _s40 ; "startrek.fatal"
  swp b
  push b
  call showfile
  add sp, 2
; end_of_time(); 
  call end_of_time
  jmp _if76_exit
_if76_exit:
; puts("Command? "); 
  mov b, _s41 ; "Command? "
  swp b
  push b
  call puts
  add sp, 2
; input(cmd, 4); 
  mov b, $4
  push bl
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call input
  add sp, 3
; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
; if (!strncmp(cmd, "nav", 3)) 
_if77_cond:
  mov b, $3
  swp b
  push b
  mov b, _s42 ; "nav"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if77_else
_if77_true:
; course_control(); 
  call course_control
  jmp _if77_exit
_if77_else:
; if (!strncmp(cmd, "srs", 3)) 
_if78_cond:
  mov b, $3
  swp b
  push b
  mov b, _s43 ; "srs"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if78_else
_if78_true:
; short_range_scan(); 
  call short_range_scan
  jmp _if78_exit
_if78_else:
; if (!strncmp(cmd, "lrs", 3)) 
_if79_cond:
  mov b, $3
  swp b
  push b
  mov b, _s44 ; "lrs"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if79_else
_if79_true:
; long_range_scan(); 
  call long_range_scan
  jmp _if79_exit
_if79_else:
; if (!strncmp(cmd, "pha", 3)) 
_if80_cond:
  mov b, $3
  swp b
  push b
  mov b, _s45 ; "pha"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if80_else
_if80_true:
; phaser_control(); 
  call phaser_control
  jmp _if80_exit
_if80_else:
; if (!strncmp(cmd, "tor", 3)) 
_if81_cond:
  mov b, $3
  swp b
  push b
  mov b, _s46 ; "tor"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if81_else
_if81_true:
; photon_torpedoes(); 
  call photon_torpedoes
  jmp _if81_exit
_if81_else:
; if (!strncmp(cmd, "shi", 3)) 
_if82_cond:
  mov b, $3
  swp b
  push b
  mov b, _s47 ; "shi"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if82_else
_if82_true:
; shield_control(); 
  call shield_control
  jmp _if82_exit
_if82_else:
; if (!strncmp(cmd, "dam", 3)) 
_if83_cond:
  mov b, $3
  swp b
  push b
  mov b, _s48 ; "dam"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if83_else
_if83_true:
; damage_control(); 
  call damage_control
  jmp _if83_exit
_if83_else:
; if (!strncmp(cmd, "com", 3)) 
_if84_cond:
  mov b, $3
  swp b
  push b
  mov b, _s49 ; "com"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if84_else
_if84_true:
; library_computer(); 
  call library_computer
  jmp _if84_exit
_if84_else:
; if (!strncmp(cmd, "xxx", 3)) 
_if85_cond:
  mov b, $3
  swp b
  push b
  mov b, _s50 ; "xxx"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if85_else
_if85_true:
; resign_commision(); 
  call resign_commision
  jmp _if85_exit
_if85_else:
; puts("Enter one of the following:\n"); 
  mov b, _s51 ; "Enter one of the following:\n"
  swp b
  push b
  call puts
  add sp, 2
; puts("  nav - To Set Course"); 
  mov b, _s52 ; "  nav - To Set Course"
  swp b
  push b
  call puts
  add sp, 2
; puts("  srs - Short Range Sensors"); 
  mov b, _s53 ; "  srs - Short Range Sensors"
  swp b
  push b
  call puts
  add sp, 2
; puts("  lrs - Long Range Sensors"); 
  mov b, _s54 ; "  lrs - Long Range Sensors"
  swp b
  push b
  call puts
  add sp, 2
; puts("  pha - Phasers"); 
  mov b, _s55 ; "  pha - Phasers"
  swp b
  push b
  call puts
  add sp, 2
; puts("  tor - Photon Torpedoes"); 
  mov b, _s56 ; "  tor - Photon Torpedoes"
  swp b
  push b
  call puts
  add sp, 2
; puts("  shi - Shield Control"); 
  mov b, _s57 ; "  shi - Shield Control"
  swp b
  push b
  call puts
  add sp, 2
; puts("  dam - Damage Control"); 
  mov b, _s58 ; "  dam - Damage Control"
  swp b
  push b
  call puts
  add sp, 2
; puts("  com - Library Computer"); 
  mov b, _s59 ; "  com - Library Computer"
  swp b
  push b
  call puts
  add sp, 2
; puts("  xxx - Resign Command\n"); 
  mov b, _s60 ; "  xxx - Resign Command\n"
  swp b
  push b
  call puts
  add sp, 2
_if85_exit:
_if84_exit:
_if83_exit:
_if82_exit:
_if81_exit:
_if80_exit:
_if79_exit:
_if78_exit:
_if77_exit:
  jmp _while75_cond
_while75_exit:
  leave
  ret

initialize:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; unsigned char                         yp, xp; 
  sub sp, 1
  sub sp, 1
; unsigned char                         r; 
  sub sp, 1
; time_start = FROM_FIXED(stardate); 
  mov d, _time_start ; $time_start
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
  pop d
  mov [d], b
; time_up = 25 + get_rand(10); 
  mov d, _time_up ; $time_up
  push d
  mov b, $19
; --- START TERMS
  push a
  mov a, b
  mov b, $a
  swp b
  push b
  call get_rand
  add sp, 2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; docked = 0; 
  mov d, _docked ; $docked
  push d
  mov b, $0
  pop d
  mov [d], bl
; energy = energy0; 
  mov d, _energy ; $energy
  push d
  mov d, _energy0 ; $energy0
  mov b, [d]
  pop d
  mov [d], b
; torps = torps0; 
  mov d, _torps ; $torps
  push d
  mov d, _torps0 ; $torps0
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov b, $0
  pop d
  mov [d], b
; quad_y = rand8(); 
  mov d, _quad_y ; $quad_y
  push d
  call rand8
  pop d
  mov [d], b
; quad_x = rand8(); 
  mov d, _quad_x ; $quad_x
  push d
  call rand8
  pop d
  mov [d], b
; ship_y = TO_FIXED00(rand8()); 
  mov d, _ship_y ; $ship_y
  push d
  call rand8
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
; ship_x = TO_FIXED00(rand8()); 
  mov d, _ship_x ; $ship_x
  push d
  call rand8
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
; for (i = 1; i <= 8; i++) 
_for86_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for86_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for86_exit
_for86_block:
; damage[i] = 0; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], b
_for86_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for86_cond
_for86_exit:
; for (i = 1; i <= 8; i++) { 
_for87_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for87_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for87_exit
_for87_block:
; for (j = 1; j <= 8; j++) { 
_for88_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $1
  pop d
  mov [d], b
_for88_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for88_exit
_for88_block:
; r = get_rand(100); 
  lea d, [bp + -6] ; $r
  push d
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
  pop d
  mov [d], bl
; klingons = 0; 
  mov d, _klingons ; $klingons
  push d
  mov b, $0
  pop d
  mov [d], bl
; if (r > 98) 
_if89_cond:
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $62
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if89_else
_if89_true:
; klingons = 3; 
  mov d, _klingons ; $klingons
  push d
  mov b, $3
  pop d
  mov [d], bl
  jmp _if89_exit
_if89_else:
; if (r > 95) 
_if90_cond:
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if90_else
_if90_true:
; klingons = 2; 
  mov d, _klingons ; $klingons
  push d
  mov b, $2
  pop d
  mov [d], bl
  jmp _if90_exit
_if90_else:
; if (r > 80) 
_if91_cond:
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $50
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if91_exit
_if91_true:
; klingons = 1; 
  mov d, _klingons ; $klingons
  push d
  mov b, $1
  pop d
  mov [d], bl
  jmp _if91_exit
_if91_exit:
_if90_exit:
_if89_exit:
; klingons_left = klingons_left + klingons; 
  mov d, _klingons_left ; $klingons_left
  push d
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; starbases = 0; 
  mov d, _starbases ; $starbases
  push d
  mov b, $0
  pop d
  mov [d], bl
; if (get_rand(100) > 96) 
_if92_cond:
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $60
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if92_exit
_if92_true:
; starbases = 1; 
  mov d, _starbases ; $starbases
  push d
  mov b, $1
  pop d
  mov [d], bl
  jmp _if92_exit
_if92_exit:
; starbases_left = starbases_left + starbases; 
  mov d, _starbases_left ; $starbases_left
  push d
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; map[i][j] = (klingons << 8) + (starbases << 4) + rand8(); 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; --- START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
; --- START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  mov a, b
  call rand8
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for88_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  dec b
  jmp _for88_cond
_for88_exit:
_for87_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for87_cond
_for87_exit:
; if (klingons_left > time_up) 
_if93_cond:
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if93_exit
_if93_true:
; time_up = klingons_left + 1; 
  mov d, _time_up ; $time_up
  push d
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if93_exit
_if93_exit:
; if (starbases_left == 0) { 
_if94_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if94_exit
_if94_true:
; yp = rand8(); 
  lea d, [bp + -4] ; $yp
  push d
  call rand8
  pop d
  mov [d], bl
; xp = rand8(); 
  lea d, [bp + -5] ; $xp
  push d
  call rand8
  pop d
  mov [d], bl
; if (map[yp][xp] < 0x200) { 
_if95_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $200
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if95_exit
_if95_true:
; map[yp][xp] = map[yp][xp] + (1 << 8); 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
; --- START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; klingons_left++; 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  inc b
  mov d, _klingons_left ; $klingons_left
  mov [d], b
  dec b
  jmp _if95_exit
_if95_exit:
; map[yp][xp] = map[yp][xp] + (1 << 4); 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
; --- START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; starbases_left++; 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  inc b
  mov d, _starbases_left ; $starbases_left
  mov [d], b
  dec b
  jmp _if94_exit
_if94_exit:
; total_klingons = klingons_left; 
  mov d, _total_klingons ; $total_klingons
  push d
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; if (starbases_left != 1) { 
_if96_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if96_exit
_if96_true:
; strcpy(plural_2, "s"); 
  mov b, _s61 ; "s"
  swp b
  push b
  mov d, _plural_2_data ; $plural_2
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
; strcpy(plural, "are"); 
  mov b, _s34 ; "are"
  swp b
  push b
  mov d, _plural_data ; $plural
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
  jmp _if96_exit
_if96_exit:
; printf("Your orders are as follows:\nDestroy the %d Klingon warships which have",klingons_left); 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, _s62 ; "Your orders are as follows:\nDestroy the %d Klingon warships which have"
  swp b
  push b
  call printf
  add sp, 3
; printf("invaded\n the galaxy before they can attack Federation Headquarters\n"); 
  mov b, _s63 ; "invaded\n the galaxy before they can attack Federation Headquarters\n"
  swp b
  push b
  call printf
  add sp, 2
; printf(" on stardate %u. This gives you %d days. There %s\n %d starbase%s in the galaxy",  
  mov d, _plural_2_data ; $plural_2
  mov b, d
  swp b
  push b
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  push bl
  mov d, _plural_data ; $plural
  mov b, d
  swp b
  push b
  mov d, _time_up ; $time_up
  mov b, [d]
  swp b
  push b
  mov d, _time_start ; $time_start
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  mov b, _s64 ; " on stardate %u. This gives you %d days. There %s\n %d starbase%s in the galaxy"
  swp b
  push b
  call printf
  add sp, 11
; printf(" for resupplying your ship.\n\n Hit any key to accept command. "); 
  mov b, _s65 ; " for resupplying your ship.\n\n Hit any key to accept command. "
  swp b
  push b
  call printf
  add sp, 2
; getchar(); 
  call getchar
  leave
  ret

place_ship:
  enter 0 ; (push bp; mov bp, sp)
; quad[FROM_FIXED00(ship_y) - 1][FROM_FIXED00(ship_x) - 1] =  		4     ; 
  mov d, _quad_data ; $quad
  push a
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  mov b, $4
  pop d
  mov [d], bl
  leave
  ret

new_quadrant:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; unsigned int        tmp; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; k = &kdata; 
  lea d, [bp + -5] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; klingons = 0; 
  mov d, _klingons ; $klingons
  push d
  mov b, $0
  pop d
  mov [d], bl
; starbases = 0; 
  mov d, _starbases ; $starbases
  push d
  mov b, $0
  pop d
  mov [d], bl
; stars = 0; 
  mov d, _stars ; $stars
  push d
  mov b, $0
  pop d
  mov [d], bl
; d4 = get_rand(50) - 1; 
  mov d, _d4 ; $d4
  push d
  mov b, $32
  swp b
  push b
  call get_rand
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; map[quad_y][quad_x] = map[quad_y][quad_x] |   0x1000		/* Set if this sector was mapped */          ; 
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  push a
  mov a, b
  mov b, $1000
  or b, a ; |
  pop a
  pop d
  mov [d], b
; if (quad_y >= 1 && quad_y <= 8 && quad_x >= 1 && quad_x <= 8) { 
_if97_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if97_exit
_if97_true:
; quadrant_name(0, quad_y, quad_x); 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  push bl
  mov d, _quad_y ; $quad_y
  mov b, [d]
  push bl
  mov b, $0
  push bl
  call quadrant_name
  add sp, 3
; if (TO_FIXED(time_start) != stardate) 
_if98_cond:
  mov d, _time_start ; $time_start
  mov b, [d]
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if98_else
_if98_true:
; printf("Now entering %s quadrant...\n\n", quadname); 
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  mov b, _s66 ; "Now entering %s quadrant...\n\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if98_exit
_if98_else:
; puts("\nYour mission begins with your starship located"); 
  mov b, _s67 ; "\nYour mission begins with your starship located"
  swp b
  push b
  call puts
  add sp, 2
; printf("in the galactic quadrant %s.\n\n", quadname); 
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  mov b, _s68 ; "in the galactic quadrant %s.\n\n"
  swp b
  push b
  call printf
  add sp, 4
_if98_exit:
  jmp _if97_exit
_if97_exit:
; tmp = map[quad_y][quad_x]; 
  lea d, [bp + -3] ; $tmp
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
; klingons = (tmp >> 8) & 0x0F; 
  mov d, _klingons ; $klingons
  push d
  lea d, [bp + -3] ; $tmp
  mov b, [d]
; --- START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push a
  mov a, b
  mov b, $f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; starbases = (tmp >> 4) & 0x0F; 
  mov d, _starbases ; $starbases
  push d
  lea d, [bp + -3] ; $tmp
  mov b, [d]
; --- START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push a
  mov a, b
  mov b, $f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; stars = tmp & 0x0F; 
  mov d, _stars ; $stars
  push d
  lea d, [bp + -3] ; $tmp
  mov b, [d]
  push a
  mov a, b
  mov b, $f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; if (klingons > 0) { 
_if99_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if99_exit
_if99_true:
; printf("Combat Area  Condition Red\n"); 
  mov b, _s69 ; "Combat Area  Condition Red\n"
  swp b
  push b
  call printf
  add sp, 2
; if (shield < 200) 
_if100_cond:
  mov d, _shield ; $shield
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $c8
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if100_exit
_if100_true:
; printf("Shields Dangerously Low\n"); 
  mov b, _s70 ; "Shields Dangerously Low\n"
  swp b
  push b
  call printf
  add sp, 2
  jmp _if100_exit
_if100_exit:
  jmp _if99_exit
_if99_exit:
; for (i = 1; i <= 3; i++) { 
_for101_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for101_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for101_exit
_for101_block:
; k->y = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  push d
  mov b, $0
  pop d
  mov [d], bl
; k->x = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  push d
  mov b, $0
  pop d
  mov [d], bl
; k->energy = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
  push d
  mov b, $0
  pop d
  mov [d], b
; k++; 
  lea d, [bp + -5] ; $k
  mov b, [d]
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  dec b
  dec b
_for101_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for101_cond
_for101_exit:
; memset(quad,  		0      , 64); 
  mov b, $40
  swp b
  push b
  mov b, $0
  push bl
  mov d, _quad_data ; $quad
  mov b, d
  swp b
  push b
  call memset
  add sp, 5
; place_ship(); 
  call place_ship
; if (klingons > 0) { 
_if102_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if102_exit
_if102_true:
; k = kdata; 
  lea d, [bp + -5] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; for (i = 0; i < klingons; i++) { 
_for103_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for103_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for103_exit
_for103_block:
; find_set_empty_place( 	3        , &k->y, &k->x); 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  mov b, d
  swp b
  push b
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  mov b, d
  swp b
  push b
  mov b, $3
  push bl
  call find_set_empty_place
  add sp, 5
; k->energy = 100 + get_rand(200); 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
  push d
  mov b, $64
; --- START TERMS
  push a
  mov a, b
  mov b, $c8
  swp b
  push b
  call get_rand
  add sp, 2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; k++; 
  lea d, [bp + -5] ; $k
  mov b, [d]
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  dec b
  dec b
_for103_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for103_cond
_for103_exit:
  jmp _if102_exit
_if102_exit:
; if (starbases > 0) 
_if104_cond:
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if104_exit
_if104_true:
; find_set_empty_place( 		2     , &base_y, &base_x); 
  mov d, _base_x ; $base_x
  mov b, d
  swp b
  push b
  mov d, _base_y ; $base_y
  mov b, d
  swp b
  push b
  mov b, $2
  push bl
  call find_set_empty_place
  add sp, 5
  jmp _if104_exit
_if104_exit:
; for (i = 1; i <= stars; i++) 
_for105_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for105_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _stars ; $stars
  mov bl, [d]
  mov bh, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for105_exit
_for105_block:
; find_set_empty_place( 		1     ,   0   ,   0   ); 
  mov b, $0
  swp b
  push b
  mov b, $0
  swp b
  push b
  mov b, $1
  push bl
  call find_set_empty_place
  add sp, 5
_for105_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for105_cond
_for105_exit:
  leave
  ret

course_control:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int       c1; 
  sub sp, 2
; int       warp; 
  sub sp, 2
; unsigned int        n; 
  sub sp, 2
; int c2, c3, c4; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; int       z1, z2; 
  sub sp, 2
  sub sp, 2
; int       x1, x2; 
  sub sp, 2
  sub sp, 2
; int       x, y; 
  sub sp, 2
  sub sp, 2
; unsigned char                         outside = 0;		/* Outside galaxy flag */ 
  sub sp, 1
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -26] ; $outside
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; unsigned char                         quad_y_old; 
  sub sp, 1
; unsigned char                         quad_x_old; 
  sub sp, 1
; puts("Course (0-9): " ); 
  mov b, _s71 ; "Course (0-9): "
  swp b
  push b
  call puts
  add sp, 2
; c1 = input_f00(); 
  lea d, [bp + -3] ; $c1
  push d
  call input_f00
  pop d
  mov [d], b
; if (c1 == 900) 
_if106_cond:
  lea d, [bp + -3] ; $c1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if106_exit
_if106_true:
; c1 = 100; 
  lea d, [bp + -3] ; $c1
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if106_exit
_if106_exit:
; if (c1 < 0 || c1 > 900) { 
_if107_cond:
  lea d, [bp + -3] ; $c1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $c1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if107_exit
_if107_true:
; printf("Lt. Sulu%s", inc_1); 
  mov d, _inc_1 ; $inc_1
  mov b, [d]
  swp b
  push b
  mov b, _s72 ; "Lt. Sulu%s"
  swp b
  push b
  call printf
  add sp, 4
; return; 
  leave
  ret
  jmp _if107_exit
_if107_exit:
; if (damage[1] < 0) 
_if108_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if108_exit
_if108_true:
; strcpy(warpmax, "0.2"); 
  mov b, _s73 ; "0.2"
  swp b
  push b
  mov d, _warpmax_data ; $warpmax
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
  jmp _if108_exit
_if108_exit:
; printf("Warp Factor (0-%s): ", warpmax); 
  mov d, _warpmax_data ; $warpmax
  mov b, d
  swp b
  push b
  mov b, _s74 ; "Warp Factor (0-%s): "
  swp b
  push b
  call printf
  add sp, 4
; warp = input_f00(); 
  lea d, [bp + -5] ; $warp
  push d
  call input_f00
  pop d
  mov [d], b
; if (damage[1] < 0 && warp > 20) { 
_if109_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -5] ; $warp
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $14
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if109_exit
_if109_true:
; printf("Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n"); 
  mov b, _s75 ; "Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n"
  swp b
  push b
  call printf
  add sp, 2
; return; 
  leave
  ret
  jmp _if109_exit
_if109_exit:
; if (warp <= 0) 
_if110_cond:
  lea d, [bp + -5] ; $warp
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if110_exit
_if110_true:
; return; 
  leave
  ret
  jmp _if110_exit
_if110_exit:
; if (warp > 800) { 
_if111_cond:
  lea d, [bp + -5] ; $warp
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $320
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if111_exit
_if111_true:
; printf("Chief Engineer Scott reports:\n  The engines wont take warp %s!\n\n", print100(warp)); 
  lea d, [bp + -5] ; $warp
  mov b, [d]
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, _s76 ; "Chief Engineer Scott reports:\n  The engines wont take warp %s!\n\n"
  swp b
  push b
  call printf
  add sp, 4
; return; 
  leave
  ret
  jmp _if111_exit
_if111_exit:
; n = warp * 8; 
  lea d, [bp + -7] ; $n
  push d
  lea d, [bp + -5] ; $warp
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $8
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; n = cint100(n);	 
  lea d, [bp + -7] ; $n
  push d
  lea d, [bp + -7] ; $n
  mov b, [d]
  swp b
  push b
  call cint100
  add sp, 2
  pop d
  mov [d], b
; if (energy - n < 0) { 
_if112_cond:
  mov d, _energy ; $energy
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if112_exit
_if112_true:
; printf("Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n", print100(warp)); 
  lea d, [bp + -5] ; $warp
  mov b, [d]
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, _s77 ; "Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n"
  swp b
  push b
  call printf
  add sp, 4
; if (shield >= n && damage[7] >= 0) { 
_if113_cond:
  mov d, _shield ; $shield
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $7
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if113_exit
_if113_true:
; printf("Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n", shield); 
  mov d, _shield ; $shield
  mov b, [d]
  swp b
  push b
  mov b, _s78 ; "Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if113_exit
_if113_exit:
; return; 
  leave
  ret
  jmp _if112_exit
_if112_exit:
; klingons_move(); 
  call klingons_move
; repair_damage(warp); 
  lea d, [bp + -5] ; $warp
  mov b, [d]
  swp b
  push b
  call repair_damage
  add sp, 2
; z1 = FROM_FIXED00(ship_y); 
  lea d, [bp + -15] ; $z1
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; z2 = FROM_FIXED00(ship_x); 
  lea d, [bp + -17] ; $z2
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; quad[z1+-1][z2+-1] =  		0      ; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -15] ; $z1
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $ffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -17] ; $z2
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $ffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
; c2 = FROM_FIXED00(c1);	/* Integer part */ 
  lea d, [bp + -9] ; $c2
  push d
  lea d, [bp + -3] ; $c1
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; c3 = c2 + 1;		/* Next integer part */ 
  lea d, [bp + -11] ; $c3
  push d
  lea d, [bp + -9] ; $c2
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
; c4 = (c1 - TO_FIXED00(c2));	/* Fractional element in fixed point */ 
  lea d, [bp + -13] ; $c4
  push d
  lea d, [bp + -3] ; $c1
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -9] ; $c2
  mov b, [d]
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x1 = 100 * c[1][c2] + (c[1][c3] - c[1][c2]) * c4; 
  lea d, [bp + -19] ; $x1
  push d
  mov b, $64
; --- START FACTORS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $1
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c2
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $1
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -11] ; $c3
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $1
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c2
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -13] ; $c4
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x2 = 100 * c[2][c2] + (c[2][c3] - c[2][c2]) * c4; 
  lea d, [bp + -21] ; $x2
  push d
  mov b, $64
; --- START FACTORS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $2
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c2
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $2
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -11] ; $c3
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $2
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c2
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -13] ; $c4
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x = ship_y; 
  lea d, [bp + -23] ; $x
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  pop d
  mov [d], b
; y = ship_x; 
  lea d, [bp + -25] ; $y
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  pop d
  mov [d], b
; for (i = 1; i <= n; i++) { 
_for114_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for114_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for114_exit
_for114_block:
; ship_y = ship_y + x1; 
  mov d, _ship_y ; $ship_y
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = ship_x + x2; 
  mov d, _ship_x ; $ship_x
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; z1 = FROM_FIXED00(ship_y); 
  lea d, [bp + -15] ; $z1
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; z2 = FROM_FIXED00(ship_x);	/* ?? cint100 ?? */ 
  lea d, [bp + -17] ; $z2
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; if (z1 < 1 || z1 >= 9 || z2 < 1 || z2 >= 9) { 
_if115_cond:
  lea d, [bp + -15] ; $z1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -15] ; $z1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $9
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + -17] ; $z2
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + -17] ; $z2
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $9
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if115_exit
_if115_true:
; outside = 0;		/* Outside galaxy flag */ 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $0
  pop d
  mov [d], bl
; quad_y_old = quad_y; 
  lea d, [bp + -27] ; $quad_y_old
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mov [d], bl
; quad_x_old = quad_x; 
  lea d, [bp + -28] ; $quad_x_old
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mov [d], bl
; x = (800 * quad_y) + x + (n * x1); 
  lea d, [bp + -23] ; $x
  push d
  mov b, $320
; --- START FACTORS
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -23] ; $x
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; y = (800 * quad_x) + y + (n * x2); 
  lea d, [bp + -25] ; $y
  push d
  mov b, $320
; --- START FACTORS
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -25] ; $y
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; quad_y = x / 800;	/* Fixed point to int and divide by 8 */ 
  mov d, _quad_y ; $quad_y
  push d
  lea d, [bp + -23] ; $x
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $320
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; quad_x = y / 800;	/* Ditto */ 
  mov d, _quad_x ; $quad_x
  push d
  lea d, [bp + -25] ; $y
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $320
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; ship_y = x - (quad_y * 800); 
  mov d, _ship_y ; $ship_y
  push d
  lea d, [bp + -23] ; $x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $320
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = y - (quad_x * 800); 
  mov d, _ship_x ; $ship_x
  push d
  lea d, [bp + -25] ; $y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $320
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (ship_y < 100) { 
_if116_cond:
  mov d, _ship_y ; $ship_y
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if116_exit
_if116_true:
; quad_y = quad_y - 1; 
  mov d, _quad_y ; $quad_y
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_y = ship_y + 800; 
  mov d, _ship_y ; $ship_y
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $320
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if116_exit
_if116_exit:
; if (ship_x < 100) { 
_if117_cond:
  mov d, _ship_x ; $ship_x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if117_exit
_if117_true:
; quad_x = quad_x - 1; 
  mov d, _quad_x ; $quad_x
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = ship_x + 800; 
  mov d, _ship_x ; $ship_x
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $320
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if117_exit
_if117_exit:
; if (quad_y < 1) { 
_if118_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if118_exit
_if118_true:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $1
  pop d
  mov [d], bl
; quad_y = 1; 
  mov d, _quad_y ; $quad_y
  push d
  mov b, $1
  pop d
  mov [d], b
; ship_y = 100; 
  mov d, _ship_y ; $ship_y
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if118_exit
_if118_exit:
; if (quad_y > 8) { 
_if119_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if119_exit
_if119_true:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $1
  pop d
  mov [d], bl
; quad_y = 8; 
  mov d, _quad_y ; $quad_y
  push d
  mov b, $8
  pop d
  mov [d], b
; ship_y = 800; 
  mov d, _ship_y ; $ship_y
  push d
  mov b, $320
  pop d
  mov [d], b
  jmp _if119_exit
_if119_exit:
; if (quad_x < 1) { 
_if120_cond:
  mov d, _quad_x ; $quad_x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if120_exit
_if120_true:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $1
  pop d
  mov [d], bl
; quad_x = 1; 
  mov d, _quad_x ; $quad_x
  push d
  mov b, $1
  pop d
  mov [d], b
; ship_x = 100; 
  mov d, _ship_x ; $ship_x
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if120_exit
_if120_exit:
; if (quad_x > 8) { 
_if121_cond:
  mov d, _quad_x ; $quad_x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if121_exit
_if121_true:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $1
  pop d
  mov [d], bl
; quad_x = 8; 
  mov d, _quad_x ; $quad_x
  push d
  mov b, $8
  pop d
  mov [d], b
; ship_x = 800; 
  mov d, _ship_x ; $ship_x
  push d
  mov b, $320
  pop d
  mov [d], b
  jmp _if121_exit
_if121_exit:
; if (outside == 1) { 
_if122_cond:
  lea d, [bp + -26] ; $outside
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if122_exit
_if122_true:
; printf("LT. Uhura reports:\n Message from Starfleet Command:\n\n "); 
  mov b, _s79 ; "LT. Uhura reports:\n Message from Starfleet Command:\n\n "
  swp b
  push b
  call printf
  add sp, 2
; printf("Permission to attempt crossing of galactic perimeter\n is hereby *denied*. "); 
  mov b, _s80 ; "Permission to attempt crossing of galactic perimeter\n is hereby *denied*. "
  swp b
  push b
  call printf
  add sp, 2
; printf("Shut down your engines.\n\n Chief Engineer Scott reports:\n "); 
  mov b, _s81 ; "Shut down your engines.\n\n Chief Engineer Scott reports:\n "
  swp b
  push b
  call printf
  add sp, 2
; printf("Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n",  
  mov d, _quad_x ; $quad_x
  mov b, [d]
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  swp b
  push b
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  swp b
  push b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  swp b
  push b
  mov b, _s82 ; "Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n"
  swp b
  push b
  call printf
  add sp, 10
  jmp _if122_exit
_if122_exit:
; maneuver_energy(n); 
  lea d, [bp + -7] ; $n
  mov b, [d]
  swp b
  push b
  call maneuver_energy
  add sp, 2
; if (FROM_FIXED(stardate) > time_start + time_up) 
_if123_cond:
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if123_exit
_if123_true:
; end_of_time(); 
  call end_of_time
  jmp _if123_exit
_if123_exit:
; if (quad_y != quad_y_old || quad_x != quad_x_old) { 
_if124_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -27] ; $quad_y_old
  mov bl, [d]
  mov bh, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -28] ; $quad_x_old
  mov bl, [d]
  mov bh, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if124_exit
_if124_true:
; stardate = stardate + TO_FIXED(1); 
  mov d, _stardate ; $stardate
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  swp b
  push b
  call TO_FIXED
  add sp, 2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; new_quadrant(); 
  call new_quadrant
  jmp _if124_exit
_if124_exit:
; complete_maneuver(warp, n); 
  lea d, [bp + -7] ; $n
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $warp
  mov b, [d]
  swp b
  push b
  call complete_maneuver
  add sp, 4
; return; 
  leave
  ret
  jmp _if115_exit
_if115_exit:
; if (quad[z1-1][z2-1] !=  		0      ) {	/* Sector not empty */ 
_if125_cond:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -15] ; $z1
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -17] ; $z2
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
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
  je _if125_exit
_if125_true:
; ship_y = ship_y - x1; 
  mov d, _ship_y ; $ship_y
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = ship_x - x2; 
  mov d, _ship_x ; $ship_x
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; printf("Warp Engines shut down at sector %d, %d due to bad navigation.\n\n", z1, z2); 
  lea d, [bp + -17] ; $z2
  mov b, [d]
  swp b
  push b
  lea d, [bp + -15] ; $z1
  mov b, [d]
  swp b
  push b
  mov b, _s83 ; "Warp Engines shut down at sector %d, %d due to bad navigation.\n\n"
  swp b
  push b
  call printf
  add sp, 6
; i = n + 1; 
  lea d, [bp + -1] ; $i
  push d
  lea d, [bp + -7] ; $n
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
  jmp _if125_exit
_if125_exit:
_for114_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for114_cond
_for114_exit:
; complete_maneuver(warp, n); 
  lea d, [bp + -7] ; $n
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $warp
  mov b, [d]
  swp b
  push b
  call complete_maneuver
  add sp, 4
  leave
  ret

complete_maneuver:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int        time_used; 
  sub sp, 2
; place_ship(); 
  call place_ship
; maneuver_energy(n); 
  lea d, [bp + 7] ; $n
  mov b, [d]
  swp b
  push b
  call maneuver_energy
  add sp, 2
; time_used = TO_FIXED(1); 
  lea d, [bp + -1] ; $time_used
  push d
  mov b, $1
  swp b
  push b
  call TO_FIXED
  add sp, 2
  pop d
  mov [d], b
; if (warp < 100) 
_if126_cond:
  lea d, [bp + 5] ; $warp
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if126_exit
_if126_true:
; time_used = TO_FIXED(FROM_FIXED00(warp)); 
  lea d, [bp + -1] ; $time_used
  push d
  lea d, [bp + 5] ; $warp
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  swp b
  push b
  call TO_FIXED
  add sp, 2
  pop d
  mov [d], b
  jmp _if126_exit
_if126_exit:
; stardate = stardate + time_used; 
  mov d, _stardate ; $stardate
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $time_used
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (FROM_FIXED(stardate) > time_start + time_up) 
_if127_cond:
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if127_exit
_if127_true:
; end_of_time(); 
  call end_of_time
  jmp _if127_exit
_if127_exit:
; short_range_scan(); 
  call short_range_scan
  leave
  ret

maneuver_energy:
  enter 0 ; (push bp; mov bp, sp)
; energy = energy - n + 10; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $n
  mov b, [d]
  sub a, b
  mov b, a
  mov a, b
  mov b, $a
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (energy >= 0) 
_if128_cond:
  mov d, _energy ; $energy
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if128_exit
_if128_true:
; return; 
  leave
  ret
  jmp _if128_exit
_if128_exit:
; puts("Shield Control supplies energy to complete maneuver.\n"); 
  mov b, _s84 ; "Shield Control supplies energy to complete maneuver.\n"
  swp b
  push b
  call puts
  add sp, 2
; shield = shield + energy; 
  mov d, _shield ; $shield
  push d
  mov d, _shield ; $shield
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; energy = 0; 
  mov d, _energy ; $energy
  push d
  mov b, $0
  pop d
  mov [d], b
; if (shield <= 0) 
_if129_cond:
  mov d, _shield ; $shield
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if129_exit
_if129_true:
; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if129_exit
_if129_exit:
  leave
  ret

short_range_scan:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; char *sC = "GREEN"; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -5] ; $sC
  push d
  mov b, _s85 ; "GREEN"
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (energy < energy0 / 10) 
_if130_cond:
  mov d, _energy ; $energy
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _energy0 ; $energy0
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if130_exit
_if130_true:
; sC = "YELLOW"; 
  lea d, [bp + -5] ; $sC
  push d
  mov b, _s86 ; "YELLOW"
  pop d
  mov [d], b
  jmp _if130_exit
_if130_exit:
; if (klingons > 0) 
_if131_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if131_exit
_if131_true:
; sC = "*RED*"; 
  lea d, [bp + -5] ; $sC
  push d
  mov b, _s87 ; "*RED*"
  pop d
  mov [d], b
  jmp _if131_exit
_if131_exit:
; docked = 0; 
  mov d, _docked ; $docked
  push d
  mov b, $0
  pop d
  mov [d], bl
; for (i = (int) (FROM_FIXED00(ship_y) - 1); i <= (int) (FROM_FIXED00(ship_y) + 1); i++) 
_for132_init:
  lea d, [bp + -1] ; $i
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for132_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for132_exit
_for132_block:
; for (j = (int) (FROM_FIXED00(ship_x) - 1); j <= (int) (FROM_FIXED00(ship_x) + 1); j++) 
_for133_init:
  lea d, [bp + -3] ; $j
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for133_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for133_exit
_for133_block:
; if (i >= 1 && i <= 8 && j >= 1 && j <= 8) { 
_if134_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if134_exit
_if134_true:
; if (quad[i-1][j-1] ==  		2     ) { 
_if135_cond:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if135_exit
_if135_true:
; docked = 1; 
  mov d, _docked ; $docked
  push d
  mov b, $1
  pop d
  mov [d], bl
; sC = "DOCKED"; 
  lea d, [bp + -5] ; $sC
  push d
  mov b, _s88 ; "DOCKED"
  pop d
  mov [d], b
; energy = energy0; 
  mov d, _energy ; $energy
  push d
  mov d, _energy0 ; $energy0
  mov b, [d]
  pop d
  mov [d], b
; torps = torps0; 
  mov d, _torps ; $torps
  push d
  mov d, _torps0 ; $torps0
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; puts("Shields dropped for docking purposes."); 
  mov b, _s89 ; "Shields dropped for docking purposes."
  swp b
  push b
  call puts
  add sp, 2
; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if135_exit
_if135_exit:
  jmp _if134_exit
_if134_exit:
_for133_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  dec b
  jmp _for133_cond
_for133_exit:
_for132_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for132_cond
_for132_exit:
; if (damage[2] < 0) { 
_if136_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if136_exit
_if136_true:
; puts("\n*** Short Range Sensors are out ***"); 
  mov b, _s90 ; "\n*** Short Range Sensors are out ***"
  swp b
  push b
  call puts
  add sp, 2
; return; 
  leave
  ret
  jmp _if136_exit
_if136_exit:
; puts(srs_1); 
  mov d, _srs_1 ; $srs_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
; for (i = 0; i < 8; i++) { 
_for137_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for137_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for137_exit
_for137_block:
; for (j = 0; j < 8; j++) 
_for138_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for138_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for138_exit
_for138_block:
; puts(tilestr[quad[i][j]]); 
  mov d, _tilestr_data ; $tilestr
  push a
  push d
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
_for138_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  dec b
  jmp _for138_cond
_for138_exit:
; if (i == 0) 
_if139_cond:
  lea d, [bp + -1] ; $i
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
  je _if139_exit
_if139_true:
; printf("    Stardate            %d\n", FROM_FIXED(stardate)); 
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
  swp b
  push b
  mov b, _s91 ; "    Stardate            %d\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if139_exit
_if139_exit:
; if (i == 1) 
_if140_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if140_exit
_if140_true:
; printf("    Condition           %s\n", sC); 
  lea d, [bp + -5] ; $sC
  mov b, [d]
  swp b
  push b
  mov b, _s92 ; "    Condition           %s\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if140_exit
_if140_exit:
; if (i == 2) 
_if141_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if141_exit
_if141_true:
; printf("    Quadrant            %d, %d\n", quad_y, quad_x); 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  swp b
  push b
  mov b, _s93 ; "    Quadrant            %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
  jmp _if141_exit
_if141_exit:
; if (i == 3) 
_if142_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if142_exit
_if142_true:
; printf("    Sector              %d, %d\n", FROM_FIXED00(ship_y), FROM_FIXED00(ship_x)); 
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  swp b
  push b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  swp b
  push b
  mov b, _s94 ; "    Sector              %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
  jmp _if142_exit
_if142_exit:
; if (i == 4) 
_if143_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if143_exit
_if143_true:
; printf("    Photon Torpedoes    %d\n", torps); 
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, _s95 ; "    Photon Torpedoes    %d\n"
  swp b
  push b
  call printf
  add sp, 3
  jmp _if143_exit
_if143_exit:
; if (i == 5) 
_if144_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if144_exit
_if144_true:
; printf("    Total Energy        %d\n", energy + shield); 
  mov d, _energy ; $energy
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  mov b, _s96 ; "    Total Energy        %d\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if144_exit
_if144_exit:
; if (i == 6) 
_if145_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $6
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if145_exit
_if145_true:
; printf("    Shields             %d\n", shield); 
  mov d, _shield ; $shield
  mov b, [d]
  swp b
  push b
  mov b, _s97 ; "    Shields             %d\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if145_exit
_if145_exit:
; if (i == 7) 
_if146_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $7
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if146_exit
_if146_true:
; printf("    Klingons Remaining  %d\n", klingons_left); 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, _s98 ; "    Klingons Remaining  %d\n"
  swp b
  push b
  call printf
  add sp, 3
  jmp _if146_exit
_if146_exit:
_for137_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for137_cond
_for137_exit:
; puts(srs_1); 
  mov d, _srs_1 ; $srs_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
; return; 
  leave
  ret

put1bcd:
  enter 0 ; (push bp; mov bp, sp)
; v = v & 0x0F; 
  lea d, [bp + 5] ; $v
  push d
  lea d, [bp + 5] ; $v
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; putchar('0' + v); 
  mov b, $30
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $v
  mov bl, [d]
  mov bh, 0
  add b, a
  pop a
; --- END TERMS
  push bl
  call putchar
  add sp, 1
  leave
  ret

putbcd:
  enter 0 ; (push bp; mov bp, sp)
; put1bcd(x >> 8); 
  lea d, [bp + 5] ; $x
  mov b, [d]
; --- START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push bl
  call put1bcd
  add sp, 1
; put1bcd(x >> 4); 
  lea d, [bp + 5] ; $x
  mov b, [d]
; --- START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push bl
  call put1bcd
  add sp, 1
; put1bcd(x); 
  lea d, [bp + 5] ; $x
  mov b, [d]
  push bl
  call put1bcd
  add sp, 1
  leave
  ret

long_range_scan:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; if (inoperable(3)) 
_if147_cond:
  mov b, $3
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if147_exit
_if147_true:
; return; 
  leave
  ret
  jmp _if147_exit
_if147_exit:
; printf("Long Range Scan for Quadrant %d, %d\n\n", quad_y, quad_x); 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  swp b
  push b
  mov b, _s99 ; "Long Range Scan for Quadrant %d, %d\n\n"
  swp b
  push b
  call printf
  add sp, 6
; for (i = quad_y - 1; i <= quad_y + 1; i++) { 
_for148_init:
  lea d, [bp + -1] ; $i
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for148_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for148_exit
_for148_block:
; printf("%s:", lrs_1); 
  mov d, _lrs_1 ; $lrs_1
  mov b, [d]
  swp b
  push b
  mov b, _s100 ; "%s:"
  swp b
  push b
  call printf
  add sp, 4
; for (j = quad_x - 1; j <= quad_x + 1; j++) { 
_for149_init:
  lea d, [bp + -3] ; $j
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for149_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for149_exit
_for149_block:
; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
; if (i > 0 && i <= 8 && j > 0 && j <= 8) { 
_if150_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if150_else
_if150_true:
; map[i][j] = map[i][j] |   0x1000		/* Set if this sector was mapped */          ; 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  push a
  mov a, b
  mov b, $1000
  or b, a ; |
  pop a
  pop d
  mov [d], b
; putbcd(map[i][j]); 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call putbcd
  add sp, 2
  jmp _if150_exit
_if150_else:
; puts("***"); 
  mov b, _s101 ; "***"
  swp b
  push b
  call puts
  add sp, 2
_if150_exit:
; puts(" :"); 
  mov b, _s102 ; " :"
  swp b
  push b
  call puts
  add sp, 2
_for149_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  dec b
  jmp _for149_cond
_for149_exit:
; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
_for148_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for148_cond
_for148_exit:
; printf("%s\n", lrs_1); 
  mov d, _lrs_1 ; $lrs_1
  mov b, [d]
  swp b
  push b
  mov b, _s103 ; "%s\n"
  swp b
  push b
  call printf
  add sp, 4
  leave
  ret

no_klingon:
  enter 0 ; (push bp; mov bp, sp)
; if (klingons <= 0) { 
_if151_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if151_exit
_if151_true:
; puts("Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"); 
  mov b, _s104 ; "Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"
  swp b
  push b
  call puts
  add sp, 2
; return 1; 
  mov b, $1
  leave
  ret
  jmp _if151_exit
_if151_exit:
; return 0; 
  mov b, $0
  leave
  ret

wipe_klingon:
  enter 0 ; (push bp; mov bp, sp)
; quad[k->y+-1][k->x+-1] =  		0      ; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $ffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $ffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

phaser_control:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; long int       phaser_energy; 
  sub sp, 4
; long unsigned int        h1; 
  sub sp, 4
; int h; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; k = &kdata; 
  lea d, [bp + -13] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; if (inoperable(4)) 
_if152_cond:
  mov b, $4
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if152_exit
_if152_true:
; return; 
  leave
  ret
  jmp _if152_exit
_if152_exit:
; if (no_klingon()) 
_if153_cond:
  call no_klingon
  cmp b, 0
  je _if153_exit
_if153_true:
; return; 
  leave
  ret
  jmp _if153_exit
_if153_exit:
; if (damage[8] < 0) 
_if154_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $8
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if154_exit
_if154_true:
; puts("Computer failure hampers accuracy."); 
  mov b, _s105 ; "Computer failure hampers accuracy."
  swp b
  push b
  call puts
  add sp, 2
  jmp _if154_exit
_if154_exit:
; printf("Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: ", energy); 
  mov d, _energy ; $energy
  mov b, [d]
  swp b
  push b
  mov b, _s106 ; "Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: "
  swp b
  push b
  call printf
  add sp, 4
; phaser_energy = input_int(); 
  lea d, [bp + -5] ; $phaser_energy
  push d
  call input_int
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; if (phaser_energy <= 0) 
_if155_cond:
  lea d, [bp + -5] ; $phaser_energy
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
  sle
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if155_exit
_if155_true:
; return; 
  leave
  ret
  jmp _if155_exit
_if155_exit:
; if (energy - phaser_energy < 0) { 
_if156_cond:
  mov d, _energy ; $energy
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub a, b
  mov b, a
  pop a
; --- END TERMS
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
  je _if156_exit
_if156_true:
; puts("Not enough energy available.\n"); 
  mov b, _s107 ; "Not enough energy available.\n"
  swp b
  push b
  call puts
  add sp, 2
; return; 
  leave
  ret
  jmp _if156_exit
_if156_exit:
; energy = energy -  phaser_energy; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (damage[8] < 0) 
_if157_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $8
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if157_else
_if157_true:
; phaser_energy =phaser_energy * get_rand(100); 
  lea d, [bp + -5] ; $phaser_energy
  push d
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if157_exit
_if157_else:
; phaser_energy = phaser_energy* 100; 
  lea d, [bp + -5] ; $phaser_energy
  push d
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
_if157_exit:
; h1 = phaser_energy / klingons; 
  lea d, [bp + -9] ; $h1
  push d
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; for (i = 0; i <= 2; i++) { 
_for158_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for158_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for158_exit
_for158_block:
; if (k->energy > 0) { 
_if159_cond:
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
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
  je _if159_exit
_if159_true:
; h1 = h1 * (get_rand(100) + 200); 
  lea d, [bp + -9] ; $h1
  push d
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $c8
  add b, a
  pop a
; --- END TERMS
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; h1 =h1/ distance_to(k); 
  lea d, [bp + -9] ; $h1
  push d
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -13] ; $k
  mov b, [d]
  swp b
  push b
  call distance_to
  add sp, 2
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; if (h1 <= 15 * k->energy) {	/* was 0.15 */ 
_if160_cond:
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $f
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  mov c, 0
  sleu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if160_else
_if160_true:
; printf("Sensors show no damage to enemy at %d, %d\n\n", k->y, k->x); 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  push bl
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, _s108 ; "Sensors show no damage to enemy at %d, %d\n\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if160_exit
_if160_else:
; h = FROM_FIXED00(h1); 
  lea d, [bp + -11] ; $h
  push d
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; k->energy = k->energy - h; 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  push d
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $h
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; printf("%d unit hit on Klingon at sector %d, %d\n", 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  push bl
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  push bl
  lea d, [bp + -11] ; $h
  mov b, [d]
  swp b
  push b
  mov b, _s109 ; "%d unit hit on Klingon at sector %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; if (k->energy <= 0) { 
_if161_cond:
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if161_else
_if161_true:
; puts("*** Klingon Destroyed ***\n"); 
  mov b, _s110 ; "*** Klingon Destroyed ***\n"
  swp b
  push b
  call puts
  add sp, 2
; klingons--; 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  dec b
  mov d, _klingons ; $klingons
  mov [d], b
  inc b
; klingons_left--; 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  dec b
  mov d, _klingons_left ; $klingons_left
  mov [d], b
  inc b
; wipe_klingon(k); 
  lea d, [bp + -13] ; $k
  mov b, [d]
  swp b
  push b
  call wipe_klingon
  add sp, 2
; k->energy = 0; 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  push d
  mov b, $0
  pop d
  mov [d], b
; map[quad_y][quad_x] = map[quad_y][quad_x] - 0x100; 
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $100
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (klingons_left <= 0) 
_if162_cond:
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if162_exit
_if162_true:
; won_game(); 
  call won_game
  jmp _if162_exit
_if162_exit:
  jmp _if161_exit
_if161_else:
; printf("   (Sensors show %d units remaining.)\n\n", k->energy); 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  swp b
  push b
  mov b, _s111 ; "   (Sensors show %d units remaining.)\n\n"
  swp b
  push b
  call printf
  add sp, 4
_if161_exit:
_if160_exit:
  jmp _if159_exit
_if159_exit:
; k++; 
  lea d, [bp + -13] ; $k
  mov b, [d]
  inc b
  inc b
  lea d, [bp + -13] ; $k
  mov [d], b
  dec b
  dec b
_for158_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for158_cond
_for158_exit:
; klingons_shoot(); 
  call klingons_shoot
  leave
  ret

photon_torpedoes:
  enter 0 ; (push bp; mov bp, sp)
; int x3, y3; 
  sub sp, 2
  sub sp, 2
; int       c1; 
  sub sp, 2
; int c2, c3, c4; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; int       x, y, x1, x2; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; if (torps <= 0) { 
_if163_cond:
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if163_exit
_if163_true:
; puts("All photon torpedoes expended"); 
  mov b, _s112 ; "All photon torpedoes expended"
  swp b
  push b
  call puts
  add sp, 2
; return; 
  leave
  ret
  jmp _if163_exit
_if163_exit:
; if (inoperable(5)) 
_if164_cond:
  mov b, $5
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if164_exit
_if164_true:
; return; 
  leave
  ret
  jmp _if164_exit
_if164_exit:
; puts("Course (0-9): "); 
  mov b, _s71 ; "Course (0-9): "
  swp b
  push b
  call puts
  add sp, 2
; c1 = input_f00(); 
  lea d, [bp + -5] ; $c1
  push d
  call input_f00
  pop d
  mov [d], b
; if (c1 == 900) 
_if165_cond:
  lea d, [bp + -5] ; $c1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if165_exit
_if165_true:
; c1 = 100; 
  lea d, [bp + -5] ; $c1
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if165_exit
_if165_exit:
; if (c1 < 100 || c1 >= 900) { 
_if166_cond:
  lea d, [bp + -5] ; $c1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -5] ; $c1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if166_exit
_if166_true:
; printf("Ensign Chekov%s", inc_1); 
  mov d, _inc_1 ; $inc_1
  mov b, [d]
  swp b
  push b
  mov b, _s113 ; "Ensign Chekov%s"
  swp b
  push b
  call printf
  add sp, 4
; return; 
  leave
  ret
  jmp _if166_exit
_if166_exit:
; energy = energy - 2; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; torps--; 
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  dec b
  mov d, _torps ; $torps
  mov [d], b
  inc b
; c2 = FROM_FIXED00(c1);	/* Integer part */ 
  lea d, [bp + -7] ; $c2
  push d
  lea d, [bp + -5] ; $c1
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; c3 = c2 + 1;		/* Next integer part */ 
  lea d, [bp + -9] ; $c3
  push d
  lea d, [bp + -7] ; $c2
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
; c4 = (c1 - TO_FIXED00(c2));	/* Fractional element in fixed point */ 
  lea d, [bp + -11] ; $c4
  push d
  lea d, [bp + -5] ; $c1
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $c2
  mov b, [d]
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x1 = 100 * c[1][c2] + (c[1][c3] - c[1][c2]) * c4; 
  lea d, [bp + -17] ; $x1
  push d
  mov b, $64
; --- START FACTORS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $1
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -7] ; $c2
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $1
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c3
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $1
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -7] ; $c2
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -11] ; $c4
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x2 = 100 * c[2][c2] + (c[2][c3] - c[2][c2]) * c4; 
  lea d, [bp + -19] ; $x2
  push d
  mov b, $64
; --- START FACTORS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $2
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -7] ; $c2
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $2
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c3
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov b, $2
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -7] ; $c2
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -11] ; $c4
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x = ship_y + x1; 
  lea d, [bp + -13] ; $x
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -17] ; $x1
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; y = ship_x + x2; 
  lea d, [bp + -15] ; $y
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x2
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x3 = FROM_FIXED00(x); 
  lea d, [bp + -1] ; $x3
  push d
  lea d, [bp + -13] ; $x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; y3 = FROM_FIXED00(y); 
  lea d, [bp + -3] ; $y3
  push d
  lea d, [bp + -15] ; $y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; puts("Torpedo Track:"); 
  mov b, _s114 ; "Torpedo Track:"
  swp b
  push b
  call puts
  add sp, 2
; while (x3 >= 1 && x3 <= 8 && y3 >= 1 && y3 <= 8) { 
_while167_cond:
  lea d, [bp + -1] ; $x3
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $x3
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $y3
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $y3
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while167_exit
_while167_block:
; unsigned char                         p; 
  sub sp, 1
; printf("    %d, %d\n", x3, y3); 
  lea d, [bp + -3] ; $y3
  mov b, [d]
  swp b
  push b
  lea d, [bp + -1] ; $x3
  mov b, [d]
  swp b
  push b
  mov b, _s115 ; "    %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; p = quad[x3-1][y3-1]; 
  lea d, [bp + -20] ; $p
  push d
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -1] ; $x3
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $y3
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; if (p !=  		0       && p !=  		4     ) { 
_if168_cond:
  lea d, [bp + -20] ; $p
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
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -20] ; $p
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if168_exit
_if168_true:
; torpedo_hit(x3, y3); 
  lea d, [bp + -3] ; $y3
  mov b, [d]
  push bl
  lea d, [bp + -1] ; $x3
  mov b, [d]
  push bl
  call torpedo_hit
  add sp, 2
; klingons_shoot(); 
  call klingons_shoot
; return; 
  leave
  ret
  jmp _if168_exit
_if168_exit:
; x = x + x1; 
  lea d, [bp + -13] ; $x
  push d
  lea d, [bp + -13] ; $x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -17] ; $x1
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; y = y + x2; 
  lea d, [bp + -15] ; $y
  push d
  lea d, [bp + -15] ; $y
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x2
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x3 = FROM_FIXED00(x); 
  lea d, [bp + -1] ; $x3
  push d
  lea d, [bp + -13] ; $x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
; y3 = FROM_FIXED00(y); 
  lea d, [bp + -3] ; $y3
  push d
  lea d, [bp + -15] ; $y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  pop d
  mov [d], b
  jmp _while167_cond
_while167_exit:
; puts("Torpedo Missed\n"); 
  mov b, _s116 ; "Torpedo Missed\n"
  swp b
  push b
  call puts
  add sp, 2
; klingons_shoot(); 
  call klingons_shoot
  leave
  ret

torpedo_hit:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; switch(quad[yp-1][xp-1]) { 
_switch169_expr:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
_switch169_comparisons:
  cmp b, 1
  je _switch169_case0
  cmp b, 3
  je _switch169_case1
  cmp b, 2
  je _switch169_case2
  jmp _switch169_exit
_switch169_case0:
; printf("Star at %d, %d absorbed torpedo energy.\n\n", yp, xp); 
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  push bl
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, _s117 ; "Star at %d, %d absorbed torpedo energy.\n\n"
  swp b
  push b
  call printf
  add sp, 4
; return; 
  leave
  ret
_switch169_case1:
; puts("*** Klingon Destroyed ***\n"); 
  mov b, _s110 ; "*** Klingon Destroyed ***\n"
  swp b
  push b
  call puts
  add sp, 2
; klingons--; 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  dec b
  mov d, _klingons ; $klingons
  mov [d], b
  inc b
; klingons_left--; 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  dec b
  mov d, _klingons_left ; $klingons_left
  mov [d], b
  inc b
; if (klingons_left <= 0) 
_if170_cond:
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if170_exit
_if170_true:
; won_game(); 
  call won_game
  jmp _if170_exit
_if170_exit:
; k = kdata; 
  lea d, [bp + -3] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; for (i = 0; i <= 2; i++) { 
_for171_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for171_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for171_exit
_for171_block:
; if (yp == k->y && xp == k->x) 
_if172_cond:
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 1
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
  je _if172_exit
_if172_true:
; k->energy = 0; 
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 2
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if172_exit
_if172_exit:
; k++; 
  lea d, [bp + -3] ; $k
  mov b, [d]
  inc b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  dec b
  dec b
_for171_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for171_cond
_for171_exit:
; map[quad_y][quad_x] =map[quad_y][quad_x] - 0x100; 
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $100
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch169_exit ; case break
_switch169_case2:
; puts("*** Starbase Destroyed ***"); 
  mov b, _s118 ; "*** Starbase Destroyed ***"
  swp b
  push b
  call puts
  add sp, 2
; starbases--; 
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  dec b
  mov d, _starbases ; $starbases
  mov [d], b
  inc b
; starbases_left--; 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  dec b
  mov d, _starbases_left ; $starbases_left
  mov [d], b
  inc b
; if (starbases_left <= 0 && klingons_left <= FROM_FIXED(stardate) - time_start - time_up) { 
_if173_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  sub a, b
  mov b, a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if173_exit
_if173_true:
; puts("That does it, Captain!!"); 
  mov b, _s119 ; "That does it, Captain!!"
  swp b
  push b
  call puts
  add sp, 2
; puts("You are hereby relieved of command\n"); 
  mov b, _s120 ; "You are hereby relieved of command\n"
  swp b
  push b
  call puts
  add sp, 2
; puts("and sentenced to 99 stardates of hard"); 
  mov b, _s121 ; "and sentenced to 99 stardates of hard"
  swp b
  push b
  call puts
  add sp, 2
; puts("labor on Cygnus 12!!\n"); 
  mov b, _s122 ; "labor on Cygnus 12!!\n"
  swp b
  push b
  call puts
  add sp, 2
; resign_commision(); 
  call resign_commision
  jmp _if173_exit
_if173_exit:
; puts("Starfleet Command reviewing your record to consider\n court martial!\n"); 
  mov b, _s123 ; "Starfleet Command reviewing your record to consider\n court martial!\n"
  swp b
  push b
  call puts
  add sp, 2
; docked = 0;		/* Undock */ 
  mov d, _docked ; $docked
  push d
  mov b, $0
  pop d
  mov [d], bl
; map[quad_y][quad_x] =map[quad_y][quad_x] - 0x10; 
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $10
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch169_exit ; case break
_switch169_exit:
; quad[yp-1][xp-1] =  		0      ; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

damage_control:
  enter 0 ; (push bp; mov bp, sp)
; int       repair_cost = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $repair_cost
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i; 
  sub sp, 2
; if (damage[6] < 0) 
_if174_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $6
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if174_exit
_if174_true:
; puts("Damage Control report not available."); 
  mov b, _s124 ; "Damage Control report not available."
  swp b
  push b
  call puts
  add sp, 2
  jmp _if174_exit
_if174_exit:
; if (docked) { 
_if175_cond:
  mov d, _docked ; $docked
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if175_exit
_if175_true:
; repair_cost = 0; 
  lea d, [bp + -1] ; $repair_cost
  push d
  mov b, $0
  pop d
  mov [d], b
; for (i = 1; i <= 8; i++) 
_for176_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for176_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for176_exit
_for176_block:
; if (damage[i] < 0) 
_if177_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if177_exit
_if177_true:
; repair_cost = repair_cost + 10; 
  lea d, [bp + -1] ; $repair_cost
  push d
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $a
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if177_exit
_if177_exit:
_for176_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  dec b
  jmp _for176_cond
_for176_exit:
; if (repair_cost) { 
_if178_cond:
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  cmp b, 0
  je _if178_exit
_if178_true:
; repair_cost = repair_cost + d4; 
  lea d, [bp + -1] ; $repair_cost
  push d
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _d4 ; $d4
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (repair_cost >= 100) 
_if179_cond:
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if179_exit
_if179_true:
; repair_cost = 90;	/* 0.9 */ 
  lea d, [bp + -1] ; $repair_cost
  push d
  mov b, $5a
  pop d
  mov [d], b
  jmp _if179_exit
_if179_exit:
; printf("\nTechnicians standing by to effect repairs to your ship;\n"); 
  mov b, _s125 ; "\nTechnicians standing by to effect repairs to your ship;\n"
  swp b
  push b
  call printf
  add sp, 2
; printf("Estimated time to repair: %s stardates.\n Will you authorize the repair order (y/N)? ", print100(repair_cost)); 
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, _s126 ; "Estimated time to repair: %s stardates.\n Will you authorize the repair order (y/N)? "
  swp b
  push b
  call printf
  add sp, 4
; if (yesno()) { 
_if180_cond:
  call yesno
  cmp b, 0
  je _if180_exit
_if180_true:
; for (i = 1; i <= 8; i++) 
_for181_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for181_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for181_exit
_for181_block:
; if (damage[i] < 0) 
_if182_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if182_exit
_if182_true:
; damage[i] = 0; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if182_exit
_if182_exit:
_for181_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  dec b
  jmp _for181_cond
_for181_exit:
; stardate = stardate + (repair_cost + 5)/10 + 1; 
  mov d, _stardate ; $stardate
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $5
  add b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  mov a, b
  mov b, $1
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if180_exit
_if180_exit:
; return; 
  leave
  ret
  jmp _if178_exit
_if178_exit:
  jmp _if175_exit
_if175_exit:
; if (damage[6] < 0) 
_if183_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $6
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if183_exit
_if183_true:
; return; 
  leave
  ret
  jmp _if183_exit
_if183_exit:
; puts("Device            State of Repair"); 
  mov b, _s127 ; "Device            State of Repair"
  swp b
  push b
  call puts
  add sp, 2
; for (i = 1; i <= 8; i++) 
_for184_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for184_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for184_exit
_for184_block:
; printf("%-25s%6s\n", get_device_name(i), print100(damage[i])); 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  lea d, [bp + -3] ; $i
  mov b, [d]
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, _s128 ; "%-25s%6s\n"
  swp b
  push b
  call printf
  add sp, 6
_for184_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  dec b
  jmp _for184_cond
_for184_exit:
; printf("\n"); 
  mov b, _s129 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
  leave
  ret

shield_control:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; if (inoperable(7)) 
_if185_cond:
  mov b, $7
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if185_exit
_if185_true:
; return; 
  leave
  ret
  jmp _if185_exit
_if185_exit:
; printf("Energy available = %d\n\n Input number of units to shields: ", energy + shield); 
  mov d, _energy ; $energy
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  mov b, _s130 ; "Energy available = %d\n\n Input number of units to shields: "
  swp b
  push b
  call printf
  add sp, 4
; i = input_int(); 
  lea d, [bp + -1] ; $i
  push d
  call input_int
  pop d
  mov [d], b
; if (i < 0 || shield == i) { 
_if186_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if186_exit
_if186_true:
; puts("<Shields Unchanged>\n"); 
  mov b, _s131 ; "<Shields Unchanged>\n"
  swp b
  push b
  call puts
  add sp, 2
; return; 
  leave
  ret
  jmp _if186_exit
_if186_exit:
; if (i >= energy + shield) { 
_if187_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if187_exit
_if187_true:
; puts("Shield Control Reports:\n  This is not the Federation Treasury."); 
  mov b, _s132 ; "Shield Control Reports:\n  This is not the Federation Treasury."
  swp b
  push b
  call puts
  add sp, 2
  jmp _if187_exit
_if187_exit:
; energy = energy + shield - i; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; shield = i; 
  mov d, _shield ; $shield
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
; printf("Deflector Control Room report:\n  Shields now at %d units per your command.\n\n", shield); 
  mov d, _shield ; $shield
  mov b, [d]
  swp b
  push b
  mov b, _s133 ; "Deflector Control Room report:\n  Shields now at %d units per your command.\n\n"
  swp b
  push b
  call printf
  add sp, 4
  leave
  ret

library_computer:
  enter 0 ; (push bp; mov bp, sp)
; if (inoperable(8)) 
_if188_cond:
  mov b, $8
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if188_exit
_if188_true:
; return; 
  leave
  ret
  jmp _if188_exit
_if188_exit:
; puts("Computer active and awating command: "); 
  mov b, _s134 ; "Computer active and awating command: "
  swp b
  push b
  call puts
  add sp, 2
; switch(input_int()) { 
_switch189_expr:
  call input_int
_switch189_comparisons:
  cmp b, -1
  je _switch189_case0
  cmp b, 0
  je _switch189_case1
  cmp b, 1
  je _switch189_case2
  cmp b, 2
  je _switch189_case3
  cmp b, 3
  je _switch189_case4
  cmp b, 4
  je _switch189_case5
  cmp b, 5
  je _switch189_case6
  jmp _switch189_default
  jmp _switch189_exit
_switch189_case0:
; break; 
  jmp _switch189_exit ; case break
_switch189_case1:
; galactic_record(); 
  call galactic_record
; break; 
  jmp _switch189_exit ; case break
_switch189_case2:
; status_report(); 
  call status_report
; break; 
  jmp _switch189_exit ; case break
_switch189_case3:
; torpedo_data(); 
  call torpedo_data
; break; 
  jmp _switch189_exit ; case break
_switch189_case4:
; nav_data(); 
  call nav_data
; break; 
  jmp _switch189_exit ; case break
_switch189_case5:
; dirdist_calc(); 
  call dirdist_calc
; break; 
  jmp _switch189_exit ; case break
_switch189_case6:
; galaxy_map(); 
  call galaxy_map
; break; 
  jmp _switch189_exit ; case break
_switch189_default:
; puts("Functions available from Library-Computer:\n\n"); 
  mov b, _s135 ; "Functions available from Library-Computer:\n\n"
  swp b
  push b
  call puts
  add sp, 2
; puts("   0 = Cumulative Galactic Record\n"); 
  mov b, _s136 ; "   0 = Cumulative Galactic Record\n"
  swp b
  push b
  call puts
  add sp, 2
; puts("   1 = Status Report\n"); 
  mov b, _s137 ; "   1 = Status Report\n"
  swp b
  push b
  call puts
  add sp, 2
; puts("   2 = Photon Torpedo Data\n"); 
  mov b, _s138 ; "   2 = Photon Torpedo Data\n"
  swp b
  push b
  call puts
  add sp, 2
; puts("   3 = Starbase Nav Data\n"); 
  mov b, _s139 ; "   3 = Starbase Nav Data\n"
  swp b
  push b
  call puts
  add sp, 2
; puts("   4 = Direction/Distance Calculator\n"); 
  mov b, _s140 ; "   4 = Direction/Distance Calculator\n"
  swp b
  push b
  call puts
  add sp, 2
; puts("   5 = Galaxy Region Name Map\n"); 
  mov b, _s141 ; "   5 = Galaxy Region Name Map\n"
  swp b
  push b
  call puts
  add sp, 2
_switch189_exit:
  leave
  ret

galactic_record:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; printf("\n     Computer Record of Galaxy for Quadrant %d,%d\n\n", quad_y, quad_x); 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  swp b
  push b
  mov b, _s142 ; "\n     Computer Record of Galaxy for Quadrant %d,%d\n\n"
  swp b
  push b
  call printf
  add sp, 6
; puts("     1     2     3     4     5     6     7     8"); 
  mov b, _s143 ; "     1     2     3     4     5     6     7     8"
  swp b
  push b
  call puts
  add sp, 2
; for (i = 1; i <= 8; i++) { 
_for190_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for190_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for190_exit
_for190_block:
; printf("%s%d", gr_1, i); 
  lea d, [bp + -1] ; $i
  mov b, [d]
  swp b
  push b
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  swp b
  push b
  mov b, _s144 ; "%s%d"
  swp b
  push b
  call printf
  add sp, 6
; for (j = 1; j <= 8; j++) { 
_for191_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $1
  pop d
  mov [d], b
_for191_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for191_exit
_for191_block:
; printf("   "); 
  mov b, _s25 ; "   "
  swp b
  push b
  call printf
  add sp, 2
; if (map[i][j] &   0x1000		/* Set if this sector was mapped */          ) 
_if192_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  push a
  mov a, b
  mov b, $1000
  and b, a ; &
  pop a
  cmp b, 0
  je _if192_else
_if192_true:
; putbcd(map[i][j]); 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call putbcd
  add sp, 2
  jmp _if192_exit
_if192_else:
; printf("***"); 
  mov b, _s101 ; "***"
  swp b
  push b
  call printf
  add sp, 2
_if192_exit:
_for191_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  dec b
  jmp _for191_cond
_for191_exit:
; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
_for190_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for190_cond
_for190_exit:
; printf("%s\n", gr_1); 
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  swp b
  push b
  mov b, _s103 ; "%s\n"
  swp b
  push b
  call printf
  add sp, 4
  leave
  ret

status_report:
  enter 0 ; (push bp; mov bp, sp)
; char *plural = str_s + 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $plural
  push d
  mov d, _str_s ; $str_s
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
; --- END LOCAL VAR INITIALIZATION
; unsigned int        left = TO_FIXED(time_start + time_up) - stardate; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $left
  push d
  mov d, _time_start ; $time_start
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; puts("   Status Report:\n"); 
  mov b, _s145 ; "   Status Report:\n"
  swp b
  push b
  call puts
  add sp, 2
; if (klingons_left > 1) 
_if193_cond:
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if193_exit
_if193_true:
; plural = str_s; 
  lea d, [bp + -1] ; $plural
  push d
  mov d, _str_s ; $str_s
  mov b, [d]
  pop d
  mov [d], b
  jmp _if193_exit
_if193_exit:
; printf("Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n", 
  lea d, [bp + -3] ; $left
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
  swp b
  push b
  lea d, [bp + -3] ; $left
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
  swp b
  push b
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  push bl
  lea d, [bp + -1] ; $plural
  mov b, [d]
  swp b
  push b
  mov b, _s146 ; "Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n"
  swp b
  push b
  call printf
  add sp, 9
; if (starbases_left < 1) { 
_if194_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if194_else
_if194_true:
; puts("Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n"); 
  mov b, _s147 ; "Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n"
  swp b
  push b
  call puts
  add sp, 2
  jmp _if194_exit
_if194_else:
; plural = str_s; 
  lea d, [bp + -1] ; $plural
  push d
  mov d, _str_s ; $str_s
  mov b, [d]
  pop d
  mov [d], b
; if (starbases_left < 2) 
_if195_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if195_exit
_if195_true:
; plural++; 
  lea d, [bp + -1] ; $plural
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $plural
  mov [d], b
  dec b
  jmp _if195_exit
_if195_exit:
; printf("The Federation is maintaining %d starbase%s in the galaxy\n\n", starbases_left, plural); 
  lea d, [bp + -1] ; $plural
  mov b, [d]
  swp b
  push b
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, _s148 ; "The Federation is maintaining %d starbase%s in the galaxy\n\n"
  swp b
  push b
  call printf
  add sp, 5
_if194_exit:
  leave
  ret

torpedo_data:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; const char *plural = str_s + 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $plural
  push d
  mov d, _str_s ; $str_s
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
; --- END LOCAL VAR INITIALIZATION
; struct klingon *k; 
  sub sp, 2
; if (no_klingon()) 
_if196_cond:
  call no_klingon
  cmp b, 0
  je _if196_exit
_if196_true:
; return; 
  leave
  ret
  jmp _if196_exit
_if196_exit:
; if (klingons > 1) 
_if197_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if197_exit
_if197_true:
; plural--; 
  lea d, [bp + -3] ; $plural
  mov b, [d]
  dec b
  lea d, [bp + -3] ; $plural
  mov [d], b
  inc b
  jmp _if197_exit
_if197_exit:
; printf("From Enterprise to Klingon battlecriuser%s:\n\n", plural); 
  lea d, [bp + -3] ; $plural
  mov b, [d]
  swp b
  push b
  mov b, _s149 ; "From Enterprise to Klingon battlecriuser%s:\n\n"
  swp b
  push b
  call printf
  add sp, 4
; k = kdata; 
  lea d, [bp + -5] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; for (i = 0; i <= 2; i++) { 
_for198_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for198_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for198_exit
_for198_block:
; if (k->energy > 0) { 
_if199_cond:
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
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
  je _if199_exit
_if199_true:
; compute_vector(TO_FIXED00(k->y), 
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  swp b
  push b
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  swp b
  push b
  call compute_vector
  add sp, 8
  jmp _if199_exit
_if199_exit:
; k++; 
  lea d, [bp + -5] ; $k
  mov b, [d]
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  dec b
  dec b
_for198_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for198_cond
_for198_exit:
  leave
  ret

nav_data:
  enter 0 ; (push bp; mov bp, sp)
; if (starbases <= 0) { 
_if200_cond:
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if200_exit
_if200_true:
; puts("Mr. Spock reports,\n  Sensors show no starbases in this quadrant.\n"); 
  mov b, _s150 ; "Mr. Spock reports,\n  Sensors show no starbases in this quadrant.\n"
  swp b
  push b
  call puts
  add sp, 2
; return; 
  leave
  ret
  jmp _if200_exit
_if200_exit:
; compute_vector(TO_FIXED00(base_y), TO_FIXED00(base_x), ship_y, ship_x); 
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  mov d, _base_x ; $base_x
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  swp b
  push b
  mov d, _base_y ; $base_y
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  swp b
  push b
  call compute_vector
  add sp, 8
  leave
  ret

dirdist_calc:
  enter 0 ; (push bp; mov bp, sp)
; int       c1, a, w1, x; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; printf("Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: ", 
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  swp b
  push b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  swp b
  push b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  swp b
  push b
  mov b, _s151 ; "Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: "
  swp b
  push b
  call printf
  add sp, 10
; c1 = TO_FIXED00(input_int()); 
  lea d, [bp + -1] ; $c1
  push d
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
; if (c1 < 0 || c1 > 900 ) 
_if201_cond:
  lea d, [bp + -1] ; $c1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $c1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if201_exit
_if201_true:
; return; 
  leave
  ret
  jmp _if201_exit
_if201_exit:
; puts("Please enter initial Y coordinate: "); 
  mov b, _s152 ; "Please enter initial Y coordinate: "
  swp b
  push b
  call puts
  add sp, 2
; a = TO_FIXED00(input_int()); 
  lea d, [bp + -3] ; $a
  push d
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
; if (a < 0 || a > 900) 
_if202_cond:
  lea d, [bp + -3] ; $a
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $a
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if202_exit
_if202_true:
; return; 
  leave
  ret
  jmp _if202_exit
_if202_exit:
; puts("Please enter final X coordinate: "); 
  mov b, _s153 ; "Please enter final X coordinate: "
  swp b
  push b
  call puts
  add sp, 2
; w1 = TO_FIXED00(input_int()); 
  lea d, [bp + -5] ; $w1
  push d
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
; if (w1 < 0 || w1 > 900) 
_if203_cond:
  lea d, [bp + -5] ; $w1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -5] ; $w1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if203_exit
_if203_true:
; return; 
  leave
  ret
  jmp _if203_exit
_if203_exit:
; puts("Please enter final Y coordinate: "); 
  mov b, _s154 ; "Please enter final Y coordinate: "
  swp b
  push b
  call puts
  add sp, 2
; x = TO_FIXED00(input_int()); 
  lea d, [bp + -7] ; $x
  push d
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
; if (x < 0 || x > 900) 
_if204_cond:
  lea d, [bp + -7] ; $x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -7] ; $x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if204_exit
_if204_true:
; return; 
  leave
  ret
  jmp _if204_exit
_if204_exit:
; compute_vector(w1, x, c1, a); 
  lea d, [bp + -3] ; $a
  mov b, [d]
  swp b
  push b
  lea d, [bp + -1] ; $c1
  mov b, [d]
  swp b
  push b
  lea d, [bp + -7] ; $x
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $w1
  mov b, [d]
  swp b
  push b
  call compute_vector
  add sp, 8
  leave
  ret

galaxy_map:
  enter 0 ; (push bp; mov bp, sp)
; int i, j, j0; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; printf("\n                   The Galaxy\n\n"); 
  mov b, _s155 ; "\n                   The Galaxy\n\n"
  swp b
  push b
  call printf
  add sp, 2
; printf("    1     2     3     4     5     6     7     8\n"); 
  mov b, _s156 ; "    1     2     3     4     5     6     7     8\n"
  swp b
  push b
  call printf
  add sp, 2
; for (i = 1; i <= 8; i++) { 
_for205_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for205_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for205_exit
_for205_block:
; printf("%s%d ", gm_1, i); 
  lea d, [bp + -1] ; $i
  mov b, [d]
  swp b
  push b
  mov d, _gm_1 ; $gm_1
  mov b, [d]
  swp b
  push b
  mov b, _s157 ; "%s%d "
  swp b
  push b
  call printf
  add sp, 6
; quadrant_name(1, i, 1); 
  mov b, $1
  push bl
  lea d, [bp + -1] ; $i
  mov b, [d]
  push bl
  mov b, $1
  push bl
  call quadrant_name
  add sp, 3
; j0 = (int) (11 - (strlen(quadname) / 2)); 
  lea d, [bp + -5] ; $j0
  push d
  mov b, $b
; --- START TERMS
  push a
  mov a, b
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strlen
  add sp, 2
; --- START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for (j = 0; j < j0; j++) 
_for206_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for206_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for206_exit
_for206_block:
; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
_for206_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  dec b
  jmp _for206_cond
_for206_exit:
; puts(quadname); 
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call puts
  add sp, 2
; for (j = 0; j < j0; j++) 
_for207_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for207_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for207_exit
_for207_block:
; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
_for207_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  dec b
  jmp _for207_cond
_for207_exit:
; if (!(strlen(quadname) % 2)) 
_if208_cond:
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strlen
  add sp, 2
; --- START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if208_exit
_if208_true:
; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
  jmp _if208_exit
_if208_exit:
; quadrant_name(1, i, 5); 
  mov b, $5
  push bl
  lea d, [bp + -1] ; $i
  mov b, [d]
  push bl
  mov b, $1
  push bl
  call quadrant_name
  add sp, 3
; j0 = (int) (12 - (strlen(quadname) / 2)); 
  lea d, [bp + -5] ; $j0
  push d
  mov b, $c
; --- START TERMS
  push a
  mov a, b
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strlen
  add sp, 2
; --- START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for (j = 0; j < j0; j++) 
_for209_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for209_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for209_exit
_for209_block:
; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
_for209_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  dec b
  jmp _for209_cond
_for209_exit:
; puts(quadname); 
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call puts
  add sp, 2
_for205_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for205_cond
_for205_exit:
; puts(gm_1); 
  mov d, _gm_1 ; $gm_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
  leave
  ret

compute_vector:
  enter 0 ; (push bp; mov bp, sp)
; long unsigned int        xl, al; 
  sub sp, 4
  sub sp, 4
; puts("  DIRECTION = "); 
  mov b, _s158 ; "  DIRECTION = "
  swp b
  push b
  call puts
  add sp, 2
; x = x - a; 
  lea d, [bp + 7] ; $x
  push d
  lea d, [bp + 7] ; $x
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 11] ; $a
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; a = c1 - w1; 
  lea d, [bp + 11] ; $a
  push d
  lea d, [bp + 9] ; $c1
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $w1
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; xl = abs(x); 
  lea d, [bp + -3] ; $xl
  push d
  lea d, [bp + 7] ; $x
  mov b, [d]
  swp b
  push b
  call abs
  add sp, 2
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; al = abs(a); 
  lea d, [bp + -7] ; $al
  push d
  lea d, [bp + 11] ; $a
  mov b, [d]
  swp b
  push b
  call abs
  add sp, 2
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; if (x < 0) { 
_if210_cond:
  lea d, [bp + 7] ; $x
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
  je _if210_else
_if210_true:
; if (a > 0) { 
_if211_cond:
  lea d, [bp + 11] ; $a
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
  je _if211_else
_if211_true:
; c1 = 300; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $12c
  pop d
  mov [d], b
; if (al >= xl) 
_if212_cond:
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sgeu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if212_else
_if212_true:
; printf("%s", print100(c1 + ((xl * 100) / al))); 
  lea d, [bp + 9] ; $c1
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  div a, b
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
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, _s159 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if212_exit
_if212_else:
; printf("%s", print100(c1 + ((((xl * 2) - al) * 100)  / xl))); 
  lea d, [bp + 9] ; $c1
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $2
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub a, b
  mov b, a
  pop g
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  div a, b
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
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, _s159 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
_if212_exit:
; printf(dist_1, print100((x > a) ? x : a)); 
_ternary216_cond:
  lea d, [bp + 7] ; $x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 11] ; $a
  mov b, [d]
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary216_false
_ternary216_true:
  lea d, [bp + 7] ; $x
  mov b, [d]
  jmp _ternary216_exit
_ternary216_false:
  lea d, [bp + 11] ; $a
  mov b, [d]
_ternary216_exit:
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov d, _dist_1 ; $dist_1
  mov b, [d]
  swp b
  push b
  call printf
  add sp, 4
; return; 
  leave
  ret
  jmp _if211_exit
_if211_else:
; if (x != 0){ 
_if217_cond:
  lea d, [bp + 7] ; $x
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if217_else
_if217_true:
; c1 = 500; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $1f4
  pop d
  mov [d], b
; return; 
  leave
  ret
  jmp _if217_exit
_if217_else:
; c1 = 700; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $2bc
  pop d
  mov [d], b
_if217_exit:
_if211_exit:
  jmp _if210_exit
_if210_else:
; if (a < 0) { 
_if218_cond:
  lea d, [bp + 11] ; $a
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
  je _if218_else
_if218_true:
; c1 = 700; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $2bc
  pop d
  mov [d], b
  jmp _if218_exit
_if218_else:
; if (x > 0) { 
_if219_cond:
  lea d, [bp + 7] ; $x
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
  je _if219_else
_if219_true:
; c1 = 100; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if219_exit
_if219_else:
; if (a == 0) { 
_if220_cond:
  lea d, [bp + 11] ; $a
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
  je _if220_else
_if220_true:
; c1 = 500; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $1f4
  pop d
  mov [d], b
  jmp _if220_exit
_if220_else:
; c1 = 100; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $64
  pop d
  mov [d], b
; if (al <= xl) 
_if221_cond:
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sleu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if221_else
_if221_true:
; printf("%s", print100(c1 + ((al * 100) / xl))); 
  lea d, [bp + 9] ; $c1
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  div a, b
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
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, _s159 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if221_exit
_if221_else:
; printf("%s", print100(c1 + ((((al * 2) - xl) * 100) / al))); 
  lea d, [bp + 9] ; $c1
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $2
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub a, b
  mov b, a
  pop g
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  div a, b
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
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, _s159 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
_if221_exit:
; printf(dist_1, print100((xl > al) ? xl : al)); 
_ternary225_cond:
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sgu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary225_false
_ternary225_true:
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  jmp _ternary225_exit
_ternary225_false:
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
_ternary225_exit:
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov d, _dist_1 ; $dist_1
  mov b, [d]
  swp b
  push b
  call printf
  add sp, 4
_if220_exit:
_if219_exit:
_if218_exit:
_if210_exit:
  leave
  ret

ship_destroyed:
  enter 0 ; (push bp; mov bp, sp)
; puts("The Enterprise has been destroyed. The Federation will be conquered.\n"); 
  mov b, _s160 ; "The Enterprise has been destroyed. The Federation will be conquered.\n"
  swp b
  push b
  call puts
  add sp, 2
; end_of_time(); 
  call end_of_time
  leave
  ret

end_of_time:
  enter 0 ; (push bp; mov bp, sp)
; printf("It is stardate %d.\n\n",  FROM_FIXED(stardate)); 
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
  swp b
  push b
  mov b, _s161 ; "It is stardate %d.\n\n"
  swp b
  push b
  call printf
  add sp, 4
; resign_commision(); 
  call resign_commision
  leave
  ret

resign_commision:
  enter 0 ; (push bp; mov bp, sp)
; printf("There were %d Klingon Battlecruisers left at the end of your mission.\n\n", klingons_left); 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, _s162 ; "There were %d Klingon Battlecruisers left at the end of your mission.\n\n"
  swp b
  push b
  call printf
  add sp, 3
; end_of_game(); 
  call end_of_game
  leave
  ret

won_game:
  enter 0 ; (push bp; mov bp, sp)
; puts("Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n"); 
  mov b, _s163 ; "Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n"
  swp b
  push b
  call puts
  add sp, 2
; if (FROM_FIXED(stardate) - time_start > 0) 
_if226_cond:
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if226_exit
_if226_true:
; printf("Your efficiency rating is %s\n", 
  mov d, _total_klingons ; $total_klingons
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- START FACTORS
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  swp b
  push b
  call square00
  add sp, 2
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, _s164 ; "Your efficiency rating is %s\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if226_exit
_if226_exit:
; end_of_game(); 
  call end_of_game
  leave
  ret

end_of_game:
  enter 0 ; (push bp; mov bp, sp)
; char x[4]; 
  sub sp, 4
; if (starbases_left > 0) { 
_if227_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if227_exit
_if227_true:
; puts("The Federation is in need of a new starship commander"); 
  mov b, _s165 ; "The Federation is in need of a new starship commander"
  swp b
  push b
  call puts
  add sp, 2
; puts(" for a similar mission.\n"); 
  mov b, _s166 ; " for a similar mission.\n"
  swp b
  push b
  call puts
  add sp, 2
; puts("If there is a volunteer, let him step forward and"); 
  mov b, _s167 ; "If there is a volunteer, let him step forward and"
  swp b
  push b
  call puts
  add sp, 2
; puts(" enter aye: "); 
  mov b, _s168 ; " enter aye: "
  swp b
  push b
  call puts
  add sp, 2
; input(x,4); 
  mov b, $4
  push bl
  lea d, [bp + -3] ; $x
  mov b, d
  swp b
  push b
  call input
  add sp, 3
; if (!strncmp(x, "aye", 3)) 
_if228_cond:
  mov b, $3
  swp b
  push b
  mov b, _s169 ; "aye"
  swp b
  push b
  lea d, [bp + -3] ; $x
  mov b, d
  swp b
  push b
  call strncmp
  add sp, 6
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if228_exit
_if228_true:
; new_game(); 
  call new_game
  jmp _if228_exit
_if228_exit:
  jmp _if227_exit
_if227_exit:
; exit(); 
  call exit
  leave
  ret

klingons_move:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; k = &kdata; 
  lea d, [bp + -3] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; for (i = 0; i <= 2; i++) { 
_for229_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for229_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for229_exit
_for229_block:
; if (k->energy > 0) { 
_if230_cond:
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 2
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
  je _if230_exit
_if230_true:
; wipe_klingon(k); 
  lea d, [bp + -3] ; $k
  mov b, [d]
  swp b
  push b
  call wipe_klingon
  add sp, 2
; find_set_empty_place( 	3        , &k->y, &k->x); 
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 1
  mov b, d
  swp b
  push b
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 0
  mov b, d
  swp b
  push b
  mov b, $3
  push bl
  call find_set_empty_place
  add sp, 5
  jmp _if230_exit
_if230_exit:
; k++; 
  lea d, [bp + -3] ; $k
  mov b, [d]
  inc b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  dec b
  dec b
_for229_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for229_cond
_for229_exit:
; klingons_shoot(); 
  call klingons_shoot
  leave
  ret

klingons_shoot:
  enter 0 ; (push bp; mov bp, sp)
; unsigned char                         r; 
  sub sp, 1
; long unsigned int        h; 
  sub sp, 4
; unsigned char                         i; 
  sub sp, 1
; struct klingon *k; 
  sub sp, 2
; long unsigned int        ratio; 
  sub sp, 4
; k = &kdata; 
  lea d, [bp + -7] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; if (klingons <= 0) 
_if231_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if231_exit
_if231_true:
; return; 
  leave
  ret
  jmp _if231_exit
_if231_exit:
; if (docked) { 
_if232_cond:
  mov d, _docked ; $docked
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if232_exit
_if232_true:
; puts("Starbase shields protect the Enterprise\n"); 
  mov b, _s170 ; "Starbase shields protect the Enterprise\n"
  swp b
  push b
  call puts
  add sp, 2
; return; 
  leave
  ret
  jmp _if232_exit
_if232_exit:
; for (i = 0; i <= 2; i++) { 
_for233_init:
  lea d, [bp + -5] ; $i
  push d
  mov b, $0
  pop d
  mov [d], bl
_for233_cond:
  lea d, [bp + -5] ; $i
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for233_exit
_for233_block:
; if (k->energy > 0) { 
_if234_cond:
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
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
  je _if234_exit
_if234_true:
; h = k->energy * (200UL + get_rand(100)); 
  lea d, [bp + -4] ; $h
  push d
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, 200
  mov c, 0
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
  add a, b
  push a
  mov a, g
  mov b, c
  adc a, b
  mov c, a
  pop b
  pop g
  pop a
; --- END TERMS
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; h =h* 100;	/* Ready for division in fixed */ 
  lea d, [bp + -4] ; $h
  push d
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; h =h/ distance_to(k); 
  lea d, [bp + -4] ; $h
  push d
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -7] ; $k
  mov b, [d]
  swp b
  push b
  call distance_to
  add sp, 2
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; shield = shield - FROM_FIXED00(h); 
  mov d, _shield ; $shield
  push d
  mov d, _shield ; $shield
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; k->energy = (k->energy * 100) / (300 + get_rand(100)); 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  push d
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  mov a, b
  mov b, $12c
; --- START TERMS
  push a
  mov a, b
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
  add b, a
  pop a
; --- END TERMS
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; printf("%d unit hit on Enterprise from sector %d, %d\n", (unsigned)FROM_FIXED00(h), k->y, k->x); 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  push bl
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  push bl
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  swp b
  push b
  mov b, _s171 ; "%d unit hit on Enterprise from sector %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; if (shield <= 0) { 
_if235_cond:
  mov d, _shield ; $shield
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if235_exit
_if235_true:
; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
; ship_destroyed(); 
  call ship_destroyed
  jmp _if235_exit
_if235_exit:
; printf("    <Shields down to %d units>\n\n", shield); 
  mov d, _shield ; $shield
  mov b, [d]
  swp b
  push b
  mov b, _s172 ; "    <Shields down to %d units>\n\n"
  swp b
  push b
  call printf
  add sp, 4
; if (h >= 20) { 
_if236_cond:
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $14
  mov c, 0
  sgeu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if236_exit
_if236_true:
; ratio = ((int)h)/shield; 
  lea d, [bp + -11] ; $ratio
  push d
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; if (get_rand(10) <= 6 && ratio > 2) { 
_if237_cond:
  mov b, $a
  swp b
  push b
  call get_rand
  add sp, 2
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $6
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -11] ; $ratio
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $2
  mov c, 0
  sgu
  pop g
  pop a
; --- END RELATIONAL
  mov g, 0
  sand32 ga, cb
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if237_exit
_if237_true:
; r = rand8(); 
  lea d, [bp + 0] ; $r
  push d
  call rand8
  pop d
  mov [d], bl
; damage[r] =damage[r] - ratio + get_rand(50); 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $ratio
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub a, b
  mov b, a
  mov a, b
  mov g, c
  mov b, $32
  swp b
  push b
  call get_rand
  add sp, 2
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
  mov [d], b
; printf("Damage Control reports\n%s damaged by hit\n\n", get_device_name(r)); 
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, _s173 ; "Damage Control reports\n%s damaged by hit\n\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if237_exit
_if237_exit:
  jmp _if236_exit
_if236_exit:
  jmp _if234_exit
_if234_exit:
; k++; 
  lea d, [bp + -7] ; $k
  mov b, [d]
  inc b
  inc b
  lea d, [bp + -7] ; $k
  mov [d], b
  dec b
  dec b
_for233_update:
  lea d, [bp + -5] ; $i
  mov bl, [d]
  mov bh, 0
  inc b
  lea d, [bp + -5] ; $i
  mov [d], b
  dec b
  jmp _for233_cond
_for233_exit:
  leave
  ret

repair_damage:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int d1; 
  sub sp, 2
; unsigned int        repair_factor;		/* Repair Factor */ 
  sub sp, 2
; repair_factor = warp; 
  lea d, [bp + -5] ; $repair_factor
  push d
  lea d, [bp + 5] ; $warp
  mov b, [d]
  pop d
  mov [d], b
; if (warp >= 100) 
_if238_cond:
  lea d, [bp + 5] ; $warp
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if238_exit
_if238_true:
; repair_factor = TO_FIXED00(1); 
  lea d, [bp + -5] ; $repair_factor
  push d
  mov b, $1
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
  jmp _if238_exit
_if238_exit:
; for (i = 1; i <= 8; i++) { 
_for239_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for239_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for239_exit
_for239_block:
; if (damage[i] < 0) { 
_if240_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if240_exit
_if240_true:
; damage[i] = damage[i] + repair_factor; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $repair_factor
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (damage[i] > -10 && damage[i] < 0)	/* -0.1 */ 
_if241_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $fff6
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if241_else
_if241_true:
; damage[i] = -10; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $a
  neg b
  pop d
  mov [d], b
  jmp _if241_exit
_if241_else:
; if (damage[i] >= 0) { 
_if242_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if242_exit
_if242_true:
; if (d1 != 1) { 
_if243_cond:
  lea d, [bp + -3] ; $d1
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if243_exit
_if243_true:
; d1 = 1; 
  lea d, [bp + -3] ; $d1
  push d
  mov b, $1
  pop d
  mov [d], b
; puts(dcr_1); 
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
  jmp _if243_exit
_if243_exit:
; printf("    %s repair completed\n\n", 
  lea d, [bp + -1] ; $i
  mov b, [d]
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, _s174 ; "    %s repair completed\n\n"
  swp b
  push b
  call printf
  add sp, 4
; damage[i] = 0; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if242_exit
_if242_exit:
_if241_exit:
  jmp _if240_exit
_if240_exit:
_for239_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for239_cond
_for239_exit:
; unsigned char                         r; 
  sub sp, 1
; if (get_rand(10) <= 2) { 
_if244_cond:
  mov b, $a
  swp b
  push b
  call get_rand
  add sp, 2
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if244_exit
_if244_true:
; r = rand8(); 
  lea d, [bp + -6] ; $r
  push d
  call rand8
  pop d
  mov [d], bl
; if (get_rand(10) < 6) { 
_if245_cond:
  mov b, $a
  swp b
  push b
  call get_rand
  add sp, 2
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $6
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if245_else
_if245_true:
; damage[r] =damage[r]- (get_rand(500) + 100); 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $1f4
  swp b
  push b
  call get_rand
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov b, $64
  add b, a
  pop a
; --- END TERMS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; puts(dcr_1); 
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
; printf("    %s damaged\n\n", get_device_name(r)); 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, _s175 ; "    %s damaged\n\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if245_exit
_if245_else:
; damage[r] = damage[r] + get_rand(300) + 100; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $12c
  swp b
  push b
  call get_rand
  add sp, 2
  add b, a
  mov a, b
  mov b, $64
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; puts(dcr_1); 
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
; printf("    %s state of repair improved\n\n", 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, _s176 ; "    %s state of repair improved\n\n"
  swp b
  push b
  call printf
  add sp, 4
_if245_exit:
  jmp _if244_exit
_if244_exit:
  leave
  ret

find_set_empty_place:
  enter 0 ; (push bp; mov bp, sp)
; unsigned char                         r1, r2; 
  sub sp, 1
  sub sp, 1
; do { 
_do246_block:
; r1 = rand8(); 
  lea d, [bp + 0] ; $r1
  push d
  call rand8
  pop d
  mov [d], bl
; r2 = rand8(); 
  lea d, [bp + -1] ; $r2
  push d
  call rand8
  pop d
  mov [d], bl
; } while (quad[r1-1][r2-1] !=  		0       ); 
_do246_cond:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
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
  cmp b, 1
  je _do246_block
_do246_exit:
; quad[r1-1][r2-1] = t; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $t
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
; if (z1) 
_if247_cond:
  lea d, [bp + 6] ; $z1
  mov b, [d]
  cmp b, 0
  je _if247_exit
_if247_true:
; *z1 = r1; 
  lea d, [bp + 6] ; $z1
  mov b, [d]
  push b
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _if247_exit
_if247_exit:
; if (z2) 
_if248_cond:
  lea d, [bp + 8] ; $z2
  mov b, [d]
  cmp b, 0
  je _if248_exit
_if248_true:
; *z2 = r2; 
  lea d, [bp + 8] ; $z2
  mov b, [d]
  push b
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _if248_exit
_if248_exit:
  leave
  ret

get_device_name:
  enter 0 ; (push bp; mov bp, sp)
; if (n < 0 || n > 8) 
_if249_cond:
  lea d, [bp + 5] ; $n
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $n
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if249_exit
_if249_true:
; n = 0; 
  lea d, [bp + 5] ; $n
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if249_exit
_if249_exit:
; return device_name[n]; 
  mov d, _device_name_data ; $device_name
  push a
  push d
  lea d, [bp + 5] ; $n
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  leave
  ret

quadrant_name:
  enter 0 ; (push bp; mov bp, sp)
; static char *sect_name[] = { "", " I", " II", " III", " IV" }; 
  sub sp, 20
; if (y < 1 || y > 8 || x < 1 || x > 8) 
_if250_cond:
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if250_exit
_if250_true:
; strcpy(quadname, "Unknown"); 
  mov b, _s181 ; "Unknown"
  swp b
  push b
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
  jmp _if250_exit
_if250_exit:
; if (x <= 4) 
_if251_cond:
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if251_else
_if251_true:
; strcpy(quadname, quad_name[y]); 
  mov d, _quad_name_data ; $quad_name
  push a
  push d
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
  jmp _if251_exit
_if251_else:
; strcpy(quadname, quad_name[y + 8]); 
  mov d, _quad_name_data ; $quad_name
  push a
  push d
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $8
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
_if251_exit:
; if (small != 1) { 
_if252_cond:
  lea d, [bp + 5] ; $small
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if252_exit
_if252_true:
; if (x > 4) 
_if253_cond:
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if253_exit
_if253_true:
; x = x - 4; 
  lea d, [bp + 7] ; $x
  push d
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  mov b, $4
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
  jmp _if253_exit
_if253_exit:
; strcat(quadname, sect_name[x]); 
  mov d, st_quadrant_name_sect_name_dt ; static sect_name
  push a
  push d
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strcat
  add sp, 4
  jmp _if252_exit
_if252_exit:
; return; 
  leave
  ret

isqrt:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int        b = 0x4000, q = 0, r = i, t; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $b
  push d
  mov b, $4000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $q
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -5] ; $r
  push d
  lea d, [bp + 5] ; $i
  mov b, [d]
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2
; while (b) { 
_while254_cond:
  lea d, [bp + -1] ; $b
  mov b, [d]
  cmp b, 0
  je _while254_exit
_while254_block:
; t = q + b; 
  lea d, [bp + -7] ; $t
  push d
  lea d, [bp + -3] ; $q
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $b
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; q =q>> 1; 
  lea d, [bp + -3] ; $q
  push d
  lea d, [bp + -3] ; $q
  mov b, [d]
; --- START SHIFT
  push a
  mov a, b
  mov b, $1
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  pop d
  mov [d], b
; if (r >= t) { 
_if255_cond:
  lea d, [bp + -5] ; $r
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $t
  mov b, [d]
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if255_exit
_if255_true:
; r =r- t; 
  lea d, [bp + -5] ; $r
  push d
  lea d, [bp + -5] ; $r
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $t
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; q = q + b; 
  lea d, [bp + -3] ; $q
  push d
  lea d, [bp + -3] ; $q
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $b
  mov b, [d]
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if255_exit
_if255_exit:
; b =b>> 2; 
  lea d, [bp + -1] ; $b
  push d
  lea d, [bp + -1] ; $b
  mov b, [d]
; --- START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  pop d
  mov [d], b
  jmp _while254_cond
_while254_exit:
; return q; 
  lea d, [bp + -3] ; $q
  mov b, [d]
  leave
  ret

square00:
  enter 0 ; (push bp; mov bp, sp)
; if (abs(t) > 181) { 
_if256_cond:
  lea d, [bp + 5] ; $t
  mov b, [d]
  swp b
  push b
  call abs
  add sp, 2
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $b5
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if256_else
_if256_true:
; t =t/ 10; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
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
; t =t* t; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $t
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  jmp _if256_exit
_if256_else:
; t =t* t; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $t
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; t =t/ 100; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  pop d
  mov [d], b
_if256_exit:
; return t; 
  lea d, [bp + 5] ; $t
  mov b, [d]
  leave
  ret

distance_to:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int        j; 
  sub sp, 2
; j = square00(TO_FIXED00(k->y) - ship_y); 
  lea d, [bp + -1] ; $j
  push d
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  swp b
  push b
  call square00
  add sp, 2
  pop d
  mov [d], b
; j = j + square00(TO_FIXED00(k->x) - ship_x); 
  lea d, [bp + -1] ; $j
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- START TERMS
  push a
  mov a, b
  mov d, _ship_x ; $ship_x
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  swp b
  push b
  call square00
  add sp, 2
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; j = isqrt(j); 
  lea d, [bp + -1] ; $j
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  swp b
  push b
  call isqrt
  add sp, 2
  pop d
  mov [d], b
; j =j* 10; 
  lea d, [bp + -1] ; $j
  push d
  lea d, [bp + -1] ; $j
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
  pop d
  mov [d], b
; return j; 
  lea d, [bp + -1] ; $j
  mov b, [d]
  leave
  ret

cint100:
  enter 0 ; (push bp; mov bp, sp)
; return (d + 50) / 100; 
  lea d, [bp + 5] ; $d
  mov b, [d]
; --- START TERMS
  push a
  mov a, b
  mov b, $32
  add b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  mov a, b
  mov b, $64
  div a, b
  mov b, a
  pop a
; --- END FACTORS
  leave
  ret

showfile:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_starbases: .fill 1, 0
_base_y: .fill 1, 0
_base_x: .fill 1, 0
_starbases_left: .fill 1, 0
_c_data: 
.db 
.db 
.db $0,$0,$0,$ffff,$ffff,$ffff,$0,$1,$1,$1,$0,$1,$1,$1,$0,$ffff,$ffff,$ffff,$0,$1,$1,
.fill 9, 0
_docked: .fill 1, 0
_energy: .fill 2, 0
_energy0: .dw 3000
_map_data: .fill 162, 0
_kdata_data: .fill 12, 0
_klingons: .fill 1, 0
_total_klingons: .fill 1, 0
_klingons_left: .fill 1, 0
_torps: .fill 1, 0
_torps0: .db 10
_quad_y: .fill 2, 0
_quad_x: .fill 2, 0
_shield: .fill 2, 0
_stars: .fill 1, 0
_time_start: .fill 2, 0
_time_up: .fill 2, 0
_damage_data: .fill 18, 0
_d4: .fill 2, 0
_ship_y: .fill 2, 0
_ship_x: .fill 2, 0
_stardate: .fill 2, 0
_quad_data: .fill 64, 0
_quadname_data: .fill 12, 0
_inc_1_data: .db "reports:\n  Incorrect course data, sir!\n", 0
_inc_1: .dw _inc_1_data
_quad_name_data: 
.dw 
.dw _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9, _s10, _s11, _s12, _s13, _s14, _s15, _s16, 
.fill 34, 0
_device_name_data: 
.dw 
.dw _s0, _s17, _s18, _s19, _s20, _s21, _s22, _s23, _s24, 
.fill 18, 0
_dcr_1_data: .db "Damage Control report:", 0
_dcr_1: .dw _dcr_1_data
_plural_2_data: 
.db 
.db $0,$0,
_plural_data: 
.db 
.db $69,$73,$0,
.fill 1, 0
_warpmax_data: 
.db 
.db $8,
.fill 3, 0
_srs_1_data: .db "------------------------", 0
_srs_1: .dw _srs_1_data
_tilestr_data: 
.dw 
.dw _s25, _s26, _s27, _s28, _s29, 
.fill 10, 0
_lrs_1_data: .db "-------------------\n", 0
_lrs_1: .dw _lrs_1_data
_gr_1_data: .db "   ----- ----- ----- ----- ----- ----- ----- -----\n", 0
_gr_1: .dw _gr_1_data
_str_s_data: .db "s", 0
_str_s: .dw _str_s_data
_gm_1_data: .db "  ----- ----- ----- ----- ----- ----- ----- -----\n", 0
_gm_1: .dw _gm_1_data
_dist_1_data: .db "  DISTANCE = \n\n", 0
_dist_1: .dw _dist_1_data
st_print100_buf_dt: .fill 16, 0
st_quadrant_name_sect_name_dt: 
.dw _s0, _s177, _s178, _s179, _s180, 
.fill 10, 0
st_quadrant_name_sect_name: .dw st_quadrant_name_sect_name_dt
_s0: .db "", 0
_s1: .db "Antares", 0
_s2: .db "Rigel", 0
_s3: .db "Procyon", 0
_s4: .db "Vega", 0
_s5: .db "Canopus", 0
_s6: .db "Altair", 0
_s7: .db "Sagittarius", 0
_s8: .db "Pollux", 0
_s9: .db "Sirius", 0
_s10: .db "Deneb", 0
_s11: .db "Capella", 0
_s12: .db "Betelgeuse", 0
_s13: .db "Aldebaran", 0
_s14: .db "Regulus", 0
_s15: .db "Arcturus", 0
_s16: .db "Spica", 0
_s17: .db "Warp engines", 0
_s18: .db "Short range sensors", 0
_s19: .db "Long range sensors", 0
_s20: .db "Phaser control", 0
_s21: .db "Photon tubes", 0
_s22: .db "Damage control", 0
_s23: .db "Shield control", 0
_s24: .db "Library computer", 0
_s25: .db "   ", 0
_s26: .db " * ", 0
_s27: .db ">!<", 0
_s28: .db "+K+", 0
_s29: .db "<*>", 0
_s30: .db "Unexpected format in printf.", 0
_s31: .db "Error: Unknown argument type.\n", 0
_s32: .db "\033[2J\033[H", 0
_s33: .db "%d.%d", 0
_s34: .db "are", 0
_s35: .db "is", 0
_s36: .db "%s %s inoperable.\n", 0
_s37: .db "startrek.intro", 0
_s38: .db "startrek.doc", 0
_s39: .db "startrek.logo", 0
_s40: .db "startrek.fatal", 0
_s41: .db "Command? ", 0
_s42: .db "nav", 0
_s43: .db "srs", 0
_s44: .db "lrs", 0
_s45: .db "pha", 0
_s46: .db "tor", 0
_s47: .db "shi", 0
_s48: .db "dam", 0
_s49: .db "com", 0
_s50: .db "xxx", 0
_s51: .db "Enter one of the following:\n", 0
_s52: .db "  nav - To Set Course", 0
_s53: .db "  srs - Short Range Sensors", 0
_s54: .db "  lrs - Long Range Sensors", 0
_s55: .db "  pha - Phasers", 0
_s56: .db "  tor - Photon Torpedoes", 0
_s57: .db "  shi - Shield Control", 0
_s58: .db "  dam - Damage Control", 0
_s59: .db "  com - Library Computer", 0
_s60: .db "  xxx - Resign Command\n", 0
_s61: .db "s", 0
_s62: .db "Your orders are as follows:\nDestroy the %d Klingon warships which have", 0
_s63: .db "invaded\n the galaxy before they can attack Federation Headquarters\n", 0
_s64: .db " on stardate %u. This gives you %d days. There %s\n %d starbase%s in the galaxy", 0
_s65: .db " for resupplying your ship.\n\n Hit any key to accept command. ", 0
_s66: .db "Now entering %s quadrant...\n\n", 0
_s67: .db "\nYour mission begins with your starship located", 0
_s68: .db "in the galactic quadrant %s.\n\n", 0
_s69: .db "Combat Area  Condition Red\n", 0
_s70: .db "Shields Dangerously Low\n", 0
_s71: .db "Course (0-9): ", 0
_s72: .db "Lt. Sulu%s", 0
_s73: .db "0.2", 0
_s74: .db "Warp Factor (0-%s): ", 0
_s75: .db "Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n", 0
_s76: .db "Chief Engineer Scott reports:\n  The engines wont take warp %s!\n\n", 0
_s77: .db "Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n", 0
_s78: .db "Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n", 0
_s79: .db "LT. Uhura reports:\n Message from Starfleet Command:\n\n ", 0
_s80: .db "Permission to attempt crossing of galactic perimeter\n is hereby *denied*. ", 0
_s81: .db "Shut down your engines.\n\n Chief Engineer Scott reports:\n ", 0
_s82: .db "Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n", 0
_s83: .db "Warp Engines shut down at sector %d, %d due to bad navigation.\n\n", 0
_s84: .db "Shield Control supplies energy to complete maneuver.\n", 0
_s85: .db "GREEN", 0
_s86: .db "YELLOW", 0
_s87: .db "*RED*", 0
_s88: .db "DOCKED", 0
_s89: .db "Shields dropped for docking purposes.", 0
_s90: .db "\n*** Short Range Sensors are out ***", 0
_s91: .db "    Stardate            %d\n", 0
_s92: .db "    Condition           %s\n", 0
_s93: .db "    Quadrant            %d, %d\n", 0
_s94: .db "    Sector              %d, %d\n", 0
_s95: .db "    Photon Torpedoes    %d\n", 0
_s96: .db "    Total Energy        %d\n", 0
_s97: .db "    Shields             %d\n", 0
_s98: .db "    Klingons Remaining  %d\n", 0
_s99: .db "Long Range Scan for Quadrant %d, %d\n\n", 0
_s100: .db "%s:", 0
_s101: .db "***", 0
_s102: .db " :", 0
_s103: .db "%s\n", 0
_s104: .db "Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n", 0
_s105: .db "Computer failure hampers accuracy.", 0
_s106: .db "Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: ", 0
_s107: .db "Not enough energy available.\n", 0
_s108: .db "Sensors show no damage to enemy at %d, %d\n\n", 0
_s109: .db "%d unit hit on Klingon at sector %d, %d\n", 0
_s110: .db "*** Klingon Destroyed ***\n", 0
_s111: .db "   (Sensors show %d units remaining.)\n\n", 0
_s112: .db "All photon torpedoes expended", 0
_s113: .db "Ensign Chekov%s", 0
_s114: .db "Torpedo Track:", 0
_s115: .db "    %d, %d\n", 0
_s116: .db "Torpedo Missed\n", 0
_s117: .db "Star at %d, %d absorbed torpedo energy.\n\n", 0
_s118: .db "*** Starbase Destroyed ***", 0
_s119: .db "That does it, Captain!!", 0
_s120: .db "You are hereby relieved of command\n", 0
_s121: .db "and sentenced to 99 stardates of hard", 0
_s122: .db "labor on Cygnus 12!!\n", 0
_s123: .db "Starfleet Command reviewing your record to consider\n court martial!\n", 0
_s124: .db "Damage Control report not available.", 0
_s125: .db "\nTechnicians standing by to effect repairs to your ship;\n", 0
_s126: .db "Estimated time to repair: %s stardates.\n Will you authorize the repair order (y/N)? ", 0
_s127: .db "Device            State of Repair", 0
_s128: .db "%-25s%6s\n", 0
_s129: .db "\n", 0
_s130: .db "Energy available = %d\n\n Input number of units to shields: ", 0
_s131: .db "<Shields Unchanged>\n", 0
_s132: .db "Shield Control Reports:\n  This is not the Federation Treasury.", 0
_s133: .db "Deflector Control Room report:\n  Shields now at %d units per your command.\n\n", 0
_s134: .db "Computer active and awating command: ", 0
_s135: .db "Functions available from Library-Computer:\n\n", 0
_s136: .db "   0 = Cumulative Galactic Record\n", 0
_s137: .db "   1 = Status Report\n", 0
_s138: .db "   2 = Photon Torpedo Data\n", 0
_s139: .db "   3 = Starbase Nav Data\n", 0
_s140: .db "   4 = Direction/Distance Calculator\n", 0
_s141: .db "   5 = Galaxy Region Name Map\n", 0
_s142: .db "\n     Computer Record of Galaxy for Quadrant %d,%d\n\n", 0
_s143: .db "     1     2     3     4     5     6     7     8", 0
_s144: .db "%s%d", 0
_s145: .db "   Status Report:\n", 0
_s146: .db "Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n", 0
_s147: .db "Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n", 0
_s148: .db "The Federation is maintaining %d starbase%s in the galaxy\n\n", 0
_s149: .db "From Enterprise to Klingon battlecriuser%s:\n\n", 0
_s150: .db "Mr. Spock reports,\n  Sensors show no starbases in this quadrant.\n", 0
_s151: .db "Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: ", 0
_s152: .db "Please enter initial Y coordinate: ", 0
_s153: .db "Please enter final X coordinate: ", 0
_s154: .db "Please enter final Y coordinate: ", 0
_s155: .db "\n                   The Galaxy\n\n", 0
_s156: .db "    1     2     3     4     5     6     7     8\n", 0
_s157: .db "%s%d ", 0
_s158: .db "  DIRECTION = ", 0
_s159: .db "%s", 0
_s160: .db "The Enterprise has been destroyed. The Federation will be conquered.\n", 0
_s161: .db "It is stardate %d.\n\n", 0
_s162: .db "There were %d Klingon Battlecruisers left at the end of your mission.\n\n", 0
_s163: .db "Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n", 0
_s164: .db "Your efficiency rating is %s\n", 0
_s165: .db "The Federation is in need of a new starship commander", 0
_s166: .db " for a similar mission.\n", 0
_s167: .db "If there is a volunteer, let him step forward and", 0
_s168: .db " enter aye: ", 0
_s169: .db "aye", 0
_s170: .db "Starbase shields protect the Enterprise\n", 0
_s171: .db "%d unit hit on Enterprise from sector %d, %d\n", 0
_s172: .db "    <Shields down to %d units>\n\n", 0
_s173: .db "Damage Control reports\n%s damaged by hit\n\n", 0
_s174: .db "    %s repair completed\n\n", 0
_s175: .db "    %s damaged\n\n", 0
_s176: .db "    %s state of repair improved\n\n", 0
_s177: .db " I", 0
_s178: .db " II", 0
_s179: .db " III", 0
_s180: .db " IV", 0
_s181: .db "Unknown", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
