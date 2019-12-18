# helloworld-nolib
as --gstabs -o helloworld-nolib.o helloworld-nolib.s
ld helloworld-nolib.o -o helloworld-nolib

# helloworld-lib:
# assemble the program
as --gstabs -o helloworld-lib.o helloworld-lib.s
# link using the c standard library and the linux 64-bit linker
ld helloworld-lib.o -o helloworld-lib -I /lib64/ld-linux-x86-64.so.2 -l c

# printf-example:
# assemble
as --gstabs -o printf-example.o printf-example.s
# link
ld printf-example.o -o printf-example -I /lib64/ld-linux-x86-64.so.2 -l c
