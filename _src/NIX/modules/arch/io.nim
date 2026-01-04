# schrod/_src/NIX/modules/arch/io.nim
# vulgo assassino de cobras mitológicas que devoram o próprio corpo
{.define: nimNoSystem.}
{.define: nimNoMain.}

proc inb*(port: uint16): uint8 {.inline.} =
    var value: uint8
    asm """
        inb %1, %0
        : "=a"(value)
        : "d"(port)
    """
    value

proc outb*(port: uint16, value: uint8) {.inline.} =
    asm """
        outb %0, %1
        :
        : "a"(value), "d"(port)
    """
