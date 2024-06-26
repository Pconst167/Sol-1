.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  call printnl


  mov a, $0
  mov g, $0
  mov b, $0
  mov c, $0
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl



  mov a, $1
  mov g, $0
  mov b, $0
  mov c, $0
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl



  mov a, $0
  mov g, $1
  mov b, $0
  mov c, $0
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl


  mov a, $0
  mov g, $0
  mov b, $1
  mov c, $0
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl



  mov a, $0
  mov g, $0
  mov b, $0
  mov c, $1
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl



  mov a, $1
  mov g, $0
  mov b, $1
  mov c, $0
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl



; ga + cb 
  mov a, $0
  mov g, $1
  mov b, $1
  mov c, $0
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl


; ga + cb 
  mov a, $1
  mov g, $0
  mov b, $FFFF
  mov c, $FFFF
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl



; ga + cb 
  mov a, $1
  mov g, $0
  mov b, $FFFF
  mov c, $1
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl


; ga + cb 
  mov a, $123
  mov g, $45
  mov b, $123
  mov c, $F32
  sub32 cb, ga
  push b
  mov b, c
  call print_u16x
  pop b
  call print_u16x
  call printnl



  syscall sys_terminate_proc

.include "lib/stdio.asm"
.end
