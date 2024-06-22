; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; "aaaaaaaaaaaaaaaaaaaaa"; 
  mov b, _s0 ; "aaaaaaaaaaaaaaaaaaaaa"
  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_s_data: .db "Hello %s World", 0
_s: .dw _s_data
_s0: .db "aaaaaaaaaaaaaaaaaaaaa", 0
_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
