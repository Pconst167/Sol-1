; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; static long int m2[2]=  {3L}; 
  sub sp, 8
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT

st_main_m2_dt: 
.dw $0003, $0000, 
.fill 4, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
