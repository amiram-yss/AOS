;ORG 0x7C00 obselete
ORG 0x7c00 ;origin 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt
DATA_SEG equ gdt_data - gdt

; Avoid BPB override
_fakeBpb:
    jmp short start; start process
    nop ; fill place with useless info so bpb wouldn't override anything essential.
times 33 db 0
 
start:
    jmp 0x0:boot

int_0x0_h: ;Interrupt 0 handler
    mov bx, INT_MSG ;print interrupt message
    call PRINTS
    iret ; ret from interrupt

boot:
    cli; Critical code here, avoiding interrupts.

;mov ax, 0x00 ; overriding BIOS's STACK seg
    xor ax, ax;     ; equiv to mov ax,0
    mov ss, ax ; stack segmentation lowest add
    mov sp, 0x7c00 ; stack pointer at the bottom of the stack
    ;mov ax, 0x7c0 ;overriding BIOS's segmentations DATA, EXTRA segs
    mov ds, ax ;data seg at 0x7c00
    mov es, ax ;extra seg at 0x7c00Interrupt handlers

    ;Interrupt handlers set
    mov word[ss:0x0], int_0x0_h ;int 0 in ss:0h
    mov word[ss:0x2], 0x7c0 ;TODO what is that?
    ;End interrupt handlers initialization

    sti; Returning interrupts. The code is no longer critical

.enter_protected_mode:
    cli
    lgdt[gdt_desc]
    mov eax, cr0
    or  eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:load_32

INT_MSG: DB ' int 0x0 ',0
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

; GDT init:
; src:  https://wiki.osdev.org/GDT_Tutorial
;       http://www.osdever.net/tutorials/view/the-world-of-protected-mode
;       https://wiki.osdev.org/Global_Descriptor_Table#Table
gdt:
gdt_null:
    dq 0x0
; Kernel Mode Code Segment
gdt_code:           ; CS points here
    dw 0xffff       ; Limit 16 bits
    dw 0x0          ; Base 16 bits
    db 0x0          ; Base (default value)
    db 10011010b    ; Access byte
    db 11001111b    ; Flags
    db 0x0          ; Base
gdt_data:           ; DS, SS, ES, FS, GS point here
    dw 0xffff       ; Limit 16 bits
    dw 0x0          ; Base 16 bits
    db 0x0          ; Base (default value)
    db 10010010b    ; Access byte [writing access granted]
    db 11001111b    ; Flags
    db 0x0          ; Base
gdt_end:

gdt_desc:
    dw gdt_end - gdt ; -1?
    dd gdt
 
[BITS 32]
load_32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp
    mov eax, 0xdeadbeef
    jmp $

times 510-($ - $$) db 0
dw 0xAA55