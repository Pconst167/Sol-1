; --- FILENAME: programs/rsa
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $p 
; $q 
; $n 
; $phi 
; $e 
; $d 
; $input_str 
; $encrypted_chars 
; $encrypted_chars_len 
; $i 
; $decrypted_char 
; $c 
  sub sp, 319
;; p = 13; 
  lea d, [bp + -1] ; $p
  push d
  mov b, $d
  pop d
  mov [d], b
;; q = 11; 
  lea d, [bp + -3] ; $q
  push d
  mov b, $b
  pop d
  mov [d], b
;; n = p * q; 
  lea d, [bp + -5] ; $n
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $q
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; phi = (p - 1) * (q - 1); 
  lea d, [bp + -7] ; $phi
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $q
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
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
;; e = find_e(phi); 
  lea d, [bp + -9] ; $e
  push d
  lea d, [bp + -7] ; $phi
  mov b, [d]
  swp b
  push b
  call find_e
  add sp, 2
  pop d
  mov [d], b
;; d = find_d(e, phi); 
  lea d, [bp + -11] ; $d
  push d
  lea d, [bp + -7] ; $phi
  mov b, [d]
  swp b
  push b
  lea d, [bp + -9] ; $e
  mov b, [d]
  swp b
  push b
  call find_d
  add sp, 4
  pop d
  mov [d], b
;; print("Public Key: ("); 
  mov b, __s0 ; "Public Key: ("
  swp b
  push b
  call print
  add sp, 2
;; printu(n); 
  lea d, [bp + -5] ; $n
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; print(", "); 
  mov b, __s1 ; ", "
  swp b
  push b
  call print
  add sp, 2
;; printu(e); 
  lea d, [bp + -9] ; $e
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; print(")\n"); 
  mov b, __s2 ; ")\n"
  swp b
  push b
  call print
  add sp, 2
;; print("Private Key: ("); 
  mov b, __s3 ; "Private Key: ("
  swp b
  push b
  call print
  add sp, 2
;; printu(n); 
  lea d, [bp + -5] ; $n
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; print(", "); 
  mov b, __s1 ; ", "
  swp b
  push b
  call print
  add sp, 2
;; printu(d); 
  lea d, [bp + -11] ; $d
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; print(")\n"); 
  mov b, __s2 ; ")\n"
  swp b
  push b
  call print
  add sp, 2
;; print("Enter a string: "); 
  mov b, __s4 ; "Enter a string: "
  swp b
  push b
  call print
  add sp, 2
;; gets(input_str); 
  lea d, [bp + -111] ; $input_str
  mov b, d
  swp b
  push b
  call gets
  add sp, 2
;; encrypted_chars_len = 0; 
  lea d, [bp + -313] ; $encrypted_chars_len
  push d
  mov b, $0
  pop d
  mov [d], b
;; print("Encrypted text: "); 
  mov b, __s5 ; "Encrypted text: "
  swp b
  push b
  call print
  add sp, 2
;; for (i = 0; input_str[i] != '\0' && input_str[i] != '\n'; i++) { 
_for1_init:
  lea d, [bp + -315] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -111] ; $input_str
  push a
  push d
  lea d, [bp + -315] ; $i
  mov b, [d]
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
  push a
  mov a, b
  lea d, [bp + -111] ; $input_str
  push a
  push d
  lea d, [bp + -315] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _for1_exit
_for1_block:
;; encrypted_chars[i] = mod_exp(input_str[i], e, n); 
  lea d, [bp + -311] ; $encrypted_chars
  push a
  push d
  lea d, [bp + -315] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -5] ; $n
  mov b, [d]
  swp b
  push b
  lea d, [bp + -9] ; $e
  mov b, [d]
  swp b
  push b
  lea d, [bp + -111] ; $input_str
  push a
  push d
  lea d, [bp + -315] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call mod_exp
  add sp, 6
  pop d
  mov [d], b
;; printu(encrypted_chars[i]); 
  lea d, [bp + -311] ; $encrypted_chars
  push a
  push d
  lea d, [bp + -315] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; print(" "); 
  mov b, __s6 ; " "
  swp b
  push b
  call print
  add sp, 2
;; encrypted_chars_len++; 
  lea d, [bp + -313] ; $encrypted_chars_len
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -313] ; $encrypted_chars_len
  mov [d], b
  mov b, g
_for1_update:
  lea d, [bp + -315] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -315] ; $i
  mov [d], b
  mov b, g
  jmp _for1_cond
_for1_exit:
;; print("\n"); 
  mov b, __s7 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print("Decrypted text: "); 
  mov b, __s8 ; "Decrypted text: "
  swp b
  push b
  call print
  add sp, 2
