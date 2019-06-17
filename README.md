# mink64os
project to make OS

source : http://www.kyobobook.co.kr/product/detailViewKor.laf?ejkGb=KOR&mallGb=KOR&barcode=9788979148367&orderClick=LAH&Kc=

Day01. 20190423 Creation of Git repository, directories, makefile test (tab, no space)

Day02: 

    to install qemu, gcc, nasm    
    - sudo apt-get install qemu-kvm qemu virt-manager virt-viewer libvirt-bin
    - sudo apt-get install gcc-multilib g++-multilib
    - sudo apt-get install nasm
 
    simple bootloader using assembly to test system
    -./mink64os/00.BootLoader/BootLoader.asm
    ------------------------------------------------
    ORG 0x00  ; starting address is 0x000
    BITS 16    ;16bit code
    
    SECTION .text
    
    jmp $  ; infiniti loop
    
    times 510 - ( $ - $$ ) db 0x00
    
    db 0x55
    db 0xAA
    -------------------------------------------------
    
    - nasm -f bin -o Disk.bin BootLoader.asm

    to test Disk.bin as bootloader using qemu
    - qemu-system-x86_64 -fda Disk.bin -M pc
    
Day03:

    to show character on the booting screen (top left)
    - screen : 80*25*2 = 4000 byte
    - 1 byte for each character + 1 byte for attribute of the character = 2 byte
    - Starting address : 0xB000 ( video memory address)
    
    to add code to show green 'M' with red background
    - in assemby to use memory addresss : []
    - to change BootLoader.asm
    ----------------------------------------------
     ORG 0x00  ; starting address is 0x000
     BITS 16    ;16bit code
        
     SECTION .text
     
     mov ax, 0xB800
     mov ds, ax 
     mov byte [0x00], 'M"
     mov byte [0x01], 0x4A
     
     jmp $  ; infiniti loop
         
     times 510 - ( $ - $$ ) db 0x00
         
     db 0x55
     db 0xAA
    ----------------------------------------------
    - nasm -f bin -o Disk.bin BootLoader.asm
    - qemu-system-x86_64 -fda Disk.bin -M pc
    
    
Day04:
    
    new bootloader -/mink64os/00.BootLoader/BootLoader2.asm : to show "hello world"
    - beginning address of boot loader : 0x7c0
    - beginning video memory address : 0xb800
    - loop to clear screen : .screenclearloop
    - loop to print message : .messageloop
    - message : message1
    
    - nasm -f bin -o Disk2.bin BootLoader2.asm
    - qemu-system-x86_64 -fda Disk2.bin -M pc
    
