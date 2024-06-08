; --- FILENAME: test
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; ff3('1', '2', '3', '4'); 
  mov b, $34
  swp b
  push b
  mov b, $33
  swp b
  push b
  mov b, $32
  swp b
  push b
  mov b, $31
  push bl
  call ff3
  add sp, 7
;; return 0; 
  mov b, $0
  leave
  syscall sys_terminate_proc

ff3:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
