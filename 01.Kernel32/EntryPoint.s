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

    mov eax 0x4000003b;
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
    push ( swtchsuccessmessage - $$ + 0x10000 )
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




