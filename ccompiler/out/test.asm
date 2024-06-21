; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; &k->energy; 
  mov d, _k ; $k
  mov d, [d]
  add d, 1
  mov b, d
  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_klin_data: .fill 3, 0
_k: .fill 2, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
