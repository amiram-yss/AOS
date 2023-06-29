ORG 0x7c00
BITS 16

boot:
    mov bx, message
    call prints
    jmp $

prints:
    mov al, [bx]
.print_loop:
    cmp al, 0
    je .print_complete
    call printc
    inc bx
    mov al, [bx]
    jmp .print_loop
.print_complete:
    ret

printc:
    mov ah, 0eh
    int 0x10
    ret

message: db 'Booting system...'

times 510 - ($ - $$) db 0
dw 0xAA55
