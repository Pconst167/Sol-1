; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; a = 65536L; 
  mov d, _a ; $a
  push d
  mov b, $0
  mov c, $1
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; p = &a; 
  mov d, _p ; $p
  push d
  mov d, _a ; $a
  mov b, d
  pop d
  mov [d], b
;; *p; 
  mov d, _p ; $p
  mov b, [d]
  mov d, b
  mov b, [d + 2]
  mov c, b
  mov b, [d]
  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_a: .fill 4, 0
_b: .fill 4, 0
_c: .fill 4, 0
_p: .fill 2, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
