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
; --- END SYSTEM SEGMENT

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; puts("");     
; --- START FUNCTION CALL
  mov b, _s0 ; ""
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; printf("Hello World" 
; --- START FUNCTION CALL
  mov b, _s0 ; "Hello WorldMy name is Sol-1And this is a multi-line string"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  syscall sys_terminate_proc

int_0:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

int_1:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

int_2:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

int_3:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

int_4:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

int_5:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

int_6:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
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
; --- END INLINE ASM SEGMENT
  leave
  ret

int_7:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
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
; --- END INLINE ASM SEGMENT
  leave
  ret

syscall_break:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_rtc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_ide:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_io:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_file_system:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_create_proc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_list_procs:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_datetime:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_reboot:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_pause_proc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_resume_proc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_terminate_proc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

syscall_system:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

trap_privilege:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  jmp syscall_reboot
  push word s_priviledge
  call puts
  sysret
s_priviledge: .db "\nexception: privilege\n", 0
; --- END INLINE ASM SEGMENT
  leave
  ret

trap_div_zero:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
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
; --- END INLINE ASM SEGMENT
  leave
  ret

trap_undef_opcode:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

system_jmptbl:
  enter 0 ; (push bp; mov bp, sp)
; char code; 
  sub sp, 1
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 0] ; $code
  mov [d], al
