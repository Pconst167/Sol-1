; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; for(unsigned int i = 0; i < 100; i++){ 
_for1_init:
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
_for1_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; --- START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
_for1_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  dec b
  jmp _for1_cond
_for1_exit:
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
