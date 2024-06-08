; --- FILENAME: test
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; printf(2, 'A', "Paulo", 1); 
  mov b, $1
  swp b
  push b
  mov b, __s0 ; "Paulo"
  swp b
  push b
  mov b, $41
  swp b
  push b
  mov b, $2
  swp b
  push b
  call printf
  add sp, 8
  syscall sys_terminate_proc

printf:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
__s0: .db "Paulo", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
