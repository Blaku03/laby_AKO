#include <stdio.h>

unsigned char iteracja(unsigned char a);

int main() {
	char w = iteracja(32);

	printf("%uc", &w);
	return 0;
}
