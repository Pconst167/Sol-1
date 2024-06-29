; --- FILENAME: ../solarium/usr/bin/shell.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
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
  mov b, _s1 ; ""
  swp b
  push b
  mov b, _s0 ; "path"
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
  mov b, _s2 ; ""
  swp b
  push b
  mov b, _s1 ; "home"
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
  mov b, _s0 ; "path"
  swp b
  push b
  mov b, _s2 ; "/etc/shell.cfg"
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
  mov b, _s1 ; "home"
  swp b
  push b
  mov b, _s2 ; "/etc/shell.cfg"
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
  mov b, _s3 ; "root@Sol-1:"
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
  mov b, _s4 ; " # "
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
  mov b, _s5 ; "\n\r"
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
  mov b, _s6 ; "cd"
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
  mov b, _s7 ; "shell"
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
  mov32 cb, $00000001
  neg b
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
  mov b, _s8 ; "123"
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
  mov b, _s9 ; "/"
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

include_ctype_lib:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
.include "lib/asm/ctype.asm"
; --- END INLINE ASM SEGMENT

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

tolower:
  enter 0 ; (push bp; mov bp, sp)
; if (ch >= 'A' && ch <= 'Z')  
_if25_cond:
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
  je _if25_else
_if25_TRUE:
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
  jmp _if25_exit
_if25_else:
; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret
_if25_exit:
  leave
  ret

toupper:
  enter 0 ; (push bp; mov bp, sp)
; if (ch >= 'a' && ch <= 'z')  
_if26_cond:
  lea d, [bp + 5] ; $ch
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
  lea d, [bp + 5] ; $ch
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
  cmp b, 0
  je _if26_else
_if26_TRUE:
; return ch - 'a' + 'A'; 
  lea d, [bp + 5] ; $ch
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
  mov32 cb, $00000041
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if26_exit
_if26_else:
; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret
_if26_exit:
  leave
  ret

is_delimiter:
  enter 0 ; (push bp; mov bp, sp)
