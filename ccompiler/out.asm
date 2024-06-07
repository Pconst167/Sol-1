; --- FILENAME: test
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; myfunc(1, 2, 255, 65535, 127); 
  mov b, $ff
  swp b
  push b
  mov b, $ffff
  swp b
  push b
  mov b, $7f
  swp b
  push b
  mov b, $1
  swp b
  push b
  mov b, $2
  swp b
  push b
  call myfunc
  add sp, 10
;; return 0; 
  mov b, $0
  leave
  syscall sys_terminate_proc

myfunc:
  enter 0 ; (push bp; mov bp, sp)
; $aa 
; $bb 
; $cc 
; $p 
  sub sp, 8
;; p = &a; 
  lea d, [bp + -7] ; $p
  push d
  lea d, [bp + 7] ; $a
  mov b, d
  pop d
  mov [d], b
;; printu(*(p+2)); 
  lea d, [bp + -7] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; puts("\n\r"); 
  mov b, __s0 ; "\n\r"
  swp b
  push b
  call puts
  add sp, 2
;; printu(*(p+4)); 
  lea d, [bp + -7] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $4
  add a, b
  mov b, a
  pop a
; END TERMS
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; puts("\n\r"); 
  mov b, __s0 ; "\n\r"
  swp b
  push b
  call puts
  add sp, 2
;; printu(*(p+6)); 
  lea d, [bp + -7] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $6
  add a, b
  mov b, a
  pop a
; END TERMS
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
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
_if1_cond:
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
  je _if1_exit
_if1_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if1_exit
_if1_exit:
;; while (num > 0) { 
_while2_cond:
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
  je _while2_exit
_while2_block:
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
  jmp _while2_cond
_while2_exit:
;; while (i > 0) { 
_while3_cond:
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
  je _while3_exit
_while3_block:
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
  jmp _while3_cond
_while3_exit:
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
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
__s0: .db "\n\r", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
