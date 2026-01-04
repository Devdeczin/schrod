# schrod/_src/NIX/modules/drivers/gtd.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}

type
    GDTEntry* {.packed.} = object
        limitLow*: uint16
        baseLow*: uint16
        baseMid*: uint8
        access*: uint8
        gran*: uint8
        baseHigh*: uint8


    GDTR* {.packed.} = object
        limit*: uint16
        base*: uint32

var
    gdt*: array[3, GDTEntry]
    gdtr* {.exportc: "kernel_gdtr".}: GDTR

proc loadGDT*() {.cdecl, importc.}

proc makeGDTEntry*(base: uint32, limit: uint32, access: uint8, gran: uint8): GDTEntry =
    result.limitLow = uint16(limit and 0xFFFF)
    result.baseLow  = uint16(base and 0xFFFF)
    result.baseMid  = uint8((base shr 16) and 0xFF)
    result.access   = access
    result.gran     = uint8(((limit shr 16) and 0x0F) or (gran and 0xF0))
    result.baseHigh = uint8((base shr 24) and 0xFF)

proc initGDT*() =
    gdt[0] = makeGDTEntry(0, 0, 0, 0)

    gdt[1] = makeGDTEntry(
        0,
        0xFFFFF,
        0x9A,
        0xCF
    )

    gdt[2] = makeGDTEntry(
        0,
        0xFFFFF,
        0x92,
        0xCF
    )

    gdtr.limit = uint16(sizeof(gdt) - 1)
    gdtr.base  = cast[uint32](addr gdt[0])

    loadGDT()