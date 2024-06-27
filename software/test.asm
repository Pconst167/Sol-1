.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF



  mov a, $FFF0
  mov g, $FFFF
  mov c, $0
  mov b, $1

  add32 cb, ga

  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x


  syscall sys_terminate_proc

.include "lib/stdio.asm"
.end
