.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF



  mov a, $1
  mov g, $0
  mov c, $8000
  mov b, $2000

  sand32 ga, cb

  call print_u8x


  syscall sys_terminate_proc

.include "lib/stdio.asm"
.end
