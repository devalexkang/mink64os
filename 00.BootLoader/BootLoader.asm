ORG 0x00  ; starting address is 0x000
BITS 16    ;16bit code

SECTION .text

jmp $  ; infiniti loop

times 510 - ( $ - $$ ) db 0x00

db 0x55
db 0xAA
