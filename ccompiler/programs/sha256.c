#include <stdio.h>

#define BLOCK_SIZE 64  // Simplified block size for the hash function
#define HASH_SIZE 16   // Simplified hash size


char text[512];

int main() {
    unsigned char hash[HASH_SIZE];
    int i;

    do{
        scanf("Enter a string to hash: %s", text);
        if(text[0] == '\0') printf("\nEmpty string.\n");
    } while(text[0] == '\0');

    simple_hash(text, hash);

    printf("Hash: ");
    for (i = 0; i < HASH_SIZE; i++) {
        printx8(hash[i]);
    }
    printf("\n");

    return 0;
}

// Rotates x right by n positions
unsigned int rotr(unsigned int x, unsigned int n) {
    return (x >> n) | (x << (16 - n));
}

// Simple hash function
void simple_hash(const char *input, unsigned char output[HASH_SIZE]) {
    unsigned int h[8];
    unsigned int k[4];
    h[0]=0x6745;
    h[1]=0xEFCD;
    h[2]=0x98AB;
    h[3]=0xCDEF;

    k[0]=0x1234;
    k[1]=0x5678;
    k[2]=0x9ABC;
    k[3]=0xDEF0;

    unsigned int i,j;
        unsigned int val;;
    unsigned int len;
    len = strlen(input);
    for (i = 0; i < len; i++) {
        val = (unsigned char)input[i];
        for (j = 0; j < 4; j++) {
            h[j] = h[j] ^ rotr(val + k[j], j + 1);
            h[j] = h[j] + val;
            h[j] = rotr(h[j], j + 1);
        }
    }

    for (i = 0; i < HASH_SIZE / 2; i++) {
        output[i * 2] = h[i] & 0xFF;
        output[i * 2 + 1] = (h[i] >> 8) & 0xFF;
    }
}
