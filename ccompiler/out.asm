; --- FILENAME: test
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; myfunc(1, 2, 'a', 255, 65535, 'b'); 
  mov b, $61
  swp b
  push b
  mov b, $ff
  swp b
  push b
  mov b, $ffff
  swp b
  push b
  mov b, $62
  swp b
  push b
  mov b, $1
  swp b
  push b
  mov b, $2
  swp b
  push b
  call myfunc
  add sp, 12
;; return 0; 
  mov b, $0
  leave
  syscall sys_terminate_proc

myfunc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
