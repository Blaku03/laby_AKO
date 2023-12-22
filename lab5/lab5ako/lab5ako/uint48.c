#include <stdio.h>

typedef long long int UINT48;

float uint48_float(UINT48 p);

int main() {
	UINT48 p = 0x0000000B4000; //11.25 w uint48
//	UINT48 p = 0x0000000AB000; //okolo 10.69
	
	printf("%f", uint48_float(p));

	return 0;
}