; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $i 
  sub sp, 2
;; 'A' || 123L; 
  mov b, $41
  push a
  mov a, b
  mov b, $7b
  mov c, $0
  sor a, b ; ||
  push b
  mov a, c
  mov b, 0
  sor a, b ; ||
  pop a
  sor a, b ; ||
  pop a
;; return; 
  leave
  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
