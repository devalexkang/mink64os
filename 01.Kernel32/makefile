all: VirtualOS.bin

VirtualOS.bin: VirtualOS.asm
	nasm -o VirtualOS.bin VirtualOS.asm

Clean:
	rm -f VirtualOS.bin