#include <stdio.h>


void main(){
  char option;
  char byte;
  printf("Test of 5.25 inch Floppy Drive Interface.\n");

  asm{
    mov d, $FFC0    ; wd1770 data register
    mov al, 2       ; setparam call
    mov bl, $09     ; track 16
    syscall sys_system
  }


  for(;;){
    printf("\nOption: ");
    option = getchar();
    switch(option){
      case 'w':
        asm{
          mov d, $FFCB    ; wd1770 data register
          mov al, 2       ; setparam call
          mov bl, $10     ; track 16
          syscall sys_system
        }
        break;
      case 'd':
        asm{
          mov d, $FFCB    ; wd1770 data register
          mov al, 4       ; getparam call
          syscall sys_system
          ccmovd byte
          mov [d], bl
        }
          printf("\nData register value: %d\n", byte);
        break;
      case 't':
        asm{
          mov d, $FFC9    ; wd1770 track register
          mov al, 4       ; getparam call
          syscall sys_system
          ccmovd byte
          mov [d], bl
        }
          printf("\nTrack register value: %d\n", byte);
        break;
      case 's':
        asm{
          mov d, $FFC8    ; wd1770 command register
          mov al, 2       ; setparam call
          mov bl, $23     ; STEP command, 30ms rate
          syscall sys_system
        }
        break;
      case 'r':
        asm{
        ; send restore command
          mov d, $FFC8    ; wd1770
          mov al, 2       ; setparam call
          mov bl, $03     ; restore command, 30ms rate
          syscall sys_system
        }
        break;
      case 'i':
        asm{
        ; send step in command
          mov d, $FFC8    ; wd1770
          mov al, 2       ; setparam call
          mov bl, $43     ; step in command, 30ms rate
          syscall sys_system
        }
        break;
      case 'o':
        asm{
        ; send step out command
          mov d, $FFC8    ; wd1770
          mov al, 2       ; setparam call
          mov bl, $63     ; step out command, 30ms rate
          syscall sys_system
        }
        break;
    case 'e':
      return;
    }
  }
  
}

