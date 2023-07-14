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

int_0x0_h: ;Interrupt 0 handler
    mov bx, INT_MSG ;print interrupt message
    call PRINTS
    iret ; ret from interrupt

BOOT:
    CLI; Critical code here, avoiding interrupts.

    mov ax, 0x00 ; overriding BIOS's STACK seg
    mov ss, ax ; stack segmentation lowest add
    mov sp, 0x7c00 ; stack pointer at the bottom of the stack
    mov ax, 0x7c0 ;overriding BIOS's segmentations DATA, EXTRA segs
    mov ds, ax ;data seg at 0x7c00
    mov es, ax ;extra seg at 0x7c00Interrupt handlers

    ;Interrupt handlers set
    mov word[ss:0x0], int_0x0_h ;int 0 in ss:0h
    mov word[ss:0x2], 0x7c0 ;TODO what is that?
    ;End interrupt handlers initialization

    STI; Returning interrupts. The code is no longer critical

    MOV BX, MESSAGE
    CALL PRINTS

    ;int 0 ;INTERRUPT
    
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

MESSAGE: DB ' AOS Booting... ',0
INT_MSG: DB ' int 0x0 ',0
DBG_MSG: DB ' ! ',0
DBG_MSG_1: DB ' 1 ',0
DBG_MSG_2: DB ' 2 ',0
DBG_MSG_3: DB ' 3 ',0

TIMES 510 - ($ - $$) DB 0
DW 0xAA55

