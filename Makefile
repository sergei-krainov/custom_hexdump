PWD := $(shell pwd)

chexdump: chexdump.o
	ld -o chexdump chexdump.o
chexdump.o: chexdump.asm
	nasm -f elf64 -g -F stabs chexdump.asm

clean:
	rm -f chexdump.o chexdump
