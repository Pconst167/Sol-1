.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
; FFC0    5.25" Floppy Drive Block
;   - FFC0  (Last 4 bits: 0000)    Output Port (377 Flip-Flop)                       Note: A3 Address line is 0
;   - FFC1  (Last 4 bits: 0001)    Input Port  (244 Buffer)                          Note: A3 Address line is 0
;   - FFC8  (Last 4 bits: 1000)    FDC         (WD1770 Floppy Drive Controller)      Note: A3 Address line is 1
main:
  mov bp, $FFFF
  mov sp, $FFFF


  ; First, select drive 1 and de-select drive 0
  mov d, $FFC0
  mov al, $09
  mov [d], al ; %00001001 : turn LED on, disable double density, select side 0, select drive 1, do not select drive 0



;  mov d, $FFC8
;  mov al, 0       ; restore command
;  mov [d], al       ; send command
  

  syscall sys_terminate_proc


.include "lib/stdio.asm"
.end
