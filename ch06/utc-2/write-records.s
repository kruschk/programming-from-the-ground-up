.include "linux.s"
.include "record-def.s"

.section .data

# Constant data of the records we want to write
# Each text data item is padded to the proper length with null (i.e. 0) bytes.

# .rept is used to pad each item. .rept tells the assembler to repeat the
# section between .rept and .endr the number of times specified. This is used
# in this program to add extra null characters at the end of each field to fill
# it up.

record1:
	.ascii "Fredrick\0"
	.rept 31	# padding to 40 bytes
	.byte 0
	.endr

	.ascii "Bartlett\0"
	.rept 31
	.byte 0
	.endr

	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209
	.byte 0
	.endr

	.quad 45

#This is the name of the file we will write to
file_name:
	.ascii "test.dat\0"

.section .text

.equ ST_FILE_DESCRIPTOR, -8

.globl _start

_start:
	# copy the stack pointer to %ebp
	movq	%rsp, %rbp

	# allocate space to hold the file descriptor
	subq	$8, %rsp

	# open the file
	movq	$SYS_OPEN, %rax
	movq	$file_name, %rdi
	movq	$0101, %rsi	# This says to create if it doesn't exist, and
				# open for writing
	movq	$0666, %rdx
	syscall

	# store the file descriptor away
	movq	%rax, ST_FILE_DESCRIPTOR(%rbp)

	# prepare the loop counter variable
	pushq	%r12		# save the variable that was in %r12
	movq	$1, %r12	# move counter to %r12

write_loop:
	# exit if we've hit the limit
	cmpq	$30, %r12
	jge	write_loop_end

	# write the first record
	pushq	ST_FILE_DESCRIPTOR(%rbp)
	pushq	$record1
	call	write_record
	addq	$16, %rsp

	# increment the counter
	incq	%r12

	# jump to start
	jmp	write_loop

write_loop_end:
	# retrieve variable that was in $r12
	popq	%r12

	# close the file descriptor
	movq	$SYS_CLOSE, %rax
	movq	ST_FILE_DESCRIPTOR(%rbp), %rdi
	syscall

	# exit the program
	movq	$SYS_EXIT, %rax
	movq	$0, %rdi
	syscall
