.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  call printnl

00000000 00000000 10000000 00000010
  mov a, $8
  mov g, $2
  mov cl, 2
  shr32 ga
  mov b, g
  call print_u16x
  mov b, a
  call print_u16x
  call printnl





  syscall sys_terminate_proc

.include "lib/stdio.asm"
.end
