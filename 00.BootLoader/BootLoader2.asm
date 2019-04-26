[org 0x00]
[bits 16]

section .text

jmp 0x07c0:start

start:
    mov ax, 0x07c0
    mov ds, ax
    mov ax, 0xb800
    mov es, ax

    mov si, 0


.screenclearloop:
    mov byte [es:si],0
    mov byte [es:si +1], 0x0a

    add si, 2

    cmp si , 80*25*2

    jl .screenclearloop

    mov si, 0
    mov di, 0

.messageloop:
    mov cl, byte [si + message1]
    cmp cl, 0
    je .messageend
    mov byte [es:di], cl

    add si, 1
    add di, 2

    jmp .messageloop

.messageend:
    jmp $

message1: db 'mint64 os boot loader start : hello world', 0

times 510 - ($ - $$) db 0x00

db 0x55
db 0xAA