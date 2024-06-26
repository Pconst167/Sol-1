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


  mov b, $1
  mov c, $0
  mov a, $0
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl


  mov b, $0
  mov c, $1
  mov a, $0
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl

  mov b, $0
  mov c, $0
  mov a, $1
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl



  mov b, $0
  mov c, $0
  mov a, $0
  mov g, $1
  sor32 ga, cb
  call print_u16x
  call printnl



  mov b, $00010000
  mov c, $0
  mov a, $0
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl


  mov b, $0
  mov c, $00010000
  mov a, $0
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl


  mov b, $0
  mov c, $0
  mov a, $00010000
  mov g, $0
  sor32 ga, cb
  call print_u16x
  call printnl



  mov b, $0
  mov c, $0
  mov a, $0
  mov g, $00010000
  sor32 ga, cb
  call print_u16x
  call printnl










  syscall sys_terminate_proc

.include "lib/stdio.asm"
.end