Day05:

    assembly
    source : https://github.com/gurugio/book_assembly_8086_ko/blob/master/README.md
    
    1. general register :
        64 bits - prefix R, 32bits - prefix E , 16 bits - non prrefix
        exp : RAX, EAX, AX
    - RAX : arithmetic register
    - RBX : base address register
    - RCX : counter register ( to count loop)
    - RDX : data register ( to sotre data )
    - RSI : source index register
    - RDI : destination index register
    - RBP ; bases pointer register ( to keep stack base address)
    - RSP : stack pointer resiter ( to store stack address current using)
    
    2. segment register : to extend memory addresses with general register
    - CS : code segement, segment address where to store  current program
    - DS : data segement, segment address where to store data using now
    - ES : extra segment, segment address where to store extra data
    - SS : strack segment, segmnet address where stack locates
    
    3. special register : developer cannot control it
    - RIP : instruction poinster ( address where to store next command )
    - eflag register : to show processor status, 32bit and each bit has its own meaning
        0. 	CF : Carry Flag. Set if the last arithmetic operation carried (addition) or borrowed (subtraction) a bit beyond the size of the register. This is then checked when the operation is followed with an add-with-carry or subtract-with-borrow to deal with values too large for just one register to contain.
        2. 	PF : Parity Flag. Set if the number of set bits in the least significant byte is a multiple of 2.
        4. 	AF : Adjust Flag. Carry of Binary Code Decimal (BCD) numbers arithmetic operations.
        6. 	ZF : Zero Flag. Set if the result of an operation is Zero (0).
        7. 	SF : Sign Flag. Set if the result of an operation is negative.
        8. 	TF : Trap Flag. Set if step by step debugging.
        9. 	IF : Interruption Flag. Set if interrupts are enabled.
        10. 	DF : Direction Flag. Stream direction. If set, string operations will decrement their pointer rather than incrementing it, reading memory backwards.
        11. 	OF : Overflow Flag. Set if signed arithmetic operations result in a value too large for the register to contain.
        12-13. 	IOPL : I/O Privilege Level field (2 bits). I/O Privilege Level of the current process.
        14. 	NT : Nested Task flag. Controls chaining of interrupts. Set if the current process is linked to the next process.
        16. 	RF : Resume Flag. Response to debug exceptions.
        17. 	VM : Virtual-8086 Mode. Set if in 8086 compatibility mode.
        18. 	AC : Alignment Check. Set if alignment checking of memory references is done.
        19. 	VIF : Virtual Interrupt Flag. Virtual image of IF.
        20. 	VIP : Virtual Interrupt Pending flag. Set if an interrupt is pending.
        21. 	ID : Identification Flag. Support for CPUID instruction if can be set. 
    
    31 	30 	29 	28 	27 	26 	25 	24 	23 	22 	21 	20 	    19 	    18 	17 	16
    0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	ID 	VIP 	VIF 	AC 	VM 	RF
    15 	14 	13 	12 	11 	10 	9 	8 	7 	6 	5 	4 	3 	2 	1 	0
    0 	NT 	IOPL 	OF 	DF 	IF 	TF 	SF 	ZF 	0 	AF 	0 	PF 	1 	CF 
    
    -------------------------------------------------------
    emulator
    source : https://dman95.github.io/SASM/english.html
    ./mink64os/04.Utility/01.Dman95-SASM-ae16f40
    Compile method : ./mink64os/04.Utility/01.Dman95-SASM-ae16f40/README.txt
    After build, run debug with several breakpoint then it shows register list and values
    
    - sasm
    --------------------------------------------------------
    
    
