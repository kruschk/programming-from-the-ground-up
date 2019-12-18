# PURPOSE:	This program is to demonstrate how to call printf
#

.section .data

# This string is called the format string. It's the first parameter, and
# printf used it to find out how many parameters it was given, and what kind
# they are.
firststring:
	.ascii "Hello! %s is a %s who loves the number %d\n\0"
name:
	.ascii "Jonathan\0"
personstring:
	.ascii "person\0"
# This could also have been a .equ, but we decided to give it a real memory
# location just for kicks.
numberloved:
	.quad 3

.section .text

.globl _start
_start:
	# note that the parameters are passed in the reverse order that they
	# listed in the function's prototype.
	#pushq	numberloved	# this is the %d
	#pushq	$personstring	# this is the second %s
	#pushq	$name		# this is the first %s
	#pushq	$firststring	# this is the format string in the prototype
	movq	numberloved, %rcx	# this is the %d
	movq	$personstring, %rdx	# this is the second %s
	movq	$name, %rsi		# this is the first %s
	movq	$firststring, %rdi	# this is the format string in the prototype
	call	printf@PLT

	#pushq	$0
	movq	$0, %rdi
	call	exit@PLT
