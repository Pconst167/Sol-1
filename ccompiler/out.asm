; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; aa=1; 
  mov d, _static_main_aa ; static aa
  push d
  mov b, $1
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
;; return; 
  leave
  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_l_data: .fill 1060, 0
_p: .fill 2, 0
_static_main_aa: .fill 4, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
