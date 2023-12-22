#include <stdio.h>

float nowy_exp(float x);

int main() {
	
	float x;
	scanf_s("%f",&x);
	printf_s("Exponent wynosi: %f", nowy_exp(x));
	
	return 0;
}
