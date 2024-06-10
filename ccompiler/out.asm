; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; 65536L; 
  mov b, $0
  mov c, $1
;; c = a + b; 
  mov d, _c ; $c
  push d
  mov d, _a ; $a
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov d, _b ; $b
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_a: .fill 4, 0
_b: .fill 4, 0
_c: .fill 4, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
