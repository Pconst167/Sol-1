#include <stdio.h>

char *input = "aGVsbG8gd29ybGQgbXkgbmFtZSBpcyBzb2wtMS4=";
char output[512];
int pass=1;
int section;

void main(void){
	base64_decode(input, output);

	printf("\nResult: %d. Section: %d\n", pass, section);

}

int base64_char_value(char c) {
  if (c >= 'A' && c <= 'Z') return c - 'A';
  if (c >= 'a' && c <= 'z') return c - 'a' + 26;
  if (c >= '0' && c <= '9') return c - '0' + 52;
  if (c == '+') return 62;
  if (c == '/') return 63;
  return -1;
}

void base64_decode(char *input, char *output) {
  int i = 0, j = 0, k = 0;
  int input_len;
  unsigned char input_buffer[4];
  unsigned char output_buffer[3];
	char a;

  input_len = strlen(input);
	printf("Len: %d\n", input_len);

  while (input_len-- && (input[k] != '=') && base64_char_value(input[k]) != -1){
		printf("input_len: %d, i: %d, j: %d, k: %d, input[k]: %c, base64: %d\n",
			input_len, i, j, k, input[k], (int)base64_char_value(input[k]));

		printf("Inside while loop. condition: %d\n", input_len-- && (input[k] != '=') && base64_char_value(input[k]) != -1);
		pass = pass && (input_len-- && (input[k] != '=') && base64_char_value(input[k]) != -1);
		if(!pass){
			section = 0;
			return;
		}

    input_buffer[i++] = input[k++];
    if (i == 4) {
			printf("is i 4? %d\n", i==4);
			pass=pass && i==4;
			if(!pass){
				section = 1;
				return;
			}
      for (i = 0; i < 4; i++) {
				printf("inside first for loop for i=0 to 3. i = %d\n", i);
				a = base64_char_value(input_buffer[i]);
        input_buffer[i] = base64_char_value(input_buffer[i]);
				printf("input_buffer[i] == base64_char_val(input_buffer[i]): %d\n", input_buffer[i] == a);
				pass=pass && input_buffer[i] == a;
				if(!pass){
					section = 2;
					return;
				}
      }

      for (i = 0; i < 3; i++) {
				printf("inside second for loop for i=0 to 2. i = %d\n", i);
        output[j++] = output_buffer[i];
				printf("output[j] == output_buffer[i]: %d\n", output[j+-1] == output_buffer[i]);
				pass=pass && output[j+-1] == output_buffer[i];
				if(!pass){
					section = 3;
					return;
				}
      }
      i = 0;
    }
  }

  if (i) {
		pass=pass && i;
		if(!pass){
			section = 4;
			return;
		}
    for (k = i; k < 4; k++) {
      input_buffer[k] = 0;
			pass=pass && input_buffer[k]==0;
			if(!pass){
				section = 5;
				return;
			}
    }

    for (k = 0; k < 4; k++) {
      a = base64_char_value(input_buffer[k]);
      input_buffer[k] = base64_char_value(input_buffer[k]);
			pass=pass && input_buffer[k] == a;
			if(!pass){
				section = 6;
				return;
			}
    }

    output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4);
    output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2);

    for (k = 0; k < i - 1; k++) {
      output[j++] = output_buffer[k];
			pass=pass && output[j+-1] == output_buffer[k];
			if(!pass){
				section = 7;
				return;
			}
    }
  }
  output[j] = '\0';
}
