; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
  syscall sys_terminate_proc

func:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_p: .fill 2, 0
_q: .fill 2, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
