; --- FILENAME: test.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; static char m2[10] = {1, 2, 3, {1, 2, 3}, 1, {1, 2, 3}}; 
  sub sp, 10
; m2[1]; 
  mov d, st_main_m2_dt ; static m2
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_m_data:
.db $01,$02,$03,$01,$02,$03,$01,$01,$02,$03,
st_main_m2_dt: 
.db 1,2,3,1,2,3,1,1,2,3,
_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
