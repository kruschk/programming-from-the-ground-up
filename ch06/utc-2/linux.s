# Common Linux definitions:

# System call numbers:
.equ	SYS_READ, 0
.equ	SYS_WRITE, 1
.equ	SYS_OPEN, 2
.equ	SYS_CLOSE, 3
.equ	SYS_BRK, 12
.equ	SYS_EXIT, 60

# Standard file descriptors
.equ	STDIN, 0
.equ	STDOUT, 1
.equ	STDERR, 2

# Common status codes
.equ	END_OF_FILE, 0
