#!/bin/bash

# assemble
as --gstabs -o integer-to-string.o	integer-to-string.s
as --gstabs -o count-chars.o		count-chars.s
as --gstabs -o write-newline.o		write-newline.s
as --gstabs -o conversion-program.o	conversion-program.s

# link
ld -o conversion-program	integer-to-string.o count-chars.o write-newline.o conversion-program.o
