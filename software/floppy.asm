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


  mov d, str0
  call _puts
  ; First, select drive 1 and de-select drive 0
  mov d, $FFC0    ; floppy configuration output port
  mov al, 2       ; setparam call
  mov bl, $09     ; %00001001 : turn LED on, disable double density, select side 0, select drive 1, do not select drive 0
  syscall sys_system

  mov d, str1
  call _puts
; wait a little
  mov c, $FF
loop1:
  dec c
  cmp c, 0
  jnz loop1

  mov d, str2
  call _puts
; send restore command
  mov d, $FFC8    ; wd1770
  mov al, 2       ; setparam call
  mov bl, $03     ; restore command, 30ms rate
  syscall sys_system


  mov d, str1
  call _puts
; wait a little
  mov c, $FF
loop2:
  dec c
  cmp c, 0
  jnz loop2

  mov d, $FFC1    ; floppy input port
  mov al, 4       ; getparam
  syscall sys_system
  mov d, str3
  call _puts
  call print_u8x  ; print vlue in 'bl'
  call printnl


  


  syscall sys_terminate_proc

str0: .db $a, $d, "selecting drive 1...", $a, $d, 0
str1: .db $a, $d, "waiting...", $a, $d, 0
str2: .db $a, $d, "sending restore command...", $a, $d, 0
str3: .db $a, $d, "floppy status register: ", 0

.include "lib/stdio.asm"
.end
