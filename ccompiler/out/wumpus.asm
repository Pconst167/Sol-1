; --- FILENAME: programs/wumpus
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $arg_p 
; $arg_line_p 
; $psrc 
; $pdest 
; $arg 
; $arg_len 
; $c 
  sub sp, 76
;; argc = 0; 
  lea d, [bp + 7] ; $argc
  push d
  mov b, $0
  pop d
  mov [d], b
;; arg_line_p = 0; 
  lea d, [bp + -3] ; $arg_line_p
  push d
  mov b, $0
  pop d
  mov [d], b
;; for(;;){ 
_for1_init:
_for1_cond:
_for1_block:
;; arg_p = arg; 
  lea d, [bp + -1] ; $arg_p
  push d
  lea d, [bp + -71] ; $arg
  mov b, d
  pop d
  mov [d], b
;; arg_len = 0; 
  lea d, [bp + -73] ; $arg_len
  push d
  mov b, $0
  pop d
  mov [d], b
;; while(*arg_line_p == ' ' || *arg_line_p == '\t') arg_line_p++; 
_while2_cond:
  lea d, [bp + -3] ; $arg_line_p
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
  push a
  mov a, b
  lea d, [bp + -3] ; $arg_line_p
  mov b, [d]
  mov d, b
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
  pop a
  cmp b, 0
  je _while2_exit
_while2_block:
;; arg_line_p++; 
  lea d, [bp + -3] ; $arg_line_p
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $arg_line_p
  mov [d], b
  mov b, g
  jmp _while2_cond
_while2_exit:
;; if(!*arg_line_p) break; 
_if3_cond:
  lea d, [bp + -3] ; $arg_line_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if3_exit
_if3_true:
;; break; 
  jmp _for1_exit ; for break
  jmp _if3_exit
_if3_exit:
;; while(*arg_line_p != ' ' && *arg_line_p != ';' && *arg_line_p){ 
_while4_cond:
  lea d, [bp + -3] ; $arg_line_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $arg_line_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  mov a, b
  lea d, [bp + -3] ; $arg_line_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while4_exit
_while4_block:
;; if(*arg_line_p == '\\') arg_line_p++; 
_if5_cond:
  lea d, [bp + -3] ; $arg_line_p
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
  je _if5_exit
_if5_true:
;; arg_line_p++; 
  lea d, [bp + -3] ; $arg_line_p
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $arg_line_p
  mov [d], b
  mov b, g
  jmp _if5_exit
_if5_exit:
;; *arg_p++ = *arg_line_p++; 
  lea d, [bp + -1] ; $arg_p
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $arg_p
  mov [d], b
  mov b, g
  push b
  lea d, [bp + -3] ; $arg_line_p
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $arg_line_p
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; arg_len++; 
  lea d, [bp + -73] ; $arg_len
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -73] ; $arg_len
  mov [d], b
  mov b, g
  jmp _while4_cond
_while4_exit:
;; *arg_p = '\0'; 
  lea d, [bp + -1] ; $arg_p
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; argv[argc] = heap_top; 
  mov b, [bp + 5] ; $argv
  mov d, b
  push a
  push d
  lea d, [bp + 7] ; $argc
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
  pop d
  mov [d], b
;; heap_top = heap_top + arg_len + 1; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -73] ; $arg_len
  mov b, [d]
  add a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; psrc = arg; 
  lea d, [bp + -5] ; $psrc
  push d
  lea d, [bp + -71] ; $arg
  mov b, d
  pop d
  mov [d], b
;; pdest = argv[argc]; 
  lea d, [bp + -7] ; $pdest
  push d
  mov b, [bp + 5] ; $argv
  mov d, b
  push a
  push d
  lea d, [bp + 7] ; $argc
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while6_cond:
  lea d, [bp + -5] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while6_exit
_while6_block:
;; *pdest++ = *psrc++; 
  lea d, [bp + -7] ; $pdest
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -7] ; $pdest
  mov [d], b
  mov b, g
  push b
  lea d, [bp + -5] ; $psrc
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -5] ; $psrc
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while6_cond
_while6_exit:
;; *pdest = '\0'; 
  lea d, [bp + -7] ; $pdest
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; argc++; 
  lea d, [bp + 7] ; $argc
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 7] ; $argc
  mov [d], b
  mov b, g
_for1_update:
  jmp _for1_cond
_for1_exit:
;; rand(); 
  call rand
;; c = getlet("INSTRUCTIONS (Y-N)"); 
  lea d, [bp + -75] ; $c
  push d
  mov b, __s0 ; "INSTRUCTIONS (Y-N)"
  swp b
  push b
  call getlet
  add sp, 2
  pop d
  mov [d], b
