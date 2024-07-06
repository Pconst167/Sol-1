; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; struct s1 mys2 = mys1; 
  sub sp, 7
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -6] ; $mys2
  push d
               
  mov d, _mys1_data ; $mys1
  mov b, d
  mov c, 0
  pop d
  mov si, b
  mov di, d
  mov c, 7
  rep movsb
; --- END LOCAL VAR INITIALIZATION
; "hello world"   ; 
               
  mov b, _s0 ; "hello world"
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_mys1_data: .fill 7, 0
_s0: .db "hello world", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
