.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  call printnl
  call printnl


  mov cl, 1
  mov ga, $FFFFFFFF
  shl32 ga, cl

  mov b, g
  call print_u16x
  mov b, a
  call print_u16x

  call printnl



  syscall sys_terminate_proc


.include "lib/stdio.asm"
.end
