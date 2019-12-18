# PURPOSE:	This function finds the maximum number of a set of data
#		items.
#
# INPUT:	A pointer to an array of integers. The array must be
#		null-terminated.
#
# OUTPUT:	The largest value in the given list of numbers.
#
# NOTES:	None (yet).
#
# VARIABLES:	The registers have the following uses:
#
# %rcx - Holds the address of the data item being examined on a given iteration
# %rbx - Largest data item found
# %rax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used to terminate the data.
#

.globl maximum
.type maximum, @function

maximum:
	pushq	%rbp		# standard function beginning stuff; push the
				# old base pointer onto the stack
	movq	%rsp, %rbp	# make the stack pointer the new base pointer

	movq	16(%rbp), %rcx	# put the pointer to the array (input) into %rcx
	movq	(%rcx), %rbx	# put the value at %rcx into %rbx, since it is
				# the largest we have seen so far

start_loop:				# start loop
	movq	(%rcx), %rax		# move the value at %rcx to %rax, since
					# it will be used heavily
	cmpq	$0, %rax		# check to see if we've hit the end
	je	loop_exit
	addq	$8, %rcx		# point to the next value in memory
	cmpq	%rbx, %rax		# compare values
	jle	start_loop		# jump to loop beginning if the new one
					# is not bigger
	movq	%rax, %rbx		# move the value as the largest
	jmp	start_loop		# jump to loop beginning
	
loop_exit:
	movq	%rbp, %rsp	# standard function return stuff
	popq	%rbp
	ret
