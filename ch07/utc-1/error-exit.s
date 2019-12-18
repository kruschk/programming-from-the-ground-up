.include "linux.s"

.equ ST_ERROR_MSG, 24
.equ ST_ERROR_CODE, 16

.globl error_exit
.type error_exit, @function

error_exit:
	pushq	%rbp
	movq	%rsp, %rbp

	# write out error code
	movq	ST_ERROR_CODE(%rbp), %rcx
	pushq	%rcx
	call	count_chars
	popq	%rsi			# write buffer
	movq	%rax, %rdx		# byte count
	movq	$STDERR, %rdi		# file descriptor
	movq	$SYS_WRITE, %rax	# syscall number
	syscall

	# write out error message
	movq	ST_ERROR_MSG(%rbp), %rcx
	pushq	%rcx
	call	count_chars
	popq	%rsi			# write buffer
	movq	%rax, %rdx		# byte count
	movq	$STDERR, %rdi		# file descriptor
	movq	$SYS_WRITE, %rax	# system call number
	syscall

	pushq	$STDERR
	call	write_newline

	# exit with status 1
	movq	$SYS_EXIT, %rax
	movq	$1, %rdi
	syscall
