; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
  sub sp, 2 ; i
  sub sp, 2 ; j
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $j
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2 ; k
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -5] ; $k
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
