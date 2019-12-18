# PURPOSE:	This program finds the maximum number of a set of data
#		items.
#

# VARIABLES:	The registers have the following uses:
#
# %rdi - Holds the index of the data item being examined
# %rbx - Largest data item found
# %rax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used to terminate the data.
#

.section .data

data_items1:	# These are the data items.
	.quad 3,67,34,222,45,75,54,34,44,33,22,11,66,0
data_items2:
	.quad 223,127,39,185,149,116,86,60,38,20,5,249,242,0
data_items3:
	.quad 37,181,191,95,126,221,5,209,109,85,88,80,104,0

.section .text

.globl _start
.globl maximum

_start:
	pushq	$data_items1	# push the first pointer onto the stack
	call	maximum		# call the maximum function
	addq	$8, %rsp	# scrubs data_items1 from the stack

	pushq	$data_items2	# push the second pointer
	call	maximum		# call the maximum function
	addq	$8, %rsp	# scrubs data_items2 from the stack

	pushq	$data_items3	# and finally, the third
	call	maximum		# call the maximum function
	addq	$8, %rsp	# scrubs data_items3 from the stack

	# rbx is already the maximum value from the last call to maximum()
	movq	$1, %rax	# 1 is the exit() syscall
	int	$0x80
