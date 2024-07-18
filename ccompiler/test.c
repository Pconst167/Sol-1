#include <stdio.h>


void main(){
  hide_cursor(1);
  asm{
    mov c, 65535
    label:
      push c
  }
  
  move_cursor(10,10);

  asm{
      pop c
      mov b, c
      call print_u16x
      loopc label
  }
  hide_cursor(0);
  return;

  asm{
    .include "lib/asm/stdio.asm"
  }

/*
  for(i=0;i<65535;i++){
    move_cursor(10, 10);
    printf("%d", i);
  }
*/
}

