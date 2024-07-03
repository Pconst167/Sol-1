.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  mov32 cb, $00010000
  mov a, c
  not a
  not b
  add b, 1
  adc a, 0
  mov c, a
  mov g, c
  mov a, b

  mov32 cb, $FFFF0000
  cmp32 ga, cb
  seq ; ==

  call print_u8x

  syscall sys_terminate_proc


.include "lib/stdio.asm"
.end
