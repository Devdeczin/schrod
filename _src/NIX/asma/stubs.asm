; schrod/_src/NIX/asma/stubs.asm
; aqui fica os stubs para o qemu não queimar no inferno
; vulgo: triple fault
BITS 32

global irq0_stub
global irq1_stub

; puxa os treco do nim para ele
extern irq0_handler
extern irq1_handler

irq0_stub:
    pushad
    call irq0_handler ; pega o irq0_handler do nim
    popad
    iret

irq1_stub:
    pushad

    push ds
    push es
    push fs
    push gs

    mov ax, 0x10      ; kernel data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call irq1_handler

    pop gs
    pop fs
    pop es
    pop ds

    popad
    iret