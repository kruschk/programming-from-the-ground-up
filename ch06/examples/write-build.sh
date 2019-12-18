as --gstabs	-o write-records.o	write-records.s
as --gstabs	-o write-record.o	write-record.s
ld		-o write-records	write-records.o write-record.o
