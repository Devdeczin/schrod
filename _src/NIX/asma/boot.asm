; _src/NIX/asma/boot.asm
; sinceramente, fiquei sem paciência de comentar sobre o boot
BITS 32
global _start
extern kmain

SECTION .multiboot
align 4
    dd 0x1BADB002
    dd 0x00000003
    dd -(0x1BADB002 + 0x00000003)

SECTION .bss
align 16
stack_bottom:
    resb 16384
stack_top:

SECTION .text
_start:
    cli
    
    ; stack correta
    mov esp, stack_top
    and esp, 0xFFFFFFF0

    cld

    call kmain

.hang:
    hlt
    jmp .hang