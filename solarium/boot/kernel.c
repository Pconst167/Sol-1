#include <stdio.h>

_system{
; ------------------------------------------------------------------------------------------------------------------;
; Solarium - Sol-1 Homebrew Minicomputer Operating System Kernel.
; ------------------------------------------------------------------------------------------------------------------;
; Memory Map
; ------------------------------------------------------------------------------------------------------------------;
; 0000    ROM BEGIN
; ....
; 7FFF    ROM END
;
; 8000    RAM begin
; ....
; F7FF    Stack root
; ------------------------------------------------------------------------------------------------------------------;
; I/O MAP
; ------------------------------------------------------------------------------------------------------------------;
; FF80    UART 0    (16550)
; FF90    UART 1    (16550)
; FFA0    RTC       (M48T02)
; FFB0    PIO 0     (8255)
; FFC0    PIO 1     (8255)
; FFD0    IDE       (Compact Flash / PATA)
; FFE0    Timer     (8253)
; FFF0    BIOS CONFIGURATION NV-RAM STORE AREA
; ------------------------------------------------------------------------------------------------------------------;

; ------------------------------------------------------------------------------------------------------------------;
; System Constants
; ------------------------------------------------------------------------------------------------------------------;
_UART0_DATA       .equ $FF80            ; data
_UART0_DLAB_0     .equ $FF80            ; divisor latch low byte
_UART0_DLAB_1     .equ $FF81            ; divisor latch high byte
_UART0_IER        .equ $FF81            ; Interrupt enable register
_UART0_FCR        .equ $FF82            ; FIFO control register
_UART0_LCR        .equ $FF83            ; line control register
_UART0_LSR        .equ $FF85            ; line status register

_UART1_DATA       .equ $FF90            ; data
_UART1_DLAB_0     .equ $FF90            ; divisor latch low byte
_UART1_DLAB_1     .equ $FF91            ; divisor latch high byte
_UART1_IER        .equ $FF91            ; Interrupt enable register
_UART1_FCR        .equ $FF92            ; FIFO control register
_UART1_LCR        .equ $FF93            ; line control register
_UART1_LSR        .equ $FF95            ; line status register

XON               .equ $11
XOFF              .equ $13

_ide_BASE         .equ $FFD0            ; IDE BASE
_ide_R0           .equ _ide_BASE + 0    ; DATA PORT
_ide_R1           .equ _ide_BASE + 1    ; READ: ERROR CODE, WRITE: FEATURE
_ide_R2           .equ _ide_BASE + 2    ; NUMBER OF SECTORS TO TRANSFER
_ide_R3           .equ _ide_BASE + 3    ; SECTOR ADDRESS LBA 0 [0:7]
_ide_R4           .equ _ide_BASE + 4    ; SECTOR ADDRESS LBA 1 [8:15]
_ide_R5           .equ _ide_BASE + 5    ; SECTOR ADDRESS LBA 2 [16:23]
_ide_R6           .equ _ide_BASE + 6    ; SECTOR ADDRESS LBA 3 [24:27 (LSB)]
_ide_R7           .equ _ide_BASE + 7    ; READ: STATUS, WRITE: COMMAND

_7SEG_DISPLAY     .equ $FFB0            ; BIOS POST CODE HEX DISPLAY (2 DIGITS) (CONNECTED TO PIO A)
_BIOS_POST_CTRL   .equ $FFB3            ; BIOS POST DISPLAY CONTROL REGISTER, 80h = As Output
_PIO_A            .equ $FFB0    
_PIO_B            .equ $FFB1
_PIO_C            .equ $FFB2
_PIO_CONTROL      .equ $FFB3            ; PIO CONTROL PORT

_TIMER_C_0        .equ $FFE0            ; TIMER COUNTER 0
_TIMER_C_1        .equ $FFE1            ; TIMER COUNTER 1
_TIMER_C_2        .equ $FFE2            ; TIMER COUNTER 2
_TIMER_CTRL       .equ $FFE3            ; TIMER CONTROL REGISTER

STACK_BEGIN       .equ $F7FF            ; beginning of stack
FIFO_SIZE         .equ 1024

text_org          .equ $400
; ------------------------------------------------------------------------------------------------------------------;


; For the next iteration:
; boot-sector(1) | kernel-sectors(32) | inode-bitmap | rawdata-bitmap | inode-table | raw-disk-data
; inode-table format:
;  file-type(f, d)
;  permissons
;  link-count
;  filesize
;  time-stamps
;  15 data block pointers
;  single-indirect pointer

; FILE ENTRY ATTRIBUTES
; filename (24)
; attributes (1)       :|0|0|file_type(3bits)|x|w|r|
; LBA (2)              : location of raw data for file entry, or dirID for directory entry
; size (2)             : filesize
; day (1)           
; month (1)
; year (1)
; packet size = 32 bytes  : total packet size in bytes

FST_ENTRY_SIZE          .equ 32  ; bytes
FST_FILES_PER_SECT      .equ (512 / FST_ENTRY_SIZE)
FST_FILES_PER_DIR       .equ (512 / FST_ENTRY_SIZE)
FST_NBR_DIRECTORIES     .equ 64
                        ; 1 sector for header, the rest is for the list of files/dirs
FST_SECTORS_PER_DIR     .equ (1 + (FST_ENTRY_SIZE * FST_FILES_PER_DIR / 512))    
FST_TOTAL_SECTORS       .equ (FST_SECTORS_PER_DIR * FST_NBR_DIRECTORIES)
FST_LBA_START           .equ 32
FST_LBA_END             .equ (FST_LBA_START + FST_TOTAL_SECTORS - 1)

FS_NBR_FILES            .equ (FST_NBR_DIRECTORIES * FST_FILES_PER_DIR)
FS_SECTORS_PER_FILE     .equ 32         ; the first sector is always a header with a NULL parameter (first byte)
                                        ; so that we know which blocks are free or taken
FS_FILE_SIZE            .equ (FS_SECTORS_PER_FILE * 512)                  
FS_TOTAL_SECTORS        .equ (FS_NBR_FILES * FS_SECTORS_PER_FILE)
FS_LBA_START            .equ (FST_LBA_END + 1)
FS_LBA_END              .equ (FS_LBA_START + FS_NBR_FILES - 1)

root_id:                .equ FST_LBA_START

; ------------------------------------------------------------------------------------------------------------------;
; GLOBAL SYSTEM VARIABLES
; ------------------------------------------------------------------------------------------------------------------;

; ------------------------------------------------------------------------------------------------------------------;
; IRQ Table
; Highest priority at lowest address
; ------------------------------------------------------------------------------------------------------------------;
.dw int_0
.dw int_1
.dw int_2
.dw int_3
.dw int_4
.dw int_5
.dw int_6
.dw int_7

; ------------------------------------------------------------------------------------------------------------------;
; Reset Vector
; ------------------------------------------------------------------------------------------------------------------;
.dw main

; ------------------------------------------------------------------------------------------------------------------;
; Exception Vector Table
; Total of 7 entries, starting at address $0012
; ------------------------------------------------------------------------------------------------------------------;
.dw trap_privilege
.dw trap_div_zero
.dw trap_undef_opcode
.dw 0
.dw 0
.dw 0
.dw 0

; ------------------------------------------------------------------------------------------------------------------;
; System Call Vector Table
; Starts at address $0020
; ------------------------------------------------------------------------------------------------------------------;
.dw syscall_break
.dw syscall_rtc
.dw syscall_ide
.dw syscall_io
.dw syscall_file_system
.dw syscall_create_proc
.dw syscall_list_procs
.dw syscall_datetime
.dw syscall_reboot
.dw syscall_pause_proc
.dw syscall_resume_proc
.dw syscall_terminate_proc
.dw syscall_system            

; ------------------------------------------------------------------------------------------------------------------;
; System Call Aliases
; ------------------------------------------------------------------------------------------------------------------;
sys_break            .equ 0
sys_rtc              .equ 1
sys_ide              .equ 2
sys_io               .equ 3
sys_filesystem       .equ 4
sys_create_proc      .equ 5
sys_list_proc        .equ 6
sys_datetime         .equ 7
sys_reboot           .equ 8
sys_pause_proc       .equ 9
sys_resume_proc      .equ 10
sys_terminate_proc   .equ 11
sys_system           .equ 12

; ------------------------------------------------------------------------------------------------------------------
; Alias Exports
; ------------------------------------------------------------------------------------------------------------------
.export text_org
.export sys_break
.export sys_rtc
.export sys_ide
.export sys_io
.export sys_filesystem
.export sys_create_proc
.export sys_list_proc
.export sys_datetime
.export sys_reboot
.export sys_pause_proc
.export sys_resume_proc
.export sys_terminate_proc
.export sys_system

}


