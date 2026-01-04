# schrod/_src/NIX/modules/idt.nim
# Satanás do Triple Fault
{.define: nimNoMain.}
{.define: nimNoSystem.}

import gtd
import irq

type
    IDTEntry {.packed.} = object
        offsetLow: uint16
        selector: uint16
        zero: uint8
        flags: uint8
        offsetHigh: uint16

    IDTR {.packed.} = object
        limit: uint16
        base: uint32

var
    idt*: array[256, IDTEntry]
    idtr*: IDTR

proc lidt*(p: ptr IDTR) {.inline.} =
    asm """
        lidt (%0)
        :
        : "r"(p)
    """

proc setGate*(n: int, handler: pointer) =
    let addr32 = cast[uint32](handler)
    idt[n] = IDTEntry(
        offsetLow:  uint16(addr32 and 0xFFFF),
        selector:   0x08,
        zero:       0,
        flags:      0x8E,
        offsetHigh: uint16(addr32 shr 16)
    )

proc makeGDTEntry*(base: uint32, limit: uint32, access: uint8, gran: uint8): GDTEntry =
    result.limitLow = uint16(limit and 0xFFFF)
    result.baseLow  = uint16(base and 0xFFFF)
    result.baseMid  = uint8((base shr 16) and 0xFF)
    result.access   = access
    result.gran     = uint8(((limit shr 16) and 0x0F) or (gran and 0xF0))
    result.baseHigh = uint8((base shr 24) and 0xFF)

proc loadGDT*() =
    asm """
        # Carrega direto do endereço de memória do label 'kernel_gdtr'
        lgdt kernel_gdtr

        # Recarrega segmentos
        movw $0x10, %ax
        movw %ax, %ds
        movw %ax, %es
        movw %ax, %fs
        movw %ax, %gs
        movw %ax, %ss

        # Jump
        ljmp $0x08, $flush_gdt
    flush_gdt:
    """

proc irq0_stub*() {.importc, cdecl.}
proc irq1_stub*() {.importc, cdecl.}
proc panic_stub*() {.importc, cdecl.}

# eu odeio idt (por algum motivo, pronuncio itd)
proc initIDT*() =
    idtr.limit = uint16(sizeof(idt) - 1)
    idtr.base  = cast[uint32](addr idt[0])

    setGate(0x20, cast[pointer](irq0_stub))
    setGate(0x21, cast[pointer](irq1_stub))

    lidt(addr idtr)
