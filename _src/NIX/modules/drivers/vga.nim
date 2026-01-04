# schrod/_src/NIX/modules/drivers/vga.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}

#======================================================================
# Constantes de tela
#======================================================================
const
    VGAWidth*  = 80   # número de colunas
    VGAHeight* = 25   # número de linhas
    #VGASize*   = VGAWidth * VGAHeight # pensei melhor, é bom usar estrutura mais kernel like

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
    PVIDMem* = ptr array[VGAWidth * VGAHeight, TEntry]

#======================================================================
# Memória do VGA
#======================================================================
var 
    vram*: PVIDMem = cast[PVIDMem](0xB8000) # ponteiro direto para 0xB8000, que é a memória do VGA
    cursorX* = 0
    cursorY* = 0

#======================================================================
# Helpers
#======================================================================
proc entry*(c: char, fg, bg: VGAColor): TEntry =
    let ch: uint16 = uint16(c)
    let attr: uint16 = uint16(uint8(bg) shl 4 or uint8(fg))
    TEntry(ch or (attr shl 8))