;; for (i = 0; i < encrypted_chars_len; i++) { 
_for2_init:
  lea d, [bp + -315] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for2_cond:
  lea d, [bp + -315] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -313] ; $encrypted_chars_len
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for2_exit
_for2_block:
;; decrypted_char = mod_exp(encrypted_chars[i], d, n); 
  lea d, [bp + -317] ; $decrypted_char
  push d
  lea d, [bp + -5] ; $n
  mov b, [d]
  swp b
  push b
  lea d, [bp + -11] ; $d
  mov b, [d]
  swp b
  push b
  lea d, [bp + -311] ; $encrypted_chars
  push a
  push d
  lea d, [bp + -315] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call mod_exp
  add sp, 6
  pop d
  mov [d], b
;; c = decrypted_char; 
  lea d, [bp + -318] ; $c
  push d
  lea d, [bp + -317] ; $decrypted_char
  mov b, [d]
  pop d
  mov [d], bl
;; putchar(c); 
  lea d, [bp + -318] ; $c
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
_for2_update:
  lea d, [bp + -315] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -315] ; $i
  mov [d], b
  mov b, g
  jmp _for2_cond
_for2_exit:
;; print("\n"); 
  mov b, __s7 ; "\n"
  swp b
  push b
  call print
  add sp, 2
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
  je _while4_exit
_while4_block:
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
  jmp _while4_cond
_while4_exit:
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
_for5_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for5_cond:
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
  je _for5_exit
_for5_block:
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
_for5_update:
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
  jmp _for5_cond
