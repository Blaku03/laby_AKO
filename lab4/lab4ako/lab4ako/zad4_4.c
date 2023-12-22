#include <stdio.h>
void przestaw(int tabl[], int n);

int main()
{
	int tablica[] = { 4,2,1,5,3,1 };
	int n = sizeof(tablica) / sizeof(tablica[0]);

	for (int i = 0; i < n - 1; i++) {
		przestaw(tablica, n - i);
	}

	printf("Posortowana tablica\n");
	for (int i = 0; i < n; i++) {
		printf(" %d,", tablica[i]);
	}
}
