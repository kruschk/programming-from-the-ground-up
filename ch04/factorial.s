# PURPOSE -	Given a number, this program computes the factorial. For
#		example, the factorial of 3 is 3 * 2 * 1, or 6. The
#		factorial of 4 is 4 * 3 * 2 * 1, or 24, and so on.
#

# This program shows how to call a function recursively.

.section .data

# This program has no global data

.section .text

.globl _start
.globl fatorial # this is unneeded unless we want to share this function
		# with other programs.

_start:
	pushq	$4		# The factorial takes one argument - the
				# number we want a factorial of. So, it
				# gets pushed.
	call	factorial	# run the factorial function
	addq	$8, %rsp	# Scrubs the parameter that was pushed on
				# the stack
	movq	%rax, %rbx	# factorial returns the answer in %rax, but
				# we want it in %rbx to send it as our exit
				# status
	movq	$1, %rax	# call the kernel's exit function
	int	$0x80

# This is the actual function definition
.type factorial, @function
factorial:
	pushq	%rbp		# standard function stuff - we have to
				# restore %rbp to its prior state before
				# returning, so we have to push it
	movq	%rsp, %rbp	# This is because we don't want to modify
				# the stack pointer, so we use %rbp.

	movq	16(%rbp), %rax	# This moves the first argument to %rax
				# 8(%rbp) holds the return address, and
				# 16(%rbp) holds the first parameter
	cmpq	$1, %rax	# If the number is 1, that is our base
				# case, and we simply return (1 is already
				# in %rax as the return value)
	je end_factorial
	decq	%rax		# otherwise, decrease the value
	pushq	%rax		# push it for our call to factorial
	call	factorial	# call factorial
	movq	16(%rbp), %rbx	# %rax has the return value, so we reload
				# our parameter into %rbx
	imulq	%rbx, %rax	# multiply that by the result of the last
				# call to factorial (in %rax)
				# the answer is stored in %rax, which is
				# good since that's where the return values
				# go.

end_factorial:
	movq	%rbp, %rsp	# standard function return stuff - we have
	popq	%rbp		# to restore %rbp and %rsp to where they
				# were before the function started
	ret			# return to the function (this pops the
				# return value, too)
