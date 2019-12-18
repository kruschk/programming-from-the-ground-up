as --gstabs	-o read-records.o	read-records.s
as --gstabs	-o read-record.o	read-record.s
as --gstabs	-o count-chars.o	count-chars.s
as --gstabs	-o write-newline.o	write-newline.s
ld		-o read-records		read-records.o read-record.o count-chars.o write-newline.o
