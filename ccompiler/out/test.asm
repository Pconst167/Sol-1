; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; unsigned long int i = 0; 
  sub sp, 4
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
; --- END LOCAL VAR INITIALIZATION
; for(i=0; i < 4294967295; i++){ 
_for1_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
_for1_cond:
  lea d, [bp + -3] ; $i
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $ffffffff
  cmp32 ga, cb
  slu ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
; printx32(i); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $i
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call printx32
  add sp, 4
; --- END FUNCTION CALL
; puts(""); 
; --- START FUNCTION CALL
  mov b, _s0 ; ""
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_for1_update:
  lea d, [bp + -3] ; $i
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov32 ga, 1
  add32 cb, ga
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, c
  mov [d+2], b
  mov32 cb, 1
  sub32 ga, cb
  mov c, g
  mov b, a
  jmp _for1_cond
_for1_exit:
  syscall sys_terminate_proc

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
  call _itoa_printx32        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop bl
  call _itoa_printx32        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
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

puts:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
_puts_L1_puts:
  mov al, [d]
  cmp al, 0
  jz _puts_END_puts
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1_puts
_puts_END_puts:
  mov a, $0A00
  syscall sys_io
; --- END INLINE ASM SEGMENT
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_string: .fill 2, 0
_s0: .db "", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
