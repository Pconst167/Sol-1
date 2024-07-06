; --- FILENAME: ../solarium/asm/asm.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; char *p; 
  sub sp, 2
; print("\n"); 
               
; --- START FUNCTION CALL
               
  mov b, _s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; program = alloc(16384); 
  mov d, _program ; $program
  push d
               
; --- START FUNCTION CALL
               
  mov32 cb, $00004000
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; bin_out = alloc(16384); 
  mov d, _bin_out ; $bin_out
  push d
               
; --- START FUNCTION CALL
               
  mov32 cb, $00004000
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; opcode_table = alloc(12310); 
  mov d, _opcode_table ; $opcode_table
  push d
               
; --- START FUNCTION CALL
               
  mov32 cb, $00003016
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; loadfile(0x0000, program); 
               
; --- START FUNCTION CALL
               
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  swp b
  push b
               
  mov32 cb, $00000000
  swp b
  push b
  call loadfile
  add sp, 4
; --- END FUNCTION CALL
; loadfile("./config.d/op_tbl", opcode_table); 
               
; --- START FUNCTION CALL
               
  mov d, _opcode_table ; $opcode_table
  mov b, [d]
  mov c, 0
  swp b
  push b
               
  mov b, _s11 ; "./config.d/op_tbl"
  swp b
  push b
  call loadfile
  add sp, 4
; --- END FUNCTION CALL
; p = program; 
  lea d, [bp + -1] ; $p
  push d
               
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while(*p) p++; 
_while1_cond:
               
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while1_exit
_while1_block:
; p++; 
               
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  dec b
  jmp _while1_cond
_while1_exit:
; while(is_space(*p)) p--; 
_while2_cond:
               
; --- START FUNCTION CALL
               
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_space
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while2_exit
_while2_block:
; p--; 
               
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  dec b
  lea d, [bp + -1] ; $p
  mov [d], b
  inc b
  jmp _while2_cond
_while2_exit:
; p++; 
               
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  dec b
; *p = '\0'; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  push b
               
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = program; 
  mov d, _prog ; $prog
  push d
               
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; bin_p = bin_out + _org; 
  mov d, _bin_p ; $bin_p
  push d
               
  mov d, _bin_out ; $bin_out
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; pc = _org; 
  mov d, _pc ; $pc
  push d
               
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; prog_size = 0; 
  mov d, _prog_size ; $prog_size
  push d
               
  mov32 cb, $00000000
  pop d
  mov [d], b
; label_directive_scan(); 
               
; --- START FUNCTION CALL
  call label_directive_scan
; prog_size = 0; 
  mov d, _prog_size ; $prog_size
  push d
               
  mov32 cb, $00000000
  pop d
  mov [d], b
; parse_text(); 
               
; --- START FUNCTION CALL
  call parse_text
; parse_data(); 
               
; --- START FUNCTION CALL
  call parse_data
; display_output(); 
               
; --- START FUNCTION CALL
  call display_output
  syscall sys_terminate_proc

parse_data:
  enter 0 ; (push bp; mov bp, sp)
; print("Parsing DATA section..."); 
               
