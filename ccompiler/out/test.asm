; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int i = 100; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000064
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int j = -200; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $000000c8
  neg b
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; printx16(i); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printx16
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
; --- START FUNCTION CALL
  mov b, _s0 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; printx16(j); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printx16
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
; --- START FUNCTION CALL
  mov b, _s0 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; printx32(i*j); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_0  
   neg a 
skip_invert_a_0:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_0  
   neg b 
skip_invert_b_0:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_0
  mov b, a
  mov a, g
  not a
  not b
  add b, 1
  adc a, 0
  mov c, a
  mov g, c
  mov a, b
_same_signs_0:
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
  call printx32
  add sp, 4
; --- END FUNCTION CALL
  syscall sys_terminate_proc

printx16:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d]
print_u16x_printx16:
  push bl
  mov bl, bh
  call _itoa_printx16        
  mov bl, al        
  mov al, 0
  syscall sys_io        
  mov ah, bl        
  mov al, 0
  syscall sys_io        
  pop bl
  call _itoa_printx16        
  mov bl, al        
  mov al, 0
  syscall sys_io        
  mov ah, bl        
  mov al, 0
  syscall sys_io        
; --- END INLINE ASM SEGMENT
; return; 
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_itoa_printx16:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits_printx16]
  mov ah, al
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits_printx16]
  pop b
  pop d
  ret
s_hex_digits_printx16:    .db "0123456789ABCDEF"  
; --- END INLINE ASM SEGMENT
  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
_puts_L1_print:
  mov al, [d]
  cmp al, 0
  jz _puts_END_print
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1_print
_puts_END_print:
; --- END INLINE ASM SEGMENT
  leave
  ret

printx32:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d+2]
  call print_u16x_printx32
  mov b, [d]
  call print_u16x_printx32
; --- END INLINE ASM SEGMENT
; return; 
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
print_u16x_printx32:
  push a
  push b
  push bl
  mov bl, bh
  call _itoa_printx32        
  mov bl, al        
  mov al, 0
  syscall sys_io        
  mov ah, bl        
  mov al, 0
  syscall sys_io        
  pop bl
  call _itoa_printx32        
  mov bl, al        
  mov al, 0
  syscall sys_io        
  mov ah, bl        
  mov al, 0
  syscall sys_io        
  pop b
  pop a
  ret
_itoa_printx32:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits_printx32]
  mov ah, al
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits_printx32]
  pop b
  pop d
  ret
s_hex_digits_printx32: .db "0123456789ABCDEF"  
; --- END INLINE ASM SEGMENT
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_s0: .db "\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
