.org 1024

.text


main:
	mov d, s_title
	call _puts

	mov a, 1
	mov [iter], a
L0:
	cla
	mov [count], a
	mov [i], a
L0_0:
	mov a, [i]
	mov d, a
	mov al, 1
	mov [d + flags], al
	mov a, [i]
	inc a
	mov [i], a
	cmp a, 8190
	jleu L0_0	

	mov a, 0
	mov [i], a
L0_1:
	mov a, [i]
	mov d, a
	mov al, [d + flags]
	cmp al, 1
	je IF_0_TRUE
L0_1_COND:	
	mov a, [i]
	inc a
	mov [i], a
	cmp a, 8190
	jleu L0_1	
L0_COND:
	mov a, [iter]
	inc a
	mov [iter], a
	cmp a, 10
	jleu L0
	jmp L0_EXIT
IF_0_TRUE:
	mov b, [i]
	mov a, [i]
	add a, b
	add a, 3
	mov [prime], a		; prime = i + i + 3
	add a, b
	mov [k], a			; k = i + prime	
WHILE:
	mov a, [k]
	mov b, 8190
	cmp a, b
	jgu WHILE_EXIT
	mov a, [k]
	mov d, a
	mov al, 0
	mov [d + flags], al
	mov a, [k]
	mov b, [prime]
	add a, b
	mov [k], a
	jmp WHILE
WHILE_EXIT:	
	mov a, [count]
	inc a
	mov [count], a	
	jmp L0_1_COND

L0_EXIT:
	mov a, [count]
	call print_u16d
	mov d, s_result
	call _puts

	syscall sys_terminate_proc




	

_strlen:
	push d
	mov c, 0
_strlen_L1:
	cmp byte [d], 0
	je _strlen_ret
	inc d
	inc c
	jmp _strlen_L1
_strlen_ret:
	pop d
	ret






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONVERT ASCII 'O'..'F' TO INTEGER 0..15
; ASCII in BL
; result in AL
; ascii for F = 0100 0110
; ascii for 9 = 0011 1001
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hex_ascii_encode:
  mov al, bl
  test al, $40        ; test if letter or number
  jnz hex_letter
  and al, $0F        ; get number
  ret
hex_letter:
  and al, $0F        ; get letter
  add al, 9
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATOI
; 2 letter hex string in B
; 8bit integer returned in AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_atoi:
  push b
  call hex_ascii_encode      ; convert BL to 4bit code in AL
  mov bl, bh
  push al          ; save a
  call hex_ascii_encode
  pop bl  
  shl al, 4
  or al, bl
  pop b
  ret  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; scanf
; no need for explanations!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scanf:
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ITOA
; 8bit value in BL
; 2 byte ASCII result in A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_itoa:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits]
  mov ah, al
  
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits]
  pop b
  pop d
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; HEX STRING TO BINARY
; di = destination address
; si = source
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_hex_to_int:
_hex_to_int_L1:
  lodsb          ; load from [SI] to AL
  cmp al, 0        ; check if ASCII 0
  jz _hex_to_int_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        ; convert ASCII byte in B to int (to AL)
  stosb          ; store AL to [DI]
  jmp _hex_to_int_L1
_hex_to_int_ret:
  ret    



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PUTCHAR
; char in ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_putchar:
  push al
  mov al, 0
  syscall sys_io      ; char in AH
  pop al
  ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT NEW LINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printnl:
  push a
  mov a, $0A00
  syscall sys_io
  mov a, $0D00
  syscall sys_io
  pop a
  ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT NULL TERMINATED STRING
; pointer in D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_puts:
  push a
  push d
_puts_L1:
  mov al, [d]
  cmp al, 0
  jz _puts_END
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1
_puts_END:
  pop d
  pop a
  ret


print_u16d:
  push a
  push b
  push g
  mov b, 10000
  div a, b      ; get 10000's coeff.
  call print_number
  mov a, b
  mov b, 1000
  div a, b      ; get 1000's coeff.
  call print_number
  mov a, b
  mov b, 100
  div a, b
  call print_number
  mov a, b
  mov b, 10
  div a, b
  call print_number
  mov al, bl      ; 1's coeff in bl
  call print_number
  pop g
  pop b
  pop a
  ret

print_number:
  add al, $30
  mov ah, al
  call _putchar
  ret


.end


.date

s_hex_digits:    .db "0123456789ABCDEF"  
s_telnet_clear:  .db "\033[2J\033[H", 0

table_power:
  .dw 1
  .dw 10
  .dw 100
  .dw 1000
  .dw 10000

s_title:	.db "Byte Magazine's Sieve of Erastothenes Benchmark\n", 0

s_result:	.db " primes.\n",0

s_comma:	.db ", ", 0

i:		.dw 0
prime:	.dw 0
k:		.dw 0
count:	.dw 0
iter:	.dw 0


flags:	.db 0

.end

