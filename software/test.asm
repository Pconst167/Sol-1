.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  call printnl
  call printnl


  mov a, $FFFF
  mov b, $123
  cmp a, b



  slt
  call print_u8x
  call printnl





  syscall sys_terminate_proc


.include "lib/stdio.asm"
.end
