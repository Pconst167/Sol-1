#include <stdio.h>

char *s = "aGVsbG8gd29ybGQgbXkgbmFtZSBpcyBzb2wtMS4=";
char output[512];

void main(void){
	base64_decode(s, output);

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

  input_len = strlen(input);

  while (input_len-- && (input[k] != '=') && base64_char_value(input[k]) != -1) {
    input_buffer[i++] = input[k++];
    if (i == 4) {
      for (i = 0; i < 4; i++) {
        input_buffer[i] = base64_char_value(input_buffer[i]);
      }
      output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4);
      output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2);
      output_buffer[2] = ((input_buffer[2] & 0x03) << 6) + input_buffer[3];

      for (i = 0; i < 3; i++) {
        output[j++] = output_buffer[i];
      }
      i = 0;
    }
  }

  if (i) {
    for (k = i; k < 4; k++) {
      input_buffer[k] = 0;
    }

    for (k = 0; k < 4; k++) {
      input_buffer[k] = base64_char_value(input_buffer[k]);
    }

    output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4);
    output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2);

    for (k = 0; k < i - 1; k++) {
      output[j++] = output_buffer[k];
    }
  }
  output[j] = '\0';
}
