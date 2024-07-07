; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; ss=ss2; 
  mov d, _ss_data ; $ss
  push d
  mov d, _ss2_data ; $ss2
  mov b, d
  mov c, 0
  pop d
  mov si, b
  mov di, d
  mov c, 3
  rep movsb
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_ss_data: .fill 3, 0
_ss2_data: .fill 3, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
