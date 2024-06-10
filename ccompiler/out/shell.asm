; --- FILENAME: ../solarium/usr/bin/shell
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:

  mov bp, $FFE0 ;

  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)

; $p 
; $t 
; $temp_prog 
; $varname 
; $is_assignment 
; $variable_str 
; $variable_int 
; $var_index 
; $i 
  sub sp, 142

;; new_str_var("path", "", 64); 
  mov b, $40
  swp b
  push b
  mov b, __s1 ; ""
  swp b
  push b
  mov b, __s0 ; "path"
  swp b
  push b
  call new_str_var
  add sp, 6
;; new_str_var("home", "", 64); 
  mov b, $40
  swp b
  push b
  mov b, __s2 ; ""
  swp b
  push b
  mov b, __s1 ; "home"
  swp b
  push b
  call new_str_var
  add sp, 6
;; read_config("/etc/shell.cfg", "path", variables[0].as_string); 
  mov d, _variables_data ; $variables
  push a
  push d
  mov b, $0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  mov b, __s0 ; "path"
  swp b
  push b
  mov b, __s2 ; "/etc/shell.cfg"
  swp b
  push b
  call read_config
  add sp, 6
;; read_config("/etc/shell.cfg", "home", variables[1].as_string); 
  mov d, _variables_data ; $variables
  push a
  push d
  mov b, $1
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  mov b, __s1 ; "home"
  swp b
  push b
  mov b, __s2 ; "/etc/shell.cfg"
  swp b
  push b
  call read_config
  add sp, 6
