#include <stdio.h>

#define BLOCK_SIZE 64  /* Simplified block size for the hash function */
#define HASH_SIZE 16   // Simplified hash size


char text[512];

int main() {
    unsigned char hash[HASH_SIZE];
    int i;



    printf("Hash: ");
    for (i = 0; i < 16; i++) {
        printx8(hash[i]);
    }
    printf("\n");

    return 0;
}
