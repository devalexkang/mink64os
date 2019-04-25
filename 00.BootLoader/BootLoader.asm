ORG 0x00  ; starting address is 0x000
BITS 16    ;16bit code

SECTION .text

mov ax, 0xB800
mov ds, ax
mov byte [0x00], 'M'
mov byte [0x01], 0x4A

jmp $  ; infiniti loop

times 510 - ( $ - $$ ) db 0x00

db 0x55
db 0xAA
