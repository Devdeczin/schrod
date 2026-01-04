ENTRY(_start)

SECTIONS
{
    /* multiboot DEVE estar no início do ELF */
    .multiboot :
    {
        KEEP(*(.multiboot))
    }

    /* agora sim, memória alta */
    . = 1M;

    .text :
    {
        *(.text*)
    }

    .rodata :
    {
        *(.rodata*)
    }

    .data :
    {
        *(.data*)
    }

    .bss :
    {
        *(COMMON)
        *(.bss*)
    }
}
