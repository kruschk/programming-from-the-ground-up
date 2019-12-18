.include "linux.s"
.include "record-def.s"
.include "error-codes.s"

# PURPOSE:	This function reads a record from the file descriptor.
#
# INPUT:	The file descriptor and a buffer.
#
# OUTPUT:	Data is written to the buffer and a status code is returned.
#

# stack variables
.equ ST_FILEDES, 24
.equ ST_WRITE_BUFFER, 16

.section .text

.globl	write_record
.type	write_record, @function

write_record:
	pushq	%rbp
	movq	%rsp, %rbp

	pushq	%rbx
	movq	$SYS_WRITE, %rax
	movq	ST_FILEDES(%rbp), %rdi
	movq	ST_WRITE_BUFFER(%rbp), %rsi
	movq	$RECORD_SIZE, %rdx
	syscall

	# check if writing was successful
	cmpq	$0, %rax
	jge	write_record_return

	# send the error if writing was unsuccessful
	pushq	$no_open_file_msg
	pushq	$no_open_file_code
	call	error_exit

write_record_return:
	# Note: %rax has the return value, which we will give back to our
	# calling program
	popq	%rbx

	movq	%rbp, %rsp
	popq	%rbp
	ret
