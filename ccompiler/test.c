#include <stdio.h>

struct t_shell_var{
  char varname[64];
  char var_type;
  char as_string[64];
  int as_int;
} variables[10];


// error: var_type is a char and is being pushed into printf as a one byte, but printf is printing 2 bytes and incrementing pointer by 2 hence error
void main(void){
	strcpy(variables[0].varname, "Sol-1.");
	strcpy(variables[0].as_string, "String Value.");
	variables[0].var_type = 5;
	variables[0].as_int = 123;

	printf("\nvarname: %s", variables[0].varname);

	printf("\nvar_type: %d\n", variables[0].var_type);
	
	printf("\nas_string: %s\n",	variables[0].as_string);

	printf("\nas_int: %d\n", variables[0].as_int);
}