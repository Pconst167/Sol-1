; --- FILENAME: programs/base64
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; char input[512]; 
; $input 
;; char output[256]; 
; $output 
;; printf("Enter a base64 encoded string to decode: "); 
  mov b, _s0 ; "Enter a base64 encoded string to decode: "
  swp b
  push b
  call printf
  add sp, 2
;; gets(input); 
  lea d, [bp + -511] ; $input
  mov b, d
  swp b
  push b
  call gets
  add sp, 2
;; base64_encode(input, output); 
  lea d, [bp + -767] ; $output
  mov b, d
  swp b
  push b
  lea d, [bp + -511] ; $input
  mov b, d
  swp b
  push b
  call base64_encode
  add sp, 4
;; printf("Encoded string: %s\n", output); 
  lea d, [bp + -767] ; $output
  mov b, d
  swp b
  push b
  mov b, _s1 ; "Encoded string: %s\n"
  swp b
  push b
  call printf
  add sp, 4
;; base64_decode(output, input); 
  lea d, [bp + -511] ; $input
  mov b, d
  swp b
  push b
  lea d, [bp + -767] ; $output
  mov b, d
  swp b
  push b
  call base64_decode
  add sp, 4
;; printf("Decoded string: %s\n", input); 
  lea d, [bp + -511] ; $input
  mov b, d
  swp b
  push b
  mov b, _s2 ; "Decoded string: %s\n"
  swp b
  push b
  call printf
  add sp, 4
;; return 0; 
  mov b, $0
  leave
  syscall sys_terminate_proc

strcpy:
  enter 0 ; (push bp; mov bp, sp)
