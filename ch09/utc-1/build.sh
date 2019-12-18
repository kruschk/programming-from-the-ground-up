# assemble source into object files:
as --gstabs	-o add-year.o		add-year.s
as --gstabs	-o alloc.o		alloc.s
as --gstabs	-o count-chars.o	count-chars.s
as --gstabs	-o read-record.o	read-record.s
as --gstabs	-o read-records.o	read-records.s
as --gstabs	-o write-newline.o	write-newline.s
as --gstabs	-o write-record.o	write-record.s
as --gstabs	-o write-records.o	write-records.s

# link write-records program
ld -o write-records	write-records.o write-record.o write-newline.o count-chars.o

# link read-records program
ld -o read-records	alloc.o count-chars.o read-records.o read-record.o write-newline.o

# link add-year program:
ld -o add-year		add-year.o count-chars.o read-record.o write-record.o write-newline.o