; if( 
_if27_cond:
  lea d, [bp + 5] ; $c
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
  mov32 cb, $00000023
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
  mov32 cb, $00000024
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
  mov32 cb, $0000002b
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
  mov32 cb, $0000002d
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
  mov32 cb, $0000002a
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
  mov32 cb, $0000002f
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
  mov32 cb, $00000025
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
  mov32 cb, $0000005b
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
  mov32 cb, $0000005d
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
  mov32 cb, $00000028
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
  mov32 cb, $00000029
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
  mov32 cb, $0000007b
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
  mov32 cb, $0000007d
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
  mov32 cb, $0000003a
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
  mov32 cb, $0000003b
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
  mov32 cb, $0000003c
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
  mov32 cb, $0000003e
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
  mov32 cb, $0000003d
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
  mov32 cb, $00000021
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
  mov32 cb, $0000005e
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
  mov32 cb, $00000026
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
  mov32 cb, $0000007c
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
  mov32 cb, $0000007e
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
  mov32 cb, $0000002e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if27_else
_if27_TRUE:
; return 1; 
  mov32 cb, $00000001
  leave
  ret
  jmp _if27_exit
_if27_else:
; return 0; 
  mov32 cb, $00000000
  leave
  ret
_if27_exit:
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
_while28_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while28_exit
_while28_block:
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
  jmp _while28_cond
_while28_exit:
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

strcmp:
  enter 0 ; (push bp; mov bp, sp)
; while (*s1 && (*s1 == *s2)) { 
_while29_cond:
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
  je _while29_exit
_while29_block:
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
  jmp _while29_cond
_while29_exit:
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

strncmp:
  enter 0 ; (push bp; mov bp, sp)
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
_for30_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for30_cond:
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
  je _for30_exit
_for30_block:
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
_for30_update:
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
  jmp _for30_cond
_for30_exit:
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
_while31_cond:
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
  je _while31_exit
_while31_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, a
  jmp _while31_cond
_while31_exit:
; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
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

memset:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < size; i++){ 
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
  lea d, [bp + 8] ; $size
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for32_exit
_for32_block:
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
; return s; 
  lea d, [bp + 5] ; $s
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
_while33_cond:
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
  je _while33_exit
_while33_block:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while33_cond
_while33_exit:
; if (*str == '-' || *str == '+') { 
_if34_cond:
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
  je _if34_exit
_if34_TRUE:
; if (*str == '-') sign = -1; 
_if35_cond:
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
  je _if35_exit
_if35_TRUE:
; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov32 cb, $00000001
  neg b
  pop d
  mov [d], b
  jmp _if35_exit
_if35_exit:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _if34_exit
_if34_exit:
; while (*str >= '0' && *str <= '9') { 
_while36_cond:
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
  je _while36_exit
_while36_block:
; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov32 cb, $0000000a
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
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
  jmp _while36_cond
_while36_exit:
; return sign * result; 
  lea d, [bp + -3] ; $sign
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  leave
  ret

rand:
  enter 0 ; (push bp; mov bp, sp)
; int  sec; 
  sub sp, 2

; --- BEGIN INLINE ASM SEGMENT
  mov al, 0
  syscall sys_rtc					
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

fopen:
  enter 0 ; (push bp; mov bp, sp)
; FILE *fp; 
  sub sp, 2
; static int max_handle = 0; 
  sub sp, 2
; fp = alloc(sizeof(FILE)); 
  lea d, [bp + -1] ; $fp
  push d
; --- START FUNCTION CALL
  mov32 cb, 260
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; strcpy(fp->filename, filename); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $filename
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $fp
  mov d, [d]
  add d, 2
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; fp->handle = max_handle; 
  lea d, [bp + -1] ; $fp
  mov d, [d]
  add d, 0
  push d
  mov d, st_fopen_max_handle ; static max_handle
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; fp->mode = mode; 
  lea d, [bp + -1] ; $fp
  mov d, [d]
  add d, 258
  push d
  lea d, [bp + 7] ; $mode
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; fp->loc = 0; 
  lea d, [bp + -1] ; $fp
  mov d, [d]
  add d, 259
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; max_handle++; 
  mov d, st_fopen_max_handle ; static max_handle
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, st_fopen_max_handle ; static max_handle
  mov [d], b
  mov b, a
  leave
  ret

fclose:
  enter 0 ; (push bp; mov bp, sp)
; free(sizeof(FILE)); 
; --- START FUNCTION CALL
  mov32 cb, 260
  swp b
  push b
  call free
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
_for37_init:
_for37_cond:
_for37_block:
; if(!*format_p) break; 
_if38_cond:
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
  je _if38_else
_if38_TRUE:
; break; 
  jmp _for37_exit ; for break
  jmp _if38_exit
_if38_else:
; if(*format_p == '%'){ 
_if39_cond:
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
  je _if39_else
_if39_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch40_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch40_comparisons:
  cmp bl, $6c
  je _switch40_case0
  cmp bl, $4c
  je _switch40_case1
  cmp bl, $64
  je _switch40_case2
  cmp bl, $69
  je _switch40_case3
  cmp bl, $75
  je _switch40_case4
  cmp bl, $78
  je _switch40_case5
  cmp bl, $63
  je _switch40_case6
  cmp bl, $73
  je _switch40_case7
  jmp _switch40_default
  jmp _switch40_exit
_switch40_case0:
_switch40_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if41_cond:
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
  je _if41_else
_if41_TRUE:
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
  jmp _if41_exit
_if41_else:
; if(*format_p == 'u') 
_if42_cond:
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
  je _if42_else
_if42_TRUE:
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
  jmp _if42_exit
_if42_else:
; if(*format_p == 'x') 
_if43_cond:
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
  je _if43_else
_if43_TRUE:
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
  jmp _if43_exit
_if43_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s10 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if43_exit:
_if42_exit:
_if41_exit:
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
  jmp _switch40_exit ; case break
_switch40_case2:
_switch40_case3:
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
  jmp _switch40_exit ; case break
_switch40_case4:
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
  jmp _switch40_exit ; case break
_switch40_case5:

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov b, [d]
  call print_u16x
; --- END INLINE ASM SEGMENT

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
  jmp _switch40_exit ; case break
_switch40_case6:

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM SEGMENT

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
  jmp _switch40_exit ; case break
_switch40_case7:

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov d, [d]
  call _puts
; --- END INLINE ASM SEGMENT

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
  jmp _switch40_exit ; case break
_switch40_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s11 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch40_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if39_exit
_if39_else:
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
_if39_exit:
_if38_exit:
_for37_update:
  jmp _for37_cond
_for37_exit:
  leave
  ret

scanf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 2
  sub sp, 2
; char c; 
  sub sp, 1
; int i; 
  sub sp, 2
; char input_string[  512                    ]; 
  sub sp, 512
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
_for44_init:
_for44_cond:
_for44_block:
; if(!*format_p) break; 
_if45_cond:
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
  je _if45_else
_if45_TRUE:
; break; 
  jmp _for44_exit ; for break
  jmp _if45_exit
_if45_else:
; if(*format_p == '%'){ 
_if46_cond:
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
  je _if46_else
_if46_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch47_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch47_comparisons:
  cmp bl, $6c
  je _switch47_case0
  cmp bl, $4c
  je _switch47_case1
  cmp bl, $64
  je _switch47_case2
  cmp bl, $69
  je _switch47_case3
  cmp bl, $75
  je _switch47_case4
  cmp bl, $78
  je _switch47_case5
  cmp bl, $63
  je _switch47_case6
  cmp bl, $73
  je _switch47_case7
  jmp _switch47_default
  jmp _switch47_exit
_switch47_case0:
_switch47_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i'); 
_if48_cond:
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
  je _if48_else
_if48_TRUE:
; ; 
  jmp _if48_exit
_if48_else:
; if(*format_p == 'u'); 
_if49_cond:
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
  je _if49_else
_if49_TRUE:
; ; 
  jmp _if49_exit
_if49_else:
; if(*format_p == 'x'); 
_if50_cond:
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
  je _if50_else
_if50_TRUE:
; ; 
  jmp _if50_exit
_if50_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s10 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if50_exit:
_if49_exit:
_if48_exit:
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
  jmp _switch47_exit ; case break
_switch47_case2:
_switch47_case3:
; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
; --- START FUNCTION CALL
  call scann
  pop d
  mov [d], b
; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
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
  jmp _switch47_exit ; case break
_switch47_case4:
; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
; --- START FUNCTION CALL
  call scann
  pop d
  mov [d], b
; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
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
  jmp _switch47_exit ; case break
_switch47_case5:
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
  jmp _switch47_exit ; case break
_switch47_case6:
; c = getchar(); 
  lea d, [bp + -4] ; $c
  push d
; --- START FUNCTION CALL
  call getchar
  pop d
  mov [d], bl
; **(char **)p = *(char *)c; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -4] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], b
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
  jmp _switch47_exit ; case break
_switch47_case7:
; gets(input_string); 
; --- START FUNCTION CALL
  lea d, [bp + -518] ; $input_string
  mov b, d
  mov c, 0
  swp b
  push b
  call gets
  add sp, 2
; --- END FUNCTION CALL
; strcpy(*(char **)p, input_string); 
; --- START FUNCTION CALL
  lea d, [bp + -518] ; $input_string
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call strcpy
  add sp, 4
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
  jmp _switch47_exit ; case break
_switch47_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s11 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch47_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if46_exit
_if46_else:
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
_if46_exit:
_if45_exit:
_for44_update:
  jmp _for44_cond
_for44_exit:
  leave
  ret

sprintf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 2
  sub sp, 2
; char *sp; 
  sub sp, 2
; sp = dest; 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 7] ; $format
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 7] ; $format
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
_for51_init:
_for51_cond:
_for51_block:
; if(!*format_p) break; 
_if52_cond:
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
  je _if52_else
_if52_TRUE:
; break; 
  jmp _for51_exit ; for break
  jmp _if52_exit
_if52_else:
; if(*format_p == '%'){ 
_if53_cond:
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
  je _if53_else
_if53_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch54_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch54_comparisons:
  cmp bl, $6c
  je _switch54_case0
  cmp bl, $4c
  je _switch54_case1
  cmp bl, $64
  je _switch54_case2
  cmp bl, $69
  je _switch54_case3
  cmp bl, $75
  je _switch54_case4
  cmp bl, $78
  je _switch54_case5
  cmp bl, $63
  je _switch54_case6
  cmp bl, $73
  je _switch54_case7
  jmp _switch54_default
  jmp _switch54_exit
_switch54_case0:
_switch54_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if55_cond:
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
  je _if55_else
_if55_TRUE:
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
  jmp _if55_exit
_if55_else:
; if(*format_p == 'u') 
_if56_cond:
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
  je _if56_else
_if56_TRUE:
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
  jmp _if56_exit
_if56_else:
; if(*format_p == 'x') 
_if57_cond:
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
  je _if57_else
_if57_TRUE:
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
  jmp _if57_exit
_if57_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s10 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if57_exit:
_if56_exit:
_if55_exit:
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
  jmp _switch54_exit ; case break
_switch54_case2:
_switch54_case3:
; sp = sp + sprint_signed(sp, *(int*)p); 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call sprint_signed
  add sp, 4
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
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
  jmp _switch54_exit ; case break
_switch54_case4:
; sp = sp + sprint_unsigned(sp, *(unsigned int*)p); 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call sprint_unsigned
  add sp, 4
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
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
  jmp _switch54_exit ; case break
_switch54_case5:

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov b, [d]
  call print_u16x
; --- END INLINE ASM SEGMENT

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
  jmp _switch54_exit ; case break
_switch54_case6:
; *sp++ = *(char *)p; 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -5] ; $sp
  mov [d], b
  dec b
  push b
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
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
  jmp _switch54_exit ; case break
_switch54_case7:
; int len = strlen(*(char **)p); 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -7] ; $len
  push d
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; strcpy(sp, *(char **)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; sp = sp + len; 
  lea d, [bp + -5] ; $sp
  push d
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $len
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
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
  jmp _switch54_exit ; case break
_switch54_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s11 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch54_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if53_exit
_if53_else:
; *sp++ = *format_p++; 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -5] ; $sp
  mov [d], b
  dec b
  push b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_if53_exit:
_if52_exit:
_for51_update:
  jmp _for51_cond
_for51_exit:
; *sp = '\0'; 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return sp - dest; // return total number of chars written 
  lea d, [bp + -5] ; $sp
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
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

printx32:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d+2]
  call print_u16x
  mov b, [d]
  call print_u16x