void int_0(){

}
void int_1(){

}
void int_2(){

}
void int_3(){

}
void int_4(){

}
void int_5(){

}

void int_6(){
  // Process Swapping
  asm{
    pusha ; save all registers into kernel stack
    mov ah, 0
    mov al, [active_proc_index]
    shl a              ; x2
    mov a, [proc_table_convert + a]  ; get process state start index
    mov di, a
    mov a, sp
    inc a
    mov si, a
    mov c, 20
    rep movsb          ; save process state!
  ; restore kernel stack position to point before interrupt arrived
    add sp, 20
  ; now load next process in queue
    mov al, [active_proc_index]
    mov bl, [nbr_active_procs]
    cmp al, bl
    je int6_cycle_back
    inc al            ; next process is next in the series
    jmp int6_continue
  int6_cycle_back:
    mov al, 1        ; next process = process 1
  int6_continue:
    mov [active_proc_index], al    ; set next active proc

  ; calculate LUT entry for next process
    mov ah, 0
    shl a              ; x2
    mov a, [proc_table_convert + a]    ; get process state start index  
    
    mov si, a            ; source is proc state block
    mov a, sp
    sub a, 19
    mov di, a            ; destination is kernel stack
  ; restore SP
    dec a
    mov sp, a
    mov c, 20
    rep movsb
  ; set VM process
    mov al, [active_proc_index]
    setptb
    mov byte[_TIMER_C_0], 0        ; load counter 0 low byte
    mov byte[_TIMER_C_0], $10        ; load counter 0 high byte
    popa
    sysret

    proc_table_convert:
      .dw proc_state_table + 0
      .dw proc_state_table + 20
      .dw proc_state_table + 40
      .dw proc_state_table + 60
      .dw proc_state_table + 80
      .dw proc_state_table + 100
      .dw proc_state_table + 120
      .dw proc_state_table + 140
  }
}

