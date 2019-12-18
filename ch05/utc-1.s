# PURPOSE:	This program converts an input file to an output file with all
#		letters converted to uppercase.
#
# PROCESSING:	1) Open the input file.
#		2) Open the output file.
#		3) While we're not at the end of the input file:
#			a) read part of file into our memory buffer
#			b) go through each byte of memory; if the byte is a
#			   lower-case letter, convert it to uppercase
#			c) write the memory buffer to output file
#

.section .data

###CONSTANTS###

# system call numbers
.equ	SYS_OPEN, 2
.equ	SYS_WRITE, 1
.equ	SYS_READ, 0
.equ	SYS_CLOSE, 3
.equ	SYS_EXIT, 60

# options for open (look at /usr/include/asm/fcntl.h for various values. You
# can combine them by adding them or ORing them). This is discussed at greater
# length in "Counting Like a Computer".
.equ	O_RDONLY, 0
.equ	O_CREAT_WRONLY_TRUNC, 03101

# standard file descriptors
.equ	STDIN, 0
.equ	STDOUT, 1
.equ	STDERR, 2

# system call interrupt
.equ	LINUX_SYSCALL, 0x80

.equ	END_OF_FILE, 0	# This is the return value of read which means we've
			# hit the end of the file.

.equ	NUMBER_ARGUMENTS, 2

.section .bss

# Buffer - this is where the data is loaded into from the data file and written
# from into the output file. This should never exceed 16,000 for various
# reasons.
.equ	BUFFER_SIZE, 500
.lcomm	BUFFER_DATA, BUFFER_SIZE

.section .text

# STACK POSITIONS
.equ	ST_SIZE_RESERVE, 16
.equ	ST_ARGV_2, 24	# output file name
.equ	ST_ARGV_1, 16	# input file name
.equ	ST_ARGV_0, 8	# name of program
.equ	ST_ARGC, 0	# number of arguments
.equ	ST_FD_IN, -8
.equ	ST_FD_OUT, -16

.globl _start

_start:
	###INITIALIZE PROGRAM###
	# save the stack pointer
	movq	%rsp, %rbp

	# allocate space for our file descriptors on the stack
	subq	$ST_SIZE_RESERVE, %rsp

	# save the file descriptor for STDIN to the stack
	movq	$STDIN, %rax
	movq	%rax, ST_FD_IN(%rbp)

	# save the file descriptor for STDOUT to the stack
	movq	$STDOUT, %rax
	movq	%rax, ST_FD_OUT(%rbp)

###BEGIN MAIN LOOP###
read_loop_begin:
	###READ IN A BLOCK FROM THE INPUT FILE###
	movq	$SYS_READ, %rax
	# get the input file descriptor
	movq	ST_FD_IN(%rbp), %rdi
	# the location to read into
	movq	$BUFFER_DATA, %rsi
	# the size of the buffer
	movq	$BUFFER_SIZE, %rdx
	# size of buffer read is returned in %rax
	syscall

	###EXIT IF WE'VE REACHED THE END###
	# check for end of file marker
	cmpq	$END_OF_FILE, %rax
	# if found or on error, go to the end
	jle	end_loop

continue_read_loop:
	###CONVERT THE BLOCK TO UPPER CASE###
	pushq	$BUFFER_DATA	# location of buffer
	pushq	%rax		# size of the buffer
	call	convert_to_upper
	popq	%rax		# get the size back
	addq	$8, %rsp	# restore %rsp

	###WRITE THE BLOCK OUT TO THE OUTPUT FILE###
	# size of the buffer
	movq	%rax, %rdx		# I think this is unneeded?
	movq	$SYS_WRITE, %rax
	# file to use
	movq	ST_FD_OUT(%rbp), %rdi
	# location of the buffer
	movq	$BUFFER_DATA, %rsi
	syscall

	###CONTINUE THE LOOP###
	jmp	read_loop_begin

end_loop:
	###EXIT###
	movq	$0, %rdi		# return 0;
	movq	$SYS_EXIT, %rax		# tell Linux we want to exit
	syscall				# call Batm--err, Linux!

# PURPOSE:	This function actually does the conversion to upper case for a
#		block.
#
# INPUT:	The first parameter is the location of the block of memory to
#		convert.
#		The second parameter is the length of that buffer.
#
# OUTPUT:	This function overwrites the current buffer with the
#		upper-casified version.
#
# VARIABLES:	%rax:	beginning of buffer
#		%rbx:	length of the buffer
#		%rdi:	current buffer offset
#		%cl:	current byte being examined
#

###CONSTANTS###
# The lower boundary of our search
.equ	LOWERCASE_A, 'a'
# The upper boundary of our search
.equ	LOWERCASE_Z, 'z'
# Conversion between upper and lower case
.equ	UPPER_CONVERSION, 'A'-'a'

###STACK STUFF###
.equ	ST_BUFFER, 24		# actual buffer
.equ	ST_BUFFER_LEN, 16	# length of buffer

convert_to_upper:
	pushq	%rbp
	movq	%rsp, %rbp

	###SET UP VARIABLES###
	movq	ST_BUFFER(%rbp), %rax
	movq	ST_BUFFER_LEN(%rbp), %rbx
	movq	$0, %rdi

	# if given a buffer with zero length, just leave
	cmpq	$0, %rbx
	je	end_convert_loop

convert_loop:
	# get the current byte
	movb	(%rax,%rdi,1), %cl

	# go to the next byte unless it is between 'a' and 'z'
	cmpb	$LOWERCASE_A, %cl
	jl	next_byte
	cmpb	$LOWERCASE_Z, %cl
	jg	next_byte

	# otherwise, conver the byte to uppercase
	addb	$UPPER_CONVERSION, %cl
	# and store it back
	movb	%cl, (%rax,%rdi,1)

next_byte:
	incq	%rdi		# next byte
	cmpq	%rdi, %rbx	# continue unless we've reached the end
	jne	convert_loop

end_convert_loop:
	# no return value, just leave
	movq	%rbp, %rsp
	popq	%rbp
	ret
