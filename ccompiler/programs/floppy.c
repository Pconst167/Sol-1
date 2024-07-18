#include <stdio.h>


int main(){

}

/*
During the Command or Result phases, the Main
Status Register must be read by the processor
before each byte of information is written into or
read from the Data Register. After each byte of
data is read from or written into the Data Register,
the CPU waits for 12us before reading the Main
Status Register. BitsD6 and D7 in the Main
Status Register must be in a 0 and 1 state,
respectively, before each byte of the command
word may be written into the WD37C65C. Many of
the commands require multiple bytes. As a result,
the Main Status Register must be read prior to
each byte transfer to the WD37C65C. During the
Result phase, Bits D6 and D7 in the Main Status
Register must both be 1's (D6=1 and D!=1)
before reading each byte from the Data Register.
Note that this reading of the Main Status Register
before each byte transfer to the WD37C65C is
required only in the Command and Result
phases, and not during the Execution phase.

*/