;; for(;;){ 
_for1_init:
_for1_cond:
_for1_block:
;; printf("root@Sol-1:");  
  mov b, __s3 ; "root@Sol-1:"
  swp b
  push b
  call printf
  add sp, 2
;; print_cwd();  
  call print_cwd
;; printf(" # "); 
  mov b, __s4 ; " # "
  swp b
  push b
  call printf
  add sp, 2
;; gets(command); 
  mov d, _command_data ; $command
  mov b, d
  swp b
  push b
  call gets
  add sp, 2
;; print("\n\r"); 
  mov b, __s5 ; "\n\r"
  swp b
  push b
  call print
  add sp, 2
;; if(command[0]) strcpy(last_cmd, command); 
_if2_cond:
  mov d, _command_data ; $command
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if2_exit
_if2_true:
;; strcpy(last_cmd, command); 
  mov d, _command_data ; $command
  mov b, d
  swp b
  push b
  mov d, _last_cmd_data ; $last_cmd
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
  jmp _if2_exit
_if2_exit:
;; prog = command; 
  mov d, _prog ; $prog
  push d
  mov d, _command_data ; $command
  mov b, d
  pop d
  mov [d], b
;; for(;;){ 
_for3_init:
_for3_cond:
_for3_block:
;; temp_prog = prog; 
  lea d, [bp + -5] ; $temp_prog
  push d
  mov d, _prog ; $prog
  mov b, [d]
  pop d
  mov [d], b
;; get(); 
  call get
;; if(tok == SEMICOLON) get(); 
_if4_cond:
  mov d, _tok ; $tok
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 35; SEMICOLON
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if4_exit
_if4_true:
;; get(); 
  call get
  jmp _if4_exit
_if4_exit:
;; if(toktype == END) break; // check for empty input 
_if5_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if5_exit
_if5_true:
;; break; // check for empty input 
  jmp _for3_exit ; for break
  jmp _if5_exit
_if5_exit:
;; is_assignment = 0; 
  lea d, [bp + -7] ; $is_assignment
  push d
  mov b, $0
  pop d
  mov [d], bl
;; if(toktype == IDENTIFIER){ 
_if6_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_true:
;; strcpy(varname, token); 
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  lea d, [bp + -6] ; $varname
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call strcpy
  add sp, 4
;; get(); 
  call get
;; is_assignment = tok == ASSIGNMENT; 
  lea d, [bp + -7] ; $is_assignment
  push d
  mov d, _tok ; $tok
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 17; ASSIGNMENT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  pop d
  mov [d], bl
  jmp _if6_exit
_if6_exit:
;; if(is_assignment){ 
_if7_cond:
  lea d, [bp + -7] ; $is_assignment
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if7_else
_if7_true:
;; get(); 
  call get
;; if(toktype == INTEGER_CONST) set_int_var(varname, atoi(token)); 
_if8_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 4; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if8_else
_if8_true:
;; set_int_var(varname, atoi(token)); 
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  call atoi
  add sp, 2
  swp b
  push b
  lea d, [bp + -6] ; $varname
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call set_int_var
  add sp, 4
  jmp _if8_exit
_if8_else:
;; if(toktype == STRING_CONST) new_str_var(varname, string_const, strlen(string_const)); 
_if9_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if9_else
_if9_true:
;; new_str_var(varname, string_const, strlen(string_const)); 
  mov d, _string_const_data ; $string_const
  mov b, d
  swp b
  push b
  call strlen
  add sp, 2
  swp b
  push b
  mov d, _string_const_data ; $string_const
  mov b, d
  swp b
  push b
  lea d, [bp + -6] ; $varname
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call new_str_var
  add sp, 6
  jmp _if9_exit
_if9_else:
;; if(toktype == IDENTIFIER) new_str_var(varname, token, strlen(token)); 
_if10_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if10_exit
_if10_true:
;; new_str_var(varname, token, strlen(token)); 
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  call strlen
  add sp, 2
  swp b
  push b
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  lea d, [bp + -6] ; $varname
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call new_str_var
  add sp, 6
  jmp _if10_exit
_if10_exit:
_if9_exit:
_if8_exit:
  jmp _if7_exit
_if7_else:
;; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -5] ; $temp_prog
  mov b, [d]
  pop d
  mov [d], b
;; get(); 
  call get
;; if(!strcmp(token, "cd")) command_cd(); 
_if11_cond:
  mov b, __s6 ; "cd"
  swp b
  push b
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if11_else
_if11_true:
;; command_cd(); 
  call command_cd
  jmp _if11_exit
_if11_else:
;; if(!strcmp(token, "shell")) command_shell(); 
_if12_cond:
  mov b, __s7 ; "shell"
  swp b
  push b
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if12_else
_if12_true:
;; command_shell(); 
  call command_shell
  jmp _if12_exit
_if12_else:
;; back(); 
  call back
;; get_path(); 
  call get_path
;; strcpy(path, token); // save file path 
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  mov d, _path_data ; $path
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
;; for(i = 0; i < 256; i++) argument[i] = 0; 
_for13_init:
  lea d, [bp + -141] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for13_cond:
  lea d, [bp + -141] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $100
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for13_exit
_for13_block:
;; argument[i] = 0; 
  mov d, _argument_data ; $argument
  push a
  push d
  lea d, [bp + -141] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
_for13_update:
  lea d, [bp + -141] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -141] ; $i
  mov [d], b
  mov b, g
  jmp _for13_cond
_for13_exit:
;; get(); 
  call get
;; if(tok != SEMICOLON && toktype != END){ 
_if14_cond:
  mov d, _tok ; $tok
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 35; SEMICOLON
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if14_exit
_if14_true:
;; back(); 
  call back
;; p = argument; 
  lea d, [bp + -1] ; $p
  push d
  mov d, _argument_data ; $argument
  mov b, d
  pop d
  mov [d], b
;; do{ 
_do15_block:
;; if(*prog == '$'){ 
_if16_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if16_else
_if16_true:
;; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; get(); // get variable name 
  call get
;; var_index = get_var_index(token); 
  lea d, [bp + -139] ; $var_index
  push d
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  call get_var_index
  add sp, 2
  pop d
  mov [d], b
;; if(var_index != -1){ 
_if17_cond:
  lea d, [bp + -139] ; $var_index
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  neg b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if17_exit
_if17_true:
;; if(get_var_type(token) == SHELL_VAR_TYP_INT) strcat(argument, "123"); 
_if18_cond:
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  call get_var_type
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, 1; SHELL_VAR_TYP_INT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if18_else
_if18_true:
;; strcat(argument, "123"); 
  mov b, __s8 ; "123"
  swp b
  push b
  mov d, _argument_data ; $argument
  mov b, d
  swp b
  push b
  call strcat
  add sp, 4
  jmp _if18_exit
_if18_else:
;; if(get_var_type(token) == SHELL_VAR_TYP_STR) strcat(argument, get_shell_var_strval(var_index)); 
_if19_cond:
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  call get_var_type
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, 0; SHELL_VAR_TYP_STR
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if19_exit
_if19_true:
;; strcat(argument, get_shell_var_strval(var_index)); 
  lea d, [bp + -139] ; $var_index
  mov b, [d]
  swp b
  push b
  call get_shell_var_strval
  add sp, 2
  swp b
  push b
  mov d, _argument_data ; $argument
  mov b, d
  swp b
  push b
  call strcat
  add sp, 4
  jmp _if19_exit
_if19_exit:
_if18_exit:
;; while(*p) p++; 
_while20_cond:
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while20_exit
_while20_block:
;; p++; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  mov b, g
  jmp _while20_cond
_while20_exit:
  jmp _if17_exit
_if17_exit:
  jmp _if16_exit
_if16_else:
;; *p++ = *prog++; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_if16_exit:
;; } while(*prog != '\0' && *prog != ';'); 
_do15_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 1
  je _do15_block
_do15_exit:
;; *p = '\0'; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  jmp _if14_exit
_if14_exit:
;; if(*path == '/' || *path == '.') spawn_new_proc(path, argument); 
_if21_cond:
  mov d, _path_data ; $path
  mov b, d
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _path_data ; $path
  mov b, d
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if21_else
_if21_true:
;; spawn_new_proc(path, argument); 
  mov d, _argument_data ; $argument
  mov b, d
  swp b
  push b
  mov d, _path_data ; $path
  mov b, d
  swp b
  push b
  call spawn_new_proc
  add sp, 4
  jmp _if21_exit
_if21_else:
;; temp_prog = prog; 
  lea d, [bp + -5] ; $temp_prog
  push d
  mov d, _prog ; $prog
  mov b, [d]
  pop d
  mov [d], b
;; prog = variables[0].as_string; 
  mov d, _prog ; $prog
  push d
  mov d, _variables_data ; $variables
  push a
  push d
  mov b, $0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  pop d
  mov [d], b
;; for(;;){ 
_for22_init:
_for22_cond:
_for22_block:
;; get(); 
  call get
;; if(toktype == END){ 
_if23_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if23_else
_if23_true:
;; break; 
  jmp _for22_exit ; for break
  jmp _if23_exit
_if23_else:
;; back(); 
  call back
_if23_exit:
;; get_path(); 
  call get_path
;; strcpy(temp, token); 
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  mov d, _temp_data ; $temp
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
;; strcat(temp, "/"); 
  mov b, __s9 ; "/"
  swp b
  push b
  mov d, _temp_data ; $temp
  mov b, d
  swp b
  push b
  call strcat
  add sp, 4
;; strcat(temp, path); // form full filepath with ENV_PATH + given filename 
  mov d, _path_data ; $path
  mov b, d
  swp b
  push b
  mov d, _temp_data ; $temp
  mov b, d
  swp b
  push b
  call strcat
  add sp, 4
;; if(file_exists(temp) != 0){ 
_if24_cond:
  mov d, _temp_data ; $temp
  mov b, d
  swp b
  push b
  call file_exists
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_true:
;; spawn_new_proc(temp, argument); 
  mov d, _argument_data ; $argument
  mov b, d
  swp b
  push b
  mov d, _temp_data ; $temp
  mov b, d
  swp b
  push b
  call spawn_new_proc
  add sp, 4
;; break; 
  jmp _for22_exit ; for break
  jmp _if24_exit
_if24_exit:
;; get(); // get separator 
  call get
_for22_update:
  jmp _for22_cond
_for22_exit:
;; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -5] ; $temp_prog
  mov b, [d]
  pop d
  mov [d], b
_if21_exit:
_if12_exit:
_if11_exit:
_if7_exit:
_for3_update:
  jmp _for3_cond
_for3_exit:
_for1_update:
  jmp _for1_cond
_for1_exit:
  syscall sys_terminate_proc

include_ctype_lib:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/ctype.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

is_space:
  enter 0 ; (push bp; mov bp, sp)
;; return c == ' ' || c == '\t' || c == '\n' || c == '\r'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $9
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  leave
  ret

is_digit:
  enter 0 ; (push bp; mov bp, sp)
;; return c >= '0' && c <= '9'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  leave
  ret

is_alpha:
  enter 0 ; (push bp; mov bp, sp)
;; return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_'); 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  leave
  ret

toupper:
  enter 0 ; (push bp; mov bp, sp)
;; if (ch >= 'a' && ch <= 'z') { 
_if25_cond:
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if25_else
_if25_true:
;; return ch - 'a' + 'A'; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, $41
  add a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if25_exit
_if25_else:
;; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  leave
  ret
_if25_exit:
  leave
  ret

is_delimiter:
  enter 0 ; (push bp; mov bp, sp)
;; if( 
_if26_cond:
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $23
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $29
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $21
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if26_else
_if26_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if26_exit
_if26_else:
;; return 0; 
  mov b, $0
  leave
  ret
_if26_exit:
  leave
  ret

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; $psrc 
; $pdest 
  sub sp, 4

;; psrc = src; 
  lea d, [bp + -1] ; $psrc
  push d
  lea d, [bp + 7] ; $src
  mov b, [d]
  pop d
  mov [d], b
;; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  pop d
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while27_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while27_exit
_while27_block:
;; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  mov b, g
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while27_cond
_while27_exit:
;; *pdest = '\0'; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

strcmp:
  enter 0 ; (push bp; mov bp, sp)
;; while (*s1 && (*s1 == *s2)) { 
_while28_cond:
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while28_exit
_while28_block:
;; s1++; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $s1
  mov [d], b
  mov b, g
;; s2++; 
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 7] ; $s2
  mov [d], b
  mov b, g
  jmp _while28_cond
_while28_exit:
;; return *s1 - *s2; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

strcat:
  enter 0 ; (push bp; mov bp, sp)
; $dest_len 
; $i 
  sub sp, 4

;; dest_len = strlen(dest); 
  lea d, [bp + -1] ; $dest_len
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; src[i] != 0; i=i+1) { 
_for29_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for29_cond:
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _for29_exit
_for29_block:
;; dest[dest_len + i] = src[i]; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
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
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for29_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _for29_cond
_for29_exit:
;; dest[dest_len + i] = 0; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
;; return dest; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; $length 
  sub sp, 2

;; length = 0; 
  lea d, [bp + -1] ; $length
  push d
  mov b, $0
  pop d
  mov [d], b
;; while (str[length] != 0) { 
_while30_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $length
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while30_exit
_while30_block:
;; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while30_cond
_while30_exit:
;; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  leave
  ret

printf:
  enter 0 ; (push bp; mov bp, sp)
; $p 
; $fp 
; $i 
  sub sp, 6

;; fp = format; 
  lea d, [bp + -3] ; $fp
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  pop d
  mov [d], b
;; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; for(;;){ 
_for31_init:
_for31_cond:
_for31_block:
;; if(!*fp) break; 
_if32_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if32_else
_if32_true:
;; break; 
  jmp _for31_exit ; for break
  jmp _if32_exit
_if32_else:
;; if(*fp == '%'){ 
_if33_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if33_else
_if33_true:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
;; switch(*fp){ 
_switch34_expr:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch34_comparisons:
  cmp bl, $64
  je _switch34_case0
  cmp bl, $69
  je _switch34_case1
  cmp bl, $75
  je _switch34_case2
  cmp bl, $78
  je _switch34_case3
  cmp bl, $63
  je _switch34_case4
  cmp bl, $73
  je _switch34_case5
  jmp _switch34_default
  jmp _switch34_exit
_switch34_case0:
_switch34_case1:
;; prints(*(int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_case2:
;; printu(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_case3:
;; printx16(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printx16
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_case4:
;; putchar(*(char*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_case5:
;; print(*(char**)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s10 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch34_exit:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
  jmp _if33_exit
_if33_else:
;; putchar(*fp); 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
_if33_exit:
_if32_exit:
_for31_update:
  jmp _for31_cond
_for31_exit:
  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov b, [d]
  call print_u16x
; --- END INLINE ASM BLOCK

  leave
  ret

printx8:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov bl, [d]
  call print_u8x
; --- END INLINE ASM BLOCK

  leave
  ret

hex_to_int:
  enter 0 ; (push bp; mov bp, sp)
; $value 
  mov a, $0
  mov [bp + -1], a
; $i 
; $hex_char 
; $len 
  sub sp, 7

;; len = strlen(hex_string); 
  lea d, [bp + -6] ; $len
  push d
  lea d, [bp + 5] ; $hex_string
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; i < len; i++) { 
_for35_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for35_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for35_exit
_for35_block:
;; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
  lea d, [bp + 5] ; $hex_string
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (hex_char >= 'a' && hex_char <= 'f')  
_if36_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $66
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if36_else
_if36_true:
;; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if36_exit
_if36_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if37_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $46
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if37_else
_if37_true:
;; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if37_exit
_if37_else:
;; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
_if37_exit:
_if36_exit:
_for35_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for35_cond
_for35_exit:
;; return value; 
  lea d, [bp + -1] ; $value
  mov b, [d]
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
; $result 
  mov a, $0
  mov [bp + -1], a
; $sign 
  mov a, $1
  mov [bp + -3], a
  sub sp, 4

;; while (*str == ' ') str++; 
_while38_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while38_exit
_while38_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while38_cond
_while38_exit:
;; if (*str == '-' || *str == '+') { 
_if39_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if39_exit
_if39_true:
;; if (*str == '-') sign = -1; 
_if40_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if40_exit
_if40_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
  jmp _if40_exit
_if40_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if39_exit
_if39_exit:
;; while (*str >= '0' && *str <= '9') { 
_while41_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while41_exit
_while41_block:
;; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while41_cond
_while41_exit:
;; return sign * result; 
  lea d, [bp + -3] ; $sign
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -1] ; $result
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  leave
  ret

gets:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _gets
; --- END INLINE ASM BLOCK

;; return strlen(s); 
  lea d, [bp + 5] ; $s
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  leave
  ret

prints:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  mov a, $0
  mov [bp + -6], a
  sub sp, 7

;; if (num < 0) { 
_if42_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _if42_else
_if42_true:
;; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
;; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  neg b
  pop d
  mov [d], b
  jmp _if42_exit
_if42_else:
;; if (num == 0) { 
_if43_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if43_exit
_if43_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if43_exit
_if43_exit:
_if42_exit:
;; while (num > 0) { 
_while44_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while44_exit
_while44_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while44_cond
_while44_exit:
;; while (i > 0) { 
_while45_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while45_exit
_while45_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while45_cond
_while45_exit:
  leave
  ret

printu:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  sub sp, 7

;; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if46_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if46_exit
_if46_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if46_exit
_if46_exit:
;; while (num > 0) { 
_while47_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while47_exit
_while47_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while47_cond
_while47_exit:
;; while (i > 0) { 
_while48_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while48_exit
_while48_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while48_cond
_while48_exit:
  leave
  ret

rand:
  enter 0 ; (push bp; mov bp, sp)
; $sec 
  sub sp, 1


; --- BEGIN INLINE ASM BLOCK
  mov al, 0
  syscall sys_rtc					
  mov al, ah
  lea d, [bp + 0] ; $sec
  mov al, [d]
; --- END INLINE ASM BLOCK

;; return sec; 
  lea d, [bp + 0] ; $sec
  mov bl, [d]
  mov bh, 0
  leave
  ret

date:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov al, 0 
  syscall sys_datetime
; --- END INLINE ASM BLOCK

  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM BLOCK

  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
; $c 
  sub sp, 1


; --- BEGIN INLINE ASM BLOCK
  call getch
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM BLOCK

;; return c; 
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  leave
  ret

scann:
  enter 0 ; (push bp; mov bp, sp)
; $m 
  sub sp, 2


; --- BEGIN INLINE ASM BLOCK
  call scan_u16d
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM BLOCK

;; return m; 
  lea d, [bp + -1] ; $m
  mov b, [d]
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _puts
  mov a, $0A00
  syscall sys_io
; --- END INLINE ASM BLOCK

  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov d, [d]
  call _puts
; --- END INLINE ASM BLOCK

  leave
  ret

loadfile:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 7] ; $destination
  mov a, [d]
  mov di, a
  lea d, [bp + 5] ; $filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

create_file:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

delete_file:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $filename
  mov al, 10
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

fopen:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

fclose:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

alloc:
  enter 0 ; (push bp; mov bp, sp)
;; heap_top = heap_top + bytes; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

free:
  enter 0 ; (push bp; mov bp, sp)
;; return heap_top = heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  syscall sys_terminate_proc
; --- END INLINE ASM BLOCK

  leave
  ret

load_hex:
  enter 0 ; (push bp; mov bp, sp)
; $temp 
  sub sp, 2

;; temp = alloc(32768); 
  lea d, [bp + -1] ; $temp
  push d
  mov b, $8000
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b

; --- BEGIN INLINE ASM BLOCK
  
  
  
  
  
_load_hex:
  push a
  push b
  push d
  push si
  push di
  sub sp, $8000      
  mov c, 0
  mov a, sp
  inc a
  mov d, a          
  call _gets        
  mov si, a
__load_hex_loop:
  lodsb             
  cmp al, 0         
  jz __load_hex_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        
  stosb             
  inc c
  jmp __load_hex_loop
__load_hex_ret:
  add sp, $8000
  pop di
  pop si
  pop d
  pop b
  pop a
; --- END INLINE ASM BLOCK

  leave
  ret

getparam:
  enter 0 ; (push bp; mov bp, sp)
; $data 
  sub sp, 1


; --- BEGIN INLINE ASM BLOCK
  mov al, 4
  lea d, [bp + 5] ; $address
  mov d, [d]
  syscall sys_system
  lea d, [bp + 0] ; $data
  mov [d], bl
; --- END INLINE ASM BLOCK

;; return data; 
  lea d, [bp + 0] ; $data
  mov bl, [d]
  mov bh, 0
  leave
  ret

clear:
  enter 0 ; (push bp; mov bp, sp)
;; print("\033[2J\033[H"); 
  mov b, __s11 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

printun:
  enter 0 ; (push bp; mov bp, sp)
;; print(prompt); 
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; printu(n); 
  lea d, [bp + 7] ; $n
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; print("\n"); 
  mov b, __s12 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

printsn:
  enter 0 ; (push bp; mov bp, sp)
;; print(prompt); 
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; prints(n); 
  lea d, [bp + 7] ; $n
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; print("\n"); 
  mov b, __s12 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

back:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2

;; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  pop d
  mov [d], b
;; while(*t++) prog--; 
_while49_cond:
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while49_exit
_while49_block:
;; prog--; 
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  dec b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while49_cond
_while49_exit:
;; tok = TOK_UNDEF; 
  mov d, _tok ; $tok
  push d
  mov b, 0; TOK_UNDEF
  pop d
  mov [d], b
;; toktype = TYPE_UNDEF; 
  mov d, _toktype ; $toktype
  push d
  mov b, 0; TYPE_UNDEF
  pop d
  mov [d], b
;; token[0] = '\0'; 
  mov d, _token_data ; $token
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

get_path:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2

;; *token = '\0'; 
  mov d, _token_data ; $token
  mov b, d
  push b
  mov b, $0
  pop d
  mov [d], bl
;; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  pop d
  mov [d], b
;; while(is_space(*prog)) prog++; 
_while50_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while50_exit
_while50_block:
;; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while50_cond
_while50_exit:
;; if(*prog == '\0'){ 
_if51_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if51_exit
_if51_true:
;; return; 
  leave
  ret
  jmp _if51_exit
_if51_exit:
;; while( 
_while52_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _while52_exit
_while52_block:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while52_cond
_while52_exit:
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

get:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2

;; *token = '\0'; 
  mov d, _token_data ; $token
  mov b, d
  push b
  mov b, $0
  pop d
  mov [d], bl
;; tok = 0; 
  mov d, _tok ; $tok
  push d
  mov b, $0
  pop d
  mov [d], b
;; toktype = 0; 
  mov d, _toktype ; $toktype
  push d
  mov b, $0
  pop d
  mov [d], b
;; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  pop d
  mov [d], b
;; while(is_space(*prog)) prog++; 
_while53_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while53_exit
_while53_block:
;; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while53_cond
_while53_exit:
;; if(*prog == '\0'){ 
_if54_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if54_exit
_if54_true:
;; toktype = END; 
  mov d, _toktype ; $toktype
  push d
  mov b, 6; END
  pop d
  mov [d], b
;; return; 
  leave
  ret
  jmp _if54_exit
_if54_exit:
;; if(is_digit(*prog)){ 
_if55_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  je _if55_else
_if55_true:
;; while(is_digit(*prog)){ 
_while56_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  je _while56_exit
_while56_block:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while56_cond
_while56_exit:
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; toktype = INTEGER_CONST; 
  mov d, _toktype ; $toktype
  push d
  mov b, 4; INTEGER_CONST
  pop d
  mov [d], b
;; return; // return to avoid *t = '\0' line at the end of function 
  leave
  ret
  jmp _if55_exit
_if55_else:
;; if(is_alpha(*prog)){ 
_if57_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  cmp b, 0
  je _if57_else
_if57_true:
;; while(is_alpha(*prog) || is_digit(*prog)){ 
_while58_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  sor a, b ; ||
  pop a
  cmp b, 0
  je _while58_exit
_while58_block:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while58_cond
_while58_exit:
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; toktype = IDENTIFIER; 
  mov d, _toktype ; $toktype
  push d
  mov b, 5; IDENTIFIER
  pop d
  mov [d], b
  jmp _if57_exit
_if57_else:
;; if(*prog == '\"'){ 
_if59_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if59_else
_if59_true:
;; *t++ = '\"'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, $22
  pop d
  mov [d], bl
;; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; while(*prog != '\"' && *prog){ 
_while60_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while60_exit
_while60_block:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while60_cond
_while60_exit:
;; if(*prog != '\"') error("Double quotes expected"); 
_if61_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if61_exit
_if61_true:
;; error("Double quotes expected"); 
  mov b, __s13 ; "Double quotes expected"
  swp b
  push b
  call error
  add sp, 2
  jmp _if61_exit
_if61_exit:
;; *t++ = '\"'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, $22
  pop d
  mov [d], bl
;; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; toktype = STRING_CONST; 
  mov d, _toktype ; $toktype
  push d
  mov b, 3; STRING_CONST
  pop d
  mov [d], b
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; convert_constant(); // converts this string token qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
  call convert_constant
  jmp _if59_exit
_if59_else:
;; if(*prog == '#'){ 
_if62_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $23
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if62_else
_if62_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = HASH; 
  mov d, _tok ; $tok
  push d
  mov b, 21; HASH
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if62_exit
_if62_else:
;; if(*prog == '{'){ 
_if63_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if63_else
_if63_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_BRACE; 
  mov d, _tok ; $tok
  push d
  mov b, 30; OPENING_BRACE
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if63_exit
_if63_else:
;; if(*prog == '}'){ 
_if64_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if64_else
_if64_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_BRACE; 
  mov d, _tok ; $tok
  push d
  mov b, 31; CLOSING_BRACE
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if64_exit
_if64_else:
;; if(*prog == '['){ 
_if65_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if65_else
_if65_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_BRACKET; 
  mov d, _tok ; $tok
  push d
  mov b, 32; OPENING_BRACKET
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if65_exit
_if65_else:
;; if(*prog == ']'){ 
_if66_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if66_else
_if66_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_BRACKET; 
  mov d, _tok ; $tok
  push d
  mov b, 33; CLOSING_BRACKET
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if66_exit
_if66_else:
;; if(*prog == '='){ 
_if67_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if67_else
_if67_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if68_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if68_else
_if68_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = EQUAL; 
  mov d, _tok ; $tok
  push d
  mov b, 8; EQUAL
  pop d
  mov [d], b
  jmp _if68_exit
_if68_else:
;; tok = ASSIGNMENT; 
  mov d, _tok ; $tok
  push d
  mov b, 17; ASSIGNMENT
  pop d
  mov [d], b
_if68_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if67_exit
_if67_else:
;; if(*prog == '&'){ 
_if69_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if69_else
_if69_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '&'){ 
_if70_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if70_else
_if70_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LOGICAL_AND; 
  mov d, _tok ; $tok
  push d
  mov b, 14; LOGICAL_AND
  pop d
  mov [d], b
  jmp _if70_exit
_if70_else:
;; tok = AMPERSAND; 
  mov d, _tok ; $tok
  push d
  mov b, 22; AMPERSAND
  pop d
  mov [d], b
_if70_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if69_exit
_if69_else:
;; if(*prog == '|'){ 
_if71_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if71_else
_if71_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '|'){ 
_if72_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if72_else
_if72_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LOGICAL_OR; 
  mov d, _tok ; $tok
  push d
  mov b, 15; LOGICAL_OR
  pop d
  mov [d], b
  jmp _if72_exit
_if72_else:
;; tok = BITWISE_OR; 
  mov d, _tok ; $tok
  push d
  mov b, 24; BITWISE_OR
  pop d
  mov [d], b
_if72_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if71_exit
_if71_else:
;; if(*prog == '~'){ 
_if73_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if73_else
_if73_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_NOT; 
  mov d, _tok ; $tok
  push d
  mov b, 25; BITWISE_NOT
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if73_exit
_if73_else:
;; if(*prog == '<'){ 
_if74_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if74_else
_if74_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if75_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if75_else
_if75_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LESS_THAN_OR_EQUAL; 
  mov d, _tok ; $tok
  push d
  mov b, 11; LESS_THAN_OR_EQUAL
  pop d
  mov [d], b
  jmp _if75_exit
_if75_else:
;; if (*prog == '<'){ 
_if76_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if76_else
_if76_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_SHL; 
  mov d, _tok ; $tok
  push d
  mov b, 26; BITWISE_SHL
  pop d
  mov [d], b
  jmp _if76_exit
_if76_else:
;; tok = LESS_THAN; 
  mov d, _tok ; $tok
  push d
  mov b, 10; LESS_THAN
  pop d
  mov [d], b
_if76_exit:
_if75_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if74_exit
_if74_else:
;; if(*prog == '>'){ 
_if77_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if77_else
_if77_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if78_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if78_else
_if78_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = GREATER_THAN_OR_EQUAL; 
  mov d, _tok ; $tok
  push d
  mov b, 13; GREATER_THAN_OR_EQUAL
  pop d
  mov [d], b
  jmp _if78_exit
_if78_else:
;; if (*prog == '>'){ 
_if79_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if79_else
_if79_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_SHR; 
  mov d, _tok ; $tok
  push d
  mov b, 27; BITWISE_SHR
  pop d
  mov [d], b
  jmp _if79_exit
_if79_else:
;; tok = GREATER_THAN; 
  mov d, _tok ; $tok
  push d
  mov b, 12; GREATER_THAN
  pop d
  mov [d], b
_if79_exit:
_if78_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if77_exit
_if77_else:
;; if(*prog == '!'){ 
_if80_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $21
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if80_else
_if80_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '='){ 
_if81_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if81_else
_if81_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = NOT_EQUAL; 
  mov d, _tok ; $tok
  push d
  mov b, 9; NOT_EQUAL
  pop d
  mov [d], b
  jmp _if81_exit
_if81_else:
;; tok = LOGICAL_NOT; 
  mov d, _tok ; $tok
  push d
  mov b, 16; LOGICAL_NOT
  pop d
  mov [d], b
_if81_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if80_exit
_if80_else:
;; if(*prog == '+'){ 
_if82_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if82_else
_if82_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '+'){ 
_if83_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if83_else
_if83_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = INCREMENT; 
  mov d, _tok ; $tok
  push d
  mov b, 5; INCREMENT
  pop d
  mov [d], b
  jmp _if83_exit
_if83_else:
;; tok = PLUS; 
  mov d, _tok ; $tok
  push d
  mov b, 1; PLUS
  pop d
  mov [d], b
_if83_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if82_exit
_if82_else:
;; if(*prog == '-'){ 
_if84_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if84_else
_if84_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '-'){ 
_if85_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if85_else
_if85_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DECREMENT; 
  mov d, _tok ; $tok
  push d
  mov b, 6; DECREMENT
  pop d
  mov [d], b
  jmp _if85_exit
_if85_else:
;; tok = MINUS; 
  mov d, _tok ; $tok
  push d
  mov b, 2; MINUS
  pop d
  mov [d], b
_if85_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if84_exit
_if84_else:
;; if(*prog == '$'){ 
_if86_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if86_else
_if86_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DOLLAR; 
  mov d, _tok ; $tok
  push d
  mov b, 18; DOLLAR
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if86_exit
_if86_else:
;; if(*prog == '^'){ 
_if87_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if87_else
_if87_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_XOR; 
  mov d, _tok ; $tok
  push d
  mov b, 23; BITWISE_XOR
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if87_exit
_if87_else:
;; if(*prog == '@'){ 
_if88_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if88_else
_if88_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = AT; 
  mov d, _tok ; $tok
  push d
  mov b, 20; AT
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if88_exit
_if88_else:
;; if(*prog == '*'){ 
_if89_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if89_else
_if89_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = STAR; 
  mov d, _tok ; $tok
  push d
  mov b, 3; STAR
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if89_exit
_if89_else:
;; if(*prog == '/'){ 
_if90_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if90_else
_if90_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = FSLASH; 
  mov d, _tok ; $tok
  push d
  mov b, 4; FSLASH
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if90_exit
_if90_else:
;; if(*prog == '%'){ 
_if91_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if91_else
_if91_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = MOD; 
  mov d, _tok ; $tok
  push d
  mov b, 7; MOD
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if91_exit
_if91_else:
;; if(*prog == '('){ 
_if92_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if92_else
_if92_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_PAREN; 
  mov d, _tok ; $tok
  push d
  mov b, 28; OPENING_PAREN
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if92_exit
_if92_else:
;; if(*prog == ')'){ 
_if93_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $29
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if93_else
_if93_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_PAREN; 
  mov d, _tok ; $tok
  push d
  mov b, 29; CLOSING_PAREN
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if93_exit
_if93_else:
;; if(*prog == ';'){ 
_if94_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if94_else
_if94_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = SEMICOLON; 
  mov d, _tok ; $tok
  push d
  mov b, 35; SEMICOLON
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if94_exit
_if94_else:
;; if(*prog == ':'){ 
_if95_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if95_else
_if95_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = COLON; 
  mov d, _tok ; $tok
  push d
  mov b, 34; COLON
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if95_exit
_if95_else:
;; if(*prog == ','){ 
_if96_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if96_else
_if96_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = COMMA; 
  mov d, _tok ; $tok
  push d
  mov b, 36; COMMA
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if96_exit
_if96_else:
;; if(*prog == '.'){ 
_if97_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if97_exit
_if97_true:
;; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DOT; 
  mov d, _tok ; $tok
  push d
  mov b, 37; DOT
  pop d
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov b, 1; DELIMITER
  pop d
  mov [d], b
  jmp _if97_exit
_if97_exit:
_if96_exit:
_if95_exit:
_if94_exit:
_if93_exit:
_if92_exit:
_if91_exit:
_if90_exit:
_if89_exit:
_if88_exit:
_if87_exit:
_if86_exit:
_if84_exit:
_if82_exit:
_if80_exit:
_if77_exit:
_if74_exit:
_if73_exit:
_if71_exit:
_if69_exit:
_if67_exit:
_if66_exit:
_if65_exit:
_if64_exit:
_if63_exit:
_if62_exit:
_if59_exit:
_if57_exit:
_if55_exit:
;; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

convert_constant:
  enter 0 ; (push bp; mov bp, sp)
; $s 
; $t 
  sub sp, 4

;; t = token; 
  lea d, [bp + -3] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  pop d
  mov [d], b
;; s = string_const; 
  lea d, [bp + -1] ; $s
  push d
  mov d, _string_const_data ; $string_const
  mov b, d
  pop d
  mov [d], b
;; if(toktype == CHAR_CONST){ 
_if98_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 2; CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if98_else
_if98_true:
;; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; if(*t == '\\'){ 
_if99_cond:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if99_else
_if99_true:
;; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; switch(*t){ 
_switch100_expr:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch100_comparisons:
  cmp bl, $30
  je _switch100_case0
  cmp bl, $61
  je _switch100_case1
  cmp bl, $62
  je _switch100_case2
  cmp bl, $66
  je _switch100_case3
  cmp bl, $6e
  je _switch100_case4
  cmp bl, $72
  je _switch100_case5
  cmp bl, $74
  je _switch100_case6
  cmp bl, $76
  je _switch100_case7
  cmp bl, $5c
  je _switch100_case8
  cmp bl, $27
  je _switch100_case9
  cmp bl, $22
  je _switch100_case10
  jmp _switch100_exit
_switch100_case0:
;; *s++ = '\0'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $0
  pop d
  mov [d], bl
;; break; 
  jmp _switch100_exit ; case break
_switch100_case1:
;; *s++ = '\a'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $7
  pop d
  mov [d], bl
;; break; 
  jmp _switch100_exit ; case break
_switch100_case2:
;; *s++ = '\b'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $8
  pop d
  mov [d], bl
;; break;   
  jmp _switch100_exit ; case break
_switch100_case3:
;; *s++ = '\f'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $c
  pop d
  mov [d], bl
;; break; 
  jmp _switch100_exit ; case break
_switch100_case4:
;; *s++ = '\n'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $a
  pop d
  mov [d], bl
;; break; 
  jmp _switch100_exit ; case break
_switch100_case5:
;; *s++ = '\r'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $d
  pop d
  mov [d], bl
;; break; 
  jmp _switch100_exit ; case break
_switch100_case6:
;; *s++ = '\t'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $9
  pop d
  mov [d], bl
;; break; 
  jmp _switch100_exit ; case break
_switch100_case7:
;; *s++ = '\v'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $b
  pop d
  mov [d], bl
;; break; 
  jmp _switch100_exit ; case break
_switch100_case8:
;; *s++ = '\\'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $5c
  pop d
  mov [d], bl
;; break; 
  jmp _switch100_exit ; case break
_switch100_case9:
;; *s++ = '\''; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $27
  pop d
  mov [d], bl
;; break; 
  jmp _switch100_exit ; case break
_switch100_case10:
;; *s++ = '\"'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $22
  pop d
  mov [d], bl
_switch100_exit:
  jmp _if99_exit
_if99_else:
;; *s++ = *t; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_if99_exit:
  jmp _if98_exit
_if98_else:
;; if(toktype == STRING_CONST){ 
_if101_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if101_exit
_if101_true:
;; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; while(*t != '\"' && *t){ 
_while102_cond:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while102_exit
_while102_block:
;; *s++ = *t++; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while102_cond
_while102_exit:
  jmp _if101_exit
_if101_exit:
_if98_exit:
;; *s = '\0'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

error:
  enter 0 ; (push bp; mov bp, sp)
;; printf("\nError: "); 
  mov b, __s14 ; "\nError: "
  swp b
  push b
  call printf
  add sp, 2
;; printf(msg); 
  lea d, [bp + 5] ; $msg
  mov b, [d]
  swp b
  push b
  call printf
  add sp, 2
;; printf("\n"); 
  mov b, __s12 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
  leave
  ret

last_cmd_insert:
  enter 0 ; (push bp; mov bp, sp)
;; if(last_cmd[0]){ 
_if103_cond:
  mov d, _last_cmd_data ; $last_cmd
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if103_exit
_if103_true:
;; strcpy(command, last_cmd); 
  mov d, _last_cmd_data ; $last_cmd
  mov b, d
  swp b
  push b
  mov d, _command_data ; $command
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
;; printf(command); 
  mov d, _command_data ; $command
  mov b, d
  swp b
  push b
  call printf
  add sp, 2
  jmp _if103_exit
_if103_exit:
  leave
  ret

new_str_var:
  enter 0 ; (push bp; mov bp, sp)
;; variables[vars_tos].var_type = SHELL_VAR_TYP_STR; 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb
  push d
  mov b, 0; SHELL_VAR_TYP_STR
  pop d
  mov [d], bl
;; variables[vars_tos].as_string = alloc(64); 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  push d
  mov b, $40
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b
;; strcpy(variables[vars_tos].varname, varname); 
  lea d, [bp + 5] ; $varname
  mov b, [d]
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
;; strcpy(variables[vars_tos].as_string, strval); 
  lea d, [bp + 7] ; $strval
  mov b, [d]
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  call strcpy
  add sp, 4
;; vars_tos++; 
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov g, b
  inc b
  mov d, _vars_tos ; $vars_tos
  mov [d], b
  mov b, g
;; return vars_tos - 1; 
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

set_str_var:
  enter 0 ; (push bp; mov bp, sp)
; $var_index 
  sub sp, 2

;; for(var_index = 0; var_index < vars_tos; var_index++){ 
_for104_init:
  lea d, [bp + -1] ; $var_index
  push d
  mov b, $0
  pop d
  mov [d], b
_for104_cond:
  lea d, [bp + -1] ; $var_index
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for104_exit
_for104_block:
;; if(!strcmp(variables[var_index].varname, varname)){ 
_if105_cond:
  lea d, [bp + 5] ; $varname
  mov b, [d]
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if105_exit
_if105_true:
;; strcpy(variables[var_index].as_string, strval); 
  lea d, [bp + 7] ; $strval
  mov b, [d]
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  call strcpy
  add sp, 4
;; return var_index; 
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  leave
  ret
  jmp _if105_exit
_if105_exit:
_for104_update:
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $var_index
  mov [d], b
  mov b, g
  jmp _for104_cond
_for104_exit:
;; printf("Error: Variable does not exist."); 
  mov b, __s15 ; "Error: Variable does not exist."
  swp b
  push b
  call printf
  add sp, 2
  leave
  ret

set_int_var:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2

;; for(i = 0; i < vars_tos; i++){ 
_for106_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for106_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for106_exit
_for106_block:
;; if(!strcmp(variables[i].varname, varname)){ 
_if107_cond:
  lea d, [bp + 5] ; $varname
  mov b, [d]
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if107_exit
_if107_true:
;; variables[vars_tos].as_int = as_int; 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  clb
  push d
  lea d, [bp + 7] ; $as_int
  mov b, [d]
  pop d
  mov [d], b
;; return i; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  leave
  ret
  jmp _if107_exit
_if107_exit:
_for106_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for106_cond
_for106_exit:
;; variables[vars_tos].var_type = SHELL_VAR_TYP_INT; 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb
  push d
  mov b, 1; SHELL_VAR_TYP_INT
  pop d
  mov [d], bl
;; strcpy(variables[vars_tos].varname, varname); 
  lea d, [bp + 5] ; $varname
  mov b, [d]
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  call strcpy
  add sp, 4
;; variables[vars_tos].as_int = as_int; 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  clb
  push d
  lea d, [bp + 7] ; $as_int
  mov b, [d]
  pop d
  mov [d], b
;; vars_tos++; 
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov g, b
  inc b
  mov d, _vars_tos ; $vars_tos
  mov [d], b
  mov b, g
;; return vars_tos - 1; 
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

get_var_index:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2

;; for(i = 0; i < vars_tos; i++) 
_for108_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for108_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for108_exit
_for108_block:
;; if(!strcmp(variables[i].varname, varname)) return i; 
_if109_cond:
  lea d, [bp + 5] ; $varname
  mov b, [d]
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if109_exit
_if109_true:
;; return i; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  leave
  ret
  jmp _if109_exit
_if109_exit:
_for108_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for108_cond
_for108_exit:
;; return -1; 
  mov b, $1
  neg b
  leave
  ret

get_var_type:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2

;; for(i = 0; i < vars_tos; i++) 
_for110_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for110_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for110_exit
_for110_block:
;; if(!strcmp(variables[i].varname, varname)) return variables[i].var_type; 
_if111_cond:
  lea d, [bp + 5] ; $varname
  mov b, [d]
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if111_exit
_if111_true:
;; return variables[i].var_type; 
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb
  mov bl, [d]
  mov bh, 0
  leave
  ret
  jmp _if111_exit
_if111_exit:
_for110_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for110_cond
_for110_exit:
;; return -1; 
  mov b, $1
  neg b
  leave
  ret

show_var:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2

;; for(i = 0; i < vars_tos; i++){ 
_for112_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for112_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for112_exit
_for112_block:
;; if(!strcmp(variables[i].varname, varname)){ 
_if113_cond:
  lea d, [bp + 5] ; $varname
  mov b, [d]
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if113_exit
_if113_true:
;; if(variables[i].var_type == SHELL_VAR_TYP_INT){ 
_if114_cond:
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, 1; SHELL_VAR_TYP_INT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if114_else
_if114_true:
;; printu(variables[i].as_int); 
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  clb
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
  jmp _if114_exit
_if114_else:
;; if(variables[i].var_type == SHELL_VAR_TYP_STR){ 
_if115_cond:
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, 0; SHELL_VAR_TYP_STR
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if115_exit
_if115_true:
;; printf(variables[i].as_string); 
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  call printf
  add sp, 2
  jmp _if115_exit
_if115_exit:
_if114_exit:
;; return i; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  leave
  ret
  jmp _if113_exit
_if113_exit:
_for112_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for112_cond
_for112_exit:
;; error("Undeclared variable."); 
  mov b, __s16 ; "Undeclared variable."
  swp b
  push b
  call error
  add sp, 2
  leave
  ret

get_shell_var_strval:
  enter 0 ; (push bp; mov bp, sp)
;; return variables[index].as_string; 
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + 5] ; $index
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  leave
  ret

get_shell_var_intval:
  enter 0 ; (push bp; mov bp, sp)
;; return variables[index].as_int; 
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + 5] ; $index
  mov b, [d]
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  clb
  mov b, [d]
  leave
  ret

file_exists:
  enter 0 ; (push bp; mov bp, sp)
; $file_exists 
  sub sp, 2


; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $filename
  mov d, [d]
  mov al, 21
  syscall sys_filesystem
  lea d, [bp + -1] ; $file_exists
  mov [d], a
; --- END INLINE ASM BLOCK

;; return file_exists; 
  lea d, [bp + -1] ; $file_exists
  mov b, [d]
  leave
  ret

command_cd:
  enter 0 ; (push bp; mov bp, sp)
; $dirID 
  sub sp, 2

;; *path = '\0'; 
  mov d, _path_data ; $path
  mov b, d
  push b
  mov b, $0
  pop d
  mov [d], bl
;; get(); 
  call get
;; if(toktype == END || tok == SEMICOLON || tok == BITWISE_NOT){ 
_if116_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov d, _tok ; $tok
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 35; SEMICOLON
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _tok ; $tok
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 25; BITWISE_NOT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if116_else
_if116_true:
;; back(); 
  call back
;; cd_to_dir(variables[1].as_string); 
  mov d, _variables_data ; $variables
  push a
  push d
  mov b, $1
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  call cd_to_dir
  add sp, 2
  jmp _if116_exit
_if116_else:
;; for(;;){ 
_for117_init:
_for117_cond:
_for117_block:
;; strcat(path, token); 
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  mov d, _path_data ; $path
  mov b, d
  swp b
  push b
  call strcat
  add sp, 4
;; get(); 
  call get
;; if(toktype == END) break; 
_if118_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if118_else
_if118_true:
;; break; 
  jmp _for117_exit ; for break
  jmp _if118_exit
_if118_else:
;; if(tok == SEMICOLON){ 
_if119_cond:
  mov d, _tok ; $tok
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 35; SEMICOLON
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if119_exit
_if119_true:
;; back(); 
  call back
;; break; 
  jmp _for117_exit ; for break
  jmp _if119_exit
_if119_exit:
_if118_exit:
_for117_update:
  jmp _for117_cond
_for117_exit:
;; cd_to_dir(path); 
  mov d, _path_data ; $path
  mov b, d
  swp b
  push b
  call cd_to_dir
  add sp, 2
_if116_exit:
  leave
  ret

cd_to_dir:
  enter 0 ; (push bp; mov bp, sp)
; $dirID 
  sub sp, 2


; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $dir
  mov d, [d]
  mov al, 19
  syscall sys_filesystem 
  lea d, [bp + -1] ; $dirID
  mov d, [d]
  mov [d], a 
  push a
; --- END INLINE ASM BLOCK

;; if(dirID != -1){ 
_if120_cond:
  lea d, [bp + -1] ; $dirID
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  neg b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if120_else
_if120_true:

; --- BEGIN INLINE ASM BLOCK
  pop a
  mov b, a
  mov al, 3
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  jmp _if120_exit
_if120_else:

; --- BEGIN INLINE ASM BLOCK
  pop a
; --- END INLINE ASM BLOCK

_if120_exit:
  leave
  ret

print_cwd:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov al, 18
  syscall sys_filesystem        
; --- END INLINE ASM BLOCK

  leave
  ret

spawn_new_proc:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 7] ; $args
  mov b, [d]
  lea d, [bp + 5] ; $executable_path
  mov d, [d]
  syscall sys_spawn_proc
; --- END INLINE ASM BLOCK

  leave
  ret

command_shell:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

command_fg:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

read_config:
  enter 0 ; (push bp; mov bp, sp)
;; transient_area = alloc(16385); 
  mov d, _transient_area ; $transient_area
  push d
  mov b, $4001
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b
;; *value = '\0'; 
  lea d, [bp + 9] ; $value
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
;; loadfile(filename, transient_area); 
  mov d, _transient_area ; $transient_area
  mov b, [d]
  swp b
  push b
  lea d, [bp + 5] ; $filename
  mov b, [d]
  swp b
  push b
  call loadfile
  add sp, 4
;; prog = transient_area; 
  mov d, _prog ; $prog
  push d
  mov d, _transient_area ; $transient_area
  mov b, [d]
  pop d
  mov [d], b
;; for(;;){ 
_for121_init:
_for121_cond:
_for121_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if122_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if122_exit
_if122_true:
;; break; 
  jmp _for121_exit ; for break
  jmp _if122_exit
_if122_exit:
;; if(!strcmp(entry_name, token)){ 
_if123_cond:
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  lea d, [bp + 7] ; $entry_name
  mov b, [d]
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if123_exit
_if123_true:
;; get(); // get '=' 
  call get
;; for(;;){ 
_for124_init:
_for124_cond:
_for124_block:
;; get(); 
  call get
;; if(!strcmp(token, ";")) return; 
_if125_cond:
  mov b, __s17 ; ";"
  swp b
  push b
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if125_exit
_if125_true:
;; return; 
  leave
  ret
  jmp _if125_exit
_if125_exit:
;; strcat(value, token); 
  mov d, _token_data ; $token
  mov b, d
  swp b
  push b
  lea d, [bp + 9] ; $value
  mov b, [d]
  swp b
  push b
  call strcat
  add sp, 4
_for124_update:
  jmp _for124_cond
_for124_exit:
  jmp _if123_exit
_if123_exit:
_for121_update:
  jmp _for121_cond
_for121_exit:
;; free(16385); 
  mov b, $4001
  swp b
  push b
  call free
  add sp, 2
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_tok: .fill 2, 0
_toktype: .fill 2, 0
_prog: .fill 2, 0
_token_data: .fill 256, 0
_string_const_data: .fill 256, 0
_transient_area: .fill 2, 0
_command_data: .fill 512, 0
_path_data: .fill 256, 0
_temp_data: .fill 256, 0
_argument_data: .fill 256, 0
_last_cmd_data: .fill 128, 0
_variables_data: .fill 210, 0
_vars_tos: .fill 2, 0
__s0: .db "path", 0
__s1: .db "home", 0
__s2: .db "/etc/shell.cfg", 0
__s3: .db "root@Sol-1:", 0
__s4: .db " # ", 0
__s5: .db "\n\r", 0
__s6: .db "cd", 0
__s7: .db "shell", 0
__s8: .db "123", 0
__s9: .db "/", 0
__s10: .db "Error: Unknown argument type.\n", 0
__s11: .db "\033[2J\033[H", 0
__s12: .db "\n", 0
__s13: .db "Double quotes expected", 0
__s14: .db "\nError: ", 0
__s15: .db "Error: Variable does not exist.", 0
__s16: .db "Undeclared variable.", 0
__s17: .db ";", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
