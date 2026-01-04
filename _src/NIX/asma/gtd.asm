; schrod/_src/NIX/asma/gtd.asm
BITS 32
GLOBAL loadGDT
EXTERN kernel_gdtr

loadGDT:
    lgdt [kernel_gdtr]

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x08:flush_gdt   ; far jump para recarregar CS

flush_gdt:
    ret