;; char *psrc; 
; $psrc 
;; char *pdest; 
; $pdest 
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
;; int dest_len; 
; $dest_len 
;; int i; 
; $i 
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
;; int length; 
; $length 
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
; $i 
;; for(i = 0; i < size; i++){ 
_for5_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for5_cond:
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
  je _for5_exit
_for5_block:
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
_for5_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for5_cond
_for5_exit:
;; return s; 
  lea d, [bp + 5] ; $s
  mov b, [d]
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
;; int result = 0;  // Initialize result 
; $result 
  mov a, $0
  mov [bp + -1], a
;; int sign = 1;    // Initialize sign as positive 
; $sign 
  mov a, $1
  mov [bp + -3], a
;; while (*str == ' ') str++; 
_while6_cond:
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
  je _while6_exit
_while6_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _while6_cond
_while6_exit:
;; if (*str == '-' || *str == '+') { 
_if7_cond:
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
  je _if7_exit
_if7_true:
;; if (*str == '-') sign = -1; 
_if8_cond:
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
  je _if8_exit
_if8_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $ffff
  pop d
  mov [d], b
  jmp _if8_exit
_if8_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _if7_exit
_if7_exit:
;; while (*str >= '0' && *str <= '9') { 
_while9_cond:
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
  je _while9_exit
_while9_block:
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
  jmp _while9_cond
_while9_exit:
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
; $sec 

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
; $fp 
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
; $p 
; $format_p 
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
_for10_init:
_for10_cond:
_for10_block:
;; if(!*format_p) break; 
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
;; break; 
  jmp _for10_exit ; for break
  jmp _if11_exit
_if11_else:
;; if(*format_p == '%'){ 
_if12_cond:
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
  je _if12_else
_if12_true:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; switch(*format_p){ 
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
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; if(*format_p == 'd' || *format_p == 'i') 
_if14_cond:
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
  je _if14_else
_if14_true:
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
  jmp _if14_exit
_if14_else:
;; if(*format_p == 'u') 
_if15_cond:
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
  je _if15_else
_if15_true:
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
  jmp _if15_exit
_if15_else:
;; if(*format_p == 'x') 
_if16_cond:
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
  je _if16_else
_if16_true:
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
  jmp _if16_exit
_if16_else:
;; err("Unexpected format in printf."); 
  mov b, _s3 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if16_exit:
_if15_exit:
_if14_exit:
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
  jmp _switch13_exit ; case break
_switch13_case2:
_switch13_case3:
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
  jmp _switch13_exit ; case break
_switch13_case4:
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
  jmp _switch13_exit ; case break
_switch13_case5:

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
  jmp _switch13_exit ; case break
_switch13_case6:

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
  jmp _switch13_exit ; case break
_switch13_case7:

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
  jmp _switch13_exit ; case break
_switch13_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, _s4 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch13_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
  jmp _if12_exit
_if12_else:
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
_if12_exit:
_if11_exit:
_for10_update:
  jmp _for10_cond
_for10_exit:
  leave
  ret

scanf:
  enter 0 ; (push bp; mov bp, sp)
;; char *p, *format_p; 
; $p 
; $format_p 
;; char c; 
; $c 
;; int i; 
; $i 
;; char input_string[  512                    ]; 
; $input_string 
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
_for17_init:
_for17_cond:
_for17_block:
;; if(!*format_p) break; 
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
;; break; 
  jmp _for17_exit ; for break
  jmp _if18_exit
_if18_else:
;; if(*format_p == '%'){ 
_if19_cond:
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
  je _if19_else
_if19_true:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; switch(*format_p){ 
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
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; if(*format_p == 'd' || *format_p == 'i'); 
_if21_cond:
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
  je _if21_else
_if21_true:
;; ; 
  jmp _if21_exit
_if21_else:
;; if(*format_p == 'u'); 
_if22_cond:
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
  je _if22_else
_if22_true:
;; ; 
  jmp _if22_exit
_if22_else:
;; if(*format_p == 'x'); 
_if23_cond:
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
  je _if23_else
_if23_true:
;; ; 
  jmp _if23_exit
_if23_else:
;; err("Unexpected format in printf."); 
  mov b, _s3 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if23_exit:
_if22_exit:
_if21_exit:
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
  jmp _switch20_exit ; case break
_switch20_case2:
_switch20_case3:
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
  jmp _switch20_exit ; case break
_switch20_case4:
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
  jmp _switch20_exit ; case break
_switch20_case5:
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
  jmp _switch20_exit ; case break
_switch20_case6:
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
  jmp _switch20_exit ; case break
_switch20_case7:
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
  jmp _switch20_exit ; case break
_switch20_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, _s4 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch20_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
  jmp _if19_exit
_if19_else:
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
_if19_exit:
_if18_exit:
_for17_update:
  jmp _for17_cond
_for17_exit:
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
; $value 
  mov a, $0
  mov [bp + -1], a
;; int i; 
; $i 
;; char hex_char; 
; $hex_char 
;; int len; 
; $len 
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
_for24_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for24_cond:
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
  je _for24_exit
_for24_block:
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
_if25_cond:
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
  je _if25_else
_if25_true:
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
  jmp _if25_exit
_if25_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if26_cond:
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
  je _if26_else
_if26_true:
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
  jmp _if26_exit
_if26_else:
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
_if26_exit:
_if25_exit:
_for24_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for24_cond
_for24_exit:
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
; $digits 
;; int i = 0; 
; $i 
  mov a, $0
  mov [bp + -6], a
;; if (num < 0) { 
_if27_cond:
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
  je _if27_else
_if27_true:
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
  jmp _if27_exit
_if27_else:
;; if (num == 0) { 
_if28_cond:
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
  je _if28_exit
_if28_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if28_exit
_if28_exit:
_if27_exit:
;; while (num > 0) { 
_while29_cond:
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
  je _while29_exit
_while29_block:
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
  jmp _while29_cond
_while29_exit:
;; while (i > 0) { 
_while30_cond:
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
  je _while30_exit
_while30_block:
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
  jmp _while30_cond
_while30_exit:
  leave
  ret

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
;; char digits[10]; 
; $digits 
;; int i = 0; 
; $i 
  mov a, $0
  mov [bp + -11], a
;; if (num < 0) { 
_if31_cond:
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
  je _if31_else
_if31_true:
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
  jmp _if31_exit
_if31_else:
;; if (num == 0) { 
_if32_cond:
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
  je _if32_exit
_if32_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if32_exit
_if32_exit:
_if31_exit:
;; while (num > 0) { 
_while33_cond:
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
  je _while33_exit
_while33_block:
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
  jmp _while33_cond
_while33_exit:
;; while (i > 0) { 
_while34_cond:
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
  je _while34_exit
_while34_block:
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
  jmp _while34_cond
_while34_exit:
  leave
  ret

print_unsigned_long:
  enter 0 ; (push bp; mov bp, sp)
;; char digits[10]; 
; $digits 
;; int i; 
; $i 
;; i = 0; 
  lea d, [bp + -11] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if35_cond:
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
  je _if35_exit
_if35_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if35_exit
_if35_exit:
;; while (num > 0) { 
_while36_cond:
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
  je _while36_exit
_while36_block:
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
  jmp _while36_cond
_while36_exit:
;; while (i > 0) { 
_while37_cond:
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
  je _while37_exit
_while37_block:
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
  jmp _while37_cond
_while37_exit:
  leave
  ret

print_unsigned:
  enter 0 ; (push bp; mov bp, sp)
;; char digits[5]; 
; $digits 
;; int i; 
; $i 
;; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if38_cond:
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
  je _if38_exit
_if38_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if38_exit
_if38_exit:
;; while (num > 0) { 
_while39_cond:
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
  je _while39_exit
_while39_block:
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
  jmp _while39_cond
_while39_exit:
;; while (i > 0) { 
_while40_cond:
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
  je _while40_exit
_while40_block:
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
  jmp _while40_cond
_while40_exit:
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
; $c 

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
; $m 

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
; $data 

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
  mov b, _s5 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
;; return i < 0 ? -i : i; 
_ternary41_cond:
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
  je _ternary41_false
_ternary41_true:
  lea d, [bp + 5] ; $i
  mov b, [d]
  neg b
  jmp _ternary41_exit
_ternary41_false:
  lea d, [bp + 5] ; $i
  mov b, [d]
_ternary41_exit:
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/asm/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

base64_encode:
  enter 0 ; (push bp; mov bp, sp)
;; int i = 0; 
; $i 
  mov a, $0
  mov [bp + -1], a
;; int j = 0; 
; $j 
  mov a, $0
  mov [bp + -3], a
;; int k; 
; $k 
;; int input_len; 
; $input_len 
;; unsigned char input_buffer[3]; 
; $input_buffer 
;; unsigned char output_buffer[4]; 
; $output_buffer 
;; input_len = strlen(input); 
  lea d, [bp + -7] ; $input_len
  push d
  lea d, [bp + 5] ; $input
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; while (input_len--) { 
_while42_cond:
  lea d, [bp + -7] ; $input_len
  mov b, [d]
  push b
  dec b
  lea d, [bp + -7] ; $input_len
  mov [d], b
  pop b
  cmp b, 0
  je _while42_exit
_while42_block:
;; input_buffer[i++] = *(input++); 
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $input
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $input
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (i == 3) { 
_if43_cond:
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
  je _if43_exit
_if43_true:
;; output_buffer[0] = (input_buffer[0] & 0xFC) >> 2; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $fc
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  pop d
  mov [d], bl
;; output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f0
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $c0
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $6
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[3] = input_buffer[2] & 0x3F; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $3
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
;; for (i = 0; i < 4; i++) { 
_for44_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for44_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for44_exit
_for44_block:
;; output[j++] = base64_table[output_buffer[i]]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov d, _base64_table ; $base64_table
  mov d, [d]
  push a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for44_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for44_cond
_for44_exit:
;; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if43_exit
_if43_exit:
  jmp _while42_cond
_while42_exit:
;; if (i) { 
_if45_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  cmp b, 0
  je _if45_exit
_if45_true:
;; for (k = i; k < 3; k++) { 
_for46_init:
  lea d, [bp + -5] ; $k
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
_for46_cond:
  lea d, [bp + -5] ; $k
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
  je _for46_exit
_for46_block:
;; input_buffer[k] = '\0'; 
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
_for46_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for46_cond
_for46_exit:
;; output_buffer[0] = (input_buffer[0] & 0xFC) >> 2; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $fc
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  pop d
  mov [d], bl
;; output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f0
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $c0
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $6
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; for (k = 0; k < i + 1; k++) { 
_for47_init:
  lea d, [bp + -5] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for47_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for47_exit
_for47_block:
;; output[j++] = base64_table[output_buffer[k]]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov d, _base64_table ; $base64_table
  mov d, [d]
  push a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for47_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for47_cond
_for47_exit:
;; while (i++ < 3) { 
_while48_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while48_exit
_while48_block:
;; output[j++] = '='; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $3d
  pop d
  mov [d], bl
  jmp _while48_cond
_while48_exit:
  jmp _if45_exit
_if45_exit:
;; output[j] = '\0'; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

base64_char_value:
  enter 0 ; (push bp; mov bp, sp)
;; if (c >= 'A' && c <= 'Z') return c - 'A'; 
_if49_cond:
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
  cmp b, 0
  je _if49_exit
_if49_true:
;; return c - 'A'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if49_exit
_if49_exit:
;; if (c >= 'a' && c <= 'z') return c - 'a' + 26; 
_if50_cond:
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
  cmp b, 0
  je _if50_exit
_if50_true:
;; return c - 'a' + 26; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, a
  mov a, b
  mov b, $1a
  add b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if50_exit
_if50_exit:
;; if (c >= '0' && c <= '9') return c - '0' + 52; 
_if51_cond:
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
  cmp b, 0
  je _if51_exit
_if51_true:
;; return c - '0' + 52; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  mov a, b
  mov b, $34
  add b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if51_exit
_if51_exit:
;; if (c == '+') return 62; 
_if52_cond:
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
  cmp b, 0
  je _if52_exit
_if52_true:
;; return 62; 
  mov b, $3e
  leave
  ret
  jmp _if52_exit
_if52_exit:
;; if (c == '/') return 63; 
_if53_cond:
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
  cmp b, 0
  je _if53_exit
_if53_true:
;; return 63; 
  mov b, $3f
  leave
  ret
  jmp _if53_exit
_if53_exit:
;; return -1; 
  mov b, $ffff
  leave
  ret

base64_decode:
  enter 0 ; (push bp; mov bp, sp)
;; int i = 0, j = 0, k = 0; 
; $i 
  mov a, $0
  mov [bp + -1], a
; $j 
  mov a, $0
  mov [bp + -3], a
; $k 
  mov a, $0
  mov [bp + -5], a
;; int input_len; 
; $input_len 
;; unsigned char input_buffer[4]; 
; $input_buffer 
;; unsigned char output_buffer[3]; 
; $output_buffer 
;; input_len = strlen(input); 
  lea d, [bp + -7] ; $input_len
  push d
  lea d, [bp + 5] ; $input
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; while (input_len-- && (input[k] != '=') && base64_char_value(input[k]) != -1) { 
_while54_cond:
  lea d, [bp + -7] ; $input_len
  mov b, [d]
  push b
  dec b
  lea d, [bp + -7] ; $input_len
  mov [d], b
  pop b
  push a
  mov a, b
  lea d, [bp + 5] ; $input
  mov d, [d]
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + 5] ; $input
  mov d, [d]
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call base64_char_value
  add sp, 1
; START RELATIONAL
  push a
  mov a, b
  mov b, $ffff
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b
  pop a
  cmp b, 0
  je _while54_exit
_while54_block:
;; input_buffer[i++] = input[k++]; 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $input
  mov d, [d]
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (i == 4) { 
_if55_cond:
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
  je _if55_exit
_if55_true:
;; for (i = 0; i < 4; i++) { 
_for56_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for56_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for56_exit
_for56_block:
;; input_buffer[i] = base64_char_value(input_buffer[i]); 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call base64_char_value
  add sp, 1
  pop d
  mov [d], bl
_for56_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for56_cond
_for56_exit:
;; output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $30
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3c
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[2] = ((input_buffer[2] & 0x03) << 6) + input_buffer[3]; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $6
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $3
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; for (i = 0; i < 3; i++) { 
_for57_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for57_cond:
  lea d, [bp + -1] ; $i
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
  je _for57_exit
_for57_block:
;; output[j++] = output_buffer[i]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for57_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for57_cond
_for57_exit:
;; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if55_exit
_if55_exit:
  jmp _while54_cond
_while54_exit:
;; if (i) { 
_if58_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  cmp b, 0
  je _if58_exit
_if58_true:
;; for (k = i; k < 4; k++) { 
_for59_init:
  lea d, [bp + -5] ; $k
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
_for59_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for59_exit
_for59_block:
;; input_buffer[k] = 0; 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
_for59_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for59_cond
_for59_exit:
;; for (k = 0; k < 4; k++) { 
_for60_init:
  lea d, [bp + -5] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for60_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for60_exit
_for60_block:
;; input_buffer[k] = base64_char_value(input_buffer[k]); 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call base64_char_value
  add sp, 1
  pop d
  mov [d], bl
_for60_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for60_cond
_for60_exit:
;; output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $30
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3c
  and b, a ; &
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; for (k = 0; k < i - 1; k++) { 
_for61_init:
  lea d, [bp + -5] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for61_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
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
  je _for61_exit
_for61_block:
;; output[j++] = output_buffer[k]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for61_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for61_cond
_for61_exit:
  jmp _if58_exit
_if58_exit:
;; output[j] = '\0'; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_base64_table_data: .db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", 0
_base64_table: .dw _base64_table_data
_s0: .db "Enter a base64 encoded string to decode: ", 0
_s1: .db "Encoded string: %s\n", 0
_s2: .db "Decoded string: %s\n", 0
_s3: .db "Unexpected format in printf.", 0
_s4: .db "Error: Unknown argument type.\n", 0
_s5: .db "\033[2J\033[H", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
