#include <stdio.h>
#include <math.h>

unsigned int top;

void main(void){
	unsigned int N, i;

	printf("Enter a number to find all prime numbers up to it: ");
	N = scann();

	print("Prime numbers are: \n");
	for (i = 2; i <= N; i++) {
			if (isPrime(i)) {
					printu(i);
					print("\n");
			}
	}

	return 0;
}

void primes1(void){
	unsigned int n, i, s, count, divides;

	n = 2;
	while(n < top){
		s = sqrt(n);
		divides = 0;

		i = 2;
		while(i <= s){
			if(n % i == 0){
				divides = 1;
				break;
			}
			i = i + 1;
			if(i >= s) break;
		}
		
		if(divides == 0){
			count = count + 1;	
			printu(n);
			print("\n");
		}
		n = n + 1;
	}
	return;
}

char isPrime(unsigned int num) {
	unsigned int i;

	if (num <= 1) return 0;
	for (i = 2; i * i <= num; i++) {
			if (num % i == 0) return 0;
	}
	return 1;
}


