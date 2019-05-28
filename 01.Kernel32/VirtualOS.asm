;1024 sector size

[org 0x00]  ; starting address is 0x00
[bits 16]   ; 16bit code

section .text   ; defition of text section (segment)

jmp 0x1000:start    ;  to copy 0x1000 to cs segment register and to move start label

sectorcount: dw 0x0000  ; to save current sector number
totalsectorcount equ 1024   ; total amount of sectors, maximum 1152 sectors ( 0x90000 byte )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; code area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


start:
    mov ax, cs      ; to set cs register value to ax register
    mov ds, ax      ; to set ax register value to ds register
    mov ax, 0xb800  ; to set video memory address 0xb800 to ax (segment) register
    mov es, ax      ; to set ES segment register


    %assign i 0     ; variable i = 0
    %rep totalsectorcount   ; to repeat totalsectorcount times
        %assign i i+1       ; i = i + 1

        mov ax, 2           ; to put 2 to ax register

        mul word [sectorcount]  ; ax register * sector number
        mov si, ax              ; to set previous mulplication result to si register


        mov byte [es:si + (160*2) ], '0' + (i % 10)     ;

        add word [sectorcount], 1           ; sector number + 1

        ; to next sector or loop
        %if i == totalsectorcount

            jmp $   ; loop

        %else
            jmp (0x1000 + i * 0x20): 0x0000  ; next sector offset
        %endif

        times (1024 - ($ - $$ ) % 1024) db 0x00
                    ; $ current section ( .text) starting address
                    ; $ - $$  offset based on current section
                    ; 512 - ($ - $$) % 512 from current address untill address 512
                    ; db 0x00 1byte <= 0x00
                    ;times  loop
                    ; from current address until address 512, to fill 0x00


    %endrep

