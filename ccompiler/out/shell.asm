; --- FILENAME: ../solarium/usr/bin/shell.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; char *p; 
  sub sp, 2
; char *t; 
  sub sp, 2
; char *temp_prog; 
  sub sp, 2
; char varname[ID_LEN]; 
  sub sp, 1
; char is_assignment; 
  sub sp, 1
; char variable_str[128]; 
  sub sp, 128
; int variable_int; 
  sub sp, 2
; int var_index; 
  sub sp, 2
; int i; 
  sub sp, 2
; new_str_var("path", "", 64); 
; --- START FUNCTION CALL
  mov32 cb, $00000040
  swp b
  push b
  mov b, _s0 ; ""
  swp b
  push b
  mov b, _s1 ; "path"
  swp b
  push b
  call new_str_var
  add sp, 6
; --- END FUNCTION CALL
; new_str_var("home", "", 64); 
; --- START FUNCTION CALL
  mov32 cb, $00000040
  swp b
  push b
  mov b, _s0 ; ""
  swp b
  push b
  mov b, _s2 ; "home"
  swp b
  push b
  call new_str_var
  add sp, 6
; --- END FUNCTION CALL
; read_config("/etc/shell.cfg", "path", variables[0].as_string); 
; --- START FUNCTION CALL
  mov d, _variables_data ; $variables
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s1 ; "path"
  swp b
  push b
  mov b, _s3 ; "/etc/shell.cfg"
  swp b
  push b
  call read_config
  add sp, 6
; --- END FUNCTION CALL
; read_config("/etc/shell.cfg", "home", variables[1].as_string); 
; --- START FUNCTION CALL
  mov d, _variables_data ; $variables
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s2 ; "home"
  swp b
  push b
  mov b, _s3 ; "/etc/shell.cfg"
  swp b
  push b
  call read_config
  add sp, 6