void int_7(){
// UART0 Interrupt
  asm{
    push a
    push d
    pushf
    mov a, [fifo_in]
    mov d, a
    mov al, [_UART0_DATA]  ; get character
    cmp al, $03        ; CTRL-C
    je CTRLC
    cmp al, $1A        ; CTRL-Z
    je CTRLZ
    mov [d], al        ; add to fifo
    mov a, [fifo_in]
    inc a
    cmp a, fifo + FIFO_SIZE         ; check if pointer reached the end of the fifo
    jne int_7_continue
    mov a, fifo  
  int_7_continue:  
    mov [fifo_in], a      ; update fifo pointer
    popf
    pop d
    pop a  
    sysret
  CTRLC:
    add sp, 5
    jmp syscall_terminate_proc
  CTRLZ:
    popf
    pop d
    pop a
    jmp syscall_pause_proc    ; pause current process and go back to the shell
  }
}


void syscall_break(void){

}
void syscall_rtc(void){

}
void syscall_ide(void){

}
void syscall_io(void){

}
void syscall_file_system(void){

}
void syscall_create_proc(void){

}
void syscall_list_procs(void){

}
void syscall_datetime(void){

}
void syscall_reboot(void){

}
void syscall_pause_proc(void){

}
void syscall_resume_proc(void){

}
void syscall_terminate_proc(void){

}
void syscall_system(void){

}

void trap_privilege(){
  asm{
    jmp syscall_reboot
    push word s_priviledge
    call puts
    sysret

    s_priviledge: .db "\nexception: privilege\n", 0
  }
}


void trap_div_zero(){
  asm{
    push a
    push d
    pushf
    push word s_divzero
    call puts
    popf
    pop d
    pop a
    sysret ; enable interrupts

    s_divzero: .db "\nexception: zero division\n", 0
  }
}

void trap_undef_opcode(){

}


static void main(){

  puts("");    
  printf("Hello World"
      "My name is Sol-1"
      "And this is a multi-line string"
  );


}