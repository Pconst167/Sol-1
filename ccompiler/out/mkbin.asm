; --- FILENAME: ../solarium/usr/bin/mkbin
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $s 
  sub sp, 2
;; prog = 0x0000; // Beginning of arguments buffer 
  mov d, _prog ; $prog
  push d
  mov b, $0
  pop d
  mov [d], b
;; s = arg; 
  lea d, [bp + -1] ; $s
  push d
  mov d, _arg_data ; $arg
  mov b, d
  pop d
  mov [d], b
;; for(;;){ 
_for1_init:
_for1_cond:
_for1_block:
;; if(*prog == '\0' || *prog == ';' || *prog == ' '){ 
_if2_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  mov d, _prog ; $prog
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
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if2_else
_if2_true:
;; *s = '\0'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; break; 
  jmp _for1_exit ; for break
  jmp _if2_exit
_if2_else:
;; *s++ = *prog++; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_if2_exit:
_for1_update:
  jmp _for1_cond
_for1_exit:
;; printf("> "); 
  mov b, _s0 ; "> "
  swp b
  push b
  call printf
  add sp, 2

; --- BEGIN INLINE ASM BLOCK
  mov d, _arg_data ; $arg
  mov al, 6
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  syscall sys_terminate_proc

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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
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
  leave
  ret

tolower:
  enter 0 ; (push bp; mov bp, sp)
;; if (ch >= 'A' && ch <= 'Z')  
_if3_cond:
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if3_else
_if3_true:
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
  jmp _if3_exit
_if3_else:
;; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if3_exit:
  leave
  ret

toupper:
  enter 0 ; (push bp; mov bp, sp)
;; if (ch >= 'a' && ch <= 'z')  
_if4_cond:
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if4_else
_if4_true:
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
  jmp _if4_exit
_if4_else:
;; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if4_exit:
  leave
  ret

is_delimiter:
  enter 0 ; (push bp; mov bp, sp)
;; if( 
_if5_cond:
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
  cmp b, 0
  je _if5_else
_if5_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if5_exit
_if5_else:
;; return 0; 
  mov b, $0
  leave
  ret
_if5_exit:
  leave
  ret

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; $psrc 
; $pdest 
  sub sp, 4
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
_while6_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while6_exit
_while6_block:
;; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  pop b
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while6_cond
_while6_exit:
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
_while7_cond:
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
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
  cmp b, 0
  je _while7_exit
_while7_block:
;; s1++; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $s1
  mov [d], b
  pop b
;; s2++; 
  lea d, [bp + 7] ; $s2
  mov b, [d]
  push b
  inc b
  lea d, [bp + 7] ; $s2
  mov [d], b
  pop b
  jmp _while7_cond
_while7_exit:
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
; $dest_len 
; $i 
  sub sp, 4
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
_for8_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for8_cond:
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
  je _for8_exit
_for8_block:
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
_for8_update:
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
  jmp _for8_cond
_for8_exit:
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
; $length 
  sub sp, 2
;; length = 0; 
  lea d, [bp + -1] ; $length
  push d
  mov b, $0
  pop d
  mov [d], b
;; while (str[length] != 0) { 
_while9_cond:
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
  je _while9_exit
_while9_block:
;; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  pop b
  jmp _while9_cond
_while9_exit:
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
; $i 
  sub sp, 2
;; for(i = 0; i < size; i++){ 
_for10_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for10_cond:
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
  je _for10_exit
_for10_block:
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
_for10_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for10_cond
_for10_exit:
;; return s; 
  lea d, [bp + 5] ; $s
  mov b, [d]
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
; $result 
  mov a, $0
  mov [bp + -1], a
; $sign 
  mov a, $1
  mov [bp + -3], a
  sub sp, 4
;; while (*str == ' ') str++; 
_while11_cond:
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
  je _while11_exit
_while11_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _while11_cond
_while11_exit:
;; if (*str == '-' || *str == '+') { 
_if12_cond:
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
  cmp b, 0
  je _if12_exit
_if12_true:
;; if (*str == '-') sign = -1; 
_if13_cond:
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
  je _if13_exit
_if13_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $ffff
  pop d
  mov [d], b
  jmp _if13_exit
_if13_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _if12_exit
_if12_exit:
;; while (*str >= '0' && *str <= '9') { 
_while14_cond:
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
  slu ; <= (unsigned)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _while14_exit
_while14_block:
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
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _while14_cond
_while14_exit:
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
; $sec 
  sub sp, 2

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
; $fp 
  sub sp, 2
;; fp = alloc(sizeof(struct _FILE)); 
  lea d, [bp + -1] ; $fp
  push d
  mov b, 736351232
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
; $p 
; $format_p 
  sub sp, 4
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
_for15_init:
_for15_cond:
_for15_block:
;; if(!*format_p) break; 
_if16_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if16_else
_if16_true:
;; break; 
  jmp _for15_exit ; for break
  jmp _if16_exit
_if16_else:
;; if(*format_p == '%'){ 
_if17_cond:
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
  je _if17_else
_if17_true:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; switch(*format_p){ 
_switch18_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch18_comparisons:
  cmp bl, $6c
  je _switch18_case0
  cmp bl, $4c
  je _switch18_case1
  cmp bl, $64
  je _switch18_case2
  cmp bl, $69
  je _switch18_case3
  cmp bl, $75
  je _switch18_case4
  cmp bl, $78
  je _switch18_case5
  cmp bl, $63
  je _switch18_case6
  cmp bl, $73
  je _switch18_case7
  jmp _switch18_default
  jmp _switch18_exit
_switch18_case0:
_switch18_case1:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; if(*format_p == 'd' || *format_p == 'i') 
_if19_cond:
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
  cmp b, 0
  je _if19_else
_if19_true:
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
  jmp _if19_exit
_if19_else:
;; if(*format_p == 'u') 
_if20_cond:
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
  je _if20_else
_if20_true:
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
  jmp _if20_exit
_if20_else:
;; if(*format_p == 'x') 
_if21_cond:
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
  je _if21_else
_if21_true:
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
  jmp _if21_exit
_if21_else:
;; err("Unexpected format in printf."); 
  mov b, _s1 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if21_exit:
_if20_exit:
_if19_exit:
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
  jmp _switch18_exit ; case break
_switch18_case2:
_switch18_case3:
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
  jmp _switch18_exit ; case break
_switch18_case4:
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
  jmp _switch18_exit ; case break
_switch18_case5:

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
  jmp _switch18_exit ; case break
_switch18_case6:

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
  jmp _switch18_exit ; case break
_switch18_case7:

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
  jmp _switch18_exit ; case break
_switch18_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, _s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch18_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
  jmp _if17_exit
_if17_else:
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
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
_if17_exit:
_if16_exit:
_for15_update:
  jmp _for15_cond
_for15_exit:
  leave
  ret

scanf:
  enter 0 ; (push bp; mov bp, sp)
; $p 
; $format_p 
; $c 
; $i 
; $input_string 
  sub sp, 519
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
_for22_init:
_for22_cond:
_for22_block:
;; if(!*format_p) break; 
_if23_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if23_else
_if23_true:
;; break; 
  jmp _for22_exit ; for break
  jmp _if23_exit
_if23_else:
;; if(*format_p == '%'){ 
_if24_cond:
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
  je _if24_else
_if24_true:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; switch(*format_p){ 
_switch25_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch25_comparisons:
  cmp bl, $6c
  je _switch25_case0
  cmp bl, $4c
  je _switch25_case1
  cmp bl, $64
  je _switch25_case2
  cmp bl, $69
  je _switch25_case3
  cmp bl, $75
  je _switch25_case4
  cmp bl, $78
  je _switch25_case5
  cmp bl, $63
  je _switch25_case6
  cmp bl, $73
  je _switch25_case7
  jmp _switch25_default
  jmp _switch25_exit
_switch25_case0:
_switch25_case1:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; if(*format_p == 'd' || *format_p == 'i'); 
_if26_cond:
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
  cmp b, 0
  je _if26_else
_if26_true:
;; ; 
  jmp _if26_exit
_if26_else:
;; if(*format_p == 'u'); 
_if27_cond:
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
  je _if27_else
_if27_true:
;; ; 
  jmp _if27_exit
_if27_else:
;; if(*format_p == 'x'); 
_if28_cond:
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
  je _if28_else
_if28_true:
;; ; 
  jmp _if28_exit
_if28_else:
;; err("Unexpected format in printf."); 
  mov b, _s1 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if28_exit:
_if27_exit:
_if26_exit:
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
  jmp _switch25_exit ; case break
_switch25_case2:
_switch25_case3:
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
  jmp _switch25_exit ; case break
_switch25_case4:
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
  jmp _switch25_exit ; case break
_switch25_case5:
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
  jmp _switch25_exit ; case break
_switch25_case6:
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
  jmp _switch25_exit ; case break
_switch25_case7:
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
  jmp _switch25_exit ; case break
_switch25_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, _s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch25_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
  jmp _if24_exit
_if24_else:
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
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
_if24_exit:
_if23_exit:
_for22_update:
  jmp _for22_cond
_for22_exit:
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
; $value 
  mov a, $0
  mov [bp + -1], a
; $i 
; $hex_char 
; $len 
  sub sp, 7
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
_for29_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for29_cond:
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
  je _for29_exit
_for29_block:
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
_if30_cond:
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if30_else
_if30_true:
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
  jmp _if30_exit
_if30_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if31_cond:
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if31_else
_if31_true:
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
  jmp _if31_exit
_if31_else:
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
_if31_exit:
_if30_exit:
_for29_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for29_cond
_for29_exit:
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
; $digits 
; $i 
  mov a, $0
  mov [bp + -6], a
  sub sp, 7
;; if (num < 0) { 
_if32_cond:
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
  je _if32_else
_if32_true:
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
  jmp _if32_exit
_if32_else:
;; if (num == 0) { 
_if33_cond:
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
  je _if33_exit
_if33_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if33_exit
_if33_exit:
_if32_exit:
;; while (num > 0) { 
_while34_cond:
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
  je _while34_exit
_while34_block:
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
  push b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
  jmp _while34_cond
_while34_exit:
;; while (i > 0) { 
_while35_cond:
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
  je _while35_exit
_while35_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  push b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
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
  jmp _while35_cond
_while35_exit:
  leave
  ret

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  mov a, $0
  mov [bp + -11], a
  sub sp, 12
;; if (num < 0) { 
_if36_cond:
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
  je _if36_else
_if36_true:
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
  jmp _if36_exit
_if36_else:
;; if (num == 0) { 
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
_if36_exit:
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
  sgt
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
  push b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop b
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
  push b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop b
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

print_unsigned_long:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  sub sp, 12
;; i = 0; 
  lea d, [bp + -11] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if40_cond:
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
  je _while41_exit
_while41_block:
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
  push b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop b
  jmp _while41_cond
_while41_exit:
;; while (i > 0) { 
_while42_cond:
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
  je _while42_exit
_while42_block:
;; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  push b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop b
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
  jmp _while42_cond
_while42_exit:
  leave
  ret

print_unsigned:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  sub sp, 7
;; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if43_cond:
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
  je _if43_exit
_if43_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if43_exit
_if43_exit:
;; while (num > 0) { 
_while44_cond:
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
  je _while44_exit
_while44_block:
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
  push b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
  jmp _while44_cond
_while44_exit:
;; while (i > 0) { 
_while45_cond:
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
  je _while45_exit
_while45_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  push b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
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
  jmp _while45_cond
_while45_exit:
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
; $c 
  sub sp, 1

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
; $m 
  sub sp, 2

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
; $data 
  sub sp, 1

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
  mov b, _s3 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
;; return i < 0 ? -i : i; 
_ternary46_cond:
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
  je _ternary46_false
_ternary46_true:
  lea d, [bp + 5] ; $i
  mov b, [d]
  neg b
  jmp _ternary46_exit
_ternary46_false:
  lea d, [bp + 5] ; $i
  mov b, [d]
_ternary46_exit:
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/asm/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

back:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  pop d
  mov [d], b
;; while(*t++) prog--; 
_while47_cond:
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while47_exit
_while47_block:
;; prog--; 
  mov d, _prog ; $prog
  mov b, [d]
  push b
  dec b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  jmp _while47_cond
_while47_exit:
;; tok = TOK_UNDEF; 
  mov d, _tok ; $tok
  push d
  mov b, 0; TOK_UNDEF
  pop d
  mov [d], b
;; toktype = TYPE_UNDEF; 
  mov d, _toktype ; $toktype
  push d
  mov b, 0; TYPE_UNDEF
  pop d
  mov [d], b
;; token[0] = '\0'; 
  mov d, _token_data ; $token
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

get_path:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; *token = '\0'; 
  mov d, _token_data ; $token
  mov b, d
  push b
  mov b, $0
  pop d
  mov [d], bl
;; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  pop d
  mov [d], b
;; while(is_space(*prog)) prog++; 
_while48_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while48_exit
_while48_block:
;; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  jmp _while48_cond
_while48_exit:
;; if(*prog == '\0'){ 
_if49_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if49_exit
_if49_true:
;; return; 
  leave
  ret
  jmp _if49_exit
_if49_exit:
;; while( 
_while50_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  slu ; <= (unsigned)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  slu ; <= (unsigned)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
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
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  slu ; <= (unsigned)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  mov a, b
  mov d, _prog ; $prog
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
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _while50_exit
_while50_block:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while50_cond
_while50_exit:
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

get:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; *token = '\0'; 
  mov d, _token_data ; $token
  mov b, d
  push b
  mov b, $0
  pop d
  mov [d], bl
;; tok = 0; 
  mov d, _tok ; $tok
  push d
  mov b, $0
  pop d
  mov [d], b
;; toktype = 0; 
  mov d, _toktype ; $toktype
  push d
  mov b, $0
  pop d
  mov [d], b
;; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  pop d
  mov [d], b
;; while(is_space(*prog)) prog++; 
_while51_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while51_exit
_while51_block:
;; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  jmp _while51_cond
_while51_exit:
;; if(*prog == '\0'){ 
_if52_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if52_exit
_if52_true:
;; toktype = END; 
  mov d, _toktype ; $toktype
  push d
  mov b, 6; END
  pop d
  mov [d], b
;; return; 
  leave
  ret
  jmp _if52_exit
_if52_exit:
;; if(is_digit(*prog)){ 
_if53_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  je _if53_else
_if53_true:
;; while(is_digit(*prog)){ 
_while54_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  je _while54_exit
_while54_block:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while54_cond
_while54_exit:
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; toktype = INTEGER_CONST; 
  mov d, _toktype ; $toktype
  push d
  mov b, 4; INTEGER_CONST
  pop d
  mov [d], b
;; return; // return to avoid *t = '\0' line at the end of function 
  leave
  ret
  jmp _if53_exit
_if53_else:
;; if(is_alpha(*prog)){ 
_if55_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  cmp b, 0
  je _if55_else
_if55_true:
;; while(is_alpha(*prog) || is_digit(*prog)){ 
_while56_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  sor a, b ; ||
  pop a
  cmp b, 0
  je _while56_exit
_while56_block:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while56_cond
_while56_exit:
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; toktype = IDENTIFIER; 
  mov d, _toktype ; $toktype
  push d
  mov b, 5; IDENTIFIER
  pop d
  mov [d], b
  jmp _if55_exit
_if55_else:
;; if(*prog == '\"'){ 
_if57_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if57_else
_if57_true:
;; *t++ = '\"'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov b, $22
  pop d
  mov [d], bl
;; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
;; while(*prog != '\"' && *prog){ 
_while58_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b
  pop a
  cmp b, 0
  je _while58_exit
_while58_block:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while58_cond
_while58_exit:
;; if(*prog != '\"') error("Double quotes expected"); 
_if59_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if59_exit
_if59_true:
;; error("Double quotes expected"); 
  mov b, _s4 ; "Double quotes expected"
  swp b
  push b
  call error
  add sp, 2
  jmp _if59_exit
_if59_exit:
;; *t++ = '\"'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov b, $22
  pop d
  mov [d], bl
;; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
;; toktype = STRING_CONST; 
  mov d, _toktype ; $toktype
  push d
  mov b, 3; STRING_CONST
  pop d
  mov [d], b
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; convert_constant(); // converts this string token qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
  call convert_constant
  jmp _if57_exit
_if57_else:
;; if(*prog == '#'){ 
_if60_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if60_else
_if60_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = HASH; 
  mov d, _tok ; $tok
  push d
  mov b, 21; HASH
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if60_exit
_if60_else:
;; if(*prog == '{'){ 
_if61_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if61_else
_if61_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_BRACE; 
  mov d, _tok ; $tok
  push d
  mov b, 30; OPENING_BRACE
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if61_exit
_if61_else:
;; if(*prog == '}'){ 
_if62_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if62_else
_if62_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_BRACE; 
  mov d, _tok ; $tok
  push d
  mov b, 31; CLOSING_BRACE
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if62_exit
_if62_else:
;; if(*prog == '['){ 
_if63_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if63_else
_if63_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_BRACKET; 
  mov d, _tok ; $tok
  push d
  mov b, 32; OPENING_BRACKET
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if63_exit
_if63_else:
;; if(*prog == ']'){ 
_if64_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if64_else
_if64_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_BRACKET; 
  mov d, _tok ; $tok
  push d
  mov b, 33; CLOSING_BRACKET
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if64_exit
_if64_else:
;; if(*prog == '='){ 
_if65_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if65_else
_if65_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if66_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if66_else
_if66_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = EQUAL; 
  mov d, _tok ; $tok
  push d
  mov b, 8; EQUAL
  pop d
  mov [d], b
  jmp _if66_exit
_if66_else:
;; tok = ASSIGNMENT; 
  mov d, _tok ; $tok
  push d
  mov b, 17; ASSIGNMENT
  pop d
  mov [d], b
_if66_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if65_exit
_if65_else:
;; if(*prog == '&'){ 
_if67_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if67_else
_if67_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '&'){ 
_if68_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if68_else
_if68_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LOGICAL_AND; 
  mov d, _tok ; $tok
  push d
  mov b, 14; LOGICAL_AND
  pop d
  mov [d], b
  jmp _if68_exit
_if68_else:
;; tok = AMPERSAND; 
  mov d, _tok ; $tok
  push d
  mov b, 22; AMPERSAND
  pop d
  mov [d], b
_if68_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if67_exit
_if67_else:
;; if(*prog == '|'){ 
_if69_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if69_else
_if69_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '|'){ 
_if70_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if70_else
_if70_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LOGICAL_OR; 
  mov d, _tok ; $tok
  push d
  mov b, 15; LOGICAL_OR
  pop d
  mov [d], b
  jmp _if70_exit
_if70_else:
;; tok = BITWISE_OR; 
  mov d, _tok ; $tok
  push d
  mov b, 24; BITWISE_OR
  pop d
  mov [d], b
_if70_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if69_exit
_if69_else:
;; if(*prog == '~'){ 
_if71_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if71_else
_if71_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_NOT; 
  mov d, _tok ; $tok
  push d
  mov b, 25; BITWISE_NOT
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if71_exit
_if71_else:
;; if(*prog == '<'){ 
_if72_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if72_else
_if72_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if73_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if73_else
_if73_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LESS_THAN_OR_EQUAL; 
  mov d, _tok ; $tok
  push d
  mov b, 11; LESS_THAN_OR_EQUAL
  pop d
  mov [d], b
  jmp _if73_exit
_if73_else:
;; if (*prog == '<'){ 
_if74_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if74_else
_if74_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_SHL; 
  mov d, _tok ; $tok
  push d
  mov b, 26; BITWISE_SHL
  pop d
  mov [d], b
  jmp _if74_exit
_if74_else:
;; tok = LESS_THAN; 
  mov d, _tok ; $tok
  push d
  mov b, 10; LESS_THAN
  pop d
  mov [d], b
_if74_exit:
_if73_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if72_exit
_if72_else:
;; if(*prog == '>'){ 
_if75_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if75_else
_if75_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if76_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if76_else
_if76_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = GREATER_THAN_OR_EQUAL; 
  mov d, _tok ; $tok
  push d
  mov b, 13; GREATER_THAN_OR_EQUAL
  pop d
  mov [d], b
  jmp _if76_exit
_if76_else:
;; if (*prog == '>'){ 
_if77_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if77_else
_if77_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_SHR; 
  mov d, _tok ; $tok
  push d
  mov b, 27; BITWISE_SHR
  pop d
  mov [d], b
  jmp _if77_exit
_if77_else:
;; tok = GREATER_THAN; 
  mov d, _tok ; $tok
  push d
  mov b, 12; GREATER_THAN
  pop d
  mov [d], b
_if77_exit:
_if76_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if75_exit
_if75_else:
;; if(*prog == '!'){ 
_if78_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if78_else
_if78_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '='){ 
_if79_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if79_else
_if79_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = NOT_EQUAL; 
  mov d, _tok ; $tok
  push d
  mov b, 9; NOT_EQUAL
  pop d
  mov [d], b
  jmp _if79_exit
_if79_else:
;; tok = LOGICAL_NOT; 
  mov d, _tok ; $tok
  push d
  mov b, 16; LOGICAL_NOT
  pop d
  mov [d], b
_if79_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if78_exit
_if78_else:
;; if(*prog == '+'){ 
_if80_cond:
  mov d, _prog ; $prog
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
  cmp b, 0
  je _if80_else
_if80_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '+'){ 
_if81_cond:
  mov d, _prog ; $prog
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
  cmp b, 0
  je _if81_else
_if81_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = INCREMENT; 
  mov d, _tok ; $tok
  push d
  mov b, 5; INCREMENT
  pop d
  mov [d], b
  jmp _if81_exit
_if81_else:
;; tok = PLUS; 
  mov d, _tok ; $tok
  push d
  mov b, 1; PLUS
  pop d
  mov [d], b
_if81_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if80_exit
_if80_else:
;; if(*prog == '-'){ 
_if82_cond:
  mov d, _prog ; $prog
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
  je _if82_else
_if82_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '-'){ 
_if83_cond:
  mov d, _prog ; $prog
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
  je _if83_else
_if83_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DECREMENT; 
  mov d, _tok ; $tok
  push d
  mov b, 6; DECREMENT
  pop d
  mov [d], b
  jmp _if83_exit
_if83_else:
;; tok = MINUS; 
  mov d, _tok ; $tok
  push d
  mov b, 2; MINUS
  pop d
  mov [d], b
_if83_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if82_exit
_if82_else:
;; if(*prog == '$'){ 
_if84_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if84_else
_if84_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DOLLAR; 
  mov d, _tok ; $tok
  push d
  mov b, 18; DOLLAR
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if84_exit
_if84_else:
;; if(*prog == '^'){ 
_if85_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if85_else
_if85_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_XOR; 
  mov d, _tok ; $tok
  push d
  mov b, 23; BITWISE_XOR
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if85_exit
_if85_else:
;; if(*prog == '@'){ 
_if86_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if86_else
_if86_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = AT; 
  mov d, _tok ; $tok
  push d
  mov b, 20; AT
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if86_exit
_if86_else:
;; if(*prog == '*'){ 
_if87_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if87_else
_if87_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = STAR; 
  mov d, _tok ; $tok
  push d
  mov b, 3; STAR
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if87_exit
_if87_else:
;; if(*prog == '/'){ 
_if88_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if88_else
_if88_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = FSLASH; 
  mov d, _tok ; $tok
  push d
  mov b, 4; FSLASH
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if88_exit
_if88_else:
;; if(*prog == '%'){ 
_if89_cond:
  mov d, _prog ; $prog
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
  je _if89_else
_if89_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = MOD; 
  mov d, _tok ; $tok
  push d
  mov b, 7; MOD
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if89_exit
_if89_else:
;; if(*prog == '('){ 
_if90_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if90_else
_if90_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_PAREN; 
  mov d, _tok ; $tok
  push d
  mov b, 28; OPENING_PAREN
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if90_exit
_if90_else:
;; if(*prog == ')'){ 
_if91_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if91_else
_if91_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_PAREN; 
  mov d, _tok ; $tok
  push d
  mov b, 29; CLOSING_PAREN
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if91_exit
_if91_else:
;; if(*prog == ';'){ 
_if92_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if92_else
_if92_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = SEMICOLON; 
  mov d, _tok ; $tok
  push d
  mov b, 35; SEMICOLON
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if92_exit
_if92_else:
;; if(*prog == ':'){ 
_if93_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if93_else
_if93_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = COLON; 
  mov d, _tok ; $tok
  push d
  mov b, 34; COLON
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if93_exit
_if93_else:
;; if(*prog == ','){ 
_if94_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if94_else
_if94_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = COMMA; 
  mov d, _tok ; $tok
  push d
  mov b, 36; COMMA
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if94_exit
_if94_else:
;; if(*prog == '.'){ 
_if95_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
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
  cmp b, 0
  je _if95_exit
_if95_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  pop b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  push b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DOT; 
  mov d, _tok ; $tok
  push d
  mov b, 37; DOT
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if95_exit
_if95_exit:
_if94_exit:
_if93_exit:
_if92_exit:
_if91_exit:
_if90_exit:
_if89_exit:
_if88_exit:
_if87_exit:
_if86_exit:
_if85_exit:
_if84_exit:
_if82_exit:
_if80_exit:
_if78_exit:
_if75_exit:
_if72_exit:
_if71_exit:
_if69_exit:
_if67_exit:
_if65_exit:
_if64_exit:
_if63_exit:
_if62_exit:
_if61_exit:
_if60_exit:
_if57_exit:
_if55_exit:
_if53_exit:
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

convert_constant:
  enter 0 ; (push bp; mov bp, sp)
; $s 
; $t 
  sub sp, 4
;; t = token; 
  lea d, [bp + -3] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  pop d
  mov [d], b
;; s = string_const; 
  lea d, [bp + -1] ; $s
  push d
  mov d, _string_const_data ; $string_const
  mov b, d
  pop d
  mov [d], b
;; if(toktype == CHAR_CONST){ 
_if96_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 2; CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if96_else
_if96_true:
;; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  pop b
;; if(*t == '\\'){ 
_if97_cond:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if97_else
_if97_true:
;; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  pop b
;; switch(*t){ 
_switch98_expr:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch98_comparisons:
  cmp bl, $30
  je _switch98_case0
  cmp bl, $61
  je _switch98_case1
  cmp bl, $62
  je _switch98_case2
  cmp bl, $66
  je _switch98_case3
  cmp bl, $6e
  je _switch98_case4
  cmp bl, $72
  je _switch98_case5
  cmp bl, $74
  je _switch98_case6
  cmp bl, $76
  je _switch98_case7
  cmp bl, $5c
  je _switch98_case8
  cmp bl, $27
  je _switch98_case9
  cmp bl, $22
  je _switch98_case10
  jmp _switch98_exit
_switch98_case0:
;; *s++ = '\0'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $0
  pop d
  mov [d], bl
;; break; 
  jmp _switch98_exit ; case break
_switch98_case1:
;; *s++ = '\a'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $7
  pop d
  mov [d], bl
;; break; 
  jmp _switch98_exit ; case break
_switch98_case2:
;; *s++ = '\b'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $8
  pop d
  mov [d], bl
;; break;   
  jmp _switch98_exit ; case break
_switch98_case3:
;; *s++ = '\f'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $c
  pop d
  mov [d], bl
;; break; 
  jmp _switch98_exit ; case break
_switch98_case4:
;; *s++ = '\n'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $a
  pop d
  mov [d], bl
;; break; 
  jmp _switch98_exit ; case break
_switch98_case5:
;; *s++ = '\r'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $d
  pop d
  mov [d], bl
;; break; 
  jmp _switch98_exit ; case break
_switch98_case6:
;; *s++ = '\t'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $9
  pop d
  mov [d], bl
;; break; 
  jmp _switch98_exit ; case break
_switch98_case7:
;; *s++ = '\v'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $b
  pop d
  mov [d], bl
;; break; 
  jmp _switch98_exit ; case break
_switch98_case8:
;; *s++ = '\\'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $5c
  pop d
  mov [d], bl
;; break; 
  jmp _switch98_exit ; case break
_switch98_case9:
;; *s++ = '\''; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $27
  pop d
  mov [d], bl
;; break; 
  jmp _switch98_exit ; case break
_switch98_case10:
;; *s++ = '\"'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  mov b, $22
  pop d
  mov [d], bl
_switch98_exit:
  jmp _if97_exit
_if97_else:
;; *s++ = *t; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_if97_exit:
  jmp _if96_exit
_if96_else:
;; if(toktype == STRING_CONST){ 
_if99_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if99_exit
_if99_true:
;; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  pop b
;; while(*t != '\"' && *t){ 
_while100_cond:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b
  pop a
  cmp b, 0
  je _while100_exit
_while100_block:
;; *s++ = *t++; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  pop b
  push b
  lea d, [bp + -3] ; $t
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while100_cond
_while100_exit:
  jmp _if99_exit
_if99_exit:
_if96_exit:
;; *s = '\0'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

error:
  enter 0 ; (push bp; mov bp, sp)
;; printf("\nError: "); 
  mov b, _s5 ; "\nError: "
  swp b
  push b
  call printf
  add sp, 2
;; printf(msg); 
  lea d, [bp + 5] ; $msg
  mov b, [d]
  swp b
  push b
  call printf
  add sp, 2
;; printf("\n"); 
  mov b, _s6 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_tok: .fill 2, 0
_toktype: .fill 2, 0
_prog: .fill 2, 0
_token_data: .fill 256, 0
_string_const_data: .fill 256, 0
_arg_data: .fill 512, 0
_s0: .db "> ", 0
_s1: .db "Unexpected format in printf.", 0
_s2: .db "Error: Unknown argument type.\n", 0
_s3: .db "\033[2J\033[H", 0
_s4: .db "Double quotes expected", 0
_s5: .db "\nError: ", 0
_s6: .db "\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
