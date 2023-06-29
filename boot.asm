ORG 0x7C00
BITS 16

BOOT:
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

MESSAGE: DB 'Booting system...'

TIMES 510 - ($ - $$) DB 0
DW 0xAA55

