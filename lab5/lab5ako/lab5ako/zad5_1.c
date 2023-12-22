#include <stdio.h>

float srednia_harm(float* tablica, unsigned int n);

int main() {
	
	const int n = 5;
	float tablica[5];

	scanf_s("%f %f %f %f %f", &tablica[0], &tablica[1], &tablica[2], &tablica[3], &tablica[4]);
	printf_s("Srednia harmoniczna wynosi: %f", srednia_harm(tablica, n));
	
	return 0;
}
