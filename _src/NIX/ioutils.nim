# schrod/_src/NIX/ioutils.nim
{.define: nimNoMain.}

#import pythonfy as py

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

type
    #====================================================================
    # VGAColor:
    # Enumeração das cores suportadas pelo modo texto VGA.
    # Cada cor corresponde ao valor que o hardware espera (0-15).
    #--------------------------------------------------------------------
    # Ponto de atenção: sem valores explícitos = Nim atribui 0,1,2... automaticamente
    #--------------------------------------------------------------------
    VGAColor* = enum
        Black, Blue, Green, Cyan, Red, Magenta,
        Brown, LightGray, DarkGray, LightBlue, LightGreen,
        LightCyan, LightRed, LightMagenta, Yellow, White

    #====================================================================
    # TEntry / TAttribute / TPos:
    #--------------------------------------------------------------------
    # TEntry: combina um caractere e seu atributo de cor (foreground+background)
    # TAttribute: 8 bits, combina 4 bits de fg + 4 bits de bg
    # TPos: posição na tela (x, y)
    #--------------------------------------------------------------------
    TEntry* = distinct uint16
    TAttribute* = distinct uint8
    TPos* = tuple[x, y: int]

    #====================================================================
    # PVIDMem: ponteiro para a memória de vídeo VGA
    #--------------------------------------------------------------------
    # 80x25 = 2000 caracteres, mas reservamos 65001 entries por precaução
    # Para evitar o `..` que depende de system.nim, usamos tamanho literal
    # (que negócio chato)
    #--------------------------------------------------------------------
    PVIDMem* = ptr array[65001, TEntry]

#======================================================================
# Constantes de tela
#======================================================================
const
    VGAWidth*  = 80   # número de colunas
    VGAHeight* = 25   # número de linhas

#======================================================================
# Memória do VGA
#======================================================================
var vram*: PVIDMem = cast[PVIDMem](0xB8000)  # ponteiro direto para 0xB8000
# 0xB8000 é basicamente onde mora o VGA

#======================================================================
# Helpers
#======================================================================
proc entry*(c: char, fg, bg: VGAColor): TEntry =
    let ch: uint16 = uint16(c)
    let attr: uint16 = uint16(uint8(bg) shl 4 or uint8(fg))
    TEntry(ch or (attr shl 8))

#======================================================================
# Funções de escrita no VGA
#======================================================================
proc putChar*(x, y: int, c: char, fg, bg: VGAColor) {.exportc, used.} =
    # Coloca um caractere na posição (x,y) com cores fg/bg
    # Tudo direto na memória de vídeo, freestanding style
    let e = entry(c, fg, bg)
    vram[x + y * VGAWidth] = e

proc putString*(x, y: int, msg: KFCString, fg, bg: VGAColor) {.exportc, used.} =
    var i = 0
    var cx = x
    var cy = y
    while msg[i] != '\0':
        if cx >= VGAWidth:
            cx = 0
            cy += 1
        if cy >= VGAHeight: 
            break # isso pra ele não imprimir fora da tela
        putChar(cx, cy, msg[i], fg, bg)
        i += 1
        cx += 1

# função adaptada do NimKernel (MIT License)
proc rainbow*(vram: PVIDMem, text: KFCString, pos: TPos) {.exportc, used.} =
    var colorBG = VGAColor.DarkGray
    var colorFG = VGAColor.Blue

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
# Controle do Cursor e outros mecanismos Físicos
#======================================================================
#proc moveCursor*(x, y: int) = discard
#proc hideCursor*() = discard
#proc showCursor*() = discard