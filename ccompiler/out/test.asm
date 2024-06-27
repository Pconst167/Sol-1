; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; long int i, j; 
  sub sp, 4
  sub sp, 4
; i = 0xFFFFFFF0; 
  lea d, [bp + -3] ; $i
  push d
  mov b, 65520
  mov c, 65535
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; j = 0x00000001; 
  lea d, [bp + -7] ; $j
  push d
  mov b, $1
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
