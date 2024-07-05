; --- FILENAME: games/startrek.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; intro(); 
               
; --- START FUNCTION CALL
  call intro
; new_game(); 
               
; --- START FUNCTION CALL
  call new_game
; return 0; 
               
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

TO_FIXED:
  enter 0 ; (push bp; mov bp, sp)
; return x * 10; 
               
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_1  
  neg a 
skip_invert_a_1:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_1  
  neg b 
skip_invert_b_1:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_1
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_1:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

FROM_FIXED:
  enter 0 ; (push bp; mov bp, sp)
; return x / 10; 
               
  lea d, [bp + 5] ; $x
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
  leave
  ret

TO_FIXED00:
  enter 0 ; (push bp; mov bp, sp)
; return x * 100; 
               
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_3  
  neg a 
skip_invert_a_3:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_3  
  neg b 
skip_invert_b_3:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_3
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_3:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

FROM_FIXED00:
  enter 0 ; (push bp; mov bp, sp)
; return x / 100; 
               
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

get_rand:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int r ; 
  sub sp, 2
; r = rand(); 
  lea d, [bp + -1] ; $r
  push d
               
; --- START FUNCTION CALL
  call rand
  pop d
  mov [d], b
; r = (r >> 8) | (r << 8); 
  lea d, [bp + -1] ; $r
  push d
               
               
  lea d, [bp + -1] ; $r
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push a
  mov a, b
               
  lea d, [bp + -1] ; $r
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  or b, a ; |
  pop a
  pop d
  mov [d], b
; return ((r % spread) + 1); 
               
               
               
  lea d, [bp + -1] ; $r
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $spread
  mov b, [d]
  mov c, 0
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  leave
  ret

rand8:
  enter 0 ; (push bp; mov bp, sp)
; return (get_rand(8)); 
               
               
; --- START FUNCTION CALL
               
  mov32 cb, $00000008
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

input:
  enter 0 ; (push bp; mov bp, sp)
; int c; 
  sub sp, 2
