.include "linux.s"
.include "record-def.s"

.section .data

input_file_name:
	.ascii "test.dat\0"

output_file_name:
	.ascii "testout.dat\0"

.section .bss

.lcomm record_buffer, RECORD_SIZE

# stack offsets of local variables
.equ ST_INPUT_DESCRIPTOR, -8
.equ ST_OUTPUT_DESCRIPTOR, -16

.section .text

.globl _start

_start:
	# copy stack pointer and make room for local variables
	movq	%rsp, %rbp
	subq	$16, %rsp

	# open file for reading
	movq	$SYS_OPEN, %rax
	movq	$input_file_name, %rdi
	movq	$0, %rsi
	movq	$0666, %rdx
	syscall

	movq	%rax, ST_INPUT_DESCRIPTOR(%rbp)

	# open file for writing
	movq	$SYS_OPEN, %rax
	movq	$output_file_name, %rdi
	movq	$0101, %rsi
	movq	$0666, %rdx
	syscall

	movq	%rax, ST_OUTPUT_DESCRIPTOR(%rbp)

loop_begin:
	pushq	ST_INPUT_DESCRIPTOR(%rbp)
	pushq	$record_buffer
	call	read_record
	addq	$16, %rsp

	# Returns the number of bytes read. If it isn't the same number we
	# requested, then it's either an end-of-file or an error, so we're quitting.
	cmpq	$RECORD_SIZE, %rax
	jne	loop_end

	# increment the age
	incq	record_buffer + RECORD_AGE

	# write the record out
	pushq	ST_OUTPUT_DESCRIPTOR(%rbp)
	pushq	$record_buffer
	call	write_record
	addq	$16, %rsp

	jmp	loop_begin

loop_end:
	movq	$SYS_EXIT, %rax
	movq	$0, %rdi
	syscall