Day06:

    assembly : 16bit
    
    RAX, EAX, AX, AH + AL
    RCX, ECX, CX, CH + CL
    RDX, EDX, DX, DH + DL
    RBX, EBX, BX, BH + BL
    RSP, ESP, SP
    RBP, EBP, BP
    RSI, ESI, SI
    RDI, EDI, DI 
    
    method to indicate memory address : d16 = 16 bit number offset, d8 = 8bit number offset
    [] : pointer 
     
    [BX + SI]
    [BX + DI]
    [BP + SI]
    [BP + DI]	
    [SI]
    [DI]
    [BX]	
    [BX + SI + d8]
    [BX + DI + d8]
    [BP + SI + d8]
    [BP + DI + d8]
    [SI + d8]
    [DI + d8]
    [BP + d8]
    [BX + d8]	
    [BX + SI + d16]
    [BX + DI + d16] 
    [BP + SI + d16]
    [BP + DI + d16]	
    [SI + d16]
    [DI + d16]
    [BP + d16]
    [BX + d16]
    
    example :
    org 100h            ; starting at adress 100h
    mov ax, 0b800h      ; ax = 0b800h  (to store value in register)
    mov ds, ax          ; ds = ax ( 0b800h )  (to store register value in segment)
    mov bx, 0           ; bx = 0   (base address is 0)
    mov cl, 'A'         ; cl = 'A' (16 bit cx's 8bit low part = 'A')
    mov ch, 11011111b   ; ch = 11011111b (16 bit cx's 8bit hgih part = 1101111;b)
    mov ds:[bx], cx     ; 0b800h + 0h  = 0b800h = cx = (ch + cl) = 1101111b + 'A'
    mov [bx+2], cx      ; ds+bx+2 = 0b800h + 0 + 2 = 0b802h = cx = (ch + cl) = 11011111b + 'A'
    mov si, 4           ; si = 4
    mov [bx+si], cx     ; [bx + si] = [4] = ds + 4 = 0b804h = cx
    mov [bx+si+2], cx   ; ds + 4 +2 = 0b806h = cx
    ret
    
    etc : sasm has error while compiling. I will focus to use nasm
    
    
Day07:
    
    Stack : last in first out, required to use function on x86 processor
            to save return address after processor calls function
            to save parameters of the function
            
    to create stack, 3 registers require
        1. stack segment register - ss, 
        2. base pointer register - bp,
        3. stack pointer register - sp
        
        ss for base address of the segment to use as stack
        (stack starts from ss, top)
        bp for stack base address
        (stack ends at bp, bottom)
        sp to indicate top of the stack
        (stack is full until sp, pop - move to bp, push - move to ss)
        
        
        
Day08:

    general format of assembly function
    
    push bp      ; input base pointer register in stack
    mov bp, sp   ; base pointer register = stack pointer register's value
                 ; to approach parameters using base pointer register
    push es      ; input from ES segment register to DX register in stack
    push si
    push di
    push ax
    push cx
    push dx
    ---------
    
    mov ax, word [bp + 4]    ; parameter 1 (iX, x coordinator value)
    mov bx, word [bp + 6]    ; parameter 2 (iY, y coordinator value)
    mov cx, word [bp + 8]    ; parameter 2 (pcString, address of string)
    
    ---------
    
    pop dx         ; pop every register from stack ( reverse againster push)
    pop cx
    pop ax
    pop di
    pop si
    pop es
    pop bp          ; 
    ret 
   
Day09:
    
    ./mink64os/05.Assembly/assemply_test.txt
    to practice assembly function ( printing a string function)
    
    call conention in safe mode (32 bit mode)
    - stdcall : parameters will be stroed in stack
                callee will manage stack
                
    - cdecl : parameters will be stored in stack
                caller will manage stack
                
    - fastcall : some parameters will be stored in registers
                 others will be stored in stack
                 callee will manage stack
                 
     ex)
     in add(int ia, int ib, int ic)
     {
        return ia + ib + ic;
     }
     void main (void)
     {
        int ireturn;
        ireturn = add(1, 2, 3);
     }
     
     stdcall : push variables from right to left, ic, ib, ia
               to return value, EAX register will be used.
               func add will remove parameters in stack
    
     cdecl : push variables from right to left, ic, ib, ia
             to return value, EAX register will be used.
             func main will remove func add parameteres (ia, ib, ib) in stack
             
     fastcall : ic to stack, ib to EDX register, ic to ECS register
                to return value, EAX register will be used
                func add will remove parameters in stack
     
     
Day10:

    IA-32e mode function call standard : fastcall extension to use more registers
                                         + 8 more general register (R8 ~ R15 register)
                                         maximu 8 parameters can be used
                                         
     [es:si] : segement * segment size + offset
                                         
    16 bit test bootloader sample : ./mink64os/00.BootLoader/BootLoader16.asm

    
Day11:
    

    16 bit test bootloader sample : ./mink64os/00.BootLoader/BootLoader16.asm
    (to continue)   
        
        
Day12:

    16 bit test bootloader sample : ./mink64os/00.BootLoader/BootLoader16.asm
    
Day13:
    
    1. bios starts to load the boot loader
    2. the boot loader loads os image
    3. atfer os image loading, os code would be run
    4. To test, boot loader read the first part of each segment (there is string), ans shows message. if not, it generates errors
    5. at the last segment, it does loop.
    
Day14:

    ./mink64os/01.Kernel32/VirtualOS.asm
    
    
Day15:
    
    ./mink64os/01.Kernel32/make
     qemu-system-x86_64 -fda VirtualOS.bin -M pc
    
    VirtualOS.asm - comment
    
Day16:
    ./mink64os/Disk.img - error
    
Day17:

    review until Day16
    
Day18:
    
    ./mink64os/00.BootLoader/BootLoader16.asm -> BootLoader.bin
    ./mink64os/01.Kernel32/VirtualOS.asm -> VirtualOS.bin
    BootLoader.bin + VirtualOS.bin -> ./mink64os/Disk.img
    
    error on printing number, 11 times, expected 1024, trying fix it
    
    ./mink64os/makefile error - tab problem, trying fix it
    
Day19:

    to change real mode to protection mode
    1-5 : 16big real mode, 6 : 32 bit protective mode
    
    1. generating segment descriptor
    2. generating GDT information
    3. setting GDT information to processor
    4. setting CR0 control register
    5. changing cs segment selector by jmp command and turing to protective mode
    6. initializing segment selectors and stack
    7. running protective mode kernel
    
    
    1. Segment descriptor
        to show segment information
        code segment descriptor + data segment descriptor
        code segment descriptor => segment information which has runnable code and CS segment selector uses
        data segment descriptor => segment information which has data, other selector excepto CS segment selector use
        
        real mode segment register == protective mode segment selector
        
Day20:
    
    GDT global descriptor table = code segment descriptor + data segment descriptor
    (null descriptor)
    
    32bit, based on address 0, + offset, linear structure
    
    
Day21:

    ./mink64os/05.Assembly/assembly_test_32.txt
    
Day22:

    review until day 21
    
Day23:

    to trun protective mode
    
    1. to set GDTR register
    2. to set CR0 control register
    2. jmp command
    
    1. gdt information on processor
        lgdt [gdtr] ; to load gdt table to process
        
        + hold interrupts using cli command, to release cli to use 
        
    2. CR0 control register
        mov eax, 0x4000003b
        mov cr0, eax
        
Day24:

    ./mink649s/01.Kernel32/EntryPoint.s  (beginning)
        
    
Day24:
  
    ./mink649s/01.Kernel32/EntryPoint.s  (continue)
            
    
Day25:    

    ./mink64os/00.BootLoader$ nasm -o BootLoader.bin BootLoader16.asm
    ./mink64os/01.Kernel32$ nasm -o Kernel32.bin EntryPoint.s 
    ./mink64os$ cat 00.BootLoader/BootLoader.bin 01.Kernel32/Kernel32.bin > Disk.img
    error: warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]

