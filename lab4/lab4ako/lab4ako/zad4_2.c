#include <stdio.h>
void plus_jeden(int* a);
void przeciwna(int* x);

int main(){
//	int m;
//	m = -5;
//	plus_jeden(&m);
//	printf("\n m = %d\n", m);
	int x = -3;
	przeciwna(&x);
	printf("\n x = %d\n", x);
	return 0;
}