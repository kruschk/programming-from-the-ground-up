#PURPOSE:	Simple program that exits and returns a status code back to
#		the linux kernel
#

#INPUT:		none
#

#OUTPUT:	returns a status code. This can be viewed by typing
#
#		echo $?
#
#		after running the program.
#

# Variables:
#		%eax holds the system call number
#		%ebx holds the return status.
#
.section .data

.section .text
.globl _start
_start:
movl $1, %eax	# this is the linux kernel command number (system call)
		# for exiting a program

movl $255, %ebx	# this is the status number we will return to the operating
		# system. Change this around and it will return different
		# things to echo $?

# The following instruction is removed as part of the exercise.
#int $0x80	# this wakes up the kernel to run the exit command.

# Failing to exit the program (with int $0x80) appears to raise a segmentation fault. Segmentation faults usally occur when trying to access a location in memory that you weren't supposed to. I have no idea why this would happen because no further instructions are given; I would expect the program to just hang.
