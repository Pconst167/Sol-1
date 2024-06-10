#include <stdio.h>

int main() {
	printf("GCD: %d", gcd(125, 65535));

    return 0;
}



int gcd(int a, int b) {
    if (b == 0) {
        return a;
    }
    return gcd(b, a % b);
}