Day26:

    to continue debuggin: maybe entrypoint.s problem - because bootloader16.asm and virtualos.bin worked
    
Day27:

    to continue to find out error part - not yet
    my guess : the book based on Win os, I am working on linux, maybe emulator has different config.
    Tomorrow , to check config nasm and qemu
    if I find, i will fix it, if not, I will change the book or process.
    
Day28:

    review code

Day32:

    Plan is changed. I need to study hardware architecture and assembly.
    
    book: great code 1 - understanding hardware
    
    1. what is the great code?
    - efficient ussage of CPU - fast
    - efficient usage of memory - small amount of code
    - efficient usage of system resource
    - easy to read and maintain
    - keeping to follow the codingstyle
    - keeping to follow the general software engineering method
    - easy to extend
    - well tested?
    - documentation
    
    2. number <> representation of number
    decimal, hexadecimal, octal, binary
    
    masm : 111011b or 111011B - binary
    hla : %11_1011 - binary
    
    hexa - Ox, -H, &H, $-
    
    
Day33:

    least significant bit, most significant bit
    
Day34:
    
    fixed point vs floating point
    
    
Day35:

    scaled numeric formats
    
Day36:
    
    bit operation
        
    
Day37:

    bit operation again
    
Day38:

    floating point
    
    
Day39:

    precision
    
Day40:

    char set and string
    
Day41:

    string
    
Day42:

    string
    
Day43:

    review
    
Day44 : 

    review
    
Day45 : 

    system bus : data bus, address bus, control bus
    
Day46:

    16 bit data bus, 32 bit data bus
    
Day47:

    big endian, small endian
    
Day48:

    review
    
Day49: 

    review
    
Day50:

    system clock