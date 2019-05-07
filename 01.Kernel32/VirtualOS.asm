;1024 sector size

[org 0x00]
[bits 16]

section .text

jmp 0x1000:start

sectorcount: dw 0x0000


start:
    mov ax, cs
    mov ds, ax
    mov ax, 0xb800
    mov es, ax


    %assign i 0
    %rep totalsectorcount
        %assign i i+1

        mov ax, 2

        mul word [sectorcount]
        mov si, ax


        mov byte [es:si + (160*2) ], '0' + (i % 10)

        add word [sectorcount], 1


        %if i == totalsectorcount

            jmp $

        %else
            jmp (0x1000 + i * 0x20): 0x0000
        %endif

        times (512 - ($ - $$ ) % 512 ) db 0x00


    %endrep

