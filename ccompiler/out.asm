; --- FILENAME: programs/wumpus
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; int c; 
  sub sp, 2 ; c
;; c = getlet("INSTRUCTIONS (Y-N): "); 
  lea d, [bp + -1] ; $c
  push d
  mov b, _s0 ; "INSTRUCTIONS (Y-N): "
  swp b
  push b
  call getlet
  add sp, 2
  pop d
  mov [d], b
;; if (c == 'Y') { 
_if1_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $59
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if1_exit
_if1_true:
;; print_instructions(); 
  call print_instructions
  jmp _if1_exit
_if1_exit:
;; do {  
_do2_block:
;; game_setup(); 
  call game_setup
;; game_play(); 
  call game_play
;; } while (getlet("NEW GAME (Y-N): ") != 'N'); 
_do2_cond:
  mov b, _s1 ; "NEW GAME (Y-N): "
  swp b
  push b
  call getlet
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $4e
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 1
  je _do2_block
_do2_exit:
;; return 0; 
  mov b, $0
  leave
  syscall sys_terminate_proc

strcpy:
  enter 0 ; (push bp; mov bp, sp)
;; char *psrc; 
  sub sp, 2 ; psrc
;; char *pdest; 
  sub sp, 2 ; pdest
;; psrc = src; 
  lea d, [bp + -1] ; $psrc
  push d
  lea d, [bp + 7] ; $src
  mov b, [d]
  pop d
  mov [d], b
;; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  pop d
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while3_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while3_exit
_while3_block:
;; *pdest++ = *psrc++; 
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
  jmp _while3_cond
_while3_exit:
;; *pdest = '\0'; 
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
;; while (*s1 && (*s1 == *s2)) { 
_while4_cond:
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
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
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  cmp b, 0
  je _while4_exit
_while4_block:
;; s1++; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $s1
  mov [d], b
  dec b
;; s2++; 
  lea d, [bp + 7] ; $s2
  mov b, [d]
  inc b
  lea d, [bp + 7] ; $s2
  mov [d], b
  dec b
  jmp _while4_cond
_while4_exit:
;; return *s1 - *s2; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
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
; END TERMS
  leave
  ret

strncmp:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

strcat:
  enter 0 ; (push bp; mov bp, sp)
;; int dest_len; 
  sub sp, 2 ; dest_len
;; int i; 
  sub sp, 2 ; i
;; dest_len = strlen(dest); 
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
;; for (i = 0; src[i] != 0; i=i+1) { 
_for5_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for5_cond:
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _for5_exit
_for5_block:
;; dest[dest_len + i] = src[i]; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add b, a
  pop a
; END TERMS
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
_for5_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _for5_cond
_for5_exit:
;; dest[dest_len + i] = 0; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
;; return dest; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
;; int length; 
  sub sp, 2 ; length
;; length = 0; 
  lea d, [bp + -1] ; $length
  push d
  mov b, $0
  pop d
  mov [d], b
;; while (str[length] != 0) { 
_while6_cond:
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while6_exit
_while6_block:
;; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  dec b
  jmp _while6_cond
_while6_exit:
;; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  syscall sys_terminate_proc
; --- END INLINE ASM BLOCK

  leave
  ret

memset:
  enter 0 ; (push bp; mov bp, sp)
;; int i; 
  sub sp, 2 ; i
;; for(i = 0; i < size; i++){ 
_for7_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for7_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 8] ; $size
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for7_exit
_for7_block:
;; *(s+i) = c; 
  lea d, [bp + 5] ; $s
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  pop a
; END TERMS
  push b
  lea d, [bp + 7] ; $c
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for7_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for7_cond
_for7_exit:
;; return s; 
  lea d, [bp + 5] ; $s
  mov b, [d]
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
;; int result = 0;  // Initialize result 
  sub sp, 2 ; result
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $result
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; int sign = 1;    // Initialize sign as positive 
  sub sp, 2 ; sign
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; while (*str == ' ') str++; 
_while8_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while8_exit
_while8_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while8_cond
_while8_exit:
;; if (*str == '-' || *str == '+') { 
_if9_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _if9_exit
_if9_true:
;; if (*str == '-') sign = -1; 
_if10_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if10_exit
_if10_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
  jmp _if10_exit
_if10_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _if9_exit
_if9_exit:
;; while (*str >= '0' && *str <= '9') { 
_while11_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  cmp b, 0
  je _while11_exit
_while11_block:
;; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while11_cond
_while11_exit:
;; return sign * result; 
  lea d, [bp + -3] ; $sign
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -1] ; $result
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  leave
  ret

rand:
  enter 0 ; (push bp; mov bp, sp)
;; int  sec; 
  sub sp, 2 ; sec

; --- BEGIN INLINE ASM BLOCK
  mov al, 0
  syscall sys_rtc					
  mov al, ah
  lea d, [bp + -1] ; $sec
  mov al, [d]
  mov ah, 0
; --- END INLINE ASM BLOCK

;; return sec; 
  lea d, [bp + -1] ; $sec
  mov b, [d]
  leave
  ret

alloc:
  enter 0 ; (push bp; mov bp, sp)
;; heap_top = heap_top + bytes; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

free:
  enter 0 ; (push bp; mov bp, sp)
;; return heap_top = heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  leave
  ret

fopen:
  enter 0 ; (push bp; mov bp, sp)
;; FILE *fp; 
  sub sp, 2 ; fp
;; fp = alloc(sizeof(int)); 
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
;; char *p, *format_p; 
  sub sp, 2 ; p
  sub sp, 2 ; format_p
;; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  pop d
  mov [d], b
;; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; for(;;){ 
_for12_init:
_for12_cond:
_for12_block:
;; if(!*format_p) break; 
_if13_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if13_else
_if13_true:
;; break; 
  jmp _for12_exit ; for break
  jmp _if13_exit
_if13_else:
;; if(*format_p == '%'){ 
_if14_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if14_else
_if14_true:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
;; switch(*format_p){ 
_switch15_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch15_comparisons:
  cmp bl, $6c
  je _switch15_case0
  cmp bl, $4c
  je _switch15_case1
  cmp bl, $64
  je _switch15_case2
  cmp bl, $69
  je _switch15_case3
  cmp bl, $75
  je _switch15_case4
  cmp bl, $78
  je _switch15_case5
  cmp bl, $63
  je _switch15_case6
  cmp bl, $73
  je _switch15_case7
  jmp _switch15_default
  jmp _switch15_exit
_switch15_case0:
_switch15_case1:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
;; if(*format_p == 'd' || *format_p == 'i') 
_if16_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $69
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _if16_else
_if16_true:
;; print_signed_long(*(long *)p); 
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
  jmp _if16_exit
_if16_else:
;; if(*format_p == 'u') 
_if17_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $75
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if17_else
_if17_true:
;; print_unsigned_long(*(unsigned long *)p); 
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
  jmp _if17_exit
_if17_else:
;; if(*format_p == 'x') 
_if18_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $78
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if18_else
_if18_true:
;; printx32(*(long int *)p); 
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
  jmp _if18_exit
_if18_else:
;; err("Unexpected format in printf."); 
  mov b, _s2 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if18_exit:
_if17_exit:
_if16_exit:
;; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $4
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch15_exit ; case break
_switch15_case2:
_switch15_case3:
;; print_signed(*(int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print_signed
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch15_exit ; case break
_switch15_case4:
;; print_unsigned(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print_unsigned
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch15_exit ; case break
_switch15_case5:

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov b, [d]
  call print_u16x
; --- END INLINE ASM BLOCK

;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch15_exit ; case break
_switch15_case6:

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM BLOCK

;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch15_exit ; case break
_switch15_case7:

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov d, [d]
  call _puts
; --- END INLINE ASM BLOCK

;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch15_exit ; case break
_switch15_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, _s3 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch15_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if14_exit
_if14_else:
;; putchar(*format_p); 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_if14_exit:
_if13_exit:
_for12_update:
  jmp _for12_cond
_for12_exit:
  leave
  ret

scanf:
  enter 0 ; (push bp; mov bp, sp)
;; char *p, *format_p; 
  sub sp, 2 ; p
  sub sp, 2 ; format_p
;; char c; 
  sub sp, 1 ; c
;; int i; 
  sub sp, 2 ; i
;; char input_string[  512                    ]; 
  sub sp, 512 ; input_string
;; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  pop d
  mov [d], b
;; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; for(;;){ 
_for19_init:
_for19_cond:
_for19_block:
;; if(!*format_p) break; 
_if20_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if20_else
_if20_true:
;; break; 
  jmp _for19_exit ; for break
  jmp _if20_exit
_if20_else:
;; if(*format_p == '%'){ 
_if21_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if21_else
_if21_true:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
;; switch(*format_p){ 
_switch22_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch22_comparisons:
  cmp bl, $6c
  je _switch22_case0
  cmp bl, $4c
  je _switch22_case1
  cmp bl, $64
  je _switch22_case2
  cmp bl, $69
  je _switch22_case3
  cmp bl, $75
  je _switch22_case4
  cmp bl, $78
  je _switch22_case5
  cmp bl, $63
  je _switch22_case6
  cmp bl, $73
  je _switch22_case7
  jmp _switch22_default
  jmp _switch22_exit
_switch22_case0:
_switch22_case1:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
;; if(*format_p == 'd' || *format_p == 'i'); 
_if23_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $69
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _if23_else
_if23_true:
;; ; 
  jmp _if23_exit
_if23_else:
;; if(*format_p == 'u'); 
_if24_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $75
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if24_else
_if24_true:
;; ; 
  jmp _if24_exit
_if24_else:
;; if(*format_p == 'x'); 
_if25_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $78
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if25_else
_if25_true:
;; ; 
  jmp _if25_exit
_if25_else:
;; err("Unexpected format in printf."); 
  mov b, _s2 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if25_exit:
_if24_exit:
_if23_exit:
;; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $4
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch22_exit ; case break
_switch22_case2:
_switch22_case3:
;; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
  call scann
  pop d
  mov [d], b
;; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  mov [d], b
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch22_exit ; case break
_switch22_case4:
;; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
  call scann
  pop d
  mov [d], b
;; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  mov [d], b
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch22_exit ; case break
_switch22_case5:
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch22_exit ; case break
_switch22_case6:
;; c = getchar(); 
  lea d, [bp + -4] ; $c
  push d
  call getchar
  pop d
  mov [d], bl
;; **(char **)p = c; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -4] ; $c
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], b
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch22_exit ; case break
_switch22_case7:
;; gets(input_string); 
  lea d, [bp + -518] ; $input_string
  mov b, d
  swp b
  push b
  call gets
  add sp, 2
;; strcpy(*(char **)p, input_string); 
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
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch22_exit ; case break
_switch22_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, _s3 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch22_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if21_exit
_if21_else:
;; putchar(*format_p); 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_if21_exit:
_if20_exit:
_for19_update:
  jmp _for19_cond
_for19_exit:
  leave
  ret

err:
  enter 0 ; (push bp; mov bp, sp)
;; print(e); 
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

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov b, [d+2]
  call print_u16x
  mov b, [d]
  call print_u16x
; --- END INLINE ASM BLOCK

  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov b, [d]
  call print_u16x
; --- END INLINE ASM BLOCK

  leave
  ret

printx8:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov bl, [d]
  call print_u8x
; --- END INLINE ASM BLOCK

  leave
  ret

hex_str_to_int:
  enter 0 ; (push bp; mov bp, sp)
;; int value = 0; 
  sub sp, 2 ; value
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $value
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; int i; 
  sub sp, 2 ; i
;; char hex_char; 
  sub sp, 1 ; hex_char
;; int len; 
  sub sp, 2 ; len
;; len = strlen(hex_string); 
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
;; for (i = 0; i < len; i++) { 
_for26_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for26_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for26_exit
_for26_block:
;; hex_char = hex_string[i]; 
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
;; if (hex_char >= 'a' && hex_char <= 'f')  
_if27_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $66
  cmp a, b
  sle ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  cmp b, 0
  je _if27_else
_if27_true:
;; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, a
  mov a, b
  mov b, $a
  add b, a
  pop a
; END TERMS
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if27_exit
_if27_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if28_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $46
  cmp a, b
  sle ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  cmp b, 0
  je _if28_else
_if28_true:
;; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, a
  mov a, b
  mov b, $a
  add b, a
  pop a
; END TERMS
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if28_exit
_if28_else:
;; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
_if28_exit:
_if27_exit:
_for26_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  dec b
  jmp _for26_cond
_for26_exit:
;; return value; 
  lea d, [bp + -1] ; $value
  mov b, [d]
  leave
  ret

gets:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _gets
; --- END INLINE ASM BLOCK

;; return strlen(s); 
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
;; char digits[5]; 
  sub sp, 5 ; digits
;; int i = 0; 
  sub sp, 2 ; i
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; if (num < 0) { 
_if29_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if29_else
_if29_true:
;; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
;; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  neg b
  pop d
  mov [d], b
  jmp _if29_exit
_if29_else:
;; if (num == 0) { 
_if30_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if30_exit
_if30_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if30_exit
_if30_exit:
_if29_exit:
;; while (num > 0) { 
_while31_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while31_exit
_while31_block:
;; digits[i] = '0' + (num % 10); 
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
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  dec b
  jmp _while31_cond
_while31_exit:
;; while (i > 0) { 
_while32_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while32_exit
_while32_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
;; putchar(digits[i]); 
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
  jmp _while32_cond
_while32_exit:
  leave
  ret

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
;; char digits[10]; 
  sub sp, 10 ; digits
;; int i = 0; 
  sub sp, 2 ; i
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; if (num < 0) { 
_if33_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
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
; END RELATIONAL
  cmp b, 0
  je _if33_else
_if33_true:
;; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
;; num = -num; 
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
  jmp _if33_exit
_if33_else:
;; if (num == 0) { 
_if34_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
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
; END RELATIONAL
  cmp b, 0
  je _if34_exit
_if34_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if34_exit
_if34_exit:
_if33_exit:
;; while (num > 0) { 
_while35_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  mov c, 0
  sgt
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _while35_exit
_while35_block:
;; digits[i] = '0' + (num % 10); 
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
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  push a
  mov a, g
  mov b, c
  adc a, b
  mov c, a
  pop b
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  dec b
  jmp _while35_cond
_while35_exit:
;; while (i > 0) { 
_while36_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while36_exit
_while36_block:
;; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  inc b
;; putchar(digits[i]); 
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
  jmp _while36_cond
_while36_exit:
  leave
  ret

print_unsigned_long:
  enter 0 ; (push bp; mov bp, sp)
;; char digits[10]; 
  sub sp, 10 ; digits
;; int i; 
  sub sp, 2 ; i
;; i = 0; 
  lea d, [bp + -11] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if37_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
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
; END RELATIONAL
  cmp b, 0
  je _if37_exit
_if37_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if37_exit
_if37_exit:
;; while (num > 0) { 
_while38_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  mov c, 0
  sgu
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _while38_exit
_while38_block:
;; digits[i] = '0' + (num % 10); 
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
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  push a
  mov a, g
  mov b, c
  adc a, b
  mov c, a
  pop b
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  dec b
  jmp _while38_cond
_while38_exit:
;; while (i > 0) { 
_while39_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while39_exit
_while39_block:
;; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  inc b
;; putchar(digits[i]); 
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
  jmp _while39_cond
_while39_exit:
  leave
  ret

print_unsigned:
  enter 0 ; (push bp; mov bp, sp)
;; char digits[5]; 
  sub sp, 5 ; digits
;; int i; 
  sub sp, 2 ; i
;; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if40_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if40_exit
_if40_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if40_exit
_if40_exit:
;; while (num > 0) { 
_while41_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while41_exit
_while41_block:
;; digits[i] = '0' + (num % 10); 
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
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  dec b
  jmp _while41_cond
_while41_exit:
;; while (i > 0) { 
_while42_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while42_exit
_while42_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  inc b
;; putchar(digits[i]); 
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
  jmp _while42_cond
_while42_exit:
  leave
  ret

date:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov al, 0 
  syscall sys_datetime
; --- END INLINE ASM BLOCK

  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM BLOCK

  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
;; char c; 
  sub sp, 1 ; c

; --- BEGIN INLINE ASM BLOCK
  call getch
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM BLOCK

;; return c; 
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  leave
  ret

scann:
  enter 0 ; (push bp; mov bp, sp)
;; int m; 
  sub sp, 2 ; m

; --- BEGIN INLINE ASM BLOCK
  call scan_u16d
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM BLOCK

;; return m; 
  lea d, [bp + -1] ; $m
  mov b, [d]
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _puts
  mov a, $0A00
  syscall sys_io
; --- END INLINE ASM BLOCK

  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov d, [d]
  call _puts
; --- END INLINE ASM BLOCK

  leave
  ret

getparam:
  enter 0 ; (push bp; mov bp, sp)
;; char data; 
  sub sp, 1 ; data

; --- BEGIN INLINE ASM BLOCK
  mov al, 4
  lea d, [bp + 5] ; $address
  mov d, [d]
  syscall sys_system
  lea d, [bp + 0] ; $data
  mov [d], bl
; --- END INLINE ASM BLOCK

;; return data; 
  lea d, [bp + 0] ; $data
  mov bl, [d]
  mov bh, 0
  leave
  ret

clear:
  enter 0 ; (push bp; mov bp, sp)
;; print("\033[2J\033[H"); 
  mov b, _s4 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
;; return i < 0 ? -i : i; 
_ternary43_cond:
  lea d, [bp + 5] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _ternary43_false
_ternary43_true:
  lea d, [bp + 5] ; $i
  mov b, [d]
  neg b
  jmp _ternary43_exit
_ternary43_false:
  lea d, [bp + 5] ; $i
  mov b, [d]
_ternary43_exit:
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/asm/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

include_ctype_lib:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/asm/ctype.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

is_space:
  enter 0 ; (push bp; mov bp, sp)
;; return c == ' ' || c == '\t' || c == '\n' || c == '\r'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $9
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  leave
  ret

is_digit:
  enter 0 ; (push bp; mov bp, sp)
;; return c >= '0' && c <= '9'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  leave
  ret

is_alpha:
  enter 0 ; (push bp; mov bp, sp)
;; return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_'); 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  leave
  ret

tolower:
  enter 0 ; (push bp; mov bp, sp)
;; if (ch >= 'A' && ch <= 'Z')  
_if44_cond:
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  cmp b, 0
  je _if44_else
_if44_true:
;; return ch - 'A' + 'a'; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, a
  mov a, b
  mov b, $61
  add b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if44_exit
_if44_else:
;; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if44_exit:
  leave
  ret

toupper:
  enter 0 ; (push bp; mov bp, sp)
;; if (ch >= 'a' && ch <= 'z')  
_if45_cond:
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  cmp b, 0
  je _if45_else
_if45_true:
;; return ch - 'a' + 'A'; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, a
  mov a, b
  mov b, $41
  add b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if45_exit
_if45_else:
;; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if45_exit:
  leave
  ret

is_delimiter:
  enter 0 ; (push bp; mov bp, sp)
;; if( 
_if46_cond:
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $23
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $29
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $21
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _if46_else
_if46_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if46_exit
_if46_else:
;; return 0; 
  mov b, $0
  leave
  ret
_if46_exit:
  leave
  ret

getnum:
  enter 0 ; (push bp; mov bp, sp)
;; int n; 
  sub sp, 2 ; n
;; print(prompt); 
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; n = scann(); 
  lea d, [bp + -1] ; $n
  push d
  call scann
  pop d
  mov [d], b
;; return n; 
  lea d, [bp + -1] ; $n
  mov b, [d]
  leave
  ret

getlet:
  enter 0 ; (push bp; mov bp, sp)
;; char c = '\n'; 
  sub sp, 1 ; c
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + 0] ; $c
  push d
  mov b, $a
  pop d
  mov [d], bl
; --- END LOCAL VAR INITIALIZATION
;; print(prompt); 
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; while (c == '\n') { 
_while47_cond:
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while47_exit
_while47_block:
;; c = getchar(); 
  lea d, [bp + 0] ; $c
  push d
  call getchar
  pop d
  mov [d], bl
  jmp _while47_cond
_while47_exit:
;; return toupper(c); 
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  push bl
  call toupper
  add sp, 1
  leave
  ret

print_instructions:
  enter 0 ; (push bp; mov bp, sp)
;; print("Welcome to 'hunt the wumpus'\n"); 
  mov b, _s5 ; "Welcome to 'hunt the wumpus'\n"
  swp b
  push b
  call print
  add sp, 2
;; print("The wumpus lives in a cave of 20 rooms. Each room\n"); 
  mov b, _s6 ; "The wumpus lives in a cave of 20 rooms. Each room\n"
  swp b
  push b
  call print
  add sp, 2
;; print("has 3 tunnels leading to other rooms.\n");  
  mov b, _s7 ; "has 3 tunnels leading to other rooms.\n"
  swp b
  push b
  call print
  add sp, 2
;; print("Look at a dodecahedron to see how this works.\n"); 
  mov b, _s8 ; "Look at a dodecahedron to see how this works.\n"
  swp b
  push b
  call print
  add sp, 2
;; print("\n"); 
  mov b, _s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" Hazards:\n"); 
  mov b, _s10 ; " Hazards:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" Bottomless pits: Two rooms have bottomless pits in them\n"); 
  mov b, _s11 ; " Bottomless pits: Two rooms have bottomless pits in them\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" If you go there, you fall into the pit (& lose!)\n"); 
  mov b, _s12 ; " If you go there, you fall into the pit (& lose!)\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n"); 
  mov b, _s13 ; " SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n"); 
  mov b, _s14 ; " GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n"); 
  mov b, _s15 ; " ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" WUMPUS:\n"); 
  mov b, _s16 ; " WUMPUS:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n"); 
  mov b, _s17 ; " THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n"); 
  mov b, _s18 ; " FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n"); 
  mov b, _s19 ; " HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" ARROW OR YOU ENTERING HIS ROOM.\n"); 
  mov b, _s20 ; " ARROW OR YOU ENTERING HIS ROOM.\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n"); 
  mov b, _s21 ; " IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n"); 
  mov b, _s22 ; " OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" ARE, HE EATS YOU UP AND YOU LOSE!\n"); 
  mov b, _s23 ; " ARE, HE EATS YOU UP AND YOU LOSE!\n"
  swp b
  push b
  call print
  add sp, 2
;; print("\n"); 
  mov b, _s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" YOU:\n"); 
  mov b, _s24 ; " YOU:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n"); 
  mov b, _s25 ; " EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n"); 
  mov b, _s26 ; " MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n"); 
  mov b, _s27 ; " ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n"); 
  mov b, _s28 ; " EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n"
  swp b
  push b
  call print
  add sp, 2
;; print("   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n"); 
  mov b, _s29 ; "   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n"
  swp b
  push b
  call print
  add sp, 2
;; print("   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n"); 
  mov b, _s30 ; "   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n"
  swp b
  push b
  call print
  add sp, 2
;; print("   AT RANDOM TO THE NEXT ROOM.\n"); 
  mov b, _s31 ; "   AT RANDOM TO THE NEXT ROOM.\n"
  swp b
  push b
  call print
  add sp, 2
;; print("     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n"); 
  mov b, _s32 ; "     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n"
  swp b
  push b
  call print
  add sp, 2
;; print("     IF THE ARROW HITS YOU, YOU LOSE.\n"); 
  mov b, _s33 ; "     IF THE ARROW HITS YOU, YOU LOSE.\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" WARNINGS:\n"); 
  mov b, _s34 ; " WARNINGS:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n"); 
  mov b, _s35 ; " WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" THE COMPUTER SAYS:\n"); 
  mov b, _s36 ; " THE COMPUTER SAYS:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" WUMPUS:  'I SMELL A WUMPUS'\n"); 
  mov b, _s37 ; " WUMPUS:  'I SMELL A WUMPUS'\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" BAT   :  'BATS NEARBY'\n"); 
  mov b, _s38 ; " BAT   :  'BATS NEARBY'\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" PIT   :  'I FEEL A DRAFT'\n"); 
  mov b, _s39 ; " PIT   :  'I FEEL A DRAFT'\n"
  swp b
  push b
  call print
  add sp, 2
;; print("\n"); 
  mov b, _s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

show_room:
  enter 0 ; (push bp; mov bp, sp)
;; int room, k; 
  sub sp, 2 ; room
  sub sp, 2 ; k
;; print("\n"); 
  mov b, _s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; for (k = 0; k < 3; k++) { 
_for48_init:
  lea d, [bp + -3] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for48_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for48_exit
_for48_block:
;; room = cave[loc[ 	    0  ]][k]; 
  lea d, [bp + -1] ; $room
  push d
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $k
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
;; if (room == loc[ 	1     ]) { 
_if49_cond:
  lea d, [bp + -1] ; $room
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if49_else
_if49_true:
;; print("I SMELL A WUMPUS!\n"); 
  mov b, _s40 ; "I SMELL A WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if49_exit
_if49_else:
;; if (room == loc[ 	2   ] || room == loc[ 	3   ]) { 
_if50_cond:
  lea d, [bp + -1] ; $room
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $room
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _if50_else
_if50_true:
;; print("I FEEL A DRAFT\n"); 
  mov b, _s41 ; "I FEEL A DRAFT\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if50_exit
_if50_else:
;; if (room == loc[ 	4    ] || room == loc[ 	5    ]) { 
_if51_cond:
  lea d, [bp + -1] ; $room
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $room
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $5
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _if51_exit
_if51_true:
;; print("BATS NEARBY!\n"); 
  mov b, _s42 ; "BATS NEARBY!\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if51_exit
_if51_exit:
_if50_exit:
_if49_exit:
_for48_update:
  lea d, [bp + -3] ; $k
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  dec b
  jmp _for48_cond
_for48_exit:
;; print("YOU ARE IN ROOM "); print_unsigned(loc[ 	    0  ]+1); print("\n"); 
  mov b, _s43 ; "YOU ARE IN ROOM "
  swp b
  push b
  call print
  add sp, 2
;; print_unsigned(loc[ 	    0  ]+1); print("\n"); 
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
;; print("\n"); 
  mov b, _s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print("TUNNELS LEAD TO ");  
  mov b, _s44 ; "TUNNELS LEAD TO "
  swp b
  push b
  call print
  add sp, 2
;; print_unsigned(cave[loc[ 	    0  ]][0]+1); print(", "); 
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
;; print(", "); 
  mov b, _s45 ; ", "
  swp b
  push b
  call print
  add sp, 2
;; print_unsigned(cave[loc[ 	    0  ]][1]+1); print(", "); 
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
;; print(", "); 
  mov b, _s45 ; ", "
  swp b
  push b
  call print
  add sp, 2
;; print_unsigned(cave[loc[ 	    0  ]][2]+1); 
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
;; print("\n\n"); 
  mov b, _s46 ; "\n\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

move_or_shoot:
  enter 0 ; (push bp; mov bp, sp)
;; int c = -1; 
  sub sp, 2 ; c
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $c
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; while ((c != 'S') && (c != 'M')) { 
_while52_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $53
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $c
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4d
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  cmp b, 0
  je _while52_exit
_while52_block:
;; c = getlet("SHOOT OR MOVE (S-M): "); 
  lea d, [bp + -1] ; $c
  push d
  mov b, _s47 ; "SHOOT OR MOVE (S-M): "
  swp b
  push b
  call getlet
  add sp, 2
  pop d
  mov [d], b
  jmp _while52_cond
_while52_exit:
;; return (c == 'S') ? 1 : 0; 
_ternary53_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $53
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _ternary53_false
_ternary53_true:
  mov b, $1
  jmp _ternary53_exit
_ternary53_false:
  mov b, $0
_ternary53_exit:
  leave
  ret

move_wumpus:
  enter 0 ; (push bp; mov bp, sp)
;; int k; 
  sub sp, 2 ; k
;; k = rand2() % 4; 
  lea d, [bp + -1] ; $k
  push d
  call rand2
; START FACTORS
  push a
  mov a, b
  mov b, $4
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; if (k < 3) { 
_if54_cond:
  lea d, [bp + -1] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if54_exit
_if54_true:
;; loc[ 	1     ] = cave[loc[ 	1     ]][k]; 
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $k
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
  jmp _if54_exit
_if54_exit:
;; if (loc[ 	1     ] == loc[ 	    0  ]) { 
_if55_cond:
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if55_exit
_if55_true:
;; print("TSK TSK TSK - WUMPUS GOT YOU!\n"); 
  mov b, _s48 ; "TSK TSK TSK - WUMPUS GOT YOU!\n"
  swp b
  push b
  call print
  add sp, 2
;; finished =  	2   ; 
  mov d, _finished ; $finished
  push d
  mov b, $2
  pop d
  mov [d], b
  jmp _if55_exit
_if55_exit:
  leave
  ret

shoot:
  enter 0 ; (push bp; mov bp, sp)
;; int path[5]; 
  sub sp, 10 ; path
;; int scratchloc = -1; 
  sub sp, 2 ; scratchloc
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $scratchloc
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; int len, k; 
  sub sp, 2 ; len
  sub sp, 2 ; k
;; finished =  	     0  ; 
  mov d, _finished ; $finished
  push d
  mov b, $0
  pop d
  mov [d], b
;; len = -1; 
  lea d, [bp + -13] ; $len
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
;; while (len < 1 || len > 5) { 
_while56_cond:
  lea d, [bp + -13] ; $len
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _while56_exit
_while56_block:
;; len = getnum("\nNUMBER OF ROOMS (1-5): "); 
  lea d, [bp + -13] ; $len
  push d
  mov b, _s49 ; "\nNUMBER OF ROOMS (1-5): "
  swp b
  push b
  call getnum
  add sp, 2
  pop d
  mov [d], b
  jmp _while56_cond
_while56_exit:
;; k = 0; 
  lea d, [bp + -15] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
;; while (k < len) { 
_while57_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while57_exit
_while57_block:
;; path[k] = getnum("ROOM #") - 1; 
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, _s50 ; "ROOM #"
  swp b
  push b
  call getnum
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if ((k>1) && (path[k] == path[k-2])) { 
_if58_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
; START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b
  pop a
; END LOGICAL AND
  cmp b, 0
  je _if58_exit
_if58_true:
;; print("ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n"); 
  mov b, _s51 ; "ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n"
  swp b
  push b
  call print
  add sp, 2
;; continue;  
  jmp _while57_cond ; while continue
  jmp _if58_exit
_if58_exit:
;; k++; 
  lea d, [bp + -15] ; $k
  mov b, [d]
  inc b
  lea d, [bp + -15] ; $k
  mov [d], b
  dec b
  jmp _while57_cond
_while57_exit:
;; scratchloc = loc[ 	    0  ]; 
  lea d, [bp + -11] ; $scratchloc
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
;; for (k = 0; k < len; k++) { 
_for59_init:
  lea d, [bp + -15] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for59_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for59_exit
_for59_block:
;; if ((cave[scratchloc][0] == path[k]) || 
_if60_cond:
  mov d, _cave_data ; $cave
  push a
  push d
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  mov d, _cave_data ; $cave
  push a
  push d
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _cave_data ; $cave
  push a
  push d
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _if60_else
_if60_true:
;; scratchloc = path[k]; 
  lea d, [bp + -11] ; $scratchloc
  push d
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
  jmp _if60_exit
_if60_else:
;; scratchloc = cave[scratchloc][rand2()%3]; 
  lea d, [bp + -11] ; $scratchloc
  push d
  mov d, _cave_data ; $cave
  push a
  push d
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  call rand2
; START FACTORS
  push a
  mov a, b
  mov b, $3
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
_if60_exit:
;; if (scratchloc == loc[ 	1     ]) { 
_if61_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if61_else
_if61_true:
;; print("AHA! YOU GOT THE WUMPUS!\n"); 
  mov b, _s52 ; "AHA! YOU GOT THE WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
;; finished =  	     1  ; 
  mov d, _finished ; $finished
  push d
  mov b, $1
  pop d
  mov [d], b
  jmp _if61_exit
_if61_else:
;; if (scratchloc == loc[ 	    0  ]) { 
_if62_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if62_exit
_if62_true:
;; print("OUCH! ARROW GOT YOU!\n"); 
  mov b, _s53 ; "OUCH! ARROW GOT YOU!\n"
  swp b
  push b
  call print
  add sp, 2
;; finished =  	2   ; 
  mov d, _finished ; $finished
  push d
  mov b, $2
  pop d
  mov [d], b
  jmp _if62_exit
_if62_exit:
_if61_exit:
;; if (finished !=  	     0  ) { 
_if63_cond:
  mov d, _finished ; $finished
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if63_exit
_if63_true:
;; return; 
  leave
  ret
  jmp _if63_exit
_if63_exit:
_for59_update:
  lea d, [bp + -15] ; $k
  mov b, [d]
  inc b
  lea d, [bp + -15] ; $k
  mov [d], b
  dec b
  jmp _for59_cond
_for59_exit:
;; print("MISSED\n"); 
  mov b, _s54 ; "MISSED\n"
  swp b
  push b
  call print
  add sp, 2
;; move_wumpus(); 
  call move_wumpus
;; if (--arrows <= 0) { 
_if64_cond:
  mov d, _arrows ; $arrows
  mov b, [d]
  dec b
  mov [d], b
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if64_exit
_if64_true:
;; finished =  	2   ; 
  mov d, _finished ; $finished
  push d
  mov b, $2
  pop d
  mov [d], b
  jmp _if64_exit
_if64_exit:
  leave
  ret

move:
  enter 0 ; (push bp; mov bp, sp)
;; int scratchloc; 
  sub sp, 2 ; scratchloc
;; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
;; while (scratchloc == -1) { 
_while65_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  neg b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while65_exit
_while65_block:
;; scratchloc = getnum("\nWHERE TO: ")-1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov b, _s55 ; "\nWHERE TO: "
  swp b
  push b
  call getnum
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if (scratchloc < 0 || scratchloc > 19) { 
_if66_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $13
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _if66_exit
_if66_true:
;; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
;; continue; 
  jmp _while65_cond ; while continue
  jmp _if66_exit
_if66_exit:
;; if ((cave[loc[ 	    0  ]][0] != scratchloc) & 
_if67_cond:
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  and b, a ; &
  mov a, b
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  and b, a ; &
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  and b, a ; &
  pop a
  cmp b, 0
  je _if67_exit
_if67_true:
;; print("NOT POSSIBLE\n"); 
  mov b, _s56 ; "NOT POSSIBLE\n"
  swp b
  push b
  call print
  add sp, 2
;; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
;; continue; 
  jmp _while65_cond ; while continue
  jmp _if67_exit
_if67_exit:
  jmp _while65_cond
_while65_exit:
;; loc[ 	    0  ] = scratchloc; 
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  pop d
  mov [d], b
;; while ((scratchloc == loc[ 	4    ]) || (scratchloc == loc[ 	5    ])) { 
_while68_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $5
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _while68_exit
_while68_block:
;; print("ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n"); 
  mov b, _s57 ; "ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n"
  swp b
  push b
  call print
  add sp, 2
;; scratchloc = loc[ 	    0  ] = rand2()%20; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call rand2
; START FACTORS
  push a
  mov a, b
  mov b, $14
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  pop d
  mov [d], b
  jmp _while68_cond
_while68_exit:
;; if (scratchloc == loc[ 	1     ]) { 
_if69_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if69_exit
_if69_true:
;; print("... OOPS! BUMPED A WUMPUS!\n"); 
  mov b, _s58 ; "... OOPS! BUMPED A WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
;; move_wumpus(); 
  call move_wumpus
  jmp _if69_exit
_if69_exit:
;; if (scratchloc == loc[ 	2   ] || scratchloc == loc[ 	3   ]) { 
_if70_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
; START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
; END LOGICAL OR
  cmp b, 0
  je _if70_exit
_if70_true:
;; print("YYYYIIIIEEEE . . . FELL IN PIT\n"); 
  mov b, _s59 ; "YYYYIIIIEEEE . . . FELL IN PIT\n"
  swp b
  push b
  call print
  add sp, 2
;; finished =  	2   ; 
  mov d, _finished ; $finished
  push d
  mov b, $2
  pop d
  mov [d], b
  jmp _if70_exit
_if70_exit:
  leave
  ret

rand2:
  enter 0 ; (push bp; mov bp, sp)
;; rand_val=rand_val+rand_inc; 
  mov d, _rand_val ; $rand_val
  push d
  mov d, _rand_val ; $rand_val
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov d, _rand_inc ; $rand_inc
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; rand_inc++; 
  mov d, _rand_inc ; $rand_inc
  mov b, [d]
  inc b
  mov d, _rand_inc ; $rand_inc
  mov [d], b
  dec b
;; return rand_val; 
  mov d, _rand_val ; $rand_val
  mov b, [d]
  leave
  ret

game_setup:
  enter 0 ; (push bp; mov bp, sp)
;; int j, k; 
  sub sp, 2 ; j
  sub sp, 2 ; k
;; int v; 
  sub sp, 2 ; v
;; for (j = 0; j <  	6   ; j++) { 
_for71_init:
  lea d, [bp + -1] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for71_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $6
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for71_exit
_for71_block:
;; loc[j] = -1; 
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
;; while (loc[j] < 0) { 
_while72_cond:
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while72_exit
_while72_block:
;; v = rand2(); 
  lea d, [bp + -5] ; $v
  push d
  call rand2
  pop d
  mov [d], b
;; loc[j] = v % 20; 
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -5] ; $v
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $14
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; for (k=0; k<j-1; k++) { 
_for73_init:
  lea d, [bp + -3] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for73_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $j
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for73_exit
_for73_block:
;; if (loc[j] == loc[k]) { 
_if74_cond:
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -3] ; $k
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if74_exit
_if74_true:
;; loc[j] = -1; 
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
  jmp _if74_exit
_if74_exit:
_for73_update:
  lea d, [bp + -3] ; $k
  mov b, [d]
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  dec b
  jmp _for73_cond
_for73_exit:
  jmp _while72_cond
_while72_exit:
_for71_update:
  lea d, [bp + -1] ; $j
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $j
  mov [d], b
  dec b
  jmp _for71_cond
_for71_exit:
  leave
  ret

game_play:
  enter 0 ; (push bp; mov bp, sp)
;; arrows = 5; 
  mov d, _arrows ; $arrows
  push d
  mov b, $5
  pop d
  mov [d], b
;; print("HUNT THE WUMPUS\n"); 
  mov b, _s60 ; "HUNT THE WUMPUS\n"
  swp b
  push b
  call print
  add sp, 2
;; if (debug) { 
_if75_cond:
  mov d, _debug ; $debug
  mov b, [d]
  cmp b, 0
  je _if75_exit
_if75_true:
;; print("Wumpus is at "); print_unsigned(loc[ 	1     ]+1); 
  mov b, _s61 ; "Wumpus is at "
  swp b
  push b
  call print
  add sp, 2
;; print_unsigned(loc[ 	1     ]+1); 
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
;; print(", pits at "); print_unsigned(loc[ 	2   ]+1); 
  mov b, _s62 ; ", pits at "
  swp b
  push b
  call print
  add sp, 2
;; print_unsigned(loc[ 	2   ]+1); 
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
;; print(" & "); print_unsigned(loc[ 	3   ]+1); 
  mov b, _s63 ; " & "
  swp b
  push b
  call print
  add sp, 2
;; print_unsigned(loc[ 	3   ]+1); 
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
;; print(", bats at "); print_unsigned(loc[ 	4    ]+1); 
  mov b, _s64 ; ", bats at "
  swp b
  push b
  call print
  add sp, 2
;; print_unsigned(loc[ 	4    ]+1); 
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
;; print(" & "); print_unsigned(loc[ 	5    ]+1); 
  mov b, _s63 ; " & "
  swp b
  push b
  call print
  add sp, 2
;; print_unsigned(loc[ 	5    ]+1); 
  mov d, _loc_data ; $loc
  push a
  push d
  mov b, $5
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
  jmp _if75_exit
_if75_exit:
;; finished =  	     0  ; 
  mov d, _finished ; $finished
  push d
  mov b, $0
  pop d
  mov [d], b
;; while (finished ==  	     0  ) { 
_while76_cond:
  mov d, _finished ; $finished
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while76_exit
_while76_block:
;; show_room(); 
  call show_room
;; if (move_or_shoot()) { 
_if77_cond:
  call move_or_shoot
  cmp b, 0
  je _if77_else
_if77_true:
;; shoot(); 
  call shoot
  jmp _if77_exit
_if77_else:
;; move(); 
  call move
_if77_exit:
  jmp _while76_cond
_while76_exit:
;; if (finished ==  	     1  ) { 
_if78_cond:
  mov d, _finished ; $finished
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if78_exit
_if78_true:
;; print("HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n"); 
  mov b, _s65 ; "HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if78_exit
_if78_exit:
;; if (finished ==  	2   ) { 
_if79_cond:
  mov d, _finished ; $finished
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if79_exit
_if79_true:
;; print("HA HA HA - YOU LOSE!\n"); 
  mov b, _s66 ; "HA HA HA - YOU LOSE!\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if79_exit
_if79_exit:
;; int c; 
  sub sp, 2 ; c
;; c = getlet("NEW GAME (Y-N): "); 
  lea d, [bp + -1] ; $c
  push d
  mov b, _s1 ; "NEW GAME (Y-N): "
  swp b
  push b
  call getlet
  add sp, 2
  pop d
  mov [d], b
;; if (c == 'N') { 
_if80_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if80_exit
_if80_true:
;; exit(); 
  call exit
  jmp _if80_exit
_if80_exit:
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_arrows: .fill 2, 0
_debug: .dw 0
_rand_val: .dw 29
_rand_inc: .dw 1
_loc_data: .fill 12, 0
_finished: .fill 2, 0
_cave_data: 
.dw 
.dw $1,$4,$7,$0,$2,$9,$1,$3,$b,$2,$4,$d,$0,$3,$5,$4,$6,$e,$5,$7,$10,$0,$6,$8,$7,$9,$11,$1,$8,$a,
.dw 
.dw 
.dw $9,$b,$12,$2,$a,$c,$b,$d,$13,$3,$c,$e,$5,$d,$f,$e,$10,$13,$6,$f,$11,$8,$10,$12,$a,$11,$13,$c,$f,$12,
.dw 
.dw 
_s0: .db "INSTRUCTIONS (Y-N): ", 0
_s1: .db "NEW GAME (Y-N): ", 0
_s2: .db "Unexpected format in printf.", 0
_s3: .db "Error: Unknown argument type.\n", 0
_s4: .db "\033[2J\033[H", 0
_s5: .db "Welcome to 'hunt the wumpus'\n", 0
_s6: .db "The wumpus lives in a cave of 20 rooms. Each room\n", 0
_s7: .db "has 3 tunnels leading to other rooms.\n", 0
_s8: .db "Look at a dodecahedron to see how this works.\n", 0
_s9: .db "\n", 0
_s10: .db " Hazards:\n", 0
_s11: .db " Bottomless pits: Two rooms have bottomless pits in them\n", 0
_s12: .db " If you go there, you fall into the pit (& lose!)\n", 0
_s13: .db " SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n", 0
_s14: .db " GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n", 0
_s15: .db " ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n", 0
_s16: .db " WUMPUS:\n", 0
_s17: .db " THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n", 0
_s18: .db " FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n", 0
_s19: .db " HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n", 0
_s20: .db " ARROW OR YOU ENTERING HIS ROOM.\n", 0
_s21: .db " IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n", 0
_s22: .db " OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n", 0
_s23: .db " ARE, HE EATS YOU UP AND YOU LOSE!\n", 0
_s24: .db " YOU:\n", 0
_s25: .db " EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n", 0
_s26: .db " MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n", 0
_s27: .db " ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n", 0
_s28: .db " EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n", 0
_s29: .db "   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n", 0
_s30: .db "   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n", 0
_s31: .db "   AT RANDOM TO THE NEXT ROOM.\n", 0
_s32: .db "     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n", 0
_s33: .db "     IF THE ARROW HITS YOU, YOU LOSE.\n", 0
_s34: .db " WARNINGS:\n", 0
_s35: .db " WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n", 0
_s36: .db " THE COMPUTER SAYS:\n", 0
_s37: .db " WUMPUS:  'I SMELL A WUMPUS'\n", 0
_s38: .db " BAT   :  'BATS NEARBY'\n", 0
_s39: .db " PIT   :  'I FEEL A DRAFT'\n", 0
_s40: .db "I SMELL A WUMPUS!\n", 0
_s41: .db "I FEEL A DRAFT\n", 0
_s42: .db "BATS NEARBY!\n", 0
_s43: .db "YOU ARE IN ROOM ", 0
_s44: .db "TUNNELS LEAD TO ", 0
_s45: .db ", ", 0
_s46: .db "\n\n", 0
_s47: .db "SHOOT OR MOVE (S-M): ", 0
_s48: .db "TSK TSK TSK - WUMPUS GOT YOU!\n", 0
_s49: .db "\nNUMBER OF ROOMS (1-5): ", 0
_s50: .db "ROOM #", 0
_s51: .db "ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n", 0
_s52: .db "AHA! YOU GOT THE WUMPUS!\n", 0
_s53: .db "OUCH! ARROW GOT YOU!\n", 0
_s54: .db "MISSED\n", 0
_s55: .db "\nWHERE TO: ", 0
_s56: .db "NOT POSSIBLE\n", 0
_s57: .db "ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n", 0
_s58: .db "... OOPS! BUMPED A WUMPUS!\n", 0
_s59: .db "YYYYIIIIEEEE . . . FELL IN PIT\n", 0
_s60: .db "HUNT THE WUMPUS\n", 0
_s61: .db "Wumpus is at ", 0
_s62: .db ", pits at ", 0
_s63: .db " & ", 0
_s64: .db ", bats at ", 0
_s65: .db "HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n", 0
_s66: .db "HA HA HA - YOU LOSE!\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
