; --- FILENAME: test
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; prin(110, 123); 
  mov b, $7b
  swp b
  push b
  mov b, $6e
  swp b
  push b
  call prin
  add sp, 4
;; return 0; 
  mov b, $0
  leave
  syscall sys_terminate_proc

prin:
  enter 0 ; (push bp; mov bp, sp)
;; printu(a); 
  lea d, [bp + 5] ; $a
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; printu(b); 
  lea d, [bp + 7] ; $b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
  leave
  ret

gcd:
  enter 0 ; (push bp; mov bp, sp)
;; if (b == 0) { 
_if1_cond:
  lea d, [bp + 7] ; $b
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
  je _if1_exit
_if1_true:
;; return a; 
  lea d, [bp + 5] ; $a
  mov b, [d]
  leave
  ret
  jmp _if1_exit
_if1_exit:
;; return gcd(b, a % b); 
  lea d, [bp + 5] ; $a
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + 7] ; $b
  mov b, [d]
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  swp b
  push b
  lea d, [bp + 7] ; $b
  mov b, [d]
  swp b
  push b
  call gcd
  add sp, 4
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
_if2_cond:
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
  je _if2_exit
_if2_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if2_exit
_if2_exit:
;; while (num > 0) { 
_while3_cond:
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
  je _while3_exit
_while3_block:
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
  jmp _while3_cond
_while3_exit:
;; while (i > 0) { 
_while4_cond:
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
  je _while4_exit
_while4_block:
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
  jmp _while4_cond
_while4_exit:
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

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
