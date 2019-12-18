# PURPOSE:	Write a function called square which receives one argument and
#		returns the square of that argument.
#		Write a program to test your square function.

.section .data

.section .text

.globl _start
.globl square

_start:
	pushq	$9		# push the input argument onto the stack
	call	square
	addq	$8, %rsp	# move the stack pointer back (this
				# essentially deletes the input value)

	movq	$1, %rax	# exit
	int	$0x80
