.include "linux.s"
.include "record-def.s"
.include "error-codes.s"

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

	# save the input fd
	movq	%rax, ST_INPUT_DESCRIPTOR(%rbp)

	# this will test and see if %rax is negative. If it is not negative, it
	# will jump to continue_processing. Otherwise it will handle the error
	# condition that the negative number represents.
	cmpq	$0, %rax
	jge	continue_to_writing

	# send the error if reading was unsuccessful
	pushq	$no_open_file_msg
	pushq	$no_open_file_code
	call	error_exit

continue_to_writing:
	# open file for writing
	movq	$SYS_OPEN, %rax
	movq	$output_file_name, %rdi
	movq	$0101, %rsi
	movq	$0666, %rdx
	syscall

	# save the output fd
	movq	%rax, ST_OUTPUT_DESCRIPTOR(%rbp)

	# check if writing was successful
	cmpq	$0, %rax
	jge	loop_begin

	# send the error if writing was unsuccessful
	pushq	$no_open_file_msg
	pushq	$no_open_file_code
	call	error_exit

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
