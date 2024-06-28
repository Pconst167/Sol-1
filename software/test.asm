.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  call printnl
  call printnl


  mov a, $0
  mov g, $0
  mov c, $0
  mov b, $0
  sand32 ga, cb
  call print_u8x
  call printnl


  mov a, $1
  mov g, $0
  mov c, $0
  mov b, $0
  sand32 ga, cb
  call print_u8x
  call printnl


  mov a, $0
  mov g, $1
  mov c, $0
  mov b, $0
  sand32 ga, cb
  call print_u8x
  call printnl



  mov a, $0
  mov g, $0
  mov c, $1
  mov b, $0
  sand32 ga, cb
  call print_u8x
  call printnl


  mov a, $0
  mov g, $0
  mov c, $0
  mov b, $1
  sand32 ga, cb
  call print_u8x
  call printnl



  mov a, $1
  mov g, $0
  mov c, $1
  mov b, $0
  sand32 ga, cb
  call print_u8x
  call printnl


  mov a, $1
  mov g, $0
  mov c, $0
  mov b, $1
  sand32 ga, cb
  call print_u8x
  call printnl



  mov a, $0
  mov g, $1
  mov c, $1
  mov b, $0
  sand32 ga, cb
  call print_u8x
  call printnl



  mov a, $0
  mov g, $1
  mov c, $0
  mov b, $1
  sand32 ga, cb
  call print_u8x
  call printnl



  mov a, $1
  mov g, $1
  mov c, $0
  mov b, $0
  sand32 ga, cb
  call print_u8x
  call printnl



  mov a, $0
  mov g, $0
  mov c, $1
  mov b, $1
  sand32 ga, cb
  call print_u8x
  call printnl



  mov a, $1
  mov g, $1
  mov c, $1
  mov b, $1
  sand32 ga, cb
  call print_u8x
  call printnl





  syscall sys_terminate_proc


.include "lib/stdio.asm"
.end
