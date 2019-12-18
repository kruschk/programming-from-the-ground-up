# PURPOSE:	Write a program that will create a file called heynow.txt and
#		write the words "Hey diddle diddle!" into it.
#

.section .data

###CONSTANTS###
# system call numbers
.equ	SYS_WRITE, 1
.equ	SYS_OPEN, 2
.equ	SYS_CLOSE, 3
.equ	SYS_EXIT, 60

# output filename
FILENAME:	.asciz "5-utc-4.out"
# flags for file
.equ	O_CREAT_WRONLY_TRUNC, 03101
# mode for file
.equ	MODE,	0666

# end-of-file indicator
.equ	EOF, 0

# output string
STRING: .ascii "Hey diddle diddle!"

.section .bss

.section .text

# stack positions
.equ	ARGV_1, 16		# output file
.equ	ARGV_0, 8		# program name
.equ	ARGC, 0			# argument count
.equ	FD_OUT, -8		# file descriptor
.equ	LOCAL_RESERVE, 8	# reserve storage space on the stack for fd

.globl _start

_start:
	### INITIALIZE THE PROGRAM ###
	# save the stack pointer
	movq	%rsp, %rbp

	# allocate space for fd on the stack
	subq	$LOCAL_RESERVE, %rsp

	### OPEN OUTPUT FILE ###
	# get a file descriptor for the output file
	movq	$SYS_OPEN, %rax
	movq	$FILENAME, %rdi
	movq	$O_CREAT_WRONLY_TRUNC, %rsi
	movq	$MODE, %rdx
	syscall

	# save the file descriptor
	movq	%rax, FD_OUT(%rbp)

	### WRITE THE STRING TO THE OUTPUT FILE ###
	movq	$SYS_WRITE, %rax
	movq	FD_OUT(%rbp), %rdi
	movq	$STRING, %rsi
	movq	$18, %rdx
	syscall

	### CLOSE OUTPUT FILE ###
	# close the file
	movq	$SYS_CLOSE, %rax
	movq	FD_OUT(%rbp), %rdi
	syscall

	### EXIT ###
	# exit
	movq	$0, %rdi		# return code of 0 means no errors
	movq	$SYS_EXIT, %rax
	syscall
