; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
;; print_unsigned_long(42672124L); 
  mov b, $1ffc
  mov c, $28b
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  push b
  call print_unsigned_long
  add sp, 4
  syscall sys_terminate_proc

print_unsigned_long:
  enter 0 ; (push bp; mov bp, sp)
; $p 
  sub sp, 2
;; p = &num; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $num
  mov b, d
  pop d
  mov [d], b
;; printx8(*p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call printx8
  add sp, 1
;; printx8(*(p+1)); 
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call printx8
  add sp, 1
;; printx8(*(p+2)); 
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call printx8
  add sp, 1
;; printx8(*(p+3)); 
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $3
  add a, b
  mov b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call printx8
  add sp, 1
  leave
  ret

printx8:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov bl, [d]
  call print_u8x
; --- END INLINE ASM BLOCK

  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov b, [d]
  call print_u16x
; --- END INLINE ASM BLOCK

  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM BLOCK

  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/asm/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
