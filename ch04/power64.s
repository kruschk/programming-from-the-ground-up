# PURPOSE:	Program to illustrate how functions work.
#		This program will compute the value of
#		2^3 + 5^2
#

# Everything in the main program is stored in registers, so the data
# section doesn't have anything.
.section .data

.section .text

.globl _start
_start:
	pushq	$3		# push second argument
	pushq	$2		# push the first argument
	call	power		# call the function
	addq	$16, %rsp	# move the stack pointer back
	pushq	%rax		# save the first answer before
				# calling the next function

	pushq	$2		# push second argument
	pushq	$5		# push first argument
	call	power		# call the function
	addq	$16, %rsp	# move the stack pointer back

	popq	%rbx		# The second answer is already in %eax. We
				# saved the first answer onto the stack, so
				# now we can just pop it out into %ebx.

	addq	%rax, %rbx	# add them together
				# the result is in %ebx

	movq	%rbx, %rdi	# %rdi holds the return value on amd64

	movq	$60, %rax	# proper amd64 exit() syscall (%rdi is returned):
	syscall
	#movq	$1, %rax	# exit (%ebx is returned)
	#int	$0x80

# PURPOSE:	This function is used to compute the value of a number
#		raised to a power.
#
# INPUT:	First argument - the base number
#		Second argument - the power to raise it to
#
# OUTPUT:	Will give the result as a return value
#
# NOTES:	The power must be 1 or greater
#
# VARIABLES:	%ebx - holds the base number
#		%ecx - holds the power
#		-4(%ebp) - holds the current result
#
#		%eax is used for temporary storage
#
.type power, @function
power:
	pushq	%rbp		# save old base pointer
	movq	%rsp, %rbp	# make stack pointer the base pointer
	subq	$8, %rsp	# get room for our local storage

	movq	16(%rbp), %rbx	# put first argument in %eax
	movq	24(%rbp), %rcx	# put second argument in %ecx

	movq	%rbx, -8(%rbp)	# store current result

power_loop_start:
	cmpq	$1, %rcx	# if the power is 1, we are done
	je	end_power
	movq	-8(%rbp), %rax	# move the current result into %eax
	imulq	%rbx, %rax	# multiply the current result by the base
				# number
	movq	%rax, -8(%rbp)	# store the current result

	decq	%rcx			# decrease the power
	jmp	power_loop_start	# run for the next power

end_power:
	movq	-8(%rbp), %rax	# return value goes in %eax
	movq	%rbp, %rsp	# restore the stack pointer
	popq	%rbp		# restore the base pointer
	ret