; --- END FUNCTION CALL
; for(;;){ 
_for1_init:
_for1_cond:
_for1_block:
; printf("root@Sol-1:");  
; --- START FUNCTION CALL
  mov b, _s4 ; "root@Sol-1:"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; print_cwd();  
; --- START FUNCTION CALL
  call print_cwd
; printf(" # "); 
; --- START FUNCTION CALL
  mov b, _s5 ; " # "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; gets(command); 
; --- START FUNCTION CALL
  mov d, _command_data ; $command
  mov b, d
  mov c, 0
  swp b
  push b
  call gets
  add sp, 2
; --- END FUNCTION CALL
; printf("\n\r"); 
; --- START FUNCTION CALL
  mov b, _s6 ; "\n\r"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; if(command[0]) strcpy(last_cmd, command); 
_if2_cond:
  mov d, _command_data ; $command
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
  je _if2_exit
_if2_TRUE:
; strcpy(last_cmd, command); 
; --- START FUNCTION CALL
  mov d, _command_data ; $command
  mov b, d
  mov c, 0
  swp b
  push b
  mov d, _last_cmd_data ; $last_cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
  jmp _if2_exit
_if2_exit:
; prog = command; 
  mov d, _prog ; $prog
  push d
  mov d, _command_data ; $command
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; for(;;){ 
_for3_init:
_for3_cond:
_for3_block:
; temp_prog = prog; 
  lea d, [bp + -5] ; $temp_prog
  push d
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok == SEMICOLON) get(); 
_if4_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $23 ; enum element: SEMICOLON
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if4_exit
_if4_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
  jmp _if4_exit
_if4_exit:
; if(toktype == END) break; // check for empty input 
_if5_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if5_exit
_if5_TRUE:
; break; // check for empty input 
  jmp _for3_exit ; for break
  jmp _if5_exit
_if5_exit:
; is_assignment = 0; 
  lea d, [bp + -7] ; $is_assignment
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if(toktype == IDENTIFIER){ 
_if6_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_TRUE:
; strcpy(varname, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -6] ; $varname
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; get(); 
; --- START FUNCTION CALL
  call get
; is_assignment = tok == ASSIGNMENT; 
  lea d, [bp + -7] ; $is_assignment
  push d
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $11 ; enum element: ASSIGNMENT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  pop d
  mov [d], bl
  jmp _if6_exit
_if6_exit:
; if(is_assignment){ 
_if7_cond:
  lea d, [bp + -7] ; $is_assignment
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if7_else
_if7_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == INTEGER_CONST) set_int_var(varname, atoi(token)); 
_if8_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $4 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if8_else
_if8_TRUE:
; set_int_var(varname, atoi(token)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call atoi
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  lea d, [bp + -6] ; $varname
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call set_int_var
  add sp, 4
; --- END FUNCTION CALL
  jmp _if8_exit
_if8_else:
; if(toktype == STRING_CONST) new_str_var(varname, string_const, strlen(string_const)); 
_if9_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if9_else
_if9_TRUE:
; new_str_var(varname, string_const, strlen(string_const)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -6] ; $varname
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call new_str_var
  add sp, 6
; --- END FUNCTION CALL
  jmp _if9_exit
_if9_else:
; if(toktype == IDENTIFIER) new_str_var(varname, token, strlen(token)); 
_if10_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if10_exit
_if10_TRUE:
; new_str_var(varname, token, strlen(token)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -6] ; $varname
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  call new_str_var
  add sp, 6
; --- END FUNCTION CALL
  jmp _if10_exit
_if10_exit:
_if9_exit:
_if8_exit:
  jmp _if7_exit
_if7_else:
; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -5] ; $temp_prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get(); 
; --- START FUNCTION CALL
  call get
; if(!strcmp(token, "cd")) command_cd(); 
_if11_cond:
; --- START FUNCTION CALL
  mov b, _s7 ; "cd"
  swp b
  push b
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if11_else
_if11_TRUE:
; command_cd(); 
; --- START FUNCTION CALL
  call command_cd
  jmp _if11_exit
_if11_else:
; if(!strcmp(token, "shell")) command_shell(); 
_if12_cond:
; --- START FUNCTION CALL
  mov b, _s8 ; "shell"
  swp b
  push b
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if12_else
_if12_TRUE:
; command_shell(); 
; --- START FUNCTION CALL
  call command_shell
  jmp _if12_exit
_if12_else:
; back(); 
; --- START FUNCTION CALL
  call back
; get_path(); 
; --- START FUNCTION CALL
  call get_path
; strcpy(path, token); // save file path 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  mov d, _path_data ; $path
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; for(i = 0; i < 256; i++) argument[i] = 0; 
_for13_init:
  lea d, [bp + -141] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for13_cond:
  lea d, [bp + -141] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000100
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for13_exit
_for13_block:
; argument[i] = 0; 
  mov d, _argument_data ; $argument
  push a
  push d
  lea d, [bp + -141] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
_for13_update:
  lea d, [bp + -141] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -141] ; $i
  mov [d], b
  mov b, a
  jmp _for13_cond
_for13_exit:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok != SEMICOLON && toktype != END){ 
_if14_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $23 ; enum element: SEMICOLON
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: END
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if14_exit
_if14_TRUE:
; back(); 
; --- START FUNCTION CALL
  call back
; p = argument; 
  lea d, [bp + -1] ; $p
  push d
  mov d, _argument_data ; $argument
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; do{ 
_do15_block:
; if(*prog == '$'){ 
_if16_cond:
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
  je _if16_else
_if16_TRUE:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; get(); // get variable name 
; --- START FUNCTION CALL
  call get
; var_index = get_var_index(token); 
  lea d, [bp + -139] ; $var_index
  push d
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call get_var_index
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if(var_index != -1){ 
_if17_cond:
  lea d, [bp + -139] ; $var_index
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if17_exit
_if17_TRUE:
; if(get_var_type(token) == SHELL_VAR_TYP_INT) strcat(argument, "123"); 
_if18_cond:
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call get_var_type
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $1 ; enum element: SHELL_VAR_TYP_INT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if18_else
_if18_TRUE:
; strcat(argument, "123"); 
; --- START FUNCTION CALL
  mov b, _s9 ; "123"
  swp b
  push b
  mov d, _argument_data ; $argument
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
  jmp _if18_exit
_if18_else:
; if(get_var_type(token) == SHELL_VAR_TYP_STR) strcat(argument, get_shell_var_strval(var_index)); 
_if19_cond:
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call get_var_type
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0 ; enum element: SHELL_VAR_TYP_STR
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_exit
_if19_TRUE:
; strcat(argument, get_shell_var_strval(var_index)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + -139] ; $var_index
  mov b, [d]
  mov c, 0
  swp b
  push b
  call get_shell_var_strval
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov d, _argument_data ; $argument
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
  jmp _if19_exit
_if19_exit:
_if18_exit:
; while(*p) p++; 
_while20_cond:
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while20_exit
_while20_block:
; p++; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  dec b
  jmp _while20_cond
_while20_exit:
  jmp _if17_exit
_if17_exit:
  jmp _if16_exit
_if16_else:
; *p++ = *prog++; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $p
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
_if16_exit:
; } while(*prog != '\0' && *prog != ';'); 
_do15_cond:
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
  mov32 cb, $0000003b
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 1
  je _do15_block
_do15_exit:
; *p = '\0'; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
  jmp _if14_exit
_if14_exit:
; if(*path == '/' || *path == '.') spawn_new_proc(path, argument); 
_if21_cond:
  mov d, _path_data ; $path
  mov b, d
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
  mov d, _path_data ; $path
  mov b, d
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
  je _if21_else
_if21_TRUE:
; spawn_new_proc(path, argument); 
; --- START FUNCTION CALL
  mov d, _argument_data ; $argument
  mov b, d
  mov c, 0
  swp b
  push b
  mov d, _path_data ; $path
  mov b, d
  mov c, 0
  swp b
  push b
  call spawn_new_proc
  add sp, 4
; --- END FUNCTION CALL
  jmp _if21_exit
_if21_else:
; temp_prog = prog; 
  lea d, [bp + -5] ; $temp_prog
  push d
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; prog = variables[0].as_string; 
  mov d, _prog ; $prog
  push d
  mov d, _variables_data ; $variables
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; for(;;){ 
_for22_init:
_for22_cond:
_for22_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END){ 
_if23_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if23_else
_if23_TRUE:
; break; 
  jmp _for22_exit ; for break
  jmp _if23_exit
_if23_else:
; back(); 
; --- START FUNCTION CALL
  call back
_if23_exit:
; get_path(); 
; --- START FUNCTION CALL
  call get_path
; strcpy(temp, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  mov d, _temp_data ; $temp
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; strcat(temp, "/"); 
; --- START FUNCTION CALL
  mov b, _s10 ; "/"
  swp b
  push b
  mov d, _temp_data ; $temp
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; strcat(temp, path); // form full filepath with ENV_PATH + given filename 
; --- START FUNCTION CALL
  mov d, _path_data ; $path
  mov b, d
  mov c, 0
  swp b
  push b
  mov d, _temp_data ; $temp
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; if(file_exists(temp) != 0){ 
_if24_cond:
; --- START FUNCTION CALL
  mov d, _temp_data ; $temp
  mov b, d
  mov c, 0
  swp b
  push b
  call file_exists
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_TRUE:
; spawn_new_proc(temp, argument); 
; --- START FUNCTION CALL
  mov d, _argument_data ; $argument
  mov b, d
  mov c, 0
  swp b
  push b
  mov d, _temp_data ; $temp
  mov b, d
  mov c, 0
  swp b
  push b
  call spawn_new_proc
  add sp, 4
; --- END FUNCTION CALL
; break; 
  jmp _for22_exit ; for break
  jmp _if24_exit
_if24_exit:
; get(); // get separator 
; --- START FUNCTION CALL
  call get
_for22_update:
  jmp _for22_cond
_for22_exit:
; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -5] ; $temp_prog
  mov b, [d]
  mov c, 0
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

last_cmd_insert:
  enter 0 ; (push bp; mov bp, sp)
; if(last_cmd[0]){ 
_if25_cond:
  mov d, _last_cmd_data ; $last_cmd
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
  je _if25_exit
_if25_TRUE:
; strcpy(command, last_cmd); 
; --- START FUNCTION CALL
  mov d, _last_cmd_data ; $last_cmd
  mov b, d
  mov c, 0
  swp b
  push b
  mov d, _command_data ; $command
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; printf(command); 
; --- START FUNCTION CALL
  mov d, _command_data ; $command
  mov b, d
  mov c, 0
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  jmp _if25_exit
_if25_exit:
  leave
  ret

new_str_var:
  enter 0 ; (push bp; mov bp, sp)
; variables[vars_tos].var_type = SHELL_VAR_TYP_STR; 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  push d
  mov32 cb, $0 ; enum element: SHELL_VAR_TYP_STR
  pop d
  mov [d], bl
; variables[vars_tos].as_string = alloc(64); 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  push d
; --- START FUNCTION CALL
  mov32 cb, $00000040
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; strcpy(variables[vars_tos].varname, varname); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $varname
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; strcpy(variables[vars_tos].as_string, strval); 
; --- START FUNCTION CALL
  lea d, [bp + 7] ; $strval
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; vars_tos++; 
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, _vars_tos ; $vars_tos
  mov [d], b
  mov b, a
; return vars_tos - 1; 
  mov d, _vars_tos ; $vars_tos
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
  leave
  ret

set_str_var:
  enter 0 ; (push bp; mov bp, sp)
; int var_index; 
  sub sp, 2
; for(var_index = 0; var_index < vars_tos; var_index++){ 
_for26_init:
  lea d, [bp + -1] ; $var_index
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for26_cond:
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for26_exit
_for26_block:
; if(!strcmp(variables[var_index].varname, varname)){ 
_if27_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $varname
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
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
  je _if27_exit
_if27_TRUE:
; strcpy(variables[var_index].as_string, strval); 
; --- START FUNCTION CALL
  lea d, [bp + 7] ; $strval
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; return var_index; 
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if27_exit
_if27_exit:
_for26_update:
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $var_index
  mov [d], b
  mov b, a
  jmp _for26_cond
_for26_exit:
; printf("Error: Variable does not exist."); 
; --- START FUNCTION CALL
  mov b, _s11 ; "Error: Variable does not exist."
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

set_int_var:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < vars_tos; i++){ 
_for28_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for28_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for28_exit
_for28_block:
; if(!strcmp(variables[i].varname, varname)){ 
_if29_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $varname
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
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
  je _if29_exit
_if29_TRUE:
; variables[vars_tos].as_int = as_int; 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  push d
  lea d, [bp + 7] ; $as_int
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
  jmp _if29_exit
_if29_exit:
_for28_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for28_cond
_for28_exit:
; variables[vars_tos].var_type = SHELL_VAR_TYP_INT; 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  push d
  mov32 cb, $1 ; enum element: SHELL_VAR_TYP_INT
  pop d
  mov [d], bl
; strcpy(variables[vars_tos].varname, varname); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $varname
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; variables[vars_tos].as_int = as_int; 
  mov d, _variables_data ; $variables
  push a
  push d
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  push d
  lea d, [bp + 7] ; $as_int
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; vars_tos++; 
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, _vars_tos ; $vars_tos
  mov [d], b
  mov b, a
; return vars_tos - 1; 
  mov d, _vars_tos ; $vars_tos
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
  leave
  ret

get_var_index:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < vars_tos; i++) 
_for30_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for30_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for30_exit
_for30_block:
; if(!strcmp(variables[i].varname, varname)) return i; 
_if31_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $varname
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
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
  je _if31_exit
_if31_TRUE:
; return i; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if31_exit
_if31_exit:
_for30_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for30_cond
_for30_exit:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret

get_var_type:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < vars_tos; i++) 
_for32_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for32_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for32_exit
_for32_block:
; if(!strcmp(variables[i].varname, varname)) return variables[i].var_type; 
_if33_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $varname
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
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
  je _if33_exit
_if33_TRUE:
; return variables[i].var_type; 
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret
  jmp _if33_exit
_if33_exit:
_for32_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for32_cond
_for32_exit:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret

show_var:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < vars_tos; i++){ 
_for34_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for34_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _vars_tos ; $vars_tos
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for34_exit
_for34_block:
; if(!strcmp(variables[i].varname, varname)){ 
_if35_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $varname
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
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
  je _if35_exit
_if35_TRUE:
; if(variables[i].var_type == SHELL_VAR_TYP_INT){ 
_if36_cond:
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $1 ; enum element: SHELL_VAR_TYP_INT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if36_else
_if36_TRUE:
; printf("%d", variables[i].as_int); 
; --- START FUNCTION CALL
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s12 ; "%d"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if36_exit
_if36_else:
; if(variables[i].var_type == SHELL_VAR_TYP_STR){ 
_if37_cond:
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0 ; enum element: SHELL_VAR_TYP_STR
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if37_exit
_if37_TRUE:
; printf(variables[i].as_string); 
; --- START FUNCTION CALL
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  jmp _if37_exit
_if37_exit:
_if36_exit:
; return i; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if35_exit
_if35_exit:
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
; error("Undeclared variable."); 
; --- START FUNCTION CALL
  mov b, _s13 ; "Undeclared variable."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

get_shell_var_strval:
  enter 0 ; (push bp; mov bp, sp)
; return variables[index].as_string; 
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + 5] ; $index
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  mov b, [d]
  mov c, 0
  leave
  ret

get_shell_var_intval:
  enter 0 ; (push bp; mov bp, sp)
; return variables[index].as_int; 
  mov d, _variables_data ; $variables
  push a
  push d
  lea d, [bp + 5] ; $index
  mov b, [d]
  mov c, 0
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  mov b, [d]
  mov c, 0
  leave
  ret

file_exists:
  enter 0 ; (push bp; mov bp, sp)
; int file_exists; 
  sub sp, 2
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $filename
  mov d, [d]
  mov al, 21
  syscall sys_filesystem
  lea d, [bp + -1] ; $file_exists
  mov [d], a
; --- END INLINE ASM SEGMENT
; return file_exists; 
  lea d, [bp + -1] ; $file_exists
  mov b, [d]
  mov c, 0
  leave
  ret

command_cd:
  enter 0 ; (push bp; mov bp, sp)
; int dirID; 
  sub sp, 2
; *path = '\0'; 
  mov d, _path_data ; $path
  mov b, d
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END || tok == SEMICOLON || tok == BITWISE_NOT){ 
_if38_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $23 ; enum element: SEMICOLON
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $19 ; enum element: BITWISE_NOT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if38_else
_if38_TRUE:
; back(); 
; --- START FUNCTION CALL
  call back
; cd_to_dir(variables[1].as_string); 
; --- START FUNCTION CALL
  mov d, _variables_data ; $variables
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  mov b, [d]
  mov c, 0
  swp b
  push b
  call cd_to_dir
  add sp, 2
; --- END FUNCTION CALL
  jmp _if38_exit
_if38_else:
; for(;;){ 
_for39_init:
_for39_cond:
_for39_block:
; strcat(path, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  mov d, _path_data ; $path
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if40_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if40_else
_if40_TRUE:
; break; 
  jmp _for39_exit ; for break
  jmp _if40_exit
_if40_else:
; if(tok == SEMICOLON){ 
_if41_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $23 ; enum element: SEMICOLON
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if41_exit
_if41_TRUE:
; back(); 
; --- START FUNCTION CALL
  call back
; break; 
  jmp _for39_exit ; for break
  jmp _if41_exit
_if41_exit:
_if40_exit:
_for39_update:
  jmp _for39_cond
_for39_exit:
; cd_to_dir(path); 
; --- START FUNCTION CALL
  mov d, _path_data ; $path
  mov b, d
  mov c, 0
  swp b
  push b
  call cd_to_dir
  add sp, 2
; --- END FUNCTION CALL
_if38_exit:
  leave
  ret

cd_to_dir:
  enter 0 ; (push bp; mov bp, sp)
; int dirID; 
  sub sp, 2
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $dir
  mov d, [d]
  mov al, 19
  syscall sys_filesystem ; get dirID in 'A'
  lea d, [bp + -1] ; $dirID
  mov d, [d]
  mov [d], a ; set dirID
  push a
; --- END INLINE ASM SEGMENT
; if(dirID != -1){ 
_if42_cond:
  lea d, [bp + -1] ; $dirID
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if42_else
_if42_TRUE:
; --- BEGIN INLINE ASM SEGMENT
  pop a
  mov b, a
  mov al, 3
  syscall sys_filesystem
; --- END INLINE ASM SEGMENT
  jmp _if42_exit
_if42_else:
; --- BEGIN INLINE ASM SEGMENT
  pop a
; --- END INLINE ASM SEGMENT
_if42_exit:
  leave
  ret

print_cwd:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  mov al, 18
  syscall sys_filesystem        ; print current directory
; --- END INLINE ASM SEGMENT
  leave
  ret

spawn_new_proc:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 7] ; $args
  mov b, [d]
  lea d, [bp + 5] ; $executable_path
  mov d, [d]
  syscall sys_spawn_proc
; --- END INLINE ASM SEGMENT
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
; transient_area = alloc(16385); 
  mov d, _transient_area ; $transient_area
  push d
; --- START FUNCTION CALL
  mov32 cb, $00004001
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; *value = '\0'; 
  lea d, [bp + 9] ; $value
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; loadfile(filename, transient_area); 
; --- START FUNCTION CALL
  mov d, _transient_area ; $transient_area
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + 5] ; $filename
  mov b, [d]
  mov c, 0
  swp b
  push b
  call loadfile
  add sp, 4
; --- END FUNCTION CALL
; prog = transient_area; 
  mov d, _prog ; $prog
  push d
  mov d, _transient_area ; $transient_area
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
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
  mov32 cb, $6 ; enum element: END
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
; if(!strcmp(entry_name, token)){ 
_if45_cond:
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + 7] ; $entry_name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if45_exit
_if45_TRUE:
; get(); // get '=' 
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for46_init:
_for46_cond:
_for46_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(!strcmp(token, ";")) return; 
_if47_cond:
; --- START FUNCTION CALL
  mov b, _s14 ; ";"
  swp b
  push b
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if47_exit
_if47_TRUE:
; return; 
  leave
  ret
  jmp _if47_exit
_if47_exit:
; strcat(value, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + 9] ; $value
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
_for46_update:
  jmp _for46_cond
_for46_exit:
  jmp _if45_exit
_if45_exit:
_for43_update:
  jmp _for43_cond
_for43_exit:
; free(16385); 
; --- START FUNCTION CALL
  mov32 cb, $00004001
  swp b
  push b
  call free
  add sp, 2
; --- END FUNCTION CALL
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
_while48_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while48_exit
_while48_block:
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
  jmp _while48_cond
_while48_exit:
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

loadfile:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 7] ; $destination
  mov a, [d]
  mov di, a
  lea d, [bp + 5] ; $filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem
; --- END INLINE ASM SEGMENT
  leave
  ret

get:
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
_while49_cond:
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
  je _while49_exit
_while49_block:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while49_cond
_while49_exit:
; if(*prog == '\0'){ 
_if50_cond:
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
  je _if50_exit
_if50_TRUE:
; toktype = END; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $6 ; enum element: END
  pop d
  mov [d], b
; return; 
  leave
  ret
  jmp _if50_exit
_if50_exit:
; if(is_digit(*prog)){ 
_if51_cond:
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
  je _if51_else
_if51_TRUE:
; while(is_digit(*prog)){ 
_while52_cond:
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
  je _while52_exit
_while52_block:
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
  jmp _while52_cond
_while52_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; toktype = INTEGER_CONST; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $4 ; enum element: INTEGER_CONST
  pop d
  mov [d], b
; return; // return to avoid *t = '\0' line at the end of function 
  leave
  ret
  jmp _if51_exit
_if51_else:
; if(is_alpha(*prog)){ 
_if53_cond:
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
  je _if53_else
_if53_TRUE:
; while(is_alpha(*prog) || is_digit(*prog)){ 
_while54_cond:
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
  je _while54_exit
_while54_block:
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
  jmp _while54_cond
_while54_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; toktype = IDENTIFIER; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $5 ; enum element: IDENTIFIER
  pop d
  mov [d], b
  jmp _if53_exit
_if53_else:
; if(*prog == '\"'){ 
_if55_cond:
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
  je _if55_else
_if55_TRUE:
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
_while56_cond:
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
  je _while56_exit
_while56_block:
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
  jmp _while56_cond
_while56_exit:
; if(*prog != '\"') error("Double quotes expected"); 
_if57_cond:
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
  je _if57_exit
_if57_TRUE:
; error("Double quotes expected"); 
; --- START FUNCTION CALL
  mov b, _s15 ; "Double quotes expected"
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if57_exit
_if57_exit:
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
  mov32 cb, $3 ; enum element: STRING_CONST
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
; convert_constant(); // converts this string token qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
; --- START FUNCTION CALL
  call convert_constant
  jmp _if55_exit
_if55_else:
; if(*prog == '#'){ 
_if58_cond:
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
  mov32 cb, $00000023
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if58_else
_if58_TRUE:
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
; tok = HASH; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $15 ; enum element: HASH
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if58_exit
_if58_else:
; if(*prog == '{'){ 
_if59_cond:
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
  mov32 cb, $0000007b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if59_else
_if59_TRUE:
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
; tok = OPENING_BRACE; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $1e ; enum element: OPENING_BRACE
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if59_exit
_if59_else:
; if(*prog == '}'){ 
_if60_cond:
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
  mov32 cb, $0000007d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if60_else
_if60_TRUE:
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
; tok = CLOSING_BRACE; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $1f ; enum element: CLOSING_BRACE
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if60_exit
_if60_else:
; if(*prog == '['){ 
_if61_cond:
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
  je _if61_else
_if61_TRUE:
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
  mov32 cb, $20 ; enum element: OPENING_BRACKET
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if61_exit
_if61_else:
; if(*prog == ']'){ 
_if62_cond:
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
  je _if62_else
_if62_TRUE:
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
  mov32 cb, $21 ; enum element: CLOSING_BRACKET
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if62_exit
_if62_else:
; if(*prog == '='){ 
_if63_cond:
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
  mov32 cb, $0000003d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if63_else
_if63_TRUE:
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
; if (*prog == '='){ 
_if64_cond:
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
  mov32 cb, $0000003d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if64_else
_if64_TRUE:
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
; tok = EQUAL; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $8 ; enum element: EQUAL
  pop d
  mov [d], b
  jmp _if64_exit
_if64_else:
; tok = ASSIGNMENT; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $11 ; enum element: ASSIGNMENT
  pop d
  mov [d], b
_if64_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if63_exit
_if63_else:
; if(*prog == '&'){ 
_if65_cond:
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
  mov32 cb, $00000026
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if65_else
_if65_TRUE:
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
; if(*prog == '&'){ 
_if66_cond:
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
  mov32 cb, $00000026
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if66_else
_if66_TRUE:
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
; tok = LOGICAL_AND; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $e ; enum element: LOGICAL_AND
  pop d
  mov [d], b
  jmp _if66_exit
_if66_else:
; tok = AMPERSAND; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $16 ; enum element: AMPERSAND
  pop d
  mov [d], b
_if66_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if65_exit
_if65_else:
; if(*prog == '|'){ 
_if67_cond:
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
  mov32 cb, $0000007c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if67_else
_if67_TRUE:
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
; if (*prog == '|'){ 
_if68_cond:
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
  mov32 cb, $0000007c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if68_else
_if68_TRUE:
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
; tok = LOGICAL_OR; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $f ; enum element: LOGICAL_OR
  pop d
  mov [d], b
  jmp _if68_exit
_if68_else:
; tok = BITWISE_OR; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $18 ; enum element: BITWISE_OR
  pop d
  mov [d], b
_if68_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if67_exit
_if67_else:
; if(*prog == '~'){ 
_if69_cond:
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
  mov32 cb, $0000007e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if69_else
_if69_TRUE:
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
; tok = BITWISE_NOT; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $19 ; enum element: BITWISE_NOT
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if69_exit
_if69_else:
; if(*prog == '<'){ 
_if70_cond:
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
  mov32 cb, $0000003c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if70_else
_if70_TRUE:
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
; if (*prog == '='){ 
_if71_cond:
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
  mov32 cb, $0000003d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if71_else
_if71_TRUE:
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
; tok = LESS_THAN_OR_EQUAL; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $b ; enum element: LESS_THAN_OR_EQUAL
  pop d
  mov [d], b
  jmp _if71_exit
_if71_else:
; if (*prog == '<'){ 
_if72_cond:
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
  mov32 cb, $0000003c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if72_else
_if72_TRUE:
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
; tok = BITWISE_SHL; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $1a ; enum element: BITWISE_SHL
  pop d
  mov [d], b
  jmp _if72_exit
_if72_else:
; tok = LESS_THAN; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $a ; enum element: LESS_THAN
  pop d
  mov [d], b
_if72_exit:
_if71_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if70_exit
_if70_else:
; if(*prog == '>'){ 
_if73_cond:
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
  mov32 cb, $0000003e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if73_else
_if73_TRUE:
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
; if (*prog == '='){ 
_if74_cond:
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
  mov32 cb, $0000003d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if74_else
_if74_TRUE:
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
; tok = GREATER_THAN_OR_EQUAL; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $d ; enum element: GREATER_THAN_OR_EQUAL
  pop d
  mov [d], b
  jmp _if74_exit
_if74_else:
; if (*prog == '>'){ 
_if75_cond:
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
  mov32 cb, $0000003e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if75_else
_if75_TRUE:
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
; tok = BITWISE_SHR; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $1b ; enum element: BITWISE_SHR
  pop d
  mov [d], b
  jmp _if75_exit
_if75_else:
; tok = GREATER_THAN; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $c ; enum element: GREATER_THAN
  pop d
  mov [d], b
_if75_exit:
_if74_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if73_exit
_if73_else:
; if(*prog == '!'){ 
_if76_cond:
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
  mov32 cb, $00000021
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if76_else
_if76_TRUE:
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
; if(*prog == '='){ 
_if77_cond:
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
  mov32 cb, $0000003d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if77_else
_if77_TRUE:
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
; tok = NOT_EQUAL; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $9 ; enum element: NOT_EQUAL
  pop d
  mov [d], b
  jmp _if77_exit
_if77_else:
; tok = LOGICAL_NOT; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $10 ; enum element: LOGICAL_NOT
  pop d
  mov [d], b
_if77_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if76_exit
_if76_else:
; if(*prog == '+'){ 
_if78_cond:
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
  je _if78_else
_if78_TRUE:
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
; if(*prog == '+'){ 
_if79_cond:
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
  je _if79_else
_if79_TRUE:
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
; tok = INCREMENT; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $5 ; enum element: INCREMENT
  pop d
  mov [d], b
  jmp _if79_exit
_if79_else:
; tok = PLUS; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $1 ; enum element: PLUS
  pop d
  mov [d], b
_if79_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if78_exit
_if78_else:
; if(*prog == '-'){ 
_if80_cond:
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
  je _if80_else
_if80_TRUE:
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
; if(*prog == '-'){ 
_if81_cond:
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
  je _if81_else
_if81_TRUE:
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
; tok = DECREMENT; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $6 ; enum element: DECREMENT
  pop d
  mov [d], b
  jmp _if81_exit
_if81_else:
; tok = MINUS; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $2 ; enum element: MINUS
  pop d
  mov [d], b
_if81_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if80_exit
_if80_else:
; if(*prog == '$'){ 
_if82_cond:
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
  je _if82_else
_if82_TRUE:
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
  mov32 cb, $12 ; enum element: DOLLAR
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if82_exit
_if82_else:
; if(*prog == '^'){ 
_if83_cond:
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
  mov32 cb, $0000005e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if83_else
_if83_TRUE:
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
; tok = BITWISE_XOR; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $17 ; enum element: BITWISE_XOR
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if83_exit
_if83_else:
; if(*prog == '@'){ 
_if84_cond:
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
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if84_else
_if84_TRUE:
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
; tok = AT; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $14 ; enum element: AT
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if84_exit
_if84_else:
; if(*prog == '*'){ 
_if85_cond:
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
  mov32 cb, $0000002a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if85_else
_if85_TRUE:
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
; tok = STAR; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $3 ; enum element: STAR
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if85_exit
_if85_else:
; if(*prog == '/'){ 
_if86_cond:
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
  cmp b, 0
  je _if86_else
_if86_TRUE:
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
; tok = FSLASH; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $4 ; enum element: FSLASH
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if86_exit
_if86_else:
; if(*prog == '%'){ 
_if87_cond:
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
  mov32 cb, $00000025
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if87_else
_if87_TRUE:
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
; tok = MOD; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $7 ; enum element: MOD
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if87_exit
_if87_else:
; if(*prog == '('){ 
_if88_cond:
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
  mov32 cb, $00000028
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if88_else
_if88_TRUE:
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
; tok = OPENING_PAREN; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $1c ; enum element: OPENING_PAREN
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if88_exit
_if88_else:
; if(*prog == ')'){ 
_if89_cond:
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
  mov32 cb, $00000029
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if89_else
_if89_TRUE:
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
; tok = CLOSING_PAREN; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $1d ; enum element: CLOSING_PAREN
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if89_exit
_if89_else:
; if(*prog == ';'){ 
_if90_cond:
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
  je _if90_else
_if90_TRUE:
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
  mov32 cb, $23 ; enum element: SEMICOLON
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if90_exit
_if90_else:
; if(*prog == ':'){ 
_if91_cond:
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
  je _if91_else
_if91_TRUE:
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
  mov32 cb, $22 ; enum element: COLON
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if91_exit
_if91_else:
; if(*prog == ','){ 
_if92_cond:
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
  je _if92_else
_if92_TRUE:
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
  mov32 cb, $24 ; enum element: COMMA
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if92_exit
_if92_else:
; if(*prog == '.'){ 
_if93_cond:
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
  je _if93_exit
_if93_TRUE:
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
  mov32 cb, $25 ; enum element: DOT
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if93_exit
_if93_exit:
_if92_exit:
_if91_exit:
_if90_exit:
_if89_exit:
_if88_exit:
_if87_exit:
_if86_exit:
_if85_exit:
_if84_exit:
_if83_exit:
_if82_exit:
_if80_exit:
_if78_exit:
_if76_exit:
_if73_exit:
_if70_exit:
_if69_exit:
_if67_exit:
_if65_exit:
_if63_exit:
_if62_exit:
_if61_exit:
_if60_exit:
_if59_exit:
_if58_exit:
_if55_exit:
_if53_exit:
_if51_exit:
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

error:
  enter 0 ; (push bp; mov bp, sp)
; printf("\nError: "); 
; --- START FUNCTION CALL
  mov b, _s16 ; "\nError: "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; printf(msg); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $msg
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s17 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
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
_for94_init:
_for94_cond:
_for94_block:
; if(!*format_p) break; 
_if95_cond:
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
  je _if95_else
_if95_TRUE:
; break; 
  jmp _for94_exit ; for break
  jmp _if95_exit
_if95_else:
; if(*format_p == '%'){ 
_if96_cond:
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
  je _if96_else
_if96_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch97_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch97_comparisons:
  cmp bl, $6c
  je _switch97_case0
  cmp bl, $4c
  je _switch97_case1
  cmp bl, $64
  je _switch97_case2
  cmp bl, $69
  je _switch97_case3
  cmp bl, $75
  je _switch97_case4
  cmp bl, $78
  je _switch97_case5
  cmp bl, $63
  je _switch97_case6
  cmp bl, $73
  je _switch97_case7
  jmp _switch97_default
  jmp _switch97_exit
_switch97_case0:
_switch97_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if98_cond:
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
  je _if98_else
_if98_TRUE:
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
  jmp _if98_exit
_if98_else:
; if(*format_p == 'u') 
_if99_cond:
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
  je _if99_else
_if99_TRUE:
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
  jmp _if99_exit
_if99_else:
; if(*format_p == 'x') 
_if100_cond:
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
  je _if100_else
_if100_TRUE:
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
  jmp _if100_exit
_if100_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s18 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if100_exit:
_if99_exit:
_if98_exit:
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
  jmp _switch97_exit ; case break
_switch97_case2:
_switch97_case3:
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
  jmp _switch97_exit ; case break
_switch97_case4:
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
  jmp _switch97_exit ; case break
_switch97_case5:
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
  jmp _switch97_exit ; case break
_switch97_case6:
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
  jmp _switch97_exit ; case break
_switch97_case7:
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
  jmp _switch97_exit ; case break
_switch97_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s19 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch97_exit:
  jmp _if96_exit
_if96_else:
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
_if96_exit:
_if95_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for94_update:
  jmp _for94_cond
_for94_exit:
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
_if101_cond:
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
  je _if101_else
_if101_TRUE:
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
  jmp _if101_exit
_if101_else:
; if (num == 0) { 
_if102_cond:
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
  je _if102_exit
_if102_TRUE:
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
  jmp _if102_exit
_if102_exit:
_if101_exit:
; while (num > 0) { 
_while103_cond:
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
  je _while103_exit
_while103_block:
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
  jmp _while103_cond
_while103_exit:
; while (i > 0) { 
_while110_cond:
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
  je _while110_exit
_while110_block:
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
  jmp _while110_cond
_while110_exit:
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
_if111_cond:
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
  je _if111_exit
_if111_TRUE:
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
  jmp _if111_exit
_if111_exit:
; while (num > 0) { 
_while112_cond:
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
  je _while112_exit
_while112_block:
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
  jmp _while112_cond
_while112_exit:
; while (i > 0) { 
_while119_cond:
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
  je _while119_exit
_while119_block:
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
  jmp _while119_cond
_while119_exit:
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
_if120_cond:
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
  je _if120_else
_if120_TRUE:
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
  jmp _if120_exit
_if120_else:
; if (num == 0) { 
_if121_cond:
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
  je _if121_exit
_if121_TRUE:
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
  jmp _if121_exit
_if121_exit:
_if120_exit:
; while (num > 0) { 
_while122_cond:
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
  je _while122_exit
_while122_block:
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
  jmp _while122_cond
_while122_exit:
; while (i > 0) { 
_while129_cond:
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
  je _while129_exit
_while129_block:
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
  jmp _while129_cond
_while129_exit:
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
_if130_cond:
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
  je _if130_exit
_if130_TRUE:
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
  jmp _if130_exit
_if130_exit:
; while (num > 0) { 
_while131_cond:
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
  je _while131_exit
_while131_block:
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
  jmp _while131_cond
_while131_exit:
; while (i > 0) { 
_while138_cond:
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
  je _while138_exit
_while138_block:
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
  jmp _while138_cond
_while138_exit:
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
_if139_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $2 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if139_else
_if139_TRUE:
; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; if(*t == '\\'){ 
_if140_cond:
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
  je _if140_else
_if140_TRUE:
; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; switch(*t){ 
_switch141_expr:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch141_comparisons:
  cmp bl, $30
  je _switch141_case0
  cmp bl, $61
  je _switch141_case1
  cmp bl, $62
  je _switch141_case2
  cmp bl, $66
  je _switch141_case3
  cmp bl, $6e
  je _switch141_case4
  cmp bl, $72
  je _switch141_case5
  cmp bl, $74
  je _switch141_case6
  cmp bl, $76
  je _switch141_case7
  cmp bl, $5c
  je _switch141_case8
  cmp bl, $27
  je _switch141_case9
  cmp bl, $22
  je _switch141_case10
  jmp _switch141_exit
_switch141_case0:
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
  jmp _switch141_exit ; case break
_switch141_case1:
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
  jmp _switch141_exit ; case break
_switch141_case2:
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
  jmp _switch141_exit ; case break
_switch141_case3:
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
  jmp _switch141_exit ; case break
_switch141_case4:
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
  jmp _switch141_exit ; case break
_switch141_case5:
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
  jmp _switch141_exit ; case break
_switch141_case6:
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
  jmp _switch141_exit ; case break
_switch141_case7:
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
  jmp _switch141_exit ; case break
_switch141_case8:
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
  jmp _switch141_exit ; case break
_switch141_case9:
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
  jmp _switch141_exit ; case break
_switch141_case10:
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
_switch141_exit:
  jmp _if140_exit
_if140_else:
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
_if140_exit:
  jmp _if139_exit
_if139_else:
; if(toktype == STRING_CONST){ 
_if142_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if142_exit
_if142_TRUE:
; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; while(*t != '\"' && *t){ 
_while143_cond:
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
  je _while143_exit
_while143_block:
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
  jmp _while143_cond
_while143_exit:
  jmp _if142_exit
_if142_exit:
_if139_exit:
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

strcmp:
  enter 0 ; (push bp; mov bp, sp)
; while (*s1 && (*s1 == *s2)) { 
_while144_cond:
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
  je _while144_exit
_while144_block:
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
  jmp _while144_cond
_while144_exit:
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
_for145_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for145_cond:
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
  je _for145_exit
_for145_block:
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
_for145_update:
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
  jmp _for145_cond
_for145_exit:
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
_while146_cond:
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
  je _while146_exit
_while146_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, a
  jmp _while146_cond
_while146_exit:
; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  leave
  ret

free:
  enter 0 ; (push bp; mov bp, sp)
; return heap_top = heap_top - bytes; 
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
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  leave
  ret

gets:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _gets_gets
; --- END INLINE ASM SEGMENT
; return strlen(s); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_gets_gets:
  push a
  push d
_gets_loop_gets:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_loop_gets      ; if no char received, retry
  cmp ah, 27
  je _gets_ansi_esc_gets
  cmp ah, $0A        ; LF
  je _gets_end_gets
  cmp ah, $0D        ; CR
  je _gets_end_gets
  cmp ah, $5C        ; '\\'
  je _gets_escape_gets
  cmp ah, $08      ; check for backspace
  je _gets_backspace_gets
  mov al, ah
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_backspace_gets:
  dec d
  jmp _gets_loop_gets
_gets_ansi_esc_gets:
  mov al, 1
  syscall sys_io        ; receive in AH without echo
  cmp al, 0          ; check error code (AL)
  je _gets_ansi_esc_gets    ; if no char received, retry
  cmp ah, '['
  jne _gets_loop_gets
_gets_ansi_esc_2_gets:
  mov al, 1
  syscall sys_io          ; receive in AH without echo
  cmp al, 0            ; check error code (AL)
  je _gets_ansi_esc_2_gets  ; if no char received, retry
  cmp ah, 'D'
  je _gets_left_arrow_gets
  cmp ah, 'C'
  je _gets_right_arrow_gets
  jmp _gets_loop_gets
_gets_left_arrow_gets:
  dec d
  jmp _gets_loop_gets
_gets_right_arrow_gets:
  inc d
  jmp _gets_loop_gets
_gets_escape_gets:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_escape_gets      ; if no char received, retry
  cmp ah, 'n'
  je _gets_LF_gets
  cmp ah, 'r'
  je _gets_CR_gets
  cmp ah, '0'
  je _gets_NULL_gets
  cmp ah, $5C  
  je _gets_slash_gets
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_slash_gets:
  mov al, $5C
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_LF_gets:
  mov al, $0A
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_CR_gets:
  mov al, $0D
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_NULL_gets:
  mov al, $00
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_end_gets:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  pop a
  ret
; --- END INLINE ASM SEGMENT
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
_while147_cond:
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
  je _while147_exit
_while147_block:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while147_cond
_while147_exit:
; if (*str == '-' || *str == '+') { 
_if148_cond:
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
  je _if148_exit
_if148_TRUE:
; if (*str == '-') sign = -1; 
_if149_cond:
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
  je _if149_exit
_if149_TRUE:
; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
  jmp _if149_exit
_if149_exit:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _if148_exit
_if148_exit:
; while (*str >= '0' && *str <= '9') { 
_while150_cond:
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
  je _while150_exit
_while150_block:
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
  jz skip_invert_a_152  
  neg a 
skip_invert_a_152:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_152  
  neg b 
skip_invert_b_152:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_152
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_152:
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
  jmp _while150_cond
_while150_exit:
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
  jz skip_invert_a_154  
  neg a 
skip_invert_a_154:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_154  
  neg b 
skip_invert_b_154:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_154
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_154:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
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
; while(*t++) prog--; 
_while155_cond:
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while155_exit
_while155_block:
; prog--; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  dec b
  mov d, _prog ; $prog
  mov [d], b
  inc b
  jmp _while155_cond
_while155_exit:
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
; token[0] = '\0'; 
  mov d, _token_data ; $token
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
; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; while(is_space(*prog)) prog++; 
_while156_cond:
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
  je _while156_exit
_while156_block:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while156_cond
_while156_exit:
; if(*prog == '\0'){ 
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
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if157_exit
_if157_TRUE:
; return; 
  leave
  ret
  jmp _if157_exit
_if157_exit:
; while( 
_while158_cond:
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
  mov32 cb, $00000061
  cmp a, b
  sgeu ; >= (unsigned)
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
  mov32 cb, $0000007a
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
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
  mov32 cb, $00000041
  cmp a, b
  sgeu ; >= (unsigned)
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
  mov32 cb, $0000005a
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
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
  mov32 cb, $00000030
  cmp a, b
  sgeu ; >= (unsigned)
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
  mov32 cb, $00000039
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
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
  mov32 cb, $0000002f
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
  je _while158_exit
_while158_block:
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
  jmp _while158_cond
_while158_exit:
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
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_transient_area: .fill 2, 0
_command_data: .fill 512, 0
_path_data: .fill 256, 0
_temp_data: .fill 256, 0
_argument_data: .fill 256, 0
_last_cmd_data: .fill 128, 0
_variables_data: .fill 210, 0
_vars_tos: .fill 2, 0
_tok: .fill 2, 0
_toktype: .fill 2, 0
_prog: .fill 2, 0
_token_data: .fill 256, 0
_string_const_data: .fill 256, 0
_s0: .db "", 0
_s1: .db "path", 0
_s2: .db "home", 0
_s3: .db "/etc/shell.cfg", 0
_s4: .db "root@Sol-1:", 0
_s5: .db " # ", 0
_s6: .db "\n\r", 0
_s7: .db "cd", 0
_s8: .db "shell", 0
_s9: .db "123", 0
_s10: .db "/", 0
_s11: .db "Error: Variable does not exist.", 0
_s12: .db "%d", 0
_s13: .db "Undeclared variable.", 0
_s14: .db ";", 0
_s15: .db "Double quotes expected", 0
_s16: .db "\nError: ", 0
_s17: .db "\n", 0
_s18: .db "Unexpected format in printf.", 0
_s19: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