; --- START FUNCTION CALL
               
  mov b, _s12 ; "Parsing DATA section..."
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; for(;;){ 
_for3_init:
_for3_cond:
_for3_block:
; get(); 
               
; --- START FUNCTION CALL
  call get
; if(toktype == END) error("Data segment not found."); 
_if4_cond:
               
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if4_exit
_if4_TRUE:
; error("Data segment not found."); 
               
; --- START FUNCTION CALL
               
  mov b, _s13 ; "Data segment not found."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if4_exit
_if4_exit:
; if(tok == DOT){ 
_if5_cond:
               
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $10 ; enum element: DOT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if5_exit
_if5_TRUE:
; get(); 
               
; --- START FUNCTION CALL
  call get
; if(tok == DATA) break; 
_if6_cond:
               
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: DATA
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_TRUE:
; break; 
  jmp _for3_exit ; for break
  jmp _if6_exit
_if6_exit:
  jmp _if5_exit
_if5_exit:
_for3_update:
  jmp _for3_cond
_for3_exit:
; for(;;){ 
_for7_init:
_for7_cond:
_for7_block:
; get(); 
               
; --- START FUNCTION CALL
  call get
; if(tok == SEGMENT_END) break; 
_if8_cond:
               
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: SEGMENT_END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if8_exit
_if8_TRUE:
; break; 
  jmp _for7_exit ; for break
  jmp _if8_exit
_if8_exit:
; if(tok == DB){ 
_if9_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: DB
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if9_else
_if9_TRUE:
; print(".db: "); 
                
; --- START FUNCTION CALL
                
  mov b, _s14 ; ".db: "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; for(;;){ 
_for10_init:
_for10_cond:
_for10_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == CHAR_CONST){ 
_if11_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if11_else
_if11_TRUE:
; emit_byte(string_const[0], 0); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000000
  push bl
                
  mov d, _string_const_data ; $string_const
  push a
  push d
                
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; printx8(string_const[0]); 
                
; --- START FUNCTION CALL
                
  mov d, _string_const_data ; $string_const
  push a
  push d
                
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call printx8
  add sp, 1
; --- END FUNCTION CALL
  jmp _if11_exit
_if11_else:
; if(toktype == INTEGER_CONST){ 
_if12_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if12_exit
_if12_TRUE:
; emit_byte(int_const, 0); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000000
  push bl
                
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; printx8(int_const); 
                
; --- START FUNCTION CALL
                
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  push bl
  call printx8
  add sp, 1
; --- END FUNCTION CALL
  jmp _if12_exit
_if12_exit:
_if11_exit:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(tok != COMMA){ 
_if13_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $f ; enum element: COMMA
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if13_exit
_if13_TRUE:
; back(); 
                
; --- START FUNCTION CALL
  call back
; break; 
  jmp _for10_exit ; for break
  jmp _if13_exit
_if13_exit:
; print(", "); 
                
; --- START FUNCTION CALL
                
  mov b, _s15 ; ", "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_for10_update:
  jmp _for10_cond
_for10_exit:
; print("\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if9_exit
_if9_else:
; if(tok == DW){ 
_if14_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: DW
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if14_exit
_if14_TRUE:
; print(".dw: "); 
                
; --- START FUNCTION CALL
                
  mov b, _s16 ; ".dw: "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; for(;;){ 
_for15_init:
_for15_cond:
_for15_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == CHAR_CONST){ 
_if16_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if16_else
_if16_TRUE:
; emit_byte(string_const[0], 0); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000000
  push bl
                
  mov d, _string_const_data ; $string_const
  push a
  push d
                
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; emit_byte(0, 0); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000000
  push bl
                
  mov32 cb, $00000000
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; printx8(string_const[0]); 
                
; --- START FUNCTION CALL
                
  mov d, _string_const_data ; $string_const
  push a
  push d
                
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call printx8
  add sp, 1
; --- END FUNCTION CALL
  jmp _if16_exit
_if16_else:
; if(toktype == INTEGER_CONST){ 
_if17_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if17_exit
_if17_TRUE:
; emit_word(int_const, 0); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000000
  push bl
                
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  swp b
  push b
  call emit_word
  add sp, 3
; --- END FUNCTION CALL
; printx16(int_const); 
                
; --- START FUNCTION CALL
                
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printx16
  add sp, 2
; --- END FUNCTION CALL
  jmp _if17_exit
_if17_exit:
_if16_exit:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(tok != COMMA){ 
_if18_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $f ; enum element: COMMA
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if18_exit
_if18_TRUE:
; back(); 
                
; --- START FUNCTION CALL
  call back
; break; 
  jmp _for15_exit ; for break
  jmp _if18_exit
_if18_exit:
; print(", "); 
                
; --- START FUNCTION CALL
                
  mov b, _s15 ; ", "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_for15_update:
  jmp _for15_cond
_for15_exit:
; print("\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if14_exit
_if14_exit:
_if9_exit:
_for7_update:
  jmp _for7_cond
_for7_exit:
; print("Done.\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s17 ; "Done.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

parse_directive:
  enter 0 ; (push bp; mov bp, sp)
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(tok == ORG){ 
_if19_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $1 ; enum element: ORG
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_else
_if19_TRUE:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype != INTEGER_CONST) error("Integer constant expected in .org directive."); 
_if20_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if20_exit
_if20_TRUE:
; error("Integer constant expected in .org directive."); 
                
; --- START FUNCTION CALL
                
  mov b, _s18 ; "Integer constant expected in .org directive."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if20_exit
_if20_exit:
; _org = int_const; 
  mov d, __org ; $_org
  push d
                
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if19_exit
_if19_else:
; if(tok == DB){ 
_if21_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: DB
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if21_else
_if21_TRUE:
; for(;;){ 
_for22_init:
_for22_cond:
_for22_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == CHAR_CONST){ 
_if23_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if23_else
_if23_TRUE:
; emit_byte(string_const[0], emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  mov d, _string_const_data ; $string_const
  push a
  push d
                
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
  jmp _if23_exit
_if23_else:
; if(toktype == INTEGER_CONST){ 
_if24_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_TRUE:
; emit_byte(int_const, emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
  jmp _if24_exit
_if24_exit:
_if23_exit:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(tok != COMMA){ 
_if25_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $f ; enum element: COMMA
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if25_exit
_if25_TRUE:
; back(); 
                
; --- START FUNCTION CALL
  call back
; break; 
  jmp _for22_exit ; for break
  jmp _if25_exit
_if25_exit:
_for22_update:
  jmp _for22_cond
_for22_exit:
  jmp _if21_exit
_if21_else:
; if(tok == DW){ 
_if26_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: DW
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if26_exit
_if26_TRUE:
; for(;;){ 
_for27_init:
_for27_cond:
_for27_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == CHAR_CONST){ 
_if28_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if28_else
_if28_TRUE:
; emit_byte(string_const[0], emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  mov d, _string_const_data ; $string_const
  push a
  push d
                
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; emit_byte(0, emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  mov32 cb, $00000000
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
  jmp _if28_exit
_if28_else:
; if(toktype == INTEGER_CONST){ 
_if29_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if29_exit
_if29_TRUE:
; emit_word(int_const, 0); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000000
  push bl
                
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  swp b
  push b
  call emit_word
  add sp, 3
; --- END FUNCTION CALL
  jmp _if29_exit
_if29_exit:
_if28_exit:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(tok != COMMA){ 
_if30_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $f ; enum element: COMMA
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if30_exit
_if30_TRUE:
; back(); 
                
; --- START FUNCTION CALL
  call back
; break; 
  jmp _for27_exit ; for break
  jmp _if30_exit
_if30_exit:
_for27_update:
  jmp _for27_cond
_for27_exit:
  jmp _if26_exit
_if26_exit:
_if21_exit:
_if19_exit:
  leave
  ret

label_directive_scan:
  enter 0 ; (push bp; mov bp, sp)
; char *temp_prog; 
  sub sp, 2
; int i; 
  sub sp, 2
; prog = program; 
  mov d, _prog ; $prog
  push d
                
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; bin_p = bin_out + _org; 
  mov d, _bin_p ; $bin_p
  push d
                
  mov d, _bin_out ; $bin_out
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; pc = _org; 
  mov d, _pc ; $pc
  push d
                
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; print("Parsing labels and directives...\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s19 ; "Parsing labels and directives...\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; for(;;){ 
_for31_init:
_for31_cond:
_for31_block:
; get(); back(); 
                
; --- START FUNCTION CALL
  call get
; back(); 
                
; --- START FUNCTION CALL
  call back
; temp_prog = prog; 
  lea d, [bp + -1] ; $temp_prog
  push d
                
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if32_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if32_exit
_if32_TRUE:
; break; 
  jmp _for31_exit ; for break
  jmp _if32_exit
_if32_exit:
; if(tok == DOT){ 
_if33_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $10 ; enum element: DOT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if33_else
_if33_TRUE:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(is_directive(token)){ 
_if34_cond:
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_directive
  add sp, 2
; --- END FUNCTION CALL
  cmp b, 0
  je _if34_exit
_if34_TRUE:
; back(); 
                
; --- START FUNCTION CALL
  call back
; parse_directive(1); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000001
  push bl
  call parse_directive
  add sp, 1
; --- END FUNCTION CALL
  jmp _if34_exit
_if34_exit:
  jmp _if33_exit
_if33_else:
; if(toktype == IDENTIFIER){ 
_if35_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if35_exit
_if35_TRUE:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(tok == COLON){ 
_if36_cond:
                
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $d ; enum element: COLON
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if36_else
_if36_TRUE:
; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -1] ; $temp_prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; parse_label(); 
                
; --- START FUNCTION CALL
  call parse_label
; print("."); 
                
; --- START FUNCTION CALL
                
  mov b, _s20 ; "."
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if36_exit
_if36_else:
; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -1] ; $temp_prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; parse_instr(1);       
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000001
  push bl
  call parse_instr
  add sp, 1
; --- END FUNCTION CALL
; print("."); 
                
; --- START FUNCTION CALL
                
  mov b, _s20 ; "."
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_if36_exit:
  jmp _if35_exit
_if35_exit:
_if33_exit:
_for31_update:
  jmp _for31_cond
_for31_exit:
; print("\nDone.\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s21 ; "\nDone.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; printf("Org: %s\n", _org); 
                
; --- START FUNCTION CALL
                
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  mov b, _s22 ; "Org: %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; print("\nLabels list:\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s23 ; "\nLabels list:\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; for(i = 0; label_table[i].name[0]; i++){ 
_for37_init:
  lea d, [bp + -3] ; $i
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
_for37_cond:
                
  mov d, _label_table_data ; $label_table
  push a
  push d
                
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  push a
  push d
                
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _for37_exit
_for37_block:
; print(label_table[i].name); 
                
; --- START FUNCTION CALL
                
  mov d, _label_table_data ; $label_table
  push a
  push d
                
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(": "); 
                
; --- START FUNCTION CALL
                
  mov b, _s24 ; ": "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; printx16(label_table[i].address); 
                
; --- START FUNCTION CALL
                
  mov d, _label_table_data ; $label_table
  push a
  push d
                
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 16
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printx16
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_for37_update:
                
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for37_cond
_for37_exit:
; print("\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

label_parse_instr:
  enter 0 ; (push bp; mov bp, sp)
; char opcode[32]; 
  sub sp, 32
; char code_line[64]; 
  sub sp, 64
; struct t_opcode op; 
  sub sp, 26
; int num_operands, num_operandsexp; 
  sub sp, 2
  sub sp, 2
; int i, j; 
  sub sp, 2
  sub sp, 2
; char operand_types[3]; // operand types and locations 
  sub sp, 3
; int old_pc; 
  sub sp, 2
; char has_operands; 
  sub sp, 1
; old_pc = pc; 
  lea d, [bp + -134] ; $old_pc
  push d
                
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get_line(); 
                
; --- START FUNCTION CALL
  call get_line
; push_prog(); 
                
; --- START FUNCTION CALL
  call push_prog
; strcpy(code_line, string_const); 
                
; --- START FUNCTION CALL
                
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; has_operands = 0; 
  lea d, [bp + -135] ; $has_operands
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = code_line; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; get(); // get main opcode 
                
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for38_init:
_for38_cond:
_for38_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if39_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if39_exit
_if39_TRUE:
; break; 
  jmp _for38_exit ; for break
  jmp _if39_exit
_if39_exit:
; if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){ 
_if40_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if40_exit
_if40_TRUE:
; has_operands = 1; 
  lea d, [bp + -135] ; $has_operands
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], bl
; break; 
  jmp _for38_exit ; for break
  jmp _if40_exit
_if40_exit:
_for38_update:
  jmp _for38_cond
_for38_exit:
; opcode[0] = '\0'; 
  lea d, [bp + -31] ; $opcode
  push a
  push d
                
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = code_line; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; if(!has_operands){ 
_if41_cond:
                
  lea d, [bp + -135] ; $has_operands
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if41_else
_if41_TRUE:
; get(); 
                
; --- START FUNCTION CALL
  call get
; strcpy(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; get();  
                
; --- START FUNCTION CALL
  call get
; if(toktype == END){ 
_if42_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if42_else
_if42_TRUE:
; strcat(opcode, " ."); 
                
; --- START FUNCTION CALL
                
  mov b, _s25 ; " ."
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
  jmp _if42_exit
_if42_else:
; strcat(opcode, " "); 
                
; --- START FUNCTION CALL
                
  mov b, _s26 ; " "
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; strcat(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; for(;;){ 
_for43_init:
_for43_cond:
_for43_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if44_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if44_exit
_if44_TRUE:
; break; 
  jmp _for43_exit ; for break
  jmp _if44_exit
_if44_exit:
; strcat(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
_for43_update:
  jmp _for43_cond
_for43_exit:
_if42_exit:
; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
                
; --- START FUNCTION CALL
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call search_opcode
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
; if(op.opcode_type){ 
_if45_cond:
                
  lea d, [bp + -121] ; $op
  add d, 25
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if45_exit
_if45_TRUE:
; forwards(1); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if45_exit
_if45_exit:
; forwards(1); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if41_exit
_if41_else:
; num_operands = 0; 
  lea d, [bp + -123] ; $num_operands
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
; for(;;){ 
_for46_init:
_for46_cond:
_for46_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if47_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if47_exit
_if47_TRUE:
; break; 
  jmp _for46_exit ; for break
  jmp _if47_exit
_if47_exit:
; if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){ 
_if48_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if48_exit
_if48_TRUE:
; num_operands++; 
                
  lea d, [bp + -123] ; $num_operands
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -123] ; $num_operands
  mov [d], b
  mov b, a
  jmp _if48_exit
_if48_exit:
_for46_update:
  jmp _for46_cond
_for46_exit:
; if(num_operands > 2) error("Maximum number of operands per instruction is 2."); 
_if49_cond:
                
  lea d, [bp + -123] ; $num_operands
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if49_exit
_if49_TRUE:
; error("Maximum number of operands per instruction is 2."); 
                
; --- START FUNCTION CALL
                
  mov b, _s27 ; "Maximum number of operands per instruction is 2."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if49_exit
_if49_exit:
; num_operandsexp = exp(2, num_operands); 
  lea d, [bp + -125] ; $num_operandsexp
  push d
                
; --- START FUNCTION CALL
                
  lea d, [bp + -123] ; $num_operands
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  mov32 cb, $00000002
  swp b
  push b
  call exp
  add sp, 4
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for(i = 0; i < num_operandsexp; i++){ 
_for50_init:
  lea d, [bp + -127] ; $i
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
_for50_cond:
                
  lea d, [bp + -127] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -125] ; $num_operandsexp
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for50_exit
_for50_block:
; prog = code_line; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; get(); 
                
; --- START FUNCTION CALL
  call get
; strcpy(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; strcat(opcode, " "); 
                
; --- START FUNCTION CALL
                
  mov b, _s26 ; " "
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; j = 0; 
  lea d, [bp + -129] ; $j
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
; for(;;){ 
_for51_init:
_for51_cond:
_for51_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if52_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if52_exit
_if52_TRUE:
; break; 
  jmp _for51_exit ; for break
  jmp _if52_exit
_if52_exit:
; if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){ 
_if53_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if53_else
_if53_TRUE:
; strcat(opcode, symbols[i*2+j]); 
                
; --- START FUNCTION CALL
                
  mov d, _symbols_data ; $symbols
  push a
  push d
                
  lea d, [bp + -127] ; $i
  mov b, [d]
  mov c, 0
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
  jz skip_invert_a_54  
  neg a 
skip_invert_a_54:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_54  
  neg b 
skip_invert_b_54:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_54
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_54:
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
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; operand_types[j] = *symbols[i*2+j]; 
  lea d, [bp + -132] ; $operand_types
  push a
  push d
                
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
                
  mov d, _symbols_data ; $symbols
  push a
  push d
                
  lea d, [bp + -127] ; $i
  mov b, [d]
  mov c, 0
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
  jz skip_invert_a_55  
  neg a 
skip_invert_a_55:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_55  
  neg b 
skip_invert_b_55:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_55
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_55:
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
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; j++; 
                
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -129] ; $j
  mov [d], b
  mov b, a
  jmp _if53_exit
_if53_else:
; strcat(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
_if53_exit:
_for51_update:
  jmp _for51_cond
_for51_exit:
; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
                
; --- START FUNCTION CALL
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call search_opcode
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
; if(op.name[0] == '\0') continue; 
_if56_cond:
                
  lea d, [bp + -121] ; $op
  add d, 0
  push a
  push d
                
  mov32 cb, $00000000
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
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if56_exit
_if56_TRUE:
; continue; 
  jmp _for50_update ; for continue
  jmp _if56_exit
_if56_exit:
; if(op.opcode_type){ 
_if57_cond:
                
  lea d, [bp + -121] ; $op
  add d, 25
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if57_exit
_if57_TRUE:
; forwards(1); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if57_exit
_if57_exit:
; forwards(1); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
; prog = code_line; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; j = 0; 
  lea d, [bp + -129] ; $j
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
; get(); 
                
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for58_init:
_for58_cond:
_for58_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if59_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if59_exit
_if59_TRUE:
; break; 
  jmp _for58_exit ; for break
  jmp _if59_exit
_if59_exit:
; if(toktype == IDENTIFIER && !is_reserved(token)){ 
_if60_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if60_else
_if60_TRUE:
; if(operand_types[j] == '#'){ 
_if61_cond:
                
  lea d, [bp + -132] ; $operand_types
  push a
  push d
                
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000023
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if61_else
_if61_TRUE:
; error("8bit operand expected but 16bit label given."); 
                
; --- START FUNCTION CALL
                
  mov b, _s28 ; "8bit operand expected but 16bit label given."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if61_exit
_if61_else:
; if(operand_types[j] == '@'){ 
_if62_cond:
                
  lea d, [bp + -132] ; $operand_types
  push a
  push d
                
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if62_exit
_if62_TRUE:
; forwards(2); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000002
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if62_exit
_if62_exit:
_if61_exit:
; j++; 
                
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -129] ; $j
  mov [d], b
  mov b, a
  jmp _if60_exit
_if60_else:
; if(toktype == INTEGER_CONST){ 
_if63_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if63_exit
_if63_TRUE:
; if(operand_types[j] == '#'){ 
_if64_cond:
                
  lea d, [bp + -132] ; $operand_types
  push a
  push d
                
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000023
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if64_else
_if64_TRUE:
; forwards(1); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if64_exit
_if64_else:
; if(operand_types[j] == '@'){ 
_if65_cond:
                
  lea d, [bp + -132] ; $operand_types
  push a
  push d
                
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if65_exit
_if65_TRUE:
; forwards(2); 
                
; --- START FUNCTION CALL
                
  mov32 cb, $00000002
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if65_exit
_if65_exit:
_if64_exit:
; j++; 
                
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -129] ; $j
  mov [d], b
  mov b, a
  jmp _if63_exit
_if63_exit:
_if60_exit:
_for58_update:
  jmp _for58_cond
_for58_exit:
; break; 
  jmp _for50_exit ; for break
_for50_update:
                
  lea d, [bp + -127] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -127] ; $i
  mov [d], b
  mov b, a
  jmp _for50_cond
_for50_exit:
_if41_exit:
; pop_prog(); 
                
; --- START FUNCTION CALL
  call pop_prog
  leave
  ret

parse_instr:
  enter 0 ; (push bp; mov bp, sp)
; char opcode[32]; 
  sub sp, 32
; char code_line[64]; 
  sub sp, 64
; struct t_opcode op; 
  sub sp, 26
; int instr_len; 
  sub sp, 2
; int num_operands, num_operandsexp; 
  sub sp, 2
  sub sp, 2
; int i, j; 
  sub sp, 2
  sub sp, 2
; char operand_types[3]; // operand types and locations 
  sub sp, 3
; int old_pc; 
  sub sp, 2
; char has_operands; 
  sub sp, 1
; old_pc = pc; 
  lea d, [bp + -136] ; $old_pc
  push d
                
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get_line(); 
                
; --- START FUNCTION CALL
  call get_line
; push_prog(); 
                
; --- START FUNCTION CALL
  call push_prog
; strcpy(code_line, string_const); 
                
; --- START FUNCTION CALL
                
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; has_operands = 0; 
  lea d, [bp + -137] ; $has_operands
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = code_line; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; get(); 
                
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for66_init:
_for66_cond:
_for66_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if67_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if67_exit
_if67_TRUE:
; break; 
  jmp _for66_exit ; for break
  jmp _if67_exit
_if67_exit:
; if(toktype == INTEGER_CONST || label_exists(token) != -1){ 
_if68_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call label_exists
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if68_exit
_if68_TRUE:
; has_operands = 1; 
  lea d, [bp + -137] ; $has_operands
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], bl
; break; 
  jmp _for66_exit ; for break
  jmp _if68_exit
_if68_exit:
_for66_update:
  jmp _for66_cond
_for66_exit:
; opcode[0] = '\0'; 
  lea d, [bp + -31] ; $opcode
  push a
  push d
                
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = code_line; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; if(!has_operands){ 
_if69_cond:
                
  lea d, [bp + -137] ; $has_operands
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if69_else
_if69_TRUE:
; get(); 
                
; --- START FUNCTION CALL
  call get
; strcpy(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; get();  
                
; --- START FUNCTION CALL
  call get
; if(toktype == END){ 
_if70_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if70_else
_if70_TRUE:
; strcat(opcode, " ."); 
                
; --- START FUNCTION CALL
                
  mov b, _s25 ; " ."
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
  jmp _if70_exit
_if70_else:
; strcat(opcode, " "); 
                
; --- START FUNCTION CALL
                
  mov b, _s26 ; " "
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; strcat(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; for(;;){ 
_for71_init:
_for71_cond:
_for71_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if72_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if72_exit
_if72_TRUE:
; break; 
  jmp _for71_exit ; for break
  jmp _if72_exit
_if72_exit:
; strcat(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
_for71_update:
  jmp _for71_cond
_for71_exit:
_if70_exit:
; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
                
; --- START FUNCTION CALL
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call search_opcode
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
; instr_len = 1; 
  lea d, [bp + -123] ; $instr_len
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
; if(op.opcode_type){ 
_if73_cond:
                
  lea d, [bp + -121] ; $op
  add d, 25
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if73_exit
_if73_TRUE:
; instr_len++; 
                
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -123] ; $instr_len
  mov [d], b
  mov b, a
; emit_byte(0xFD, emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  mov32 cb, $000000fd
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
  jmp _if73_exit
_if73_exit:
; emit_byte(op.opcode, emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  lea d, [bp + -121] ; $op
  add d, 24
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; if(!emit_override){ 
_if74_cond:
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if74_exit
_if74_TRUE:
; printf("%x(%d): %s\n", old_pc, instr_len, code_line); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -136] ; $old_pc
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  mov b, _s29 ; "%x(%d): %s\n"
  swp b
  push b
  call printf
  add sp, 8
; --- END FUNCTION CALL
  jmp _if74_exit
_if74_exit:
  jmp _if69_exit
_if69_else:
; num_operands = 0; 
  lea d, [bp + -125] ; $num_operands
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
; for(;;){ 
_for75_init:
_for75_cond:
_for75_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if76_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if76_exit
_if76_TRUE:
; break; 
  jmp _for75_exit ; for break
  jmp _if76_exit
_if76_exit:
; if(toktype == INTEGER_CONST || label_exists(token) != -1) num_operands++; 
_if77_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call label_exists
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if77_exit
_if77_TRUE:
; num_operands++; 
                
  lea d, [bp + -125] ; $num_operands
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -125] ; $num_operands
  mov [d], b
  mov b, a
  jmp _if77_exit
_if77_exit:
_for75_update:
  jmp _for75_cond
_for75_exit:
; if(num_operands > 2) error("Maximum number of operands per instruction is 2."); 
_if78_cond:
                
  lea d, [bp + -125] ; $num_operands
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if78_exit
_if78_TRUE:
; error("Maximum number of operands per instruction is 2."); 
                
; --- START FUNCTION CALL
                
  mov b, _s27 ; "Maximum number of operands per instruction is 2."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if78_exit
_if78_exit:
; num_operandsexp = exp(2, num_operands); 
  lea d, [bp + -127] ; $num_operandsexp
  push d
                
; --- START FUNCTION CALL
                
  lea d, [bp + -125] ; $num_operands
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  mov32 cb, $00000002
  swp b
  push b
  call exp
  add sp, 4
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for(i = 0; i < num_operandsexp; i++){ 
_for79_init:
  lea d, [bp + -129] ; $i
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
_for79_cond:
                
  lea d, [bp + -129] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -127] ; $num_operandsexp
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for79_exit
_for79_block:
; prog = code_line; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; get(); 
                
; --- START FUNCTION CALL
  call get
; strcpy(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; strcat(opcode, " "); 
                
; --- START FUNCTION CALL
                
  mov b, _s26 ; " "
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; j = 0; 
  lea d, [bp + -131] ; $j
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
; for(;;){ 
_for80_init:
_for80_cond:
_for80_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if81_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if81_exit
_if81_TRUE:
; break; 
  jmp _for80_exit ; for break
  jmp _if81_exit
_if81_exit:
; if(toktype == INTEGER_CONST || label_exists(token) != -1){ 
_if82_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call label_exists
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if82_else
_if82_TRUE:
; strcat(opcode, symbols[i*2+j]); 
                
; --- START FUNCTION CALL
                
  mov d, _symbols_data ; $symbols
  push a
  push d
                
  lea d, [bp + -129] ; $i
  mov b, [d]
  mov c, 0
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
  jz skip_invert_a_83  
  neg a 
skip_invert_a_83:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_83  
  neg b 
skip_invert_b_83:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_83
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_83:
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
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; operand_types[j] = *symbols[i*2+j]; 
  lea d, [bp + -134] ; $operand_types
  push a
  push d
                
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
                
  mov d, _symbols_data ; $symbols
  push a
  push d
                
  lea d, [bp + -129] ; $i
  mov b, [d]
  mov c, 0
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
  jz skip_invert_a_84  
  neg a 
skip_invert_a_84:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_84  
  neg b 
skip_invert_b_84:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_84
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_84:
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
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; j++; 
                
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -131] ; $j
  mov [d], b
  mov b, a
  jmp _if82_exit
_if82_else:
; strcat(opcode, token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
_if82_exit:
_for80_update:
  jmp _for80_cond
_for80_exit:
; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
                
; --- START FUNCTION CALL
                
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call search_opcode
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
; if(op.name[0] == '\0') continue; 
_if85_cond:
                
  lea d, [bp + -121] ; $op
  add d, 0
  push a
  push d
                
  mov32 cb, $00000000
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
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if85_exit
_if85_TRUE:
; continue; 
  jmp _for79_update ; for continue
  jmp _if85_exit
_if85_exit:
; instr_len = 1; 
  lea d, [bp + -123] ; $instr_len
  push d
                
  mov32 cb, $00000001
  pop d
  mov [d], b
; if(op.opcode_type){ 
_if86_cond:
                
  lea d, [bp + -121] ; $op
  add d, 25
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if86_exit
_if86_TRUE:
; emit_byte(0xFD, emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  mov32 cb, $000000fd
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; instr_len++; 
                
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -123] ; $instr_len
  mov [d], b
  mov b, a
  jmp _if86_exit
_if86_exit:
; emit_byte(op.opcode, emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  lea d, [bp + -121] ; $op
  add d, 24
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; prog = code_line; 
  mov d, _prog ; $prog
  push d
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; j = 0; 
  lea d, [bp + -131] ; $j
  push d
                
  mov32 cb, $00000000
  pop d
  mov [d], b
; get(); 
                
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for87_init:
_for87_cond:
_for87_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if88_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if88_exit
_if88_TRUE:
; break; 
  jmp _for87_exit ; for break
  jmp _if88_exit
_if88_exit:
; if(toktype == IDENTIFIER){ 
_if89_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if89_else
_if89_TRUE:
; if(label_exists(token) != -1){ 
_if90_cond:
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call label_exists
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if90_else
_if90_TRUE:
; if(operand_types[j] == '#'){ 
_if91_cond:
                
  lea d, [bp + -134] ; $operand_types
  push a
  push d
                
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000023
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if91_else
_if91_TRUE:
; error("8bit operand expected but 16bit label given."); 
                
; --- START FUNCTION CALL
                
  mov b, _s28 ; "8bit operand expected but 16bit label given."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if91_exit
_if91_else:
; if(operand_types[j] == '@'){ 
_if92_cond:
                
  lea d, [bp + -134] ; $operand_types
  push a
  push d
                
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if92_exit
_if92_TRUE:
; emit_word(get_label_addr(token), emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call get_label_addr
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call emit_word
  add sp, 3
; --- END FUNCTION CALL
; instr_len = instr_len + 2; 
  lea d, [bp + -123] ; $instr_len
  push d
                
  lea d, [bp + -123] ; $instr_len
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
  jmp _if92_exit
_if92_exit:
_if91_exit:
; j++; 
                
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -131] ; $j
  mov [d], b
  mov b, a
  jmp _if90_exit
_if90_else:
; if(!is_reserved(token)){ 
_if93_cond:
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  cmp b, 0
  je _if93_exit
_if93_TRUE:
; error_s("Undeclared label: ", token); 
                
; --- START FUNCTION CALL
                
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                
  mov b, _s30 ; "Undeclared label: "
  swp b
  push b
  call error_s
  add sp, 4
; --- END FUNCTION CALL
  jmp _if93_exit
_if93_exit:
_if90_exit:
  jmp _if89_exit
_if89_else:
; if(toktype == INTEGER_CONST){ 
_if94_cond:
                
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if94_exit
_if94_TRUE:
; if(operand_types[j] == '#'){ 
_if95_cond:
                
  lea d, [bp + -134] ; $operand_types
  push a
  push d
                
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000023
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if95_else
_if95_TRUE:
; emit_byte(int_const, emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; instr_len++; 
                
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -123] ; $instr_len
  mov [d], b
  mov b, a
  jmp _if95_exit
_if95_else:
; if(operand_types[j] == '@'){ 
_if96_cond:
                
  lea d, [bp + -134] ; $operand_types
  push a
  push d
                
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if96_exit
_if96_TRUE:
; emit_word(int_const, emit_override); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
                
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  swp b
  push b
  call emit_word
  add sp, 3
; --- END FUNCTION CALL
; instr_len = instr_len + 2; 
  lea d, [bp + -123] ; $instr_len
  push d
                
  lea d, [bp + -123] ; $instr_len
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
  jmp _if96_exit
_if96_exit:
_if95_exit:
; j++; 
                
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -131] ; $j
  mov [d], b
  mov b, a
  jmp _if94_exit
_if94_exit:
_if89_exit:
_for87_update:
  jmp _for87_cond
_for87_exit:
; if(!emit_override){ 
_if97_cond:
                
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if97_exit
_if97_TRUE:
; printf("%x(%d): %s\n", old_pc, instr_len, code_line); 
                
; --- START FUNCTION CALL
                
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  lea d, [bp + -136] ; $old_pc
  mov b, [d]
  mov c, 0
  swp b
  push b
                
  mov b, _s29 ; "%x(%d): %s\n"
  swp b
  push b
  call printf
  add sp, 8
; --- END FUNCTION CALL
  jmp _if97_exit
_if97_exit:
; break; 
  jmp _for79_exit ; for break
_for79_update:
                
  lea d, [bp + -129] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -129] ; $i
  mov [d], b
  mov b, a
  jmp _for79_cond
_for79_exit:
_if69_exit:
; pop_prog(); 
                
; --- START FUNCTION CALL
  call pop_prog
  leave
  ret

parse_text:
  enter 0 ; (push bp; mov bp, sp)
; char *temp_prog; 
  sub sp, 2
; print("Parsing TEXT section...\n"); 
                
; --- START FUNCTION CALL
                
  mov b, _s31 ; "Parsing TEXT section...\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; prog = program; 
  mov d, _prog ; $prog
  push d
                
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; bin_p = bin_out + _org; 
  mov d, _bin_p ; $bin_p
  push d
                
  mov d, _bin_out ; $bin_out
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; pc = _org; 
  mov d, _pc ; $pc
  push d
                
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; for(;;){ 
_for98_init:
_for98_cond:
_for98_block:
; get(); 
                
; --- START FUNCTION CALL
  call get
; if(toktype == END) error("TEXT section not found."); 
_if99_cond:
                 
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if99_exit
_if99_TRUE:
; error("TEXT section not found."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s32 ; "TEXT section not found."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if99_exit
_if99_exit:
; if(tok == TEXT){ 
_if100_cond:
                 
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $4 ; enum element: TEXT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if100_exit
_if100_TRUE:
; break; 
  jmp _for98_exit ; for break
  jmp _if100_exit
_if100_exit:
_for98_update:
  jmp _for98_cond
_for98_exit:
; for(;;){ 
_for101_init:
_for101_cond:
_for101_block:
; get(); back(); 
                 
; --- START FUNCTION CALL
  call get
; back(); 
                 
; --- START FUNCTION CALL
  call back
; temp_prog = prog; 
  lea d, [bp + -1] ; $temp_prog
  push d
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get(); 
                 
; --- START FUNCTION CALL
  call get
; if(toktype == END) error("TEXT section end not found."); 
_if102_cond:
                 
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if102_exit
_if102_TRUE:
; error("TEXT section end not found."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s33 ; "TEXT section end not found."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if102_exit
_if102_exit:
; if(tok == DOT){ 
_if103_cond:
                 
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $10 ; enum element: DOT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if103_else
_if103_TRUE:
; get(); 
                 
; --- START FUNCTION CALL
  call get
; if(tok == SEGMENT_END) break; 
_if104_cond:
                 
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: SEGMENT_END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if104_else
_if104_TRUE:
; break; 
  jmp _for101_exit ; for break
  jmp _if104_exit
_if104_else:
; error("Unexpected directive."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s34 ; "Unexpected directive."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
_if104_exit:
  jmp _if103_exit
_if103_else:
; if(toktype == IDENTIFIER){ 
_if105_cond:
                 
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if105_exit
_if105_TRUE:
; get(); 
                 
; --- START FUNCTION CALL
  call get
; if(tok != COLON){ 
_if106_cond:
                 
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $d ; enum element: COLON
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if106_exit
_if106_TRUE:
; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
                 
  lea d, [bp + -1] ; $temp_prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; parse_instr(0); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000000
  push bl
  call parse_instr
  add sp, 1
; --- END FUNCTION CALL
  jmp _if106_exit
_if106_exit:
  jmp _if105_exit
_if105_exit:
_if103_exit:
_for101_update:
  jmp _for101_cond
_for101_exit:
; print("Done.\n\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s35 ; "Done.\n\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

debug:
  enter 0 ; (push bp; mov bp, sp)
; printf("\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s10 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; printf("Prog Offset: %x\n", prog - program); 
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  swp b
  push b
                 
  mov b, _s36 ; "Prog Offset: %x\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("Prog value : %c\n", *prog); 
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
                 
  mov b, _s37 ; "Prog value : %c\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("Token      : %s\n", token); 
                 
; --- START FUNCTION CALL
                 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                 
  mov b, _s38 ; "Token      : %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("Tok        : %d\n", tok); 
                 
; --- START FUNCTION CALL
                 
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s39 ; "Tok        : %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("Toktype    : %d\n", toktype); 
                 
; --- START FUNCTION CALL
                 
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s40 ; "Toktype    : %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("StringConst: %s\n", string_const); 
                 
; --- START FUNCTION CALL
                 
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  swp b
  push b
                 
  mov b, _s41 ; "StringConst: %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("PC         : %x\n", pc); 
                 
; --- START FUNCTION CALL
                 
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s42 ; "PC         : %x\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

display_output:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; unsigned char *p; 
  sub sp, 2
; print("\nAssembly complete.\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s43 ; "\nAssembly complete.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; printf("Program size: %d\n", prog_size); 
                 
; --- START FUNCTION CALL
                 
  mov d, _prog_size ; $prog_size
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s44 ; "Program size: %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; print("Listing: \n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s45 ; "Listing: \n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; p = bin_out + _org; 
  lea d, [bp + -3] ; $p
  push d
                 
  mov d, _bin_out ; $bin_out
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for107_init:
_for107_cond:
_for107_block:
; if(p == bin_p) break; 
_if108_cond:
                 
  lea d, [bp + -3] ; $p
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _bin_p ; $bin_p
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if108_exit
_if108_TRUE:
; break; 
  jmp _for107_exit ; for break
  jmp _if108_exit
_if108_exit:
; printx8(*p);  
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -3] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call printx8
  add sp, 1
; --- END FUNCTION CALL
; p++; 
                 
  lea d, [bp + -3] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $p
  mov [d], b
  dec b
_for107_update:
  jmp _for107_cond
_for107_exit:
; print("\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

is_reserved:
  enter 0 ; (push bp; mov bp, sp)
; return !strcmp(name, "a") 
                 
; --- START FUNCTION CALL
                 
  mov b, _s46 ; "a"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s47 ; "al"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s48 ; "ah"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s49 ; "b"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s50 ; "bl"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s51 ; "bh"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s52 ; "c"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s53 ; "cl"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s54 ; "ch"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s55 ; "d"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s56 ; "dl"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s57 ; "dh"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s58 ; "g"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s59 ; "gl"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s60 ; "gh"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s61 ; "pc"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s62 ; "sp"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s63 ; "bp"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s64 ; "si"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s65 ; "di"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s66 ; "word"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s67 ; "byte"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s68 ; "cmpsb"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s69 ; "movsb"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s70 ; "stosb"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

is_directive:
  enter 0 ; (push bp; mov bp, sp)
; return !strcmp(name, "org")  
                 
; --- START FUNCTION CALL
                 
  mov b, _s0 ; "org"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
                 
  mov b, _s71 ; "define"
  swp b
  push b
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

parse_label:
  enter 0 ; (push bp; mov bp, sp)
; char label_name[ 32      ]; 
  sub sp, 32
; get(); 
                 
; --- START FUNCTION CALL
  call get
; strcpy(label_name, token); 
                 
; --- START FUNCTION CALL
                 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
                 
  lea d, [bp + -31] ; $label_name
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; declare_label(label_name, pc); 
                 
; --- START FUNCTION CALL
                 
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  lea d, [bp + -31] ; $label_name
  mov b, d
  mov c, 0
  swp b
  push b
  call declare_label
  add sp, 4
; --- END FUNCTION CALL
; get(); // get ':' 
                 
; --- START FUNCTION CALL
  call get
  leave
  ret

declare_label:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i <  16          ; i++){ 
_for109_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for109_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000010
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for109_exit
_for109_block:
; if(!label_table[i].name[0]){ 
_if110_cond:
                 
  mov d, _label_table_data ; $label_table
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  push a
  push d
                 
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if110_exit
_if110_TRUE:
; strcpy(label_table[i].name, name); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _label_table_data ; $label_table
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; label_table[i].address = address; 
  mov d, _label_table_data ; $label_table
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 16
  push d
                 
  lea d, [bp + 7] ; $address
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; return i; 
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if110_exit
_if110_exit:
_for109_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for109_cond
_for109_exit:
  leave
  ret

get_label_addr:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i <  16          ; i++){ 
_for111_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for111_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000010
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for111_exit
_for111_block:
; if(!strcmp(label_table[i].name, name)){ 
_if112_cond:
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _label_table_data ; $label_table
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if112_exit
_if112_TRUE:
; return label_table[i].address; 
                 
  mov d, _label_table_data ; $label_table
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 16
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if112_exit
_if112_exit:
_for111_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for111_cond
_for111_exit:
; error_s("Label does not exist: ", name); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov b, _s72 ; "Label does not exist: "
  swp b
  push b
  call error_s
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

label_exists:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i <  16          ; i++){ 
_for113_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for113_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000010
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for113_exit
_for113_block:
; if(!strcmp(label_table[i].name, name)){ 
_if114_cond:
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _label_table_data ; $label_table
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if114_exit
_if114_TRUE:
; return i; 
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if114_exit
_if114_exit:
_for113_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for113_cond
_for113_exit:
; return -1; 
                 
  mov32 cb, $ffffffff
  leave
  ret

search_opcode:
  enter 0 ; (push bp; mov bp, sp)
; char opcode_str[24]; 
  sub sp, 24
; char opcode_hex[5]; 
  sub sp, 5
; char *hex_p; 
  sub sp, 2
; char *op_p; 
  sub sp, 2
; char *tbl_p; 
  sub sp, 2
; struct t_opcode return_opcode; 
  sub sp, 26
; tbl_p = opcode_table; 
  lea d, [bp + -34] ; $tbl_p
  push d
                 
  mov d, _opcode_table ; $opcode_table
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; for(;;){ 
_for115_init:
_for115_cond:
_for115_block:
; op_p = opcode_str; 
  lea d, [bp + -32] ; $op_p
  push d
                 
  lea d, [bp + -23] ; $opcode_str
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; hex_p = opcode_hex; 
  lea d, [bp + -30] ; $hex_p
  push d
                 
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; while(*tbl_p != ' ') *op_p++ = *tbl_p++; 
_while116_cond:
                 
  lea d, [bp + -34] ; $tbl_p
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
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while116_exit
_while116_block:
; *op_p++ = *tbl_p++; 
  lea d, [bp + -32] ; $op_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -32] ; $op_p
  mov [d], b
  dec b
  push b
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while116_cond
_while116_exit:
; *op_p++ = *tbl_p++; 
  lea d, [bp + -32] ; $op_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -32] ; $op_p
  mov [d], b
  dec b
  push b
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; while(*tbl_p != ' ') *op_p++ = *tbl_p++; 
_while117_cond:
                 
  lea d, [bp + -34] ; $tbl_p
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
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while117_exit
_while117_block:
; *op_p++ = *tbl_p++; 
  lea d, [bp + -32] ; $op_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -32] ; $op_p
  mov [d], b
  dec b
  push b
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while117_cond
_while117_exit:
; *op_p = '\0'; 
  lea d, [bp + -32] ; $op_p
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if(!strcmp(opcode_str, what_opcode)){ 
_if118_cond:
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $what_opcode
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  lea d, [bp + -23] ; $opcode_str
  mov b, d
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if118_else
_if118_TRUE:
; strcpy(return_opcode.name, what_opcode); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $what_opcode
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  lea d, [bp + -60] ; $return_opcode
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; while(*tbl_p == ' ') tbl_p++; 
_while119_cond:
                 
  lea d, [bp + -34] ; $tbl_p
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
  je _while119_exit
_while119_block:
; tbl_p++; 
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  jmp _while119_cond
_while119_exit:
; while(is_hex_digit(*tbl_p)) *hex_p++ = *tbl_p++; // Copy hex opcode 
_while120_cond:
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_hex_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while120_exit
_while120_block:
; *hex_p++ = *tbl_p++; // Copy hex opcode 
  lea d, [bp + -30] ; $hex_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -30] ; $hex_p
  mov [d], b
  dec b
  push b
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while120_cond
_while120_exit:
; *hex_p = '\0'; 
  lea d, [bp + -30] ; $hex_p
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if(strlen(opcode_hex) == 4){ 
_if121_cond:
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if121_else
_if121_TRUE:
; return_opcode.opcode_type = 1; 
  lea d, [bp + -60] ; $return_opcode
  add d, 25
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], bl
; *(opcode_hex + 2) = '\0'; 
                 
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; return_opcode.opcode = hex_to_int(opcode_hex); 
  lea d, [bp + -60] ; $return_opcode
  add d, 24
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
  swp b
  push b
  call hex_to_int
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], bl
  jmp _if121_exit
_if121_else:
; return_opcode.opcode_type = 0; 
  lea d, [bp + -60] ; $return_opcode
  add d, 25
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return_opcode.opcode = hex_to_int(opcode_hex); 
  lea d, [bp + -60] ; $return_opcode
  add d, 24
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
  swp b
  push b
  call hex_to_int
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], bl
_if121_exit:
; return return_opcode; 
                 
  lea d, [bp + -60] ; $return_opcode
  mov b, d
  mov c, 0
  leave
  ret
  jmp _if118_exit
_if118_else:
; while(*tbl_p != '\n') tbl_p++; 
_while122_cond:
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while122_exit
_while122_block:
; tbl_p++; 
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  jmp _while122_cond
_while122_exit:
; while(*tbl_p == '\n') tbl_p++; 
_while123_cond:
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while123_exit
_while123_block:
; tbl_p++; 
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  jmp _while123_cond
_while123_exit:
; if(!*tbl_p) break; 
_if124_cond:
                 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if124_exit
_if124_TRUE:
; break; 
  jmp _for115_exit ; for break
  jmp _if124_exit
_if124_exit:
_if118_exit:
_for115_update:
  jmp _for115_cond
_for115_exit:
; return_opcode.name[0] = '\0'; 
  lea d, [bp + -60] ; $return_opcode
  add d, 0
  push a
  push d
                 
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return return_opcode; 
                 
  lea d, [bp + -60] ; $return_opcode
  mov b, d
  mov c, 0
  leave
  ret

forwards:
  enter 0 ; (push bp; mov bp, sp)
; bin_p = bin_p + amount; 
  mov d, _bin_p ; $bin_p
  push d
                 
  mov d, _bin_p ; $bin_p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $amount
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; prog_size = prog_size + amount; 
  mov d, _prog_size ; $prog_size
  push d
                 
  mov d, _prog_size ; $prog_size
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $amount
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; pc = pc + amount; 
  mov d, _pc ; $pc
  push d
                 
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $amount
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  leave
  ret

emit_byte:
  enter 0 ; (push bp; mov bp, sp)
; if(!emit_override){ 
_if125_cond:
                 
  lea d, [bp + 6] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if125_exit
_if125_TRUE:
; *bin_p = byte; 
  mov d, _bin_p ; $bin_p
  mov b, [d]
  mov c, 0
  push b
                 
  lea d, [bp + 5] ; $byte
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _if125_exit
_if125_exit:
; forwards(1); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

emit_word:
  enter 0 ; (push bp; mov bp, sp)
; if(!emit_override){ 
_if126_cond:
                 
  lea d, [bp + 7] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if126_exit
_if126_TRUE:
; *((int*)bin_p) = word; 
                 
  mov d, _bin_p ; $bin_p
  mov b, [d]
  mov c, 0
  push b
                 
  lea d, [bp + 5] ; $word
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if126_exit
_if126_exit:
; forwards(2); 
                 
; --- START FUNCTION CALL
                 
  mov32 cb, $00000002
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

back:
  enter 0 ; (push bp; mov bp, sp)
; char *t; 
  sub sp, 2
; t = token; 
  lea d, [bp + -1] ; $t
  push d
                 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; while(*t){ 
_while127_cond:
                 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while127_exit
_while127_block:
; prog--; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  dec b
  mov d, _prog ; $prog
  mov [d], b
  inc b
; t++; 
                 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  jmp _while127_cond
_while127_exit:
  leave
  ret

get_path:
  enter 0 ; (push bp; mov bp, sp)
; char *t; 
  sub sp, 2
; *token = '\0'; 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; tok = 0; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; toktype = 0; 
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; t = token; 
  lea d, [bp + -1] ; $t
  push d
                 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; while(is_space(*prog)) prog++; 
_while128_cond:
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_space
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while128_exit
_while128_block:
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while128_cond
_while128_exit:
; if(*prog == '\0'){ 
_if129_cond:
                 
  mov d, _prog ; $prog
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
  je _if129_exit
_if129_TRUE:
; toktype = END; 
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $7 ; enum element: END
  pop d
  mov [d], b
; return; 
  leave
  ret
  jmp _if129_exit
_if129_exit:
; while(*prog == '/' || is_alpha(*prog) || is_digit(*prog) || *prog == '_' || *prog == '-' || *prog == '.') { 
_while130_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002f
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_alpha
  add sp, 1
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
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
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005f
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
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
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _while130_exit
_while130_block:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while130_cond
_while130_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

is_hex_digit:
  enter 0 ; (push bp; mov bp, sp)
; return c >= '0' && c <= '9' || c >= 'A' && c <= 'F' || c >= 'a' && c <= 'f'; 
                 
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
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
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000046
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000061
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
  mov32 cb, $00000066
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

get_line:
  enter 0 ; (push bp; mov bp, sp)
; char *t; 
  sub sp, 2
; t = string_const; 
  lea d, [bp + -1] ; $t
  push d
                 
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; while(*prog != 0x0A && *prog != '\0'){ 
_while131_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _prog ; $prog
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
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while131_exit
_while131_block:
; if(*prog == ';'){ 
_if132_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if132_else
_if132_TRUE:
; while(*prog != 0x0A && *prog != '\0') prog++; 
_while133_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _prog ; $prog
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
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while133_exit
_while133_block:
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while133_cond
_while133_exit:
; break; 
  jmp _while131_exit ; while break
  jmp _if132_exit
_if132_else:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_if132_exit:
  jmp _while131_cond
_while131_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

get:
  enter 0 ; (push bp; mov bp, sp)
; char *t; 
  sub sp, 2
; char temp_hex[64]; 
  sub sp, 64
; char *p; 
  sub sp, 2
; *token = '\0'; 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; tok = TOK_UNDEF; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $0 ; enum element: TOK_UNDEF
  pop d
  mov [d], b
; toktype = TYPE_UNDEF; 
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $0 ; enum element: TYPE_UNDEF
  pop d
  mov [d], b
; t = token; 
  lea d, [bp + -1] ; $t
  push d
                 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; do{ 
_do134_block:
; while(is_space(*prog)) prog++; 
_while135_cond:
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_space
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while135_exit
_while135_block:
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while135_cond
_while135_exit:
; if(*prog == ';'){ 
_if136_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if136_exit
_if136_TRUE:
; while(*prog != '\n') prog++; 
_while137_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while137_exit
_while137_block:
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while137_cond
_while137_exit:
; if(*prog == '\n') prog++; 
_if138_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if138_exit
_if138_TRUE:
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _if138_exit
_if138_exit:
  jmp _if136_exit
_if136_exit:
; } while(is_space(*prog) || *prog == ';'); 
_do134_cond:
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_space
  add sp, 1
; --- END FUNCTION CALL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 1
  je _do134_block
_do134_exit:
; if(*prog == '\0'){ 
_if139_cond:
                 
  mov d, _prog ; $prog
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
  je _if139_exit
_if139_TRUE:
; toktype = END; 
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $7 ; enum element: END
  pop d
  mov [d], b
; return; 
  leave
  ret
  jmp _if139_exit
_if139_exit:
; if(is_alpha(*prog)){ 
_if140_cond:
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_alpha
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if140_else
_if140_TRUE:
; while(is_alpha(*prog) || is_digit(*prog)){ 
_while141_cond:
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_alpha
  add sp, 1
; --- END FUNCTION CALL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
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
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _while141_exit
_while141_block:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while141_cond
_while141_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if((tok = search_keyword(token)) != -1)  
_if142_cond:
                 
  mov d, _tok ; $tok
  push d
                 
; --- START FUNCTION CALL
                 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call search_keyword
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if142_else
_if142_TRUE:
; toktype = KEYWORD; 
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $1 ; enum element: KEYWORD
  pop d
  mov [d], b
  jmp _if142_exit
_if142_else:
; toktype = IDENTIFIER; 
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $6 ; enum element: IDENTIFIER
  pop d
  mov [d], b
_if142_exit:
  jmp _if140_exit
_if140_else:
; if(is_digit(*prog) || (*prog == '$' && is_hex_digit(*(prog+1)))){ 
_if143_cond:
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
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
; --- START LOGICAL OR
  push a
  mov a, b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000024
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
                 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_hex_digit
  add sp, 1
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if143_else
_if143_TRUE:
; if(*prog == '$' && is_hex_digit(*(prog+1))){ 
_if144_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000024
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
                 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_hex_digit
  add sp, 1
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if144_else
_if144_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; p = temp_hex; 
  lea d, [bp + -67] ; $p
  push d
                 
  lea d, [bp + -65] ; $temp_hex
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; *t++ = *p++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  lea d, [bp + -67] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -67] ; $p
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  pop d
  mov [d], bl
; while(is_hex_digit(*prog)){ 
_while145_cond:
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_hex_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while145_exit
_while145_block:
; *t++ = *p++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  lea d, [bp + -67] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -67] ; $p
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  pop d
  mov [d], bl
  jmp _while145_cond
_while145_exit:
; *t = *p = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  lea d, [bp + -67] ; $p
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
  pop d
  mov [d], bl
; int_const = hex_to_int(temp_hex); 
  mov d, _int_const ; $int_const
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + -65] ; $temp_hex
  mov b, d
  mov c, 0
  swp b
  push b
  call hex_to_int
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _if144_exit
_if144_else:
; while(is_digit(*prog)){ 
_while146_cond:
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
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
  je _while146_exit
_while146_block:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while146_cond
_while146_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; int_const = atoi(token); 
  mov d, _int_const ; $int_const
  push d
                 
; --- START FUNCTION CALL
                 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call atoi
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
_if144_exit:
; toktype = INTEGER_CONST; 
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $5 ; enum element: INTEGER_CONST
  pop d
  mov [d], b
  jmp _if143_exit
_if143_else:
; if(*prog == '\''){ 
_if147_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000027
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if147_else
_if147_TRUE:
; *t++ = '\''; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000027
  pop d
  mov [d], bl
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; if(*prog == '\\'){ 
_if148_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if148_else
_if148_TRUE:
; *t++ = '\\'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $0000005c
  pop d
  mov [d], bl
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _if148_exit
_if148_else:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_if148_exit:
; if(*prog != '\''){ 
_if149_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000027
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if149_exit
_if149_TRUE:
; error("Closing single quotes expected."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s73 ; "Closing single quotes expected."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if149_exit
_if149_exit:
; *t++ = '\''; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000027
  pop d
  mov [d], bl
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; toktype = CHAR_CONST; 
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $3 ; enum element: CHAR_CONST
  pop d
  mov [d], b
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; convert_constant(); // converts this string token with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
                 
; --- START FUNCTION CALL
  call convert_constant
  jmp _if147_exit
_if147_else:
; if(*prog == '\"'){ 
_if150_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000022
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if150_else
_if150_TRUE:
; *t++ = '\"'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000022
  pop d
  mov [d], bl
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; while(*prog != '\"' && *prog){ 
_while151_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000022
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while151_exit
_while151_block:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while151_cond
_while151_exit:
; if(*prog != '\"') error("Double quotes expected"); 
_if152_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000022
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if152_exit
_if152_TRUE:
; error("Double quotes expected"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s74 ; "Double quotes expected"
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if152_exit
_if152_exit:
; *t++ = '\"'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000022
  pop d
  mov [d], bl
; prog++; 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; toktype = STRING_CONST; 
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $4 ; enum element: STRING_CONST
  pop d
  mov [d], b
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; convert_constant(); // converts this string token with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
                 
; --- START FUNCTION CALL
  call convert_constant
  jmp _if150_exit
_if150_else:
; if(*prog == '['){ 
_if153_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if153_else
_if153_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = OPENING_BRACKET; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $b ; enum element: OPENING_BRACKET
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if153_exit
_if153_else:
; if(*prog == ']'){ 
_if154_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if154_else
_if154_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = CLOSING_BRACKET; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $c ; enum element: CLOSING_BRACKET
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if154_exit
_if154_else:
; if(*prog == '+'){ 
_if155_cond:
                 
  mov d, _prog ; $prog
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
  cmp b, 0
  je _if155_else
_if155_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = PLUS; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $8 ; enum element: PLUS
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if155_exit
_if155_else:
; if(*prog == '-'){ 
_if156_cond:
                 
  mov d, _prog ; $prog
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
  je _if156_else
_if156_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = MINUS; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $9 ; enum element: MINUS
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if156_exit
_if156_else:
; if(*prog == '$'){ 
_if157_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000024
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if157_else
_if157_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = DOLLAR; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $a ; enum element: DOLLAR
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if157_exit
_if157_else:
; if(*prog == ':'){ 
_if158_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if158_else
_if158_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = COLON; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $d ; enum element: COLON
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if158_exit
_if158_else:
; if(*prog == ';'){ 
_if159_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if159_else
_if159_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = SEMICOLON; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $e ; enum element: SEMICOLON
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if159_exit
_if159_else:
; if(*prog == ','){ 
_if160_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if160_else
_if160_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = COMMA; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $f ; enum element: COMMA
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if160_exit
_if160_else:
; if(*prog == '.'){ 
_if161_cond:
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if161_exit
_if161_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = DOT; 
  mov d, _tok ; $tok
  push d
                 
  mov32 cb, $10 ; enum element: DOT
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
                 
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if161_exit
_if161_exit:
_if160_exit:
_if159_exit:
_if158_exit:
_if157_exit:
_if156_exit:
_if155_exit:
_if154_exit:
_if153_exit:
_if150_exit:
_if147_exit:
_if143_exit:
_if140_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if(toktype == TYPE_UNDEF){ 
_if162_cond:
                 
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0 ; enum element: TYPE_UNDEF
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if162_exit
_if162_TRUE:
; print("TOKEN ERROR. Prog: "); printx16((int)(prog-program));  
                 
; --- START FUNCTION CALL
                 
  mov b, _s75 ; "TOKEN ERROR. Prog: "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; printx16((int)(prog-program));  
                 
; --- START FUNCTION CALL
                 
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  snex b
  swp b
  push b
  call printx16
  add sp, 2
; --- END FUNCTION CALL
; print(", ProgVal: "); putchar(*prog);  
                 
; --- START FUNCTION CALL
                 
  mov b, _s76 ; ", ProgVal: "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; putchar(*prog);  
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
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
; print("\n Text after prog: \n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s77 ; "\n Text after prog: \n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(prog); 
                 
; --- START FUNCTION CALL
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; exit(); 
                 
; --- START FUNCTION CALL
  call exit
  jmp _if162_exit
_if162_exit:
  leave
  ret

convert_constant:
  enter 0 ; (push bp; mov bp, sp)
; char *s; 
  sub sp, 2
; char *t; 
  sub sp, 2
; t = token; 
  lea d, [bp + -3] ; $t
  push d
                 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; s = string_const; 
  lea d, [bp + -1] ; $s
  push d
                 
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; if(toktype == CHAR_CONST){ 
_if163_cond:
                 
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if163_else
_if163_TRUE:
; t++; 
                 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; if(*t == '\\'){ 
_if164_cond:
                 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if164_else
_if164_TRUE:
; t++; 
                 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; switch(*t){ 
_switch165_expr:
                 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch165_comparisons:
  cmp bl, $30
  je _switch165_case0
  cmp bl, $61
  je _switch165_case1
  cmp bl, $62
  je _switch165_case2
  cmp bl, $66
  je _switch165_case3
  cmp bl, $6e
  je _switch165_case4
  cmp bl, $72
  je _switch165_case5
  cmp bl, $74
  je _switch165_case6
  cmp bl, $76
  je _switch165_case7
  cmp bl, $5c
  je _switch165_case8
  cmp bl, $27
  je _switch165_case9
  cmp bl, $22
  je _switch165_case10
  jmp _switch165_exit
_switch165_case0:
; *s++ = '\0'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
; break; 
  jmp _switch165_exit ; case break
_switch165_case1:
; *s++ = '\a'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000007
  pop d
  mov [d], bl
; break; 
  jmp _switch165_exit ; case break
_switch165_case2:
; *s++ = '\b'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000008
  pop d
  mov [d], bl
; break;   
  jmp _switch165_exit ; case break
_switch165_case3:
; *s++ = '\f'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $0000000c
  pop d
  mov [d], bl
; break; 
  jmp _switch165_exit ; case break
_switch165_case4:
; *s++ = '\n'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $0000000a
  pop d
  mov [d], bl
; break; 
  jmp _switch165_exit ; case break
_switch165_case5:
; *s++ = '\r'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $0000000d
  pop d
  mov [d], bl
; break; 
  jmp _switch165_exit ; case break
_switch165_case6:
; *s++ = '\t'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000009
  pop d
  mov [d], bl
; break; 
  jmp _switch165_exit ; case break
_switch165_case7:
; *s++ = '\v'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $0000000b
  pop d
  mov [d], bl
; break; 
  jmp _switch165_exit ; case break
_switch165_case8:
; *s++ = '\\'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $0000005c
  pop d
  mov [d], bl
; break; 
  jmp _switch165_exit ; case break
_switch165_case9:
; *s++ = '\''; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000027
  pop d
  mov [d], bl
; break; 
  jmp _switch165_exit ; case break
_switch165_case10:
; *s++ = '\"'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  mov32 cb, $00000022
  pop d
  mov [d], bl
_switch165_exit:
  jmp _if164_exit
_if164_else:
; *s++ = *t; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_if164_exit:
  jmp _if163_exit
_if163_else:
; if(toktype == STRING_CONST){ 
_if166_cond:
                 
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $4 ; enum element: STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if166_exit
_if166_TRUE:
; t++; 
                 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; while(*t != '\"' && *t){ 
_while167_cond:
                 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000022
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while167_exit
_while167_block:
; *s++ = *t++; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
                 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while167_cond
_while167_exit:
  jmp _if166_exit
_if166_exit:
_if163_exit:
; *s = '\0'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  push b
                 
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

error:
  enter 0 ; (push bp; mov bp, sp)
; print("\nError: "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s78 ; "\nError: "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(msg); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $msg
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; exit(); 
                 
; --- START FUNCTION CALL
  call exit
  leave
  ret

error_s:
  enter 0 ; (push bp; mov bp, sp)
; print("\nError: "); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s78 ; "\nError: "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(msg); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $msg
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(param); 
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 7] ; $param
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s10 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; exit(); 
                 
; --- START FUNCTION CALL
  call exit
  leave
  ret

push_prog:
  enter 0 ; (push bp; mov bp, sp)
; if(prog_tos == 10) error("Cannot push prog. Stack overflow."); 
_if168_cond:
                 
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if168_exit
_if168_TRUE:
; error("Cannot push prog. Stack overflow."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s79 ; "Cannot push prog. Stack overflow."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if168_exit
_if168_exit:
; prog_stack[prog_tos] = prog; 
  mov d, _prog_stack_data ; $prog_stack
  push a
  push d
                 
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
                 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; prog_tos++; 
                 
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, _prog_tos ; $prog_tos
  mov [d], b
  mov b, a
  leave
  ret

pop_prog:
  enter 0 ; (push bp; mov bp, sp)
; if(prog_tos == 0) error("Cannot pop prog. Stack overflow."); 
_if169_cond:
                 
  mov d, _prog_tos ; $prog_tos
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
  je _if169_exit
_if169_TRUE:
; error("Cannot pop prog. Stack overflow."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s80 ; "Cannot pop prog. Stack overflow."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if169_exit
_if169_exit:
; prog_tos--; 
                 
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  mov d, _prog_tos ; $prog_tos
  mov [d], b
  mov b, a
; prog = prog_stack[prog_tos]; 
  mov d, _prog ; $prog
  push d
                 
  mov d, _prog_stack_data ; $prog_stack
  push a
  push d
                 
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  leave
  ret

search_keyword:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; keywords[i].keyword[0]; i++) 
_for170_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for170_cond:
                 
  mov d, _keywords_data ; $keywords
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 3 ; mov a, 3; mul a, b; add d, b
  pop a
  add d, 0
  push a
  push d
                 
  mov32 cb, $00000000
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _for170_exit
_for170_block:
; if (!strcmp(keywords[i].keyword, keyword)) return keywords[i].tok; 
_if171_cond:
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $keyword
  mov b, [d]
  mov c, 0
  swp b
  push b
                 
  mov d, _keywords_data ; $keywords
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 3 ; mov a, 3; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if171_exit
_if171_TRUE:
; return keywords[i].tok; 
                 
  mov d, _keywords_data ; $keywords
  push a
  push d
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 3 ; mov a, 3; mul a, b; add d, b
  pop a
  add d, 2
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret
  jmp _if171_exit
_if171_exit:
_for170_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for170_cond
_for170_exit:
; return -1; 
                 
  mov32 cb, $ffffffff
  leave
  ret

hex_to_int:
  enter 0 ; (push bp; mov bp, sp)
; int value = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $value
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i; 
  sub sp, 2
; char hex_char; 
  sub sp, 1
; int len; 
  sub sp, 2
; len = strlen(hex_string); 
  lea d, [bp + -6] ; $len
  push d
                 
; --- START FUNCTION CALL
                 
  lea d, [bp + 5] ; $hex_string
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for (i = 0; i < len; i++) { 
_for172_init:
  lea d, [bp + -3] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for172_cond:
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for172_exit
_for172_block:
; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
                 
  lea d, [bp + 5] ; $hex_string
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
; if (hex_char >= 'a' && hex_char <= 'f')  
_if173_cond:
                 
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000061
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000066
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if173_else
_if173_TRUE:
; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value
  push d
                 
                 
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000010
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_174  
  neg a 
skip_invert_a_174:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_174  
  neg b 
skip_invert_b_174:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_174
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_174:
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
                 
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000061
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $0000000a
  add b, a
  pop a
; --- END TERMS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if173_exit
_if173_else:
; if (hex_char >= 'A' && hex_char <= 'F')  
_if175_cond:
                 
  lea d, [bp + -4] ; $hex_char
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
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000046
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if175_else
_if175_TRUE:
; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value
  push d
                 
                 
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000010
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_176  
  neg a 
skip_invert_a_176:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_176  
  neg b 
skip_invert_b_176:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_176
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_176:
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
                 
  lea d, [bp + -4] ; $hex_char
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
  mov32 cb, $0000000a
  add b, a
  pop a
; --- END TERMS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if175_exit
_if175_else:
; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value
  push d
                 
                 
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000010
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_177  
  neg a 
skip_invert_a_177:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_177  
  neg b 
skip_invert_b_177:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_177
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_177:
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
                 
  lea d, [bp + -4] ; $hex_char
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
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
_if175_exit:
_if173_exit:
_for172_update:
                 
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for172_cond
_for172_exit:
; return value; 
                 
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
  leave
  ret

loadfile:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  meta mov d, destination
  mov a, [d]
  mov di, a
  meta mov d, filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem
; --- END INLINE ASM SEGMENT
  leave
  ret

exp:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int result = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $result
  push d
                 
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; for(i = 0; i < exp; i++){ 
_for178_init:
  lea d, [bp + -1] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for178_cond:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $exp
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for178_exit
_for178_block:
; result = result * base; 
  lea d, [bp + -3] ; $result
  push d
                 
  lea d, [bp + -3] ; $result
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $base
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
  jz skip_invert_a_179  
  neg a 
skip_invert_a_179:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_179  
  neg b 
skip_invert_b_179:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_179
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_179:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
_for178_update:
                 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for178_cond
_for178_exit:
; return result; 
                 
  lea d, [bp + -3] ; $result
  mov b, [d]
  mov c, 0
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

alloc:
  enter 0 ; (push bp; mov bp, sp)
; heap_top = heap_top + bytes; 
  mov d, _heap_top ; $heap_top
  push d
                 
  mov d, _heap_top ; $heap_top
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; return heap_top - bytes; 
                 
  mov d, _heap_top ; $heap_top
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  leave
  ret

is_space:
  enter 0 ; (push bp; mov bp, sp)
; return c == ' ' || c == '\t' || c == '\n' || c == '\r'; 
                 
  lea d, [bp + 5] ; $c
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000009
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

is_alpha:
  enter 0 ; (push bp; mov bp, sp)
; return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_'); 
                 
                 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000061
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
  mov32 cb, $0000007a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
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
  lea d, [bp + 5] ; $c
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
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005f
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
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

strcmp:
  enter 0 ; (push bp; mov bp, sp)
; while (*s1 && (*s1 == *s2)) { 
_while180_cond:
                 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
                 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov c, 0
  mov d, b
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
  je _while180_exit
_while180_block:
; s1++; 
                 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $s1
  mov [d], b
  dec b
; s2++; 
                 
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 7] ; $s2
  mov [d], b
  dec b
  jmp _while180_cond
_while180_exit:
; return *s1 - *s2; 
                 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
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
_while181_cond:
                 
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
  je _while181_exit
_while181_block:
; length++; 
                 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, a
  jmp _while181_cond
_while181_exit:
; return length; 
                 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
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
_while182_cond:
                 
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
  je _while182_exit
_while182_block:
; str++; 
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while182_cond
_while182_exit:
; if (*str == '-' || *str == '+') { 
_if183_cond:
                 
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
  je _if183_exit
_if183_TRUE:
; if (*str == '-') sign = -1; 
_if184_cond:
                 
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
  je _if184_exit
_if184_TRUE:
; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
                 
  mov32 cb, $ffffffff
  pop d
  mov [d], b
  jmp _if184_exit
_if184_exit:
; str++; 
                 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _if183_exit
_if183_exit:
; while (*str >= '0' && *str <= '9') { 
_while185_cond:
                 
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
  je _while185_exit
_while185_block:
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
  jz skip_invert_a_186  
  neg a 
skip_invert_a_186:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_186  
  neg b 
skip_invert_b_186:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_186
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_186:
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
  jmp _while185_cond
_while185_exit:
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
  jz skip_invert_a_187  
  neg a 
skip_invert_a_187:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_187  
  neg b 
skip_invert_b_187:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_187
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_187:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  syscall sys_terminate_proc
; --- END INLINE ASM SEGMENT
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
_while188_cond:
                 
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while188_exit
_while188_block:
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
  jmp _while188_cond
_while188_exit:
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
_for189_init:
  lea d, [bp + -3] ; $i
  push d
                 
  mov32 cb, $00000000
  pop d
  mov [d], b
_for189_cond:
                 
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
  je _for189_exit
_for189_block:
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
_for189_update:
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
  jmp _for189_cond
_for189_exit:
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
_for190_init:
_for190_cond:
_for190_block:
; if(!*format_p) break; 
_if191_cond:
                 
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
  je _if191_else
_if191_TRUE:
; break; 
  jmp _for190_exit ; for break
  jmp _if191_exit
_if191_else:
; if(*format_p == '%'){ 
_if192_cond:
                 
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
  je _if192_else
_if192_TRUE:
; format_p++; 
                 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch193_expr:
                 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch193_comparisons:
  cmp bl, $6c
  je _switch193_case0
  cmp bl, $4c
  je _switch193_case1
  cmp bl, $64
  je _switch193_case2
  cmp bl, $69
  je _switch193_case3
  cmp bl, $75
  je _switch193_case4
  cmp bl, $78
  je _switch193_case5
  cmp bl, $63
  je _switch193_case6
  cmp bl, $73
  je _switch193_case7
  jmp _switch193_default
  jmp _switch193_exit
_switch193_case0:
_switch193_case1:
; format_p++; 
                 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if194_cond:
                 
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
  je _if194_else
_if194_TRUE:
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
  jmp _if194_exit
_if194_else:
; if(*format_p == 'u') 
_if195_cond:
                 
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
  je _if195_else
_if195_TRUE:
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
  jmp _if195_exit
_if195_else:
; if(*format_p == 'x') 
_if196_cond:
                 
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
  je _if196_else
_if196_TRUE:
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
  jmp _if196_exit
_if196_else:
; err("Unexpected format in printf."); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s81 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if196_exit:
_if195_exit:
_if194_exit:
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
  jmp _switch193_exit ; case break
_switch193_case2:
_switch193_case3:
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
  jmp _switch193_exit ; case break
_switch193_case4:
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
  jmp _switch193_exit ; case break
_switch193_case5:
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
  jmp _switch193_exit ; case break
_switch193_case6:
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
  jmp _switch193_exit ; case break
_switch193_case7:
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
  jmp _switch193_exit ; case break
_switch193_default:
; print("Error: Unknown argument type.\n"); 
                 
; --- START FUNCTION CALL
                 
  mov b, _s82 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch193_exit:
; format_p++; 
                 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if192_exit
_if192_else:
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
_if192_exit:
_if191_exit:
_for190_update:
  jmp _for190_cond
_for190_exit:
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
_if197_cond:
                 
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
  je _if197_else
_if197_TRUE:
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
  jmp _if197_exit
_if197_else:
; if (num == 0) { 
_if198_cond:
                 
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
  je _if198_exit
_if198_TRUE:
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
  jmp _if198_exit
_if198_exit:
_if197_exit:
; while (num > 0) { 
_while199_cond:
                 
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
  je _while199_exit
_while199_block:
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
  jmp _while199_cond
_while199_exit:
; while (i > 0) { 
_while202_cond:
                 
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
  je _while202_exit
_while202_block:
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
  jmp _while202_cond
_while202_exit:
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
_if203_cond:
                 
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
  je _if203_exit
_if203_TRUE:
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
  jmp _if203_exit
_if203_exit:
; while (num > 0) { 
_while204_cond:
                 
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
  je _while204_exit
_while204_block:
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
  jmp _while204_cond
_while204_exit:
; while (i > 0) { 
_while207_cond:
                 
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
  je _while207_exit
_while207_block:
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
  jmp _while207_cond
_while207_exit:
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
_if208_cond:
                 
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
  je _if208_else
_if208_TRUE:
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
  jmp _if208_exit
_if208_else:
; if (num == 0) { 
_if209_cond:
                 
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
  je _if209_exit
_if209_TRUE:
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
  jmp _if209_exit
_if209_exit:
_if208_exit:
; while (num > 0) { 
_while210_cond:
                 
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
  je _while210_exit
_while210_block:
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
  jmp _while210_cond
_while210_exit:
; while (i > 0) { 
_while213_cond:
                 
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
  je _while213_exit
_while213_block:
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
  jmp _while213_cond
_while213_exit:
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
_if214_cond:
                 
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
  je _if214_exit
_if214_TRUE:
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
  jmp _if214_exit
_if214_exit:
; while (num > 0) { 
_while215_cond:
                 
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
  je _while215_exit
_while215_block:
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
  jmp _while215_cond
_while215_exit:
; while (i > 0) { 
_while218_cond:
                 
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
  je _while218_exit
_while218_block:
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
  jmp _while218_cond
_while218_exit:
  leave
  ret

printx8:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov bl, [d]
  call _itoa_printx8        ; convert bl to char in A
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
_itoa_printx8:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits_printx8]
  mov ah, al
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits_printx8]
  pop b
  pop d
  ret
s_hex_digits_printx8:    .db "0123456789ABCDEF"  
; --- END INLINE ASM SEGMENT
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_keywords_data:
.dw _s0
.db 1
.dw _s1
.db 2
.dw _s2
.db 3
.dw _s3
.db 4
.dw _s4
.db 6
.dw _s5
.db 7
.dw _s6
.db 5
.dw _s7
.db 0
_label_table_data: .fill 288, 0
__org: .dw $0400
_pc: .fill 2, 0
_print_information: .db $01
_tok: .fill 2, 0
_toktype: .fill 2, 0
_prog: .fill 2, 0
_token_data: .fill 64, 0
_string_const_data: .fill 256, 0
_int_const: .fill 2, 0
_program: .fill 2, 0
_bin_out: .fill 2, 0
_bin_p: .fill 2, 0
_opcode_table: .fill 2, 0
_prog_stack_data: .fill 20, 0
_prog_tos: .fill 2, 0
_prog_size: .fill 2, 0
_symbols_data: 
.dw 
.dw _s8, _s9, _s9, _s8, _s8, _s8, _s9, _s9, 
_s0: .db "org", 0
_s1: .db "include", 0
_s2: .db "data", 0
_s3: .db "text", 0
_s4: .db "db", 0
_s5: .db "dw", 0
_s6: .db "end", 0
_s7: .db "", 0
_s8: .db "@", 0
_s9: .db "#", 0
_s10: .db "\n", 0
_s11: .db "./config.d/op_tbl", 0
_s12: .db "Parsing DATA section...", 0
_s13: .db "Data segment not found.", 0
_s14: .db ".db: ", 0
_s15: .db ", ", 0
_s16: .db ".dw: ", 0
_s17: .db "Done.\n", 0
_s18: .db "Integer constant expected in .org directive.", 0
_s19: .db "Parsing labels and directives...\n", 0
_s20: .db ".", 0
_s21: .db "\nDone.\n", 0
_s22: .db "Org: %s\n", 0
_s23: .db "\nLabels list:\n", 0
_s24: .db ": ", 0
_s25: .db " .", 0
_s26: .db " ", 0
_s27: .db "Maximum number of operands per instruction is 2.", 0
_s28: .db "8bit operand expected but 16bit label given.", 0
_s29: .db "%x(%d): %s\n", 0
_s30: .db "Undeclared label: ", 0
_s31: .db "Parsing TEXT section...\n", 0
_s32: .db "TEXT section not found.", 0
_s33: .db "TEXT section end not found.", 0
_s34: .db "Unexpected directive.", 0
_s35: .db "Done.\n\n", 0
_s36: .db "Prog Offset: %x\n", 0
_s37: .db "Prog value : %c\n", 0
_s38: .db "Token      : %s\n", 0
_s39: .db "Tok        : %d\n", 0
_s40: .db "Toktype    : %d\n", 0
_s41: .db "StringConst: %s\n", 0
_s42: .db "PC         : %x\n", 0
_s43: .db "\nAssembly complete.\n", 0
_s44: .db "Program size: %d\n", 0
_s45: .db "Listing: \n", 0
_s46: .db "a", 0
_s47: .db "al", 0
_s48: .db "ah", 0
_s49: .db "b", 0
_s50: .db "bl", 0
_s51: .db "bh", 0
_s52: .db "c", 0
_s53: .db "cl", 0
_s54: .db "ch", 0
_s55: .db "d", 0
_s56: .db "dl", 0
_s57: .db "dh", 0
_s58: .db "g", 0
_s59: .db "gl", 0
_s60: .db "gh", 0
_s61: .db "pc", 0
_s62: .db "sp", 0
_s63: .db "bp", 0
_s64: .db "si", 0
_s65: .db "di", 0
_s66: .db "word", 0
_s67: .db "byte", 0
_s68: .db "cmpsb", 0
_s69: .db "movsb", 0
_s70: .db "stosb", 0
_s71: .db "define", 0
_s72: .db "Label does not exist: ", 0
_s73: .db "Closing single quotes expected.", 0
_s74: .db "Double quotes expected", 0
_s75: .db "TOKEN ERROR. Prog: ", 0
_s76: .db ", ProgVal: ", 0
_s77: .db "\n Text after prog: \n", 0
_s78: .db "\nError: ", 0
_s79: .db "Cannot push prog. Stack overflow.", 0
_s80: .db "Cannot pop prog. Stack overflow.", 0
_s81: .db "Unexpected format in printf.", 0
_s82: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
