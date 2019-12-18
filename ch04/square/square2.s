# PURPOSE:	Write a function called square which receives one argument and
#		returns the square of that argument.
#		This function is used to compute the square of a positive
#		integer.
#
# INPUT:	Only one input is required, the number to square.
#
# OUTPUT:	The square of the input number.
#
# NOTES:	The number must be a positive integer.
#
# VARIABLES:	%rbx - holds the result.
#

.globl square
.type square, @function

square:
	pushq	%rbp		# push the old base pointer onto the stack
	movq	%rsp, %rbp	# save the current base pointer in %rbp

	movq	16(%rbp), %rax	# move the input argument into register
				# %rax
	movq	%rax, %rbx	# copy the input into %rbx as well
	imulq	%rax, %rbx	# multiply the two registers together
				# (result stored in %rdx:rbx?)
	
	movq	%rbp, %rsp	# restore the stack pointer
	popq	%rbp		# restore the old base pointer
	ret
