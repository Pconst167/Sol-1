; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; 10 * 5 % 49 == 1; 
  mov32 cb, $0000000a
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000005
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_3  
  neg a 
skip_invert_a_3:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_3  
  neg b 
skip_invert_b_3:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_3
  mov b, a
  mov a, g
  not a
  not b
  add b, 1
  adc a, 0
  mov g, a
  mov a, b
_same_signs_3:
  mov32 cb, $00000031
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000001
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
