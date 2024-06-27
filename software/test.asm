.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  call printnl

  mov b, $0
  mov c, $0
  mov a, $0
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl


  mov b, $FFFF
  mov c, $0
  mov a, $0
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl


  mov b, $0
  mov c, $FFFF
  mov a, $0
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl

  mov b, $0
  mov c, $0
  mov a, $FFFF
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl



  mov b, $0
  mov c, $0
  mov a, $0
  mov g, $FFFF
  sor32 ga, cb
  call print_u16x
  call printnl



  mov b, $0100
  mov c, $0
  mov a, $0
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl


  mov b, $0
  mov c, $0100
  mov a, $0
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl


  mov b, $0
  mov c, $0
  mov a, $0100
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl



  mov b, $0
  mov c, $0
  mov a, $0
  mov g, $0100
  sor32 ga, cb
  call print_u16x
  call printnl










  syscall sys_terminate_proc

.include "lib/stdio.asm"
.end
