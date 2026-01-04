# schrod/_src/NIX/ioutils.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}

#import pythonfy as py
import ../drivers/vga

#======================================================================
# Kernel Fixed Cstring (KFC)
#======================================================================
# Nim normal tem c"" no system.nim, que transforma string em cstring
# Mas no kernel freestanding não temos isso
# kfc faz a mesma coisa: transforma em um array fixo de chars + '\0'
# - Imutável, seguro, sem runtime
# - Cada byte controlável manualmente
# (eu gosto muito de kfc inclusive)
#======================================================================
type
    KFCString* = array[256, char]  # sempre termina com '\0'

template kfc*(s: cstring): KFCString {.used.} =
    var arr: KFCString
    var i = 0
    while i < s.len and i < 255:  # len conhecido em tempo de compilação
        arr[i] = s[i]
        i += 1
    arr[i] = '\0'
    arr

#======================================================================
# VGA miscellaneous (nome longo, peguei do tradutor)
#======================================================================
# função adaptada do NimKernel (MIT License)
proc rainbow*(vram: PVIDMem, text: KFCString, pos: TPos) {.exportc, used.} =
    var colorBG = VGAColor.DarkGray
    var colorFG = VGAColor.Blue

    # porque nunca pensei em criar uma função dentro da função?
    # meu trabalho inútil facilitaria em mil vezes
    proc nextColor(color: VGAColor, skip: set[VGAColor]): VGAColor =
        var next = color
        while true:
            if next == VGAColor.White:
                next = VGAColor.Black
            else:
                next = VGAColor(ord(next) + 1)
            if not (next in skip):
                break
        next

    const skipColors = {
        VGAColor.Black, VGAColor.Cyan, VGAColor.DarkGray,
        VGAColor.Magenta, VGAColor.Red, VGAColor.Blue,
        VGAColor.LightBlue, VGAColor.LightMagenta
    }

    var i = 0
    while text[i] != '\0':
        colorFG = nextColor(colorFG, skipColors)
        vram[pos.x + i + pos.y * VGAWidth] =
            entry(text[i], colorFG, colorBG)
        i += 1

#======================================================================
# Controle do Cursor e outros mecanismos Físicos (eu quero desintegrar-)
#======================================================================
#proc moveCursor*(x, y: int) = discard
#proc hideCursor*() = discard
#proc showCursor*() = discard