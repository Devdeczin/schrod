#schrod/_src/NIX/pythonfy.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}

{.checks: off.}

#======================================================================
# Pythonfy: esse módulo serve para automatizar certas coisas complexas
# da mesma forma que fiz o putString para facilitar o putChar
# é basicamente o açúcar do python 
#======================================================================
import ../arch/ioutils
import ../arch/ui/themes
import ../arch/gtd
import ../arch/idt

import ../drivers/vga

var
    cursorX*: int = 0
    cursorY*: int = 0

proc clearScreen*(fg, bg: VGAColor) {.exportc, used.} =
    # Limpa a tela. Com vários ' '.
    # O que foi? Esperava mais?
    # ele usa MATEMÁTICA para isso, uau
    let clearEntry = entry(' ', fg, bg)
    var y = 0
    while y < VGAHeight:
        var x = 0
        while x < VGAWidth:
            vram[x + y * VGAWidth] = clearEntry
            x += 1
        y += 1

# um applyTheme bem mais inteligente, eu espero
proc applyTheme*(old: Theme, new: Theme) =
    for y in 0 ..< VGAHeight:
        for x in 0 ..< VGAWidth:
            let offset = x + y * VGAWidth
            let e = uint16(vram[offset])
            let c = char(e and 0xFF)
            let attr = uint8((e shr 8) and 0xFF)
            let fg = VGAColor(attr and 0x0F)
            # let bg = VGAColor((attr shr 4) and 0x0F) # Caso queira mapear BGs também

            var newFg = new.ok # Cor padrão se não houver match

            # Mapeamento inteligente:
            if fg == old.ok:      newFg = new.ok
            elif fg == old.sucess:  newFg = new.sucess
            elif fg == old.warn:    newFg = new.warn
            elif fg == old.error:   newFg = new.error
            elif fg == old.debug:   newFg = new.debug
            elif fg == old.alive:   newFg = new.alive
            elif fg == old.test:    newFg = new.test
            elif fg == old.init:    newFg = new.init

            vram[offset] = entry(c, newFg, new.bg)

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

# nunca use isso
# sei la, odeio ele sem motivo algum
proc ttyPutChar*(c: char) =
    if c == '\n':
        cursorX = 0
        inc cursorY
    else:
        putChar(cursorX, cursorY, c, ct.ok, ct.bg)
        inc cursorX

    if cursorX >= VGAWidth:
        cursorX = 0
        inc cursorY

    if cursorY >= VGAHeight:
        cursorY = VGAHeight - 1

#======================================================================
# para usar o ksprint corretamente, use 'xy' para selecionar o valor do x e y ao mesmo tempo
# basta pegar o valor do x, some com o valor do y dobrado
template ksprint*(xy: int, s: cstring, ct: Theme, fg: untyped) = # kernel simple print
    let x = xy
    let y = xy div 2
    putString(x, y, s, ct.fg, ct.bg)

template kbprint*(y: int, s: cstring, kind: static[ThemeKind]) = # kernel basic print
    const ct = selectTheme(kind)
    putString(0, y, kfc(s), ct.ok, ct.bg)

template kcprint*(x, y: int, s: cstring, fg, bg: VGAColor, kind: static[ThemeKind]) =
    const ct = selectTheme(kind)
    putString(x, y, kfc(s), ct.fg, ct.bg)

template selectTheme*(kind: static[ThemeKind]): Theme =
    when kind == TQuarkCat:
        QuarkCat
    elif kind == TClassicJazz:
        ClassicJazz

#======================================================================
template hideCursor*() = # eu te odeio TA&T
    asm """
        movw $0x3D4, %dx
        movb $0x0A, %al
        outb %al, %dx

        incw %dx
        movb $0x20, %al
        outb %al, %dx
    """

template hlt*() =
    #{.volatile.}:
    asm "hlt"

template cli*() =
    #{.volatile.}:
    asm "cli"

template sti*() =
    #{.volatile.}:
    asm "sti"

template nop*() =
    #{.volatile.}:
    asm "nop"


template idleloop*() =
    sti()
    while true:
        hlt()

template panicloop*() =
    cli()
    while true:
        hlt()