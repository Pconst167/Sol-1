; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)

; --- BEGIN INLINE ASM BLOCK
  mov g, b
; --- END INLINE ASM BLOCK

  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
