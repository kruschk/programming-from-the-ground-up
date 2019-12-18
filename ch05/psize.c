#include <stdio.h>

int main(int argc, char *argv[]) {
	printf("%lu, %lu, %lu\n", sizeof(char *), argv[0], argv[1]);
	return 0;
}
