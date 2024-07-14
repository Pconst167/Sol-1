; --- FILENAME: ../solarium/boot/kernel.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
; --- BEGIN SYSTEM SEGMENT
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
FS_SECTORS_PER_FILE     .equ 32         ; the first sector is always a header with a  0     parameter (first byte)
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
; --- END SYSTEM SEGMENT

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
<<<<<<< HEAD
; unsigned long int i = 0; 
  sub sp, 4
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
; --- END LOCAL VAR INITIALIZATION
; for(i=0; i < 4294967295; i++){ 
_for1_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
_for1_cond:
  lea d, [bp + -3] ; $i
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $ffffffff
  cmp32 ga, cb
  slu ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
; printx32(i); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $i
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call printx32
  add sp, 4
; --- END FUNCTION CALL
; puts(""); 
; --- START FUNCTION CALL
  mov b, _s0 ; ""
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_for1_update:
  lea d, [bp + -3] ; $i
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov32 ga, 1
  add32 cb, ga
  lea d, [bp + -3] ; $i
  mov b, c
  mov [d+2], b
  mov [d], b
  mov g, c
  mov a, b
  mov32 cb, 1
  sub32 ga, cb
  mov c, g
  mov b, a
  jmp _for1_cond
_for1_exit:
  syscall sys_terminate_proc

printx32:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d+2]
  call print_u16x_printx32
  mov b, [d]
  call print_u16x_printx32
; --- END INLINE ASM SEGMENT
; return; 
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
print_u16x_printx32:
  push a
  push b
  push bl
  mov bl, bh
  call _itoa_printx32        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop bl
  call _itoa_printx32        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop b
  pop a
  ret
_itoa_printx32:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits_printx32]
  mov ah, al
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits_printx32]
  pop b
  pop d
  ret
s_hex_digits_printx32: .db "0123456789ABCDEF"  
; --- END INLINE ASM SEGMENT
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
_puts_L1_puts:
  mov al, [d]
  cmp al, 0
  jz _puts_END_puts
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1_puts
_puts_END_puts:
  mov a, $0A00
  syscall sys_io
; --- END INLINE ASM SEGMENT
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_s0: .db "", 0
=======
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
>>>>>>> 1de28e44daa3a3690887102723661165cafdaccd

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
