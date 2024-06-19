; --- FILENAME: ctestsuite/testsuite1
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $pass 
; $i 
; $nbr_tests 
  mov a, $a
  mov [bp + -23], a
  sub sp, 24
;; for(i = 0; i < nbr_tests; i++){ 
_for1_init:
  lea d, [bp + -21] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -21] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -23] ; $nbr_tests
  mov b, [d]
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
;; pass[i] = -1; 
  lea d, [bp + -19] ; $pass
  push a
  push d
  lea d, [bp + -21] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $ffff
  pop d
  mov [d], b
_for1_update:
  lea d, [bp + -21] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -21] ; $i
  mov [d], b
  pop b
  jmp _for1_cond
_for1_exit:
;; pass[0] = test0(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test0
  pop d
  mov [d], b
;; pass[1] = test1(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test1
  pop d
  mov [d], b
;; pass[2] = test2(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test2
  pop d
  mov [d], b
;; pass[3] = test3(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test3
  pop d
  mov [d], b
;; pass[4] = test4(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test4
  pop d
  mov [d], b
;; pass[5] = test5(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $5
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test5
  pop d
  mov [d], b
;; pass[6] = test6(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $6
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test6
  pop d
  mov [d], b
;; pass[7] = test7(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $7
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test7
  pop d
  mov [d], b
;; pass[8] = test8(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $8
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test8
  pop d
  mov [d], b
;; pass[9] = test9(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $9
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test9
  pop d
  mov [d], b
;; for(i = 0; i < nbr_tests; i++) 
_for2_init:
  lea d, [bp + -21] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for2_cond:
  lea d, [bp + -21] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -23] ; $nbr_tests
  mov b, [d]
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for2_exit
_for2_block:
;; printf("Test %d, Result: %d\n", i, pass[i]); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  lea d, [bp + -21] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  lea d, [bp + -21] ; $i
  mov b, [d]
  swp b
  push b
  mov b, __s0 ; "Test %d, Result: %d\n"
  swp b
  push b
  call printf
  add sp, 6
_for2_update:
  lea d, [bp + -21] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -21] ; $i
  mov [d], b
  pop b
  jmp _for2_cond
_for2_exit:
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
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while4_exit
_while4_block:
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
  push b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  pop b
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
_while7_cond:
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
  je _while7_exit
_while7_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _while7_cond
_while7_exit:
;; if (*str == '-' || *str == '+') { 
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
  je _if8_exit
_if8_true:
;; if (*str == '-') sign = -1; 
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
  cmp b, 0
  je _if9_exit
_if9_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $ffff
  pop d
  mov [d], b
  jmp _if9_exit
_if9_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _if8_exit
_if8_exit:
;; while (*str >= '0' && *str <= '9') { 
_while10_cond:
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
  sleu ; <= (unsigned)
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while10_exit
_while10_block:
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
  jmp _while10_cond
_while10_exit:
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

srand:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

malloc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

calloc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

realloc:
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

base64_encode:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  mov a, $0
  mov [bp + -1], a
; $j 
  mov a, $0
  mov [bp + -3], a
; $k 
; $input_len 
; $input_buffer 
; $output_buffer 
  sub sp, 15
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
_while11_cond:
  lea d, [bp + -7] ; $input_len
  mov b, [d]
  push b
  dec b
  lea d, [bp + -7] ; $input_len
  mov [d], b
  pop b
  cmp b, 0
  je _while11_exit
_while11_block:
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
_if12_cond:
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
  je _if12_exit
_if12_true:
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
  pop a
  pop d
  mov [d], bl
;; for (i = 0; i < 4; i++) { 
_for13_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for13_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for13_exit
_for13_block:
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
_for13_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for13_cond
_for13_exit:
;; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if12_exit
_if12_exit:
  jmp _while11_cond
_while11_exit:
;; if (i) { 
_if14_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  cmp b, 0
  je _if14_exit
_if14_true:
;; for (k = i; k < 3; k++) { 
_for15_init:
  lea d, [bp + -5] ; $k
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
_for15_cond:
  lea d, [bp + -5] ; $k
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
  je _for15_exit
_for15_block:
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
_for15_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for15_cond
_for15_exit:
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
_for16_init:
  lea d, [bp + -5] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for16_cond:
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for16_exit
_for16_block:
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
_for16_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for16_cond
_for16_exit:
;; while (i++ < 3) { 
_while17_cond:
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while17_exit
_while17_block:
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
  jmp _while17_cond
_while17_exit:
  jmp _if14_exit
_if14_exit:
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
_if18_cond:
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
  cmp b, 0
  je _if18_exit
_if18_true:
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
  jmp _if18_exit
_if18_exit:
;; if (c >= 'a' && c <= 'z') return c - 'a' + 26; 
_if19_cond:
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
  cmp b, 0
  je _if19_exit
_if19_true:
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
  jmp _if19_exit
_if19_exit:
;; if (c >= '0' && c <= '9') return c - '0' + 52; 
_if20_cond:
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
  cmp b, 0
  je _if20_exit
_if20_true:
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
  jmp _if20_exit
_if20_exit:
;; if (c == '+') return 62; 
_if21_cond:
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
  je _if21_exit
_if21_true:
;; return 62; 
  mov b, $3e
  leave
  ret
  jmp _if21_exit
_if21_exit:
;; if (c == '/') return 63; 
_if22_cond:
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
  je _if22_exit
_if22_true:
;; return 63; 
  mov b, $3f
  leave
  ret
  jmp _if22_exit
_if22_exit:
;; return -1; 
  mov b, $ffff
  leave
  ret

base64_decode:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  mov a, $0
  mov [bp + -1], a
; $j 
  mov a, $0
  mov [bp + -3], a
; $k 
  mov a, $0
  mov [bp + -5], a
; $input_len 
; $input_buffer 
; $output_buffer 
  sub sp, 15
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
_while23_cond:
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
  sand a, b ; &&
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
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while23_exit
_while23_block:
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
_if24_cond:
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
  je _if24_exit
_if24_true:
;; for (i = 0; i < 4; i++) { 
_for25_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for25_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for25_exit
_for25_block:
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
_for25_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for25_cond
_for25_exit:
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
_for26_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for26_cond:
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
  je _for26_exit
_for26_block:
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
_for26_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for26_cond
_for26_exit:
;; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if24_exit
_if24_exit:
  jmp _while23_cond
_while23_exit:
;; if (i) { 
_if27_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  cmp b, 0
  je _if27_exit
_if27_true:
;; for (k = i; k < 4; k++) { 
_for28_init:
  lea d, [bp + -5] ; $k
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
_for28_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for28_exit
_for28_block:
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
_for28_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for28_cond
_for28_exit:
;; for (k = 0; k < 4; k++) { 
_for29_init:
  lea d, [bp + -5] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for29_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for29_exit
_for29_block:
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
_for29_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for29_cond
_for29_exit:
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
  and a, b ; &
  mov b, a
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
_for30_init:
  lea d, [bp + -5] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for30_cond:
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
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for30_exit
_for30_block:
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
_for30_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for30_cond
_for30_exit:
  jmp _if27_exit
_if27_exit:
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

va_start:
  enter 0 ; (push bp; mov bp, sp)
;; argp->current_arg = first_fixed_param + sizeof(first_fixed_param); 
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  push d
  lea d, [bp + 7] ; $first_fixed_param
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, 2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  leave
  ret

va_arg:
  enter 0 ; (push bp; mov bp, sp)
; $p 
  sub sp, 2
;; p = argp->current_arg; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  mov b, [d]
  pop d
  mov [d], b
;; argp->current_arg = argp->current_arg + size; 
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  push d
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $size
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return p; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  leave
  ret

va_end:
  enter 0 ; (push bp; mov bp, sp)
;; argp->current_arg =   0   ; 
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  push d
  mov b, $0
  pop d
  mov [d], b
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
_for31_init:
_for31_cond:
_for31_block:
;; if(!*format_p) break; 
_if32_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if32_else
_if32_true:
;; break; 
  jmp _for31_exit ; for break
  jmp _if32_exit
_if32_else:
;; if(*format_p == '%'){ 
_if33_cond:
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
  je _if33_else
_if33_true:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; switch(*format_p){ 
_switch34_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch34_comparisons:
  cmp bl, $6c
  je _switch34_case0
  cmp bl, $4c
  je _switch34_case1
  cmp bl, $64
  je _switch34_case2
  cmp bl, $69
  je _switch34_case3
  cmp bl, $75
  je _switch34_case4
  cmp bl, $78
  je _switch34_case5
  cmp bl, $63
  je _switch34_case6
  cmp bl, $73
  je _switch34_case7
  jmp _switch34_default
  jmp _switch34_exit
_switch34_case0:
_switch34_case1:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; if(*format_p == 'd' || *format_p == 'i'); 
_if35_cond:
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
  je _if35_else
_if35_true:
;; ; 
  jmp _if35_exit
_if35_else:
;; if(*format_p == 'u'); 
_if36_cond:
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
  je _if36_else
_if36_true:
;; ; 
  jmp _if36_exit
_if36_else:
;; if(*format_p == 'x'); 
_if37_cond:
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
  je _if37_else
_if37_true:
;; ; 
  jmp _if37_exit
_if37_else:
;; err("Unexpected format in printf."); 
  mov b, __s1 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if37_exit:
_if36_exit:
_if35_exit:
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
  jmp _switch34_exit ; case break
_switch34_case2:
_switch34_case3:
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
  jmp _switch34_exit ; case break
_switch34_case4:
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
  jmp _switch34_exit ; case break
_switch34_case5:
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
  jmp _switch34_exit ; case break
_switch34_case6:
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
  jmp _switch34_exit ; case break
_switch34_case7:
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
  jmp _switch34_exit ; case break
_switch34_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch34_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
  jmp _if33_exit
_if33_else:
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
_if33_exit:
_if32_exit:
_for31_update:
  jmp _for31_cond
_for31_exit:
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
_for38_init:
_for38_cond:
_for38_block:
;; if(!*format_p) break; 
_if39_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if39_else
_if39_true:
;; break; 
  jmp _for38_exit ; for break
  jmp _if39_exit
_if39_else:
;; if(*format_p == '%'){ 
_if40_cond:
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
  je _if40_else
_if40_true:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; switch(*format_p){ 
_switch41_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch41_comparisons:
  cmp bl, $6c
  je _switch41_case0
  cmp bl, $4c
  je _switch41_case1
  cmp bl, $64
  je _switch41_case2
  cmp bl, $69
  je _switch41_case3
  cmp bl, $75
  je _switch41_case4
  cmp bl, $78
  je _switch41_case5
  cmp bl, $63
  je _switch41_case6
  cmp bl, $73
  je _switch41_case7
  jmp _switch41_default
  jmp _switch41_exit
_switch41_case0:
_switch41_case1:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
;; if(*format_p == 'd' || *format_p == 'i') 
_if42_cond:
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
  je _if42_else
_if42_true:
;; print_signed_long(*(long *)p); 
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call print_signed_long
  add sp, 4
  jmp _if42_exit
_if42_else:
;; if(*format_p == 'u') 
_if43_cond:
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
  je _if43_else
_if43_true:
;; print_unsigned_long(*(unsigned long *)p); 
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call print_unsigned_long
  add sp, 4
  jmp _if43_exit
_if43_else:
;; if(*format_p == 'x') 
_if44_cond:
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
  je _if44_else
_if44_true:
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
  jmp _if44_exit
_if44_else:
;; err("Unexpected format in printf."); 
  mov b, __s1 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if44_exit:
_if43_exit:
_if42_exit:
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
  jmp _switch41_exit ; case break
_switch41_case2:
_switch41_case3:
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
  jmp _switch41_exit ; case break
_switch41_case4:
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
  jmp _switch41_exit ; case break
_switch41_case5:

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
  jmp _switch41_exit ; case break
_switch41_case6:

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
  jmp _switch41_exit ; case break
_switch41_case7:

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
  jmp _switch41_exit ; case break
_switch41_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch41_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
  jmp _if40_exit
_if40_else:
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
_if40_exit:
_if39_exit:
_for38_update:
  jmp _for38_cond
_for38_exit:
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
;; exit(); 
  call exit
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
_for45_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for45_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for45_exit
_for45_block:
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
_if46_cond:
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
  je _if46_else
_if46_true:
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
  jmp _if46_exit
_if46_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if47_cond:
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
  je _if47_else
_if47_true:
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
  jmp _if47_exit
_if47_else:
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
_if47_exit:
_if46_exit:
_for45_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for45_cond
_for45_exit:
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
_if48_cond:
  lea d, [bp + 5] ; $num
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
  je _if48_else
_if48_true:
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
  jmp _if48_exit
_if48_else:
;; if (num == 0) { 
_if49_cond:
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
  je _if49_exit
_if49_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if49_exit
_if49_exit:
_if48_exit:
;; while (num > 0) { 
_while50_cond:
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
  je _while50_exit
_while50_block:
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
  jmp _while50_cond
_while50_exit:
;; while (i > 0) { 
_while51_cond:
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
  je _while51_exit
_while51_block:
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
  jmp _while51_cond
_while51_exit:
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
_if52_cond:
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
  mov si, a
  mov a, b
  mov di, a
  mov a, g
  mov b, c
  cmp a, b
  slu ; <
  push b
  mov b, c
  seq ; ==
  push b
  mov a, di
  mov b, a
  mov a, si
  cmp a, b
  slu ; <
  pop a
  and b, a
  pop a
  or b, a
  
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _if52_else
_if52_true:
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
  jmp _if52_exit
_if52_else:
;; if (num == 0) { 
_if53_cond:
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
  cmp a, b
  seq ; ==
  push b
  mov a, c
  mov b, g
  cmp a, b
  seq ; ==
  pop a
  sand a, b
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _if53_exit
_if53_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if53_exit
_if53_exit:
_if52_exit:
;; while (num > 0) { 
_while54_cond:
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
  cmp a, b
  sgt ; >
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _while54_exit
_while54_block:
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
  jmp _while54_cond
_while54_exit:
;; while (i > 0) { 
_while55_cond:
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
  je _while55_exit
_while55_block:
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
  jmp _while55_cond
_while55_exit:
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
_if56_cond:
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
  cmp a, b
  seq ; ==
  push b
  mov a, c
  mov b, g
  cmp a, b
  seq ; ==
  pop a
  sand a, b
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _if56_exit
_if56_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if56_exit
_if56_exit:
;; while (num > 0) { 
_while57_cond:
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
  cmp a, b
  sgu ; > (unsigned)
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _while57_exit
_while57_block:
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
  jmp _while57_cond
_while57_exit:
;; while (i > 0) { 
_while58_cond:
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
  je _while58_exit
_while58_block:
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
  jmp _while58_cond
_while58_exit:
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
_if59_cond:
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
  je _if59_exit
_if59_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if59_exit
_if59_exit:
;; while (num > 0) { 
_while60_cond:
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
  je _while60_exit
_while60_block:
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
  jmp _while60_cond
_while60_exit:
;; while (i > 0) { 
_while61_cond:
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
  je _while61_exit
_while61_block:
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
  jmp _while61_cond
_while61_exit:
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
  lea d, [bp + 7] ; $destination
  mov a, [d]
  mov di, a
  lea d, [bp + 5] ; $filename
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
  mov b, __s3 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/asm/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

test0:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $pass 
  mov a, $1
  mov [bp + -3], a
  sub sp, 4
;; for (i = 0; i < 5; i++){ 
_for62_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for62_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for62_exit
_for62_block:
;; gca1[i] = 'A' + i; 
  mov d, _gca1_data ; $gca1
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $41
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; gia1[i] = i; 
  mov d, _gia1_data ; $gia1
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
_for62_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for62_cond
_for62_exit:
;; for (i = 0; i < 5; i++){ 
_for63_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for63_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for63_exit
_for63_block:
;; if(gca1[i] != 'A' + i){ 
_if64_cond:
  mov d, _gca1_data ; $gca1
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  pop a
; END TERMS
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if64_exit
_if64_true:
;; pass = 0; 
  lea d, [bp + -3] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for63_exit ; for break
  jmp _if64_exit
_if64_exit:
;; if(gia1[i] != i){ 
_if65_cond:
  mov d, _gia1_data ; $gia1
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
  lea d, [bp + -1] ; $i
  mov b, [d]
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if65_exit
_if65_true:
;; pass = 0; 
  lea d, [bp + -3] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for63_exit ; for break
  jmp _if65_exit
_if65_exit:
_for63_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for63_cond
_for63_exit:
;; return pass; 
  lea d, [bp + -3] ; $pass
  mov b, [d]
  leave
  ret

test1:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $j 
; $pass 
  mov a, $1
  mov [bp + -5], a
  sub sp, 6
;; for (i = 0; i < 5; i++){ 
_for66_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for66_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for66_exit
_for66_block:
;; for (j = 0; j < 5; j++){ 
_for67_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for67_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for67_exit
_for67_block:
;; gca2[i][j] = 'A' + i + j; 
  mov d, _gca2_data ; $gca2
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 5 ; mov a, 5; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $41
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; gia2[i][j] = i * j; 
  mov d, _gia2_data ; $gia2
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
_for67_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for67_cond
_for67_exit:
_for66_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for66_cond
_for66_exit:
;; for (i = 0; i < 5; i++){ 
_for68_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for68_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for68_exit
_for68_block:
;; for (j = 0; j < 5; j++){ 
_for69_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for69_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for69_exit
_for69_block:
;; if(gca2[i][j] != 'A' + i + j){ 
_if70_cond:
  mov d, _gca2_data ; $gca2
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 5 ; mov a, 5; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  add b, a
  pop a
; END TERMS
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if70_exit
_if70_true:
;; pass = 0; 
  lea d, [bp + -5] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for69_exit ; for break
  jmp _if70_exit
_if70_exit:
;; if(gia2[i][j] != i * j){ 
_if71_cond:
  mov d, _gia2_data ; $gia2
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if71_exit
_if71_true:
;; pass = 0; 
  lea d, [bp + -5] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for69_exit ; for break
  jmp _if71_exit
_if71_exit:
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
;; return pass; 
  lea d, [bp + -5] ; $pass
  mov b, [d]
  leave
  ret

test2:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $j 
; $lca 
; $lia 
; $pass 
  mov a, $1
  mov [bp + -20], a
  sub sp, 21
;; for (i = 0; i < 5; i++){ 
_for72_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for72_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for72_exit
_for72_block:
;; lca[i] = 'A' + i + j; 
  lea d, [bp + -8] ; $lca
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $41
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; lia[i] = i * j; 
  lea d, [bp + -18] ; $lia
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
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
;; for (i = 0; i < 5; i++){ 
_for73_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for73_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for73_exit
_for73_block:
;; if(lca[i] != 'A' + i + j){ 
_if74_cond:
  lea d, [bp + -8] ; $lca
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  add b, a
  pop a
; END TERMS
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if74_exit
_if74_true:
;; pass = 0; 
  lea d, [bp + -20] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for73_exit ; for break
  jmp _if74_exit
_if74_exit:
;; if(lia[i] != i * j){ 
_if75_cond:
  lea d, [bp + -18] ; $lia
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
  lea d, [bp + -1] ; $i
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if75_exit
_if75_true:
;; pass = 0; 
  lea d, [bp + -20] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for73_exit ; for break
  jmp _if75_exit
_if75_exit:
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
;; return pass; 
  lea d, [bp + -20] ; $pass
  mov b, [d]
  leave
  ret

test3:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $j 
; $lca 
; $lia 
; $pass 
  mov a, $1
  mov [bp + -80], a
  sub sp, 81
;; for (i = 0; i < 5; i++){ 
_for76_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for76_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for76_exit
_for76_block:
;; for (j = 0; j < 5; j++){ 
_for77_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for77_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for77_exit
_for77_block:
;; lca[i][j] = 'A' + i + j; 
  lea d, [bp + -28] ; $lca
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 5 ; mov a, 5; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $41
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; lia[i][j] = i * j; 
  lea d, [bp + -78] ; $lia
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
_for77_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for77_cond
_for77_exit:
_for76_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for76_cond
_for76_exit:
;; for (i = 0; i < 5; i++){ 
_for78_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for78_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for78_exit
_for78_block:
;; for (j = 0; j < 5; j++){ 
_for79_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for79_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for79_exit
_for79_block:
;; if(lca[i][j] != 'A' + i + j){ 
_if80_cond:
  lea d, [bp + -28] ; $lca
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 5 ; mov a, 5; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
; START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  add b, a
  pop a
; END TERMS
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if80_exit
_if80_true:
;; pass = 0; 
  lea d, [bp + -80] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for79_exit ; for break
  jmp _if80_exit
_if80_exit:
;; if(lia[i][j] != i * j){ 
_if81_cond:
  lea d, [bp + -78] ; $lia
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if81_exit
_if81_true:
;; pass = 0; 
  lea d, [bp + -80] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for79_exit ; for break
  jmp _if81_exit
_if81_exit:
_for79_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for79_cond
_for79_exit:
_for78_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for78_cond
_for78_exit:
;; return pass; 
  lea d, [bp + -80] ; $pass
  mov b, [d]
  leave
  ret

test4:
  enter 0 ; (push bp; mov bp, sp)
; $a 
; $b 
; $c 
; $result 
; $pass 
  mov a, $1
  mov [bp + -9], a
  sub sp, 10
;; result = 1 && 1 && 1; 
  lea d, [bp + -7] ; $result
  push d
  mov b, $1
  push a
  mov a, b
  mov b, $1
  sand a, b ; &&
  mov a, b
  mov b, $1
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; result = 1 && 0 && 1; 
  lea d, [bp + -7] ; $result
  push d
  mov b, $1
  push a
  mov a, b
  mov b, $0
  sand a, b ; &&
  mov a, b
  mov b, $1
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 0; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; result = 1 || 1 || 1; 
  lea d, [bp + -7] ; $result
  push d
  mov b, $1
  push a
  mov a, b
  mov b, $1
  sor a, b ; ||
  mov a, b
  mov b, $1
  sor a, b ; ||
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; result = 0 || 1 || 0; 
  lea d, [bp + -7] ; $result
  push d
  mov b, $0
  push a
  mov a, b
  mov b, $1
  sor a, b ; ||
  mov a, b
  mov b, $0
  sor a, b ; ||
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; result = 1 || 0 && 1; 
  lea d, [bp + -7] ; $result
  push d
  mov b, $1
  push a
  mov a, b
  mov b, $0
  push a
  mov a, b
  mov b, $1
  sand a, b ; &&
  pop a
  sor a, b ; ||
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; result = 0 || 0 || 0; 
  lea d, [bp + -7] ; $result
  push d
  mov b, $0
  push a
  mov a, b
  mov b, $0
  sor a, b ; ||
  mov a, b
  mov b, $0
  sor a, b ; ||
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 0; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; a = 1; b = 1; c = 1; 
  lea d, [bp + -1] ; $a
  push d
  mov b, $1
  pop d
  mov [d], b
;; b = 1; c = 1; 
  lea d, [bp + -3] ; $b
  push d
  mov b, $1
  pop d
  mov [d], b
;; c = 1; 
  lea d, [bp + -5] ; $c
  push d
  mov b, $1
  pop d
  mov [d], b
;; result = a && b && c; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  sand a, b ; &&
  mov a, b
  lea d, [bp + -5] ; $c
  mov b, [d]
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; a = 1; b = 0; c = 1; 
  lea d, [bp + -1] ; $a
  push d
  mov b, $1
  pop d
  mov [d], b
;; b = 0; c = 1; 
  lea d, [bp + -3] ; $b
  push d
  mov b, $0
  pop d
  mov [d], b
;; c = 1; 
  lea d, [bp + -5] ; $c
  push d
  mov b, $1
  pop d
  mov [d], b
;; result = a && b && c; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  sand a, b ; &&
  mov a, b
  lea d, [bp + -5] ; $c
  mov b, [d]
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 0; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; a = 1; b = 1; c = 1; 
  lea d, [bp + -1] ; $a
  push d
  mov b, $1
  pop d
  mov [d], b
;; b = 1; c = 1; 
  lea d, [bp + -3] ; $b
  push d
  mov b, $1
  pop d
  mov [d], b
;; c = 1; 
  lea d, [bp + -5] ; $c
  push d
  mov b, $1
  pop d
  mov [d], b
;; result = a || b || b; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  sor a, b ; ||
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  sor a, b ; ||
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; a = 0; b = 1; c = 0; 
  lea d, [bp + -1] ; $a
  push d
  mov b, $0
  pop d
  mov [d], b
;; b = 1; c = 0; 
  lea d, [bp + -3] ; $b
  push d
  mov b, $1
  pop d
  mov [d], b
;; c = 0; 
  lea d, [bp + -5] ; $c
  push d
  mov b, $0
  pop d
  mov [d], b
;; result = a || b || b; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  sor a, b ; ||
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  sor a, b ; ||
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; a = 1; b = 0; c = 1; 
  lea d, [bp + -1] ; $a
  push d
  mov b, $1
  pop d
  mov [d], b
;; b = 0; c = 1; 
  lea d, [bp + -3] ; $b
  push d
  mov b, $0
  pop d
  mov [d], b
;; c = 1; 
  lea d, [bp + -5] ; $c
  push d
  mov b, $1
  pop d
  mov [d], b
;; result = a || b && b; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  sand a, b ; &&
  pop a
  sor a, b ; ||
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; a = 0; b = 0; c = 0; 
  lea d, [bp + -1] ; $a
  push d
  mov b, $0
  pop d
  mov [d], b
;; b = 0; c = 0; 
  lea d, [bp + -3] ; $b
  push d
  mov b, $0
  pop d
  mov [d], b
;; c = 0; 
  lea d, [bp + -5] ; $c
  push d
  mov b, $0
  pop d
  mov [d], b
;; result = a || b || b; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  sor a, b ; ||
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  sor a, b ; ||
  pop a
  pop d
  mov [d], b
;; pass = pass && result == 0; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -7] ; $result
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; return pass; 
  lea d, [bp + -9] ; $pass
  mov b, [d]
  leave
  ret

test5:
  enter 0 ; (push bp; mov bp, sp)
; $pass 
; $i 
; $j 
; $k 
; $a1 
; $a2 
; $a3 
  sub sp, 38
;; i = 1; 
  lea d, [bp + -3] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
;; j = 1; 
  lea d, [bp + -5] ; $j
  push d
  mov b, $1
  pop d
  mov [d], b
;; k = 1; 
  lea d, [bp + -7] ; $k
  push d
  mov b, $1
  pop d
  mov [d], b
;; a1[3] = 1; 
  lea d, [bp + -17] ; $a1
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $1
  pop d
  mov [d], b
;; a2[2] = 1; 
  lea d, [bp + -27] ; $a2
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $1
  pop d
  mov [d], b
;; a3[a2[a1[i + j + (k && 1) + (1 && 0)] + (i && 1)] + (0 || j)] = 56; 
  lea d, [bp + -37] ; $a3
  push a
  push d
  lea d, [bp + -27] ; $a2
  push a
  push d
  lea d, [bp + -17] ; $a1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $j
  mov b, [d]
  add b, a
  mov a, b
  lea d, [bp + -7] ; $k
  mov b, [d]
  push a
  mov a, b
  mov b, $1
  sand a, b ; &&
  pop a
  add b, a
  mov a, b
  mov b, $1
  push a
  mov a, b
  mov b, $0
  sand a, b ; &&
  pop a
  add b, a
  pop a
; END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  push a
  mov a, b
  mov b, $1
  sand a, b ; &&
  pop a
  add b, a
  pop a
; END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $0
  push a
  mov a, b
  lea d, [bp + -5] ; $j
  mov b, [d]
  sor a, b ; ||
  pop a
  add b, a
  pop a
; END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $38
  pop d
  mov [d], b
;; pass = a3[2] == 56; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -37] ; $a3
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
  mov b, $38
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  pop d
  mov [d], b
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test6:
  enter 0 ; (push bp; mov bp, sp)
; $pass 
  mov a, $1
  mov [bp + -1], a
; $i 
; $j 
; $k 
  sub sp, 8
;; test6_struct.c1 = 'A'; 
  mov d, _test6_struct_data ; $test6_struct
  add d, 0
  push d
  mov b, $41
  pop d
  mov [d], bl
;; pass = pass && test6_struct.c1 == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov d, _test6_struct_data ; $test6_struct
  add d, 0
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for82_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for82_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for82_exit
_for82_block:
;; test6_struct.ca[i] = i; 
  mov d, _test6_struct_data ; $test6_struct
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mov [d], bl
;; pass = pass && test6_struct.ca[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov d, _test6_struct_data ; $test6_struct
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
_for82_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for82_cond
_for82_exit:
;; test6_struct.i1 = 55555; 
  mov d, _test6_struct_data ; $test6_struct
  add d, 6
  push d
  mov b, $d903
  pop d
  mov [d], b
;; pass = pass && test6_struct.i1 == 55555; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov d, _test6_struct_data ; $test6_struct
  add d, 6
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $d903
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for83_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for83_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for83_exit
_for83_block:
;; test6_struct.ia[i] = i; 
  mov d, _test6_struct_data ; $test6_struct
  add d, 8
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mov [d], b
;; pass = pass && test6_struct.ia[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov d, _test6_struct_data ; $test6_struct
  add d, 8
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
_for83_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for83_cond
_for83_exit:
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test7:
  enter 0 ; (push bp; mov bp, sp)
; $pass 
  mov a, $1
  mov [bp + -1], a
; $i 
; $j 
; $k 
  sub sp, 8
;; test7_struct.test7_substruct.c1 = 'A'; 
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 0
  push d
  mov b, $41
  pop d
  mov [d], bl
;; pass = pass && test7_struct.test7_substruct.c1 == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 0
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for84_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for84_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for84_exit
_for84_block:
;; test7_struct.test7_substruct.ca[i] = i; 
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mov [d], bl
;; pass = pass && test7_struct.test7_substruct.ca[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
_for84_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for84_cond
_for84_exit:
;; test7_struct.test7_substruct.i1 = 55555; 
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 6
  push d
  mov b, $d903
  pop d
  mov [d], b
;; pass = pass && test7_struct.test7_substruct.i1 == 55555; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 6
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $d903
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for85_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for85_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for85_exit
_for85_block:
;; test7_struct.test7_substruct.ia[i] = i; 
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 8
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mov [d], b
;; pass = pass && test7_struct.test7_substruct.ia[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 8
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
_for85_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for85_cond
_for85_exit:
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test8:
  enter 0 ; (push bp; mov bp, sp)
; $pass 
  mov a, $1
  mov [bp + -1], a
; $i 
; $j 
; $k 
; $test8_struct 
  sub sp, 26
;; test8_struct.c1 = 'A'; 
  lea d, [bp + -25] ; $test8_struct
  add d, 0
  push d
  mov b, $41
  pop d
  mov [d], bl
;; pass = pass && test8_struct.c1 == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -25] ; $test8_struct
  add d, 0
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for86_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for86_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for86_exit
_for86_block:
;; test8_struct.ca[i] = i; 
  lea d, [bp + -25] ; $test8_struct
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mov [d], bl
;; pass = pass && test8_struct.ca[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -25] ; $test8_struct
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
_for86_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for86_cond
_for86_exit:
;; test8_struct.i1 = 55555; 
  lea d, [bp + -25] ; $test8_struct
  add d, 6
  push d
  mov b, $d903
  pop d
  mov [d], b
;; pass = pass && test8_struct.i1 == 55555; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -25] ; $test8_struct
  add d, 6
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $d903
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for87_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for87_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for87_exit
_for87_block:
;; test8_struct.ia[i] = i; 
  lea d, [bp + -25] ; $test8_struct
  add d, 8
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mov [d], b
;; pass = pass && test8_struct.ia[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -25] ; $test8_struct
  add d, 8
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
_for87_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for87_cond
_for87_exit:
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test9:
  enter 0 ; (push bp; mov bp, sp)
; $pass 
  mov a, $1
  mov [bp + -1], a
; $i 
; $j 
; $k 
; $test9_struct 
  sub sp, 44
;; test9_struct.test9_substruct.c1 = 'A'; 
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 0
  push d
  mov b, $41
  pop d
  mov [d], bl
;; pass = pass && test9_struct.test9_substruct.c1 == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 0
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for88_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for88_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for88_exit
_for88_block:
;; test9_struct.test9_substruct.ca[i] = i; 
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mov [d], bl
;; pass = pass && test9_struct.test9_substruct.ca[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
_for88_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for88_cond
_for88_exit:
;; test9_struct.test9_substruct.i1 = 55555; 
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 6
  push d
  mov b, $d903
  pop d
  mov [d], b
;; pass = pass && test9_struct.test9_substruct.i1 == 55555; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 6
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $d903
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for89_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for89_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for89_exit
_for89_block:
;; test9_struct.test9_substruct.ia[i] = i; 
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 8
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mov [d], b
;; pass = pass && test9_struct.test9_substruct.ia[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 8
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
_for89_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for89_cond
_for89_exit:
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_base64_table_data: .db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", 0
_base64_table: .dw _base64_table_data
_gca1_data: 
.db $30,$31,$32,$33,$34,
_gia1_data: 
.dw 0,1,2,3,4,
_gca2_data: .fill 25, 0
_gia2_data: .fill 50, 0
_test6_struct_data: .fill 18, 0
_test7_struct_data: .fill 36, 0
__s0: .db "Test %d, Result: %d\n", 0
__s1: .db "Unexpected format in printf.", 0
__s2: .db "Error: Unknown argument type.\n", 0
__s3: .db "\033[2J\033[H", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