; while((c = getchar()) != '\n') { 
_while6_cond:
               
  lea d, [bp + -1] ; $c
  push d
               
; --- START FUNCTION CALL
  call getchar
  pop d
  mov [d], b
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while6_exit
_while6_block:
; if (c == -1) 
_if7_cond:
               
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if7_exit
_if7_TRUE:
; exit(); 
               
; --- START FUNCTION CALL
  call exit
  jmp _if7_exit
_if7_exit:
; if (l > 1) { 
_if8_cond:
               
  lea d, [bp + 7] ; $l
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if8_exit
_if8_TRUE:
; *b++ = c; 
  lea d, [bp + 5] ; $b
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $b
  mov [d], b
  dec b
  push b
               
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; l--; 
               
  lea d, [bp + 7] ; $l
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  lea d, [bp + 7] ; $l
  mov [d], bl
  inc b
  jmp _if8_exit
_if8_exit:
  jmp _while6_cond
_while6_exit:
; *b = 0; 
  lea d, [bp + 5] ; $b
  mov b, [d]
  mov c, 0
  push b
               
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

yesno:
  enter 0 ; (push bp; mov bp, sp)
; char b[2]; 
  sub sp, 2
; input(b,2); 
               
; --- START FUNCTION CALL
               
  mov32 cb, $00000002
  push bl
               
  lea d, [bp + -1] ; $b
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
; tolower(*b); 
               
; --- START FUNCTION CALL
               
  lea d, [bp + -1] ; $b
  mov b, d
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call tolower
  add sp, 1
; --- END FUNCTION CALL
; return 1; 
               
  mov32 cb, $00000001
  leave
  ret
; return 0; 
               
  mov32 cb, $00000000
  leave
  ret

input_f00:
  enter 0 ; (push bp; mov bp, sp)
; int v; 
  sub sp, 2
; char buf[8]; 
  sub sp, 8
; char *x; 
  sub sp, 2
; input(buf, 8); 
               
; --- START FUNCTION CALL
               
  mov32 cb, $00000008
  push bl
               
  lea d, [bp + -9] ; $buf
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
; x = buf; 
  lea d, [bp + -11] ; $x
  push d
               
  lea d, [bp + -9] ; $buf
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; if (!is_digit(*x)) 
_if9_cond:
                
; --- START FUNCTION CALL
                
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if9_exit
_if9_TRUE:
; return -1; 
                
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if9_exit
_if9_exit:
; v = 100 * (*x++ - '0'); 
  lea d, [bp + -1] ; $v
  push d
                
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
                
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_10  
  neg a 
skip_invert_a_10:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_10  
  neg b 
skip_invert_b_10:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_10
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_10:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; if (*x == 0) 
_if11_cond:
                
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
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
  je _if11_exit
_if11_TRUE:
; return v; 
                
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if11_exit
_if11_exit:
; if (*x++ != '.') 
_if12_cond:
                
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002e
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if12_exit
_if12_TRUE:
; return -1; 
                
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if12_exit
_if12_exit:
; if (!is_digit(*x)) 
_if13_cond:
                
; --- START FUNCTION CALL
                
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if13_exit
_if13_TRUE:
; return -1; 
                
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if13_exit
_if13_exit:
; v = v + 10 * (*x++ - '0'); 
  lea d, [bp + -1] ; $v
  push d
                
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $0000000a
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
                
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_14  
  neg a 
skip_invert_a_14:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_14  
  neg b 
skip_invert_b_14:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_14
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_14:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (!*x) 
_if15_cond:
                
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if15_exit
_if15_TRUE:
; return v; 
                
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if15_exit
_if15_exit:
; if (!is_digit(*x)) 
_if16_cond:
                
; --- START FUNCTION CALL
                
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if16_exit
_if16_TRUE:
; return -1; 
                
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if16_exit
_if16_exit:
; v = v + *x++ - '0'; 
  lea d, [bp + -1] ; $v
  push d
                
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; return v; 
                
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
  leave
  ret

input_int:
  enter 0 ; (push bp; mov bp, sp)
; char x[8]; 
  sub sp, 8
; input(x, 8); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000008
  push bl
                
  lea d, [bp + -7] ; $x
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
; if (!is_digit(*x)) 
_if17_cond:
                
; --- START FUNCTION CALL
                
  lea d, [bp + -7] ; $x
  mov b, d
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if17_exit
_if17_TRUE:
; return -1; 
                
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if17_exit
_if17_exit:
; return atoi(x); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + -7] ; $x
  mov b, d
  mov c, 0
  swp b
  push b
  call atoi
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

print100:
  enter 0 ; (push bp; mov bp, sp)
; static char buf[16]; 
  sub sp, 16
; char *p; 
  sub sp, 2
; *p = buf; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  push b
                
  mov d, st_print100_buf_dt ; static buf
  mov b, d
  mov c, 0
  pop d
  mov [d], bl
; if (v < 0) { 
_if18_cond:
                
  lea d, [bp + 5] ; $v
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
  je _if18_exit
_if18_TRUE:
; v = -v; 
  lea d, [bp + 5] ; $v
  push d
                
  lea d, [bp + 5] ; $v
  mov b, [d]
  mov c, 0
  neg b
  pop d
  mov [d], b
; *p++ = '-'; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  dec b
  push b
                
  mov32 cb, $0000002d
  pop d
  mov [d], bl
  jmp _if18_exit
_if18_exit:
; return buf; 
                
  mov d, st_print100_buf_dt ; static buf
  mov b, d
  mov c, 0
  leave
  ret

inoperable:
  enter 0 ; (push bp; mov bp, sp)
; if (damage[u] < 0) { 
_if19_cond:
                
  mov d, _damage_data ; $damage
  push a
  push d
                
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if19_exit
_if19_TRUE:
; printf("%s %s inoperable.\n", 
                
; --- START FUNCTION CALL
_ternary20_cond:
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary20_FALSE
_ternary20_TRUE:
                
  mov b, _s30 ; "are"
  jmp _ternary20_exit
_ternary20_FALSE:
                
  mov b, _s31 ; "is"
_ternary20_exit:
  swp b
  push b
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                
  mov b, _s32 ; "%s %s inoperable.\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; return 1; 
                
  mov32 cb, $00000001
  leave
  ret
  jmp _if19_exit
_if19_exit:
; return 0; 
                
  mov32 cb, $00000000
  leave
  ret

intro:
  enter 0 ; (push bp; mov bp, sp)
; showfile("startrek.intro"); 
                
; --- START FUNCTION CALL
                
  mov b, _s33 ; "startrek.intro"
  swp b
  push b
  call showfile
  add sp, 2
; --- END FUNCTION CALL
; if (yesno()) 
_if21_cond:
                
; --- START FUNCTION CALL
  call yesno
  cmp b, 0
  je _if21_exit
_if21_TRUE:
; showfile("startrek.doc"); 
                
; --- START FUNCTION CALL
                
  mov b, _s34 ; "startrek.doc"
  swp b
  push b
  call showfile
  add sp, 2
; --- END FUNCTION CALL
  jmp _if21_exit
_if21_exit:
; showfile("startrek.logo"); 
                
; --- START FUNCTION CALL
                
  mov b, _s35 ; "startrek.logo"
  swp b
  push b
  call showfile
  add sp, 2
; --- END FUNCTION CALL
; stardate = TO_FIXED((get_rand(20) + 20) * 100); 
  mov d, _stardate ; $stardate
  push d
                
; --- START FUNCTION CALL
                
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000014
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000014
  add b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_22  
  neg a 
skip_invert_a_22:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_22  
  neg b 
skip_invert_b_22:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_22
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_22:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  leave
  ret

new_game:
  enter 0 ; (push bp; mov bp, sp)
; char cmd[4]; 
  sub sp, 4
; initialize(); 
                
; --- START FUNCTION CALL
  call initialize
; new_quadrant(); 
                
; --- START FUNCTION CALL
  call new_quadrant
; short_range_scan(); 
                
; --- START FUNCTION CALL
  call short_range_scan
; while (1) { 
_while23_cond:
                
  mov32 cb, $00000001
  cmp b, 0
  je _while23_exit
_while23_block:
; if (shield + energy <= 10 && (energy < 10 || damage[7] < 0)) { 
_if24_cond:
                
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
                
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _damage_data ; $damage
  push a
  push d
                
  mov32 cb, $00000007
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if24_exit
_if24_TRUE:
; showfile("startrek.fatal"); 
                
; --- START FUNCTION CALL
                
  mov b, _s36 ; "startrek.fatal"
  swp b
  push b
  call showfile
  add sp, 2
; --- END FUNCTION CALL
; end_of_time(); 
                
; --- START FUNCTION CALL
  call end_of_time
  jmp _if24_exit
_if24_exit:
; puts("Command? "); 
                
; --- START FUNCTION CALL
                
  mov b, _s37 ; "Command? "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; input(cmd, 4); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000004
  push bl
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
; putchar('\n'); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; if (!strncmp(cmd, "nav", 3)) 
_if25_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000003
  swp b
  push b
                
  mov b, _s38 ; "nav"
  swp b
  push b
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if25_else
_if25_TRUE:
; course_control(); 
                
; --- START FUNCTION CALL
  call course_control
  jmp _if25_exit
_if25_else:
; if (!strncmp(cmd, "srs", 3)) 
_if26_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000003
  swp b
  push b
                
  mov b, _s39 ; "srs"
  swp b
  push b
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if26_else
_if26_TRUE:
; short_range_scan(); 
                
; --- START FUNCTION CALL
  call short_range_scan
  jmp _if26_exit
_if26_else:
; if (!strncmp(cmd, "lrs", 3)) 
_if27_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000003
  swp b
  push b
                
  mov b, _s40 ; "lrs"
  swp b
  push b
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if27_else
_if27_TRUE:
; long_range_scan(); 
                
; --- START FUNCTION CALL
  call long_range_scan
  jmp _if27_exit
_if27_else:
; if (!strncmp(cmd, "pha", 3)) 
_if28_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000003
  swp b
  push b
                
  mov b, _s41 ; "pha"
  swp b
  push b
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if28_else
_if28_TRUE:
; phaser_control(); 
                
; --- START FUNCTION CALL
  call phaser_control
  jmp _if28_exit
_if28_else:
; if (!strncmp(cmd, "tor", 3)) 
_if29_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000003
  swp b
  push b
                
  mov b, _s42 ; "tor"
  swp b
  push b
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if29_else
_if29_TRUE:
; photon_torpedoes(); 
                
; --- START FUNCTION CALL
  call photon_torpedoes
  jmp _if29_exit
_if29_else:
; if (!strncmp(cmd, "shi", 3)) 
_if30_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000003
  swp b
  push b
                
  mov b, _s43 ; "shi"
  swp b
  push b
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if30_else
_if30_TRUE:
; shield_control(); 
                
; --- START FUNCTION CALL
  call shield_control
  jmp _if30_exit
_if30_else:
; if (!strncmp(cmd, "dam", 3)) 
_if31_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000003
  swp b
  push b
                
  mov b, _s44 ; "dam"
  swp b
  push b
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if31_else
_if31_TRUE:
; damage_control(); 
                
; --- START FUNCTION CALL
  call damage_control
  jmp _if31_exit
_if31_else:
; if (!strncmp(cmd, "com", 3)) 
_if32_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000003
  swp b
  push b
                
  mov b, _s45 ; "com"
  swp b
  push b
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if32_else
_if32_TRUE:
; library_computer(); 
                
; --- START FUNCTION CALL
  call library_computer
  jmp _if32_exit
_if32_else:
; if (!strncmp(cmd, "xxx", 3)) 
_if33_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000003
  swp b
  push b
                
  mov b, _s46 ; "xxx"
  swp b
  push b
                
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if33_else
_if33_TRUE:
; resign_commision(); 
                
; --- START FUNCTION CALL
  call resign_commision
  jmp _if33_exit
_if33_else:
; puts("Enter one of the following:\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s47 ; "Enter one of the following:\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  nav - To Set Course"); 
                
; --- START FUNCTION CALL
                
  mov b, _s48 ; "  nav - To Set Course"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  srs - Short Range Sensors"); 
                
; --- START FUNCTION CALL
                
  mov b, _s49 ; "  srs - Short Range Sensors"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  lrs - Long Range Sensors"); 
                
; --- START FUNCTION CALL
                
  mov b, _s50 ; "  lrs - Long Range Sensors"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  pha - Phasers"); 
                
; --- START FUNCTION CALL
                
  mov b, _s51 ; "  pha - Phasers"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  tor - Photon Torpedoes"); 
                
; --- START FUNCTION CALL
                
  mov b, _s52 ; "  tor - Photon Torpedoes"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  shi - Shield Control"); 
                
; --- START FUNCTION CALL
                
  mov b, _s53 ; "  shi - Shield Control"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  dam - Damage Control"); 
                
; --- START FUNCTION CALL
                
  mov b, _s54 ; "  dam - Damage Control"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  com - Library Computer"); 
                
; --- START FUNCTION CALL
                
  mov b, _s55 ; "  com - Library Computer"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  xxx - Resign Command\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s56 ; "  xxx - Resign Command\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_if33_exit:
_if32_exit:
_if31_exit:
_if30_exit:
_if29_exit:
_if28_exit:
_if27_exit:
_if26_exit:
_if25_exit:
  jmp _while23_cond
_while23_exit:
  leave
  ret

initialize:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; unsigned char yp, xp; 
  sub sp, 1
  sub sp, 1
; unsigned char r; 
  sub sp, 1
; time_start = FROM_FIXED(stardate); 
  mov d, _time_start ; $time_start
  push d
                
; --- START FUNCTION CALL
                
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; time_up = 25 + get_rand(10); 
  mov d, _time_up ; $time_up
  push d
                
  mov32 cb, $00000019
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov32 cb, $0000000a
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; docked = 0; 
  mov d, _docked ; $docked
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; energy = energy0; 
  mov d, _energy ; $energy
  push d
                
  mov d, _energy0 ; $energy0
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; torps = torps0; 
  mov d, _torps ; $torps
  push d
                
  mov d, _torps0 ; $torps0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; shield = 0; 
  mov d, _shield ; $shield
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
; quad_y = rand8(); 
  mov d, _quad_y ; $quad_y
  push d
                
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], b
; quad_x = rand8(); 
  mov d, _quad_x ; $quad_x
  push d
                
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], b
; ship_y = TO_FIXED00(rand8()); 
  mov d, _ship_y ; $ship_y
  push d
                
; --- START FUNCTION CALL
                
; --- START FUNCTION CALL
  call rand8
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; ship_x = TO_FIXED00(rand8()); 
  mov d, _ship_x ; $ship_x
  push d
                
; --- START FUNCTION CALL
                
; --- START FUNCTION CALL
  call rand8
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for (i = 1; i <= 8; i++) 
_for34_init:
  lea d, [bp + -1] ; $i
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
_for34_cond:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for34_exit
_for34_block:
; damage[i] = 0; 
  mov d, _damage_data ; $damage
  push a
  push d
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
_for34_update:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for34_cond
_for34_exit:
; for (i = 1; i <= 8; i++) { 
_for35_init:
  lea d, [bp + -1] ; $i
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
_for35_cond:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for35_exit
_for35_block:
; for (j = 1; j <= 8; j++) { 
_for36_init:
  lea d, [bp + -3] ; $j
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
_for36_cond:
                
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for36_exit
_for36_block:
; r = get_rand(100); 
  lea d, [bp + -6] ; $r
  push d
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], bl
; klingons = 0; 
  mov d, _klingons ; $klingons
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if (r > 98) 
_if37_cond:
                
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000062
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if37_else
_if37_TRUE:
; klingons = 3; 
  mov d, _klingons ; $klingons
  push d
                
  mov32 cb, $00000003
  pop d
  mov [d], bl
  jmp _if37_exit
_if37_else:
; if (r > 95) 
_if38_cond:
                
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005f
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if38_else
_if38_TRUE:
; klingons = 2; 
  mov d, _klingons ; $klingons
  push d
                
  mov32 cb, $00000002
  pop d
  mov [d], bl
  jmp _if38_exit
_if38_else:
; if (r > 80) 
_if39_cond:
                
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000050
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if39_exit
_if39_TRUE:
; klingons = 1; 
  mov d, _klingons ; $klingons
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], bl
  jmp _if39_exit
_if39_exit:
_if38_exit:
_if37_exit:
; klingons_left = klingons_left + klingons; 
  mov d, _klingons_left ; $klingons_left
  push d
                
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; starbases = 0; 
  mov d, _starbases ; $starbases
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if (get_rand(100) > 96) 
_if40_cond:
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000060
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if40_exit
_if40_TRUE:
; starbases = 1; 
  mov d, _starbases ; $starbases
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], bl
  jmp _if40_exit
_if40_exit:
; starbases_left = starbases_left + starbases; 
  mov d, _starbases_left ; $starbases_left
  push d
                
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; map[i][j] = (klingons << 8) + (starbases << 4) + rand8(); 
  mov d, _map_data ; $map
  push a
  push d
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                
                
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
                
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  mov a, b
; --- START FUNCTION CALL
  call rand8
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for36_update:
                
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for36_cond
_for36_exit:
_for35_update:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for35_cond
_for35_exit:
; if (klingons_left > time_up) 
_if41_cond:
                
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if41_exit
_if41_TRUE:
; time_up = klingons_left + 1; 
  mov d, _time_up ; $time_up
  push d
                
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if41_exit
_if41_exit:
; if (starbases_left == 0) { 
_if42_cond:
                
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
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
  je _if42_exit
_if42_TRUE:
; yp = rand8(); 
  lea d, [bp + -4] ; $yp
  push d
                
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; xp = rand8(); 
  lea d, [bp + -5] ; $xp
  push d
                
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; if (map[yp][xp] < 0x200) { 
_if43_cond:
                
  mov d, _map_data ; $map
  push a
  push d
                
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000200
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if43_exit
_if43_TRUE:
; map[yp][xp] = map[yp][xp] + (1 << 8); 
  mov d, _map_data ; $map
  push a
  push d
                
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                
  mov d, _map_data ; $map
  push a
  push d
                
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                
  mov32 cb, $00000001
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; klingons_left++; 
                
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  inc b
  mov d, _klingons_left ; $klingons_left
  mov [d], bl
  dec b
  jmp _if43_exit
_if43_exit:
; map[yp][xp] = map[yp][xp] + (1 << 4); 
  mov d, _map_data ; $map
  push a
  push d
                
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                
  mov d, _map_data ; $map
  push a
  push d
                
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                
  mov32 cb, $00000001
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; starbases_left++; 
                
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  inc b
  mov d, _starbases_left ; $starbases_left
  mov [d], bl
  dec b
  jmp _if42_exit
_if42_exit:
; total_klingons = klingons_left; 
  mov d, _total_klingons ; $total_klingons
  push d
                
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (starbases_left != 1) { 
_if44_cond:
                
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if44_exit
_if44_TRUE:
; strcpy(plural_2, "s"); 
                
; --- START FUNCTION CALL
                
  mov b, _s57 ; "s"
  swp b
  push b
                
  mov d, _plural_2_data ; $plural_2
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; strcpy(plural, "are"); 
                
; --- START FUNCTION CALL
                
  mov b, _s30 ; "are"
  swp b
  push b
                
  mov d, _plural_data ; $plural
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
  jmp _if44_exit
_if44_exit:
; getchar(); 
                
; --- START FUNCTION CALL
  call getchar
  leave
  ret

place_ship:
  enter 0 ; (push bp; mov bp, sp)
; quad[FROM_FIXED00(ship_y) - 1][FROM_FIXED00(ship_x) - 1] = 		4; 
  mov d, _quad_data ; $quad
  push a
  push d
                
; --- START FUNCTION CALL
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                
; --- START FUNCTION CALL
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
                
  mov32 cb, $00000004
  pop d
  mov [d], bl
  leave
  ret

new_quadrant:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; unsigned int tmp; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; k = &kdata; 
  lea d, [bp + -5] ; $k
  push d
                
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; klingons = 0; 
  mov d, _klingons ; $klingons
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; starbases = 0; 
  mov d, _starbases ; $starbases
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; stars = 0; 
  mov d, _stars ; $stars
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; d4 = get_rand(50) - 1; 
  mov d, _d4 ; $d4
  push d
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000032
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; map[quad_y][quad_x] = map[quad_y][quad_x] |  0x1000		/* Set if this sector was mapped */; 
  mov d, _map_data ; $map
  push a
  push d
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                
  mov d, _map_data ; $map
  push a
  push d
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00001000
  or b, a ; |
  pop a
  pop d
  mov [d], b
; if (quad_y >= 1 && quad_y <= 8 && quad_x >= 1 && quad_x <= 8) { 
_if45_cond:
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if45_exit
_if45_TRUE:
; quadrant_name(0, quad_y, quad_x); 
                
; --- START FUNCTION CALL
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  push bl
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  push bl
                
  mov32 cb, $00000000
  push bl
  call quadrant_name
  add sp, 3
; --- END FUNCTION CALL
; if (TO_FIXED(time_start) != stardate) 
_if46_cond:
                
; --- START FUNCTION CALL
                
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if46_else
_if46_TRUE:
; printf("Now entering %s quadrant...\n\n", quadname); 
                
; --- START FUNCTION CALL
                
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
                
  mov b, _s58 ; "Now entering %s quadrant...\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if46_exit
_if46_else:
; puts("\nYour mission begins with your starship located"); 
                
; --- START FUNCTION CALL
                
  mov b, _s59 ; "\nYour mission begins with your starship located"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; printf("in the galactic quadrant %s.\n\n", quadname); 
                
; --- START FUNCTION CALL
                
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
                
  mov b, _s60 ; "in the galactic quadrant %s.\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if46_exit:
  jmp _if45_exit
_if45_exit:
; tmp = map[quad_y][quad_x]; 
  lea d, [bp + -3] ; $tmp
  push d
                
  mov d, _map_data ; $map
  push a
  push d
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; klingons = (tmp >> 8) & 0x0F; 
  mov d, _klingons ; $klingons
  push d
                
                
  lea d, [bp + -3] ; $tmp
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; starbases = (tmp >> 4) & 0x0F; 
  mov d, _starbases ; $starbases
  push d
                
                
  lea d, [bp + -3] ; $tmp
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; stars = tmp & 0x0F; 
  mov d, _stars ; $stars
  push d
                
  lea d, [bp + -3] ; $tmp
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; if (klingons > 0) { 
_if47_cond:
                
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
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
  je _if47_exit
_if47_TRUE:
; printf("Combat Area  Condition Red\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s61 ; "Combat Area  Condition Red\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; if (shield < 200) 
_if48_cond:
                
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $000000c8
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if48_exit
_if48_TRUE:
; printf("Shields Dangerously Low\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s62 ; "Shields Dangerously Low\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  jmp _if48_exit
_if48_exit:
  jmp _if47_exit
_if47_exit:
; for (i = 1; i <= 3; i++) { 
_for49_init:
  lea d, [bp + -1] ; $i
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
_for49_cond:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for49_exit
_for49_block:
; k->y = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; k->x = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; k->energy = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
; k++; 
                
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
_for49_update:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for49_cond
_for49_exit:
; memset(quad, 		0, 64); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000040
  swp b
  push b
                
  mov32 cb, $00000000
  push bl
                
  mov d, _quad_data ; $quad
  mov b, d
  mov c, 0
  swp b
  push b
  call memset
  add sp, 5
; --- END FUNCTION CALL
; place_ship(); 
                
; --- START FUNCTION CALL
  call place_ship
; if (klingons > 0) { 
_if50_cond:
                
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
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
  je _if50_exit
_if50_TRUE:
; k = kdata; 
  lea d, [bp + -5] ; $k
  push d
                
  mov d, _kdata_data ; $kdata
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; for (i = 0; i < klingons; i++) { 
_for51_init:
  lea d, [bp + -1] ; $i
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
_for51_cond:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for51_exit
_for51_block:
; find_set_empty_place(	3, k->y, k->x); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
                
  mov32 cb, $00000003
  push bl
  call find_set_empty_place
  add sp, 5
; --- END FUNCTION CALL
; k->energy = 100 + get_rand(200); 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
  push d
                
  mov32 cb, $00000064
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov32 cb, $000000c8
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; k++; 
                
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
_for51_update:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for51_cond
_for51_exit:
  jmp _if50_exit
_if50_exit:
; if (starbases > 0) 
_if52_cond:
                
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
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
  je _if52_exit
_if52_TRUE:
; find_set_empty_place(		2, &base_y, &base_x); 
                
; --- START FUNCTION CALL
                
  mov d, _base_x ; $base_x
  mov b, d
  swp b
  push b
                
  mov d, _base_y ; $base_y
  mov b, d
  swp b
  push b
                
  mov32 cb, $00000002
  push bl
  call find_set_empty_place
  add sp, 5
; --- END FUNCTION CALL
  jmp _if52_exit
_if52_exit:
; for (i = 1; i <= stars; i++) 
_for53_init:
  lea d, [bp + -1] ; $i
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
_for53_cond:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _stars ; $stars
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for53_exit
_for53_block:
; find_set_empty_place(		1,  0,  0); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000000
  swp b
  push b
                
  mov32 cb, $00000000
  swp b
  push b
                
  mov32 cb, $00000001
  push bl
  call find_set_empty_place
  add sp, 5
; --- END FUNCTION CALL
_for53_update:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for53_cond
_for53_exit:
  leave
  ret

course_control:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int c1; 
  sub sp, 2
; int warp; 
  sub sp, 2
; unsigned int n; 
  sub sp, 2
; int c2, c3, c4; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; int z1, z2; 
  sub sp, 2
  sub sp, 2
; int x1, x2; 
  sub sp, 2
  sub sp, 2
; int x, y; 
  sub sp, 2
  sub sp, 2
; unsigned char outside = 0;		/* Outside galaxy flag */ 
  sub sp, 1
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -26] ; $outside
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; --- END LOCAL VAR INITIALIZATION
; unsigned char quad_y_old; 
  sub sp, 1
; unsigned char quad_x_old; 
  sub sp, 1
; puts("Course (0-9): " ); 
                
; --- START FUNCTION CALL
                
  mov b, _s63 ; "Course (0-9): "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; c1 = input_f00(); 
  lea d, [bp + -3] ; $c1
  push d
                
; --- START FUNCTION CALL
  call input_f00
  pop d
  mov [d], b
; if (c1 == 900) 
_if54_cond:
                
  lea d, [bp + -3] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if54_exit
_if54_TRUE:
; c1 = 100; 
  lea d, [bp + -3] ; $c1
  push d
                
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if54_exit
_if54_exit:
; if (c1 < 0 || c1 > 900) { 
_if55_cond:
                
  lea d, [bp + -3] ; $c1
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if55_exit
_if55_TRUE:
; printf("Lt. Sulu%s", inc_1); 
                
; --- START FUNCTION CALL
                
  mov d, _inc_1 ; $inc_1
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  mov b, _s64 ; "Lt. Sulu%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if55_exit
_if55_exit:
; if (damage[1] < 0) 
_if56_cond:
                
  mov d, _damage_data ; $damage
  push a
  push d
                
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if56_exit
_if56_TRUE:
; strcpy(warpmax, "0.2"); 
                
; --- START FUNCTION CALL
                
  mov b, _s65 ; "0.2"
  swp b
  push b
                
  mov d, _warpmax_data ; $warpmax
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
  jmp _if56_exit
_if56_exit:
; printf("Warp Factor (0-%s): ", warpmax); 
                
; --- START FUNCTION CALL
                
  mov d, _warpmax_data ; $warpmax
  mov b, d
  mov c, 0
  swp b
  push b
                
  mov b, _s66 ; "Warp Factor (0-%s): "
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; warp = input_f00(); 
  lea d, [bp + -5] ; $warp
  push d
                
; --- START FUNCTION CALL
  call input_f00
  pop d
  mov [d], b
; if (damage[1] < 0 && warp > 20) { 
_if57_cond:
                
  mov d, _damage_data ; $damage
  push a
  push d
                
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000014
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if57_exit
_if57_TRUE:
; printf("Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s67 ; "Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if57_exit
_if57_exit:
; if (warp <= 0) 
_if58_cond:
                
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if58_exit
_if58_TRUE:
; return; 
  leave
  ret
  jmp _if58_exit
_if58_exit:
; if (warp > 800) { 
_if59_cond:
                
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000320
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if59_exit
_if59_TRUE:
; printf("Chief Engineer Scott reports:\n  The engines won't take warp %s!\n\n", print100(warp)); 
                
; --- START FUNCTION CALL
                
; --- START FUNCTION CALL
                
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                
  mov b, _s68 ; "Chief Engineer Scott reports:\n  The engines won't take warp %s!\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if59_exit
_if59_exit:
; n = warp * 8; 
  lea d, [bp + -7] ; $n
  push d
                
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000008
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_60  
  neg a 
skip_invert_a_60:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_60  
  neg b 
skip_invert_b_60:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_60
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_60:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; n = cint100(n);	 
  lea d, [bp + -7] ; $n
  push d
                
; --- START FUNCTION CALL
                
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  call cint100
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (energy - n < 0) { 
_if61_cond:
                
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if61_exit
_if61_TRUE:
; printf("Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n", print100(warp)); 
                
; --- START FUNCTION CALL
                
; --- START FUNCTION CALL
                
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                
  mov b, _s69 ; "Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; if (shield >= n && damage[7] >= 0) { 
_if62_cond:
                
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _damage_data ; $damage
  push a
  push d
                
  mov32 cb, $00000007
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if62_exit
_if62_TRUE:
; printf("Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n", shield); 
                
; --- START FUNCTION CALL
                
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  mov b, _s70 ; "Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if62_exit
_if62_exit:
; return; 
  leave
  ret
  jmp _if61_exit
_if61_exit:
; klingons_move(); 
                
; --- START FUNCTION CALL
  call klingons_move
; repair_damage(warp); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call repair_damage
  add sp, 2
; --- END FUNCTION CALL
; z1 = FROM_FIXED00(ship_y); 
  lea d, [bp + -15] ; $z1
  push d
                
; --- START FUNCTION CALL
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; z2 = FROM_FIXED00(ship_x); 
  lea d, [bp + -17] ; $z2
  push d
                
; --- START FUNCTION CALL
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; quad[z1+-1][z2+-1] = 		0; 
  mov d, _quad_data ; $quad
  push a
  push d
                
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; c2 = FROM_FIXED00(c1);	/* Integer part */ 
  lea d, [bp + -9] ; $c2
  push d
                
; --- START FUNCTION CALL
                
  lea d, [bp + -3] ; $c1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; c3 = c2 + 1;		/* Next integer part */ 
  lea d, [bp + -11] ; $c3
  push d
                
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; c4 = (c1 - TO_FIXED00(c2));	/* Fractional element in fixed point */ 
  lea d, [bp + -13] ; $c4
  push d
                
                
  lea d, [bp + -3] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
                
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x1 = 100 * c[1][c2] + (c[1][c3] - c[1][c2]) * c4; 
  lea d, [bp + -19] ; $x1
  push d
                
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
                
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_63  
  neg a 
skip_invert_a_63:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_63  
  neg b 
skip_invert_b_63:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_63
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_63:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
                
  mov d, _c_data ; $c
  push a
  push d
                
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                
  lea d, [bp + -11] ; $c3
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
                
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -13] ; $c4
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_64  
  neg a 
skip_invert_a_64:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_64  
  neg b 
skip_invert_b_64:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_64
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_64:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x2 = 100 * c[2][c2] + (c[2][c3] - c[2][c2]) * c4; 
  lea d, [bp + -21] ; $x2
  push d
                
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
                
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_65  
  neg a 
skip_invert_a_65:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_65  
  neg b 
skip_invert_b_65:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_65
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_65:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
                
  mov d, _c_data ; $c
  push a
  push d
                
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                
  lea d, [bp + -11] ; $c3
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
                
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -13] ; $c4
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_66  
  neg a 
skip_invert_a_66:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_66  
  neg b 
skip_invert_b_66:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_66
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_66:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x = ship_y; 
  lea d, [bp + -23] ; $x
  push d
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; y = ship_x; 
  lea d, [bp + -25] ; $y
  push d
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; for (i = 1; i <= n; i++) { 
_for67_init:
  lea d, [bp + -1] ; $i
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
_for67_cond:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for67_exit
_for67_block:
; ship_y = ship_y + x1; 
  mov d, _ship_y ; $ship_y
  push d
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = ship_x + x2; 
  mov d, _ship_x ; $ship_x
  push d
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; z1 = FROM_FIXED00(ship_y); 
  lea d, [bp + -15] ; $z1
  push d
                
; --- START FUNCTION CALL
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; z2 = FROM_FIXED00(ship_x);	/* ?? cint100 ?? */ 
  lea d, [bp + -17] ; $z2
  push d
                
; --- START FUNCTION CALL
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (z1 < 1 || z1 >= 9 || z2 < 1 || z2 >= 9) { 
_if68_cond:
                
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000009
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000009
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if68_exit
_if68_TRUE:
; outside = 0;		/* Outside galaxy flag */ 
  lea d, [bp + -26] ; $outside
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; quad_y_old = quad_y; 
  lea d, [bp + -27] ; $quad_y_old
  push d
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; quad_x_old = quad_x; 
  lea d, [bp + -28] ; $quad_x_old
  push d
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; x = (800 * quad_y) + x + (n * x1); 
  lea d, [bp + -23] ; $x
  push d
                
                
  mov32 cb, $00000320
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_69  
  neg a 
skip_invert_a_69:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_69  
  neg b 
skip_invert_b_69:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_69
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_69:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -23] ; $x
  mov b, [d]
  mov c, 0
  add32 cb, ga
  mov a, b
  mov g, c
                
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -19] ; $x1
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_70  
  neg a 
skip_invert_a_70:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_70  
  neg b 
skip_invert_b_70:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_70
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_70:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; y = (800 * quad_x) + y + (n * x2); 
  lea d, [bp + -25] ; $y
  push d
                
                
  mov32 cb, $00000320
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_71  
  neg a 
skip_invert_a_71:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_71  
  neg b 
skip_invert_b_71:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_71
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_71:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -25] ; $y
  mov b, [d]
  mov c, 0
  add32 cb, ga
  mov a, b
  mov g, c
                
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -21] ; $x2
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_72  
  neg a 
skip_invert_a_72:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_72  
  neg b 
skip_invert_b_72:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_72
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_72:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; quad_y = x / 800;	/* Fixed point to int and divide by 8 */ 
  mov d, _quad_y ; $quad_y
  push d
                
  lea d, [bp + -23] ; $x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000320
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
; quad_x = y / 800;	/* Ditto */ 
  mov d, _quad_x ; $quad_x
  push d
                
  lea d, [bp + -25] ; $y
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000320
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
; ship_y = x - (quad_y * 800); 
  mov d, _ship_y ; $ship_y
  push d
                
  lea d, [bp + -23] ; $x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000320
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_75  
  neg a 
skip_invert_a_75:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_75  
  neg b 
skip_invert_b_75:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_75
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_75:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  sub32 ga, cb
  mov b, a
  mov c, g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = y - (quad_x * 800); 
  mov d, _ship_x ; $ship_x
  push d
                
  lea d, [bp + -25] ; $y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000320
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_76  
  neg a 
skip_invert_a_76:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_76  
  neg b 
skip_invert_b_76:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_76
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_76:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  sub32 ga, cb
  mov b, a
  mov c, g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (ship_y < 100) { 
_if77_cond:
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if77_exit
_if77_TRUE:
; quad_y = quad_y - 1; 
  mov d, _quad_y ; $quad_y
  push d
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_y = ship_y + 800; 
  mov d, _ship_y ; $ship_y
  push d
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000320
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if77_exit
_if77_exit:
; if (ship_x < 100) { 
_if78_cond:
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if78_exit
_if78_TRUE:
; quad_x = quad_x - 1; 
  mov d, _quad_x ; $quad_x
  push d
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = ship_x + 800; 
  mov d, _ship_x ; $ship_x
  push d
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000320
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if78_exit
_if78_exit:
; if (quad_y < 1) { 
_if79_cond:
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if79_exit
_if79_TRUE:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], bl
; quad_y = 1; 
  mov d, _quad_y ; $quad_y
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
; ship_y = 100; 
  mov d, _ship_y ; $ship_y
  push d
                
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if79_exit
_if79_exit:
; if (quad_y > 8) { 
_if80_cond:
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if80_exit
_if80_TRUE:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], bl
; quad_y = 8; 
  mov d, _quad_y ; $quad_y
  push d
                
  mov32 cb, $00000008
  pop d
  mov [d], b
; ship_y = 800; 
  mov d, _ship_y ; $ship_y
  push d
                
  mov32 cb, $00000320
  pop d
  mov [d], b
  jmp _if80_exit
_if80_exit:
; if (quad_x < 1) { 
_if81_cond:
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if81_exit
_if81_TRUE:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], bl
; quad_x = 1; 
  mov d, _quad_x ; $quad_x
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
; ship_x = 100; 
  mov d, _ship_x ; $ship_x
  push d
                
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if81_exit
_if81_exit:
; if (quad_x > 8) { 
_if82_cond:
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if82_exit
_if82_TRUE:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], bl
; quad_x = 8; 
  mov d, _quad_x ; $quad_x
  push d
                
  mov32 cb, $00000008
  pop d
  mov [d], b
; ship_x = 800; 
  mov d, _ship_x ; $ship_x
  push d
                
  mov32 cb, $00000320
  pop d
  mov [d], b
  jmp _if82_exit
_if82_exit:
; if (outside == 1) { 
_if83_cond:
                
  lea d, [bp + -26] ; $outside
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if83_exit
_if83_TRUE:
; printf("LT. Uhura reports:\n Message from Starfleet Command:\n\n Permission to attempt crossing of galactic perimeter\n is hereby *denied*. Shut down your engines.\n\n Chief Engineer Scott reports:\n Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n", FROM_FIXED00(ship_y), 
                
; --- START FUNCTION CALL
                
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
                
; --- START FUNCTION CALL
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                
; --- START FUNCTION CALL
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                
  mov b, _s71 ; "LT. Uhura reports:\n Message from Starfleet Command:\n\n Permission to attempt crossing of galactic perimeter\n is hereby *denied*. Shut down your engines.\n\n Chief Engineer Scott reports:\n Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n"
  swp b
  push b
  call printf
  add sp, 10
; --- END FUNCTION CALL
  jmp _if83_exit
_if83_exit:
; maneuver_energy(n); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  call maneuver_energy
  add sp, 2
; --- END FUNCTION CALL
; if (FROM_FIXED(stardate) > time_start + time_up) 
_if84_cond:
                
; --- START FUNCTION CALL
                
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if84_exit
_if84_TRUE:
; end_of_time(); 
                
; --- START FUNCTION CALL
  call end_of_time
  jmp _if84_exit
_if84_exit:
; if (quad_y != quad_y_old || quad_x != quad_x_old) { 
_if85_cond:
                
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -27] ; $quad_y_old
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -28] ; $quad_x_old
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if85_exit
_if85_TRUE:
; stardate = stardate + TO_FIXED(1); 
  mov d, _stardate ; $stardate
  push d
                
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov32 cb, $00000001
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; new_quadrant(); 
                
; --- START FUNCTION CALL
  call new_quadrant
  jmp _if85_exit
_if85_exit:
; complete_maneuver(warp, n); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call complete_maneuver
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if68_exit
_if68_exit:
; if (quad[z1+-1][z2+-1] != 		0) {	/* Sector not empty */ 
_if86_cond:
                
  mov d, _quad_data ; $quad
  push a
  push d
                
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if86_exit
_if86_TRUE:
; ship_y = ship_y - x1; 
  mov d, _ship_y ; $ship_y
  push d
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = ship_x - x2; 
  mov d, _ship_x ; $ship_x
  push d
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; printf("Warp Engines shut down at sector %d, %d due to bad navigation.\n\n", z1, z2); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  mov b, _s72 ; "Warp Engines shut down at sector %d, %d due to bad navigation.\n\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; i = n + 1; 
  lea d, [bp + -1] ; $i
  push d
                
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if86_exit
_if86_exit:
_for67_update:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for67_cond
_for67_exit:
; complete_maneuver(warp, n); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call complete_maneuver
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

complete_maneuver:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int time_used; 
  sub sp, 2
; place_ship(); 
                
; --- START FUNCTION CALL
  call place_ship
; maneuver_energy(n); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  call maneuver_energy
  add sp, 2
; --- END FUNCTION CALL
; time_used = TO_FIXED(1); 
  lea d, [bp + -1] ; $time_used
  push d
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000001
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (warp < 100) 
_if87_cond:
                
  lea d, [bp + 5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if87_exit
_if87_TRUE:
; time_used = TO_FIXED(FROM_FIXED00(warp)); 
  lea d, [bp + -1] ; $time_used
  push d
                
; --- START FUNCTION CALL
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _if87_exit
_if87_exit:
; stardate = stardate + time_used; 
  mov d, _stardate ; $stardate
  push d
                
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $time_used
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (FROM_FIXED(stardate) > time_start + time_up) 
_if88_cond:
                
; --- START FUNCTION CALL
                
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if88_exit
_if88_TRUE:
; end_of_time(); 
                
; --- START FUNCTION CALL
  call end_of_time
  jmp _if88_exit
_if88_exit:
; short_range_scan(); 
                
; --- START FUNCTION CALL
  call short_range_scan
  leave
  ret

maneuver_energy:
  enter 0 ; (push bp; mov bp, sp)
; energy = energy - n + 10; 
  mov d, _energy ; $energy
  push d
                
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $0000000a
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (energy >= 0) 
_if89_cond:
                
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if89_exit
_if89_TRUE:
; return; 
  leave
  ret
  jmp _if89_exit
_if89_exit:
; puts("Shield Control supplies energy to complete maneuver.\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s73 ; "Shield Control supplies energy to complete maneuver.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; shield = shield + energy; 
  mov d, _shield ; $shield
  push d
                
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; energy = 0; 
  mov d, _energy ; $energy
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
; if (shield <= 0) 
_if90_cond:
                
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if90_exit
_if90_TRUE:
; shield = 0; 
  mov d, _shield ; $shield
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if90_exit
_if90_exit:
  leave
  ret

short_range_scan:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; char *sC = "GREEN"; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -5] ; $sC
  push d
                
  mov b, _s74 ; "GREEN"
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (energy < energy0 / 10) 
_if91_cond:
                
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _energy0 ; $energy0
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
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if91_exit
_if91_TRUE:
; sC = "YELLOW"; 
  lea d, [bp + -5] ; $sC
  push d
                
  mov b, _s75 ; "YELLOW"
  pop d
  mov [d], b
  jmp _if91_exit
_if91_exit:
; if (klingons > 0) 
_if93_cond:
                
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
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
  je _if93_exit
_if93_TRUE:
; sC = "*RED*"; 
  lea d, [bp + -5] ; $sC
  push d
                
  mov b, _s76 ; "*RED*"
  pop d
  mov [d], b
  jmp _if93_exit
_if93_exit:
; docked = 0; 
  mov d, _docked ; $docked
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; for (i = (int) (FROM_FIXED00(ship_y) - 1); i <= (int) (FROM_FIXED00(ship_y) + 1); i++) 
_for94_init:
  lea d, [bp + -1] ; $i
  push d
                
                
; --- START FUNCTION CALL
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for94_cond:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
                
; --- START FUNCTION CALL
                
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for94_exit
_for94_block:
; for (j = (int) (FROM_FIXED00(ship_x) - 1); j <= (int) (FROM_FIXED00(ship_x) + 1); j++) 
_for95_init:
  lea d, [bp + -3] ; $j
  push d
                
                
; --- START FUNCTION CALL
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for95_cond:
                
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
                
; --- START FUNCTION CALL
                
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for95_exit
_for95_block:
; if (i >= 1 && i <= 8 && j >= 1 && j <= 8) { 
_if96_cond:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if96_exit
_if96_TRUE:
; if (quad[i+-1][j+-1] == 		2) { 
_if97_cond:
                
  mov d, _quad_data ; $quad
  push a
  push d
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if97_exit
_if97_TRUE:
; docked = 1; 
  mov d, _docked ; $docked
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], bl
; sC = "DOCKED"; 
  lea d, [bp + -5] ; $sC
  push d
                
  mov b, _s77 ; "DOCKED"
  pop d
  mov [d], b
; energy = energy0; 
  mov d, _energy ; $energy
  push d
                
  mov d, _energy0 ; $energy0
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; torps = torps0; 
  mov d, _torps ; $torps
  push d
                
  mov d, _torps0 ; $torps0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; puts("Shields dropped for docking purposes."); 
                
; --- START FUNCTION CALL
                
  mov b, _s78 ; "Shields dropped for docking purposes."
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; shield = 0; 
  mov d, _shield ; $shield
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if97_exit
_if97_exit:
  jmp _if96_exit
_if96_exit:
_for95_update:
                
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for95_cond
_for95_exit:
_for94_update:
                
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for94_cond
_for94_exit:
; if (damage[2] < 0) { 
_if98_cond:
                
  mov d, _damage_data ; $damage
  push a
  push d
                
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if98_exit
_if98_TRUE:
; puts("\n*** Short Range Sensors are out ***"); 
                
; --- START FUNCTION CALL
                
  mov b, _s79 ; "\n*** Short Range Sensors are out ***"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if98_exit
_if98_exit:
; puts(srs_1); 
                
; --- START FUNCTION CALL
                
  mov d, _srs_1 ; $srs_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; for (i = 0; i < 8; i++) { 
_for99_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for99_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for99_exit
_for99_block:
; for (j = 0; j < 8; j++) 
_for100_init:
  lea d, [bp + -3] ; $j
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for100_cond:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for100_exit
_for100_block:
; puts(tilestr[quad[i][j]]); 
                 
; --- START FUNCTION CALL
                 
  mov d, _tilestr_data ; $tilestr
  push a
  push d
                 
  mov d, _quad_data ; $quad
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_for100_update:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for100_cond
_for100_exit:
; if (i == 0) 
_if101_cond:
                 
  lea d, [bp + -1] ; $i
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
  je _if101_exit
_if101_TRUE:
; printf("    Stardate            %d\n", FROM_FIXED(stardate)); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s80 ; "    Stardate            %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if101_exit
_if101_exit:
; if (i == 1) 
_if102_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if102_exit
_if102_TRUE:
; printf("    Condition           %s\n", sC); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -5] ; $sC
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s81 ; "    Condition           %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if102_exit
_if102_exit:
; if (i == 2) 
_if103_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if103_exit
_if103_TRUE:
; printf("    Quadrant            %d, %d\n", quad_y, quad_x); 
                 
; --- START FUNCTION CALL
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s82 ; "    Quadrant            %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
  jmp _if103_exit
_if103_exit:
; if (i == 3) 
_if104_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if104_exit
_if104_TRUE:
; printf("    Sector              %d, %d\n", FROM_FIXED00(ship_y), FROM_FIXED00(ship_x)); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
; --- START FUNCTION CALL
                 
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s83 ; "    Sector              %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
  jmp _if104_exit
_if104_exit:
; if (i == 4) 
_if105_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if105_exit
_if105_TRUE:
; printf("    Photon Torpedoes    %d\n", torps); 
                 
; --- START FUNCTION CALL
                 
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  mov b, _s84 ; "    Photon Torpedoes    %d\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
  jmp _if105_exit
_if105_exit:
; if (i == 5) 
_if106_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if106_exit
_if106_TRUE:
; printf("    Total Energy        %d\n", energy + shield); 
                 
; --- START FUNCTION CALL
                 
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
                 
  mov b, _s85 ; "    Total Energy        %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if106_exit
_if106_exit:
; if (i == 6) 
_if107_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000006
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if107_exit
_if107_TRUE:
; printf("    Shields             %d\n", shield); 
                 
; --- START FUNCTION CALL
                 
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s86 ; "    Shields             %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if107_exit
_if107_exit:
; if (i == 7) 
_if108_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000007
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if108_exit
_if108_TRUE:
; printf("    Klingons Remaining  %d\n", klingons_left); 
                 
; --- START FUNCTION CALL
                 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  mov b, _s87 ; "    Klingons Remaining  %d\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
  jmp _if108_exit
_if108_exit:
_for99_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for99_cond
_for99_exit:
; puts(srs_1); 
                 
; --- START FUNCTION CALL
                 
  mov d, _srs_1 ; $srs_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; putchar('\n'); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret

put1bcd:
  enter 0 ; (push bp; mov bp, sp)
; v = v & 0x0F; 
  lea d, [bp + 5] ; $v
  push d
                 
  lea d, [bp + 5] ; $v
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; putchar('0' + v); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $v
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

putbcd:
  enter 0 ; (push bp; mov bp, sp)
; put1bcd(x >> 8); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push bl
  call put1bcd
  add sp, 1
; --- END FUNCTION CALL
; put1bcd(x >> 4); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push bl
  call put1bcd
  add sp, 1
; --- END FUNCTION CALL
; put1bcd(x); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
  push bl
  call put1bcd
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

long_range_scan:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; if (inoperable(3)) 
_if109_cond:
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000003
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if109_exit
_if109_TRUE:
; return; 
  leave
  ret
  jmp _if109_exit
_if109_exit:
; printf("Long Range Scan for Quadrant %d, %d\n\n", quad_y, quad_x); 
                 
; --- START FUNCTION CALL
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s88 ; "Long Range Scan for Quadrant %d, %d\n\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; for (i = quad_y - 1; i <= quad_y + 1; i++) { 
_for110_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for110_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for110_exit
_for110_block:
; printf("%s:", lrs_1); 
                 
; --- START FUNCTION CALL
                 
  mov d, _lrs_1 ; $lrs_1
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s89 ; "%s:"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; for (j = quad_x - 1; j <= quad_x + 1; j++) { 
_for111_init:
  lea d, [bp + -3] ; $j
  push d
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for111_cond:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for111_exit
_for111_block:
; putchar(' '); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; if (i > 0 && i <= 8 && j > 0 && j <= 8) { 
_if112_cond:
                 
  lea d, [bp + -1] ; $i
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
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
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
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if112_else
_if112_TRUE:
; map[i][j] = map[i][j] |  0x1000		/* Set if this sector was mapped */; 
  mov d, _map_data ; $map
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov d, _map_data ; $map
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00001000
  or b, a ; |
  pop a
  pop d
  mov [d], b
; putbcd(map[i][j]); 
                 
; --- START FUNCTION CALL
                 
  mov d, _map_data ; $map
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call putbcd
  add sp, 2
; --- END FUNCTION CALL
  jmp _if112_exit
_if112_else:
; puts("***"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s90 ; "***"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_if112_exit:
; puts(" :"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s91 ; " :"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_for111_update:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for111_cond
_for111_exit:
; putchar('\n'); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for110_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for110_cond
_for110_exit:
; printf("%s\n", lrs_1); 
                 
; --- START FUNCTION CALL
                 
  mov d, _lrs_1 ; $lrs_1
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s92 ; "%s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

no_klingon:
  enter 0 ; (push bp; mov bp, sp)
; if (klingons <= 0) { 
_if113_cond:
                 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if113_exit
_if113_TRUE:
; puts("Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s93 ; "Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return 1; 
                 
  mov32 cb, $00000001
  leave
  ret
  jmp _if113_exit
_if113_exit:
; return 0; 
                 
  mov32 cb, $00000000
  leave
  ret

wipe_klingon:
  enter 0 ; (push bp; mov bp, sp)
; quad[k->y+-1][k->x+-1] = 		0; 
  mov d, _quad_data ; $quad
  push a
  push d
                 
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                 
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

phaser_control:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; long int phaser_energy; 
  sub sp, 4
; long unsigned int h1; 
  sub sp, 4
; int h; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; k = &kdata; 
  lea d, [bp + -13] ; $k
  push d
                 
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; if (inoperable(4)) 
_if114_cond:
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000004
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if114_exit
_if114_TRUE:
; return; 
  leave
  ret
  jmp _if114_exit
_if114_exit:
; if (no_klingon()) 
_if115_cond:
                 
; --- START FUNCTION CALL
  call no_klingon
  cmp b, 0
  je _if115_exit
_if115_TRUE:
; return; 
  leave
  ret
  jmp _if115_exit
_if115_exit:
; if (damage[8] < 0) 
_if116_cond:
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  mov32 cb, $00000008
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if116_exit
_if116_TRUE:
; puts("Computer failure hampers accuracy."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s94 ; "Computer failure hampers accuracy."
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if116_exit
_if116_exit:
; printf("Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: ", energy); 
                 
; --- START FUNCTION CALL
                 
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s95 ; "Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: "
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; phaser_energy = input_int(); 
  lea d, [bp + -5] ; $phaser_energy
  push d
                 
; --- START FUNCTION CALL
  call input_int
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
; if (phaser_energy <= 0) 
_if117_cond:
                 
  lea d, [bp + -5] ; $phaser_energy
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
  sle
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if117_exit
_if117_TRUE:
; return; 
  leave
  ret
  jmp _if117_exit
_if117_exit:
; if (energy - phaser_energy < 0) { 
_if118_cond:
                 
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub32 ga, cb
  mov b, a
  mov c, g
  pop a
; --- END TERMS
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
  je _if118_exit
_if118_TRUE:
; puts("Not enough energy available.\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s96 ; "Not enough energy available.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if118_exit
_if118_exit:
; energy = energy -  phaser_energy; 
  mov d, _energy ; $energy
  push d
                 
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub32 ga, cb
  mov b, a
  mov c, g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (damage[8] < 0) 
_if119_cond:
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  mov32 cb, $00000008
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if119_else
_if119_TRUE:
; phaser_energy =phaser_energy * get_rand(100); 
  lea d, [bp + -5] ; $phaser_energy
  push d
                 
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
                 
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_120  
  neg a 
skip_invert_a_120:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_120  
  neg b 
skip_invert_b_120:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_120
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_120:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if119_exit
_if119_else:
; phaser_energy = phaser_energy* 100; 
  lea d, [bp + -5] ; $phaser_energy
  push d
                 
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_121  
  neg a 
skip_invert_a_121:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_121  
  neg b 
skip_invert_b_121:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_121
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_121:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
_if119_exit:
; h1 = phaser_energy / klingons; 
  lea d, [bp + -9] ; $h1
  push d
                 
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
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
; for (i = 0; i <= 2; i++) { 
_for123_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for123_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for123_exit
_for123_block:
; if (k->energy > 0) { 
_if124_cond:
                 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
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
  je _if124_exit
_if124_TRUE:
; h1 = h1 * (get_rand(100) + 200); 
  lea d, [bp + -9] ; $h1
  push d
                 
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $000000c8
  add b, a
  pop a
; --- END TERMS
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_125  
  neg a 
skip_invert_a_125:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_125  
  neg b 
skip_invert_b_125:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_125
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_125:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; h1 =h1/ distance_to(k); 
  lea d, [bp + -9] ; $h1
  push d
                 
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
                 
  lea d, [bp + -13] ; $k
  mov b, [d]
  mov c, 0
  swp b
  push b
  call distance_to
  add sp, 2
; --- END FUNCTION CALL
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
; if (h1 <= 15 * k->energy) {	/* was 0.15 */ 
_if127_cond:
                 
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000f
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_128  
  neg a 
skip_invert_a_128:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_128  
  neg b 
skip_invert_b_128:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_128
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_128:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  cmp32 ga, cb
  sleu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if127_else
_if127_TRUE:
; printf("Sensors show no damage to enemy at %d, %d\n\n", k->y, k->x); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  mov b, _s97 ; "Sensors show no damage to enemy at %d, %d\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if127_exit
_if127_else:
; h = FROM_FIXED00(h1); 
  lea d, [bp + -11] ; $h
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; k->energy = k->energy - h; 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  push d
                 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $h
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; printf("%d unit hit on Klingon at sector %d, %d\n", 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  lea d, [bp + -11] ; $h
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s98 ; "%d unit hit on Klingon at sector %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; if (k->energy <= 0) { 
_if129_cond:
                 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if129_else
_if129_TRUE:
; puts("*** Klingon Destroyed ***\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s99 ; "*** Klingon Destroyed ***\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; klingons--; 
                 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _klingons ; $klingons
  mov [d], bl
  inc b
; klingons_left--; 
                 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _klingons_left ; $klingons_left
  mov [d], bl
  inc b
; wipe_klingon(k); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -13] ; $k
  mov b, [d]
  mov c, 0
  swp b
  push b
  call wipe_klingon
  add sp, 2
; --- END FUNCTION CALL
; k->energy = 0; 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; map[quad_y][quad_x] = map[quad_y][quad_x] - 0x100; 
  mov d, _map_data ; $map
  push a
  push d
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov d, _map_data ; $map
  push a
  push d
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000100
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (klingons_left <= 0) 
_if130_cond:
                 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if130_exit
_if130_TRUE:
; won_game(); 
                 
; --- START FUNCTION CALL
  call won_game
  jmp _if130_exit
_if130_exit:
  jmp _if129_exit
_if129_else:
; printf("   (Sensors show %d units remaining.)\n\n", k->energy); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s100 ; "   (Sensors show %d units remaining.)\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if129_exit:
_if127_exit:
  jmp _if124_exit
_if124_exit:
; k++; 
                 
  lea d, [bp + -13] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -13] ; $k
  mov [d], b
  mov b, a
_for123_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for123_cond
_for123_exit:
; klingons_shoot(); 
                 
; --- START FUNCTION CALL
  call klingons_shoot
  leave
  ret

photon_torpedoes:
  enter 0 ; (push bp; mov bp, sp)
; int x3, y3; 
  sub sp, 2
  sub sp, 2
; int c1; 
  sub sp, 2
; int c2, c3, c4; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; int x, y, x1, x2; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; if (torps <= 0) { 
_if131_cond:
                 
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if131_exit
_if131_TRUE:
; puts("All photon torpedoes expended"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s101 ; "All photon torpedoes expended"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if131_exit
_if131_exit:
; if (inoperable(5)) 
_if132_cond:
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000005
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if132_exit
_if132_TRUE:
; return; 
  leave
  ret
  jmp _if132_exit
_if132_exit:
; puts("Course (0-9): "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s63 ; "Course (0-9): "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; c1 = input_f00(); 
  lea d, [bp + -5] ; $c1
  push d
                 
; --- START FUNCTION CALL
  call input_f00
  pop d
  mov [d], b
; if (c1 == 900) 
_if133_cond:
                 
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if133_exit
_if133_TRUE:
; c1 = 100; 
  lea d, [bp + -5] ; $c1
  push d
                 
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if133_exit
_if133_exit:
; if (c1 < 100 || c1 >= 900) { 
_if134_cond:
                 
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if134_exit
_if134_TRUE:
; printf("Ensign Chekov%s", inc_1); 
                 
; --- START FUNCTION CALL
                 
  mov d, _inc_1 ; $inc_1
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s102 ; "Ensign Chekov%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if134_exit
_if134_exit:
; energy = energy - 2; 
  mov d, _energy ; $energy
  push d
                 
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; torps--; 
                 
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _torps ; $torps
  mov [d], bl
  inc b
; c2 = FROM_FIXED00(c1);	/* Integer part */ 
  lea d, [bp + -7] ; $c2
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; c3 = c2 + 1;		/* Next integer part */ 
  lea d, [bp + -9] ; $c3
  push d
                 
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; c4 = (c1 - TO_FIXED00(c2));	/* Fractional element in fixed point */ 
  lea d, [bp + -11] ; $c4
  push d
                 
                 
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
                 
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x1 = 100 * c[1][c2] + (c[1][c3] - c[1][c2]) * c4; 
  lea d, [bp + -17] ; $x1
  push d
                 
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
                 
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                 
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_135  
  neg a 
skip_invert_a_135:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_135  
  neg b 
skip_invert_b_135:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_135
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_135:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
                 
  mov d, _c_data ; $c
  push a
  push d
                 
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                 
  lea d, [bp + -9] ; $c3
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
                 
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                 
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -11] ; $c4
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_136  
  neg a 
skip_invert_a_136:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_136  
  neg b 
skip_invert_b_136:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_136
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_136:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x2 = 100 * c[2][c2] + (c[2][c3] - c[2][c2]) * c4; 
  lea d, [bp + -19] ; $x2
  push d
                 
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
                 
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                 
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_137  
  neg a 
skip_invert_a_137:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_137  
  neg b 
skip_invert_b_137:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_137
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_137:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
                 
  mov d, _c_data ; $c
  push a
  push d
                 
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                 
  lea d, [bp + -9] ; $c3
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
                 
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
                 
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -11] ; $c4
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_138  
  neg a 
skip_invert_a_138:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_138  
  neg b 
skip_invert_b_138:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_138
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_138:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x = ship_y + x1; 
  lea d, [bp + -13] ; $x
  push d
                 
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -17] ; $x1
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; y = ship_x + x2; 
  lea d, [bp + -15] ; $y
  push d
                 
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x2
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x3 = FROM_FIXED00(x); 
  lea d, [bp + -1] ; $x3
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -13] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; y3 = FROM_FIXED00(y); 
  lea d, [bp + -3] ; $y3
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -15] ; $y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; puts("Torpedo Track:"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s103 ; "Torpedo Track:"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; while (x3 >= 1 && x3 <= 8 && y3 >= 1 && y3 <= 8) { 
_while139_cond:
                 
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while139_exit
_while139_block:
; unsigned char p; 
  sub sp, 1
; printf("    %d, %d\n", x3, y3); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s104 ; "    %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; p = quad[x3+-1][y3+-1]; 
  lea d, [bp + -20] ; $p
  push d
                 
  mov d, _quad_data ; $quad
  push a
  push d
                 
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                 
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (p != 		0 && p != 		4) { 
_if140_cond:
                 
  lea d, [bp + -20] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -20] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if140_exit
_if140_TRUE:
; torpedo_hit(x3, y3); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
  push bl
                 
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
  push bl
  call torpedo_hit
  add sp, 2
; --- END FUNCTION CALL
; klingons_shoot(); 
                 
; --- START FUNCTION CALL
  call klingons_shoot
; return; 
  leave
  ret
  jmp _if140_exit
_if140_exit:
; x = x + x1; 
  lea d, [bp + -13] ; $x
  push d
                 
  lea d, [bp + -13] ; $x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -17] ; $x1
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; y = y + x2; 
  lea d, [bp + -15] ; $y
  push d
                 
  lea d, [bp + -15] ; $y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x2
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x3 = FROM_FIXED00(x); 
  lea d, [bp + -1] ; $x3
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -13] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; y3 = FROM_FIXED00(y); 
  lea d, [bp + -3] ; $y3
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -15] ; $y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _while139_cond
_while139_exit:
; puts("Torpedo Missed\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s105 ; "Torpedo Missed\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; klingons_shoot(); 
                 
; --- START FUNCTION CALL
  call klingons_shoot
  leave
  ret

torpedo_hit:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; switch(quad[yp+-1][xp+-1]) { 
_switch141_expr:
                 
  mov d, _quad_data ; $quad
  push a
  push d
                 
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                 
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch141_comparisons:
  cmp b, 1
  je _switch141_case0
  cmp b, 3
  je _switch141_case1
  cmp b, 2
  je _switch141_case2
  jmp _switch141_exit
_switch141_case0:
; printf("Star at %d, %d absorbed torpedo energy.\n\n", yp, xp); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  mov b, _s106 ; "Star at %d, %d absorbed torpedo energy.\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
_switch141_case1:
; puts("*** Klingon Destroyed ***\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s99 ; "*** Klingon Destroyed ***\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; klingons--; 
                 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _klingons ; $klingons
  mov [d], bl
  inc b
; klingons_left--; 
                 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _klingons_left ; $klingons_left
  mov [d], bl
  inc b
; if (klingons_left <= 0) 
_if142_cond:
                 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if142_exit
_if142_TRUE:
; won_game(); 
                 
; --- START FUNCTION CALL
  call won_game
  jmp _if142_exit
_if142_exit:
; k = kdata; 
  lea d, [bp + -3] ; $k
  push d
                 
  mov d, _kdata_data ; $kdata
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; for (i = 0; i <= 2; i++) { 
_for143_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for143_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for143_exit
_for143_block:
; if (yp == k->y && xp == k->x) 
_if144_cond:
                 
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if144_exit
_if144_TRUE:
; k->energy = 0; 
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 2
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if144_exit
_if144_exit:
; k++; 
                 
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, a
_for143_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for143_cond
_for143_exit:
; map[quad_y][quad_x] =map[quad_y][quad_x] - 0x100; 
  mov d, _map_data ; $map
  push a
  push d
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov d, _map_data ; $map
  push a
  push d
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000100
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch141_exit ; case break
_switch141_case2:
; puts("*** Starbase Destroyed ***"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s107 ; "*** Starbase Destroyed ***"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; starbases--; 
                 
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _starbases ; $starbases
  mov [d], bl
  inc b
; starbases_left--; 
                 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _starbases_left ; $starbases_left
  mov [d], bl
  inc b
; if (starbases_left <= 0 && klingons_left <= FROM_FIXED(stardate) - time_start - time_up) { 
_if145_cond:
                 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
; --- START FUNCTION CALL
                 
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if145_exit
_if145_TRUE:
; puts("That does it, Captain!!"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s108 ; "That does it, Captain!!"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("You are hereby relieved of command\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s109 ; "You are hereby relieved of command\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("and sentenced to 99 stardates of hard"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s110 ; "and sentenced to 99 stardates of hard"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("labor on Cygnus 12!!\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s111 ; "labor on Cygnus 12!!\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; resign_commision(); 
                 
; --- START FUNCTION CALL
  call resign_commision
  jmp _if145_exit
_if145_exit:
; puts("Starfleet Command reviewing your record to consider\n court martial!\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s112 ; "Starfleet Command reviewing your record to consider\n court martial!\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; docked = 0;		/* Undock */ 
  mov d, _docked ; $docked
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; map[quad_y][quad_x] =map[quad_y][quad_x] - 0x10; 
  mov d, _map_data ; $map
  push a
  push d
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov d, _map_data ; $map
  push a
  push d
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000010
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch141_exit ; case break
_switch141_exit:
; quad[yp+-1][xp+-1] = 		0; 
  mov d, _quad_data ; $quad
  push a
  push d
                 
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                 
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

damage_control:
  enter 0 ; (push bp; mov bp, sp)
; int repair_cost = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $repair_cost
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i; 
  sub sp, 2
; if (damage[6] < 0) 
_if146_cond:
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  mov32 cb, $00000006
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if146_exit
_if146_TRUE:
; puts("Damage Control report not available."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s113 ; "Damage Control report not available."
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if146_exit
_if146_exit:
; if (docked) { 
_if147_cond:
                 
  mov d, _docked ; $docked
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if147_exit
_if147_TRUE:
; repair_cost = 0; 
  lea d, [bp + -1] ; $repair_cost
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; for (i = 1; i <= 8; i++) 
_for148_init:
  lea d, [bp + -3] ; $i
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
_for148_cond:
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for148_exit
_for148_block:
; if (damage[i] < 0) 
_if149_cond:
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if149_exit
_if149_TRUE:
; repair_cost = repair_cost + 10; 
  lea d, [bp + -1] ; $repair_cost
  push d
                 
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $0000000a
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if149_exit
_if149_exit:
_for148_update:
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for148_cond
_for148_exit:
; if (repair_cost) { 
_if150_cond:
                 
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if150_exit
_if150_TRUE:
; repair_cost = repair_cost + d4; 
  lea d, [bp + -1] ; $repair_cost
  push d
                 
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _d4 ; $d4
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (repair_cost >= 100) 
_if151_cond:
                 
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if151_exit
_if151_TRUE:
; repair_cost = 90;	/* 0.9 */ 
  lea d, [bp + -1] ; $repair_cost
  push d
                 
  mov32 cb, $0000005a
  pop d
  mov [d], b
  jmp _if151_exit
_if151_exit:
; printf("\nTechnicians standing by to effect repairs to your ship;\nEstimated time to repair: %s stardates.\n Will you authorize the repair order (y/N)? ", print100(repair_cost)); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s114 ; "\nTechnicians standing by to effect repairs to your ship;\nEstimated time to repair: %s stardates.\n Will you authorize the repair order (y/N)? "
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; if (yesno()) { 
_if152_cond:
                 
; --- START FUNCTION CALL
  call yesno
  cmp b, 0
  je _if152_exit
_if152_TRUE:
; for (i = 1; i <= 8; i++) 
_for153_init:
  lea d, [bp + -3] ; $i
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
_for153_cond:
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for153_exit
_for153_block:
; if (damage[i] < 0) 
_if154_cond:
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if154_exit
_if154_TRUE:
; damage[i] = 0; 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if154_exit
_if154_exit:
_for153_update:
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for153_cond
_for153_exit:
; stardate = stardate + (repair_cost + 5)/10 + 1; 
  mov d, _stardate ; $stardate
  push d
                 
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                 
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000005
  add b, a
  pop a
; --- END TERMS
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
  add b, a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if152_exit
_if152_exit:
; return; 
  leave
  ret
  jmp _if150_exit
_if150_exit:
  jmp _if147_exit
_if147_exit:
; if (damage[6] < 0) 
_if156_cond:
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  mov32 cb, $00000006
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if156_exit
_if156_TRUE:
; return; 
  leave
  ret
  jmp _if156_exit
_if156_exit:
; puts("Device            State of Repair"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s115 ; "Device            State of Repair"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; for (i = 1; i <= 8; i++) 
_for157_init:
  lea d, [bp + -3] ; $i
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
_for157_cond:
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for157_exit
_for157_block:
; printf("%-25s%6s\n", get_device_name(i), print100(damage[i])); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s116 ; "%-25s%6s\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
_for157_update:
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for157_cond
_for157_exit:
; printf("\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s117 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

shield_control:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; if (inoperable(7)) 
_if158_cond:
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000007
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if158_exit
_if158_TRUE:
; return; 
  leave
  ret
  jmp _if158_exit
_if158_exit:
; printf("Energy available = %d\n\n Input number of units to shields: ", energy + shield); 
                 
; --- START FUNCTION CALL
                 
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
                 
  mov b, _s118 ; "Energy available = %d\n\n Input number of units to shields: "
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; i = input_int(); 
  lea d, [bp + -1] ; $i
  push d
                 
; --- START FUNCTION CALL
  call input_int
  pop d
  mov [d], b
; if (i < 0 || shield == i) { 
_if159_cond:
                 
  lea d, [bp + -1] ; $i
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
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if159_exit
_if159_TRUE:
; puts("<Shields Unchanged>\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s119 ; "<Shields Unchanged>\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if159_exit
_if159_exit:
; if (i >= energy + shield) { 
_if160_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if160_exit
_if160_TRUE:
; puts("Shield Control Reports:\n  'This is not the Federation Treasury.'"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s120 ; "Shield Control Reports:\n  'This is not the Federation Treasury.'"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if160_exit
_if160_exit:
; energy = energy + shield - i; 
  mov d, _energy ; $energy
  push d
                 
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  add b, a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; shield = i; 
  mov d, _shield ; $shield
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; printf("Deflector Control Room report:\n  'Shields now at %d units per your command.'\n\n", shield); 
                 
; --- START FUNCTION CALL
                 
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s121 ; "Deflector Control Room report:\n  'Shields now at %d units per your command.'\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

library_computer:
  enter 0 ; (push bp; mov bp, sp)
; if (inoperable(8)) 
_if161_cond:
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000008
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if161_exit
_if161_TRUE:
; return; 
  leave
  ret
  jmp _if161_exit
_if161_exit:
; puts("Computer active and awating command: "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s122 ; "Computer active and awating command: "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; switch(input_int()) { 
_switch162_expr:
                 
; --- START FUNCTION CALL
  call input_int
_switch162_comparisons:
  cmp b, -1
  je _switch162_case0
  cmp b, 0
  je _switch162_case1
  cmp b, 1
  je _switch162_case2
  cmp b, 2
  je _switch162_case3
  cmp b, 3
  je _switch162_case4
  cmp b, 4
  je _switch162_case5
  cmp b, 5
  je _switch162_case6
  jmp _switch162_default
  jmp _switch162_exit
_switch162_case0:
; break; 
  jmp _switch162_exit ; case break
_switch162_case1:
; galactic_record(); 
                 
; --- START FUNCTION CALL
  call galactic_record
; break; 
  jmp _switch162_exit ; case break
_switch162_case2:
; status_report(); 
                 
; --- START FUNCTION CALL
  call status_report
; break; 
  jmp _switch162_exit ; case break
_switch162_case3:
; torpedo_data(); 
                 
; --- START FUNCTION CALL
  call torpedo_data
; break; 
  jmp _switch162_exit ; case break
_switch162_case4:
; nav_data(); 
                 
; --- START FUNCTION CALL
  call nav_data
; break; 
  jmp _switch162_exit ; case break
_switch162_case5:
; dirdist_calc(); 
                 
; --- START FUNCTION CALL
  call dirdist_calc
; break; 
  jmp _switch162_exit ; case break
_switch162_case6:
; galaxy_map(); 
                 
; --- START FUNCTION CALL
  call galaxy_map
; break; 
  jmp _switch162_exit ; case break
_switch162_default:
; puts("Functions available from Library-Computer:\n\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s123 ; "Functions available from Library-Computer:\n\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   0 = Cumulative Galactic Record\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s124 ; "   0 = Cumulative Galactic Record\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   1 = Status Report\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s125 ; "   1 = Status Report\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   2 = Photon Torpedo Data\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s126 ; "   2 = Photon Torpedo Data\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   3 = Starbase Nav Data\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s127 ; "   3 = Starbase Nav Data\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   4 = Direction/Distance Calculator\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s128 ; "   4 = Direction/Distance Calculator\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   5 = Galaxy 'Region Name' Map\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s129 ; "   5 = Galaxy 'Region Name' Map\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_switch162_exit:
  leave
  ret

galactic_record:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; printf("\n     Computer Record of Galaxy for Quadrant %d,%d\n\n", quad_y, quad_x); 
                 
; --- START FUNCTION CALL
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s130 ; "\n     Computer Record of Galaxy for Quadrant %d,%d\n\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; puts("     1     2     3     4     5     6     7     8"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s131 ; "     1     2     3     4     5     6     7     8"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; for (i = 1; i <= 8; i++) { 
_for163_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
_for163_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for163_exit
_for163_block:
; printf("%s%d", gr_1, i); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s132 ; "%s%d"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; for (j = 1; j <= 8; j++) { 
_for164_init:
  lea d, [bp + -3] ; $j
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
_for164_cond:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for164_exit
_for164_block:
; printf("   "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s25 ; "   "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; if (map[i][j] &  0x1000		/* Set if this sector was mapped */) 
_if165_cond:
                 
  mov d, _map_data ; $map
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00001000
  and b, a ; &
  pop a
  cmp b, 0
  je _if165_else
_if165_TRUE:
; putbcd(map[i][j]); 
                 
; --- START FUNCTION CALL
                 
  mov d, _map_data ; $map
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call putbcd
  add sp, 2
; --- END FUNCTION CALL
  jmp _if165_exit
_if165_else:
; printf("***"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s90 ; "***"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
_if165_exit:
_for164_update:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for164_cond
_for164_exit:
; putchar('\n'); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for163_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for163_cond
_for163_exit:
; printf("%s\n", gr_1); 
                 
; --- START FUNCTION CALL
                 
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s92 ; "%s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

status_report:
  enter 0 ; (push bp; mov bp, sp)
; char *plural; 
  sub sp, 2
; plural = str_s + 1; 
  lea d, [bp + -1] ; $plural
  push d
                 
  mov d, _str_s ; $str_s
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; unsigned int left; 
  sub sp, 2
; left = TO_FIXED(time_start + time_up) - stardate; 
  lea d, [bp + -3] ; $left
  push d
                 
; --- START FUNCTION CALL
                 
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; puts("   Status Report:\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s133 ; "   Status Report:\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; if (klingons_left > 1) 
_if166_cond:
                 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if166_exit
_if166_TRUE:
; plural = str_s; 
  lea d, [bp + -1] ; $plural
  push d
                 
  mov d, _str_s ; $str_s
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if166_exit
_if166_exit:
; printf("Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n", 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $left
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
  swp b
  push b
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $left
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  lea d, [bp + -1] ; $plural
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s134 ; "Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n"
  swp b
  push b
  call printf
  add sp, 9
; --- END FUNCTION CALL
; if (starbases_left < 1) { 
_if168_cond:
                 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if168_else
_if168_TRUE:
; puts("Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s135 ; "Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if168_exit
_if168_else:
; plural = str_s; 
  lea d, [bp + -1] ; $plural
  push d
                 
  mov d, _str_s ; $str_s
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; if (starbases_left < 2) 
_if169_cond:
                 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if169_exit
_if169_TRUE:
; plural++; 
                 
  lea d, [bp + -1] ; $plural
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $plural
  mov [d], b
  dec b
  jmp _if169_exit
_if169_exit:
; printf("The Federation is maintaining %d starbase%s in the galaxy\n\n", starbases_left, plural); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -1] ; $plural
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  mov b, _s136 ; "The Federation is maintaining %d starbase%s in the galaxy\n\n"
  swp b
  push b
  call printf
  add sp, 5
; --- END FUNCTION CALL
_if168_exit:
  leave
  ret

torpedo_data:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; char *plural; 
  sub sp, 2
; plural = str_s + 1; 
  lea d, [bp + -3] ; $plural
  push d
                 
  mov d, _str_s ; $str_s
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; struct klingon *k; 
  sub sp, 2
; if (no_klingon()) 
_if170_cond:
                 
; --- START FUNCTION CALL
  call no_klingon
  cmp b, 0
  je _if170_exit
_if170_TRUE:
; return; 
  leave
  ret
  jmp _if170_exit
_if170_exit:
; if (klingons > 1) 
_if171_cond:
                 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if171_exit
_if171_TRUE:
; plural--; 
                 
  lea d, [bp + -3] ; $plural
  mov b, [d]
  mov c, 0
  dec b
  lea d, [bp + -3] ; $plural
  mov [d], b
  inc b
  jmp _if171_exit
_if171_exit:
; printf("From Enterprise to Klingon battlecriuser%s:\n\n", plural); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $plural
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s137 ; "From Enterprise to Klingon battlecriuser%s:\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; k = kdata; 
  lea d, [bp + -5] ; $k
  push d
                 
  mov d, _kdata_data ; $kdata
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; for (i = 0; i <= 2; i++) { 
_for172_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for172_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for172_exit
_for172_block:
; if (k->energy > 0) { 
_if173_cond:
                 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
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
  je _if173_exit
_if173_TRUE:
; compute_vector(TO_FIXED00(k->y), 
                 
; --- START FUNCTION CALL
                 
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call compute_vector
  add sp, 8
; --- END FUNCTION CALL
  jmp _if173_exit
_if173_exit:
; k++; 
                 
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
_for172_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for172_cond
_for172_exit:
  leave
  ret

nav_data:
  enter 0 ; (push bp; mov bp, sp)
; if (starbases <= 0) { 
_if174_cond:
                 
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if174_exit
_if174_TRUE:
; puts("Mr. Spock reports,\n  'Sensors show no starbases in this quadrant.'\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s138 ; "Mr. Spock reports,\n  'Sensors show no starbases in this quadrant.'\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if174_exit
_if174_exit:
; compute_vector(TO_FIXED00(base_y), TO_FIXED00(base_x), ship_y, ship_x); 
                 
; --- START FUNCTION CALL
                 
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
; --- START FUNCTION CALL
                 
  mov d, _base_x ; $base_x
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
; --- START FUNCTION CALL
                 
  mov d, _base_y ; $base_y
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call compute_vector
  add sp, 8
; --- END FUNCTION CALL
  leave
  ret

dirdist_calc:
  enter 0 ; (push bp; mov bp, sp)
; int c1, a, w1, x; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; printf("Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: ", 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
; --- START FUNCTION CALL
                 
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s139 ; "Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: "
  swp b
  push b
  call printf
  add sp, 10
; --- END FUNCTION CALL
; c1 = TO_FIXED00(input_int()); 
  lea d, [bp + -1] ; $c1
  push d
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (c1 < 0 || c1 > 900 ) 
_if175_cond:
                 
  lea d, [bp + -1] ; $c1
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if175_exit
_if175_TRUE:
; return; 
  leave
  ret
  jmp _if175_exit
_if175_exit:
; puts("Please enter initial Y coordinate: "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s140 ; "Please enter initial Y coordinate: "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; a = TO_FIXED00(input_int()); 
  lea d, [bp + -3] ; $a
  push d
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (a < 0 || a > 900) 
_if176_cond:
                 
  lea d, [bp + -3] ; $a
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if176_exit
_if176_TRUE:
; return; 
  leave
  ret
  jmp _if176_exit
_if176_exit:
; puts("Please enter final X coordinate: "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s141 ; "Please enter final X coordinate: "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; w1 = TO_FIXED00(input_int()); 
  lea d, [bp + -5] ; $w1
  push d
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (w1 < 0 || w1 > 900) 
_if177_cond:
                 
  lea d, [bp + -5] ; $w1
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -5] ; $w1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if177_exit
_if177_TRUE:
; return; 
  leave
  ret
  jmp _if177_exit
_if177_exit:
; puts("Please enter final Y coordinate: "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s142 ; "Please enter final Y coordinate: "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; x = TO_FIXED00(input_int()); 
  lea d, [bp + -7] ; $x
  push d
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (x < 0 || x > 900) 
_if178_cond:
                 
  lea d, [bp + -7] ; $x
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -7] ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if178_exit
_if178_TRUE:
; return; 
  leave
  ret
  jmp _if178_exit
_if178_exit:
; compute_vector(w1, x, c1, a); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $a
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  lea d, [bp + -1] ; $c1
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  lea d, [bp + -7] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  lea d, [bp + -5] ; $w1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call compute_vector
  add sp, 8
; --- END FUNCTION CALL
  leave
  ret

galaxy_map:
  enter 0 ; (push bp; mov bp, sp)
; int i, j, j0; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; printf("\n                   The Galaxy\n\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s143 ; "\n                   The Galaxy\n\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; printf("    1     2     3     4     5     6     7     8\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s144 ; "    1     2     3     4     5     6     7     8\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for (i = 1; i <= 8; i++) { 
_for179_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
_for179_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for179_exit
_for179_block:
; printf("%s%d ", gm_1, i); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _gm_1 ; $gm_1
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s145 ; "%s%d "
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; quadrant_name(1, i, 1); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000001
  push bl
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  push bl
                 
  mov32 cb, $00000001
  push bl
  call quadrant_name
  add sp, 3
; --- END FUNCTION CALL
; j0 = (int) (11 - (strlen(quadname) / 2)); 
  lea d, [bp + -5] ; $j0
  push d
                 
                 
  mov32 cb, $0000000b
; --- START TERMS
  push a
  mov a, b
                 
; --- START FUNCTION CALL
                 
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for (j = 0; j < j0; j++) 
_for181_init:
  lea d, [bp + -3] ; $j
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for181_cond:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for181_exit
_for181_block:
; putchar(' '); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for181_update:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for181_cond
_for181_exit:
; puts(quadname); 
                 
; --- START FUNCTION CALL
                 
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; for (j = 0; j < j0; j++) 
_for182_init:
  lea d, [bp + -3] ; $j
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for182_cond:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for182_exit
_for182_block:
; putchar(' '); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for182_update:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for182_cond
_for182_exit:
; if (!(strlen(quadname) % 2)) 
_if183_cond:
                 
                 
; --- START FUNCTION CALL
                 
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  cmp b, 0
  je _if183_exit
_if183_TRUE:
; putchar(' '); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if183_exit
_if183_exit:
; quadrant_name(1, i, 5); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000005
  push bl
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  push bl
                 
  mov32 cb, $00000001
  push bl
  call quadrant_name
  add sp, 3
; --- END FUNCTION CALL
; j0 = (int) (12 - (strlen(quadname) / 2)); 
  lea d, [bp + -5] ; $j0
  push d
                 
                 
  mov32 cb, $0000000c
; --- START TERMS
  push a
  mov a, b
                 
; --- START FUNCTION CALL
                 
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for (j = 0; j < j0; j++) 
_for186_init:
  lea d, [bp + -3] ; $j
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for186_cond:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for186_exit
_for186_block:
; putchar(' '); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for186_update:
                 
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for186_cond
_for186_exit:
; puts(quadname); 
                 
; --- START FUNCTION CALL
                 
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_for179_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for179_cond
_for179_exit:
; puts(gm_1); 
                 
; --- START FUNCTION CALL
                 
  mov d, _gm_1 ; $gm_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

compute_vector:
  enter 0 ; (push bp; mov bp, sp)
; long unsigned int xl, al; 
  sub sp, 4
  sub sp, 4
; puts("  DIRECTION = "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s146 ; "  DIRECTION = "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; x = x - a; 
  lea d, [bp + 7] ; $x
  push d
                 
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; a = c1 - w1; 
  lea d, [bp + 11] ; $a
  push d
                 
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $w1
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; xl = abs(x); 
  lea d, [bp + -3] ; $xl
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call abs
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
; al = abs(a); 
  lea d, [bp + -7] ; $al
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call abs
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
; if (x < 0) { 
_if187_cond:
                 
  lea d, [bp + 7] ; $x
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
  je _if187_else
_if187_TRUE:
; if (a > 0) { 
_if188_cond:
                 
  lea d, [bp + 11] ; $a
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
  je _if188_else
_if188_TRUE:
; c1 = 300; 
  lea d, [bp + 9] ; $c1
  push d
                 
  mov32 cb, $0000012c
  pop d
  mov [d], b
; if (al >= xl) 
_if189_cond:
                 
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  cmp32 ga, cb
  sgeu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if189_else
_if189_TRUE:
; printf("%s", print100(c1 + ((xl * 100) / al))); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                 
                 
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_190  
  neg a 
skip_invert_a_190:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_190  
  neg b 
skip_invert_b_190:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_190
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_190:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop a
; --- END TERMS
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s147 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if189_exit
_if189_else:
; printf("%s", print100(c1 + ((((xl * 2) - al) * 100)  / xl))); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                 
                 
                 
                 
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_192  
  neg a 
skip_invert_a_192:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_192  
  neg b 
skip_invert_b_192:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_192
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_192:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub32 ga, cb
  mov b, a
  mov c, g
  pop g
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_193  
  neg a 
skip_invert_a_193:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_193  
  neg b 
skip_invert_b_193:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_193
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_193:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop a
; --- END TERMS
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s147 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if189_exit:
; printf(dist_1, print100((x > a) ? x : a)); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
_ternary195_cond:
                 
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary195_FALSE
_ternary195_TRUE:
                 
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
  jmp _ternary195_exit
_ternary195_FALSE:
                 
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
_ternary195_exit:
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov d, _dist_1 ; $dist_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if188_exit
_if188_else:
; if (x != 0){ 
_if196_cond:
                 
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if196_else
_if196_TRUE:
; c1 = 500; 
  lea d, [bp + 9] ; $c1
  push d
                 
  mov32 cb, $000001f4
  pop d
  mov [d], b
; return; 
  leave
  ret
  jmp _if196_exit
_if196_else:
; c1 = 700; 
  lea d, [bp + 9] ; $c1
  push d
                 
  mov32 cb, $000002bc
  pop d
  mov [d], b
_if196_exit:
_if188_exit:
  jmp _if187_exit
_if187_else:
; if (a < 0) { 
_if197_cond:
                 
  lea d, [bp + 11] ; $a
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
  je _if197_else
_if197_TRUE:
; c1 = 700; 
  lea d, [bp + 9] ; $c1
  push d
                 
  mov32 cb, $000002bc
  pop d
  mov [d], b
  jmp _if197_exit
_if197_else:
; if (x > 0) { 
_if198_cond:
                 
  lea d, [bp + 7] ; $x
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
  je _if198_else
_if198_TRUE:
; c1 = 100; 
  lea d, [bp + 9] ; $c1
  push d
                 
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if198_exit
_if198_else:
; if (a == 0) { 
_if199_cond:
                 
  lea d, [bp + 11] ; $a
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
  je _if199_else
_if199_TRUE:
; c1 = 500; 
  lea d, [bp + 9] ; $c1
  push d
                 
  mov32 cb, $000001f4
  pop d
  mov [d], b
  jmp _if199_exit
_if199_else:
; c1 = 100; 
  lea d, [bp + 9] ; $c1
  push d
                 
  mov32 cb, $00000064
  pop d
  mov [d], b
; if (al <= xl) 
_if200_cond:
                 
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  cmp32 ga, cb
  sleu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if200_else
_if200_TRUE:
; printf("%s", print100(c1 + ((al * 100) / xl))); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                 
                 
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_201  
  neg a 
skip_invert_a_201:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_201  
  neg b 
skip_invert_b_201:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_201
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_201:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop a
; --- END TERMS
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s147 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if200_exit
_if200_else:
; printf("%s", print100(c1 + ((((al * 2) - xl) * 100) / al))); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                 
                 
                 
                 
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_203  
  neg a 
skip_invert_a_203:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_203  
  neg b 
skip_invert_b_203:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_203
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_203:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub32 ga, cb
  mov b, a
  mov c, g
  pop g
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_204  
  neg a 
skip_invert_a_204:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_204  
  neg b 
skip_invert_b_204:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_204
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_204:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop a
; --- END TERMS
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s147 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if200_exit:
; printf(dist_1, print100((xl > al) ? xl : al)); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
_ternary206_cond:
                 
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  cmp32 ga, cb
  sgu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary206_FALSE
_ternary206_TRUE:
                 
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  jmp _ternary206_exit
_ternary206_FALSE:
                 
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
_ternary206_exit:
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov d, _dist_1 ; $dist_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if199_exit:
_if198_exit:
_if197_exit:
_if187_exit:
  leave
  ret

ship_destroyed:
  enter 0 ; (push bp; mov bp, sp)
; puts("The Enterprise has been destroyed. The Federation will be conquered.\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s148 ; "The Enterprise has been destroyed. The Federation will be conquered.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; end_of_time(); 
                 
; --- START FUNCTION CALL
  call end_of_time
  leave
  ret

end_of_time:
  enter 0 ; (push bp; mov bp, sp)
; printf("It is stardate %d.\n\n",  FROM_FIXED(stardate)); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s149 ; "It is stardate %d.\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; resign_commision(); 
                 
; --- START FUNCTION CALL
  call resign_commision
  leave
  ret

resign_commision:
  enter 0 ; (push bp; mov bp, sp)
; printf("There were %d Klingon Battlecruisers left at the end of your mission.\n\n", klingons_left); 
                 
; --- START FUNCTION CALL
                 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  mov b, _s150 ; "There were %d Klingon Battlecruisers left at the end of your mission.\n\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; end_of_game(); 
                 
; --- START FUNCTION CALL
  call end_of_game
  leave
  ret

won_game:
  enter 0 ; (push bp; mov bp, sp)
; puts("Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s151 ; "Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; if (FROM_FIXED(stardate) - time_start > 0) 
_if207_cond:
                 
; --- START FUNCTION CALL
                 
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if207_exit
_if207_TRUE:
; printf("Your efficiency rating is %s\n", 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  mov d, _total_klingons ; $total_klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
                 
; --- START FUNCTION CALL
                 
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  swp b
  push b
  call square00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s152 ; "Your efficiency rating is %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if207_exit
_if207_exit:
; end_of_game(); 
                 
; --- START FUNCTION CALL
  call end_of_game
  leave
  ret

end_of_game:
  enter 0 ; (push bp; mov bp, sp)
; char x[4]; 
  sub sp, 4
; if (starbases_left > 0) { 
_if209_cond:
                 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
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
  je _if209_exit
_if209_TRUE:
; puts("The Federation is in need of a new starship commander"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s153 ; "The Federation is in need of a new starship commander"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts(" for a similar mission.\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s154 ; " for a similar mission.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("If there is a volunteer, let him step forward and"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s155 ; "If there is a volunteer, let him step forward and"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts(" enter 'aye': "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s156 ; " enter 'aye': "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; input(x,4); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000004
  push bl
                 
  lea d, [bp + -3] ; $x
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
  jmp _if209_exit
_if209_exit:
; exit(); 
                 
; --- START FUNCTION CALL
  call exit
  leave
  ret

klingons_move:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; k = &kdata; 
  lea d, [bp + -3] ; $k
  push d
                 
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; for (i = 0; i <= 2; i++) { 
_for210_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for210_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for210_exit
_for210_block:
; if (k->energy > 0) { 
_if211_cond:
                 
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 2
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
  je _if211_exit
_if211_TRUE:
; wipe_klingon(k); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  swp b
  push b
  call wipe_klingon
  add sp, 2
; --- END FUNCTION CALL
; find_set_empty_place(	3, k->y, k->x); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
                 
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
                 
  mov32 cb, $00000003
  push bl
  call find_set_empty_place
  add sp, 5
; --- END FUNCTION CALL
  jmp _if211_exit
_if211_exit:
; k++; 
                 
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, a
_for210_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for210_cond
_for210_exit:
; klingons_shoot(); 
                 
; --- START FUNCTION CALL
  call klingons_shoot
  leave
  ret

klingons_shoot:
  enter 0 ; (push bp; mov bp, sp)
; unsigned char r; 
  sub sp, 1
; long unsigned int h; 
  sub sp, 4
; unsigned char i; 
  sub sp, 1
; struct klingon *k; 
  sub sp, 2
; long unsigned int ratio; 
  sub sp, 4
; k = &kdata; 
  lea d, [bp + -7] ; $k
  push d
                 
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; if (klingons <= 0) 
_if212_cond:
                 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if212_exit
_if212_TRUE:
; return; 
  leave
  ret
  jmp _if212_exit
_if212_exit:
; if (docked) { 
_if213_cond:
                 
  mov d, _docked ; $docked
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if213_exit
_if213_TRUE:
; puts("Starbase shields protect the Enterprise\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s157 ; "Starbase shields protect the Enterprise\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if213_exit
_if213_exit:
; for (i = 0; i <= 2; i++) { 
_for214_init:
  lea d, [bp + -5] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
_for214_cond:
                 
  lea d, [bp + -5] ; $i
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for214_exit
_for214_block:
; if (k->energy > 0) { 
_if215_cond:
                 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
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
  je _if215_exit
_if215_TRUE:
; h = k->energy * (200UL + get_rand(100)); 
  lea d, [bp + -4] ; $h
  push d
                 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
                 
  mov32 cb, $000000c8
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
                 
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_216  
  neg a 
skip_invert_a_216:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_216  
  neg b 
skip_invert_b_216:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_216
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_216:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; h =h* 100;	/* Ready for division in fixed */ 
  lea d, [bp + -4] ; $h
  push d
                 
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_217  
  neg a 
skip_invert_a_217:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_217  
  neg b 
skip_invert_b_217:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_217
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_217:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; h =h/ distance_to(k); 
  lea d, [bp + -4] ; $h
  push d
                 
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
                 
  lea d, [bp + -7] ; $k
  mov b, [d]
  mov c, 0
  swp b
  push b
  call distance_to
  add sp, 2
; --- END FUNCTION CALL
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
; shield = shield - FROM_FIXED00(h); 
  mov d, _shield ; $shield
  push d
                 
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
                 
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; k->energy = (k->energy * 100) / (300 + get_rand(100)); 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  push d
                 
                 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_219  
  neg a 
skip_invert_a_219:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_219  
  neg b 
skip_invert_b_219:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_219
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_219:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
                 
  mov32 cb, $0000012c
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
                 
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
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
; printf("%d unit hit on Enterprise from sector %d, %d\n", (unsigned)FROM_FIXED00(h), k->y, k->x); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp a
  push b
                 
                 
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  swp b
  push b
                 
  mov b, _s158 ; "%d unit hit on Enterprise from sector %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; if (shield <= 0) { 
_if221_cond:
                 
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if221_exit
_if221_TRUE:
; putchar('\n'); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; ship_destroyed(); 
                 
; --- START FUNCTION CALL
  call ship_destroyed
  jmp _if221_exit
_if221_exit:
; printf("    <Shields down to %d units>\n\n", shield); 
                 
; --- START FUNCTION CALL
                 
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s159 ; "    <Shields down to %d units>\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; if (h >= 20) { 
_if222_cond:
                 
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000014
  cmp32 ga, cb
  sgeu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if222_exit
_if222_TRUE:
; ratio = ((int)h)/shield; 
  lea d, [bp + -11] ; $ratio
  push d
                 
                 
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
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
  mov b, 0
  mov [d + 2], b
; if (get_rand(10) <= 6 && ratio > 2) { 
_if224_cond:
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $0000000a
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000006
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -11] ; $ratio
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  cmp32 ga, cb
  sgu
  pop g
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if224_exit
_if224_TRUE:
; r = rand8(); 
  lea d, [bp + 0] ; $r
  push d
                 
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; damage[r] =damage[r] - ratio + get_rand(50); 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $ratio
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub32 ga, cb
  mov b, a
  mov c, g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
                 
  mov32 cb, $00000032
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add32 cb, ga
  pop a
; --- END TERMS
  pop d
  mov [d], b
; printf("Damage Control reports\n'%s' damaged by hit\n\n", get_device_name(r)); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s160 ; "Damage Control reports\n'%s' damaged by hit\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if224_exit
_if224_exit:
  jmp _if222_exit
_if222_exit:
  jmp _if215_exit
_if215_exit:
; k++; 
                 
  lea d, [bp + -7] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -7] ; $k
  mov [d], b
  mov b, a
_for214_update:
                 
  lea d, [bp + -5] ; $i
  mov bl, [d]
  mov bh, 0
  mov c, 0
  inc b
  lea d, [bp + -5] ; $i
  mov [d], bl
  dec b
  jmp _for214_cond
_for214_exit:
  leave
  ret

repair_damage:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int d1; 
  sub sp, 2
; unsigned int repair_factor;		/* Repair Factor */ 
  sub sp, 2
; repair_factor = warp; 
  lea d, [bp + -5] ; $repair_factor
  push d
                 
  lea d, [bp + 5] ; $warp
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; if (warp >= 100) 
_if225_cond:
                 
  lea d, [bp + 5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if225_exit
_if225_TRUE:
; repair_factor = TO_FIXED00(1); 
  lea d, [bp + -5] ; $repair_factor
  push d
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000001
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _if225_exit
_if225_exit:
; for (i = 1; i <= 8; i++) { 
_for226_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
_for226_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for226_exit
_for226_block:
; if (damage[i] < 0) { 
_if227_cond:
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _if227_exit
_if227_TRUE:
; damage[i] = damage[i] + repair_factor; 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $repair_factor
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (damage[i] > -10 && damage[i] < 0)	/* -0.1 */ 
_if228_cond:
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $fffffff6
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if228_else
_if228_TRUE:
; damage[i] = -10; 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov32 cb, $fffffff6
  pop d
  mov [d], b
  jmp _if228_exit
_if228_else:
; if (damage[i] >= 0) { 
_if229_cond:
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if229_exit
_if229_TRUE:
; if (d1 != 1) { 
_if230_cond:
                 
  lea d, [bp + -3] ; $d1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if230_exit
_if230_TRUE:
; d1 = 1; 
  lea d, [bp + -3] ; $d1
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
; puts(dcr_1); 
                 
; --- START FUNCTION CALL
                 
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if230_exit
_if230_exit:
; printf("    %s repair completed\n\n", 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s161 ; "    %s repair completed\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; damage[i] = 0; 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if229_exit
_if229_exit:
_if228_exit:
  jmp _if227_exit
_if227_exit:
_for226_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for226_cond
_for226_exit:
; unsigned char r; 
  sub sp, 1
; if (get_rand(10) <= 2) { 
_if231_cond:
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $0000000a
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if231_exit
_if231_TRUE:
; r = rand8(); 
  lea d, [bp + -6] ; $r
  push d
                 
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; if (get_rand(10) < 6) { 
_if232_cond:
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $0000000a
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000006
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if232_else
_if232_TRUE:
; damage[r] =damage[r]- (get_rand(500) + 100); 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $000001f4
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000064
  add b, a
  pop a
; --- END TERMS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; puts(dcr_1); 
                 
; --- START FUNCTION CALL
                 
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; printf("    %s damaged\n\n", get_device_name(r)); 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s162 ; "    %s damaged\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if232_exit
_if232_else:
; damage[r] = damage[r] + get_rand(300) + 100; 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov d, _damage_data ; $damage
  push a
  push d
                 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
                 
  mov32 cb, $0000012c
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  mov a, b
  mov32 cb, $00000064
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; puts(dcr_1); 
                 
; --- START FUNCTION CALL
                 
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; printf("    %s state of repair improved\n\n", 
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
                 
  mov b, _s163 ; "    %s state of repair improved\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if232_exit:
  jmp _if231_exit
_if231_exit:
  leave
  ret

find_set_empty_place:
  enter 0 ; (push bp; mov bp, sp)
; unsigned char r1, r2; 
  sub sp, 1
  sub sp, 1
; do { 
_do233_block:
; r1 = rand8(); 
  lea d, [bp + 0] ; $r1
  push d
                 
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; r2 = rand8(); 
  lea d, [bp + -1] ; $r2
  push d
                 
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; } while (quad[r1+-1][r2+-1] != 		0 ); 
_do233_cond:
                 
  mov d, _quad_data ; $quad
  push a
  push d
                 
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                 
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 1
  je _do233_block
_do233_exit:
; quad[r1+-1][r2+-1] = t; 
  mov d, _quad_data ; $quad
  push a
  push d
                 
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
                 
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
                 
  lea d, [bp + 5] ; $t
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (z1) 
_if234_cond:
                 
  lea d, [bp + 6] ; $z1
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if234_exit
_if234_TRUE:
; *z1 = r1; 
  lea d, [bp + 6] ; $z1
  mov b, [d]
  mov c, 0
  push b
                 
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _if234_exit
_if234_exit:
; if (z2) 
_if235_cond:
                 
  lea d, [bp + 8] ; $z2
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if235_exit
_if235_TRUE:
; *z2 = r2; 
  lea d, [bp + 8] ; $z2
  mov b, [d]
  mov c, 0
  push b
                 
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _if235_exit
_if235_exit:
  leave
  ret

get_device_name:
  enter 0 ; (push bp; mov bp, sp)
; if (n < 0 || n > 8) 
_if236_cond:
                 
  lea d, [bp + 5] ; $n
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if236_exit
_if236_TRUE:
; n = 0; 
  lea d, [bp + 5] ; $n
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if236_exit
_if236_exit:
; return device_name[n]; 
                 
  mov d, _device_name_data ; $device_name
  push a
  push d
                 
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  leave
  ret

quadrant_name:
  enter 0 ; (push bp; mov bp, sp)
; static char *sect_name[] = { "", " I", " II", " III", " IV" }; 
  sub sp, 20
; if (y < 1 || y > 8 || x < 1 || x > 8) 
_if237_cond:
                 
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if237_exit
_if237_TRUE:
; strcpy(quadname, "Unknown"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s168 ; "Unknown"
  swp b
  push b
                 
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
  jmp _if237_exit
_if237_exit:
; if (x <= 4) 
_if238_cond:
                 
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if238_else
_if238_TRUE:
; strcpy(quadname, quad_name[y]); 
                 
; --- START FUNCTION CALL
                 
  mov d, _quad_name_data ; $quad_name
  push a
  push d
                 
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
  jmp _if238_exit
_if238_else:
; strcpy(quadname, quad_name[y + 8]); 
                 
; --- START FUNCTION CALL
                 
  mov d, _quad_name_data ; $quad_name
  push a
  push d
                 
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000008
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
_if238_exit:
; if (small != 1) { 
_if239_cond:
                 
  lea d, [bp + 5] ; $small
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if239_exit
_if239_TRUE:
; if (x > 4) 
_if240_cond:
                 
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if240_exit
_if240_TRUE:
; x = x - 4; 
  lea d, [bp + 7] ; $x
  push d
                 
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000004
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
  jmp _if240_exit
_if240_exit:
; strcat(quadname, sect_name[x]); 
                 
; --- START FUNCTION CALL
                 
  mov d, st_quadrant_name_sect_name_dt ; static sect_name
  push a
  push d
                 
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
  jmp _if239_exit
_if239_exit:
; return; 
  leave
  ret

isqrt:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int b, q, r, t; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; b = 0x4000; 
  lea d, [bp + -1] ; $b
  push d
                 
  mov32 cb, $00004000
  pop d
  mov [d], b
; q = 0; 
  lea d, [bp + -3] ; $q
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; r = i; 
  lea d, [bp + -5] ; $r
  push d
                 
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while (b) { 
_while241_cond:
                 
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _while241_exit
_while241_block:
; t = q + b; 
  lea d, [bp + -7] ; $t
  push d
                 
  lea d, [bp + -3] ; $q
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; q =q>> 1; 
  lea d, [bp + -3] ; $q
  push d
                 
  lea d, [bp + -3] ; $q
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000001
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  pop d
  mov [d], b
; if (r >= t) { 
_if242_cond:
                 
  lea d, [bp + -5] ; $r
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $t
  mov b, [d]
  mov c, 0
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if242_exit
_if242_TRUE:
; r =r- t; 
  lea d, [bp + -5] ; $r
  push d
                 
  lea d, [bp + -5] ; $r
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $t
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; q = q + b; 
  lea d, [bp + -3] ; $q
  push d
                 
  lea d, [bp + -3] ; $q
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if242_exit
_if242_exit:
; b =b>> 2; 
  lea d, [bp + -1] ; $b
  push d
                 
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  pop d
  mov [d], b
  jmp _while241_cond
_while241_exit:
; return q; 
                 
  lea d, [bp + -3] ; $q
  mov b, [d]
  mov c, 0
  leave
  ret

square00:
  enter 0 ; (push bp; mov bp, sp)
; if (abs(t) > 181) { 
_if243_cond:
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
  swp b
  push b
  call abs
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $000000b5
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if243_else
_if243_TRUE:
; t =t/ 10; 
  lea d, [bp + 5] ; $t
  push d
                 
  lea d, [bp + 5] ; $t
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
; t =t* t; 
  lea d, [bp + 5] ; $t
  push d
                 
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_245  
  neg a 
skip_invert_a_245:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_245  
  neg b 
skip_invert_b_245:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_245
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_245:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  jmp _if243_exit
_if243_else:
; t =t* t; 
  lea d, [bp + 5] ; $t
  push d
                 
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_246  
  neg a 
skip_invert_a_246:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_246  
  neg b 
skip_invert_b_246:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_246
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_246:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; t =t/ 100; 
  lea d, [bp + 5] ; $t
  push d
                 
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
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
_if243_exit:
; return t; 
                 
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
  leave
  ret

distance_to:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int j; 
  sub sp, 2
; j = square00(TO_FIXED00(k->y) - ship_y); 
  lea d, [bp + -1] ; $j
  push d
                 
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  swp b
  push b
  call square00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; j = j + square00(TO_FIXED00(k->x) - ship_x); 
  lea d, [bp + -1] ; $j
  push d
                 
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  swp b
  push b
  call square00
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; j = isqrt(j); 
  lea d, [bp + -1] ; $j
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  swp b
  push b
  call isqrt
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  leave
  ret

cint100:
  enter 0 ; (push bp; mov bp, sp)
; return (d + 50) / 100; 
                 
                 
  lea d, [bp + 5] ; $d
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000032
  add b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

showfile:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
; char c; 
  sub sp, 1
; --- BEGIN INLINE ASM SEGMENT
  mov al, 1
  syscall sys_io      ; receive in AH
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM SEGMENT
; return c; 
                 
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  syscall sys_terminate_proc
; --- END INLINE ASM SEGMENT
  leave
  ret

tolower:
  enter 0 ; (push bp; mov bp, sp)
; if (ch >= 'A' && ch <= 'Z')  
_if249_cond:
                 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if249_else
_if249_TRUE:
; return ch - 'A' + 'a'; 
                 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000041
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $00000061
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if249_exit
_if249_else:
; return ch; 
                 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret
_if249_exit:
  leave
  ret

rand:
  enter 0 ; (push bp; mov bp, sp)
; int  sec; 
  sub sp, 2
; --- BEGIN INLINE ASM SEGMENT
  mov al, 0
  syscall sys_rtc					; get seconds
  mov al, ah
  lea d, [bp + -1] ; $sec
  mov al, [d]
  mov ah, 0
; --- END INLINE ASM SEGMENT
; return sec; 
                 
  lea d, [bp + -1] ; $sec
  mov b, [d]
  mov c, 0
  leave
  ret

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; char *psrc; 
  sub sp, 2
; char *pdest; 
  sub sp, 2
; psrc = src; 
  lea d, [bp + -1] ; $psrc
  push d
                 
  lea d, [bp + 7] ; $src
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
                 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while(*psrc) *pdest++ = *psrc++; 
_while250_cond:
                 
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while250_exit
_while250_block:
; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  dec b
  push b
                 
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while250_cond
_while250_exit:
; *pdest = '\0'; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

strcat:
  enter 0 ; (push bp; mov bp, sp)
; int dest_len; 
  sub sp, 2
; int i; 
  sub sp, 2
; dest_len = strlen(dest); 
  lea d, [bp + -1] ; $dest_len
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for (i = 0; src[i] != 0; i=i+1) { 
_for251_init:
  lea d, [bp + -3] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for251_cond:
                 
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for251_exit
_for251_block:
; dest[dest_len + i] = src[i]; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
                 
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for251_update:
  lea d, [bp + -3] ; $i
  push d
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _for251_cond
_for251_exit:
; dest[dest_len + i] = 0; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return dest; 
                 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; int length; 
  sub sp, 2
; length = 0; 
  lea d, [bp + -1] ; $length
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (str[length] != 0) { 
_while252_cond:
                 
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while252_exit
_while252_block:
; length++; 
                 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, a
  jmp _while252_cond
_while252_exit:
; return length; 
                 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
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
_for253_init:
_for253_cond:
_for253_block:
; if(!*format_p) break; 
_if254_cond:
                 
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
  je _if254_else
_if254_TRUE:
; break; 
  jmp _for253_exit ; for break
  jmp _if254_exit
_if254_else:
; if(*format_p == '%'){ 
_if255_cond:
                 
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
  je _if255_else
_if255_TRUE:
; format_p++; 
                 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch256_expr:
                 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch256_comparisons:
  cmp bl, $6c
  je _switch256_case0
  cmp bl, $4c
  je _switch256_case1
  cmp bl, $64
  je _switch256_case2
  cmp bl, $69
  je _switch256_case3
  cmp bl, $75
  je _switch256_case4
  cmp bl, $78
  je _switch256_case5
  cmp bl, $63
  je _switch256_case6
  cmp bl, $73
  je _switch256_case7
  jmp _switch256_default
  jmp _switch256_exit
_switch256_case0:
_switch256_case1:
; format_p++; 
                 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if257_cond:
                 
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
  je _if257_else
_if257_TRUE:
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
  jmp _if257_exit
_if257_else:
; if(*format_p == 'u') 
_if258_cond:
                 
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
  je _if258_else
_if258_TRUE:
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
  jmp _if258_exit
_if258_else:
; if(*format_p == 'x') 
_if259_cond:
                 
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
  je _if259_else
_if259_TRUE:
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
  jmp _if259_exit
_if259_else:
; err("Unexpected format in printf."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s169 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if259_exit:
_if258_exit:
_if257_exit:
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
  jmp _switch256_exit ; case break
_switch256_case2:
_switch256_case3:
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
  jmp _switch256_exit ; case break
_switch256_case4:
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
  jmp _switch256_exit ; case break
_switch256_case5:
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
  jmp _switch256_exit ; case break
_switch256_case6:
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
; p = p + 1; 
  lea d, [bp + -1] ; $p
  push d
                 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch256_exit ; case break
_switch256_case7:
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
  jmp _switch256_exit ; case break
_switch256_default:
; print("Error: Unknown argument type.\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s170 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch256_exit:
; format_p++; 
                 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if255_exit
_if255_else:
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
_if255_exit:
_if254_exit:
_for253_update:
  jmp _for253_cond
_for253_exit:
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
_if260_cond:
                 
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
  je _if260_else
_if260_TRUE:
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
  jmp _if260_exit
_if260_else:
; if (num == 0) { 
_if261_cond:
                 
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
  je _if261_exit
_if261_TRUE:
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
  jmp _if261_exit
_if261_exit:
_if260_exit:
; while (num > 0) { 
_while262_cond:
                 
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
  je _while262_exit
_while262_block:
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
  jmp _while262_cond
_while262_exit:
; while (i > 0) { 
_while265_cond:
                 
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
  je _while265_exit
_while265_block:
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
  jmp _while265_cond
_while265_exit:
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
_if266_cond:
                 
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
  je _if266_exit
_if266_TRUE:
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
  jmp _if266_exit
_if266_exit:
; while (num > 0) { 
_while267_cond:
                 
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
  je _while267_exit
_while267_block:
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
  jmp _while267_cond
_while267_exit:
; while (i > 0) { 
_while270_cond:
                 
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
  je _while270_exit
_while270_block:
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
  jmp _while270_cond
_while270_exit:
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
_if271_cond:
                 
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
  je _if271_else
_if271_TRUE:
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
  jmp _if271_exit
_if271_else:
; if (num == 0) { 
_if272_cond:
                 
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
  je _if272_exit
_if272_TRUE:
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
  jmp _if272_exit
_if272_exit:
_if271_exit:
; while (num > 0) { 
_while273_cond:
                 
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
  je _while273_exit
_while273_block:
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
  jmp _while273_cond
_while273_exit:
; while (i > 0) { 
_while276_cond:
                 
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
  je _while276_exit
_while276_block:
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
  jmp _while276_cond
_while276_exit:
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
_if277_cond:
                 
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
  je _if277_exit
_if277_TRUE:
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
  jmp _if277_exit
_if277_exit:
; while (num > 0) { 
_while278_cond:
                 
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
  je _while278_exit
_while278_block:
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
  jmp _while278_cond
_while278_exit:
; while (i > 0) { 
_while281_cond:
                 
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
  je _while281_exit
_while281_block:
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
  jmp _while281_cond
_while281_exit:
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

memset:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < size; i++){ 
_for282_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for282_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 8] ; $size
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for282_exit
_for282_block:
; *(s+i) = c; 
                 
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  push b
                 
  lea d, [bp + 7] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for282_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for282_cond
_for282_exit:
; return s; 
                 
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
  leave
  ret

strncmp:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for (i = 0; i < n; i++) { 
_for283_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for283_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 9] ; $n
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for283_exit
_for283_block:
; if (str1[i] != str2[i]) { 
_if284_cond:
                 
  lea d, [bp + 5] ; $str1
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $str2
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if284_exit
_if284_TRUE:
; return (unsigned char)str1[i] - (unsigned char)str2[i]; 
                 
  lea d, [bp + 5] ; $str1
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $str2
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if284_exit
_if284_exit:
; if (str1[i] == '\0' || str2[i] == '\0') { 
_if285_cond:
                 
  lea d, [bp + 5] ; $str1
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 7] ; $str2
  mov d, [d]
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if285_exit
_if285_TRUE:
; break; 
  jmp _for283_exit ; for break
  jmp _if285_exit
_if285_exit:
_for283_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for283_cond
_for283_exit:
; return 0; 
                 
  mov32 cb, $00000000
  leave
  ret

is_digit:
  enter 0 ; (push bp; mov bp, sp)
; return c >= '0' && c <= '9'; 
                 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000030
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000039
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
; return i < 0 ? -i : i; 
_ternary286_cond:
  lea d, [bp + 5] ; $i
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
  je _ternary286_FALSE
_ternary286_TRUE:
                 
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
  neg b
  jmp _ternary286_exit
_ternary286_FALSE:
                 
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
_ternary286_exit:
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
; int result = 0;  // Initialize result 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $result
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int sign = 1;    // Initialize sign as positive 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $sign
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; while (*str == ' ') str++; 
_while287_cond:
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000020
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while287_exit
_while287_block:
; str++; 
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while287_cond
_while287_exit:
; if (*str == '-' || *str == '+') { 
_if288_cond:
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if288_exit
_if288_TRUE:
; if (*str == '-') sign = -1; 
_if289_cond:
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if289_exit
_if289_TRUE:
; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
                 
  mov32 cb, $ffffffff
  pop d
  mov [d], b
  jmp _if289_exit
_if289_exit:
; str++; 
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _if288_exit
_if288_exit:
; while (*str >= '0' && *str <= '9') { 
_while290_cond:
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000030
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000039
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while290_exit
_while290_block:
; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
                 
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_291  
  neg a 
skip_invert_a_291:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_291  
  neg b 
skip_invert_b_291:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_291
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_291:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  add b, a
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; str++; 
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while290_cond
_while290_exit:
; return sign * result; 
                 
  lea d, [bp + -3] ; $sign
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_292  
  neg a 
skip_invert_a_292:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_292  
  neg b 
skip_invert_b_292:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_292
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_292:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_starbases: .fill 1, 0
_base_y: .fill 1, 0
_base_x: .fill 1, 0
_starbases_left: .fill 1, 0
_c_data: 
.db 
.db 
.db $00,$00,$00,$ff,$ff,$ff,$00,$01,$01,$01,$00,$01,$01,$01,$00,$ff,$ff,$ff,$00,$01,$01,
.fill 9, 0
_docked: .fill 1, 0
_energy: .fill 2, 0
_energy0: .dw $0bb8
_map_data: .fill 162, 0
_kdata_data: .fill 12, 0
_klingons: .fill 1, 0
_total_klingons: .fill 1, 0
_klingons_left: .fill 1, 0
_torps: .fill 1, 0
_torps0: .db $0a
_quad_y: .fill 2, 0
_quad_x: .fill 2, 0
_shield: .fill 2, 0
_stars: .fill 1, 0
_time_start: .fill 2, 0
_time_up: .fill 2, 0
_damage_data: .fill 18, 0
_d4: .fill 2, 0
_ship_y: .fill 2, 0
_ship_x: .fill 2, 0
_stardate: .fill 2, 0
_quad_data: .fill 64, 0
_quadname_data: .fill 12, 0
_inc_1_data: .db "reports:\n  Incorrect course data, sir!\n", 0
_inc_1: .dw _inc_1_data
_quad_name_data: 
.dw 
.dw _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9, _s10, _s11, _s12, _s13, _s14, _s15, _s16, 
.fill 34, 0
_device_name_data: 
.dw 
.dw _s0, _s17, _s18, _s19, _s20, _s21, _s22, _s23, _s24, 
.fill 18, 0
_dcr_1_data: .db "Damage Control report:", 0
_dcr_1: .dw _dcr_1_data
_plural_2_data: 
.db 
.db $00,$00,
_plural_data: 
.db 
.db $69,$73,$00,
.fill 1, 0
_warpmax_data: 
.db 
.db $08,
.fill 3, 0
_srs_1_data: .db "------------------------", 0
_srs_1: .dw _srs_1_data
_tilestr_data: 
.dw 
.dw _s25, _s26, _s27, _s28, _s29, 
.fill 10, 0
_lrs_1_data: .db "-------------------\n", 0
_lrs_1: .dw _lrs_1_data
_gr_1_data: .db "   ----- ----- ----- ----- ----- ----- ----- -----\n", 0
_gr_1: .dw _gr_1_data
_str_s_data: .db "s", 0
_str_s: .dw _str_s_data
_gm_1_data: .db "  ----- ----- ----- ----- ----- ----- ----- -----\n", 0
_gm_1: .dw _gm_1_data
_dist_1_data: .db "  DISTANCE = %s\n\n", 0
_dist_1: .dw _dist_1_data
st_print100_buf_dt: .fill 16, 0
st_quadrant_name_sect_name_dt: 
.dw _s0, _s164, _s165, _s166, _s167, 
.fill 10, 0
st_quadrant_name_sect_name: .dw st_quadrant_name_sect_name_dt
_s0: .db "", 0
_s1: .db "Antares", 0
_s2: .db "Rigel", 0
_s3: .db "Procyon", 0
_s4: .db "Vega", 0
_s5: .db "Canopus", 0
_s6: .db "Altair", 0
_s7: .db "Sagittarius", 0
_s8: .db "Pollux", 0
_s9: .db "Sirius", 0
_s10: .db "Deneb", 0
_s11: .db "Capella", 0
_s12: .db "Betelgeuse", 0
_s13: .db "Aldebaran", 0
_s14: .db "Regulus", 0
_s15: .db "Arcturus", 0
_s16: .db "Spica", 0
_s17: .db "Warp engines", 0
_s18: .db "Short range sensors", 0
_s19: .db "Long range sensors", 0
_s20: .db "Phaser control", 0
_s21: .db "Photon tubes", 0
_s22: .db "Damage control", 0
_s23: .db "Shield control", 0
_s24: .db "Library computer", 0
_s25: .db "   ", 0
_s26: .db " * ", 0
_s27: .db ">!<", 0
_s28: .db "+K+", 0
_s29: .db "<*>", 0
_s30: .db "are", 0
_s31: .db "is", 0
_s32: .db "%s %s inoperable.\n", 0
_s33: .db "startrek.intro", 0
_s34: .db "startrek.doc", 0
_s35: .db "startrek.logo", 0
_s36: .db "startrek.fatal", 0
_s37: .db "Command? ", 0
_s38: .db "nav", 0
_s39: .db "srs", 0
_s40: .db "lrs", 0
_s41: .db "pha", 0
_s42: .db "tor", 0
_s43: .db "shi", 0
_s44: .db "dam", 0
_s45: .db "com", 0
_s46: .db "xxx", 0
_s47: .db "Enter one of the following:\n", 0
_s48: .db "  nav - To Set Course", 0
_s49: .db "  srs - Short Range Sensors", 0
_s50: .db "  lrs - Long Range Sensors", 0
_s51: .db "  pha - Phasers", 0
_s52: .db "  tor - Photon Torpedoes", 0
_s53: .db "  shi - Shield Control", 0
_s54: .db "  dam - Damage Control", 0
_s55: .db "  com - Library Computer", 0
_s56: .db "  xxx - Resign Command\n", 0
_s57: .db "s", 0
_s58: .db "Now entering %s quadrant...\n\n", 0
_s59: .db "\nYour mission begins with your starship located", 0
_s60: .db "in the galactic quadrant %s.\n\n", 0
_s61: .db "Combat Area  Condition Red\n", 0
_s62: .db "Shields Dangerously Low\n", 0
_s63: .db "Course (0-9): ", 0
_s64: .db "Lt. Sulu%s", 0
_s65: .db "0.2", 0
_s66: .db "Warp Factor (0-%s): ", 0
_s67: .db "Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n", 0
_s68: .db "Chief Engineer Scott reports:\n  The engines won't take warp %s!\n\n", 0
_s69: .db "Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n", 0
_s70: .db "Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n", 0
_s71: .db "LT. Uhura reports:\n Message from Starfleet Command:\n\n Permission to attempt crossing of galactic perimeter\n is hereby *denie"
.db "d*. Shut down your engines.\n\n Chief Engineer Scott reports:\n Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n", 0
_s72: .db "Warp Engines shut down at sector %d, %d due to bad navigation.\n\n", 0
_s73: .db "Shield Control supplies energy to complete maneuver.\n", 0
_s74: .db "GREEN", 0
_s75: .db "YELLOW", 0
_s76: .db "*RED*", 0
_s77: .db "DOCKED", 0
_s78: .db "Shields dropped for docking purposes.", 0
_s79: .db "\n*** Short Range Sensors are out ***", 0
_s80: .db "    Stardate            %d\n", 0
_s81: .db "    Condition           %s\n", 0
_s82: .db "    Quadrant            %d, %d\n", 0
_s83: .db "    Sector              %d, %d\n", 0
_s84: .db "    Photon Torpedoes    %d\n", 0
_s85: .db "    Total Energy        %d\n", 0
_s86: .db "    Shields             %d\n", 0
_s87: .db "    Klingons Remaining  %d\n", 0
_s88: .db "Long Range Scan for Quadrant %d, %d\n\n", 0
_s89: .db "%s:", 0
_s90: .db "***", 0
_s91: .db " :", 0
_s92: .db "%s\n", 0
_s93: .db "Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n", 0
_s94: .db "Computer failure hampers accuracy.", 0
_s95: .db "Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: ", 0
_s96: .db "Not enough energy available.\n", 0
_s97: .db "Sensors show no damage to enemy at %d, %d\n\n", 0
_s98: .db "%d unit hit on Klingon at sector %d, %d\n", 0
_s99: .db "*** Klingon Destroyed ***\n", 0
_s100: .db "   (Sensors show %d units remaining.)\n\n", 0
_s101: .db "All photon torpedoes expended", 0
_s102: .db "Ensign Chekov%s", 0
_s103: .db "Torpedo Track:", 0
_s104: .db "    %d, %d\n", 0
_s105: .db "Torpedo Missed\n", 0
_s106: .db "Star at %d, %d absorbed torpedo energy.\n\n", 0
_s107: .db "*** Starbase Destroyed ***", 0
_s108: .db "That does it, Captain!!", 0
_s109: .db "You are hereby relieved of command\n", 0
_s110: .db "and sentenced to 99 stardates of hard", 0
_s111: .db "labor on Cygnus 12!!\n", 0
_s112: .db "Starfleet Command reviewing your record to consider\n court martial!\n", 0
_s113: .db "Damage Control report not available.", 0
_s114: .db "\nTechnicians standing by to effect repairs to your ship;\nEstimated time to repair: %s stardates.\n Will you authorize the repa"
.db "ir order (y/N)? ", 0
_s115: .db "Device            State of Repair", 0
_s116: .db "%-25s%6s\n", 0
_s117: .db "\n", 0
_s118: .db "Energy available = %d\n\n Input number of units to shields: ", 0
_s119: .db "<Shields Unchanged>\n", 0
_s120: .db "Shield Control Reports:\n  'This is not the Federation Treasury.'", 0
_s121: .db "Deflector Control Room report:\n  'Shields now at %d units per your command.'\n\n", 0
_s122: .db "Computer active and awating command: ", 0
_s123: .db "Functions available from Library-Computer:\n\n", 0
_s124: .db "   0 = Cumulative Galactic Record\n", 0
_s125: .db "   1 = Status Report\n", 0
_s126: .db "   2 = Photon Torpedo Data\n", 0
_s127: .db "   3 = Starbase Nav Data\n", 0
_s128: .db "   4 = Direction/Distance Calculator\n", 0
_s129: .db "   5 = Galaxy 'Region Name' Map\n", 0
_s130: .db "\n     Computer Record of Galaxy for Quadrant %d,%d\n\n", 0
_s131: .db "     1     2     3     4     5     6     7     8", 0
_s132: .db "%s%d", 0
_s133: .db "   Status Report:\n", 0
_s134: .db "Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n", 0
_s135: .db "Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n", 0
_s136: .db "The Federation is maintaining %d starbase%s in the galaxy\n\n", 0
_s137: .db "From Enterprise to Klingon battlecriuser%s:\n\n", 0
_s138: .db "Mr. Spock reports,\n  'Sensors show no starbases in this quadrant.'\n", 0
_s139: .db "Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: ", 0
_s140: .db "Please enter initial Y coordinate: ", 0
_s141: .db "Please enter final X coordinate: ", 0
_s142: .db "Please enter final Y coordinate: ", 0
_s143: .db "\n                   The Galaxy\n\n", 0
_s144: .db "    1     2     3     4     5     6     7     8\n", 0
_s145: .db "%s%d ", 0
_s146: .db "  DIRECTION = ", 0
_s147: .db "%s", 0
_s148: .db "The Enterprise has been destroyed. The Federation will be conquered.\n", 0
_s149: .db "It is stardate %d.\n\n", 0
_s150: .db "There were %d Klingon Battlecruisers left at the end of your mission.\n\n", 0
_s151: .db "Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n", 0
_s152: .db "Your efficiency rating is %s\n", 0
_s153: .db "The Federation is in need of a new starship commander", 0
_s154: .db " for a similar mission.\n", 0
_s155: .db "If there is a volunteer, let him step forward and", 0
_s156: .db " enter 'aye': ", 0
_s157: .db "Starbase shields protect the Enterprise\n", 0
_s158: .db "%d unit hit on Enterprise from sector %d, %d\n", 0
_s159: .db "    <Shields down to %d units>\n\n", 0
_s160: .db "Damage Control reports\n'%s' damaged by hit\n\n", 0
_s161: .db "    %s repair completed\n\n", 0
_s162: .db "    %s damaged\n\n", 0
_s163: .db "    %s state of repair improved\n\n", 0
_s164: .db " I", 0
_s165: .db " II", 0
_s166: .db " III", 0
_s167: .db " IV", 0
_s168: .db "Unknown", 0
_s169: .db "Unexpected format in printf.", 0
_s170: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
