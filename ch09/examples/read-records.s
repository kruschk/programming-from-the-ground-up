.include "linux.s"
.include "record-def.s"

.section .data

file_name:
	.ascii "test.dat\0"

record_buffer_ptr:
	.quad 0

.section .bss

.section .text

# main program
.globl _start

_start:
	# These are the locations on the stack where we will store the input
	# and output descriptors (FYI - we could have used memory addresses in
	# a .data section instead)
	.equ ST_INPUT_DESCRIPTOR, -8
	.equ ST_OUTPUT_DESCRIPTOR, -16

	# copy the stack pointer to %rbp
	movq	%rsp, %rbp
	# allocate space to hold the file descriptors
	subq	$16, %rsp

	# initialize our memory allocator
	call	allocate_init

	# allocate some memory for the record buffer
	pushq	$RECORD_SIZE
	call	allocate
	movq	%rax, record_buffer_ptr

	# open the file
	movq	$SYS_OPEN, %rax
	movq	$file_name, %rdi
	movq	$0, %rsi	# this says to open read-only
	movq	$0666, %rdx
	syscall

	# save file descriptor
	movq	%rax, ST_INPUT_DESCRIPTOR(%rbp)

	# Even though it’s a constant, we are saving the output file descriptor
	# in a local variable so that if we later decide that it isn’t always
	# going to be STDOUT, we can change it easily.
	movq	$STDOUT, ST_OUTPUT_DESCRIPTOR(%rbp)

record_read_loop:
	pushq	ST_INPUT_DESCRIPTOR(%rbp)
	pushq	record_buffer_ptr
	call	read_record
	addq	$16, %rsp

	# Returns the number of bytes read. If it isn't the same number we
	# requested, then it's either an end-of-file or an error, so we're
	# quitting.
	cmpq	$RECORD_SIZE, %rax
	jne	finished_reading

	# Otherwise, print out the first name, but first, we must know its
	# size.
	#pushq	$RECORD_FIRSTNAME + record_buffer
	movq	record_buffer_ptr, %rax
	addq	$RECORD_FIRSTNAME, %rax
	pushq	%rax
	call	count_chars
	addq	$8, %rsp

	movq	%rax, %rdx
	movq	$SYS_WRITE, %rax
	movq	ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
	#movq	$RECORD_FIRSTNAME + record_buffer, %rsi
	movq	record_buffer_ptr, %rsi
	addq	$RECORD_FIRSTNAME, %rsi
	syscall

	pushq	ST_OUTPUT_DESCRIPTOR(%rbp)
	call	write_newline
	addq	$8, %rsp

	jmp	record_read_loop

finished_reading:
	# deallocate memory
	pushq	record_buffer_ptr
	call	deallocate

	# exit program
	movq	$SYS_EXIT, %rax
	movq	$0, %rdi
	syscall
