all: Kernel32.bin

Kernel32.bin: Source/EntryPoint.s
	nasm -o Kernel32.bin $<

Clean:
	rm -f Kernel32.bin