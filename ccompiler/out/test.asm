; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
  syscall sys_terminate_proc

test0_subTest0:
  enter 0 ; (push bp; mov bp, sp)
;; ia[1]; 
  mov b, [bp + 5] ; $ia
  mov d, b
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
