#include <stdio.h>
#include <xmmintrin.h>

void dziel(__m128* tablica1, unsigned int n, float dzielnik);

int main() {
	__m128 tablica[2];
	tablica[0].m128_f32[0] = 5.0;
	tablica[0].m128_f32[1] = 2.0;
	tablica[0].m128_f32[2] = 4.0;
	tablica[0].m128_f32[3] = 8.0;

	tablica[1].m128_f32[0] = 9.0;
	tablica[1].m128_f32[1] = 111.0;
	tablica[1].m128_f32[2] = 6.0;
	tablica[1].m128_f32[3] = 7.0;
	unsigned int n = 2;

	dziel(tablica, n, 2.0f);

	for (int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			printf("%f\n", tablica[i].m128_f32[j]);
		}
	}

	return 0;
}