[org 0x00]
[bits 16]

section .text

jmp 0x07c0:start

;;;;;;;;;;;;;;;;;;;;;
;environment setting parameteres
;;;;;;;;;;;;;;;;;;;;;

totalsectorcount: dw 1024



;;;;;;;;;;;;;;;;;;;
;code area
;;;;;;;;;;;;;;;;;;;
start:
    mov ax, 0x07c0
    mov ds, ax
    mov ax, 0xb800
    mov es, ax



    mov ax, 0x0000
    mov ss, ax
    mov sp, 0xfffe
    mov bp, 0xfffe


;;;;;;;;;;;;;;;;;;
; clean the screen
;;;;;;;;;;;;;;;;;;;

    mov si, 0


.screenclearloop:
    mov byte [es:si], 0
    mov byte [es:si +1], 0x0a
    add si, 2
    cmp si, 80*25*2
    jl .screenclearloop


;;;;;;;;;;;;;;;;;;
; starting message
;;;;;;;;;;;;;;;;;;

    push message1
    push 0
    push 0
    call printmessage
    add sp, 6


;;;;;;;;;;;;;;;;;;
;loading message
;;;;;;;;;;;;;;;;;;
    push imageloadingmessage
    push 1
    push 0
    call printmessage
    add sp, 6

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

mov ax, 0
mov dl, 0
int 0x13

jc handlediskerror



