# PURPOSE:	Given a number, this program computes the factorial. For
#		example, the factorial of 3 is 3 * 2 * 1, or 6. The
#		factorial of 4 is 4 * 3 * 2 * 1, or 24, and so on.
#

# This program is a modification of the recursive factorial function seen
# previously, it simply uses iteration instead of recursion.

.section .data

# This program has no global data

.section .text

.globl _start
.globl fatorial # this is unneeded unless we want to share this function
		# with other programs.

_start:
	pushq	$5		# The factorial takes one argument - the
				# number we want a factorial of. So, it
				# gets pushed.
	call	factorial	# run the factorial function
	addq	$8, %rsp	# Scrubs the parameter that was pushed on
				# the stack
	movq	$1, %rax	# call the kernel's exit function
	int	$0x80

# PURPOSE:	This function computes the factorial of a number.
#
# INPUT:	A positive integer.
#
# OUTPUT:	The factorial of the input (e.g. 4! = 4*3*2*1 = 24).
#
# NOTES:	Nothing too special.
#
# VARIABLES:
#	%rax - serves as multiplier and iteration counter
#	%rbx - holds the results of intermediate calculations and the final
#	       result (when looping has completed)
#

.type factorial, @function

factorial:
	pushq	%rbp		# standard function stuff - we have to
				# restore %rbp to its prior state before
				# returning, so we have to push it
	movq	%rsp, %rbp	# This is because we don't want to modify
				# the stack pointer, so we use %rbp.

	movq	16(%rbp), %rbx	# move the input value into %rbx
	movq	%rbx, %rax	# and copy it into %rax as well

factorial_loop:
	cmpq	$1, %rax	# check if the input was 1
	jle	end_factorial	# return the input value if that was the case

	decq	%rax		# decrement %rax
	imulq	%rax, %rbx	# multiply %rax and %rbx, store the result in
				# %rdx:rbx
	jmp	factorial_loop

end_factorial:
	movq	%rbp, %rsp	# standard function return stuff - we have
	popq	%rbp		# to restore %rbp and %rsp to where they
				# were before the function started
	ret			# return to the function (this pops the
				# return value, too)
