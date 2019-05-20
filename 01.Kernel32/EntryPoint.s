; protected mode and initialization

[org 0x00]      ; starting address 0x00
[bits 16]       ; 16bit code


section .text

;;;;;;;;;;;;;;;;;;;;;;;;
;code area
;;;;;;;;;;;;;;;;;;;;;;;

start:
    mov ax, 0x1000
    mov ds, ax
    mov es, ax

    cli         ; to stop interrupt
    lgdt [ gdtr ] ; to load gdt

    ;;;;;;;;;;;;;;;;;;;;;;
    ;disable paging+cache+ internal FPU + align check
    ;;;;;;;;;;;;;;;;;;;;;;

    mov eax, 0x4000003b;
    mov cr0, eax

    jmp dword 0x08: (protectedmode - $$ + 0x10000 )



[bits 32]       ; 32 bit code
protectedmode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; stack 64k size at 0x00000000 - 0x0000ffff
    mov ss, ax
    mov esp, 0xfffe
    mov ebp, 0xfffe

    ; show message about protected mode
    push ( switchsuccessmessage - $$ + 0x10000 )
    push 2
    push 0
    call printmessage
    add esp, 12

    jmp $   ; infinite loop

;;;;;;;;;;;;;;;;;;;;;;;
;code about function
;;;;;;;;;;;;;;;;;;;;;;

printmessage:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push eax
    push ecx
    push edx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;x, y coordinates of video memory address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov eax, dword [ ebp + 12 ]
    mov esi, 160
    mul esi
    mov edi, eax

    mov eax, dword [ebp + 8 ]
    mov esi, 2
    mul esi
    add edi, eax


    mov esi, dword [ ebp + 16 ]


.messageloop:
    mov cl, byte [esi]

    cmp cl, 0
    je .messageend

    mov byte [ edi + 0xb8000 ], cl

    add esi, 1
    add edi, 2

    jmp .messageloop

.messageend:
    pop edx
    pop ecx
    pop eax
    pop edi
    pop esi
    pop ebp
    ret


;;;;;;;;;;;;;;;;;;;;;;
; data area
;;;;;;;;;;;;;;;;;;;;;;

align 8, db 0


dw 0x0000

; definition gdtr structure

gdtr:
    dw gdtend - gdt - 1
    dd ( gdt - $$ + 0x10000 )


; definition of gdt table

gdt:
; null descriptor, 0

nulldescriptor:
    dw 0x0000
    dw 0x0000
    db 0x00
    db 0x00
    db 0x00
    db 0x00


; protective mode kernel - code segment descriptor

codedescriptor:
    dw 0xffff
    dw 0x0000
    dw 0x00
    db 0x9a
    db 0xcf
    db 0x00
    dw 0xffff
    dw 0x0000
    db 0x00
    db 0x92
    db 0xcf
    db 0x00

gdtend:

switchsuccessmessage: db 'switch to protected model success', 0

times 512 - ( $ - $$ ) db 0x00



