; --- FILENAME: test
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; putchar('A',1,2); 
  mov b, $2
  swp b
  push b
  mov b, $1
  swp b
  push b
  mov b, $41
  push bl
  call putchar
  add sp, 5
  syscall sys_terminate_proc

putchar:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
