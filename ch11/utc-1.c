/* This is an implementation of the maximum.s program written in "Programming
 * from the Ground Up".
 */
#include <stdio.h>

int main(int argc, char **argv) {
	const int data_items[] = {3,67,34,222,45,75,54,34,44,33,22,11,6};

	int largest = data_items[0];
	for (size_t i = 1; i < (sizeof data_items)/(sizeof(data_items[i])); i++) {
		//printf("current: %d\n", data_items[i]);
		if (largest < data_items[i]) {
			largest = data_items[i];
		}
	}
	printf("largest: %d\n", largest);
	return 0;
}
