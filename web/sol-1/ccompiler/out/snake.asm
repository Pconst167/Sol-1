; --- FILENAME: programs/snake
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $i 
  sub sp, 2
;; for (i = 0; i < 8; i++) { 
_for1_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for1_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
;; snake_x[i] = 20 - i; 
  mov d, _snake_x_data ; $snake_x
  push a         
  mov b, [bp + -1] ; $i                     
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a         
  mov b, $14
; START TERMS
  push a
  mov a, b
  mov b, [bp + -1] ; $i             
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; snake_y[i] = 10; 
  mov d, _snake_y_data ; $snake_y
  push a         
  mov b, [bp + -1] ; $i                     
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a         
  mov b, $a        
  mov [d], b
_for1_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for1_cond
_for1_exit:
;; while (1) { 
_while2_cond:
  mov b, $1
  cmp b, 0
  je _while2_exit
_while2_block:
;; draw_board(); 
  call draw_board
;; update_snake(); 
  call update_snake
  jmp _while2_cond
_while2_exit:
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
  mov b, [bp + 5] ; $src                     
  mov [d], b
;; pdest = dest; 
  lea d, [bp + -3] ; $pdest         
  mov b, [bp + 7] ; $dest                     
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while3_cond:
  mov b, [bp + -1] ; $psrc             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while3_exit
_while3_block:
;; *pdest++ = *psrc++; 
  mov b, [bp + -3] ; $pdest             
  mov g, b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -1] ; $psrc             
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
  jmp _while3_cond
_while3_exit:
;; *pdest = '\0'; 
  mov b, [bp + -3] ; $pdest             
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
  mov b, [bp + 7] ; $s1             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, [bp + 7] ; $s1             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $s2             
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
  je _while4_exit
_while4_block:
;; s1++; 
  mov b, [bp + 7] ; $s1             
  mov g, b
  inc b
  lea d, [bp + 7] ; $s1
  mov [d], b
  mov b, g
;; s2++; 
  mov b, [bp + 5] ; $s2             
  mov g, b
  inc b
  lea d, [bp + 5] ; $s2
  mov [d], b
  mov b, g
  jmp _while4_cond
_while4_exit:
;; return *s1 - *s2; 
  mov b, [bp + 7] ; $s1             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $s2             
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
  mov b, [bp + 7] ; $dest             
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; src[i] != 0; i=i+1) { 
_for5_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for5_cond:
  lea d, [bp + 5] ; $src
  mov d, [d]
  push a         
  mov b, [bp + -3] ; $i                     
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
  lea d, [bp + 7] ; $dest
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $dest_len             
; START TERMS
  push a
  mov a, b
  mov b, [bp + -3] ; $i             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + 5] ; $src
  mov d, [d]
  push a         
  mov b, [bp + -3] ; $i                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for5_update:
  lea d, [bp + -3] ; $i         
  mov b, [bp + -3] ; $i             
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  jmp _for5_cond
_for5_exit:
;; dest[dest_len + i] = 0; 
  lea d, [bp + 7] ; $dest
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $dest_len             
; START TERMS
  push a
  mov a, b
  mov b, [bp + -3] ; $i             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a         
  mov b, $0        
  mov [d], bl
;; return dest; 
  mov b, [bp + 7] ; $dest             
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; $length 
  sub sp, 2
;; length = 0; 
  lea d, [bp + -1] ; $length         
  mov b, $0        
  mov [d], b
