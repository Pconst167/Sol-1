; --- FILENAME: ctestsuite/testsuite1
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; int pass[10]; 
  sub sp, 20 ; pass
;; int i; 
  sub sp, 2 ; i
;; int nbr_tests = 10; 
  sub sp, 2 ; nbr_tests
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -23] ; $nbr_tests
  push d
  mov b, $a
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
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
  slt ; < (signed)
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
  slt ; < (signed)
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
  mov b, _s0 ; "Test %d, Result: %d\n"
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
  sand a, b
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
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
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
  mov b, $ffff
  pop d
  mov [d], b
  jmp _if10_exit
_if10_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
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
  mov b, _s1 ; "Unexpected format in printf."
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
  mov b, _s2 ; "Error: Unknown argument type.\n"
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
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
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
  mov b, _s1 ; "Unexpected format in printf."
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
  mov b, _s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch22_exit:
;; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
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

test0:
  enter 0 ; (push bp; mov bp, sp)
;; int i; 
  sub sp, 2 ; i
;; int pass = 1; 
  sub sp, 2 ; pass
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $pass
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; for (i = 0; i < 5; i++){ 
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
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for44_exit
_for44_block:
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
;; for (i = 0; i < 5; i++){ 
_for45_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for45_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for45_exit
_for45_block:
;; if(gca1[i] != 'A' + i){ 
_if46_cond:
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
  je _if46_exit
_if46_true:
;; pass = 0; 
  lea d, [bp + -3] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for45_exit ; for break
  jmp _if46_exit
_if46_exit:
;; if(gia1[i] != i){ 
_if47_cond:
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
  je _if47_exit
_if47_true:
;; pass = 0; 
  lea d, [bp + -3] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for45_exit ; for break
  jmp _if47_exit
_if47_exit:
_for45_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for45_cond
_for45_exit:
;; return pass; 
  lea d, [bp + -3] ; $pass
  mov b, [d]
  leave
  ret

test1:
  enter 0 ; (push bp; mov bp, sp)
;; int i, j; 
  sub sp, 2 ; i
  sub sp, 2 ; j
;; int pass = 1; 
  sub sp, 2 ; pass
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -5] ; $pass
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; for (i = 0; i < 5; i++){ 
_for48_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for48_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for48_exit
_for48_block:
;; for (j = 0; j < 5; j++){ 
_for49_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for49_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for49_exit
_for49_block:
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
_for49_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for49_cond
_for49_exit:
_for48_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for48_cond
_for48_exit:
;; for (i = 0; i < 5; i++){ 
_for50_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for50_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for50_exit
_for50_block:
;; for (j = 0; j < 5; j++){ 
_for51_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for51_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for51_exit
_for51_block:
;; if(gca2[i][j] != 'A' + i + j){ 
_if52_cond:
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
  je _if52_exit
_if52_true:
;; pass = 0; 
  lea d, [bp + -5] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for51_exit ; for break
  jmp _if52_exit
_if52_exit:
;; if(gia2[i][j] != i * j){ 
_if53_cond:
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
  je _if53_exit
_if53_true:
;; pass = 0; 
  lea d, [bp + -5] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for51_exit ; for break
  jmp _if53_exit
_if53_exit:
_for51_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for51_cond
_for51_exit:
_for50_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for50_cond
_for50_exit:
;; return pass; 
  lea d, [bp + -5] ; $pass
  mov b, [d]
  leave
  ret

test2:
  enter 0 ; (push bp; mov bp, sp)
;; int i, j; 
  sub sp, 2 ; i
  sub sp, 2 ; j
;; char lca[5]; 
  sub sp, 5 ; lca
;; int lia[5]; 
  sub sp, 10 ; lia
;; int pass = 1; 
  sub sp, 2 ; pass
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -20] ; $pass
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; for (i = 0; i < 5; i++){ 
_for54_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for54_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for54_exit
_for54_block:
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
_for54_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for54_cond
_for54_exit:
;; for (i = 0; i < 5; i++){ 
_for55_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for55_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for55_exit
_for55_block:
;; if(lca[i] != 'A' + i + j){ 
_if56_cond:
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
  je _if56_exit
_if56_true:
;; pass = 0; 
  lea d, [bp + -20] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for55_exit ; for break
  jmp _if56_exit
_if56_exit:
;; if(lia[i] != i * j){ 
_if57_cond:
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
  je _if57_exit
_if57_true:
;; pass = 0; 
  lea d, [bp + -20] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for55_exit ; for break
  jmp _if57_exit
_if57_exit:
_for55_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for55_cond
_for55_exit:
;; return pass; 
  lea d, [bp + -20] ; $pass
  mov b, [d]
  leave
  ret

test3:
  enter 0 ; (push bp; mov bp, sp)
;; int i, j; 
  sub sp, 2 ; i
  sub sp, 2 ; j
;; char lca[5][5]; 
  sub sp, 25 ; lca
;; int lia[5][5]; 
  sub sp, 50 ; lia
;; int pass = 1; 
  sub sp, 2 ; pass
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -80] ; $pass
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; for (i = 0; i < 5; i++){ 
_for58_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for58_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for58_exit
_for58_block:
;; for (j = 0; j < 5; j++){ 
_for59_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for59_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for59_exit
_for59_block:
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
_for59_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for59_cond
_for59_exit:
_for58_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for58_cond
_for58_exit:
;; for (i = 0; i < 5; i++){ 
_for60_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for60_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for60_exit
_for60_block:
;; for (j = 0; j < 5; j++){ 
_for61_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for61_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for61_exit
_for61_block:
;; if(lca[i][j] != 'A' + i + j){ 
_if62_cond:
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
  je _if62_exit
_if62_true:
;; pass = 0; 
  lea d, [bp + -80] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for61_exit ; for break
  jmp _if62_exit
_if62_exit:
;; if(lia[i][j] != i * j){ 
_if63_cond:
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
  je _if63_exit
_if63_true:
;; pass = 0; 
  lea d, [bp + -80] ; $pass
  push d
  mov b, $0
  pop d
  mov [d], b
;; break; 
  jmp _for61_exit ; for break
  jmp _if63_exit
_if63_exit:
_for61_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for61_cond
_for61_exit:
_for60_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for60_cond
_for60_exit:
;; return pass; 
  lea d, [bp + -80] ; $pass
  mov b, [d]
  leave
  ret

test4:
  enter 0 ; (push bp; mov bp, sp)
;; int a, b, c; 
  sub sp, 2 ; a
  sub sp, 2 ; b
  sub sp, 2 ; c
;; int result; 
  sub sp, 2 ; result
;; int pass = 1; 
  sub sp, 2 ; pass
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -9] ; $pass
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; result = 1 && 1 && 1; 
  lea d, [bp + -7] ; $result
  push d
  mov b, $1
  push a
  mov a, b
  mov b, $1
  sand a, b
  mov a, b
  mov b, $1
  sand a, b
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
  sand a, b
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
  sand a, b
  mov a, b
  mov b, $1
  sand a, b
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
  sand a, b
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
  sand a, b
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
  sand a, b
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
  sand a, b
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
  sand a, b
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
  sand a, b
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
  sand a, b
  mov a, b
  lea d, [bp + -5] ; $c
  mov b, [d]
  sand a, b
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
  sand a, b
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
  sand a, b
  mov a, b
  lea d, [bp + -5] ; $c
  mov b, [d]
  sand a, b
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
  sand a, b
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
  sand a, b
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
  sand a, b
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
  sand a, b
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
  sand a, b
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
  sand a, b
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
;; int pass; 
  sub sp, 2 ; pass
;; int i, j, k; 
  sub sp, 2 ; i
  sub sp, 2 ; j
  sub sp, 2 ; k
;; int a1[5]; 
  sub sp, 10 ; a1
;; int a2[5]; 
  sub sp, 10 ; a2
;; int a3[5]; 
  sub sp, 10 ; a3
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
  sand a, b
  pop a
  add b, a
  mov a, b
  mov b, $1
  push a
  mov a, b
  mov b, $0
  sand a, b
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
  sand a, b
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
;; int pass = 1; 
  sub sp, 2 ; pass
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $pass
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; int i, j, k; 
  sub sp, 2 ; i
  sub sp, 2 ; j
  sub sp, 2 ; k
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
  sand a, b
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for64_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for64_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for64_exit
_for64_block:
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
  sand a, b
  pop a
  pop d
  mov [d], b
_for64_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for64_cond
_for64_exit:
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
  sand a, b
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for65_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for65_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for65_exit
_for65_block:
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
  sand a, b
  pop a
  pop d
  mov [d], b
_for65_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for65_cond
_for65_exit:
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test7:
  enter 0 ; (push bp; mov bp, sp)
;; int pass = 1; 
  sub sp, 2 ; pass
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $pass
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; int i, j, k; 
  sub sp, 2 ; i
  sub sp, 2 ; j
  sub sp, 2 ; k
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
  sand a, b
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for66_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for66_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for66_exit
_for66_block:
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
  sand a, b
  pop a
  pop d
  mov [d], b
_for66_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for66_cond
_for66_exit:
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
  sand a, b
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for67_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for67_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for67_exit
_for67_block:
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
  sand a, b
  pop a
  pop d
  mov [d], b
_for67_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for67_cond
_for67_exit:
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test8:
  enter 0 ; (push bp; mov bp, sp)
;; int pass = 1; 
  sub sp, 2 ; pass
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $pass
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; int i, j, k; 
  sub sp, 2 ; i
  sub sp, 2 ; j
  sub sp, 2 ; k
;; struct t_test8_struct test8_struct; 
  sub sp, 18 ; test8_struct
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
  sand a, b
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for68_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for68_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for68_exit
_for68_block:
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
  sand a, b
  pop a
  pop d
  mov [d], b
_for68_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for68_cond
_for68_exit:
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
  sand a, b
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for69_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for69_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for69_exit
_for69_block:
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
  sand a, b
  pop a
  pop d
  mov [d], b
_for69_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for69_cond
_for69_exit:
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test9:
  enter 0 ; (push bp; mov bp, sp)
;; int pass = 1; 
  sub sp, 2 ; pass
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $pass
  push d
  mov b, $1
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
;; int i, j, k; 
  sub sp, 2 ; i
  sub sp, 2 ; j
  sub sp, 2 ; k
;; struct t_test9_struct test9_struct; 
  sub sp, 36 ; test9_struct
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
  sand a, b
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for70_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for70_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for70_exit
_for70_block:
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
  sand a, b
  pop a
  pop d
  mov [d], b
_for70_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for70_cond
_for70_exit:
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
  sand a, b
  pop a
  pop d
  mov [d], b
;; for(i = 0; i < 5; i++){ 
_for71_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for71_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $5
  cmp a, b
  slt ; < (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for71_exit
_for71_block:
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
  sand a, b
  pop a
  pop d
  mov [d], b
_for71_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for71_cond
_for71_exit:
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_gca1_data: 
.db $30,$31,$32,$33,$34,
_gia1_data: 
.dw $0,$1,$2,$3,$4,
_gca2_data: .fill 25, 0
_gia2_data: .fill 50, 0
_test6_struct_data: .fill 18, 0
_test7_struct_data: .fill 36, 0
_s0: .db "Test %d, Result: %d\n", 0
_s1: .db "Unexpected format in printf.", 0
_s2: .db "Error: Unknown argument type.\n", 0
_s3: .db "\033[2J\033[H", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
