; --- FILENAME: programs/life
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $i 
; $j 
; $n 
  sub sp, 6
;; for(i = 0; i <   30     ; i++){ 
_for1_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1e
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
;; for(j = 0; j <    40    ; j++){ 
_for2_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for2_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for2_exit
_for2_block:
;; nextState[i][j] = currState[i][j]; 
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for2_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for2_cond
_for2_exit:
_for1_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for1_cond
_for1_exit:
;; for(;;){ 
_for3_init:
_for3_cond:
_for3_block:
;; for(i = 1; i <   30     +-1; i++){ 
_for4_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for4_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1e
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
  pop a
; END TERMS
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for4_exit
_for4_block:
;; for(j = 1; j <    40    +-1; j++){ 
_for5_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $1
  pop d
  mov [d], b
_for5_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
  pop a
; END TERMS
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for5_exit
_for5_block:
;; n = neighbours(i, j); 
  lea d, [bp + -5] ; $n
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  swp b
  push b
  lea d, [bp + -1] ; $i
  mov b, [d]
  swp b
  push b
  call neighbours
  pop d
  mov [d], b
;; if(n < 2 || n > 3) nextState[i][j] = ' '; 
_if6_cond:
  lea d, [bp + -5] ; $n
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  slt ; <= (signed)
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $n
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if6_else
_if6_true:
;; nextState[i][j] = ' '; 
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $20
  pop d
  mov [d], bl
  jmp _if6_exit
_if6_else:
;; if(n == 3) nextState[i][j] = '@'; 
_if7_cond:
  lea d, [bp + -5] ; $n
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
  je _if7_exit
_if7_true:
;; nextState[i][j] = '@'; 
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $40
  pop d
  mov [d], bl
  jmp _if7_exit
_if7_exit:
_if6_exit:
_for5_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for5_cond
_for5_exit:
_for4_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for4_cond
_for4_exit:
;; for(i = 1; i <   30     +-1; i++){ 
_for8_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $1
  pop d
  mov [d], b
_for8_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1e
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
  pop a
; END TERMS
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for8_exit
_for8_block:
;; for(j = 1; j <    40    +-1; j++){ 
_for9_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $1
  pop d
  mov [d], b
_for9_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
  pop a
; END TERMS
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for9_exit
_for9_block:
;; currState[i][j] = nextState[i][j]; 
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for9_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for9_cond
_for9_exit:
_for8_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for8_cond
_for8_exit:
;; printf(clear); 
  mov d, _clear_data ; $clear
  mov b, d
  swp b
  push b
  call printf
;; show(); 
  call show
;; puts("\n\rPress CTRL+C to quit.\n\r"); 
  mov b, __s0 ; "\n\rPress CTRL+C to quit.\n\r"
  swp b
  push b
  call puts
  add sp, 2
_for3_update:
  jmp _for3_cond
_for3_exit:
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
_while10_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while10_exit
_while10_block:
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
  jmp _while10_cond
_while10_exit:
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
_while11_cond:
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
  je _while11_exit
_while11_block:
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
  jmp _while11_cond
_while11_exit:
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
_for12_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for12_cond:
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
  je _for12_exit
_for12_block:
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
  add a, b
  mov b, a
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
_for12_update:
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
  jmp _for12_cond
_for12_exit:
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
_while13_cond:
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
  je _while13_exit
_while13_block:
;; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  pop b
  jmp _while13_cond
_while13_exit:
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
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
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
  mov b, $ffffffff
  pop d
  mov [d], b
  jmp _if16_exit
_if16_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
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
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
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
  add a, b
  mov b, a
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
  add a, b
  mov b, a
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
_for18_init:
_for18_cond:
_for18_block:
;; if(!*fp) break; 
_if19_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if19_else
_if19_true:
;; break; 
  jmp _for18_exit ; for break
  jmp _if19_exit
_if19_else:
;; if(*fp == '%'){ 
_if20_cond:
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
  je _if20_else
_if20_true:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  pop b
;; switch(*fp){ 
_switch21_expr:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch21_comparisons:
  cmp bl, $6c
  je _switch21_case0
  cmp bl, $4c
  je _switch21_case1
  cmp bl, $64
  je _switch21_case2
  cmp bl, $69
  je _switch21_case3
  cmp bl, $75
  je _switch21_case4
  cmp bl, $78
  je _switch21_case5
  cmp bl, $63
  je _switch21_case6
  cmp bl, $73
  je _switch21_case7
  jmp _switch21_default
  jmp _switch21_exit
_switch21_case0:
_switch21_case1:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  pop b
;; if(*fp == 'd' || *fp == 'i') 
_if22_cond:
  lea d, [bp + -3] ; $fp
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
  lea d, [bp + -3] ; $fp
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
  je _if22_else
_if22_true:
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
  jmp _if22_exit
_if22_else:
;; if(*fp == 'u') 
_if23_cond:
  lea d, [bp + -3] ; $fp
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
  je _if23_else
_if23_true:
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
  jmp _if23_exit
_if23_else:
;; if(*fp == 'x') 
_if24_cond:
  lea d, [bp + -3] ; $fp
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
  je _if24_else
_if24_true:
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
  jmp _if24_exit
_if24_else:
;; err("Unexpected format in printf."); 
  mov b, __s1 ; "Unexpected format in printf."
  swp b
  push b
  call err
_if24_exit:
_if23_exit:
_if22_exit:
;; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $4
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch21_exit ; case break
_switch21_case2:
_switch21_case3:
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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch21_exit ; case break
_switch21_case4:
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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch21_exit ; case break
_switch21_case5:

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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch21_exit ; case break
_switch21_case6:

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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch21_exit ; case break
_switch21_case7:

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
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch21_exit ; case break
_switch21_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch21_exit:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  pop b
  jmp _if20_exit
_if20_else:
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
  push b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  pop b
_if20_exit:
_if19_exit:
_for18_update:
  jmp _for18_cond
_for18_exit:
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
_for25_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for25_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for25_exit
_for25_block:
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
_if26_cond:
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
  je _if26_else
_if26_true:
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
  mov a, b
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
  jmp _if26_exit
_if26_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if27_cond:
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
  je _if27_else
_if27_true:
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
  mov a, b
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
  jmp _if27_exit
_if27_else:
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
_if27_exit:
_if26_exit:
_for25_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for25_cond
_for25_exit:
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
_if28_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if28_else
_if28_true:
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
  jmp _if28_exit
_if28_else:
;; if (num == 0) { 
_if29_cond:
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
  je _if29_exit
_if29_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if29_exit
_if29_exit:
_if28_exit:
;; while (num > 0) { 
_while30_cond:
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
  je _while30_exit
_while30_block:
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
  push b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
  jmp _while30_cond
_while30_exit:
;; while (i > 0) { 
_while31_cond:
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
  je _while31_exit
_while31_block:
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
  jmp _while31_cond
_while31_exit:
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
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  neg b
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if32_exit
_if32_else:
;; if (num == 0) { 
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
  je _while34_exit
_while34_block:
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
  mov b, a
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
  jmp _while34_cond
_while34_exit:
;; while (i > 0) { 
_while35_cond:
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
  je _while35_exit
_while35_block:
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
  jmp _while35_cond
_while35_exit:
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
  je _if36_exit
_if36_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if36_exit
_if36_exit:
;; while (num > 0) { 
_while37_cond:
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
  je _while37_exit
_while37_block:
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
  mov b, a
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
  jmp _while37_cond
_while37_exit:
;; while (i > 0) { 
_while38_cond:
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
  je _while38_exit
_while38_block:
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
  jmp _while38_cond
_while38_exit:
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
_if39_cond:
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
  je _if39_exit
_if39_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if39_exit
_if39_exit:
;; while (num > 0) { 
_while40_cond:
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
  je _while40_exit
_while40_block:
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
  push b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
  jmp _while40_cond
_while40_exit:
;; while (i > 0) { 
_while41_cond:
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
  je _while41_exit
_while41_block:
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
  jmp _while41_cond
_while41_exit:
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

show:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $j 
  sub sp, 4
;; for(i = 0; i <   30     ; i++){ 
_for42_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for42_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1e
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for42_exit
_for42_block:
;; for(j = 0; j <    40    ; j++){ 
_for43_init:
  lea d, [bp + -3] ; $j
  push d
  mov b, $0
  pop d
  mov [d], b
_for43_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for43_exit
_for43_block:
;; currState[i][j] == '@' ? printf("@ ") : printf(". "); 
_ternary44_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
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
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _ternary44_false
_ternary44_true:
  mov b, __s4 ; "@ "
  swp b
  push b
  call printf
  jmp _ternary44_exit
_ternary44_false:
  mov b, __s5 ; ". "
  swp b
  push b
  call printf
_ternary44_exit:
_for43_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  jmp _for43_cond
_for43_exit:
;; putchar(10); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
_for42_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for42_cond
_for42_exit:
  leave
  ret

alive:
  enter 0 ; (push bp; mov bp, sp)
;; if(currState[i][j] == '@') return 1; 
_if45_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + 5] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + 7] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
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
  je _if45_else
_if45_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if45_exit
_if45_else:
;; return 0; 
  mov b, $0
  leave
  ret
_if45_exit:
  leave
  ret

neighbours:
  enter 0 ; (push bp; mov bp, sp)
; $count 
  sub sp, 2
;; count = 0; 
  lea d, [bp + -1] ; $count
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(currState[i+-1][j] == '@')			count++; 
_if46_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + 5] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + 7] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
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
  je _if46_exit
_if46_true:
;; count++; 
  lea d, [bp + -1] ; $count
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $count
  mov [d], b
  pop b
  jmp _if46_exit
_if46_exit:
;; if(currState[i+-1][j+-1] == '@') 	count++; 
_if47_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + 5] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + 7] ; $j
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
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
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if47_exit
_if47_true:
;; count++; 
  lea d, [bp + -1] ; $count
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $count
  mov [d], b
  pop b
  jmp _if47_exit
_if47_exit:
;; if(currState[i+-1][j+1] == '@') 	count++; 
_if48_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + 5] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + 7] ; $j
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
  add d, b
  pop a
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
  je _if48_exit
_if48_true:
;; count++; 
  lea d, [bp + -1] ; $count
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $count
  mov [d], b
  pop b
  jmp _if48_exit
_if48_exit:
;; if(currState[i][j+-1] == '@') 		count++; 
_if49_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + 5] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + 7] ; $j
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
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
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if49_exit
_if49_true:
;; count++; 
  lea d, [bp + -1] ; $count
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $count
  mov [d], b
  pop b
  jmp _if49_exit
_if49_exit:
;; if(currState[i][j+1] == '@') 			count++; 
_if50_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + 5] ; $i
  mov b, [d]
  pop d
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + 7] ; $j
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
  add d, b
  pop a
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
  je _if50_exit
_if50_true:
;; count++; 
  lea d, [bp + -1] ; $count
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $count
  mov [d], b
  pop b
  jmp _if50_exit
_if50_exit:
;; if(currState[i+1][j+-1] == '@') 	count++; 
_if51_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + 5] ; $i
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
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + 7] ; $j
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $ffffffff
  add a, b
  mov b, a
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
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if51_exit
_if51_true:
;; count++; 
  lea d, [bp + -1] ; $count
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $count
  mov [d], b
  pop b
  jmp _if51_exit
_if51_exit:
;; if(currState[i+1][j] == '@') 			count++; 
_if52_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + 5] ; $i
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
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + 7] ; $j
  mov b, [d]
  pop d
  add d, b
  pop a
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
  je _if52_exit
_if52_true:
;; count++; 
  lea d, [bp + -1] ; $count
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $count
  mov [d], b
  pop b
  jmp _if52_exit
_if52_exit:
;; if(currState[i+1][j+1] == '@') 		count++; 
_if53_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + 5] ; $i
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
  mma 40 ; mov a, 40; mul a, b; add d, b
  push d
  lea d, [bp + 7] ; $j
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
  add d, b
  pop a
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
  je _if53_exit
_if53_true:
;; count++; 
  lea d, [bp + -1] ; $count
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $count
  mov [d], b
  pop b
  jmp _if53_exit
_if53_exit:
;; return count; 
  lea d, [bp + -1] ; $count
  mov b, [d]
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_clear_data: 
.db 27,$5b,$32,$4a,27,$5b,$48,0,
.fill 3, 0
_nextState_data: .fill 1200, 0
_currState_data: 
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$40,$20,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$40,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$20,$20,$20,$40,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,$20,$20,$20,$40,$20,$20,$20,$20,$20,$40,
.db $20,$20,$20,$40,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,
.db $20,$20,$20,$40,$20,$20,$20,$40,$20,$40,$40,$20,$20,$20,$20,$40,$20,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$20,$20,$20,$20,$20,$40,$20,$20,$20,$20,$20,$20,$20,$40,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$20,$20,$20,$40,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.fill 400, 0
__s0: .db "\n\rPress CTRL+C to quit.\n\r", 0
__s1: .db "Unexpected format in printf.", 0
__s2: .db "Error: Unknown argument type.\n", 0
__s3: .db "\033[2J\033[H", 0
__s4: .db "@ ", 0
__s5: .db ". ", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
