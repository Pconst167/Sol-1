; --- FILENAME: games/startrek
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; intro(); 
  call intro
;; new_game(); 
  call new_game
;; return (0); 
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
_while1_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while1_exit
_while1_block:
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
  jmp _while1_cond
_while1_exit:
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
_while2_cond:
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
  je _while2_exit
_while2_block:
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
  jmp _while2_cond
_while2_exit:
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _for3_exit
_for3_block:
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
_for3_update:
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
  jmp _for3_cond
_for3_exit:
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while4_exit
_while4_block:
;; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  pop b
  jmp _while4_cond
_while4_exit:
;; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
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
_for5_init:
_for5_cond:
_for5_block:
;; if(!*format_p) break; 
_if6_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if6_else
_if6_true:
;; break; 
  jmp _for5_exit ; for break
  jmp _if6_exit
_if6_else:
;; if(*format_p == '%'){ 
_if7_cond:
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
  je _if7_else
_if7_true:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; switch(*format_p){ 
_switch8_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch8_comparisons:
  cmp bl, $6c
  je _switch8_case0
  cmp bl, $4c
  je _switch8_case1
  cmp bl, $64
  je _switch8_case2
  cmp bl, $69
  je _switch8_case3
  cmp bl, $75
  je _switch8_case4
  cmp bl, $78
  je _switch8_case5
  cmp bl, $63
  je _switch8_case6
  cmp bl, $73
  je _switch8_case7
  jmp _switch8_default
  jmp _switch8_exit
_switch8_case0:
_switch8_case1:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; if(*format_p == 'd' || *format_p == 'i') 
_if9_cond:
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
  je _if9_else
_if9_true:
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
  jmp _if9_exit
_if9_else:
;; if(*format_p == 'u') 
_if10_cond:
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
  je _if10_else
_if10_true:
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
  jmp _if10_exit
_if10_else:
;; if(*format_p == 'x') 
_if11_cond:
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
  je _if11_else
_if11_true:
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
  jmp _if11_exit
_if11_else:
;; err("Unexpected format in printf."); 
  mov b, __s29 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if11_exit:
_if10_exit:
_if9_exit:
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
  jmp _switch8_exit ; case break
_switch8_case2:
_switch8_case3:
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
  jmp _switch8_exit ; case break
_switch8_case4:
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
  jmp _switch8_exit ; case break
_switch8_case5:

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
  jmp _switch8_exit ; case break
_switch8_case6:

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
  jmp _switch8_exit ; case break
_switch8_case7:

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
  jmp _switch8_exit ; case break
_switch8_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s30 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch8_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
  jmp _if7_exit
_if7_else:
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
_if7_exit:
_if6_exit:
_for5_update:
  jmp _for5_cond
_for5_exit:
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
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; if(*format_p == 'd' || *format_p == 'i'); 
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
  je _if16_else
_if16_true:
;; ; 
  jmp _if16_exit
_if16_else:
;; if(*format_p == 'u'); 
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
;; ; 
  jmp _if17_exit
_if17_else:
;; if(*format_p == 'x'); 
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
;; ; 
  jmp _if18_exit
_if18_else:
;; err("Unexpected format in printf."); 
  mov b, __s29 ; "Unexpected format in printf."
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
  jmp _switch15_exit ; case break
_switch15_case4:
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
  jmp _switch15_exit ; case break
_switch15_case5:
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
  jmp _switch15_exit ; case break
_switch15_case7:
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
  jmp _switch15_exit ; case break
_switch15_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s30 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch15_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
_if14_exit:
_if13_exit:
_for12_update:
  jmp _for12_cond
_for12_exit:
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
  slt ; < (signed)
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
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
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
_if21_exit:
_if20_exit:
_for19_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for19_cond
_for19_exit:
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
_if22_cond:
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
  je _if22_else
_if22_true:
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
  jmp _if22_exit
_if22_else:
;; if (num == 0) { 
_if23_cond:
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
  je _if23_exit
_if23_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if23_exit
_if23_exit:
_if22_exit:
;; while (num > 0) { 
_while24_cond:
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
  je _while24_exit
_while24_block:
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
  jmp _while24_cond
_while24_exit:
;; while (i > 0) { 
_while25_cond:
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
  je _while25_exit
_while25_block:
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
  jmp _while25_cond
_while25_exit:
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
_if26_cond:
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
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  neg b
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if26_exit
_if26_else:
;; if (num == 0) { 
_if27_cond:
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
  je _while28_exit
_while28_block:
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
  jmp _while28_cond
_while28_exit:
;; while (i > 0) { 
_while29_cond:
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
  je _while29_exit
_while29_block:
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
  jmp _while29_cond
_while29_exit:
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
_if30_cond:
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
  je _while31_exit
_while31_block:
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
  jmp _while31_cond
_while31_exit:
;; while (i > 0) { 
_while32_cond:
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
  je _while32_exit
_while32_block:
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
  jmp _while32_cond
_while32_exit:
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
;; while (num > 0) { 
_while34_cond:
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
  mov b, __s31 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
;; return i < 0 ? -i : i; 
_ternary36_cond:
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
  je _ternary36_false
_ternary36_true:
  lea d, [bp + 5] ; $i
  mov b, [d]
  neg b
  jmp _ternary36_exit
_ternary36_false:
  lea d, [bp + 5] ; $i
  mov b, [d]
_ternary36_exit:
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/asm/stdio.asm"
; --- END INLINE ASM BLOCK

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
_for37_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for37_cond:
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
  je _for37_exit
_for37_block:
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
_for37_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for37_cond
_for37_exit:
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
_while38_cond:
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
  je _while38_exit
_while38_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _while38_cond
_while38_exit:
;; if (*str == '-' || *str == '+') { 
_if39_cond:
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
  je _if39_exit
_if39_true:
;; if (*str == '-') sign = -1; 
_if40_cond:
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
  je _if40_exit
_if40_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $ffff
  pop d
  mov [d], b
  jmp _if40_exit
_if40_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _if39_exit
_if39_exit:
;; while (*str >= '0' && *str <= '9') { 
_while41_cond:
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
  je _while41_exit
_while41_block:
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
  jmp _while41_cond
_while41_exit:
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
_if42_cond:
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
  je _if42_else
_if42_true:
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
  jmp _if42_exit
_if42_else:
;; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if42_exit:
  leave
  ret

toupper:
  enter 0 ; (push bp; mov bp, sp)
;; if (ch >= 'a' && ch <= 'z')  
_if43_cond:
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
  je _if43_else
_if43_true:
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
  jmp _if43_exit
_if43_else:
;; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if43_exit:
  leave
  ret

is_delimiter:
  enter 0 ; (push bp; mov bp, sp)
;; if( 
_if44_cond:
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
  je _if44_else
_if44_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if44_exit
_if44_else:
;; return 0; 
  mov b, $0
  leave
  ret
_if44_exit:
  leave
  ret

TO_FIXED:
  enter 0 ; (push bp; mov bp, sp)
;; return x * 10; 
  lea d, [bp + 5] ; $x
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
  leave
  ret

FROM_FIXED:
  enter 0 ; (push bp; mov bp, sp)
;; return x / 10; 
  lea d, [bp + 5] ; $x
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  leave
  ret

TO_FIXED00:
  enter 0 ; (push bp; mov bp, sp)
;; return x * 100; 
  lea d, [bp + 5] ; $x
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  leave
  ret

FROM_FIXED00:
  enter 0 ; (push bp; mov bp, sp)
;; return x / 100; 
  lea d, [bp + 5] ; $x
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $64
  div a, b
  mov b, a
  pop a
; END FACTORS
  leave
  ret

get_rand:
  enter 0 ; (push bp; mov bp, sp)
; $r 
  sub sp, 2
;; r = rand(); 
  lea d, [bp + -1] ; $r
  push d
  call rand
  pop d
  mov [d], b
;; r = (r >> 8) | (r << 8); 
  lea d, [bp + -1] ; $r
  push d
  lea d, [bp + -1] ; $r
  mov b, [d]
; START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shr a, cl
  mov b, a
  pop a
; END SHIFT
  push a
  mov a, b
  lea d, [bp + -1] ; $r
  mov b, [d]
; START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
  or b, a ; |
  pop a
  pop d
  mov [d], b
;; return ((r % spread) + 1); 
  lea d, [bp + -1] ; $r
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $spread
  mov b, [d]
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  leave
  ret

rand8:
  enter 0 ; (push bp; mov bp, sp)
;; return (get_rand(8)); 
  mov b, $8
  swp b
  push b
  call get_rand
  add sp, 2
  leave
  ret

input:
  enter 0 ; (push bp; mov bp, sp)
; $c 
  sub sp, 2
;; while((c = getchar()) != '\n') { 
_while45_cond:
  lea d, [bp + -1] ; $c
  push d
  call getchar
  pop d
  mov [d], b
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while45_exit
_while45_block:
;; if (c == -1) 
_if46_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $ffff
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if46_exit
_if46_true:
;; exit(); 
  call exit
  jmp _if46_exit
_if46_exit:
;; if (l > 1) { 
_if47_cond:
  lea d, [bp + 7] ; $l
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if47_exit
_if47_true:
;; *b++ = c; 
  lea d, [bp + 5] ; $b
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $b
  mov [d], b
  pop b
  push b
  lea d, [bp + -1] ; $c
  mov b, [d]
  pop d
  mov [d], bl
;; l--; 
  lea d, [bp + 7] ; $l
  mov bl, [d]
  mov bh, 0
  push b
  dec b
  lea d, [bp + 7] ; $l
  mov [d], b
  pop b
  jmp _if47_exit
_if47_exit:
  jmp _while45_cond
_while45_exit:
;; *b = 0; 
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
; $b 
  sub sp, 2
;; input(b,2); 
  mov b, $2
  push bl
  lea d, [bp + -1] ; $b
  mov b, d
  swp b
  push b
  call input
  add sp, 3
;; if (tolower(*b) == 'y') 
_if48_cond:
  lea d, [bp + -1] ; $b
  mov b, d
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call tolower
  add sp, 1
; START RELATIONAL
  push a
  mov a, b
  mov b, $79
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if48_exit
_if48_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if48_exit
_if48_exit:
;; return 0; 
  mov b, $0
  leave
  ret

input_f00:
  enter 0 ; (push bp; mov bp, sp)
; $v 
; $buf 
; $x 
  sub sp, 12
;; input(buf, 8); 
  mov b, $8
  push bl
  lea d, [bp + -9] ; $buf
  mov b, d
  swp b
  push b
  call input
  add sp, 3
;; x = buf; 
  lea d, [bp + -11] ; $x
  push d
  lea d, [bp + -9] ; $buf
  mov b, d
  pop d
  mov [d], b
;; if (!is_digit(*x)) 
_if49_cond:
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
  je _if49_exit
_if49_true:
;; return -1; 
  mov b, $ffff
  leave
  ret
  jmp _if49_exit
_if49_exit:
;; v = 100 * (*x++ - '0'); 
  lea d, [bp + -1] ; $v
  push d
  mov b, $64
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -11] ; $x
  mov b, [d]
  push b
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  pop b
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
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; if (*x == 0) 
_if50_cond:
  lea d, [bp + -11] ; $x
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
  je _if50_exit
_if50_true:
;; return v; 
  lea d, [bp + -1] ; $v
  mov b, [d]
  leave
  ret
  jmp _if50_exit
_if50_exit:
;; if (*x++ != '.') 
_if51_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  push b
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if51_exit
_if51_true:
;; return -1; 
  mov b, $ffff
  leave
  ret
  jmp _if51_exit
_if51_exit:
;; if (!is_digit(*x)) 
_if52_cond:
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
  je _if52_exit
_if52_true:
;; return -1; 
  mov b, $ffff
  leave
  ret
  jmp _if52_exit
_if52_exit:
;; v = v + 10 * (*x++ - '0'); 
  lea d, [bp + -1] ; $v
  push d
  lea d, [bp + -1] ; $v
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $a
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -11] ; $x
  mov b, [d]
  push b
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  pop b
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
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if (!*x) 
_if53_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if53_exit
_if53_true:
;; return v; 
  lea d, [bp + -1] ; $v
  mov b, [d]
  leave
  ret
  jmp _if53_exit
_if53_exit:
;; if (!is_digit(*x)) 
_if54_cond:
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
  je _if54_exit
_if54_true:
;; return -1; 
  mov b, $ffff
  leave
  ret
  jmp _if54_exit
_if54_exit:
;; v = v + *x++ - '0'; 
  lea d, [bp + -1] ; $v
  push d
  lea d, [bp + -1] ; $v
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $x
  mov b, [d]
  push b
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  add b, a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return v; 
  lea d, [bp + -1] ; $v
  mov b, [d]
  leave
  ret

input_int:
  enter 0 ; (push bp; mov bp, sp)
; $x 
  sub sp, 8
;; input(x, 8); 
  mov b, $8
  push bl
  lea d, [bp + -7] ; $x
  mov b, d
  swp b
  push b
  call input
  add sp, 3
;; if (!is_digit(*x)) 
_if55_cond:
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
  je _if55_exit
_if55_true:
;; return -1; 
  mov b, $ffff
  leave
  ret
  jmp _if55_exit
_if55_exit:
;; return atoi(x); 
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
; $p 
  sub sp, 2
;; *p = buf; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  push b
  mov d, st_print100_buf_dt ; static buf
  mov b, d
  pop d
  mov [d], bl
;; if (v < 0) { 
_if56_cond:
  lea d, [bp + 5] ; $v
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
  je _if56_exit
_if56_true:
;; v = -v; 
  lea d, [bp + 5] ; $v
  push d
  lea d, [bp + 5] ; $v
  mov b, [d]
  neg b
  pop d
  mov [d], b
;; *p++ = '-'; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  pop b
  push b
  mov b, $2d
  pop d
  mov [d], bl
  jmp _if56_exit
_if56_exit:
;; return buf; 
  mov d, st_print100_buf_dt ; static buf
  mov b, d
  leave
  ret

inoperable:
  enter 0 ; (push bp; mov bp, sp)
;; if (damage[u] < 0) { 
_if57_cond:
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if57_exit
_if57_true:
;; printf("%s %s inoperable.\n", 
_ternary59_cond:
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _ternary59_false
_ternary59_true:
  mov b, __s32 ; "are"
  jmp _ternary59_exit
_ternary59_false:
  mov b, __s33 ; "is"
_ternary59_exit:
  swp b
  push b
  mov b, __s34 ; "%s %s inoperable.\n"
  swp b
  push b
  call printf
  add sp, 4
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if57_exit
_if57_exit:
;; return 0; 
  mov b, $0
  leave
  ret

intro:
  enter 0 ; (push bp; mov bp, sp)
;; stardate = TO_FIXED((get_rand(20) + 20) * 100); 
  mov d, _stardate ; $stardate
  push d
  mov b, $14
  swp b
  push b
  call get_rand
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $14
  add b, a
  pop a
; END TERMS
; START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
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
  leave
  ret

initialize:
  enter 0 ; (push bp; mov bp, sp)
;; getchar(); 
  call getchar
  leave
  ret

place_ship:
  enter 0 ; (push bp; mov bp, sp)
;; quad[FROM_FIXED00(ship_y) - 1][FROM_FIXED00(ship_x) - 1] =  		4     ; 
  mov d, _quad_data ; $quad
  push a
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
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
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  swp b
  push b
  call FROM_FIXED00
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
  leave
  ret

course_control:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

complete_maneuver:
  enter 0 ; (push bp; mov bp, sp)
; $time_used 
  sub sp, 2
;; place_ship(); 
  call place_ship
;; maneuver_energy(n); 
  lea d, [bp + 7] ; $n
  mov b, [d]
  swp b
  push b
  call maneuver_energy
  add sp, 2
;; time_used = TO_FIXED(1); 
  lea d, [bp + -1] ; $time_used
  push d
  mov b, $1
  swp b
  push b
  call TO_FIXED
  add sp, 2
  pop d
  mov [d], b
;; if (warp < 100) 
_if60_cond:
  lea d, [bp + 5] ; $warp
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  slu ; < (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if60_exit
_if60_true:
;; time_used = TO_FIXED(FROM_FIXED00(warp)); 
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
  jmp _if60_exit
_if60_exit:
;; stardate = stardate + time_used; 
  mov d, _stardate ; $stardate
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $time_used
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if (FROM_FIXED(stardate) > time_start + time_up); 
_if61_cond:
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  add b, a
  pop a
; END TERMS
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if61_exit
_if61_true:
;; ; 
  jmp _if61_exit
_if61_exit:
;; short_range_scan(); 
  call short_range_scan
  leave
  ret

maneuver_energy:
  enter 0 ; (push bp; mov bp, sp)
;; energy = energy - n + 10; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
; START TERMS
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
; END TERMS
  pop d
  mov [d], b
;; if (energy >= 0) 
_if62_cond:
  mov d, _energy ; $energy
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if62_exit
_if62_true:
;; return; 
  leave
  ret
  jmp _if62_exit
_if62_exit:
;; puts("Shield Control supplies energy to complete maneuver.\n"); 
  mov b, __s35 ; "Shield Control supplies energy to complete maneuver.\n"
  swp b
  push b
  call puts
  add sp, 2
;; shield = shield + energy; 
  mov d, _shield ; $shield
  push d
  mov d, _shield ; $shield
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; energy = 0; 
  mov d, _energy ; $energy
  push d
  mov b, $0
  pop d
  mov [d], b
;; if (shield <= 0) 
_if63_cond:
  mov d, _shield ; $shield
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if63_exit
_if63_true:
;; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if63_exit
_if63_exit:
  leave
  ret

short_range_scan:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

put1bcd:
  enter 0 ; (push bp; mov bp, sp)
;; v = v & 0x0F; 
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
;; putchar('0' + v); 
  mov b, $30
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $v
  mov bl, [d]
  mov bh, 0
  add b, a
  pop a
; END TERMS
  push bl
  call putchar
  add sp, 1
  leave
  ret

putbcd:
  enter 0 ; (push bp; mov bp, sp)
;; put1bcd(x >> 8); 
  lea d, [bp + 5] ; $x
  mov b, [d]
; START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shr a, cl
  mov b, a
  pop a
; END SHIFT
  push bl
  call put1bcd
  add sp, 1
;; put1bcd(x >> 4); 
  lea d, [bp + 5] ; $x
  mov b, [d]
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shr a, cl
  mov b, a
  pop a
; END SHIFT
  push bl
  call put1bcd
  add sp, 1
;; put1bcd(x); 
  lea d, [bp + 5] ; $x
  mov b, [d]
  push bl
  call put1bcd
  add sp, 1
  leave
  ret

long_range_scan:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

no_klingon:
  enter 0 ; (push bp; mov bp, sp)
;; if (klingons <= 0) { 
_if64_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slu ; <= (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if64_exit
_if64_true:
;; puts("Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"); 
  mov b, __s36 ; "Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"
  swp b
  push b
  call puts
  add sp, 2
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if64_exit
_if64_exit:
;; return 0; 
  mov b, $0
  leave
  ret

wipe_klingon:
  enter 0 ; (push bp; mov bp, sp)
;; quad[k->y+-1][k->x+-1] =  		0      ; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $ffff
  add b, a
  pop a
; END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $ffff
  add b, a
  pop a
; END TERMS
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
  leave
  ret

photon_torpedoes:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

torpedo_hit:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

damage_control:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

shield_control:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; if (inoperable(7)) 
_if65_cond:
  mov b, $7
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if65_exit
_if65_true:
;; return; 
  leave
  ret
  jmp _if65_exit
_if65_exit:
;; printf("Energy available = %d\n\n Input number of units to shields: ", energy + shield); 
  mov d, _energy ; $energy
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  add b, a
  pop a
; END TERMS
  swp b
  push b
  mov b, __s37 ; "Energy available = %d\n\n Input number of units to shields: "
  swp b
  push b
  call printf
  add sp, 4
;; i = input_int(); 
  lea d, [bp + -1] ; $i
  push d
  call input_int
  pop d
  mov [d], b
;; if (i < 0 || shield == i) { 
_if66_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if66_exit
_if66_true:
;; unchanged: 
shield_control_unchanged:
;; puts("<Shields Unchanged>\n"); 
  mov b, __s38 ; "<Shields Unchanged>\n"
  swp b
  push b
  call puts
  add sp, 2
;; return; 
  leave
  ret
  jmp _if66_exit
_if66_exit:
;; if (i >= energy + shield) { 
_if67_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  add b, a
  pop a
; END TERMS
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if67_exit
_if67_true:
;; puts("Shield Control Reports:\n  'This is not the Federation Treasury.'"); 
  mov b, __s39 ; "Shield Control Reports:\n  'This is not the Federation Treasury.'"
  swp b
  push b
  call puts
  add sp, 2
;; goto unchanged; 
  jmp shield_control_unchanged
  jmp _if67_exit
_if67_exit:
;; energy = energy + shield - i; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
; START TERMS
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
; END TERMS
  pop d
  mov [d], b
;; shield = i; 
  mov d, _shield ; $shield
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
;; printf("Deflector Control Room report:\n  'Shields now at %d units per your command.'\n\n", shield); 
  mov d, _shield ; $shield
  mov b, [d]
  swp b
  push b
  mov b, __s40 ; "Deflector Control Room report:\n  'Shields now at %d units per your command.'\n\n"
  swp b
  push b
  call printf
  add sp, 4
  leave
  ret

library_computer:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

galactic_record:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $j 
  sub sp, 4
;; printf("\n     Computer Record of Galaxy for Quadrant %d,%d\n\n", quad_y, quad_x); 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  swp b
  push b
  mov b, __s41 ; "\n     Computer Record of Galaxy for Quadrant %d,%d\n\n"
  swp b
  push b
  call printf
  add sp, 6
;; puts("     1     2     3     4     5     6     7     8"); 
  mov b, __s42 ; "     1     2     3     4     5     6     7     8"
  swp b
  push b
  call puts
  add sp, 2
;; for (i = 1; i <= 8; i++) { 
_for68_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for68_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for68_exit
_for68_block:
;; printf("%s%d", gr_1, i); 
  lea d, [bp + -1] ; $i
  mov b, [d]
  swp b
  push b
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  swp b
  push b
  mov b, __s43 ; "%s%d"
  swp b
  push b
  call printf
  add sp, 6
;; for (j = 1; j <= 8; j++) { 
_for69_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $1
  pop d
  mov [d], b
_for69_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for69_exit
_for69_block:
;; printf("   "); 
  mov b, __s24 ; "   "
  swp b
  push b
  call printf
  add sp, 2
;; if (map[i][j] &   0x1000		/* Set if this sector was mapped */          ) 
_if70_cond:
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
  je _if70_else
_if70_true:
;; putbcd(map[i][j]); 
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
  jmp _if70_exit
_if70_else:
;; printf("***"); 
  mov b, __s44 ; "***"
  swp b
  push b
  call printf
  add sp, 2
_if70_exit:
_for69_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for69_cond
_for69_exit:
;; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
_for68_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for68_cond
_for68_exit:
;; printf("%s\n", gr_1); 
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  swp b
  push b
  mov b, __s45 ; "%s\n"
  swp b
  push b
  call printf
  add sp, 4
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_starbases: .fill 1, 0
_base_y: .fill 1, 0
_base_x: .fill 1, 0
_starbases_left: .fill 1, 0
_c_data: 
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
.dw __s0, __s0, __s1, __s2, __s3, __s4, __s5, __s6, __s7, __s8, __s9, __s10, __s11, __s12, __s13, __s14, __s15, 
.fill 34, 0
_device_name_data: 
.dw __s16, __s16, __s17, __s18, __s19, __s20, __s21, __s22, __s23, 
.fill 18, 0
_dcr_1_data: .db "Damage Control report:", 0
_dcr_1: .dw _dcr_1_data
_plural_2_data: 
.db $0,$0,
_plural_data: 
.db $69,$73,$0,
.fill 1, 0
_warpmax_data: 
.db $8,
.fill 3, 0
_srs_1_data: .db "------------------------", 0
_srs_1: .dw _srs_1_data
_tilestr_data: 
.dw __s24, __s25, __s26, __s27, __s28, 
.fill 10, 0
_lrs_1_data: .db "-------------------\n", 0
_lrs_1: .dw _lrs_1_data
_gr_1_data: .db "   ----- ----- ----- ----- ----- ----- ----- -----\n", 0
_gr_1: .dw _gr_1_data
_str_s_data: .db "s", 0
_str_s: .dw _str_s_data
st_print100_buf_dt: .fill 16, 0
__s0: .db "Antares", 0
__s1: .db "Rigel", 0
__s2: .db "Procyon", 0
__s3: .db "Vega", 0
__s4: .db "Canopus", 0
__s5: .db "Altair", 0
__s6: .db "Sagittarius", 0
__s7: .db "Pollux", 0
__s8: .db "Sirius", 0
__s9: .db "Deneb", 0
__s10: .db "Capella", 0
__s11: .db "Betelgeuse", 0
__s12: .db "Aldebaran", 0
__s13: .db "Regulus", 0
__s14: .db "Arcturus", 0
__s15: .db "Spica", 0
__s16: .db "Warp engines", 0
__s17: .db "Short range sensors", 0
__s18: .db "Long range sensors", 0
__s19: .db "Phaser control", 0
__s20: .db "Photon tubes", 0
__s21: .db "Damage control", 0
__s22: .db "Shield control", 0
__s23: .db "Library computer", 0
__s24: .db "   ", 0
__s25: .db " * ", 0
__s26: .db ">!<", 0
__s27: .db "+K+", 0
__s28: .db "<*>", 0
__s29: .db "Unexpected format in printf.", 0
__s30: .db "Error: Unknown argument type.\n", 0
__s31: .db "\033[2J\033[H", 0
__s32: .db "are", 0
__s33: .db "is", 0
__s34: .db "%s %s inoperable.\n", 0
__s35: .db "Shield Control supplies energy to complete maneuver.\n", 0
__s36: .db "Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n", 0
__s37: .db "Energy available = %d\n\n Input number of units to shields: ", 0
__s38: .db "<Shields Unchanged>\n", 0
__s39: .db "Shield Control Reports:\n  'This is not the Federation Treasury.'", 0
__s40: .db "Deflector Control Room report:\n  'Shields now at %d units per your command.'\n\n", 0
__s41: .db "\n     Computer Record of Galaxy for Quadrant %d,%d\n\n", 0
__s42: .db "     1     2     3     4     5     6     7     8", 0
__s43: .db "%s%d", 0
__s44: .db "***", 0
__s45: .db "%s\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
