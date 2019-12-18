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
	.rept 31	#Padding to 40 bytes
	.byte 0
	.endr

	.ascii "Bartlett\0"
	.rept 31	#Padding to 40 bytes
	.byte 0
	.endr

	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209	#Padding to 240 bytes
	.byte 0
	.endr

	.quad 45	# age

	.ascii "Sngl.\0"
	.rept 2		#Padding to 40 bytes
	.byte 0
	.endr

record2:
	.ascii "Marilyn\0"
	.rept 32	#Padding to 40 bytes
	.byte 0
	.endr

	.ascii "Taylor\0"
	.rept 33	#Padding to 40 bytes
	.byte 0
	.endr

	.ascii "2224 S Johannan St\nChicago, IL 12345\0"
	.rept 203	#Padding to 240 bytes
	.byte 0
	.endr

	.quad 29	# age

	.ascii "Sngl.\0"
	.rept 2		#Padding to 40 bytes
	.byte 0
	.endr

record3:
	.ascii "Derrick\0"
	.rept 32	#Padding to 40 bytes
	.byte 0
	.endr

	.ascii "McIntire\0"
	.rept 31	#Padding to 40 bytes
	.byte 0
	.endr

	.ascii "500 W Oakland\nSan Diego, CA 54321\0"
	.rept 206	#Padding to 240 bytes
	.byte 0
	.endr

	.quad 36	# age

	.ascii "Marr.\0"
	.rept 2		#Padding to 40 bytes
	.byte 0
	.endr

#This is the name of the file we will write to
file_name:
	.ascii "test.dat\0"

.section .text

.equ ST_FILE_DESCRIPTOR, -8

.globl _start

_start:
	# copy the stack pointer to %rbp
	movq	%rsp, %rbp

	# allocate space to hold the file descriptor
	subq	$8, %rsp

	# open the file
	movq	$SYS_OPEN, %rax
	movq	$file_name, %rdi
	movq	$03101, %rsi	# This says to create if it doesn't exist, and
				# open for writing
	movq	$0666, %rdx
	syscall

	# store the file descriptor away
	movq	%rax, ST_FILE_DESCRIPTOR(%rbp)

	# write the first record
	pushq	ST_FILE_DESCRIPTOR(%rbp)
	pushq	$record1
	call	write_record
	addq	$16, %rsp

	# write the second record
	pushq	ST_FILE_DESCRIPTOR(%rbp)
	pushq	$record2
	call	write_record
	addq	$16, %rsp

	# write the third record
	pushq	ST_FILE_DESCRIPTOR(%rbp)
	pushq	$record3
	call	write_record
	addq	$16, %rsp

	# close the file descriptor
	movq	$SYS_CLOSE, %rax
	movq	ST_FILE_DESCRIPTOR(%rbp), %rdi
	syscall

	# exit the program
	movq	$SYS_EXIT, %rax
	movq	$0, %rdi
	syscall
