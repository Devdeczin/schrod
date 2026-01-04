# schrod/_src/NIX/modules/drivers/pic.nim
{.define: nimNoSystem.}
{.define: nimNoMain.}

import io

const
    PIC1 = 0x20'u16
    PIC2 = 0xA0'u16
    PIC1_COMMAND = PIC1
    PIC1_DATA    = PIC1 + 1
    PIC2_COMMAND = PIC2
    PIC2_DATA    = PIC2 + 1
    PIC_EOI = 0x20'u8

proc sendEOI*(irq: uint8) =
    if irq >= 8:
        outb(PIC2_COMMAND, PIC_EOI)
    outb(PIC1_COMMAND, PIC_EOI)

proc irq0_handler*() {.exportc, cdecl.} =
    sendEOI(0)

# pelo visto, isso assassina o input do teclado
#[ proc irq1_handler*() {.exportc, cdecl.} =
    discard inb(0x60)
    sendEOI(1) ]#

proc remapPIC*() =
    outb(PIC1_COMMAND, 0x11)
    outb(PIC2_COMMAND, 0x11)

    outb(PIC1_DATA, 0x20) # IRQs 0–7  → 0x20–0x27
    outb(PIC2_DATA, 0x28) # IRQs 8–15 → 0x28–0x2F

    outb(PIC1_DATA, 0x04)
    outb(PIC2_DATA, 0x02)

    outb(PIC1_DATA, 0x01)
    outb(PIC2_DATA, 0x01)

    outb(PIC1_DATA, 0x0)
    outb(PIC2_DATA, 0x0)