# mink64os
project to make OS

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
    