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
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, __s34 ; "%s %s inoperable.\n"
  swp b
  push b
  call printf
  add sp, 6
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
;; showfile("startrek.intro"); 
  mov b, __s35 ; "startrek.intro"
  swp b
  push b
  call showfile
  add sp, 2
;; if (yesno()) 
_if60_cond:
  call yesno
  cmp b, 0
  je _if60_exit
_if60_true:
;; showfile("startrek.doc"); 
  mov b, __s36 ; "startrek.doc"
  swp b
  push b
  call showfile
  add sp, 2
  jmp _if60_exit
_if60_exit:
;; showfile("startrek.logo"); 
  mov b, __s37 ; "startrek.logo"
  swp b
  push b
  call showfile
  add sp, 2
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
; $cmd 
  sub sp, 4
;; initialize(); 
  call initialize
;; new_quadrant(); 
  call new_quadrant
;; short_range_scan(); 
  call short_range_scan
;; while (1) { 
_while61_cond:
  mov b, $1
  cmp b, 0
  je _while61_exit
_while61_block:
;; if (shield + energy <= 10 && (energy < 10 || damage[7] < 0)) { 
_if62_cond:
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  sand a, b
  pop a
  cmp b, 0
  je _if62_exit
_if62_true:
;; showfile("startrek.fatal"); 
  mov b, __s38 ; "startrek.fatal"
  swp b
  push b
  call showfile
  add sp, 2
;; end_of_time(); 
  call end_of_time
  jmp _if62_exit
_if62_exit:
;; puts("Command? "); 
  mov b, __s39 ; "Command? "
  swp b
  push b
  call puts
  add sp, 2
;; input(cmd, 4); 
  mov b, $4
  push bl
  lea d, [bp + -3] ; $cmd
  mov b, d
  swp b
  push b
  call input
  add sp, 3
;; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
;; if (!strncmp(cmd, "nav", 3)) 
_if63_cond:
  mov b, $3
  swp b
  push b
  mov b, __s40 ; "nav"
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
  je _if63_else
_if63_true:
;; course_control(); 
  call course_control
  jmp _if63_exit
_if63_else:
;; if (!strncmp(cmd, "srs", 3)) 
_if64_cond:
  mov b, $3
  swp b
  push b
  mov b, __s41 ; "srs"
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
  je _if64_else
_if64_true:
;; short_range_scan(); 
  call short_range_scan
  jmp _if64_exit
_if64_else:
;; if (!strncmp(cmd, "lrs", 3)) 
_if65_cond:
  mov b, $3
  swp b
  push b
  mov b, __s42 ; "lrs"
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
  je _if65_else
_if65_true:
;; long_range_scan(); 
  call long_range_scan
  jmp _if65_exit
_if65_else:
;; if (!strncmp(cmd, "pha", 3)) 
_if66_cond:
  mov b, $3
  swp b
  push b
  mov b, __s43 ; "pha"
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
  je _if66_else
_if66_true:
;; phaser_control(); 
  call phaser_control
  jmp _if66_exit
_if66_else:
;; if (!strncmp(cmd, "tor", 3)) 
_if67_cond:
  mov b, $3
  swp b
  push b
  mov b, __s44 ; "tor"
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
  je _if67_else
_if67_true:
;; photon_torpedoes(); 
  call photon_torpedoes
  jmp _if67_exit
_if67_else:
;; if (!strncmp(cmd, "shi", 3)) 
_if68_cond:
  mov b, $3
  swp b
  push b
  mov b, __s45 ; "shi"
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
  je _if68_else
_if68_true:
;; shield_control(); 
  call shield_control
  jmp _if68_exit
_if68_else:
;; if (!strncmp(cmd, "dam", 3)) 
_if69_cond:
  mov b, $3
  swp b
  push b
  mov b, __s46 ; "dam"
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
  je _if69_else
_if69_true:
;; damage_control(); 
  call damage_control
  jmp _if69_exit
_if69_else:
;; if (!strncmp(cmd, "com", 3)) 
_if70_cond:
  mov b, $3
  swp b
  push b
  mov b, __s47 ; "com"
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
  je _if70_else
_if70_true:
;; library_computer(); 
  call library_computer
  jmp _if70_exit
_if70_else:
;; if (!strncmp(cmd, "xxx", 3)) 
_if71_cond:
  mov b, $3
  swp b
  push b
  mov b, __s48 ; "xxx"
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
  je _if71_else
_if71_true:
;; resign_commision(); 
  call resign_commision
  jmp _if71_exit
_if71_else:
;; puts("Enter one of the following:\n"); 
  mov b, __s49 ; "Enter one of the following:\n"
  swp b
  push b
  call puts
  add sp, 2
;; puts("  nav - To Set Course"); 
  mov b, __s50 ; "  nav - To Set Course"
  swp b
  push b
  call puts
  add sp, 2
;; puts("  srs - Short Range Sensors"); 
  mov b, __s51 ; "  srs - Short Range Sensors"
  swp b
  push b
  call puts
  add sp, 2
;; puts("  lrs - Long Range Sensors"); 
  mov b, __s52 ; "  lrs - Long Range Sensors"
  swp b
  push b
  call puts
  add sp, 2
;; puts("  pha - Phasers"); 
  mov b, __s53 ; "  pha - Phasers"
  swp b
  push b
  call puts
  add sp, 2
;; puts("  tor - Photon Torpedoes"); 
  mov b, __s54 ; "  tor - Photon Torpedoes"
  swp b
  push b
  call puts
  add sp, 2
;; puts("  shi - Shield Control"); 
  mov b, __s55 ; "  shi - Shield Control"
  swp b
  push b
  call puts
  add sp, 2
;; puts("  dam - Damage Control"); 
  mov b, __s56 ; "  dam - Damage Control"
  swp b
  push b
  call puts
  add sp, 2
;; puts("  com - Library Computer"); 
  mov b, __s57 ; "  com - Library Computer"
  swp b
  push b
  call puts
  add sp, 2
;; puts("  xxx - Resign Command\n"); 
  mov b, __s58 ; "  xxx - Resign Command\n"
  swp b
  push b
  call puts
  add sp, 2
_if71_exit:
_if70_exit:
_if69_exit:
_if68_exit:
_if67_exit:
_if66_exit:
_if65_exit:
_if64_exit:
_if63_exit:
  jmp _while61_cond
_while61_exit:
  leave
  ret

initialize:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $j 
; $yp 
; $xp 
; $r 
  sub sp, 7
;; time_start = FROM_FIXED(stardate); 
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
;; time_up = 25 + get_rand(10); 
  mov d, _time_up ; $time_up
  push d
  mov b, $19
; START TERMS
  push a
  mov a, b
  mov b, $a
  swp b
  push b
  call get_rand
  add sp, 2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; docked = 0; 
  mov d, _docked ; $docked
  push d
  mov b, $0
  pop d
  mov [d], bl
;; energy = energy0; 
  mov d, _energy ; $energy
  push d
  mov d, _energy0 ; $energy0
  mov b, [d]
  pop d
  mov [d], b
;; torps = torps0; 
  mov d, _torps ; $torps
  push d
  mov d, _torps0 ; $torps0
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov b, $0
  pop d
  mov [d], b
;; quad_y = rand8(); 
  mov d, _quad_y ; $quad_y
  push d
  call rand8
  pop d
  mov [d], b
;; quad_x = rand8(); 
  mov d, _quad_x ; $quad_x
  push d
  call rand8
  pop d
  mov [d], b
;; ship_y = TO_FIXED00(rand8()); 
  mov d, _ship_y ; $ship_y
  push d
  call rand8
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
;; ship_x = TO_FIXED00(rand8()); 
  mov d, _ship_x ; $ship_x
  push d
  call rand8
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
;; for (i = 1; i <= 8; i++) 
_for72_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for72_cond:
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
  je _for72_exit
_for72_block:
;; damage[i] = 0; 
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
_for72_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for72_cond
_for72_exit:
;; for (i = 1; i <= 8; i++) { 
_for73_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for73_cond:
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
  je _for73_exit
_for73_block:
;; for (j = 1; j <= 8; j++) { 
_for74_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $1
  pop d
  mov [d], b
_for74_cond:
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
  je _for74_exit
_for74_block:
;; r = get_rand(100); 
  lea d, [bp + -6] ; $r
  push d
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
  pop d
  mov [d], bl
;; klingons = 0; 
  mov d, _klingons ; $klingons
  push d
  mov b, $0
  pop d
  mov [d], bl
;; if (r > 98) 
_if75_cond:
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $62
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if75_else
_if75_true:
;; klingons = 3; 
  mov d, _klingons ; $klingons
  push d
  mov b, $3
  pop d
  mov [d], bl
  jmp _if75_exit
_if75_else:
;; if (r > 95) 
_if76_cond:
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if76_else
_if76_true:
;; klingons = 2; 
  mov d, _klingons ; $klingons
  push d
  mov b, $2
  pop d
  mov [d], bl
  jmp _if76_exit
_if76_else:
;; if (r > 80) 
_if77_cond:
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $50
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if77_exit
_if77_true:
;; klingons = 1; 
  mov d, _klingons ; $klingons
  push d
  mov b, $1
  pop d
  mov [d], bl
  jmp _if77_exit
_if77_exit:
_if76_exit:
_if75_exit:
;; klingons_left = klingons_left + klingons; 
  mov d, _klingons_left ; $klingons_left
  push d
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; starbases = 0; 
  mov d, _starbases ; $starbases
  push d
  mov b, $0
  pop d
  mov [d], bl
;; if (get_rand(100) > 96) 
_if78_cond:
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $60
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if78_exit
_if78_true:
;; starbases = 1; 
  mov d, _starbases ; $starbases
  push d
  mov b, $1
  pop d
  mov [d], bl
  jmp _if78_exit
_if78_exit:
;; starbases_left = starbases_left + starbases; 
  mov d, _starbases_left ; $starbases_left
  push d
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; map[i][j] = (klingons << 8) + (starbases << 4) + rand8(); 
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
; START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  mov a, b
  call rand8
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
_for74_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for74_cond
_for74_exit:
_for73_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for73_cond
_for73_exit:
;; if (klingons_left > time_up) 
_if79_cond:
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if79_exit
_if79_true:
;; time_up = klingons_left + 1; 
  mov d, _time_up ; $time_up
  push d
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if79_exit
_if79_exit:
;; if (starbases_left == 0) { 
_if80_cond:
  mov d, _starbases_left ; $starbases_left
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
  je _if80_exit
_if80_true:
;; yp = rand8(); 
  lea d, [bp + -4] ; $yp
  push d
  call rand8
  pop d
  mov [d], bl
;; xp = rand8(); 
  lea d, [bp + -5] ; $xp
  push d
  call rand8
  pop d
  mov [d], bl
;; if (map[yp][xp] < 0x200) { 
_if81_cond:
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $200
  cmp a, b
  slu ; < (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if81_exit
_if81_true:
;; map[yp][xp] = map[yp][xp] + (1 << 8); 
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
; START TERMS
  push a
  mov a, b
  mov b, $1
; START SHIFT
  push a
  mov a, b
  mov b, $8
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; klingons_left++; 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  push b
  inc b
  mov d, _klingons_left ; $klingons_left
  mov [d], b
  pop b
  jmp _if81_exit
_if81_exit:
;; map[yp][xp] = map[yp][xp] + (1 << 4); 
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
; START TERMS
  push a
  mov a, b
  mov b, $1
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; starbases_left++; 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  push b
  inc b
  mov d, _starbases_left ; $starbases_left
  mov [d], b
  pop b
  jmp _if80_exit
_if80_exit:
;; total_klingons = klingons_left; 
  mov d, _total_klingons ; $total_klingons
  push d
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (starbases_left != 1) { 
_if82_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if82_exit
_if82_true:
;; strcpy(plural_2, "s"); 
  mov b, __s59 ; "s"
  swp b
  push b
  mov d, _plural_2_data ; $plural_2
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
;; strcpy(plural, "are"); 
  mov b, __s32 ; "are"
  swp b
  push b
  mov d, _plural_data ; $plural
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
  jmp _if82_exit
_if82_exit:
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
; $i 
; $tmp 
; $k 
  sub sp, 6
;; k = &kdata; 
  lea d, [bp + -5] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
;; klingons = 0; 
  mov d, _klingons ; $klingons
  push d
  mov b, $0
  pop d
  mov [d], bl
;; starbases = 0; 
  mov d, _starbases ; $starbases
  push d
  mov b, $0
  pop d
  mov [d], bl
;; stars = 0; 
  mov d, _stars ; $stars
  push d
  mov b, $0
  pop d
  mov [d], bl
;; d4 = get_rand(50) - 1; 
  mov d, _d4 ; $d4
  push d
  mov b, $32
  swp b
  push b
  call get_rand
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
;; map[quad_y][quad_x] = map[quad_y][quad_x] |   0x1000		/* Set if this sector was mapped */          ; 
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
;; if (quad_y >= 1 && quad_y <= 8 && quad_x >= 1 && quad_x <= 8) { 
_if83_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  sand a, b
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if83_exit
_if83_true:
;; quadrant_name(0, quad_y, quad_x); 
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
;; if (TO_FIXED(time_start) != stardate) 
_if84_cond:
  mov d, _time_start ; $time_start
  mov b, [d]
  swp b
  push b
  call TO_FIXED
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if84_else
_if84_true:
;; printf("Now entering %s quadrant...\n\n", quadname); 
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  mov b, __s60 ; "Now entering %s quadrant...\n\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if84_exit
_if84_else:
;; puts("\nYour mission begins with your starship located"); 
  mov b, __s61 ; "\nYour mission begins with your starship located"
  swp b
  push b
  call puts
  add sp, 2
;; printf("in the galactic quadrant %s.\n\n", quadname); 
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  mov b, __s62 ; "in the galactic quadrant %s.\n\n"
  swp b
  push b
  call printf
  add sp, 4
_if84_exit:
  jmp _if83_exit
_if83_exit:
;; tmp = map[quad_y][quad_x]; 
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
;; klingons = (tmp >> 8) & 0x0F; 
  mov d, _klingons ; $klingons
  push d
  lea d, [bp + -3] ; $tmp
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
  mov b, $f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
;; starbases = (tmp >> 4) & 0x0F; 
  mov d, _starbases ; $starbases
  push d
  lea d, [bp + -3] ; $tmp
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
  push a
  mov a, b
  mov b, $f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
;; stars = tmp & 0x0F; 
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
;; if (klingons > 0) { 
_if85_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if85_exit
_if85_true:
;; printf("Combat Area  Condition Red\n"); 
  mov b, __s63 ; "Combat Area  Condition Red\n"
  swp b
  push b
  call printf
  add sp, 2
;; if (shield < 200) 
_if86_cond:
  mov d, _shield ; $shield
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $c8
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if86_exit
_if86_true:
;; printf("Shields Dangerously Low\n"); 
  mov b, __s64 ; "Shields Dangerously Low\n"
  swp b
  push b
  call printf
  add sp, 2
  jmp _if86_exit
_if86_exit:
  jmp _if85_exit
_if85_exit:
;; for (i = 1; i <= 3; i++) { 
_for87_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for87_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for87_exit
_for87_block:
;; k->y = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  push d
  mov b, $0
  pop d
  mov [d], bl
;; k->x = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  push d
  mov b, $0
  pop d
  mov [d], bl
;; k->energy = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
  push d
  mov b, $0
  pop d
  mov [d], b
;; k++; 
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
_for87_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for87_cond
_for87_exit:
;; memset(quad,  		0      , 64); 
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
;; place_ship(); 
  call place_ship
;; if (klingons > 0) { 
_if88_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if88_exit
_if88_true:
;; k = kdata; 
  lea d, [bp + -5] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
;; for (i = 0; i < klingons; i++) { 
_for89_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for89_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for89_exit
_for89_block:
;; find_set_empty_place( 	3        , k->y, k->x); 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  mov b, $3
  push bl
  call find_set_empty_place
  add sp, 5
;; k->energy = 100 + get_rand(200); 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
  push d
  mov b, $64
; START TERMS
  push a
  mov a, b
  mov b, $c8
  swp b
  push b
  call get_rand
  add sp, 2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; k++; 
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
_for89_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for89_cond
_for89_exit:
  jmp _if88_exit
_if88_exit:
;; if (starbases > 0) 
_if90_cond:
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if90_exit
_if90_true:
;; find_set_empty_place( 		2     , &base_y, &base_x); 
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
  jmp _if90_exit
_if90_exit:
;; for (i = 1; i <= stars; i++) 
_for91_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for91_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _stars ; $stars
  mov bl, [d]
  mov bh, 0
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for91_exit
_for91_block:
;; find_set_empty_place( 		1     ,   0   ,   0   ); 
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
_for91_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for91_cond
_for91_exit:
  leave
  ret

course_control:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $c1 
; $warp 
; $n 
; $c2 
; $c3 
; $c4 
; $z1 
; $z2 
; $x1 
; $x2 
; $x 
; $y 
; $outside 
  mov al, $0
  mov [bp + -26], al
; $quad_y_old 
; $quad_x_old 
  sub sp, 29
;; puts("Course (0-9): " ); 
  mov b, __s65 ; "Course (0-9): "
  swp b
  push b
  call puts
  add sp, 2
;; c1 = input_f00(); 
  lea d, [bp + -3] ; $c1
  push d
  call input_f00
  pop d
  mov [d], b
;; if (c1 == 900) 
_if92_cond:
  lea d, [bp + -3] ; $c1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if92_exit
_if92_true:
;; c1 = 100; 
  lea d, [bp + -3] ; $c1
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if92_exit
_if92_exit:
;; if (c1 < 0 || c1 > 900) { 
_if93_cond:
  lea d, [bp + -3] ; $c1
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
  lea d, [bp + -3] ; $c1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if93_exit
_if93_true:
;; printf("Lt. Sulu%s", inc_1); 
  mov d, _inc_1 ; $inc_1
  mov b, [d]
  swp b
  push b
  mov b, __s66 ; "Lt. Sulu%s"
  swp b
  push b
  call printf
  add sp, 4
;; return; 
  leave
  ret
  jmp _if93_exit
_if93_exit:
;; if (damage[1] < 0) 
_if94_cond:
  mov d, _damage_data ; $damage
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
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if94_exit
_if94_true:
;; strcpy(warpmax, "0.2"); 
  mov b, __s67 ; "0.2"
  swp b
  push b
  mov d, _warpmax_data ; $warpmax
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
  jmp _if94_exit
_if94_exit:
;; printf("Warp Factor (0-%s): ", warpmax); 
  mov d, _warpmax_data ; $warpmax
  mov b, d
  swp b
  push b
  mov b, __s68 ; "Warp Factor (0-%s): "
  swp b
  push b
  call printf
  add sp, 4
;; warp = input_f00(); 
  lea d, [bp + -5] ; $warp
  push d
  call input_f00
  pop d
  mov [d], b
;; if (damage[1] < 0 && warp > 20) { 
_if95_cond:
  mov d, _damage_data ; $damage
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
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $warp
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $14
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if95_exit
_if95_true:
;; printf("Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n"); 
  mov b, __s69 ; "Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n"
  swp b
  push b
  call printf
  add sp, 2
;; return; 
  leave
  ret
  jmp _if95_exit
_if95_exit:
;; if (warp <= 0) 
_if96_cond:
  lea d, [bp + -5] ; $warp
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
  je _if96_exit
_if96_true:
;; return; 
  leave
  ret
  jmp _if96_exit
_if96_exit:
;; if (warp > 800) { 
_if97_cond:
  lea d, [bp + -5] ; $warp
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $320
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if97_exit
_if97_true:
;; printf("Chief Engineer Scott reports:\n  The engines wont take warp %s!\n\n", print100(warp)); 
  lea d, [bp + -5] ; $warp
  mov b, [d]
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, __s70 ; "Chief Engineer Scott reports:\n  The engines wont take warp %s!\n\n"
  swp b
  push b
  call printf
  add sp, 4
;; return; 
  leave
  ret
  jmp _if97_exit
_if97_exit:
;; n = warp * 8; 
  lea d, [bp + -7] ; $n
  push d
  lea d, [bp + -5] ; $warp
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $8
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; n = cint100(n);	 
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
;; if (energy - n < 0) { 
_if98_cond:
  mov d, _energy ; $energy
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slu ; < (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if98_exit
_if98_true:
;; printf("Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n", print100(warp)); 
  lea d, [bp + -5] ; $warp
  mov b, [d]
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, __s71 ; "Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n"
  swp b
  push b
  call printf
  add sp, 4
;; if (shield >= n && damage[7] >= 0) { 
_if99_cond:
  mov d, _shield ; $shield
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if99_exit
_if99_true:
;; printf("Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n", shield); 
  mov d, _shield ; $shield
  mov b, [d]
  swp b
  push b
  mov b, __s72 ; "Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if99_exit
_if99_exit:
;; return; 
  leave
  ret
  jmp _if98_exit
_if98_exit:
;; klingons_move(); 
  call klingons_move
;; repair_damage(warp); 
  lea d, [bp + -5] ; $warp
  mov b, [d]
  swp b
  push b
  call repair_damage
  add sp, 2
;; z1 = FROM_FIXED00(ship_y); 
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
;; z2 = FROM_FIXED00(ship_x); 
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
;; quad[z1+-1][z2+-1] =  		0      ; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -15] ; $z1
  mov b, [d]
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
  lea d, [bp + -17] ; $z2
  mov b, [d]
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
;; c2 = FROM_FIXED00(c1);	/* Integer part */ 
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
;; c3 = c2 + 1;		/* Next integer part */ 
  lea d, [bp + -11] ; $c3
  push d
  lea d, [bp + -9] ; $c2
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
;; c4 = (c1 - TO_FIXED00(c2));	/* Fractional element in fixed point */ 
  lea d, [bp + -13] ; $c4
  push d
  lea d, [bp + -3] ; $c1
  mov b, [d]
; START TERMS
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
; END TERMS
  pop d
  mov [d], b
;; x1 = 100 * c[1][c2] + (c[1][c3] - c[1][c2]) * c4; 
  lea d, [bp + -19] ; $x1
  push d
  mov b, $64
; START FACTORS
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
; END FACTORS
; START TERMS
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
; START TERMS
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
; END TERMS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -13] ; $c4
  mov b, [d]
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
;; x2 = 100 * c[2][c2] + (c[2][c3] - c[2][c2]) * c4; 
  lea d, [bp + -21] ; $x2
  push d
  mov b, $64
; START FACTORS
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
; END FACTORS
; START TERMS
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
; START TERMS
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
; END TERMS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -13] ; $c4
  mov b, [d]
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
;; x = ship_y; 
  lea d, [bp + -23] ; $x
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  pop d
  mov [d], b
;; y = ship_x; 
  lea d, [bp + -25] ; $y
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  pop d
  mov [d], b
;; for (i = 1; i <= n; i++) { 
_for100_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for100_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for100_exit
_for100_block:
;; ship_y = ship_y + x1; 
  mov d, _ship_y ; $ship_y
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; ship_x = ship_x + x2; 
  mov d, _ship_x ; $ship_x
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; z1 = FROM_FIXED00(ship_y); 
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
;; z2 = FROM_FIXED00(ship_x);	/* ?? cint100 ?? */ 
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
;; if (z1 < 1 || z1 >= 9 || z2 < 1 || z2 >= 9) { 
_if101_cond:
  lea d, [bp + -15] ; $z1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -15] ; $z1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $9
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + -17] ; $z2
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + -17] ; $z2
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $9
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if101_exit
_if101_true:
;; outside = 0;		/* Outside galaxy flag */ 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $0
  pop d
  mov [d], bl
;; quad_y_old = quad_y; 
  lea d, [bp + -27] ; $quad_y_old
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  pop d
  mov [d], bl
;; quad_x_old = quad_x; 
  lea d, [bp + -28] ; $quad_x_old
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  pop d
  mov [d], bl
;; x = (800 * quad_y) + x + (n * x1); 
  lea d, [bp + -23] ; $x
  push d
  mov b, $320
; START FACTORS
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -23] ; $x
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
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
;; y = (800 * quad_x) + y + (n * x2); 
  lea d, [bp + -25] ; $y
  push d
  mov b, $320
; START FACTORS
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -25] ; $y
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
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
;; quad_y = x / 800;	/* Fixed point to int and divide by 8 */ 
  mov d, _quad_y ; $quad_y
  push d
  lea d, [bp + -23] ; $x
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $320
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; quad_x = y / 800;	/* Ditto */ 
  mov d, _quad_x ; $quad_x
  push d
  lea d, [bp + -25] ; $y
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $320
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; ship_y = x - (quad_y * 800); 
  mov d, _ship_y ; $ship_y
  push d
  lea d, [bp + -23] ; $x
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $320
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; ship_x = y - (quad_x * 800); 
  mov d, _ship_x ; $ship_x
  push d
  lea d, [bp + -25] ; $y
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $320
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if (ship_y < 100) { 
_if102_cond:
  mov d, _ship_y ; $ship_y
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if102_exit
_if102_true:
;; quad_y = quad_y - 1; 
  mov d, _quad_y ; $quad_y
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
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
;; ship_y = ship_y + 800; 
  mov d, _ship_y ; $ship_y
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $320
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if102_exit
_if102_exit:
;; if (ship_x < 100) { 
_if103_cond:
  mov d, _ship_x ; $ship_x
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if103_exit
_if103_true:
;; quad_x = quad_x - 1; 
  mov d, _quad_x ; $quad_x
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
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
;; ship_x = ship_x + 800; 
  mov d, _ship_x ; $ship_x
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $320
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if103_exit
_if103_exit:
;; if (quad_y < 1) { 
_if104_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if104_exit
_if104_true:
;; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $1
  pop d
  mov [d], bl
;; quad_y = 1; 
  mov d, _quad_y ; $quad_y
  push d
  mov b, $1
  pop d
  mov [d], b
;; ship_y = 100; 
  mov d, _ship_y ; $ship_y
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if104_exit
_if104_exit:
;; if (quad_y > 8) { 
_if105_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if105_exit
_if105_true:
;; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $1
  pop d
  mov [d], bl
;; quad_y = 8; 
  mov d, _quad_y ; $quad_y
  push d
  mov b, $8
  pop d
  mov [d], b
;; ship_y = 800; 
  mov d, _ship_y ; $ship_y
  push d
  mov b, $320
  pop d
  mov [d], b
  jmp _if105_exit
_if105_exit:
;; if (quad_x < 1) { 
_if106_cond:
  mov d, _quad_x ; $quad_x
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if106_exit
_if106_true:
;; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $1
  pop d
  mov [d], bl
;; quad_x = 1; 
  mov d, _quad_x ; $quad_x
  push d
  mov b, $1
  pop d
  mov [d], b
;; ship_x = 100; 
  mov d, _ship_x ; $ship_x
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if106_exit
_if106_exit:
;; if (quad_x > 8) { 
_if107_cond:
  mov d, _quad_x ; $quad_x
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if107_exit
_if107_true:
;; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov b, $1
  pop d
  mov [d], bl
;; quad_x = 8; 
  mov d, _quad_x ; $quad_x
  push d
  mov b, $8
  pop d
  mov [d], b
;; ship_x = 800; 
  mov d, _ship_x ; $ship_x
  push d
  mov b, $320
  pop d
  mov [d], b
  jmp _if107_exit
_if107_exit:
;; if (outside == 1) { 
_if108_cond:
  lea d, [bp + -26] ; $outside
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if108_exit
_if108_true:
;; printf("LT. Uhura reports:\n Message from Starfleet Command:\n\n Permission to attempt crossing of galactic perimeter\n is hereby *denied*. Shut down your engines.\n\n Chief Engineer Scott reports:\n Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n", FROM_FIXED00(ship_y), 
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
  mov b, __s73 ; "LT. Uhura reports:\n Message from Starfleet Command:\n\n Permission to attempt crossing of galactic perimeter\n is hereby *denied*. Shut down your engines.\n\n Chief Engineer Scott reports:\n Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n"
  swp b
  push b
  call printf
  add sp, 10
  jmp _if108_exit
_if108_exit:
;; maneuver_energy(n); 
  lea d, [bp + -7] ; $n
  mov b, [d]
  swp b
  push b
  call maneuver_energy
  add sp, 2
;; if (FROM_FIXED(stardate) > time_start + time_up) 
_if109_cond:
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
  je _if109_exit
_if109_true:
;; end_of_time(); 
  call end_of_time
  jmp _if109_exit
_if109_exit:
;; if (quad_y != quad_y_old || quad_x != quad_x_old) { 
_if110_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -27] ; $quad_y_old
  mov bl, [d]
  mov bh, 0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -28] ; $quad_x_old
  mov bl, [d]
  mov bh, 0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if110_exit
_if110_true:
;; stardate = stardate + TO_FIXED(1); 
  mov d, _stardate ; $stardate
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  swp b
  push b
  call TO_FIXED
  add sp, 2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; new_quadrant(); 
  call new_quadrant
  jmp _if110_exit
_if110_exit:
;; complete_maneuver(warp, n); 
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
;; return; 
  leave
  ret
  jmp _if101_exit
_if101_exit:
;; if (quad[z1+-1][z2+-1] !=  		0      ) {	/* Sector not empty */ 
_if111_cond:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -15] ; $z1
  mov b, [d]
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
  lea d, [bp + -17] ; $z2
  mov b, [d]
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
  je _if111_exit
_if111_true:
;; ship_y = ship_y - x1; 
  mov d, _ship_y ; $ship_y
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; ship_x = ship_x - x2; 
  mov d, _ship_x ; $ship_x
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; printf("Warp Engines shut down at sector %d, %d due to bad navigation.\n\n", z1, z2); 
  lea d, [bp + -17] ; $z2
  mov b, [d]
  swp b
  push b
  lea d, [bp + -15] ; $z1
  mov b, [d]
  swp b
  push b
  mov b, __s74 ; "Warp Engines shut down at sector %d, %d due to bad navigation.\n\n"
  swp b
  push b
  call printf
  add sp, 6
;; i = n + 1; 
  lea d, [bp + -1] ; $i
  push d
  lea d, [bp + -7] ; $n
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
  jmp _if111_exit
_if111_exit:
_for100_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for100_cond
_for100_exit:
;; complete_maneuver(warp, n); 
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
_if112_cond:
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
  je _if112_exit
_if112_true:
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
  jmp _if112_exit
_if112_exit:
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
;; if (FROM_FIXED(stardate) > time_start + time_up) 
_if113_cond:
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
  je _if113_exit
_if113_true:
;; end_of_time(); 
  call end_of_time
  jmp _if113_exit
_if113_exit:
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
_if114_cond:
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
  je _if114_exit
_if114_true:
;; return; 
  leave
  ret
  jmp _if114_exit
_if114_exit:
;; puts("Shield Control supplies energy to complete maneuver.\n"); 
  mov b, __s75 ; "Shield Control supplies energy to complete maneuver.\n"
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
_if115_cond:
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
  je _if115_exit
_if115_true:
;; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if115_exit
_if115_exit:
  leave
  ret

short_range_scan:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $j 
; $sC 
  mov a, _sC_data
  mov [bp + -5], a
  sub sp, 6
;; if (energy < energy0 / 10) 
_if116_cond:
  mov d, _energy ; $energy
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _energy0 ; $energy0
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if116_exit
_if116_true:
;; sC = "YELLOW"; 
  lea d, [bp + -5] ; $sC
  push d
  mov b, __s76 ; "YELLOW"
  pop d
  mov [d], b
  jmp _if116_exit
_if116_exit:
;; if (klingons > 0) 
_if117_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if117_exit
_if117_true:
;; sC = "*RED*"; 
  lea d, [bp + -5] ; $sC
  push d
  mov b, __s77 ; "*RED*"
  pop d
  mov [d], b
  jmp _if117_exit
_if117_exit:
;; docked = 0; 
  mov d, _docked ; $docked
  push d
  mov b, $0
  pop d
  mov [d], bl
;; for (i = (int) (FROM_FIXED00(ship_y) - 1); i <= (int) (FROM_FIXED00(ship_y) + 1); i++) 
_for118_init:
  lea d, [bp + -1] ; $i
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
  mov [d], b
_for118_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
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
  add b, a
  pop a
; END TERMS
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for118_exit
_for118_block:
;; for (j = (int) (FROM_FIXED00(ship_x) - 1); j <= (int) (FROM_FIXED00(ship_x) + 1); j++) 
_for119_init:
  lea d, [bp + -3] ; $j
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
  mov [d], b
_for119_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
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
  add b, a
  pop a
; END TERMS
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for119_exit
_for119_block:
;; if (i >= 1 && i <= 8 && j >= 1 && j <= 8) { 
_if120_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
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
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  sand a, b
  mov a, b
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
  sand a, b
  pop a
  cmp b, 0
  je _if120_exit
_if120_true:
;; if (quad[i+-1][j+-1] ==  		2     ) { 
_if121_cond:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
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
  lea d, [bp + -3] ; $j
  mov b, [d]
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
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if121_exit
_if121_true:
;; docked = 1; 
  mov d, _docked ; $docked
  push d
  mov b, $1
  pop d
  mov [d], bl
;; sC = "DOCKED"; 
  lea d, [bp + -5] ; $sC
  push d
  mov b, __s78 ; "DOCKED"
  pop d
  mov [d], b
;; energy = energy0; 
  mov d, _energy ; $energy
  push d
  mov d, _energy0 ; $energy0
  mov b, [d]
  pop d
  mov [d], b
;; torps = torps0; 
  mov d, _torps ; $torps
  push d
  mov d, _torps0 ; $torps0
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; puts("Shields dropped for docking purposes."); 
  mov b, __s79 ; "Shields dropped for docking purposes."
  swp b
  push b
  call puts
  add sp, 2
;; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if121_exit
_if121_exit:
  jmp _if120_exit
_if120_exit:
_for119_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for119_cond
_for119_exit:
_for118_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for118_cond
_for118_exit:
;; if (damage[2] < 0) { 
_if122_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $2
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
  je _if122_exit
_if122_true:
;; puts("\n*** Short Range Sensors are out ***"); 
  mov b, __s80 ; "\n*** Short Range Sensors are out ***"
  swp b
  push b
  call puts
  add sp, 2
;; return; 
  leave
  ret
  jmp _if122_exit
_if122_exit:
;; puts(srs_1); 
  mov d, _srs_1 ; $srs_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
;; for (i = 0; i < 8; i++) { 
_for123_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for123_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for123_exit
_for123_block:
;; for (j = 0; j < 8; j++) 
_for124_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for124_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for124_exit
_for124_block:
;; puts(tilestr[quad[i][j]]); 
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
_for124_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for124_cond
_for124_exit:
;; if (i == 0) 
_if125_cond:
  lea d, [bp + -1] ; $i
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
  je _if125_exit
_if125_true:
;; printf("    Stardate            %d\n", FROM_FIXED(stardate)); 
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
  swp b
  push b
  mov b, __s81 ; "    Stardate            %d\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if125_exit
_if125_exit:
;; if (i == 1) 
_if126_cond:
  lea d, [bp + -1] ; $i
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
  je _if126_exit
_if126_true:
;; printf("    Condition           %s\n", sC); 
  lea d, [bp + -5] ; $sC
  mov b, [d]
  swp b
  push b
  mov b, __s82 ; "    Condition           %s\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if126_exit
_if126_exit:
;; if (i == 2) 
_if127_cond:
  lea d, [bp + -1] ; $i
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
  je _if127_exit
_if127_true:
;; printf("    Quadrant            %d, %d\n", quad_y, quad_x); 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  swp b
  push b
  mov b, __s83 ; "    Quadrant            %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
  jmp _if127_exit
_if127_exit:
;; if (i == 3) 
_if128_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if128_exit
_if128_true:
;; printf("    Sector              %d, %d\n", FROM_FIXED00(ship_y), FROM_FIXED00(ship_x)); 
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
  mov b, __s84 ; "    Sector              %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
  jmp _if128_exit
_if128_exit:
;; if (i == 4) 
_if129_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if129_exit
_if129_true:
;; printf("    Photon Torpedoes    %d\n", torps); 
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, __s85 ; "    Photon Torpedoes    %d\n"
  swp b
  push b
  call printf
  add sp, 3
  jmp _if129_exit
_if129_exit:
;; if (i == 5) 
_if130_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if130_exit
_if130_true:
;; printf("    Total Energy        %d\n", energy + shield); 
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
  mov b, __s86 ; "    Total Energy        %d\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if130_exit
_if130_exit:
;; if (i == 6) 
_if131_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $6
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if131_exit
_if131_true:
;; printf("    Shields             %d\n", shield); 
  mov d, _shield ; $shield
  mov b, [d]
  swp b
  push b
  mov b, __s87 ; "    Shields             %d\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if131_exit
_if131_exit:
;; if (i == 7) 
_if132_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $7
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if132_exit
_if132_true:
;; printf("    Klingons Remaining  %d\n", klingons_left); 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, __s88 ; "    Klingons Remaining  %d\n"
  swp b
  push b
  call printf
  add sp, 3
  jmp _if132_exit
_if132_exit:
_for123_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for123_cond
_for123_exit:
;; puts(srs_1); 
  mov d, _srs_1 ; $srs_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
;; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
;; return; 
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
; $i 
; $j 
  sub sp, 4
;; if (inoperable(3)) 
_if133_cond:
  mov b, $3
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if133_exit
_if133_true:
;; return; 
  leave
  ret
  jmp _if133_exit
_if133_exit:
;; printf("Long Range Scan for Quadrant %d, %d\n\n", quad_y, quad_x); 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  swp b
  push b
  mov b, __s89 ; "Long Range Scan for Quadrant %d, %d\n\n"
  swp b
  push b
  call printf
  add sp, 6
;; for (i = quad_y - 1; i <= quad_y + 1; i++) { 
_for134_init:
  lea d, [bp + -1] ; $i
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
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
_for134_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for134_exit
_for134_block:
;; printf("%s:", lrs_1); 
  mov d, _lrs_1 ; $lrs_1
  mov b, [d]
  swp b
  push b
  mov b, __s90 ; "%s:"
  swp b
  push b
  call printf
  add sp, 4
;; for (j = quad_x - 1; j <= quad_x + 1; j++) { 
_for135_init:
  lea d, [bp + -3] ; $j
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
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
_for135_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for135_exit
_for135_block:
;; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
;; if (i > 0 && i <= 8 && j > 0 && j <= 8) { 
_if136_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  push a
  mov a, b
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
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sand a, b
  mov a, b
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
  sand a, b
  pop a
  cmp b, 0
  je _if136_else
_if136_true:
;; map[i][j] = map[i][j] |   0x1000		/* Set if this sector was mapped */          ; 
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
  jmp _if136_exit
_if136_else:
;; puts("***"); 
  mov b, __s91 ; "***"
  swp b
  push b
  call puts
  add sp, 2
_if136_exit:
;; puts(" :"); 
  mov b, __s92 ; " :"
  swp b
  push b
  call puts
  add sp, 2
_for135_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for135_cond
_for135_exit:
;; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
_for134_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for134_cond
_for134_exit:
;; printf("%s\n", lrs_1); 
  mov d, _lrs_1 ; $lrs_1
  mov b, [d]
  swp b
  push b
  mov b, __s93 ; "%s\n"
  swp b
  push b
  call printf
  add sp, 4
  leave
  ret

no_klingon:
  enter 0 ; (push bp; mov bp, sp)
;; if (klingons <= 0) { 
_if137_cond:
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
  je _if137_exit
_if137_true:
;; puts("Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"); 
  mov b, __s94 ; "Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"
  swp b
  push b
  call puts
  add sp, 2
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if137_exit
_if137_exit:
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
; $i 
; $phaser_energy 
; $h1 
; $h 
; $k 
  sub sp, 14
;; k = &kdata; 
  lea d, [bp + -13] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
;; if (inoperable(4)) 
_if138_cond:
  mov b, $4
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if138_exit
_if138_true:
;; return; 
  leave
  ret
  jmp _if138_exit
_if138_exit:
;; if (no_klingon()) 
_if139_cond:
  call no_klingon
  cmp b, 0
  je _if139_exit
_if139_true:
;; return; 
  leave
  ret
  jmp _if139_exit
_if139_exit:
;; if (damage[8] < 0) 
_if140_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $8
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
  je _if140_exit
_if140_true:
;; puts("Computer failure hampers accuracy."); 
  mov b, __s95 ; "Computer failure hampers accuracy."
  swp b
  push b
  call puts
  add sp, 2
  jmp _if140_exit
_if140_exit:
;; printf("Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: ", energy); 
  mov d, _energy ; $energy
  mov b, [d]
  swp b
  push b
  mov b, __s96 ; "Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: "
  swp b
  push b
  call printf
  add sp, 4
;; phaser_energy = input_int(); 
  lea d, [bp + -5] ; $phaser_energy
  push d
  call input_int
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; if (phaser_energy <= 0) 
_if141_cond:
  lea d, [bp + -5] ; $phaser_energy
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
  sle
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _if141_exit
_if141_true:
;; return; 
  leave
  ret
  jmp _if141_exit
_if141_exit:
;; if (energy - phaser_energy < 0) { 
_if142_cond:
  mov d, _energy ; $energy
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub a, b
  mov b, a
  pop a
; END TERMS
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
  je _if142_exit
_if142_true:
;; puts("Not enough energy available.\n"); 
  mov b, __s97 ; "Not enough energy available.\n"
  swp b
  push b
  call puts
  add sp, 2
;; return; 
  leave
  ret
  jmp _if142_exit
_if142_exit:
;; energy = energy -  phaser_energy; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if (damage[8] < 0) 
_if143_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $8
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
  je _if143_else
_if143_true:
;; phaser_energy =phaser_energy * get_rand(100); 
  lea d, [bp + -5] ; $phaser_energy
  push d
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
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
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if143_exit
_if143_else:
;; phaser_energy = phaser_energy* 100; 
  lea d, [bp + -5] ; $phaser_energy
  push d
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
_if143_exit:
;; h1 = phaser_energy / klingons; 
  lea d, [bp + -9] ; $h1
  push d
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; for (i = 0; i <= 2; i++) { 
_for144_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for144_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for144_exit
_for144_block:
;; if (k->energy > 0) { 
_if145_cond:
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
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
  je _if145_exit
_if145_true:
;; h1 = h1 * (get_rand(100) + 200); 
  lea d, [bp + -9] ; $h1
  push d
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $c8
  add b, a
  pop a
; END TERMS
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; h1 =h1/ distance_to(k); 
  lea d, [bp + -9] ; $h1
  push d
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
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
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; if (h1 <= 15 * k->energy) {	/* was 0.15 */ 
_if146_cond:
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $f
; START FACTORS
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
; END FACTORS
  mov c, 0
  sleu
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _if146_else
_if146_true:
;; printf("Sensors show no damage to enemy at %d, %d\n\n", k->y, k->x); 
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
  mov b, __s98 ; "Sensors show no damage to enemy at %d, %d\n\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if146_exit
_if146_else:
;; h = FROM_FIXED00(h1); 
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
;; k->energy = k->energy - h; 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  push d
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $h
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; printf("%d unit hit on Klingon at sector %d, %d\n", 
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
  mov b, __s99 ; "%d unit hit on Klingon at sector %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
;; if (k->energy <= 0) { 
_if147_cond:
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
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
  je _if147_else
_if147_true:
;; puts("*** Klingon Destroyed ***\n"); 
  mov b, __s100 ; "*** Klingon Destroyed ***\n"
  swp b
  push b
  call puts
  add sp, 2
;; klingons--; 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  push b
  dec b
  mov d, _klingons ; $klingons
  mov [d], b
  pop b
;; klingons_left--; 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  push b
  dec b
  mov d, _klingons_left ; $klingons_left
  mov [d], b
  pop b
;; wipe_klingon(k); 
  lea d, [bp + -13] ; $k
  mov b, [d]
  swp b
  push b
  call wipe_klingon
  add sp, 2
;; k->energy = 0; 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  push d
  mov b, $0
  pop d
  mov [d], b
;; map[quad_y][quad_x] = map[quad_y][quad_x] - 0x100; 
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
; START TERMS
  push a
  mov a, b
  mov b, $100
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if (klingons_left <= 0) 
_if148_cond:
  mov d, _klingons_left ; $klingons_left
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
  je _if148_exit
_if148_true:
;; won_game(); 
  call won_game
  jmp _if148_exit
_if148_exit:
  jmp _if147_exit
_if147_else:
;; printf("   (Sensors show %d units remaining.)\n\n", k->energy); 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  swp b
  push b
  mov b, __s101 ; "   (Sensors show %d units remaining.)\n\n"
  swp b
  push b
  call printf
  add sp, 4
_if147_exit:
_if146_exit:
  jmp _if145_exit
_if145_exit:
;; k++; 
  lea d, [bp + -13] ; $k
  mov b, [d]
  push b
  inc b
  inc b
  lea d, [bp + -13] ; $k
  mov [d], b
  pop b
_for144_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for144_cond
_for144_exit:
;; klingons_shoot(); 
  call klingons_shoot
  leave
  ret

photon_torpedoes:
  enter 0 ; (push bp; mov bp, sp)
; $x3 
; $y3 
; $c1 
; $c2 
; $c3 
; $c4 
; $x 
; $y 
; $x1 
; $x2 
; $p 
  sub sp, 21
;; if (torps <= 0) { 
_if149_cond:
  mov d, _torps ; $torps
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
  je _if149_exit
_if149_true:
;; puts("All photon torpedoes expended"); 
  mov b, __s102 ; "All photon torpedoes expended"
  swp b
  push b
  call puts
  add sp, 2
;; return; 
  leave
  ret
  jmp _if149_exit
_if149_exit:
;; if (inoperable(5)) 
_if150_cond:
  mov b, $5
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if150_exit
_if150_true:
;; return; 
  leave
  ret
  jmp _if150_exit
_if150_exit:
;; puts("Course (0-9): "); 
  mov b, __s65 ; "Course (0-9): "
  swp b
  push b
  call puts
  add sp, 2
;; c1 = input_f00(); 
  lea d, [bp + -5] ; $c1
  push d
  call input_f00
  pop d
  mov [d], b
;; if (c1 == 900) 
_if151_cond:
  lea d, [bp + -5] ; $c1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if151_exit
_if151_true:
;; c1 = 100; 
  lea d, [bp + -5] ; $c1
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if151_exit
_if151_exit:
;; if (c1 < 100 || c1 >= 900) { 
_if152_cond:
  lea d, [bp + -5] ; $c1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $c1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if152_exit
_if152_true:
;; printf("Ensign Chekov%s", inc_1); 
  mov d, _inc_1 ; $inc_1
  mov b, [d]
  swp b
  push b
  mov b, __s103 ; "Ensign Chekov%s"
  swp b
  push b
  call printf
  add sp, 4
;; return; 
  leave
  ret
  jmp _if152_exit
_if152_exit:
;; energy = energy - 2; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
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
;; torps--; 
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  push b
  dec b
  mov d, _torps ; $torps
  mov [d], b
  pop b
;; c2 = FROM_FIXED00(c1);	/* Integer part */ 
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
;; c3 = c2 + 1;		/* Next integer part */ 
  lea d, [bp + -9] ; $c3
  push d
  lea d, [bp + -7] ; $c2
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
;; c4 = (c1 - TO_FIXED00(c2));	/* Fractional element in fixed point */ 
  lea d, [bp + -11] ; $c4
  push d
  lea d, [bp + -5] ; $c1
  mov b, [d]
; START TERMS
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
; END TERMS
  pop d
  mov [d], b
;; x1 = 100 * c[1][c2] + (c[1][c3] - c[1][c2]) * c4; 
  lea d, [bp + -17] ; $x1
  push d
  mov b, $64
; START FACTORS
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
; END FACTORS
; START TERMS
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
; START TERMS
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
; END TERMS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -11] ; $c4
  mov b, [d]
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
;; x2 = 100 * c[2][c2] + (c[2][c3] - c[2][c2]) * c4; 
  lea d, [bp + -19] ; $x2
  push d
  mov b, $64
; START FACTORS
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
; END FACTORS
; START TERMS
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
; START TERMS
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
; END TERMS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -11] ; $c4
  mov b, [d]
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
;; x = ship_y + x1; 
  lea d, [bp + -13] ; $x
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -17] ; $x1
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; y = ship_x + x2; 
  lea d, [bp + -15] ; $y
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x2
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; x3 = FROM_FIXED00(x); 
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
;; y3 = FROM_FIXED00(y); 
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
;; puts("Torpedo Track:"); 
  mov b, __s104 ; "Torpedo Track:"
  swp b
  push b
  call puts
  add sp, 2
;; while (x3 >= 1 && x3 <= 8 && y3 >= 1 && y3 <= 8) { 
_while153_cond:
  lea d, [bp + -1] ; $x3
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $x3
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $y3
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $y3
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _while153_exit
_while153_block:
;; printf("    %d, %d\n", x3, y3); 
  lea d, [bp + -3] ; $y3
  mov b, [d]
  swp b
  push b
  lea d, [bp + -1] ; $x3
  mov b, [d]
  swp b
  push b
  mov b, __s105 ; "    %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
;; p = quad[x3+-1][y3+-1]; 
  lea d, [bp + -20] ; $p
  push d
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -1] ; $x3
  mov b, [d]
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
  lea d, [bp + -3] ; $y3
  mov b, [d]
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
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (p !=  		0       && p !=  		4     ) { 
_if154_cond:
  lea d, [bp + -20] ; $p
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
  push a
  mov a, b
  lea d, [bp + -20] ; $p
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if154_exit
_if154_true:
;; torpedo_hit(x3, y3); 
  lea d, [bp + -3] ; $y3
  mov b, [d]
  push bl
  lea d, [bp + -1] ; $x3
  mov b, [d]
  push bl
  call torpedo_hit
  add sp, 2
;; klingons_shoot(); 
  call klingons_shoot
;; return; 
  leave
  ret
  jmp _if154_exit
_if154_exit:
;; x = x + x1; 
  lea d, [bp + -13] ; $x
  push d
  lea d, [bp + -13] ; $x
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -17] ; $x1
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; y = y + x2; 
  lea d, [bp + -15] ; $y
  push d
  lea d, [bp + -15] ; $y
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x2
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; x3 = FROM_FIXED00(x); 
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
;; y3 = FROM_FIXED00(y); 
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
  jmp _while153_cond
_while153_exit:
;; puts("Torpedo Missed\n"); 
  mov b, __s106 ; "Torpedo Missed\n"
  swp b
  push b
  call puts
  add sp, 2
;; klingons_shoot(); 
  call klingons_shoot
  leave
  ret

torpedo_hit:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $k 
  sub sp, 4
;; switch(quad[yp+-1][xp+-1]) { 
_switch155_expr:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 5] ; $yp
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
  lea d, [bp + 6] ; $xp
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
  mov bl, [d]
  mov bh, 0
_switch155_comparisons:
  cmp b, 1
  je _switch155_case0
  cmp b, 3
  je _switch155_case1
  cmp b, 2
  je _switch155_case2
  jmp _switch155_exit
_switch155_case0:
;; printf("Star at %d, %d absorbed torpedo energy.\n\n", yp, xp); 
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  push bl
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, __s107 ; "Star at %d, %d absorbed torpedo energy.\n\n"
  swp b
  push b
  call printf
  add sp, 4
;; return; 
  leave
  ret
_switch155_case1:
;; puts("*** Klingon Destroyed ***\n"); 
  mov b, __s100 ; "*** Klingon Destroyed ***\n"
  swp b
  push b
  call puts
  add sp, 2
;; klingons--; 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  push b
  dec b
  mov d, _klingons ; $klingons
  mov [d], b
  pop b
;; klingons_left--; 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  push b
  dec b
  mov d, _klingons_left ; $klingons_left
  mov [d], b
  pop b
;; if (klingons_left <= 0) 
_if156_cond:
  mov d, _klingons_left ; $klingons_left
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
  je _if156_exit
_if156_true:
;; won_game(); 
  call won_game
  jmp _if156_exit
_if156_exit:
;; k = kdata; 
  lea d, [bp + -3] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
;; for (i = 0; i <= 2; i++) { 
_for157_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for157_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for157_exit
_for157_block:
;; if (yp == k->y && xp == k->x) 
_if158_cond:
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
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
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
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
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if158_exit
_if158_true:
;; k->energy = 0; 
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 2
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if158_exit
_if158_exit:
;; k++; 
  lea d, [bp + -3] ; $k
  mov b, [d]
  push b
  inc b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  pop b
_for157_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for157_cond
_for157_exit:
;; map[quad_y][quad_x] =map[quad_y][quad_x] - 0x100; 
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
; START TERMS
  push a
  mov a, b
  mov b, $100
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch155_exit ; case break
_switch155_case2:
;; puts("*** Starbase Destroyed ***"); 
  mov b, __s108 ; "*** Starbase Destroyed ***"
  swp b
  push b
  call puts
  add sp, 2
;; starbases--; 
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  push b
  dec b
  mov d, _starbases ; $starbases
  mov [d], b
  pop b
;; starbases_left--; 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  push b
  dec b
  mov d, _starbases_left ; $starbases_left
  mov [d], b
  pop b
;; if (starbases_left <= 0 && klingons_left <= FROM_FIXED(stardate) - time_start - time_up) { 
_if159_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; START TERMS
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
; END TERMS
  cmp a, b
  slu ; <= (unsigned)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if159_exit
_if159_true:
;; puts("That does it, Captain!!"); 
  mov b, __s109 ; "That does it, Captain!!"
  swp b
  push b
  call puts
  add sp, 2
;; puts("You are hereby relieved of command\n"); 
  mov b, __s110 ; "You are hereby relieved of command\n"
  swp b
  push b
  call puts
  add sp, 2
;; puts("and sentenced to 99 stardates of hard"); 
  mov b, __s111 ; "and sentenced to 99 stardates of hard"
  swp b
  push b
  call puts
  add sp, 2
;; puts("labor on Cygnus 12!!\n"); 
  mov b, __s112 ; "labor on Cygnus 12!!\n"
  swp b
  push b
  call puts
  add sp, 2
;; resign_commision(); 
  call resign_commision
  jmp _if159_exit
_if159_exit:
;; puts("Starfleet Command reviewing your record to consider\n court martial!\n"); 
  mov b, __s113 ; "Starfleet Command reviewing your record to consider\n court martial!\n"
  swp b
  push b
  call puts
  add sp, 2
;; docked = 0;		/* Undock */ 
  mov d, _docked ; $docked
  push d
  mov b, $0
  pop d
  mov [d], bl
;; map[quad_y][quad_x] =map[quad_y][quad_x] - 0x10; 
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
; START TERMS
  push a
  mov a, b
  mov b, $10
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch155_exit ; case break
_switch155_exit:
;; quad[yp+-1][xp+-1] =  		0      ; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 5] ; $yp
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
  lea d, [bp + 6] ; $xp
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

damage_control:
  enter 0 ; (push bp; mov bp, sp)
; $repair_cost 
  mov a, $0
  mov [bp + -1], a
; $i 
  sub sp, 4
;; if (damage[6] < 0) 
_if160_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $6
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
  je _if160_exit
_if160_true:
;; puts("Damage Control report not available."); 
  mov b, __s114 ; "Damage Control report not available."
  swp b
  push b
  call puts
  add sp, 2
  jmp _if160_exit
_if160_exit:
;; if (docked) { 
_if161_cond:
  mov d, _docked ; $docked
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if161_exit
_if161_true:
;; repair_cost = 0; 
  lea d, [bp + -1] ; $repair_cost
  push d
  mov b, $0
  pop d
  mov [d], b
;; for (i = 1; i <= 8; i++) 
_for162_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for162_cond:
  lea d, [bp + -3] ; $i
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
  je _for162_exit
_for162_block:
;; if (damage[i] < 0) 
_if163_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
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
  je _if163_exit
_if163_true:
;; repair_cost = repair_cost + 10; 
  lea d, [bp + -1] ; $repair_cost
  push d
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $a
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if163_exit
_if163_exit:
_for162_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for162_cond
_for162_exit:
;; if (repair_cost) { 
_if164_cond:
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  cmp b, 0
  je _if164_exit
_if164_true:
;; repair_cost = repair_cost + d4; 
  lea d, [bp + -1] ; $repair_cost
  push d
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov d, _d4 ; $d4
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if (repair_cost >= 100) 
_if165_cond:
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if165_exit
_if165_true:
;; repair_cost = 90;	/* 0.9 */ 
  lea d, [bp + -1] ; $repair_cost
  push d
  mov b, $5a
  pop d
  mov [d], b
  jmp _if165_exit
_if165_exit:
;; printf("\nTechnicians standing by to effect repairs to your ship;\nEstimated time to repair: %s stardates.\n Will you authorize the repair order (y/N)? ", print100(repair_cost)); 
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, __s115 ; "\nTechnicians standing by to effect repairs to your ship;\nEstimated time to repair: %s stardates.\n Will you authorize the repair order (y/N)? "
  swp b
  push b
  call printf
  add sp, 4
;; if (yesno()) { 
_if166_cond:
  call yesno
  cmp b, 0
  je _if166_exit
_if166_true:
;; for (i = 1; i <= 8; i++) 
_for167_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for167_cond:
  lea d, [bp + -3] ; $i
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
  je _for167_exit
_for167_block:
;; if (damage[i] < 0) 
_if168_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
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
  je _if168_exit
_if168_true:
;; damage[i] = 0; 
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
  jmp _if168_exit
_if168_exit:
_for167_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for167_cond
_for167_exit:
;; stardate = stardate + (repair_cost + 5)/10 + 1; 
  mov d, _stardate ; $stardate
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $5
  add b, a
  pop a
; END TERMS
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  add b, a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if166_exit
_if166_exit:
;; return; 
  leave
  ret
  jmp _if164_exit
_if164_exit:
  jmp _if161_exit
_if161_exit:
;; if (damage[6] < 0) 
_if169_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov b, $6
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
  je _if169_exit
_if169_true:
;; return; 
  leave
  ret
  jmp _if169_exit
_if169_exit:
;; puts("Device            State of Repair"); 
  mov b, __s116 ; "Device            State of Repair"
  swp b
  push b
  call puts
  add sp, 2
;; for (i = 1; i <= 8; i++) 
_for170_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for170_cond:
  lea d, [bp + -3] ; $i
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
  je _for170_exit
_for170_block:
;; printf("%-25s%6s\n", get_device_name(i), print100(damage[i])); 
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
  mov b, __s117 ; "%-25s%6s\n"
  swp b
  push b
  call printf
  add sp, 6
_for170_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for170_cond
_for170_exit:
;; printf("\n"); 
  mov b, __s118 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
  leave
  ret

shield_control:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; if (inoperable(7)) 
_if171_cond:
  mov b, $7
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if171_exit
_if171_true:
;; return; 
  leave
  ret
  jmp _if171_exit
_if171_exit:
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
  mov b, __s119 ; "Energy available = %d\n\n Input number of units to shields: "
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
_if172_cond:
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
  je _if172_exit
_if172_true:
;; puts("<Shields Unchanged>\n"); 
  mov b, __s120 ; "<Shields Unchanged>\n"
  swp b
  push b
  call puts
  add sp, 2
;; return; 
  leave
  ret
  jmp _if172_exit
_if172_exit:
;; if (i >= energy + shield) { 
_if173_cond:
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
  je _if173_exit
_if173_true:
;; puts("Shield Control Reports:\n  This is not the Federation Treasury."); 
  mov b, __s121 ; "Shield Control Reports:\n  This is not the Federation Treasury."
  swp b
  push b
  call puts
  add sp, 2
  jmp _if173_exit
_if173_exit:
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
;; printf("Deflector Control Room report:\n  Shields now at %d units per your command.\n\n", shield); 
  mov d, _shield ; $shield
  mov b, [d]
  swp b
  push b
  mov b, __s122 ; "Deflector Control Room report:\n  Shields now at %d units per your command.\n\n"
  swp b
  push b
  call printf
  add sp, 4
  leave
  ret

library_computer:
  enter 0 ; (push bp; mov bp, sp)
;; if (inoperable(8)) 
_if174_cond:
  mov b, $8
  push bl
  call inoperable
  add sp, 1
  cmp b, 0
  je _if174_exit
_if174_true:
;; return; 
  leave
  ret
  jmp _if174_exit
_if174_exit:
;; puts("Computer active and awating command: "); 
  mov b, __s123 ; "Computer active and awating command: "
  swp b
  push b
  call puts
  add sp, 2
;; switch(input_int()) { 
_switch175_expr:
  call input_int
_switch175_comparisons:
  cmp b, -1
  je _switch175_case0
  cmp b, 0
  je _switch175_case1
  cmp b, 1
  je _switch175_case2
  cmp b, 2
  je _switch175_case3
  cmp b, 3
  je _switch175_case4
  cmp b, 4
  je _switch175_case5
  cmp b, 5
  je _switch175_case6
  jmp _switch175_default
  jmp _switch175_exit
_switch175_case0:
;; break; 
  jmp _switch175_exit ; case break
_switch175_case1:
;; galactic_record(); 
  call galactic_record
;; break; 
  jmp _switch175_exit ; case break
_switch175_case2:
;; status_report(); 
  call status_report
;; break; 
  jmp _switch175_exit ; case break
_switch175_case3:
;; torpedo_data(); 
  call torpedo_data
;; break; 
  jmp _switch175_exit ; case break
_switch175_case4:
;; nav_data(); 
  call nav_data
;; break; 
  jmp _switch175_exit ; case break
_switch175_case5:
;; dirdist_calc(); 
  call dirdist_calc
;; break; 
  jmp _switch175_exit ; case break
_switch175_case6:
;; galaxy_map(); 
  call galaxy_map
;; break; 
  jmp _switch175_exit ; case break
_switch175_default:
;; puts("Functions available from Library-Computer:\n\n"); 
  mov b, __s124 ; "Functions available from Library-Computer:\n\n"
  swp b
  push b
  call puts
  add sp, 2
;; puts("   0 = Cumulative Galactic Record\n"); 
  mov b, __s125 ; "   0 = Cumulative Galactic Record\n"
  swp b
  push b
  call puts
  add sp, 2
;; puts("   1 = Status Report\n"); 
  mov b, __s126 ; "   1 = Status Report\n"
  swp b
  push b
  call puts
  add sp, 2
;; puts("   2 = Photon Torpedo Data\n"); 
  mov b, __s127 ; "   2 = Photon Torpedo Data\n"
  swp b
  push b
  call puts
  add sp, 2
;; puts("   3 = Starbase Nav Data\n"); 
  mov b, __s128 ; "   3 = Starbase Nav Data\n"
  swp b
  push b
  call puts
  add sp, 2
;; puts("   4 = Direction/Distance Calculator\n"); 
  mov b, __s129 ; "   4 = Direction/Distance Calculator\n"
  swp b
  push b
  call puts
  add sp, 2
;; puts("   5 = Galaxy Region Name Map\n"); 
  mov b, __s130 ; "   5 = Galaxy Region Name Map\n"
  swp b
  push b
  call puts
  add sp, 2
_switch175_exit:
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
  mov b, __s131 ; "\n     Computer Record of Galaxy for Quadrant %d,%d\n\n"
  swp b
  push b
  call printf
  add sp, 6
;; puts("     1     2     3     4     5     6     7     8"); 
  mov b, __s132 ; "     1     2     3     4     5     6     7     8"
  swp b
  push b
  call puts
  add sp, 2
;; for (i = 1; i <= 8; i++) { 
_for176_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for176_cond:
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
  je _for176_exit
_for176_block:
;; printf("%s%d", gr_1, i); 
  lea d, [bp + -1] ; $i
  mov b, [d]
  swp b
  push b
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  swp b
  push b
  mov b, __s133 ; "%s%d"
  swp b
  push b
  call printf
  add sp, 6
;; for (j = 1; j <= 8; j++) { 
_for177_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $1
  pop d
  mov [d], b
_for177_cond:
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
  je _for177_exit
_for177_block:
;; printf("   "); 
  mov b, __s24 ; "   "
  swp b
  push b
  call printf
  add sp, 2
;; if (map[i][j] &   0x1000		/* Set if this sector was mapped */          ) 
_if178_cond:
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
  je _if178_else
_if178_true:
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
  jmp _if178_exit
_if178_else:
;; printf("***"); 
  mov b, __s91 ; "***"
  swp b
  push b
  call printf
  add sp, 2
_if178_exit:
_for177_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for177_cond
_for177_exit:
;; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
_for176_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for176_cond
_for176_exit:
;; printf("%s\n", gr_1); 
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  swp b
  push b
  mov b, __s93 ; "%s\n"
  swp b
  push b
  call printf
  add sp, 4
  leave
  ret

status_report:
  enter 0 ; (push bp; mov bp, sp)
; $plural 
; $left 
  sub sp, 4
;; plural = str_s + 1; 
  lea d, [bp + -1] ; $plural
  push d
  mov d, _str_s ; $str_s
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
;; left = TO_FIXED(time_start + time_up) - stardate; 
  lea d, [bp + -3] ; $left
  push d
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
  swp b
  push b
  call TO_FIXED
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; puts("   Status Report:\n"); 
  mov b, __s134 ; "   Status Report:\n"
  swp b
  push b
  call puts
  add sp, 2
;; if (klingons_left > 1) 
_if179_cond:
  mov d, _klingons_left ; $klingons_left
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
  je _if179_exit
_if179_true:
;; plural = str_s; 
  lea d, [bp + -1] ; $plural
  push d
  mov d, _str_s ; $str_s
  mov b, [d]
  pop d
  mov [d], b
  jmp _if179_exit
_if179_exit:
;; printf("Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n", 
  lea d, [bp + -3] ; $left
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
  mov b, __s135 ; "Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n"
  swp b
  push b
  call printf
  add sp, 9
;; if (starbases_left < 1) { 
_if180_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if180_else
_if180_true:
;; puts("Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n"); 
  mov b, __s136 ; "Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n"
  swp b
  push b
  call puts
  add sp, 2
  jmp _if180_exit
_if180_else:
;; plural = str_s; 
  lea d, [bp + -1] ; $plural
  push d
  mov d, _str_s ; $str_s
  mov b, [d]
  pop d
  mov [d], b
;; if (starbases_left < 2) 
_if181_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if181_exit
_if181_true:
;; plural++; 
  lea d, [bp + -1] ; $plural
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $plural
  mov [d], b
  pop b
  jmp _if181_exit
_if181_exit:
;; printf("The Federation is maintaining %d starbase%s in the galaxy\n\n", starbases_left, plural); 
  lea d, [bp + -1] ; $plural
  mov b, [d]
  swp b
  push b
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, __s137 ; "The Federation is maintaining %d starbase%s in the galaxy\n\n"
  swp b
  push b
  call printf
  add sp, 5
_if180_exit:
  leave
  ret

torpedo_data:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $plural 
; $k 
  sub sp, 6
;; plural = str_s + 1; 
  lea d, [bp + -3] ; $plural
  push d
  mov d, _str_s ; $str_s
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
;; if (no_klingon()) 
_if182_cond:
  call no_klingon
  cmp b, 0
  je _if182_exit
_if182_true:
;; return; 
  leave
  ret
  jmp _if182_exit
_if182_exit:
;; if (klingons > 1) 
_if183_cond:
  mov d, _klingons ; $klingons
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
  je _if183_exit
_if183_true:
;; plural--; 
  lea d, [bp + -3] ; $plural
  mov b, [d]
  push b
  dec b
  lea d, [bp + -3] ; $plural
  mov [d], b
  pop b
  jmp _if183_exit
_if183_exit:
;; printf("From Enterprise to Klingon battlecriuser%s:\n\n", plural); 
  lea d, [bp + -3] ; $plural
  mov b, [d]
  swp b
  push b
  mov b, __s138 ; "From Enterprise to Klingon battlecriuser%s:\n\n"
  swp b
  push b
  call printf
  add sp, 4
;; k = kdata; 
  lea d, [bp + -5] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
;; for (i = 0; i <= 2; i++) { 
_for184_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for184_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for184_exit
_for184_block:
;; if (k->energy > 0) { 
_if185_cond:
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
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
  je _if185_exit
_if185_true:
;; compute_vector(TO_FIXED00(k->y), 
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
  jmp _if185_exit
_if185_exit:
;; k++; 
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
_for184_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for184_cond
_for184_exit:
  leave
  ret

nav_data:
  enter 0 ; (push bp; mov bp, sp)
;; if (starbases <= 0) { 
_if186_cond:
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if186_exit
_if186_true:
;; puts("Mr. Spock reports,\n  Sensors show no starbases in this quadrant.\n"); 
  mov b, __s139 ; "Mr. Spock reports,\n  Sensors show no starbases in this quadrant.\n"
  swp b
  push b
  call puts
  add sp, 2
;; return; 
  leave
  ret
  jmp _if186_exit
_if186_exit:
;; compute_vector(TO_FIXED00(base_y), TO_FIXED00(base_x), ship_y, ship_x); 
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
; $c1 
; $a 
; $w1 
; $x 
  sub sp, 8
;; printf("Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: ", 
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
  mov b, __s140 ; "Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: "
  swp b
  push b
  call printf
  add sp, 10
;; c1 = TO_FIXED00(input_int()); 
  lea d, [bp + -1] ; $c1
  push d
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
;; if (c1 < 0 || c1 > 900 ) 
_if187_cond:
  lea d, [bp + -1] ; $c1
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
  lea d, [bp + -1] ; $c1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if187_exit
_if187_true:
;; return; 
  leave
  ret
  jmp _if187_exit
_if187_exit:
;; puts("Please enter initial Y coordinate: "); 
  mov b, __s141 ; "Please enter initial Y coordinate: "
  swp b
  push b
  call puts
  add sp, 2
;; a = TO_FIXED00(input_int()); 
  lea d, [bp + -3] ; $a
  push d
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
;; if (a < 0 || a > 900) 
_if188_cond:
  lea d, [bp + -3] ; $a
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
  lea d, [bp + -3] ; $a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if188_exit
_if188_true:
;; return; 
  leave
  ret
  jmp _if188_exit
_if188_exit:
;; puts("Please enter final X coordinate: "); 
  mov b, __s142 ; "Please enter final X coordinate: "
  swp b
  push b
  call puts
  add sp, 2
;; w1 = TO_FIXED00(input_int()); 
  lea d, [bp + -5] ; $w1
  push d
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
;; if (w1 < 0 || w1 > 900) 
_if189_cond:
  lea d, [bp + -5] ; $w1
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
  lea d, [bp + -5] ; $w1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if189_exit
_if189_true:
;; return; 
  leave
  ret
  jmp _if189_exit
_if189_exit:
;; puts("Please enter final Y coordinate: "); 
  mov b, __s143 ; "Please enter final Y coordinate: "
  swp b
  push b
  call puts
  add sp, 2
;; x = TO_FIXED00(input_int()); 
  lea d, [bp + -7] ; $x
  push d
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
;; if (x < 0 || x > 900) 
_if190_cond:
  lea d, [bp + -7] ; $x
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
  lea d, [bp + -7] ; $x
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $384
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if190_exit
_if190_true:
;; return; 
  leave
  ret
  jmp _if190_exit
_if190_exit:
;; compute_vector(w1, x, c1, a); 
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
; $i 
; $j 
; $j0 
  sub sp, 6
;; printf("\n                   The Galaxy\n\n"); 
  mov b, __s144 ; "\n                   The Galaxy\n\n"
  swp b
  push b
  call printf
  add sp, 2
;; printf("    1     2     3     4     5     6     7     8\n"); 
  mov b, __s145 ; "    1     2     3     4     5     6     7     8\n"
  swp b
  push b
  call printf
  add sp, 2
;; for (i = 1; i <= 8; i++) { 
_for191_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for191_cond:
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
  je _for191_exit
_for191_block:
;; printf("%s%d ", gm_1, i); 
  lea d, [bp + -1] ; $i
  mov b, [d]
  swp b
  push b
  mov d, _gm_1 ; $gm_1
  mov b, [d]
  swp b
  push b
  mov b, __s146 ; "%s%d "
  swp b
  push b
  call printf
  add sp, 6
;; quadrant_name(1, i, 1); 
  mov b, $1
  push bl
  lea d, [bp + -1] ; $i
  mov b, [d]
  push bl
  mov b, $1
  push bl
  call quadrant_name
  add sp, 3
;; j0 = (int) (11 - (strlen(quadname) / 2)); 
  lea d, [bp + -5] ; $j0
  push d
  mov b, $b
; START TERMS
  push a
  mov a, b
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strlen
  add sp, 2
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; END FACTORS
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; for (j = 0; j < j0; j++) 
_for192_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for192_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for192_exit
_for192_block:
;; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
_for192_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for192_cond
_for192_exit:
;; puts(quadname); 
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call puts
  add sp, 2
;; for (j = 0; j < j0; j++) 
_for193_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for193_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for193_exit
_for193_block:
;; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
_for193_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for193_cond
_for193_exit:
;; if (!(strlen(quadname) % 2)) 
_if194_cond:
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strlen
  add sp, 2
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if194_exit
_if194_true:
;; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
  jmp _if194_exit
_if194_exit:
;; quadrant_name(1, i, 5); 
  mov b, $5
  push bl
  lea d, [bp + -1] ; $i
  mov b, [d]
  push bl
  mov b, $1
  push bl
  call quadrant_name
  add sp, 3
;; j0 = (int) (12 - (strlen(quadname) / 2)); 
  lea d, [bp + -5] ; $j0
  push d
  mov b, $c
; START TERMS
  push a
  mov a, b
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strlen
  add sp, 2
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; END FACTORS
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; for (j = 0; j < j0; j++) 
_for195_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for195_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for195_exit
_for195_block:
;; putchar(' '); 
  mov b, $20
  push bl
  call putchar
  add sp, 1
_for195_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for195_cond
_for195_exit:
;; puts(quadname); 
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call puts
  add sp, 2
_for191_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for191_cond
_for191_exit:
;; puts(gm_1); 
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
; $xl 
; $al 
  sub sp, 8
;; puts("  DIRECTION = "); 
  mov b, __s147 ; "  DIRECTION = "
  swp b
  push b
  call puts
  add sp, 2
;; x = x - a; 
  lea d, [bp + 7] ; $x
  push d
  lea d, [bp + 7] ; $x
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 11] ; $a
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; a = c1 - w1; 
  lea d, [bp + 11] ; $a
  push d
  lea d, [bp + 9] ; $c1
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $w1
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; xl = abs(x); 
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
;; al = abs(a); 
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
;; if (x < 0) { 
_if196_cond:
  lea d, [bp + 7] ; $x
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
  je _if196_else
_if196_true:
;; if (a > 0) { 
_if197_cond:
  lea d, [bp + 11] ; $a
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
  je _if197_else
_if197_true:
;; c1 = 300; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $12c
  pop d
  mov [d], b
;; if (al >= xl) 
_if198_cond:
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
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
; END RELATIONAL
  cmp b, 0
  je _if198_else
_if198_true:
;; printf("%s", print100(c1 + ((xl * 100) / al))); 
  lea d, [bp + 9] ; $c1
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  div a, b
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
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, __s148 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if198_exit
_if198_else:
;; printf("%s", print100(c1 + ((((xl * 2) - al) * 100)  / xl))); 
  lea d, [bp + 9] ; $c1
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $2
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
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
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  div a, b
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
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, __s148 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
_if198_exit:
;; printf(dist_1, print100((x > a) ? x : a)); 
_ternary202_cond:
  lea d, [bp + 7] ; $x
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 11] ; $a
  mov b, [d]
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _ternary202_false
_ternary202_true:
  lea d, [bp + 7] ; $x
  mov b, [d]
  jmp _ternary202_exit
_ternary202_false:
  lea d, [bp + 11] ; $a
  mov b, [d]
_ternary202_exit:
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
;; return; 
  leave
  ret
  jmp _if197_exit
_if197_else:
;; if (x != 0){ 
_if203_cond:
  lea d, [bp + 7] ; $x
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
  je _if203_else
_if203_true:
;; c1 = 500; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $1f4
  pop d
  mov [d], b
;; return; 
  leave
  ret
  jmp _if203_exit
_if203_else:
;; c1 = 700; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $2bc
  pop d
  mov [d], b
_if203_exit:
_if197_exit:
  jmp _if196_exit
_if196_else:
;; if (a < 0) { 
_if204_cond:
  lea d, [bp + 11] ; $a
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
  je _if204_else
_if204_true:
;; c1 = 700; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $2bc
  pop d
  mov [d], b
  jmp _if204_exit
_if204_else:
;; if (x > 0) { 
_if205_cond:
  lea d, [bp + 7] ; $x
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
  je _if205_else
_if205_true:
;; c1 = 100; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $64
  pop d
  mov [d], b
  jmp _if205_exit
_if205_else:
;; if (a == 0) { 
_if206_cond:
  lea d, [bp + 11] ; $a
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
  je _if206_else
_if206_true:
;; c1 = 500; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $1f4
  pop d
  mov [d], b
  jmp _if206_exit
_if206_else:
;; c1 = 100; 
  lea d, [bp + 9] ; $c1
  push d
  mov b, $64
  pop d
  mov [d], b
;; if (al <= xl) 
_if207_cond:
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
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
; END RELATIONAL
  cmp b, 0
  je _if207_else
_if207_true:
;; printf("%s", print100(c1 + ((al * 100) / xl))); 
  lea d, [bp + 9] ; $c1
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  div a, b
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
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, __s148 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if207_exit
_if207_else:
;; printf("%s", print100(c1 + ((((al * 2) - xl) * 100) / al))); 
  lea d, [bp + 9] ; $c1
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $2
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
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
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  div a, b
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
  swp b
  push b
  call print100
  add sp, 2
  swp b
  push b
  mov b, __s148 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
_if207_exit:
;; printf(dist_1, print100((xl > al) ? xl : al)); 
_ternary211_cond:
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
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
; END RELATIONAL
  cmp b, 0
  je _ternary211_false
_ternary211_true:
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  jmp _ternary211_exit
_ternary211_false:
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
_ternary211_exit:
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
_if206_exit:
_if205_exit:
_if204_exit:
_if196_exit:
  leave
  ret

ship_destroyed:
  enter 0 ; (push bp; mov bp, sp)
;; puts("The Enterprise has been destroyed. The Federation will be conquered.\n"); 
  mov b, __s149 ; "The Enterprise has been destroyed. The Federation will be conquered.\n"
  swp b
  push b
  call puts
  add sp, 2
;; end_of_time(); 
  call end_of_time
  leave
  ret

end_of_time:
  enter 0 ; (push bp; mov bp, sp)
;; printf("It is stardate %d.\n\n",  FROM_FIXED(stardate)); 
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
  swp b
  push b
  mov b, __s150 ; "It is stardate %d.\n\n"
  swp b
  push b
  call printf
  add sp, 4
;; resign_commision(); 
  call resign_commision
  leave
  ret

resign_commision:
  enter 0 ; (push bp; mov bp, sp)
;; printf("There were %d Klingon Battlecruisers left at the end of your mission.\n\n", klingons_left); 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, __s151 ; "There were %d Klingon Battlecruisers left at the end of your mission.\n\n"
  swp b
  push b
  call printf
  add sp, 3
;; end_of_game(); 
  call end_of_game
  leave
  ret

won_game:
  enter 0 ; (push bp; mov bp, sp)
;; puts("Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n"); 
  mov b, __s152 ; "Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n"
  swp b
  push b
  call puts
  add sp, 2
;; if (FROM_FIXED(stardate) - time_start > 0) 
_if212_cond:
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if212_exit
_if212_true:
;; printf("Your efficiency rating is %s\n", 
  mov d, _total_klingons ; $total_klingons
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; START FACTORS
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  div a, b
  mov b, a
  pop a
; END FACTORS
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
  mov b, __s153 ; "Your efficiency rating is %s\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if212_exit
_if212_exit:
;; end_of_game(); 
  call end_of_game
  leave
  ret

end_of_game:
  enter 0 ; (push bp; mov bp, sp)
; $x 
  sub sp, 4
;; if (starbases_left > 0) { 
_if213_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if213_exit
_if213_true:
;; puts("The Federation is in need of a new starship commander"); 
  mov b, __s154 ; "The Federation is in need of a new starship commander"
  swp b
  push b
  call puts
  add sp, 2
;; puts(" for a similar mission.\n"); 
  mov b, __s155 ; " for a similar mission.\n"
  swp b
  push b
  call puts
  add sp, 2
;; puts("If there is a volunteer, let him step forward and"); 
  mov b, __s156 ; "If there is a volunteer, let him step forward and"
  swp b
  push b
  call puts
  add sp, 2
;; puts(" enter aye: "); 
  mov b, __s157 ; " enter aye: "
  swp b
  push b
  call puts
  add sp, 2
;; input(x,4); 
  mov b, $4
  push bl
  lea d, [bp + -3] ; $x
  mov b, d
  swp b
  push b
  call input
  add sp, 3
;; if (!strncmp(x, "aye", 3)) 
_if214_cond:
  mov b, $3
  swp b
  push b
  mov b, __s158 ; "aye"
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
  je _if214_exit
_if214_true:
;; new_game(); 
  call new_game
  jmp _if214_exit
_if214_exit:
  jmp _if213_exit
_if213_exit:
;; exit(); 
  call exit
  leave
  ret

klingons_move:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $k 
  sub sp, 4
;; k = &kdata; 
  lea d, [bp + -3] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
;; for (i = 0; i <= 2; i++) { 
_for215_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for215_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for215_exit
_for215_block:
;; if (k->energy > 0) { 
_if216_cond:
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 2
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
  je _if216_exit
_if216_true:
;; wipe_klingon(k); 
  lea d, [bp + -3] ; $k
  mov b, [d]
  swp b
  push b
  call wipe_klingon
  add sp, 2
;; find_set_empty_place( 	3        , k->y, k->x); 
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  mov b, $3
  push bl
  call find_set_empty_place
  add sp, 5
  jmp _if216_exit
_if216_exit:
;; k++; 
  lea d, [bp + -3] ; $k
  mov b, [d]
  push b
  inc b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  pop b
_for215_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for215_cond
_for215_exit:
;; klingons_shoot(); 
  call klingons_shoot
  leave
  ret

klingons_shoot:
  enter 0 ; (push bp; mov bp, sp)
; $r 
; $h 
; $i 
; $k 
; $ratio 
  sub sp, 12
;; k = &kdata; 
  lea d, [bp + -7] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
;; if (klingons <= 0) 
_if217_cond:
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
  je _if217_exit
_if217_true:
;; return; 
  leave
  ret
  jmp _if217_exit
_if217_exit:
;; if (docked) { 
_if218_cond:
  mov d, _docked ; $docked
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if218_exit
_if218_true:
;; puts("Starbase shields protect the Enterprise\n"); 
  mov b, __s159 ; "Starbase shields protect the Enterprise\n"
  swp b
  push b
  call puts
  add sp, 2
;; return; 
  leave
  ret
  jmp _if218_exit
_if218_exit:
;; for (i = 0; i <= 2; i++) { 
_for219_init:
  lea d, [bp + -5] ; $i
  push d
  mov b, $0
  pop d
  mov [d], bl
_for219_cond:
  lea d, [bp + -5] ; $i
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  slu ; <= (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for219_exit
_for219_block:
;; if (k->energy > 0) { 
_if220_cond:
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
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
  je _if220_exit
_if220_true:
;; h = k->energy * (200UL + get_rand(100)); 
  lea d, [bp + -4] ; $h
  push d
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, 200
  mov c, 0
; START TERMS
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
; END TERMS
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; h =h* 100;	/* Ready for division in fixed */ 
  lea d, [bp + -4] ; $h
  push d
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov b, $64
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; h =h/ distance_to(k); 
  lea d, [bp + -4] ; $h
  push d
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
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
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; shield = shield - FROM_FIXED00(h); 
  mov d, _shield ; $shield
  push d
  mov d, _shield ; $shield
  mov b, [d]
; START TERMS
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
; END TERMS
  pop d
  mov [d], b
;; k->energy = (k->energy * 100) / (300 + get_rand(100)); 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  push d
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
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
; START FACTORS
  push a
  mov a, b
  mov b, $12c
; START TERMS
  push a
  mov a, b
  mov b, $64
  swp b
  push b
  call get_rand
  add sp, 2
  add b, a
  pop a
; END TERMS
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; printf("%d unit hit on Enterprise from sector %d, %d\n", (unsigned)FROM_FIXED00(h), k->y, k->x); 
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
  mov b, __s160 ; "%d unit hit on Enterprise from sector %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
;; if (shield <= 0) { 
_if221_cond:
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
  je _if221_exit
_if221_true:
;; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
;; ship_destroyed(); 
  call ship_destroyed
  jmp _if221_exit
_if221_exit:
;; printf("    <Shields down to %d units>\n\n", shield); 
  mov d, _shield ; $shield
  mov b, [d]
  swp b
  push b
  mov b, __s161 ; "    <Shields down to %d units>\n\n"
  swp b
  push b
  call printf
  add sp, 4
;; if (h >= 20) { 
_if222_cond:
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $14
  mov c, 0
  sgeu
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _if222_exit
_if222_true:
;; ratio = ((int)h)/shield; 
  lea d, [bp + -11] ; $ratio
  push d
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START FACTORS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; if (get_rand(10) <= 6 && ratio > 2) { 
_if223_cond:
  mov b, $a
  swp b
  push b
  call get_rand
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $6
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -11] ; $ratio
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $2
  mov c, 0
  sgu
  pop g
  pop a
; END RELATIONAL
  mov g, 0
  sand32 ga, cb
  pop a
  cmp b, 0
  je _if223_exit
_if223_true:
;; r = rand8(); 
  lea d, [bp + 0] ; $r
  push d
  call rand8
  pop d
  mov [d], bl
;; damage[r] =damage[r] - ratio + get_rand(50); 
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
; START TERMS
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
; END TERMS
  pop d
  mov [d], b
;; printf("Damage Control reports\n%s damaged by hit\n\n", get_device_name(r)); 
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, __s162 ; "Damage Control reports\n%s damaged by hit\n\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if223_exit
_if223_exit:
  jmp _if222_exit
_if222_exit:
  jmp _if220_exit
_if220_exit:
;; k++; 
  lea d, [bp + -7] ; $k
  mov b, [d]
  push b
  inc b
  inc b
  lea d, [bp + -7] ; $k
  mov [d], b
  pop b
_for219_update:
  lea d, [bp + -5] ; $i
  mov bl, [d]
  mov bh, 0
  push b
  inc b
  lea d, [bp + -5] ; $i
  mov [d], b
  pop b
  jmp _for219_cond
_for219_exit:
  leave
  ret

repair_damage:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $d1 
; $repair_factor 
; $r 
  sub sp, 7
;; repair_factor = warp; 
  lea d, [bp + -5] ; $repair_factor
  push d
  lea d, [bp + 5] ; $warp
  mov b, [d]
  pop d
  mov [d], b
;; if (warp >= 100) 
_if224_cond:
  lea d, [bp + 5] ; $warp
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if224_exit
_if224_true:
;; repair_factor = TO_FIXED00(1); 
  lea d, [bp + -5] ; $repair_factor
  push d
  mov b, $1
  swp b
  push b
  call TO_FIXED00
  add sp, 2
  pop d
  mov [d], b
  jmp _if224_exit
_if224_exit:
;; for (i = 1; i <= 8; i++) { 
_for225_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for225_cond:
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
  je _for225_exit
_for225_block:
;; if (damage[i] < 0) { 
_if226_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
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
  je _if226_exit
_if226_true:
;; damage[i] = damage[i] + repair_factor; 
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
; START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $repair_factor
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; if (damage[i] > -10 && damage[i] < 0)	/* -0.1 */ 
_if227_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $fff6
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
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
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _if227_else
_if227_true:
;; damage[i] = -10; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $fff6
  pop d
  mov [d], b
  jmp _if227_exit
_if227_else:
;; if (damage[i] >= 0) { 
_if228_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
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
  sge ; >=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if228_exit
_if228_true:
;; if (d1 != 1) { 
_if229_cond:
  lea d, [bp + -3] ; $d1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if229_exit
_if229_true:
;; d1 = 1; 
  lea d, [bp + -3] ; $d1
  push d
  mov b, $1
  pop d
  mov [d], b
;; puts(dcr_1); 
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
  jmp _if229_exit
_if229_exit:
;; printf("    %s repair completed\n\n", 
  lea d, [bp + -1] ; $i
  mov b, [d]
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, __s163 ; "    %s repair completed\n\n"
  swp b
  push b
  call printf
  add sp, 4
;; damage[i] = 0; 
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
  jmp _if228_exit
_if228_exit:
_if227_exit:
  jmp _if226_exit
_if226_exit:
_for225_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for225_cond
_for225_exit:
;; if (get_rand(10) <= 2) { 
_if230_cond:
  mov b, $a
  swp b
  push b
  call get_rand
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if230_exit
_if230_true:
;; r = rand8(); 
  lea d, [bp + -6] ; $r
  push d
  call rand8
  pop d
  mov [d], bl
;; if (get_rand(10) < 6) { 
_if231_cond:
  mov b, $a
  swp b
  push b
  call get_rand
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $6
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if231_else
_if231_true:
;; damage[r] =damage[r]- (get_rand(500) + 100); 
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
; START TERMS
  push a
  mov a, b
  mov b, $1f4
  swp b
  push b
  call get_rand
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $64
  add b, a
  pop a
; END TERMS
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; puts(dcr_1); 
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
;; printf("    %s damaged\n\n", get_device_name(r)); 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, __s164 ; "    %s damaged\n\n"
  swp b
  push b
  call printf
  add sp, 4
  jmp _if231_exit
_if231_else:
;; damage[r] = damage[r] + get_rand(300) + 100; 
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
; START TERMS
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
; END TERMS
  pop d
  mov [d], b
;; puts(dcr_1); 
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  swp b
  push b
  call puts
  add sp, 2
;; printf("    %s state of repair improved\n\n", 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call get_device_name
  add sp, 2
  swp b
  push b
  mov b, __s165 ; "    %s state of repair improved\n\n"
  swp b
  push b
  call printf
  add sp, 4
_if231_exit:
  jmp _if230_exit
_if230_exit:
  leave
  ret

find_set_empty_place:
  enter 0 ; (push bp; mov bp, sp)
; $r1 
; $r2 
  sub sp, 2
;; do { 
_do232_block:
;; r1 = rand8(); 
  lea d, [bp + 0] ; $r1
  push d
  call rand8
  pop d
  mov [d], bl
;; r2 = rand8(); 
  lea d, [bp + -1] ; $r2
  push d
  call rand8
  pop d
  mov [d], bl
;; } while (quad[r1+-1][r2+-1] !=  		0       ); 
_do232_cond:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 0] ; $r1
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
  lea d, [bp + -1] ; $r2
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
  cmp b, 1
  je _do232_block
_do232_exit:
;; quad[r1+-1][r2+-1] = t; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 0] ; $r1
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
  lea d, [bp + -1] ; $r2
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
  lea d, [bp + 5] ; $t
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (z1) 
_if233_cond:
  lea d, [bp + 6] ; $z1
  mov b, [d]
  cmp b, 0
  je _if233_exit
_if233_true:
;; *z1 = r1; 
  lea d, [bp + 6] ; $z1
  mov b, [d]
  push b
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _if233_exit
_if233_exit:
;; if (z2) 
_if234_cond:
  lea d, [bp + 8] ; $z2
  mov b, [d]
  cmp b, 0
  je _if234_exit
_if234_true:
;; *z2 = r2; 
  lea d, [bp + 8] ; $z2
  mov b, [d]
  push b
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _if234_exit
_if234_exit:
  leave
  ret

get_device_name:
  enter 0 ; (push bp; mov bp, sp)
;; if (n < 0 || n > 8) 
_if235_cond:
  lea d, [bp + 5] ; $n
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
  lea d, [bp + 5] ; $n
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if235_exit
_if235_true:
;; n = 0; 
  lea d, [bp + 5] ; $n
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if235_exit
_if235_exit:
;; return device_name[n]; 
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
;; if (y < 1 || y > 8 || x < 1 || x > 8) 
_if236_cond:
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slu ; < (unsigned)
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  slu ; < (unsigned)
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $8
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if236_exit
_if236_true:
;; strcpy(quadname, "Unknown"); 
  mov b, __s170 ; "Unknown"
  swp b
  push b
  mov d, _quadname_data ; $quadname
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
  jmp _if236_exit
_if236_exit:
;; if (x <= 4) 
_if237_cond:
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slu ; <= (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if237_else
_if237_true:
;; strcpy(quadname, quad_name[y]); 
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
  jmp _if237_exit
_if237_else:
;; strcpy(quadname, quad_name[y + 8]); 
  mov d, _quad_name_data ; $quad_name
  push a
  push d
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $8
  add b, a
  pop a
; END TERMS
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
_if237_exit:
;; if (small != 1) { 
_if238_cond:
  lea d, [bp + 5] ; $small
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if238_exit
_if238_true:
;; if (x > 4) 
_if239_cond:
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if239_exit
_if239_true:
;; x = x - 4; 
  lea d, [bp + 7] ; $x
  push d
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $4
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
  jmp _if239_exit
_if239_exit:
;; strcat(quadname, sect_name[x]); 
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
  jmp _if238_exit
_if238_exit:
;; return; 
  leave
  ret

isqrt:
  enter 0 ; (push bp; mov bp, sp)
; $b 
; $q 
; $r 
; $t 
  sub sp, 8
;; b = 0x4000; 
  lea d, [bp + -1] ; $b
  push d
  mov b, $4000
  pop d
  mov [d], b
;; q = 0; 
  lea d, [bp + -3] ; $q
  push d
  mov b, $0
  pop d
  mov [d], b
;; r = i; 
  lea d, [bp + -5] ; $r
  push d
  lea d, [bp + 5] ; $i
  mov b, [d]
  pop d
  mov [d], b
;; while (b) { 
_while240_cond:
  lea d, [bp + -1] ; $b
  mov b, [d]
  cmp b, 0
  je _while240_exit
_while240_block:
;; t = q + b; 
  lea d, [bp + -7] ; $t
  push d
  lea d, [bp + -3] ; $q
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $b
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; q =q>> 1; 
  lea d, [bp + -3] ; $q
  push d
  lea d, [bp + -3] ; $q
  mov b, [d]
; START SHIFT
  push a
  mov a, b
  mov b, $1
  mov c, b
  shr a, cl
  mov b, a
  pop a
; END SHIFT
  pop d
  mov [d], b
;; if (r >= t) { 
_if241_cond:
  lea d, [bp + -5] ; $r
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $t
  mov b, [d]
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if241_exit
_if241_true:
;; r =r- t; 
  lea d, [bp + -5] ; $r
  push d
  lea d, [bp + -5] ; $r
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $t
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; q = q + b; 
  lea d, [bp + -3] ; $q
  push d
  lea d, [bp + -3] ; $q
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $b
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if241_exit
_if241_exit:
;; b =b>> 2; 
  lea d, [bp + -1] ; $b
  push d
  lea d, [bp + -1] ; $b
  mov b, [d]
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shr a, cl
  mov b, a
  pop a
; END SHIFT
  pop d
  mov [d], b
  jmp _while240_cond
_while240_exit:
;; return q; 
  lea d, [bp + -3] ; $q
  mov b, [d]
  leave
  ret

square00:
  enter 0 ; (push bp; mov bp, sp)
;; if (abs(t) > 181) { 
_if242_cond:
  lea d, [bp + 5] ; $t
  mov b, [d]
  swp b
  push b
  call abs
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $b5
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if242_else
_if242_true:
;; t =t/ 10; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
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
;; t =t* t; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $t
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  jmp _if242_exit
_if242_else:
;; t =t* t; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $t
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; t =t/ 100; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $64
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
_if242_exit:
;; return t; 
  lea d, [bp + 5] ; $t
  mov b, [d]
  leave
  ret

distance_to:
  enter 0 ; (push bp; mov bp, sp)
; $j 
  sub sp, 2
;; j = square00(TO_FIXED00(k->y) - ship_y); 
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
; START TERMS
  push a
  mov a, b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call square00
  add sp, 2
  pop d
  mov [d], b
;; j = j + square00(TO_FIXED00(k->x) - ship_x); 
  lea d, [bp + -1] ; $j
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
; START TERMS
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
; START TERMS
  push a
  mov a, b
  mov d, _ship_x ; $ship_x
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call square00
  add sp, 2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; j = isqrt(j); 
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
;; j =j* 10; 
  lea d, [bp + -1] ; $j
  push d
  lea d, [bp + -1] ; $j
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
  pop d
  mov [d], b
;; return j; 
  lea d, [bp + -1] ; $j
  mov b, [d]
  leave
  ret

cint100:
  enter 0 ; (push bp; mov bp, sp)
;; return (d + 50) / 100; 
  lea d, [bp + 5] ; $d
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $32
  add b, a
  pop a
; END TERMS
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

showfile:
  enter 0 ; (push bp; mov bp, sp)
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
_gm_1_data: .db "  ----- ----- ----- ----- ----- ----- ----- -----\n", 0
_gm_1: .dw _gm_1_data
_dist_1_data: .db "  DISTANCE = \n\n", 0
_dist_1: .dw _dist_1_data
st_print100_buf_dt: .fill 16, 0
_sC_data: .db "GREEN", 0
_sC: .dw _sC_data
st_quadrant_name_sect_name_dt: 
.dw __s166, __s166, __s167, __s168, __s169, .fill 10, 0
st_quadrant_name: .dw st_sect_name_sect_name_dt
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
__s35: .db "startrek.intro", 0
__s36: .db "startrek.doc", 0
__s37: .db "startrek.logo", 0
__s38: .db "startrek.fatal", 0
__s39: .db "Command? ", 0
__s40: .db "nav", 0
__s41: .db "srs", 0
__s42: .db "lrs", 0
__s43: .db "pha", 0
__s44: .db "tor", 0
__s45: .db "shi", 0
__s46: .db "dam", 0
__s47: .db "com", 0
__s48: .db "xxx", 0
__s49: .db "Enter one of the following:\n", 0
__s50: .db "  nav - To Set Course", 0
__s51: .db "  srs - Short Range Sensors", 0
__s52: .db "  lrs - Long Range Sensors", 0
__s53: .db "  pha - Phasers", 0
__s54: .db "  tor - Photon Torpedoes", 0
__s55: .db "  shi - Shield Control", 0
__s56: .db "  dam - Damage Control", 0
__s57: .db "  com - Library Computer", 0
__s58: .db "  xxx - Resign Command\n", 0
__s59: .db "s", 0
__s60: .db "Now entering %s quadrant...\n\n", 0
__s61: .db "\nYour mission begins with your starship located", 0
__s62: .db "in the galactic quadrant %s.\n\n", 0
__s63: .db "Combat Area  Condition Red\n", 0
__s64: .db "Shields Dangerously Low\n", 0
__s65: .db "Course (0-9): ", 0
__s66: .db "Lt. Sulu%s", 0
__s67: .db "0.2", 0
__s68: .db "Warp Factor (0-%s): ", 0
__s69: .db "Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n", 0
__s70: .db "Chief Engineer Scott reports:\n  The engi; --- END DATA BLOCK

.end