;; if (c == 'Y') { 
_if7_cond:
  lea d, [bp + -75] ; $c
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
  je _if7_exit
_if7_true:
;; print_instructions(); 
  call print_instructions
  jmp _if7_exit
_if7_exit:
;; do {  
_do8_block:
;; game_setup(); 
  call game_setup
;; game_play(); 
  call game_play
;; } while (getlet("NEW GAME (Y-N)") != 'N'); 
_do8_cond:
  mov b, __s1 ; "NEW GAME (Y-N)"
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
  je _do8_block
_do8_exit:
;; return 0; 
  mov b, $0
  leave
  syscall sys_terminate_proc

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; $psrc 
; $pdest 
  sub sp, 4
;; psrc = src; 
  lea d, [bp + -1] ; $psrc
  push d
  lea d, [bp + 5] ; $src
  mov b, [d]
  pop d
  mov [d], b
;; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 7] ; $dest
  mov b, [d]
  pop d
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while9_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while9_exit
_while9_block:
;; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  mov b, g
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while9_cond
_while9_exit:
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
_while10_cond:
  lea d, [bp + 7] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  lea d, [bp + 7] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $s2
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while10_exit
_while10_block:
;; s1++; 
  lea d, [bp + 7] ; $s1
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 7] ; $s1
  mov [d], b
  mov b, g
;; s2++; 
  lea d, [bp + 5] ; $s2
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $s2
  mov [d], b
  mov b, g
  jmp _while10_cond
_while10_exit:
;; return *s1 - *s2; 
  lea d, [bp + 7] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $s2
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

strcat:
  enter 0 ; (push bp; mov bp, sp)
; $dest_len 
; $i 
  sub sp, 4
;; dest_len = strlen(dest); 
  lea d, [bp + -1] ; $dest_len
  push d
  lea d, [bp + 7] ; $dest
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; src[i] != 0; i=i+1) { 
_for11_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for11_cond:
  lea d, [bp + 5] ; $src
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
  je _for11_exit
_for11_block:
;; dest[dest_len + i] = src[i]; 
  lea d, [bp + 7] ; $dest
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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + 5] ; $src
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
_for11_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _for11_cond
_for11_exit:
;; dest[dest_len + i] = 0; 
  lea d, [bp + 7] ; $dest
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
  add a, b
  mov b, a
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
  lea d, [bp + 7] ; $dest
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
_while12_cond:
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
  je _while12_exit
_while12_block:
;; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while12_cond
_while12_exit:
;; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  leave
  ret

va_arg:
  enter 0 ; (push bp; mov bp, sp)
; $val 
  sub sp, 2
;; if(size == 1){ 
_if13_cond:
  lea d, [bp + 5] ; $size
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
  je _if13_else
_if13_true:
;; val = *(char*)arg->p; 
  lea d, [bp + -1] ; $val
  push d
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], b
  jmp _if13_exit