; --- END INLINE ASM SEGMENT
; switch(code){ 
_switch1_expr:
  lea d, [bp + 0] ; $code
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch1_comparisons:
  cmp b, 0
  je _switch1_case0
  cmp b, 1
  je _switch1_case1
  cmp b, 2
  je _switch1_case2
  cmp b, 3
  je _switch1_case3
  cmp b, 4
  je _switch1_case4
  jmp _switch1_exit
_switch1_case0:
; system_uname(); 
; --- START FUNCTION CALL
  call system_uname
; break; 
  jmp _switch1_exit ; case break
_switch1_case1:
; system_whoami(); 
; --- START FUNCTION CALL
  call system_whoami
; break; 
  jmp _switch1_exit ; case break
_switch1_case2:
; system_setparam(); 
; --- START FUNCTION CALL
  call system_setparam
; break; 
  jmp _switch1_exit ; case break
_switch1_case3:
; system_bootloader_install(); 
; --- START FUNCTION CALL
  call system_bootloader_install
; break; 
  jmp _switch1_exit ; case break
_switch1_case4:
; system_getparam(); 
; --- START FUNCTION CALL
  call system_getparam
; break; 
  jmp _switch1_exit ; case break
_switch1_exit:
  leave
  ret

system_getparam:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  mov bl, [d]
  sysret
; --- END INLINE ASM SEGMENT
  leave
  ret

system_bootloader_install:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  push b
  mov b, 0
  mov c, 0
  mov ah, $01                 ; 1 sector
  mov d, transient_area
  call ide_read_sect          ; read sector
  pop b
  mov [d + 510], b            ; update LBA address
  mov b, 0
  mov c, 0
  mov ah, $01                 ; 1 sector
  mov d, transient_area
  call ide_write_sect         ; write sector
  sysret
; --- END INLINE ASM SEGMENT
  leave
  ret

system_setparam:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  mov [d], bl
  sysret
; --- END INLINE ASM SEGMENT
  leave
  ret

system_uname:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  sysret
; --- END INLINE ASM SEGMENT
  leave
  ret

system_whoami:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  sysret
; --- END INLINE ASM SEGMENT
  leave
  ret

syscall_reboot:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  push word $FFFF 
  push byte %00000000             ; dma_ack = 0, interrupts disabled, mode = supervisor, paging = off, halt=0, display_reg_load=0, dir=0
  push word BIOS_RESET_VECTOR    ; and then push RESET VECTOR of the shell to the stack
  sysret
; --- END INLINE ASM SEGMENT
  leave
  ret

syscall_resume_proc:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  mov g, a                            ; save the process number
  pusha                               ; save all registers into kernel stack
  mov ah, 0
  mov al, [active_proc_index]
  shl a              ; x2
  mov a, [proc_table_convert + a]     ; get process state start index
  mov di, a
  mov a, sp
  inc a
  mov si, a
  mov c, 20
  rep movsb                           ; save process state!
  ; restore kernel stack position to point before interrupt arrived
  add sp, 20
  ; now load the new process number!
  mov a, g                            ; retrieve the process number argument that was saved in the beginning
  mov [active_proc_index], al         ; set new active proc
  ; calculate LUT entry for next process
  mov ah, 0
  shl a                               ; x2
  mov a, [proc_table_convert + a]     ; get process state start index  
  mov si, a                           ; source is proc state block
  mov a, sp
  sub a, 19
  mov di, a                           ; destination is kernel stack
  ; restore SP
  dec a
  mov sp, a
  mov c, 20
  rep movsb
  ; set VM process
  mov al, [active_proc_index]
  setptb
  popa
  sysret
; --- END INLINE ASM SEGMENT
  leave
  ret

syscall_list_procs:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  mov d, s_ps_header
  call _puts
  mov d, proc_availab_table + 1
  mov c, 1
list_procs_L0:  
  cmp byte[d], 1
  jne list_procs_next
  mov b, d
  sub b, proc_availab_table
  shl b, 5
  push d
  push b
  mov b, c
  call print_u8x
  mov ah, ' '
  call _putchar
  call _putchar
  pop b
  mov d, b
  add d, proc_names
  call _puts
  call printnl
  pop d
list_procs_next:
  inc d
  inc c
  cmp c, 9
  jne list_procs_L0
list_procs_end:
  sysret
; --- END INLINE ASM SEGMENT
  leave
  ret

syscall_break:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  pusha
syscall_break_prompt:
  mov d, s_break1
  call _puts
  call printnl
  call scan_u16d
  cmp a, 0
  je syscall_break_regs
  cmp a, 1
  je syscall_break_mem
syscall_break_end:  
  popa
  sysret
syscall_break_regs:
  mov a, sp
  add a, 14               ; back-track 7 registers
  mov d, a
  mov cl, 7
syscall_regs_L0:
  mov b, [d]
  swp b
  call print_u16x         ; print register value
  call printnl
  sub d, 2
  sub cl, 1
  cmp cl, 0
  jne syscall_regs_L0
  jmp syscall_break_prompt
  call printnl
  jmp syscall_break_prompt
syscall_break_mem:
  call printnl
  call scan_u16x
  mov si, a               ; data source from user space
  mov di, scrap_sector    ; destination in kernel space
  mov c, 512
  load                    ; transfer data to kernel space!
  mov d, scrap_sector     ; dump pointer in d
  mov c, 0
dump_loop:
  mov al, cl
  and al, $0F
  jz print_base
back:
  mov al, [d]             ; read byte
  mov bl, al
  call print_u8x
  mov a, $2000
  syscall sys_io          ; space
  mov al, cl
  and al, $0F
  cmp al, $0F
  je print_ascii
back1:
  inc d
  inc c
  cmp c, 512
  jne dump_loop
  call printnl
  jmp syscall_break_prompt  ; go to syscall_break return point
print_ascii:
  mov a, $2000
  syscall sys_io
  sub d, 16
  mov b, 16
print_ascii_L:
  inc d
  mov al, [d]               ; read byte
  cmp al, $20
  jlu dot
  cmp al, $7E
  jleu ascii
dot:
  mov a, $2E00
  syscall sys_io
  jmp ascii_continue
ascii:
  mov ah, al
  mov al, 0
  syscall sys_io
ascii_continue:
  loopb print_ascii_L
  jmp back1
print_base:
  call printnl
  mov b, d
  sub b, scrap_sector      ; remove this later and fix address bases which display incorrectly
  call print_u16x          ; display row
  mov a, $3A00
  syscall sys_io
  mov a, $2000
  syscall sys_io
  jmp back
s_break1:  
.db "\nDebugger entry point.\n"
.db "0. Show Registers\n"
.db "1. Show 512B RAM block\n"
.db "2. Continue Execution", 0
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

printf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 2
  sub sp, 2
; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for2_init:
_for2_cond:
_for2_block:
; if(!*format_p) break; 
_if3_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if3_else
_if3_TRUE:
; break; 
  jmp _for2_exit ; for break
  jmp _if3_exit
_if3_else:
; if(*format_p == '%'){ 
_if4_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000025
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if4_else
_if4_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch5_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch5_comparisons:
  cmp bl, $6c
  je _switch5_case0
  cmp bl, $4c
  je _switch5_case1
  cmp bl, $64
  je _switch5_case2
  cmp bl, $69
  je _switch5_case3
  cmp bl, $75
  je _switch5_case4
  cmp bl, $78
  je _switch5_case5
  cmp bl, $63
  je _switch5_case6
  cmp bl, $73
  je _switch5_case7
  jmp _switch5_default
  jmp _switch5_exit
_switch5_case0:
_switch5_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if6_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000069
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if6_else
_if6_TRUE:
; print_signed_long(*(long *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_signed_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if6_exit
_if6_else:
; if(*format_p == 'u') 
_if7_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000075
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if7_else
_if7_TRUE:
; print_unsigned_long(*(unsigned long *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_unsigned_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if7_exit
_if7_else:
; if(*format_p == 'x') 
_if8_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000078
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if8_else
_if8_TRUE:
; printx32(*(long int *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
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
  jmp _if8_exit
_if8_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s1 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if8_exit:
_if7_exit:
_if6_exit:
; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000004
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch5_exit ; case break
_switch5_case2:
_switch5_case3:
; print_signed(*(int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print_signed
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch5_exit ; case break
_switch5_case4:
; print_unsigned(*(unsigned int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch5_exit ; case break
_switch5_case5:
; printx16(*(int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printx16
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch5_exit ; case break
_switch5_case6:
; putchar(*(char*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch5_exit ; case break
_switch5_case7:
; print(*(char**)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch5_exit ; case break
_switch5_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch5_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if4_exit
_if4_else:
; putchar(*format_p); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_if4_exit:
_if3_exit:
_for2_update:
  jmp _for2_cond
_for2_exit:
  leave
  ret

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10]; 
  sub sp, 10
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if9_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  cmp32 ga, cb
  slt ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if9_else
_if9_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  not a
  not b
  add b, 1
  adc a, 0
  mov c, a
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if9_exit
_if9_else:
; if (num == 0) { 
_if10_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if10_exit
_if10_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if10_exit
_if10_exit:
_if9_exit:
; while (num > 0) { 
_while11_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  cmp32 ga, cb
  sgt
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while11_exit
_while11_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  jmp _while11_cond
_while11_exit:
; while (i > 0) { 
_while18_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while18_exit
_while18_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while18_cond
_while18_exit:
  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  mov al, 0
  syscall sys_io      ; char in AH
; --- END INLINE ASM SEGMENT
  leave
  ret

print_unsigned_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10]; 
  sub sp, 10
; int i; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -11] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; if(num == 0){ 
_if19_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_exit
_if19_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if19_exit
_if19_exit:
; while (num > 0) { 
_while20_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  cmp32 ga, cb
  sgu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while20_exit
_while20_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  jmp _while20_cond
_while20_exit:
; while (i > 0) { 
_while27_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while27_exit
_while27_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while27_cond
_while27_exit:
  leave
  ret

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

err:
  enter 0 ; (push bp; mov bp, sp)
; print(e); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $e
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
_puts_L1_print:
  mov al, [d]
  cmp al, 0
  jz _puts_END_print
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1_print
_puts_END_print:
; --- END INLINE ASM SEGMENT
  leave
  ret

print_signed:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -6] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if28_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if28_else
_if28_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  neg b
  pop d
  mov [d], b
  jmp _if28_exit
_if28_else:
; if (num == 0) { 
_if29_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if29_exit
_if29_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if29_exit
_if29_exit:
_if28_exit:
; while (num > 0) { 
_while30_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while30_exit
_while30_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  jmp _while30_cond
_while30_exit:
; while (i > 0) { 
_while37_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while37_exit
_while37_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while37_cond
_while37_exit:
  leave
  ret

print_unsigned:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; if(num == 0){ 
_if38_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if38_exit
_if38_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if38_exit
_if38_exit:
; while (num > 0) { 
_while39_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while39_exit
_while39_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  jmp _while39_cond
_while39_exit:
; while (i > 0) { 
_while46_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while46_exit
_while46_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while46_cond
_while46_exit:
  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d]
print_u16x_printx16:
  push bl
  mov bl, bh
  call _itoa_printx16        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop bl
  call _itoa_printx16        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
; --- END INLINE ASM SEGMENT
; return; 
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_itoa_printx16:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits_printx16]
  mov ah, al
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits_printx16]
  pop b
  pop d
  ret
s_hex_digits_printx16:    .db "0123456789ABCDEF"  
; --- END INLINE ASM SEGMENT
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_active_proc_index: .fill 1, 0
_s0: .db "Hello WorldMy name is Sol-1And this is a multi-line string", 0
_s1: .db "Unexpected format in printf.", 0
_s2: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
