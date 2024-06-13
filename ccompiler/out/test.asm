; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $i 
  sub sp, 4
;; i = 0xAABBCCDDL; 
  lea d, [bp + -3] ; $i
  push d
  mov b, $ccdd
  mov c, $aabb
  pop d
  mov [d], b
;; (long int)i; 
  lea d, [bp + -3] ; $i
  mov b, [d]
  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
