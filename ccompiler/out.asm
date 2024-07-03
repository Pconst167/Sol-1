; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; long int i = -100; 
  sub sp, 4
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000064
  neg b
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; long int j = 200; 
  sub sp, 4
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -7] ; $j
  push d
  mov32 cb, $000000c8
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; print_signed_long(i*j); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $i
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $j
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_4  
   neg a 
skip_invert_a_4:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_4  
   neg b 
skip_invert_b_4:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_4
  mov b, a
  mov a, g
  not a
  not b
  add b, 1
  adc a, 0
  mov c, a
  mov g, c
  mov a, b
_same_signs_4:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_signed_long
  add sp, 4
; --- END FUNCTION CALL
  syscall sys_terminate_proc

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10]; 
  sub sp, 10
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if5_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  cmp32 ga, cb
  slt ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if5_else
_if5_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  not a
  not b
  add b, 1
  adc a, 0
  mov c, a
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if5_exit
_if5_else:
; if (num == 0) { 
_if6_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if6_exit
_if6_exit:
_if5_exit:
; while (num > 0) { 
_while7_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  cmp32 ga, cb
  sgt
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while7_exit
_while7_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  div a, b ; 
  mov a, b
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  div a, b
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  jmp _while7_cond
_while7_exit:
; while (i > 0) { 
_while14_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while14_exit
_while14_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while14_cond
_while14_exit:
  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  mov al, 0
  syscall sys_io      
; --- END INLINE ASM SEGMENT
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
