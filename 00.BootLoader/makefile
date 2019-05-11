all: BootLoader.bin

BootLoader.bin: BootLoader16.asm
	nasm -o BootLoader.bin BootLoader16.asm

Clean:
	rm -f BootLoader.bin