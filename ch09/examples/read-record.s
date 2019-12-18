.include "linux.s"
.include "record-def.s"

# PURPOSE:	This function reads a record from the file descriptor.
#
# INPUT:	The file descriptor and a buffer.
#
# OUTPUT:	Data is written to the buffer and a status code is returned.
#

# stack variables
.equ ST_FILEDES, 24
.equ ST_READ_BUFFER, 16

.section .text

.globl	read_record
.type	read_record, @function

read_record:
	pushq	%rbp
	movq	%rsp, %rbp

	pushq	%rbx
	movq	$SYS_READ, %rax
	movq	ST_FILEDES(%rbp), %rdi
	movq	ST_READ_BUFFER(%rbp), %rsi
	movq	$RECORD_SIZE, %rdx
	syscall

	# Note: %rax has the return value, which we will give back to our
	# calling program
	popq	%rbx

	movq	%rbp, %rsp
	popq	%rbp
	ret
