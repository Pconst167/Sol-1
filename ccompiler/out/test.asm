; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $i 
  mov a, $0
  mov [bp + -1], a
  sub sp, 2
;; label: 
main_label:
;; i++; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
;; if(i >= 100) goto label; 
_if1_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if1_else
_if1_true:
;; goto label; 
  jmp main_label
  jmp _if1_exit
_if1_else:
;; goto label; 
  jmp main_label
_if1_exit:
;; exit: 
main_exit:
;; return; 
  leave
  syscall sys_terminate_proc
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_l_data: .fill 1060, 0
_p: .fill 2, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
