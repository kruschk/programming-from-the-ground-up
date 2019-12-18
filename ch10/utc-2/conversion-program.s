.include "linux.s"

.section .data

# This is where it will be stored
tmp_buffer:
	.ascii "\0\0\0\0\0\0\0\0\0\0\0"

.section .text

.globl _start

_start:
	movq	%rsp, %rbp

	# call the conversion function:
	# storage for the result
	pushq	$tmp_buffer
	# number to convert
	pushq	$32
	call	integer2string
	addq	$16, %rsp

	# get the character count for our system call
	pushq	$tmp_buffer
	call	count_chars
	addq	$8, %rsp

	# the count goes in %rdx for SYS_WRITE
	movq	%rax, %rdx

	# make the system call
	movq	$SYS_WRITE, %rax
	movq	$STDOUT, %rdi
	movq	$tmp_buffer, %rsi
	syscall

	# write a carriage return
	pushq	$STDOUT
	call	write_newline

	# exit
	movq	$SYS_EXIT, %rax
	movq	$0, %rbx
	syscall
