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
    - RCS : counter register ( to count loop)
    - RDX : data register ( to sotre data )
    - RSI : source index register
    - RDI : destination index register
    - RBP ; bases pointer register ( to keep stack base address)
    - RSP : stack pointer resiter ( to store stack address current using)
    
    2. segment register : to extend memory addresses with general register
    - CS : segment address where to store  current program
    - DS : segment address where to store data using now
    - ES : segment address ?
    - SS : segmnet address where stack locates
    
    3. special register : developer cannot control it
    - RIP : instruction poinster ( address where to store next command )
    - eflag register : to show processor status, 32bit and each bit has its own meaning
    
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
            
    to create stack, 3 registers require. stack segment register
        1. stack segment register - ss, 
        2. base pointer register - bp,
        3. stack pointer register - sp
        
        ss for base address of the segment to use as stack
        (stack starts from ss, top)
        bp for stack base address
        (stack ends at bp, bottom)
        sp to indicate top of the stack
        (stack is full until sp, pop - move to bp, push - move to ss)
        
        
        
        