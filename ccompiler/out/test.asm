; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; u1[0]; 
  mov d, _u1_data ; $u1
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 23 ; mov a, 23; mul a, b; add d, b
  pop a
  mov b, d
  mov c, 0
; return; 
  leave
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_u1_data: .fill 230, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
