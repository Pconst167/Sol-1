#include <stdio.h>
#include <math.h>

unsigned int top;

void main(void){
	print("Max: ");
	top = scann();
	primes();

	return;
}

void primes(void){
	unsigned int n, i, s, count, divides;

	print("entered 1");

	n = 2;
	while(n < top){
	print("entered 2");
		s = sqrt(n);
	print("entered 3");
		divides = 0;

		i = 2;
		while(i <= s){
			if(n % i == 0){
				divides = 1;
				break;
			}
			i = i + 1;
			if(i == n) break;
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

