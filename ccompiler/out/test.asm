; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; puts(""); 
; --- START FUNCTION CALL
  mov b, _s0 ; ""
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts(""); 
; --- START FUNCTION CALL
  mov b, _s0 ; ""
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  syscall sys_terminate_proc

puts:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_s0: .db "", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
