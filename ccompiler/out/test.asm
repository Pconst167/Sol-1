; --- FILENAME: test
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
fopen:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_ff_data: .fill 518, 0
st_fopen_fp_dt: .fill 2, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
