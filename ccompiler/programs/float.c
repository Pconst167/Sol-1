#include <stdio.h>

struct Float16{
    int mantissa;  // 16-bit integer for the mantissa
    char exponent;   // 8-bit integer for the exponent
};

int main() {
    struct Float16 a, b;
    struct Float16 sum;

    a.mantissa = 1234;
    a.exponent = 1 ;
    b.mantissa = 1789;
    b.exponent = 2;

    puts("Starting...\n\r");

    sum = add(a, b);

    puts("Sum mantissa: ");
    prints(sum.mantissa);
    puts("Sum exponent:");
    prints(sum.exponent);


}

struct Float16 add(struct Float16 a, struct Float16 b) {
    // Align exponents
    while (a.exponent < b.exponent) {
        a.mantissa = a.mantissa / 2;
        a.exponent = a.exponent + 1;
        puts("Loop1");
    }
    while (b.exponent < a.exponent) {
        b.mantissa = b.mantissa / 2;
        b.exponent = b.exponent + 1;
        printx8(b.exponent);
        puts("\n\r");
    }

    // Add mantissas
    struct Float16 result;
    result.mantissa = a.mantissa + b.mantissa;
    result.exponent = a.exponent;

    // Normalize result
    while (result.mantissa > 32767 || result.mantissa < -32767) {
        result.mantissa = result.mantissa / 2;
        result.exponent++;
        puts("Loop3");
    }

    return result;
}

struct Float16 subtract(struct Float16 a, struct Float16 b) {
    // Align exponents
    while (a.exponent < b.exponent) {
        a.mantissa = a.mantissa / 2;
        a.exponent++;
    }
    while (b.exponent < a.exponent) {
        b.mantissa = b.mantissa / 2;
        b.exponent++;
    }

    // Subtract mantissas
    struct Float16 result;
    result.mantissa = a.mantissa - b.mantissa;
    result.exponent = a.exponent;

    // Normalize result
    while (result.mantissa > 32767 || result.mantissa < -32767) {
        result.mantissa = result.mantissa / 2;
        result.exponent++;
    }

    return result;
}
