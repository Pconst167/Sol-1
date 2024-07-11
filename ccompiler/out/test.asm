; --- FILENAME: test.c

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; "Hello World" 
  mov b, _s0 ; "Hello WorldMy name is Sol-1And this is a multi-line string"
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_s0: .db "Hello WorldMy name is Sol-1And this is a multi-line string", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