_for5_exit:
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
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while6_cond
_while6_exit:
;; return length; 
  lea d, [bp + -1] ; $length
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
;; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; for(;;){ 
_for7_init:
_for7_cond:
_for7_block:
;; if(!*fp) break; 
_if8_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if8_else
_if8_true:
;; break; 
  jmp _for7_exit ; for break
  jmp _if8_exit
_if8_else:
;; if(*fp == '%'){ 
_if9_cond:
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
  je _if9_else
_if9_true:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
;; switch(*fp){ 
_switch10_expr:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch10_comparisons:
  cmp bl, $64
  je _switch10_case0
  cmp bl, $69
  je _switch10_case1
  cmp bl, $75
  je _switch10_case2
  cmp bl, $78
  je _switch10_case3
  cmp bl, $63
  je _switch10_case4
  cmp bl, $73
  je _switch10_case5
  jmp _switch10_default
  jmp _switch10_exit
_switch10_case0:
_switch10_case1:
;; prints(*(int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call prints
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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch10_exit ; case break
_switch10_case2:
;; printu(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch10_exit ; case break
_switch10_case3:
;; printx16(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printx16
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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch10_exit ; case break
_switch10_case4:
;; putchar(*(char*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch10_exit ; case break
_switch10_case5:
;; print(*(char**)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch10_exit ; case break
_switch10_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s9 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch10_exit:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
  jmp _if9_exit
_if9_else:
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
_if9_exit:
_if8_exit:
_for7_update:
  jmp _for7_cond
_for7_exit:
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
_for11_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for11_cond:
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
  je _for11_exit
_for11_block:
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
_if12_cond:
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
  je _if12_else
_if12_true:
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
  jmp _if12_exit
_if12_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if13_cond:
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
  je _if13_else
_if13_true:
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
  jmp _if13_exit
_if13_else:
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
_if13_exit:
_if12_exit:
_for11_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for11_cond
_for11_exit:
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
_while14_cond:
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
  je _while14_exit
_while14_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while14_cond
_while14_exit:
;; if (*str == '-' || *str == '+') { 
_if15_cond:
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
  je _if15_exit
_if15_true:
;; if (*str == '-') sign = -1; 
_if16_cond:
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
  je _if16_exit
_if16_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
  jmp _if16_exit
_if16_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if15_exit
_if15_exit:
;; while (*str >= '0' && *str <= '9') { 
_while17_cond:
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
  je _while17_exit
_while17_block:
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
  jmp _while17_cond
_while17_exit:
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
_if18_cond:
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
  je _if18_else
_if18_true:
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
  jmp _if18_exit
_if18_else:
;; if (num == 0) { 
_if19_cond:
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
  je _if19_exit
_if19_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if19_exit
_if19_exit:
_if18_exit:
;; while (num > 0) { 
_while20_cond:
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
  je _while20_exit
_while20_block:
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
  jmp _while20_cond
_while20_exit:
;; while (i > 0) { 
_while21_cond:
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
  je _while21_exit
_while21_block:
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
  jmp _while21_cond
_while21_exit:
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
_if22_cond:
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
  je _if22_exit
_if22_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if22_exit
_if22_exit:
;; while (num > 0) { 
_while23_cond:
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
  je _while23_exit
_while23_block:
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
  jmp _while23_cond
_while23_exit:
;; while (i > 0) { 
_while24_cond:
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
  je _while24_exit
_while24_block:
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
  jmp _while24_cond
_while24_exit:
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
  mov b, __s10 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

printun:
  enter 0 ; (push bp; mov bp, sp)
;; print(prompt); 
  lea d, [bp + 7] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; printu(n); 
  lea d, [bp + 5] ; $n
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; print("\n"); 
  mov b, __s7 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

printsn:
  enter 0 ; (push bp; mov bp, sp)
;; print(prompt); 
  lea d, [bp + 7] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; prints(n); 
  lea d, [bp + 5] ; $n
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; print("\n"); 
  mov b, __s7 ; "\n"
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

gcd:
  enter 0 ; (push bp; mov bp, sp)
;; if (b == 0) { 
_if25_cond:
  lea d, [bp + 5] ; $b
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
  je _if25_exit
_if25_true:
;; return a; 
  lea d, [bp + 7] ; $a
  mov b, [d]
  leave
  ret
  jmp _if25_exit
_if25_exit:
;; return gcd(b, a % b); 
  lea d, [bp + 7] ; $a
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $b
  mov b, [d]
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  swp b
  push b
  lea d, [bp + 5] ; $b
  mov b, [d]
  swp b
  push b
  call gcd
  add sp, 4
  leave
  ret

mod_exp:
  enter 0 ; (push bp; mov bp, sp)
; $result 
  sub sp, 2
;; result = 1; 
  lea d, [bp + -1] ; $result
  push d
  mov b, $1
  pop d
  mov [d], b
;; while (exp > 0) { 
_while26_cond:
  lea d, [bp + 7] ; $exp
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
  je _while26_exit
_while26_block:
;; if (exp & 1) { 
_if27_cond:
  lea d, [bp + 7] ; $exp
  mov b, [d]
  push a
  mov a, b
  mov b, $1
  and a, b ; &
  mov b, a
  pop a
  cmp b, 0
  je _if27_exit
_if27_true:
;; result = (result * base) % mod; 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 9] ; $base
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $mod
  mov b, [d]
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  jmp _if27_exit
_if27_exit:
;; exp = exp >> 1; 
  lea d, [bp + 7] ; $exp
  push d
  lea d, [bp + 7] ; $exp
  mov b, [d]
; START SHIFT
  push a
  mov a, b
  mov b, $1
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  pop d
  mov [d], b
;; base = (base * base) % mod; 
  lea d, [bp + 9] ; $base
  push d
  lea d, [bp + 9] ; $base
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 9] ; $base
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $mod
  mov b, [d]
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
  jmp _while26_cond
_while26_exit:
;; return result; 
  lea d, [bp + -1] ; $result
  mov b, [d]
  leave
  ret

find_e:
  enter 0 ; (push bp; mov bp, sp)
; $e 
  sub sp, 2
;; for (e = 2; e < phi; e++) { 
_for28_init:
  lea d, [bp + -1] ; $e
  push d
  mov b, $2
  pop d
  mov [d], b
_for28_cond:
  lea d, [bp + -1] ; $e
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $phi
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for28_exit
_for28_block:
;; if (gcd(e, phi) == 1) { 
_if29_cond:
  lea d, [bp + 5] ; $phi
  mov b, [d]
  swp b
  push b
  lea d, [bp + -1] ; $e
  mov b, [d]
  swp b
  push b
  call gcd
  add sp, 4
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if29_exit
_if29_true:
;; return e; 
  lea d, [bp + -1] ; $e
  mov b, [d]
  leave
  ret
  jmp _if29_exit
_if29_exit:
_for28_update:
  lea d, [bp + -1] ; $e
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $e
  mov [d], b
  mov b, g
  jmp _for28_cond
_for28_exit:
;; return 0; 
  mov b, $0
  leave
  ret

find_d:
  enter 0 ; (push bp; mov bp, sp)
; $d 
  sub sp, 2
;; for (d = 2; d < phi; d++) { 
_for30_init:
  lea d, [bp + -1] ; $d
  push d
  mov b, $2
  pop d
  mov [d], b
_for30_cond:
  lea d, [bp + -1] ; $d
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $phi
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for30_exit
_for30_block:
;; if ((d * e) % phi == 1) { 
_if31_cond:
  lea d, [bp + -1] ; $d
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 7] ; $e
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 5] ; $phi
  mov b, [d]
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if31_exit
_if31_true:
;; return d; 
  lea d, [bp + -1] ; $d
  mov b, [d]
  leave
  ret
  jmp _if31_exit
_if31_exit:
_for30_update:
  lea d, [bp + -1] ; $d
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $d
  mov [d], b
  mov b, g
  jmp _for30_cond
_for30_exit:
;; return 0; 
  mov b, $0
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
__s0: .db "Public Key: (", 0
__s1: .db ", ", 0
__s2: .db ")\n", 0
__s3: .db "Private Key: (", 0
__s4: .db "Enter a string: ", 0
__s5: .db "Encrypted text: ", 0
__s6: .db " ", 0
__s7: .db "\n", 0
__s8: .db "Decrypted text: ", 0
__s9: .db "Error: Unknown argument type.\n", 0
__s10: .db "\033[2J\033[H", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
