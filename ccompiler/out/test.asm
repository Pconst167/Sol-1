; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int i; 
  sub sp, 2
mylabel:
.db 1
  mov a, 1
  mov d, 2
  add c, 1
  add a, 1
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_string: .fill 2, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
