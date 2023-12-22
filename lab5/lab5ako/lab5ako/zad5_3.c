#include <stdio.h>
void sumy_elementow(char* liczby_A, char* liczby_B, char* wynik, int count);

#define n 16

int main() {
	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122,
		-121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3,
		3, 3, 3, 3, 3, 3, 3, 3 };

	char wynik[n];

	sumy_elementow(liczby_A, liczby_B, wynik, n);
	for (int i = 0; i < n; i++) {
		printf("%d ", wynik[i]);
	}

	return 0;
}