;; while (str[length] != 0) { 
_while6_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $length                     
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
  mov b, [bp + -1] ; $length             
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while6_cond
_while6_exit:
;; return length; 
  mov b, [bp + -1] ; $length             
  leave
  ret

va_arg:
  enter 0 ; (push bp; mov bp, sp)
; $val 
  sub sp, 2
;; if(size == 1){ 
_if7_cond:
  mov b, [bp + 5] ; $size             
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if7_else
_if7_true:
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
  jmp _if7_exit
_if7_else:
;; if(size == 2){ 
_if8_cond:
  mov b, [bp + 5] ; $size             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if8_else
_if8_true:
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
  jmp _if8_exit
_if8_else:
;; print("Unknown type size in va_arg() call. Size needs to be either 1 or 2."); 
  mov b, __s0 ; "Unknown type size in va_arg() call. Size needs to be either 1 or 2."
  swp b
  push b
  call print
  add sp, 2
_if8_exit:
_if7_exit:
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
  mov b, [bp + 5] ; $size             
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return val; 
  mov b, [bp + -1] ; $val             
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
  mov b, [bp + 5] ; $format                     
  mov [d], b
;; p = &format; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
  pop d
  mov [d], b
;; for(;;){ 
_for9_init:
_for9_cond:
_for9_block:
;; if(!*fp) break; 
_if10_cond:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if10_exit
_if10_true:
;; break; 
  jmp _for9_exit ; for break
  jmp _if10_exit
_if10_exit:
;; if(*fp == '%'){ 
_if11_cond:
  mov b, [bp + -3] ; $fp             
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
  je _if11_else
_if11_true:
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
;; switch(*fp){ 
_switch12_expr:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch12_comparisons:
  cmp bl, $64
  je _switch12_case0
  cmp bl, $69
  je _switch12_case1
  cmp bl, $75
  je _switch12_case2
  cmp bl, $78
  je _switch12_case3
  cmp bl, $63
  je _switch12_case4
  cmp bl, $73
  je _switch12_case5
  jmp _switch12_default
  jmp _switch12_exit
_switch12_case0:
_switch12_case1:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; prints(*(int*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; break; 
  jmp _switch12_exit ; case break
_switch12_case2:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; printu(*(unsigned int*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; break; 
  jmp _switch12_exit ; case break
_switch12_case3:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; printx16(*(unsigned int*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call printx16
  add sp, 2
;; break; 
  jmp _switch12_exit ; case break
_switch12_case4:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; putchar(*(char*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; break; 
  jmp _switch12_exit ; case break
_switch12_case5:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; print(*(char**)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; break; 
  jmp _switch12_exit ; case break
_switch12_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s1 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch12_exit:
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
  jmp _if11_exit
_if11_else:
;; putchar(*fp); 
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
_if11_exit:
_for9_update:
  jmp _for9_cond
_for9_exit:
  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov b, [bp + 5] ; $hex             
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
  mov b, [bp + 5] ; $hex_string             
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; i < len; i++) { 
_for13_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for13_cond:
  mov b, [bp + -3] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + -6] ; $len             
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for13_exit
_for13_block:
;; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
  lea d, [bp + 5] ; $hex_string
  mov d, [d]
  push a         
  mov b, [bp + -3] ; $i                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (hex_char >= 'a' && hex_char <= 'f')  
_if14_cond:
  mov bl, [bp + -4] ; $hex_char
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
  mov bl, [bp + -4] ; $hex_char
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
  je _if14_else
_if14_true:
;; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value         
  mov b, [bp + -1] ; $value             
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
  mov bl, [bp + -4] ; $hex_char
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
  mov [d], b
  jmp _if14_exit
_if14_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if15_cond:
  mov bl, [bp + -4] ; $hex_char
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
  mov bl, [bp + -4] ; $hex_char
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
  je _if15_else
_if15_true:
;; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value         
  mov b, [bp + -1] ; $value             
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
  mov bl, [bp + -4] ; $hex_char
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
  mov [d], b
  jmp _if15_exit
_if15_else:
;; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value         
  mov b, [bp + -1] ; $value             
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
  mov bl, [bp + -4] ; $hex_char
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
  mov [d], b
_if15_exit:
_if14_exit:
_for13_update:
  mov b, [bp + -3] ; $i             
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for13_cond
_for13_exit:
;; return value; 
  mov b, [bp + -1] ; $value             
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
_while16_cond:
  mov b, [bp + 5] ; $str             
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
  je _while16_exit
_while16_block:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while16_cond
_while16_exit:
;; if (*str == '-' || *str == '+') { 
_if17_cond:
  mov b, [bp + 5] ; $str             
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
  mov b, [bp + 5] ; $str             
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
  je _if17_exit
_if17_true:
;; if (*str == '-') sign = -1; 
_if18_cond:
  mov b, [bp + 5] ; $str             
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
  je _if18_exit
_if18_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign         
  mov b, $1
  neg b        
  mov [d], b
  jmp _if18_exit
_if18_exit:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if17_exit
_if17_exit:
;; while (*str >= '0' && *str <= '9') { 
_while19_cond:
  mov b, [bp + 5] ; $str             
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
  mov b, [bp + 5] ; $str             
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
  je _while19_exit
_while19_block:
;; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  mov b, [bp + -1] ; $result             
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
  mov b, [bp + 5] ; $str             
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
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while19_cond
_while19_exit:
;; return sign * result; 
  mov b, [bp + -3] ; $sign             
; START FACTORS
  push a
  mov a, b
  mov b, [bp + -1] ; $result             
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
  mov a, [bp + 5] ; $s             
  mov d, a
  call _gets
; --- END INLINE ASM BLOCK

;; return strlen(s); 
  mov b, [bp + 5] ; $s             
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
_if20_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _if20_else
_if20_true:
;; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
;; num = -num; 
  lea d, [bp + 5] ; $num         
  mov b, [bp + 5] ; $num             
  neg b        
  mov [d], b
  jmp _if20_exit
_if20_else:
;; if (num == 0) { 
_if21_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if21_exit
_if21_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if21_exit
_if21_exit:
_if20_exit:
;; while (num > 0) { 
_while22_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while22_exit
_while22_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a         
  mov b, $30
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $num             
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
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num         
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS        
  mov [d], b
;; i++; 
  mov b, [bp + -6] ; $i             
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while22_cond
_while22_exit:
;; while (i > 0) { 
_while23_cond:
  mov b, [bp + -6] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while23_exit
_while23_block:
;; i--; 
  mov b, [bp + -6] ; $i             
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while23_cond
_while23_exit:
  leave
  ret

printu:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  sub sp, 7
;; i = 0; 
  lea d, [bp + -6] ; $i         
  mov b, $0        
  mov [d], b
;; if(num == 0){ 
_if24_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if24_exit
_if24_exit:
;; while (num > 0) { 
_while25_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while25_exit
_while25_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a         
  mov b, $30
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $num             
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
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num         
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS        
  mov [d], b
;; i++; 
  mov b, [bp + -6] ; $i             
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while25_cond
_while25_exit:
;; while (i > 0) { 
_while26_cond:
  mov b, [bp + -6] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while26_exit
_while26_block:
;; i--; 
  mov b, [bp + -6] ; $i             
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while26_cond
_while26_exit:
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
  mov al, [bp + 0] ; $sec
            
; --- END INLINE ASM BLOCK

;; return sec; 
  mov bl, [bp + 0] ; $sec
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
  mov al, [bp + 5] ; $c
            
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
  mov bl, [bp + 0] ; $c
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
  mov b, [bp + -1] ; $m             
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov a, [bp + 5] ; $s             
  mov d, a
  call _puts
  mov ah, $0A
  mov al, 0
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
  mov a, [bp + 5] ; $destination             
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
  mov b, [_heap_top] ; $heap_top           
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $bytes             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; return heap_top - bytes; 
  mov b, [_heap_top] ; $heap_top           
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $bytes             
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
  mov b, [_heap_top] ; $heap_top           
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $bytes             
  sub a, b
  mov b, a
  pop a
; END TERMS        
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
  mov bl, [bp + 0] ; $data
  mov bh, 0             
  leave
  ret

clear:
  enter 0 ; (push bp; mov bp, sp)
;; print("\033[2J\033[H"); 
  mov b, __s2 ; "\033[2J\033[H"
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

draw_board:
  enter 0 ; (push bp; mov bp, sp)
; $x 
; $y 
; $i 
; $c 
  sub sp, 7
;; print(s); 
  mov b, _s_data ; $s           
  swp b
  push b
  call print
  add sp, 2
;; printu(rand()); 
  call rand
  swp b
  push b
  call printu
  add sp, 2
;; print("\n"); 
  mov b, __s3 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; for (y = 0; y < 20; y++) { 
_for27_init:
  lea d, [bp + -3] ; $y         
  mov b, $0        
  mov [d], b
_for27_cond:
  mov b, [bp + -3] ; $y             
; START RELATIONAL
  push a
  mov a, b
  mov b, $14
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for27_exit
_for27_block:
;; for (x = 0; x < 40; x++) { 
_for28_init:
  lea d, [bp + -1] ; $x         
  mov b, $0        
  mov [d], b
_for28_cond:
  mov b, [bp + -1] ; $x             
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for28_exit
_for28_block:
;; c = ' '; 
  lea d, [bp + -6] ; $c         
  mov b, $20        
  mov [d], bl
;; if (x == 0 || x == 39 || y == 0 || y == 19) { 
_if29_cond:
  mov b, [bp + -1] ; $x             
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
  mov b, [bp + -1] ; $x             
; START RELATIONAL
  push a
  mov a, b
  mov b, $27
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov b, [bp + -3] ; $y             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov b, [bp + -3] ; $y             
; START RELATIONAL
  push a
  mov a, b
  mov b, $13
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if29_else
_if29_true:
;; c = '#'; 
  lea d, [bp + -6] ; $c         
  mov b, $23        
  mov [d], bl
  jmp _if29_exit
_if29_else:
;; for (i = 0; i < 8; i++) { 
_for30_init:
  lea d, [bp + -5] ; $i         
  mov b, $0        
  mov [d], b
_for30_cond:
  mov b, [bp + -5] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for30_exit
_for30_block:
;; if (x == snake_x[i] && y == snake_y[i]) { 
_if31_cond:
  mov b, [bp + -1] ; $x             
; START RELATIONAL
  push a
  mov a, b
  mov d, _snake_x_data ; $snake_x
  push a         
  mov b, [bp + -5] ; $i                     
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [bp + -3] ; $y             
; START RELATIONAL
  push a
  mov a, b
  mov d, _snake_y_data ; $snake_y
  push a         
  mov b, [bp + -5] ; $i                     
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
  je _if31_exit
_if31_true:
;; c = 'o'; 
  lea d, [bp + -6] ; $c         
  mov b, $6f        
  mov [d], bl
;; break; 
  jmp _for30_exit ; for break
  jmp _if31_exit
_if31_exit:
_for30_update:
  mov b, [bp + -5] ; $i             
  mov g, b
  inc b
  lea d, [bp + -5] ; $i
  mov [d], b
  mov b, g
  jmp _for30_cond
_for30_exit:
_if29_exit:
;; putchar(c); 
  mov bl, [bp + -6] ; $c
  mov bh, 0             
  push bl
  call putchar
  add sp, 1
_for28_update:
  mov b, [bp + -1] ; $x             
  mov g, b
  inc b
  lea d, [bp + -1] ; $x
  mov [d], b
  mov b, g
  jmp _for28_cond
_for28_exit:
;; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
_for27_update:
  mov b, [bp + -3] ; $y             
  mov g, b
  inc b
  lea d, [bp + -3] ; $y
  mov [d], b
  mov b, g
  jmp _for27_cond
_for27_exit:
;; return; 
  leave
  ret

update_snake:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $snkx 
; $snky 
  sub sp, 6
;; for (i = 8 - 1; i > 0; i--) { 
_for32_init:
  lea d, [bp + -1] ; $i         
  mov b, $8
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
_for32_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _for32_exit
_for32_block:
;; snake_x[i] = snake_x[i - 1]; 
  mov d, _snake_x_data ; $snake_x
  push a         
  mov b, [bp + -1] ; $i                     
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _snake_x_data ; $snake_x
  push a         
  mov b, [bp + -1] ; $i             
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
;; snake_y[i] = snake_y[i - 1]; 
  mov d, _snake_y_data ; $snake_y
  push a         
  mov b, [bp + -1] ; $i                     
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _snake_y_data ; $snake_y
  push a         
  mov b, [bp + -1] ; $i             
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
_for32_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  dec b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for32_cond
_for32_exit:
;; snake_x[0] = snake_x[0] + dx; 
  mov d, _snake_x_data ; $snake_x
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _snake_x_data ; $snake_x
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, [_dx] ; $dx           
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; snake_y[0] = snake_y[0] + dy; 
  mov d, _snake_y_data ; $snake_y
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _snake_y_data ; $snake_y
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, [_dy] ; $dy           
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if (rand() % 10 < 2) { // Randomly change direction 
_if33_cond:
  call rand
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _if33_exit
_if33_true:
;; if (dx != 0) { 
_if34_cond:
  mov b, [_dx] ; $dx           
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if34_else
_if34_true:
;; dy = rand() % 2 == 0 ? 1 : -1; 
  mov d, _dy ; $dy
  push d
_ternary35_cond:
  call rand
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _ternary35_false
_ternary35_true:
  mov b, $1
  jmp _ternary35_exit
_ternary35_false:
  mov b, $1
  neg b
_ternary35_exit:
  pop d
  mov [d], b
;; dx = 0; 
  mov d, _dx ; $dx         
  mov b, $0        
  mov [d], b
  jmp _if34_exit
_if34_else:
;; if (dy != 0) { 
_if36_cond:
  mov b, [_dy] ; $dy           
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if36_exit
_if36_true:
;; dx = rand() % 2 == 0 ? 1 : -1; 
  mov d, _dx ; $dx
  push d
_ternary37_cond:
  call rand
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _ternary37_false
_ternary37_true:
  mov b, $1
  jmp _ternary37_exit
_ternary37_false:
  mov b, $1
  neg b
_ternary37_exit:
  pop d
  mov [d], b
;; dy = 0; 
  mov d, _dy ; $dy         
  mov b, $0        
  mov [d], b
  jmp _if36_exit
_if36_exit:
_if34_exit:
  jmp _if33_exit
_if33_exit:
;; snkx = snake_x[0]; 
  lea d, [bp + -3] ; $snkx
  push d
  mov d, _snake_x_data ; $snake_x
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
;; snky = snake_y[0]; 
  lea d, [bp + -5] ; $snky
  push d
  mov d, _snake_y_data ; $snake_y
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
;; if (snkx <= 0) { 
_if38_cond:
  mov b, [bp + -3] ; $snkx             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if38_else
_if38_true:
;; snake_x[0] = 1; 
  mov d, _snake_x_data ; $snake_x
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a         
  mov b, $1        
  mov [d], b
;; dx = 1; 
  mov d, _dx ; $dx         
  mov b, $1        
  mov [d], b
;; dy = 0; 
  mov d, _dy ; $dy         
  mov b, $0        
  mov [d], b
  jmp _if38_exit
_if38_else:
;; if (snkx >= 39) { 
_if39_cond:
  mov b, [bp + -3] ; $snkx             
; START RELATIONAL
  push a
  mov a, b
  mov b, $27
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if39_else
_if39_true:
;; snake_x[0] = 38; 
  mov d, _snake_x_data ; $snake_x
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a         
  mov b, $26        
  mov [d], b
;; dx = -1; 
  mov d, _dx ; $dx         
  mov b, $1
  neg b        
  mov [d], b
;; dy = 0; 
  mov d, _dy ; $dy         
  mov b, $0        
  mov [d], b
  jmp _if39_exit
_if39_else:
;; if (snky <= 0) { 
_if40_cond:
  mov b, [bp + -5] ; $snky             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if40_else
_if40_true:
;; snake_y[0] = 1; 
  mov d, _snake_y_data ; $snake_y
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a         
  mov b, $1        
  mov [d], b
;; dy = 1; 
  mov d, _dy ; $dy         
  mov b, $1        
  mov [d], b
;; dx = 0; 
  mov d, _dx ; $dx         
  mov b, $0        
  mov [d], b
  jmp _if40_exit
_if40_else:
;; if (snky >= 19) { 
_if41_cond:
  mov b, [bp + -5] ; $snky             
; START RELATIONAL
  push a
  mov a, b
  mov b, $13
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if41_exit
_if41_true:
;; snake_y[0] = 18; 
  mov d, _snake_y_data ; $snake_y
  push a         
  mov b, $0        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a         
  mov b, $12        
  mov [d], b
;; dy = -1; 
  mov d, _dy ; $dy         
  mov b, $1
  neg b        
  mov [d], b
;; dx = 0; 
  mov d, _dx ; $dx         
  mov b, $0        
  mov [d], b
  jmp _if41_exit
_if41_exit:
_if40_exit:
_if39_exit:
_if38_exit:
;; return; 
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_s_data: 
.db 27,$5b,$32,$4a,27,$5b,$48,0,
_snake_x_data: .fill 16, 0
_snake_y_data: .fill 16, 0
_dx: .dw 1
_dy: .dw 0
__s0: .db "Unknown type size in va_arg() call. Size needs to be either 1 or 2.", 0
__s1: .db "Error: Unknown argument type.\n", 0
__s2: .db "\033[2J\033[H", 0
__s3: .db "\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
