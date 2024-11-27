
.include "lib/kernel.exp"
.org text_org

main:
  mov bp, $FFFF
  mov sp, $FFFF

  mov a, 65535
  mov b, 32767
  div a, b

  call print_u16d


  syscall sys_terminate_proc


.include "lib/stdio.asm"
.end

