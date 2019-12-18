# PURPOSE:	This program finds the maximum number of a set of data
#		items.
#

# VARIABLES:	The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used to terminate the data.
#

.section .data

data_items:	# These are the data items.
	.quad 3,67,34,222,45,75,54,34,44,33,22,11,66,0

output_string:
	.string "The maximum value in the array is %d.\n"

.section .text

.globl _start
_start:
	movq	$0, %rdi			# move 0 into the index register
	movq	data_items(,%rdi,8), %rax	# load the first byte of data
	movq	%rax, %rbx			# since this is the first item,
						# %eax is the biggest

start_loop:				# start loop
	cmpq	$0, %rax			# check to see if we've hit the end
	je	loop_exit
	incq	%rdi				# load next value
	movq	data_items(,%rdi,8), %rax
	cmpq	%rbx, %rax			# compare values
	jle	start_loop			# jump to loop beginning if the new one
						# isn't bigger
	movq	%rax, %rbx			# move the value as the largest
	jmp	start_loop			# jump to loop beginning
	
loop_exit:
	# %rbx holds the maximum value, we want to print it:
	movq	$output_string, %rdi
	movq	%rbx, %rsi
	call	printf@PLT

	# %rdi is the status code for the exit system call
	movq	$0, %rdi
	movq	$60, %rax
	syscall