_if13_else:
;; if(size == 2){ 
_if14_cond:
  lea d, [bp + 5] ; $size
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
  je _if14_else
_if14_true:
;; val = *(int*)arg->p; 
  lea d, [bp + -1] ; $val
  push d
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  mov b, [d]
  mov d, b
  mov b, [d]
  pop d
  mov [d], b
  jmp _if14_exit
_if14_else:
;; print("Unknown type size in va_arg() call. Size needs to be either 1 or 2."); 
  mov b, __s2 ; "Unknown type size in va_arg() call. Size needs to be either 1 or 2."
  swp b
  push b
  call print
  add sp, 2
_if14_exit:
_if13_exit:
;; arg->p = arg->p + size; 
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  push d
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $size
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return val; 
  lea d, [bp + -1] ; $val
  mov b, [d]
  leave
  ret

printf:
  enter 0 ; (push bp; mov bp, sp)
; $p 
; $fp 
; $i 
  sub sp, 6
;; fp = format; 
  lea d, [bp + -3] ; $fp
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  pop d
  mov [d], b
;; p = &format; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
  pop d
  mov [d], b
;; for(;;){ 
_for15_init:
_for15_cond:
_for15_block:
;; if(!*fp) break; 
_if16_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if16_exit
_if16_true:
;; break; 
  jmp _for15_exit ; for break
  jmp _if16_exit
_if16_exit:
;; if(*fp == '%'){ 
_if17_cond:
  lea d, [bp + -3] ; $fp
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
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
;; switch(*fp){ 
_switch18_expr:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch18_comparisons:
  cmp bl, $64
  je _switch18_case0
  cmp bl, $69
  je _switch18_case1
  cmp bl, $75
  je _switch18_case2
  cmp bl, $78
  je _switch18_case3
  cmp bl, $63
  je _switch18_case4
  cmp bl, $73
  je _switch18_case5
  jmp _switch18_default
  jmp _switch18_exit
_switch18_case0:
_switch18_case1:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
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
  mov [d], b
;; prints(*(int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; break; 
  jmp _switch18_exit ; case break
_switch18_case2:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
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
  mov [d], b
;; printu(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; break; 
  jmp _switch18_exit ; case break
_switch18_case3:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
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
  mov [d], b
;; printx16(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printx16
  add sp, 2
;; break; 
  jmp _switch18_exit ; case break
_switch18_case4:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
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
  mov [d], b
;; putchar(*(char*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; break; 
  jmp _switch18_exit ; case break
_switch18_case5:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
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
  mov [d], b
;; print(*(char**)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; break; 
  jmp _switch18_exit ; case break
_switch18_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s3 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch18_exit:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
  jmp _if17_exit
_if17_else:
;; putchar(*fp); 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
_if17_exit:
_for15_update:
  jmp _for15_cond
_for15_exit:
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

hex_to_int:
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
_for19_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for19_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for19_exit
_for19_block:
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
_if20_cond:
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
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if20_else
_if20_true:
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
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if20_exit
_if20_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if21_cond:
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
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if21_else
_if21_true:
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
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if21_exit
_if21_else:
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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
_if21_exit:
_if20_exit:
_for19_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for19_cond
_for19_exit:
;; return value; 
  lea d, [bp + -1] ; $value
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
_while22_cond:
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
  je _while22_exit
_while22_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while22_cond
_while22_exit:
;; if (*str == '-' || *str == '+') { 
_if23_cond:
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
  je _if23_exit
_if23_true:
;; if (*str == '-') sign = -1; 
_if24_cond:
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
  je _if24_exit
_if24_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
  jmp _if24_exit
_if24_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if23_exit
_if23_exit:
;; while (*str >= '0' && *str <= '9') { 
_while25_cond:
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
  sge ; >=
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
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while25_exit
_while25_block:
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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while25_cond
_while25_exit:
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

prints:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  mov a, $0
  mov [bp + -6], a
  sub sp, 7
;; if (num < 0) { 
_if26_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _if26_else
_if26_true:
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
  jmp _if26_exit
_if26_else:
;; if (num == 0) { 
_if27_cond:
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
  je _if27_exit
_if27_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if27_exit
_if27_exit:
_if26_exit:
;; while (num > 0) { 
_while28_cond:
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
  je _while28_exit
_while28_block:
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
  add a, b
  mov b, a
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
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while28_cond
_while28_exit:
;; while (i > 0) { 
_while29_cond:
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
  je _while29_exit
_while29_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
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
  jmp _while29_cond
_while29_exit:
  leave
  ret

printu:
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
;; while (num > 0) { 
_while31_cond:
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
  add a, b
  mov b, a
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
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
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
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
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

rand:
  enter 0 ; (push bp; mov bp, sp)
; $sec 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  mov al, 0
  syscall sys_rtc					
  mov al, ah
  lea d, [bp + 0] ; $sec
  mov al, [d]
; --- END INLINE ASM BLOCK

;; return sec; 
  lea d, [bp + 0] ; $sec
  mov bl, [d]
  mov bh, 0
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

loadfile:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $destination
  mov a, [d]
  mov di, a
  lea d, [bp + 7] ; $filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

create_file:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

delete_file:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $filename
  mov al, 10
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

fopen:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

fclose:
  enter 0 ; (push bp; mov bp, sp)
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
  add a, b
  mov b, a
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

exit:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  syscall sys_terminate_proc
; --- END INLINE ASM BLOCK

  leave
  ret

load_hex:
  enter 0 ; (push bp; mov bp, sp)
; $temp 
  sub sp, 2
;; temp = alloc(32768); 
  lea d, [bp + -1] ; $temp
  push d
  mov b, $8000
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b

; --- BEGIN INLINE ASM BLOCK
  
  
  
  
  
_load_hex:
  push a
  push b
  push d
  push si
  push di
  sub sp, $8000      
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
  add sp, $8000
  pop di
  pop si
  pop d
  pop b
  pop a
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
  mov b, __s4 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

include_ctype_lib:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/ctype.asm"
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
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
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
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
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
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
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

toupper:
  enter 0 ; (push bp; mov bp, sp)
;; if (ch >= 'a' && ch <= 'z') { 
_if33_cond:
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
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if33_else
_if33_true:
;; return ch - 'a' + 'A'; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, $41
  add a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if33_exit
_if33_else:
;; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if33_exit:
  leave
  ret

is_delimiter:
  enter 0 ; (push bp; mov bp, sp)
;; if( 
_if34_cond:
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
  je _if34_else
_if34_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if34_exit
_if34_else:
;; return 0; 
  mov b, $0
  leave
  ret
_if34_exit:
  leave
  ret

getnum:
  enter 0 ; (push bp; mov bp, sp)
; $n 
  sub sp, 2
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
; $c 
  mov al, $a
  mov [bp + 0], al
  sub sp, 1
;; print(prompt); 
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; while (c == '\n') { 
_while35_cond:
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
  je _while35_exit
_while35_block:
;; c = getchar(); 
  lea d, [bp + 0] ; $c
  push d
  call getchar
  pop d
  mov [d], bl
  jmp _while35_cond
_while35_exit:
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
;; print("WELCOME TO 'HUNT THE WUMPUS'\n"); 
  mov b, __s5 ; "WELCOME TO 'HUNT THE WUMPUS'\n"
  swp b
  push b
  call print
  add sp, 2
;; print("THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM\n"); 
  mov b, __s6 ; "THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM\n"
  swp b
  push b
  call print
  add sp, 2
;; print("HAS 3 TUNNELS LEADING TO OTHER ROOMS. (LOOK AT A\n"); 
  mov b, __s7 ; "HAS 3 TUNNELS LEADING TO OTHER ROOMS. (LOOK AT A\n"
  swp b
  push b
  call print
  add sp, 2
;; print("DODECAHEDRON TO SEE HOW THIS WORKS-IF YOU DON'T KNOW\n"); 
  mov b, __s8 ; "DODECAHEDRON TO SEE HOW THIS WORKS-IF YOU DON'T KNOW\n"
  swp b
  push b
  call print
  add sp, 2
;; print("WHAT A DODECAHEDRON IS, ASK SOMEONE)\n"); 
  mov b, __s9 ; "WHAT A DODECAHEDRON IS, ASK SOMEONE)\n"
  swp b
  push b
  call print
  add sp, 2
;; print("\n"); 
  mov b, __s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" HAZARDS:\n"); 
  mov b, __s11 ; " HAZARDS:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" BOTTOMLESS PITS: TWO ROOMS HAVE BOTTOMLESS PITS IN THEM\n"); 
  mov b, __s12 ; " BOTTOMLESS PITS: TWO ROOMS HAVE BOTTOMLESS PITS IN THEM\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)\n"); 
  mov b, __s13 ; " IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n"); 
  mov b, __s14 ; " SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n"); 
  mov b, __s15 ; " GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n"); 
  mov b, __s16 ; " ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" WUMPUS:\n"); 
  mov b, __s17 ; " WUMPUS:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n"); 
  mov b, __s18 ; " THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n"); 
  mov b, __s19 ; " FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n"); 
  mov b, __s20 ; " HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" ARROW OR YOU ENTERING HIS ROOM.\n"); 
  mov b, __s21 ; " ARROW OR YOU ENTERING HIS ROOM.\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n"); 
  mov b, __s22 ; " IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n"); 
  mov b, __s23 ; " OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" ARE, HE EATS YOU UP AND YOU LOSE!\n"); 
  mov b, __s24 ; " ARE, HE EATS YOU UP AND YOU LOSE!\n"
  swp b
  push b
  call print
  add sp, 2
;; print("\n"); 
  mov b, __s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" YOU:\n"); 
  mov b, __s25 ; " YOU:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n"); 
  mov b, __s26 ; " EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n"); 
  mov b, __s27 ; " MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n"); 
  mov b, __s28 ; " ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n"); 
  mov b, __s29 ; " EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n"
  swp b
  push b
  call print
  add sp, 2
;; print("   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n"); 
  mov b, __s30 ; "   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n"
  swp b
  push b
  call print
  add sp, 2
;; print("   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n"); 
  mov b, __s31 ; "   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n"
  swp b
  push b
  call print
  add sp, 2
;; print("   AT RANDOM TO THE NEXT ROOM.\n"); 
  mov b, __s32 ; "   AT RANDOM TO THE NEXT ROOM.\n"
  swp b
  push b
  call print
  add sp, 2
;; print("     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n"); 
  mov b, __s33 ; "     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n"
  swp b
  push b
  call print
  add sp, 2
;; print("     IF THE ARROW HITS YOU, YOU LOSE.\n"); 
  mov b, __s34 ; "     IF THE ARROW HITS YOU, YOU LOSE.\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" WARNINGS:\n"); 
  mov b, __s35 ; " WARNINGS:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n"); 
  mov b, __s36 ; " WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" THE COMPUTER SAYS:\n"); 
  mov b, __s37 ; " THE COMPUTER SAYS:\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" WUMPUS:  'I SMELL A WUMPUS'\n"); 
  mov b, __s38 ; " WUMPUS:  'I SMELL A WUMPUS'\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" BAT   :  'BATS NEARBY'\n"); 
  mov b, __s39 ; " BAT   :  'BATS NEARBY'\n"
  swp b
  push b
  call print
  add sp, 2
;; print(" PIT   :  'I FEEL A DRAFT'\n"); 
  mov b, __s40 ; " PIT   :  'I FEEL A DRAFT'\n"
  swp b
  push b
  call print
  add sp, 2
;; print("\n"); 
  mov b, __s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

show_room:
  enter 0 ; (push bp; mov bp, sp)
; $room 
; $k 
  sub sp, 4
;; print("\n"); 
  mov b, __s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; for (k = 0; k < 3; k++) { 
_for36_init:
  lea d, [bp + -3] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for36_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for36_exit
_for36_block:
;; room = cave[loc[ 0  ]][k]; 
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
;; if (room == loc[ 1     ]) { 
_if37_cond:
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
  je _if37_else
_if37_true:
;; print("I SMELL A WUMPUS!\n"); 
  mov b, __s41 ; "I SMELL A WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if37_exit
_if37_else:
;; if (room == loc[ 2   ] || room == loc[ 3   ]) { 
_if38_cond:
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
  cmp b, 0
  je _if38_else
_if38_true:
;; print("I FEEL A DRAFT\n"); 
  mov b, __s42 ; "I FEEL A DRAFT\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if38_exit
_if38_else:
;; if (room == loc[ 4    ] || room == loc[ 5    ]) { 
_if39_cond:
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
  cmp b, 0
  je _if39_exit
_if39_true:
;; print("BATS NEARBY!\n"); 
  mov b, __s43 ; "BATS NEARBY!\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if39_exit
_if39_exit:
_if38_exit:
_if37_exit:
_for36_update:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, g
  jmp _for36_cond
_for36_exit:
;; print("YOU ARE IN ROOM "); printu(loc[ 0  ]+1); print("\n"); 
  mov b, __s44 ; "YOU ARE IN ROOM "
  swp b
  push b
  call print
  add sp, 2
;; printu(loc[ 0  ]+1); print("\n"); 
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
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
;; print("\n"); 
  mov b, __s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print("TUNNELS LEAD TO ");  
  mov b, __s45 ; "TUNNELS LEAD TO "
  swp b
  push b
  call print
  add sp, 2
;; printu(cave[loc[ 0  ]][0]+1); 
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
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
;; printu(cave[loc[ 0  ]][1]+1);  
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
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
;; printu(cave[loc[ 0  ]][2]+1); 
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
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
;; print("\n\n"); 
  mov b, __s46 ; "\n\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

move_or_shoot:
  enter 0 ; (push bp; mov bp, sp)
; $c 
  mov a, $ffffffff
  mov [bp + -1], a
  sub sp, 2
;; while ((c != 'S') && (c != 'M')) { 
_while40_cond:
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
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while40_exit
_while40_block:
;; c = getlet("SHOOT OR MOVE (S-M)"); 
  lea d, [bp + -1] ; $c
  push d
  mov b, __s47 ; "SHOOT OR MOVE (S-M)"
  swp b
  push b
  call getlet
  add sp, 2
  pop d
  mov [d], b
  jmp _while40_cond
_while40_exit:
;; return (c == 'S') ? 1 : 0; 
_ternary41_cond:
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
  je _ternary41_false
_ternary41_true:
  mov b, $1
  jmp _ternary41_exit
_ternary41_false:
  mov b, $0
_ternary41_exit:
  leave
  ret

move_wumpus:
  enter 0 ; (push bp; mov bp, sp)
; $k 
  sub sp, 2
;; k = rand() % 4; 
  lea d, [bp + -1] ; $k
  push d
  call rand
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
_if42_cond:
  lea d, [bp + -1] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _if42_exit
_if42_true:
;; loc[ 1     ] = cave[loc[ 1     ]][k]; 
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
  jmp _if42_exit
_if42_exit:
;; if (loc[ 1     ] == loc[ 0  ]) { 
_if43_cond:
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
  je _if43_exit
_if43_true:
;; print("TSK TSK TSK - WUMPUS GOT YOU!\n"); 
  mov b, __s48 ; "TSK TSK TSK - WUMPUS GOT YOU!\n"
  swp b
  push b
  call print
  add sp, 2
;; finished =  2   ; 
  mov d, _finished ; $finished
  push d
  mov b, $2
  pop d
  mov [d], b
  jmp _if43_exit
_if43_exit:
  leave
  ret

shoot:
  enter 0 ; (push bp; mov bp, sp)
; $path 
; $scratchloc 
  mov a, $ffffffff
  mov [bp + -11], a
; $len 
; $k 
  sub sp, 16
;; finished =  0  ; 
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
_while44_cond:
  lea d, [bp + -13] ; $len
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
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
  cmp b, 0
  je _while44_exit
_while44_block:
;; len = getnum("NO. OF ROOMS (1-5)"); 
  lea d, [bp + -13] ; $len
  push d
  mov b, __s49 ; "NO. OF ROOMS (1-5)"
  swp b
  push b
  call getnum
  add sp, 2
  pop d
  mov [d], b
  jmp _while44_cond
_while44_exit:
;; k = 0; 
  lea d, [bp + -15] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
;; while (k < len) { 
_while45_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _while45_exit
_while45_block:
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
  mov b, __s50 ; "ROOM #"
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
_if46_cond:
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
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if46_exit
_if46_true:
;; print("ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n"); 
  mov b, __s51 ; "ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n"
  swp b
  push b
  call print
  add sp, 2
;; continue;  
  jmp _while45_cond ; while continue
  jmp _if46_exit
_if46_exit:
;; k++; 
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -15] ; $k
  mov [d], b
  mov b, g
  jmp _while45_cond
_while45_exit:
;; scratchloc = loc[ 0  ]; 
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
_for47_init:
  lea d, [bp + -15] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for47_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for47_exit
_for47_block:
;; if ((cave[scratchloc][0] == path[k]) || 
_if48_cond:
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
  cmp b, 0
  je _if48_else
_if48_true:
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
  jmp _if48_exit
_if48_else:
;; scratchloc = cave[scratchloc][rand()%3]; 
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
  call rand
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
_if48_exit:
;; if (scratchloc == loc[ 1     ]) { 
_if49_cond:
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
  je _if49_else
_if49_true:
;; print("AHA! YOU GOT THE WUMPUS!\n"); 
  mov b, __s52 ; "AHA! YOU GOT THE WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
;; finished =  1  ; 
  mov d, _finished ; $finished
  push d
  mov b, $1
  pop d
  mov [d], b
  jmp _if49_exit
_if49_else:
;; if (scratchloc == loc[ 0  ]) { 
_if50_cond:
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
  je _if50_exit
_if50_true:
;; print("OUCH! ARROW GOT YOU!\n"); 
  mov b, __s53 ; "OUCH! ARROW GOT YOU!\n"
  swp b
  push b
  call print
  add sp, 2
;; finished =  2   ; 
  mov d, _finished ; $finished
  push d
  mov b, $2
  pop d
  mov [d], b
  jmp _if50_exit
_if50_exit:
_if49_exit:
;; if (finished !=  0  ) { 
_if51_cond:
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
  je _if51_exit
_if51_true:
;; return; 
  leave
  ret
  jmp _if51_exit
_if51_exit:
_for47_update:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -15] ; $k
  mov [d], b
  mov b, g
  jmp _for47_cond
_for47_exit:
;; print("MISSED\n"); 
  mov b, __s54 ; "MISSED\n"
  swp b
  push b
  call print
  add sp, 2
;; move_wumpus(); 
  call move_wumpus
;; if (--arrows <= 0) { 
_if52_cond:
  mov d, _arrows ; $arrows
  mov b, [d]
  dec b
  mov d, _arrows ; $arrows
  mov [d], b
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if52_exit
_if52_true:
;; finished =  2   ; 
  mov d, _finished ; $finished
  push d
  mov b, $2
  pop d
  mov [d], b
  jmp _if52_exit
_if52_exit:
  leave
  ret

move:
  enter 0 ; (push bp; mov bp, sp)
; $scratchloc 
  sub sp, 2
;; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
;; while (scratchloc == -1) { 
_while53_cond:
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
  je _while53_exit
_while53_block:
;; scratchloc = getnum("WHERE TO")-1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov b, __s55 ; "WHERE TO"
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
_if54_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
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
  cmp b, 0
  je _if54_exit
_if54_true:
;; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
;; continue; 
  jmp _while53_cond ; while continue
  jmp _if54_exit
_if54_exit:
;; if ((cave[loc[ 0  ]][0] != scratchloc) & 
_if55_cond:
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
  and a, b ; &
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
  and a, b ; &
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
  and a, b ; &
  mov b, a
  pop a
  cmp b, 0
  je _if55_exit
_if55_true:
;; print("NOT POSSIBLE\n"); 
  mov b, __s56 ; "NOT POSSIBLE\n"
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
  jmp _while53_cond ; while continue
  jmp _if55_exit
_if55_exit:
  jmp _while53_cond
_while53_exit:
;; loc[ 0  ] = scratchloc; 
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
;; while ((scratchloc == loc[ 4    ]) || (scratchloc == loc[ 5    ])) { 
_while56_cond:
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
  cmp b, 0
  je _while56_exit
_while56_block:
;; print("ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n"); 
  mov b, __s57 ; "ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n"
  swp b
  push b
  call print
  add sp, 2
;; scratchloc = loc[ 0  ] = rand()%20; 
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
  call rand
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
  jmp _while56_cond
_while56_exit:
;; if (scratchloc == loc[ 1     ]) { 
_if57_cond:
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
  je _if57_exit
_if57_true:
;; print("... OOPS! BUMPED A WUMPUS!\n"); 
  mov b, __s58 ; "... OOPS! BUMPED A WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
;; move_wumpus(); 
  call move_wumpus
  jmp _if57_exit
_if57_exit:
;; if (scratchloc == loc[ 2   ] || scratchloc == loc[ 3   ]) { 
_if58_cond:
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
  cmp b, 0
  je _if58_exit
_if58_true:
;; print("YYYYIIIIEEEE . . . FELL IN PIT\n"); 
  mov b, __s59 ; "YYYYIIIIEEEE . . . FELL IN PIT\n"
  swp b
  push b
  call print
  add sp, 2
;; finished =  2   ; 
  mov d, _finished ; $finished
  push d
  mov b, $2
  pop d
  mov [d], b
  jmp _if58_exit
_if58_exit:
  leave
  ret

game_setup:
  enter 0 ; (push bp; mov bp, sp)
; $j 
; $k 
  sub sp, 4
;; for (j = 0; j <  6   ; j++) { 
_for59_init:
  lea d, [bp + -1] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for59_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $6
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for59_exit
_for59_block:
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
_while60_cond:
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
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _while60_exit
_while60_block:
;; loc[j] = rand()%20; 
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call rand
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
_for61_init:
  lea d, [bp + -3] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for61_cond:
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
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for61_exit
_for61_block:
;; if (loc[j] == loc[k]) { 
_if62_cond:
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
  je _if62_exit
_if62_true:
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
  jmp _if62_exit
_if62_exit:
_for61_update:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, g
  jmp _for61_cond
_for61_exit:
  jmp _while60_cond
_while60_exit:
_for59_update:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $j
  mov [d], b
  mov b, g
  jmp _for59_cond
_for59_exit:
  leave
  ret

game_play:
  enter 0 ; (push bp; mov bp, sp)
; $c 
  sub sp, 2
;; arrows = 5; 
  mov d, _arrows ; $arrows
  push d
  mov b, $5
  pop d
  mov [d], b
;; print("HUNT THE WUMPUS\n"); 
  mov b, __s60 ; "HUNT THE WUMPUS\n"
  swp b
  push b
  call print
  add sp, 2
;; if (debug) { 
_if63_cond:
  mov d, _debug ; $debug
  mov b, [d]
  cmp b, 0
  je _if63_exit
_if63_true:
;; print("Wumpus is at "); printu(loc[ 1     ]+1); 
  mov b, __s61 ; "Wumpus is at "
  swp b
  push b
  call print
  add sp, 2
;; printu(loc[ 1     ]+1); 
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
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
;; print(", pits at "); printu(loc[ 2   ]+1); 
  mov b, __s62 ; ", pits at "
  swp b
  push b
  call print
  add sp, 2
;; printu(loc[ 2   ]+1); 
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
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
;; print(" & "); printu(loc[ 3   ]+1); 
  mov b, __s63 ; " & "
  swp b
  push b
  call print
  add sp, 2
;; printu(loc[ 3   ]+1); 
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
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
;; print(", bats at "); printu(loc[ 4    ]+1); 
  mov b, __s64 ; ", bats at "
  swp b
  push b
  call print
  add sp, 2
;; printu(loc[ 4    ]+1); 
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
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
;; print(" & "); printu(loc[ 5    ]+1); 
  mov b, __s63 ; " & "
  swp b
  push b
  call print
  add sp, 2
;; printu(loc[ 5    ]+1); 
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
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
  jmp _if63_exit
_if63_exit:
;; finished =  0  ; 
  mov d, _finished ; $finished
  push d
  mov b, $0
  pop d
  mov [d], b
;; while (finished ==  0  ) { 
_while64_cond:
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
  je _while64_exit
_while64_block:
;; show_room(); 
  call show_room
;; if (move_or_shoot()) { 
_if65_cond:
  call move_or_shoot
  cmp b, 0
  je _if65_else
_if65_true:
;; shoot(); 
  call shoot
  jmp _if65_exit
_if65_else:
;; move(); 
  call move
_if65_exit:
  jmp _while64_cond
_while64_exit:
;; if (finished ==  1  ) { 
_if66_cond:
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
  je _if66_exit
_if66_true:
;; print("HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n"); 
  mov b, __s65 ; "HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if66_exit
_if66_exit:
;; if (finished ==  2   ) { 
_if67_cond:
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
  je _if67_exit
_if67_true:
;; print("HA HA HA - YOU LOSE!\n"); 
  mov b, __s66 ; "HA HA HA - YOU LOSE!\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if67_exit
_if67_exit:
;; c = getlet("NEW GAME (Y-N)"); 
  lea d, [bp + -1] ; $c
  push d
  mov b, __s1 ; "NEW GAME (Y-N)"
  swp b
  push b
  call getlet
  add sp, 2
  pop d
  mov [d], b
;; if (c == 'N') { 
_if68_cond:
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
  je _if68_exit
_if68_true:
;; exit(); 
  call exit
  jmp _if68_exit
_if68_exit:
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_arrows: .fill 2, 0
_debug: .dw 0
_loc_data: .fill 12, 0
_finished: .fill 2, 0
_cave_data: 
.dw 
.dw 1,4,7,0,2,9,1,3,11,2,4,13,0,3,5,4,6,14,5,7,16,0,6,8,7,9,17,1,8,10,
.dw 
.dw 
.dw 9,11,18,2,10,12,11,13,19,3,12,14,5,13,15,14,16,19,6,15,17,8,16,18,10,17,19,12,15,18,
.dw 
.dw 
__s0: .db "INSTRUCTIONS (Y-N)", 0
__s1: .db "NEW GAME (Y-N)", 0
__s2: .db "Unknown type size in va_arg() call. Size needs to be either 1 or 2.", 0
__s3: .db "Error: Unknown argument type.\n", 0
__s4: .db "\033[2J\033[H", 0
__s5: .db "WELCOME TO 'HUNT THE WUMPUS'\n", 0
__s6: .db "THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM\n", 0
__s7: .db "HAS 3 TUNNELS LEADING TO OTHER ROOMS. (LOOK AT A\n", 0
__s8: .db "DODECAHEDRON TO SEE HOW THIS WORKS-IF YOU DON'T KNOW\n", 0
__s9: .db "WHAT A DODECAHEDRON IS, ASK SOMEONE)\n", 0
__s10: .db "\n", 0
__s11: .db " HAZARDS:\n", 0
__s12: .db " BOTTOMLESS PITS: TWO ROOMS HAVE BOTTOMLESS PITS IN THEM\n", 0
__s13: .db " IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)\n", 0
__s14: .db " SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n", 0
__s15: .db " GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n", 0
__s16: .db " ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n", 0
__s17: .db " WUMPUS:\n", 0
__s18: .db " THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n", 0
__s19: .db " FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n", 0
__s20: .db " HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n", 0
__s21: .db " ARROW OR YOU ENTERING HIS ROOM.\n", 0
__s22: .db " IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n", 0
__s23: .db " OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n", 0
__s24: .db " ARE, HE EATS YOU UP AND YOU LOSE!\n", 0
__s25: .db " YOU:\n", 0
__s26: .db " EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n", 0
__s27: .db " MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n", 0
__s28: .db " ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n", 0
__s29: .db " EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n", 0
__s30: .db "   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n", 0
__s31: .db "   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n", 0
__s32: .db "   AT RANDOM TO THE NEXT ROOM.\n", 0
__s33: .db "     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n", 0
__s34: .db "     IF THE ARROW HITS YOU, YOU LOSE.\n", 0
__s35: .db " WARNINGS:\n", 0
__s36: .db " WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n", 0
__s37: .db " THE COMPUTER SAYS:\n", 0
__s38: .db " WUMPUS:  'I SMELL A WUMPUS'\n", 0
__s39: .db " BAT   :  'BATS NEARBY'\n", 0
__s40: .db " PIT   :  'I FEEL A DRAFT'\n", 0
__s41: .db "I SMELL A WUMPUS!\n", 0
__s42: .db "I FEEL A DRAFT\n", 0
__s43: .db "BATS NEARBY!\n", 0
__s44: .db "YOU ARE IN ROOM ", 0
__s45: .db "TUNNELS LEAD TO ", 0
__s46: .db "\n\n", 0
__s47: .db "SHOOT OR MOVE (S-M)", 0
__s48: .db "TSK TSK TSK - WUMPUS GOT YOU!\n", 0
__s49: .db "NO. OF ROOMS (1-5)", 0
__s50: .db "ROOM #", 0
__s51: .db "ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n", 0
__s52: .db "AHA! YOU GOT THE WUMPUS!\n", 0
__s53: .db "OUCH! ARROW GOT YOU!\n", 0
__s54: .db "MISSED\n", 0
__s55: .db "WHERE TO", 0
__s56: .db "NOT POSSIBLE\n", 0
__s57: .db "ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n", 0
__s58: .db "... OOPS! BUMPED A WUMPUS!\n", 0
__s59: .db "YYYYIIIIEEEE . . . FELL IN PIT\n", 0
__s60: .db "HUNT THE WUMPUS\n", 0
__s61: .db "Wumpus is at ", 0
__s62: .db ", pits at ", 0
__s63: .db " & ", 0
__s64: .db ", bats at ", 0
__s65: .db "HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n", 0
__s66: .db "HA HA HA - YOU LOSE!\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
