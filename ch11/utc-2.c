/* This is an implementation of the maximum.s program written in "Programming
 * from the Ground Up".
 * In this first line, the C preprocessor replaces the #include statement with the
 * entire stdio.h header file text. This allows us to use the functions defined
 * there.
 */
#include <stdio.h>

/* Here, the program entry point is defined (the main function) and the
 * argument count variable and argument vector are given names that they can be
 * easily accessed by.
 */
int main(int argc, char **argv) {
	/* An array of unsigned integers is allocated here. This may be
	 * implemented in assembly like so:
	 * data_items:
	 * 	.long 3,67,34,222,45,75,54,34,44,33,22,11,6
	 */
	const unsigned int data_items[] = {3,67,34,222,45,75,54,34,44,33,22,11,6};

	/* This defines a variable name, largest, and initializes it to the
	 * first element in the data_items array.
	 */
	int largest = data_items[0];
	/* This sets up a loop that will begin at counter variable i = 1, and
	 * go all the way to the end of the array, incrementing i with each
	 * iteration. This is a relatively complex procedure in assembly, but
	 * it is done very easily in C!
	 */
	for (size_t i = 1; i < (sizeof data_items)/(sizeof(data_items[i])); i++) {
		/* Define a variable named "current". On each iteration, set it
		 * to the value of data_items at the index defined by i.
		 */
		int current = data_items[i];
		/* Prints the current value. This can be done with a system
		 * call, but requires a fair amount of overhead to set up the
		 * buffer that gets written, due to the formatting.
		 */
		printf("current: %d\n", current);
		/* If the current value is larger than the largest value, set
		 * the largest value to the current value.
		 */
		if (current > largest) {
			largest = current;
		}
	}
	/* Prints the current value. This can be done with a system call, but
	 * requires a fair amount of overhead to set up the buffer that gets
	 * written, due to the formatting.
	 */
	printf("largest: %d\n", largest);
	/* Return with the largest value as the status code.
	 */
	return largest;
}
