[org 0x00]          ; set 0x00 as code starting address
[bits 16]           ; 16 bit code

section .text       ; test section - segment

jmp 0x07c0:start    ; to move to start label, put 0x07c0 to cs segment register

;;;;;;;;;;;;;;;;;;;;;
;environment setting parameteres
;;;;;;;;;;;;;;;;;;;;;

totalsectorcount: dw 1024   ; os image capacity - max 1152 sector 0x90000 byte



;;;;;;;;;;;;;;;;;;;
;code area
;;;;;;;;;;;;;;;;;;;
start:
    mov ax, 0x07c0      ; bootloader starting address 0x7c00 -> ax, segment register
    mov ds, ax          ; ax -> ds
    mov ax, 0xb800      ; video memory starting address 0xb800 -> ax, segment register
    mov es, ax          ; as -> es


    ;to make stack , 0x0000:0000 - 0x0000:ffff  64 kb size
    mov ax, 0x0000
    mov ss, ax
    mov sp, 0xfffe
    mov bp, 0xfffe


;;;;;;;;;;;;;;;;;;
; clean the screen
;;;;;;;;;;;;;;;;;;;

    mov si, 0           ; to initialize si register (index of string, message)


.screenclearloop:               ; to clear screen
    mov byte [es:si], 0         ; to input 0 into video meemory address for character
    mov byte [es:si +1], 0x0a   ; to input 0x0a into video memory address for background coloer
    add si, 2                   ; to next step , + 2 byte
    cmp si, 80*25*2             ; to check whether the end of screen or not
    jl .screenclearloop         ; if not loop to clear


;;;;;;;;;;;;;;;;;;
; starting message
;;;;;;;;;;;;;;;;;;

    push message1               ; to put message address into stack
    push 0                      ; to input x value into stack
    push 0                      ; to input y value into stack
    call printmessage           ; to call function
    add sp, 6                   ; to delete used parameters


;;;;;;;;;;;;;;;;;;
;loading message
;;;;;;;;;;;;;;;;;;
    push imageloadingmessage    ; to put message address into stack
    push 1                      ; to input x value into stack
    push 0                      ; to input y value into stack
    call printmessage           ; to call function
    add sp, 6                   ; to delete used parameters

;;;;;;;;;;;;;;;;;;
;loading os image for disk
;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;
;reset before loading
;;;;;;;;;;;;;;;;;;;

resetdisk;

;;;;;;;;;;;;;;;;;;;
; call bios reset function
;;;;;;;;;;;;;;;;;;;

    mov ax, 0                   ; service number 0, floppy = 0
    mov dl, 0
    int 0x13

    jc handlediskerror          ; to hanle error


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;read sector from disk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
    mov si, 0x1000              ;  es:bx <- 0x10000 <- disk contents
    mov es, si
    mov bx, 0x0000              ; to set address 0x1000:00000


    mov di, word [totalsectorcount]     ; to put sector amount into DI register

readdata:

    cmp di, 0               ;
    je readend
    sub di, 0x1

    ;;;;;;;;;;;;;;;;
    ;call bios read function
    ;;;;;;;;;;;;;;;;

    mov ah, 0x02
    mov al, 0x1
    mov ch, byte [tracknumber]
    mov cl, byte [sectornumber]
    mov dh, byte [headnumber]
    mov dl, 0x00
    int 0x13
    jc handlediskerror

    ;;;;;;;;;;;;;;;;;;;;;;;
    ;to calculate track, head, secotr address
    ;;;;;;;;;;;;;;;;;;;;;;;

    add si, 0x0020
    mov es, si


    mov al, byte [sectornumber]
    add al, 0x01
    mov byte [sectornumber], al
    cmp al, 19
    jl readdata



    xor byte [headnumber], 0x01
    mov byte [sectornumber], 0x01


    cmp byte [headnumber], 0x00

    jne readdata

    add byte [tracknumber], 0x01
    jmp readata

readend:


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; to print message about os image completion
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push loadingcompletemessage
    push 1
    push 20
    call printmessage
    add sp, 6

    ;;;;;;;;;;;;;;;;
    ;to run os image
    ;;;;;;;;;;;;;;;;
    jmp 0x1000:0x0000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function code area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; to handle disk errors

handlediskerror:
    push diskerrormessage
    push 1
    push 20
    call printmessage

    jmp $


; function to print message
; parameter : x value, y value, string

printmessage:
    push bp
    mov pb, sp

    push es
    push si
    push di
    push ax
    push cx
    push dx

    mov ax, 0xb800
    mov es, ax

    ;;;;;;;;;;;;;;;;;;;;;;;;
    ; to calculate video memory address of x, y value
    ;;;;;;;;;;;;;;;;;;;;;;;;

    ; y values for line address

    mov ax, word [bp +6]
    mov si, 160
    mul si
    mov di, ax


    ; x values for final address


    mov ax, word [bp + 4]
    mov si, 2
    mul si
    add di, ax

    ; final address of string
    mov si, word [bp +8]


.messageloop:
    mov cl, byte [si]

    cmp cl, 0
    je .messageend

    mov byte [es:di], cl

    add si, 1
    add di, 2

    jmp .messageloop

.messageend:
    pop dx
    pop cx
    pop ax
    pop di
    pop si
    pop es
    pop bp
    ret


;;;;;;;;;;;;;;;;;;;;;
; data area
;;;;;;;;;;;;;;;;;;;;;
; boot loader starting message

message1: db 'mint64 os boot loader start', 0

diskerrormessage: db 'disk error', 0
imageloadingmessage: db 'os image loading', 0
loadingcompletemessage: db, 'complete', 0

;parameters about disk reading
sectornumber: db 0x02
headnumber: db 0x00
tracknumber: db 0x00


times 510 - ($ - $$) db 0x00


db 0x55
db 0xaa
