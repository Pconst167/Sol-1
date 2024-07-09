; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int j; 
  sub sp, 2
; int i = j; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