; --- END INLINE ASM SEGMENT

  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d]
  call print_u16x
; --- END INLINE ASM SEGMENT

  leave
  ret

printx8:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov bl, [d]
  call print_u8x
; --- END INLINE ASM SEGMENT

  leave
  ret

hex_str_to_int:
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
_for58_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for58_cond:
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
  je _for58_exit
_for58_block:
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
_if59_cond:
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
  je _if59_else
_if59_TRUE:
; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov32 cb, $00000010
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
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
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if59_exit
_if59_else:
; if (hex_char >= 'A' && hex_char <= 'F')  
_if60_cond:
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
  je _if60_else
_if60_TRUE:
; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov32 cb, $00000010
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
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
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if60_exit
_if60_else:
; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov32 cb, $00000010
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
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
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_if60_exit:
_if59_exit:
_for58_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for58_cond
_for58_exit:
; return value; 
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
  leave
  ret

gets:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _gets
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
_if61_cond:
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
  je _if61_else
_if61_TRUE:
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
  jmp _if61_exit
_if61_else:
; if (num == 0) { 
_if62_cond:
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
  je _if62_exit
_if62_TRUE:
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
  jmp _if62_exit
_if62_exit:
_if61_exit:
; while (num > 0) { 
_while63_cond:
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
  je _while63_exit
_while63_block:
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
  mov a, b
  mov32 cb, $0000000a
  div a, b ; 
  mov a, b
  mov b, a
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
  mov a, b
  mov32 cb, $0000000a
  div a, b
  mov b, a
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
  jmp _while63_cond
_while63_exit:
; while (i > 0) { 
_while64_cond:
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
  je _while64_exit
_while64_block:
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
  jmp _while64_cond
_while64_exit:
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
_if65_cond:
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
  je _if65_else
_if65_TRUE:
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
  mov b, 0
  mov [d + 2], b
  jmp _if65_exit
_if65_else:
; if (num == 0) { 
_if66_cond:
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
  je _if66_exit
_if66_TRUE:
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
  jmp _if66_exit
_if66_exit:
_if65_exit:
; while (num > 0) { 
_while67_cond:
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
  je _while67_exit
_while67_block:
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
  mov a, b
  mov32 cb, $0000000a
  div a, b ; 
  mov a, b
  mov b, a
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
  mov a, b
  mov32 cb, $0000000a
  div a, b
  mov b, a
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
  jmp _while67_cond
_while67_exit:
; while (i > 0) { 
_while68_cond:
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
  je _while68_exit
_while68_block:
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
  jmp _while68_cond
_while68_exit:
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
_if69_cond:
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
  je _if69_exit
_if69_TRUE:
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
  jmp _if69_exit
_if69_exit:
; while (num > 0) { 
_while70_cond:
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
  je _while70_exit
_while70_block:
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
  mov a, b
  mov32 cb, $0000000a
  div a, b ; 
  mov a, b
  mov b, a
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
  mov a, b
  mov32 cb, $0000000a
  div a, b
  mov b, a
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
  jmp _while70_cond
_while70_exit:
; while (i > 0) { 
_while71_cond:
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
  je _while71_exit
_while71_block:
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
  jmp _while71_cond
_while71_exit:
  leave
  ret

sprint_unsigned:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i; 
  sub sp, 2
; int len = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -8] ; $len
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; if(num == 0){ 
_if72_cond:
  lea d, [bp + 7] ; $num
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
  je _if72_exit
_if72_TRUE:
; *dest++ = '0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  mov32 cb, $00000030
  pop d
  mov [d], bl
; return 1; 
  mov32 cb, $00000001
  leave
  ret
  jmp _if72_exit
_if72_exit:
; while (num > 0) { 
_while73_cond:
  lea d, [bp + 7] ; $num
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
  je _while73_exit
_while73_block:
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
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov32 cb, $0000000a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 7] ; $num
  push d
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov32 cb, $0000000a
  div a, b
  mov b, a
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
  jmp _while73_cond
_while73_exit:
; while (i > 0) { 
_while74_cond:
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
  je _while74_exit
_while74_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
; *dest++ = digits[i]; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
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
  pop d
  mov [d], bl
; len++; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -8] ; $len
  mov [d], b
  mov b, a
  jmp _while74_cond
_while74_exit:
; *dest = '\0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return len; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
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
_if75_cond:
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
  je _if75_exit
_if75_TRUE:
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
  jmp _if75_exit
_if75_exit:
; while (num > 0) { 
_while76_cond:
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
  je _while76_exit
_while76_block:
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
  mov a, b
  mov32 cb, $0000000a
  div a, b ; 
  mov a, b
  mov b, a
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
  mov a, b
  mov32 cb, $0000000a
  div a, b
  mov b, a
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
  jmp _while76_cond
_while76_exit:
; while (i > 0) { 
_while77_cond:
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
  je _while77_exit
_while77_block:
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
  jmp _while77_cond
_while77_exit:
  leave
  ret

sprint_signed:
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
; int len = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -8] ; $len
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if78_cond:
  lea d, [bp + 7] ; $num
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
  je _if78_else
_if78_TRUE:
; *dest++ = '-'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  mov32 cb, $0000002d
  pop d
  mov [d], bl
; num = -num; 
  lea d, [bp + 7] ; $num
  push d
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
  neg b
  pop d
  mov [d], b
; len++; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -8] ; $len
  mov [d], b
  mov b, a
  jmp _if78_exit
_if78_else:
; if (num == 0) { 
_if79_cond:
  lea d, [bp + 7] ; $num
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
  je _if79_exit
_if79_TRUE:
; *dest++ = '0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
  mov32 cb, $00000030
  pop d
  mov [d], bl
; *dest = '\0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return 1; 
  mov32 cb, $00000001
  leave
  ret
  jmp _if79_exit
_if79_exit:
_if78_exit:
; while (num > 0) { 
_while80_cond:
  lea d, [bp + 7] ; $num
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
  je _while80_exit
_while80_block:
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
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov32 cb, $0000000a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 7] ; $num
  push d
  lea d, [bp + 7] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  mov a, b
  mov32 cb, $0000000a
  div a, b
  mov b, a
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
  jmp _while80_cond
_while80_exit:
; while (i > 0) { 
_while81_cond:
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
  je _while81_exit
_while81_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
; *dest++ = digits[i]; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $dest
  mov [d], b
  dec b
  push b
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
  pop d
  mov [d], bl
; len++; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -8] ; $len
  mov [d], b
  mov b, a
  jmp _while81_cond
_while81_exit:
; *dest = '\0'; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return len; 
  lea d, [bp + -8] ; $len
  mov b, [d]
  mov c, 0
  leave
  ret

date:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  mov al, 0 
  syscall sys_datetime
; --- END INLINE ASM SEGMENT

  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM SEGMENT

  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
; char c; 
  sub sp, 1

; --- BEGIN INLINE ASM SEGMENT
  call getch
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

scann:
  enter 0 ; (push bp; mov bp, sp)
; int m; 
  sub sp, 2

; --- BEGIN INLINE ASM SEGMENT
  call scan_u16d
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM SEGMENT

; return m; 
  lea d, [bp + -1] ; $m
  mov b, [d]
  mov c, 0
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _puts
  mov a, $0A00
  syscall sys_io
; --- END INLINE ASM SEGMENT

  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
  call _puts
; --- END INLINE ASM SEGMENT

  leave
  ret

getparam:
  enter 0 ; (push bp; mov bp, sp)
; char data; 
  sub sp, 1

; --- BEGIN INLINE ASM SEGMENT
  mov al, 4
  lea d, [bp + 5] ; $address
  mov d, [d]
  syscall sys_system
  lea d, [bp + 0] ; $data
  mov [d], bl
; --- END INLINE ASM SEGMENT

; return data; 
  lea d, [bp + 0] ; $data
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret

clear:
  enter 0 ; (push bp; mov bp, sp)
; print("\033[2J\033[H"); 
; --- START FUNCTION CALL
  mov b, _s12 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
; return i < 0 ? -i : i; 
_ternary82_cond:
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
  je _ternary82_FALSE
_ternary82_TRUE:
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
  neg b
  jmp _ternary82_exit
_ternary82_FALSE:
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
_ternary82_exit:
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

create_file:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

delete_file:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $filename
  mov al, 10
  syscall sys_filesystem
; --- END INLINE ASM SEGMENT

  leave
  ret

load_hex:
  enter 0 ; (push bp; mov bp, sp)
; char *temp; 
  sub sp, 2
; temp = alloc(32768); 
  lea d, [bp + -1] ; $temp
  push d
; --- START FUNCTION CALL
  mov32 cb, $00008000
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b

; --- BEGIN INLINE ASM SEGMENT
  
  
  
_load_hex:
  lea d, [bp + 5] ; $destination
  mov d, [d]
  mov di, d
  lea d, [bp + -1] ; $temp
  mov d, [d]
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
; --- END INLINE ASM SEGMENT

  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
.include "lib/asm/stdio.asm"
; --- END INLINE ASM SEGMENT

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
_while83_cond:
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
  je _while83_exit
_while83_block:
; prog--; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  dec b
  mov d, _prog ; $prog
  mov [d], b
  inc b
  jmp _while83_cond
_while83_exit:
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
_while84_cond:
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
  je _while84_exit
_while84_block:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while84_cond
_while84_exit:
; if(*prog == '\0'){ 
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
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if85_exit
_if85_TRUE:
; return; 
  leave
  ret
  jmp _if85_exit
_if85_exit:
; while( 
_while86_cond:
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
  je _while86_exit
_while86_block:
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
  jmp _while86_cond
_while86_exit:
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
_while87_cond:
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
  je _while87_exit
_while87_block:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while87_cond
_while87_exit:
; if(*prog == '\0'){ 
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
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if88_exit
_if88_TRUE:
; toktype = END; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $6 ; enum element: END
  pop d
  mov [d], b
; return; 
  leave
  ret
  jmp _if88_exit
_if88_exit:
; if(is_digit(*prog)){ 
_if89_cond:
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
  je _if89_else
_if89_TRUE:
; while(is_digit(*prog)){ 
_while90_cond:
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
  je _while90_exit
_while90_block:
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
  jmp _while90_cond
_while90_exit:
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
  jmp _if89_exit
_if89_else:
; if(is_alpha(*prog)){ 
_if91_cond:
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
  je _if91_else
_if91_TRUE:
; while(is_alpha(*prog) || is_digit(*prog)){ 
_while92_cond:
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
  je _while92_exit
_while92_block:
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
  jmp _while92_cond
_while92_exit:
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
  jmp _if91_exit
_if91_else:
; if(*prog == '\"'){ 
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
  mov32 cb, $00000022
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if93_else
_if93_TRUE:
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
_while94_cond:
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
  je _while94_exit
_while94_block:
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
  jmp _while94_cond
_while94_exit:
; if(*prog != '\"') error("Double quotes expected"); 
_if95_cond:
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
  je _if95_exit
_if95_TRUE:
; error("Double quotes expected"); 
; --- START FUNCTION CALL
  mov b, _s13 ; "Double quotes expected"
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if95_exit
_if95_exit:
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
  jmp _if93_exit
_if93_else:
; if(*prog == '#'){ 
_if96_cond:
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
  je _if96_else
_if96_TRUE:
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
  jmp _if96_exit
_if96_else:
; if(*prog == '{'){ 
_if97_cond:
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
  je _if97_else
_if97_TRUE:
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
  jmp _if97_exit
_if97_else:
; if(*prog == '}'){ 
_if98_cond:
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
  je _if98_else
_if98_TRUE:
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
  jmp _if98_exit
_if98_else:
; if(*prog == '['){ 
_if99_cond:
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
  je _if99_else
_if99_TRUE:
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
  jmp _if99_exit
_if99_else:
; if(*prog == ']'){ 
_if100_cond:
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
  je _if100_else
_if100_TRUE:
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
  jmp _if100_exit
_if100_else:
; if(*prog == '='){ 
_if101_cond:
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
  je _if101_else
_if101_TRUE:
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
_if102_cond:
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
  je _if102_else
_if102_TRUE:
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
  jmp _if102_exit
_if102_else:
; tok = ASSIGNMENT; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $11 ; enum element: ASSIGNMENT
  pop d
  mov [d], b
_if102_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if101_exit
_if101_else:
; if(*prog == '&'){ 
_if103_cond:
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
  je _if103_else
_if103_TRUE:
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
_if104_cond:
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
  je _if104_else
_if104_TRUE:
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
  jmp _if104_exit
_if104_else:
; tok = AMPERSAND; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $16 ; enum element: AMPERSAND
  pop d
  mov [d], b
_if104_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if103_exit
_if103_else:
; if(*prog == '|'){ 
_if105_cond:
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
  je _if105_else
_if105_TRUE:
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
_if106_cond:
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
  je _if106_else
_if106_TRUE:
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
  jmp _if106_exit
_if106_else:
; tok = BITWISE_OR; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $18 ; enum element: BITWISE_OR
  pop d
  mov [d], b
_if106_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if105_exit
_if105_else:
; if(*prog == '~'){ 
_if107_cond:
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
  je _if107_else
_if107_TRUE:
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
  jmp _if107_exit
_if107_else:
; if(*prog == '<'){ 
_if108_cond:
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
  je _if108_else
_if108_TRUE:
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
_if109_cond:
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
  je _if109_else
_if109_TRUE:
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
  jmp _if109_exit
_if109_else:
; if (*prog == '<'){ 
_if110_cond:
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
  je _if110_else
_if110_TRUE:
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
  jmp _if110_exit
_if110_else:
; tok = LESS_THAN; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $a ; enum element: LESS_THAN
  pop d
  mov [d], b
_if110_exit:
_if109_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if108_exit
_if108_else:
; if(*prog == '>'){ 
_if111_cond:
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
  je _if111_else
_if111_TRUE:
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
_if112_cond:
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
  je _if112_else
_if112_TRUE:
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
  jmp _if112_exit
_if112_else:
; if (*prog == '>'){ 
_if113_cond:
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
  je _if113_else
_if113_TRUE:
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
  jmp _if113_exit
_if113_else:
; tok = GREATER_THAN; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $c ; enum element: GREATER_THAN
  pop d
  mov [d], b
_if113_exit:
_if112_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if111_exit
_if111_else:
; if(*prog == '!'){ 
_if114_cond:
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
  je _if114_else
_if114_TRUE:
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
_if115_cond:
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
  je _if115_else
_if115_TRUE:
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
  jmp _if115_exit
_if115_else:
; tok = LOGICAL_NOT; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $10 ; enum element: LOGICAL_NOT
  pop d
  mov [d], b
_if115_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if114_exit
_if114_else:
; if(*prog == '+'){ 
_if116_cond:
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
  je _if116_else
_if116_TRUE:
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
_if117_cond:
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
  je _if117_else
_if117_TRUE:
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
  jmp _if117_exit
_if117_else:
; tok = PLUS; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $1 ; enum element: PLUS
  pop d
  mov [d], b
_if117_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if116_exit
_if116_else:
; if(*prog == '-'){ 
_if118_cond:
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
  je _if118_else
_if118_TRUE:
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
_if119_cond:
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
  je _if119_else
_if119_TRUE:
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
  jmp _if119_exit
_if119_else:
; tok = MINUS; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $2 ; enum element: MINUS
  pop d
  mov [d], b
_if119_exit:
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if118_exit
_if118_else:
; if(*prog == '$'){ 
_if120_cond:
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
  je _if120_else
_if120_TRUE:
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
  jmp _if120_exit
_if120_else:
; if(*prog == '^'){ 
_if121_cond:
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
  je _if121_else
_if121_TRUE:
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
  jmp _if121_exit
_if121_else:
; if(*prog == '@'){ 
_if122_cond:
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
  je _if122_else
_if122_TRUE:
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
  jmp _if122_exit
_if122_else:
; if(*prog == '*'){ 
_if123_cond:
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
  je _if123_else
_if123_TRUE:
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
  jmp _if123_exit
_if123_else:
; if(*prog == '/'){ 
_if124_cond:
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
  je _if124_else
_if124_TRUE:
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
  jmp _if124_exit
_if124_else:
; if(*prog == '%'){ 
_if125_cond:
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
  je _if125_else
_if125_TRUE:
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
  jmp _if125_exit
_if125_else:
; if(*prog == '('){ 
_if126_cond:
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
  je _if126_else
_if126_TRUE:
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
  jmp _if126_exit
_if126_else:
; if(*prog == ')'){ 
_if127_cond:
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
  je _if127_else
_if127_TRUE:
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
  jmp _if127_exit
_if127_else:
; if(*prog == ';'){ 
_if128_cond:
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
  je _if128_else
_if128_TRUE:
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
  jmp _if128_exit
_if128_else:
; if(*prog == ':'){ 
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
  mov32 cb, $0000003a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if129_else
_if129_TRUE:
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
  jmp _if129_exit
_if129_else:
; if(*prog == ','){ 
_if130_cond:
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
  je _if130_else
_if130_TRUE:
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
  jmp _if130_exit
_if130_else:
; if(*prog == '.'){ 
_if131_cond:
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
  je _if131_exit
_if131_TRUE:
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
  jmp _if131_exit
_if131_exit:
_if130_exit:
_if129_exit:
_if128_exit:
_if127_exit:
_if126_exit:
_if125_exit:
_if124_exit:
_if123_exit:
_if122_exit:
_if121_exit:
_if120_exit:
_if118_exit:
_if116_exit:
_if114_exit:
_if111_exit:
_if108_exit:
_if107_exit:
_if105_exit:
_if103_exit:
_if101_exit:
_if100_exit:
_if99_exit:
_if98_exit:
_if97_exit:
_if96_exit:
_if93_exit:
_if91_exit:
_if89_exit:
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
_if132_cond:
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
  je _if132_else
_if132_TRUE:
; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; if(*t == '\\'){ 
_if133_cond:
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
  je _if133_else
_if133_TRUE:
; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; switch(*t){ 
_switch134_expr:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch134_comparisons:
  cmp bl, $30
  je _switch134_case0
  cmp bl, $61
  je _switch134_case1
  cmp bl, $62
  je _switch134_case2
  cmp bl, $66
  je _switch134_case3
  cmp bl, $6e
  je _switch134_case4
  cmp bl, $72
  je _switch134_case5
  cmp bl, $74
  je _switch134_case6
  cmp bl, $76
  je _switch134_case7
  cmp bl, $5c
  je _switch134_case8
  cmp bl, $27
  je _switch134_case9
  cmp bl, $22
  je _switch134_case10
  jmp _switch134_exit
_switch134_case0:
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
  jmp _switch134_exit ; case break
_switch134_case1:
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
  jmp _switch134_exit ; case break
_switch134_case2:
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
  jmp _switch134_exit ; case break
_switch134_case3:
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
  jmp _switch134_exit ; case break
_switch134_case4:
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
  jmp _switch134_exit ; case break
_switch134_case5:
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
  jmp _switch134_exit ; case break
_switch134_case6:
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
  jmp _switch134_exit ; case break
_switch134_case7:
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
  jmp _switch134_exit ; case break
_switch134_case8:
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
  jmp _switch134_exit ; case break
_switch134_case9:
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
  jmp _switch134_exit ; case break
_switch134_case10:
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
_switch134_exit:
  jmp _if133_exit
_if133_else:
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
_if133_exit:
  jmp _if132_exit
_if132_else:
; if(toktype == STRING_CONST){ 
_if135_cond:
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
  je _if135_exit
_if135_TRUE:
; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; while(*t != '\"' && *t){ 
_while136_cond:
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
  je _while136_exit
_while136_block:
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
  jmp _while136_cond
_while136_exit:
  jmp _if135_exit
_if135_exit:
_if132_exit:
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
; printf("\nError: "); 
; --- START FUNCTION CALL
  mov b, _s14 ; "\nError: "
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
  mov b, _s15 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

last_cmd_insert:
  enter 0 ; (push bp; mov bp, sp)
; if(last_cmd[0]){ 
_if137_cond:
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
  je _if137_exit
_if137_TRUE:
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
  jmp _if137_exit
_if137_exit:
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
_for138_init:
  lea d, [bp + -1] ; $var_index
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for138_cond:
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
  je _for138_exit
_for138_block:
; if(!strcmp(variables[var_index].varname, varname)){ 
_if139_cond:
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
  je _if139_exit
_if139_TRUE:
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
  jmp _if139_exit
_if139_exit:
_for138_update:
  lea d, [bp + -1] ; $var_index
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $var_index
  mov [d], b
  mov b, a
  jmp _for138_cond
_for138_exit:
; printf("Error: Variable does not exist."); 
; --- START FUNCTION CALL
  mov b, _s16 ; "Error: Variable does not exist."
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
_for140_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for140_cond:
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
  je _for140_exit
_for140_block:
; if(!strcmp(variables[i].varname, varname)){ 
_if141_cond:
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
  je _if141_exit
_if141_TRUE:
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
  jmp _if141_exit
_if141_exit:
_for140_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for140_cond
_for140_exit:
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
_for142_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for142_cond:
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
  je _for142_exit
_for142_block:
; if(!strcmp(variables[i].varname, varname)) return i; 
_if143_cond:
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
  je _if143_exit
_if143_TRUE:
; return i; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if143_exit
_if143_exit:
_for142_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for142_cond
_for142_exit:
; return -1; 
  mov32 cb, $00000001
  neg b
  leave
  ret

get_var_type:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < vars_tos; i++) 
_for144_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for144_cond:
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
  je _for144_exit
_for144_block:
; if(!strcmp(variables[i].varname, varname)) return variables[i].var_type; 
_if145_cond:
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
  je _if145_exit
_if145_TRUE:
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
  jmp _if145_exit
_if145_exit:
_for144_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for144_cond
_for144_exit:
; return -1; 
  mov32 cb, $00000001
  neg b
  leave
  ret

show_var:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < vars_tos; i++){ 
_for146_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for146_cond:
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
  je _for146_exit
_for146_block:
; if(!strcmp(variables[i].varname, varname)){ 
_if147_cond:
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
  je _if147_exit
_if147_TRUE:
; if(variables[i].var_type == SHELL_VAR_TYP_INT){ 
_if148_cond:
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
  je _if148_else
_if148_TRUE:
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
  mov b, _s17 ; "%d"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if148_exit
_if148_else:
; if(variables[i].var_type == SHELL_VAR_TYP_STR){ 
_if149_cond:
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
  je _if149_exit
_if149_TRUE:
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
  jmp _if149_exit
_if149_exit:
_if148_exit:
; return i; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if147_exit
_if147_exit:
_for146_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for146_cond
_for146_exit:
; error("Undeclared variable."); 
; --- START FUNCTION CALL
  mov b, _s18 ; "Undeclared variable."
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
_if150_cond:
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
  je _if150_else
_if150_TRUE:
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
  jmp _if150_exit
_if150_else:
; for(;;){ 
_for151_init:
_for151_cond:
_for151_block:
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
_if152_cond:
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
  je _if152_else
_if152_TRUE:
; break; 
  jmp _for151_exit ; for break
  jmp _if152_exit
_if152_else:
; if(tok == SEMICOLON){ 
_if153_cond:
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
  je _if153_exit
_if153_TRUE:
; back(); 
; --- START FUNCTION CALL
  call back
; break; 
  jmp _for151_exit ; for break
  jmp _if153_exit
_if153_exit:
_if152_exit:
_for151_update:
  jmp _for151_cond
_for151_exit:
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
_if150_exit:
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
  syscall sys_filesystem 
  lea d, [bp + -1] ; $dirID
  mov d, [d]
  mov [d], a 
  push a
; --- END INLINE ASM SEGMENT

; if(dirID != -1){ 
_if154_cond:
  lea d, [bp + -1] ; $dirID
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  neg b
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if154_else
_if154_TRUE:

; --- BEGIN INLINE ASM SEGMENT
  pop a
  mov b, a
  mov al, 3
  syscall sys_filesystem
; --- END INLINE ASM SEGMENT

  jmp _if154_exit
_if154_else:

; --- BEGIN INLINE ASM SEGMENT
  pop a
; --- END INLINE ASM SEGMENT

_if154_exit:
  leave
  ret

print_cwd:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM SEGMENT
  mov al, 18
  syscall sys_filesystem        
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
_for155_init:
_for155_cond:
_for155_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if156_cond:
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
  je _if156_exit
_if156_TRUE:
; break; 
  jmp _for155_exit ; for break
  jmp _if156_exit
_if156_exit:
; if(!strcmp(entry_name, token)){ 
_if157_cond:
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
  je _if157_exit
_if157_TRUE:
; get(); // get '=' 
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for158_init:
_for158_cond:
_for158_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(!strcmp(token, ";")) return; 
_if159_cond:
; --- START FUNCTION CALL
  mov b, _s19 ; ";"
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
  je _if159_exit
_if159_TRUE:
; return; 
  leave
  ret
  jmp _if159_exit
_if159_exit:
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
_for158_update:
  jmp _for158_cond
_for158_exit:
  jmp _if157_exit
_if157_exit:
_for155_update:
  jmp _for155_cond
_for155_exit:
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
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
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
st_fopen_max_handle: .dw 0
_s0: .db "path", 0
_s1: .db "home", 0
_s2: .db "/etc/shell.cfg", 0
_s3: .db "root@Sol-1:", 0
_s4: .db " # ", 0
_s5: .db "\n\r", 0
_s6: .db "cd", 0
_s7: .db "shell", 0
_s8: .db "123", 0
_s9: .db "/", 0
_s10: .db "Unexpected format in printf.", 0
_s11: .db "Error: Unknown argument type.\n", 0
_s12: .db "\033[2J\033[H", 0
_s13: .db "Double quotes expected", 0
_s14: .db "\nError: ", 0
_s15: .db "\n", 0
_s16: .db "Error: Variable does not exist.", 0
_s17: .db "%d", 0
_s18: .db "Undeclared variable.", 0
_s19: .db ";", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
