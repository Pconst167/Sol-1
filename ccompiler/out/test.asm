; --- FILENAME: test
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; ff(255); 
  mov b, $ff
  swp b
  push b
  call ff
  add sp, 2
;; return 0; 
  mov b, $0
  leave
  syscall sys_terminate_proc

myfunc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

ff:
  enter 0 ; (push bp; mov bp, sp)
;; ff(1); 
  mov b, $1
  swp b
  push b
  call ff
  add sp, 2
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
