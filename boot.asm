;ORG 0x7C00 obselete
ORG 0 ;origin 0
BITS 16

; Avoid BPV override
_fakeBpb:
    jmp short start; start process
    nop ; fill place with useless info so bpb wouldn't override anything essential.
    times 33 db 0

start:
    jmp 0x7c0:BOOT

BOOT:
    CLI; Critical code here, avoiding interrupts.

    mov ax, 0x00 ; overriding BIOS's STACK seg
    mov ss, ax ; stack segmentation lowest add
    mov sp, 0x7c00 ; stack pointer at the bottom of the stack
    mov ax, 0x7c0 ;overriding BIOS's segmentations DATA, EXTRA segs
    mov ds, ax ;data seg at 0x7c00
    mov es, ax ;extra seg at 0x7c00

    STI; Returning interrupts. The code is no longer critical
    MOV BX, MESSAGE
    CALL PRINTS
    JMP $

PRINTS:
    .PRINT_LOOP:
        MOV AL, [BX]
        CMP AL, 0
        JE .PRINT_COMPLETE
        CALL PRINTC
        INC BX
        JMP .PRINT_LOOP

    .PRINT_COMPLETE:
        RET

PRINTC:
    MOV AH, 0EH
    INT 0x10
    RET

MESSAGE: DB 'AOS Booting...'

TIMES 510 - ($ - $$) DB 0
DW 0xAA55

