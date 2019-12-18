# PURPOSE:	Count the characters until a null byte is reached.
#
# INPUT:	The address of the character string.
#
# OUTPUT:	Returns the count in %rax
#
# PROCESS:	Registers used:
#		%rcx - character count
#		%al - current character
#		%rdx - current character address
#

.globl count_chars
.type count_chars, @function

# This is where our one parameter is on the stack
.equ ST_STRING_START_ADDRESS, 16

count_chars:
	pushq	%rbp
	movq	%rsp, %rbp

	# counter starts at 0
	movq	$0, %rcx

	# starting address of the data
	movq	ST_STRING_START_ADDRESS(%rbp), %rdx

count_loop_begin:
	# grab the current character
	movb	(%rdx), %al
	# is it null?
	cmpb	$0, %al
	# if yes, we're done
	je	count_loop_end
	# otherwise, increment the counter and the pointer
	incq	%rcx
	incq	%rdx
	# go back to the beginning of the loop
	jmp	count_loop_begin

count_loop_end:
	# we're done. move the count int %rax and return
	movq	%rcx, %rax

	popq	%rbp
	ret
