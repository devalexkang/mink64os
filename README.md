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