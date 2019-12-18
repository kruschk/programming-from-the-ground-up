# PURPOSE:	This program writes the message "hello world" and exits"
#

.include "linux.s"

.section .data

helloworld:
	.ascii "hello world\n"
helloworld_end:

.equ helloworld_len, helloworld_end - helloworld

.section .text

.globl _start
_start:
	movq	$STDOUT, %rdi
	movq	$helloworld, %rsi
	movq	$helloworld_len, %rdx
	movq	$SYS_WRITE, %rax
	syscall

	movq	$0, %rdi
	movq	$SYS_EXIT, %rax
	syscall
