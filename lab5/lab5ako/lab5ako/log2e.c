#include <stdio.h>

float power_e(int power);

int main() {
	
	int power;
	scanf_s("%d", &power);
	printf("E to the power of %d is %f",power, power_e(power));
	
	return 0;
}
