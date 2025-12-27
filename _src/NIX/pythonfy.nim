#schrod/_src/NIX/pythonfy.nim
{.define: nimNoMain.}

{.checks: off.}

#======================================================================
# Pythonfy: esse módulo serve para automatizar certas coisas complexas
# da mesma forma que fiz o putString para facilitar o putChar
# é basicamente o açúcar do python 
#======================================================================
import themes
import ioutils

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

#======================================================================
# para usar o kprint corretamente, use 'xy' para selecionar o valor do x e y ao mesmo tempo
# basta pegar o valor do x, some com o valor do y dobrado
template ksprint*(xy: int, s: cstring, ct: Theme, fg: untyped) = # kernel simple print
    let x = xy
    let y = xy div 2
    putString(x, y, s, ct.fg, ct.bg)

template kprint*(y: int, s: cstring, kind: static[ThemeKind]) =
    const ct = selectTheme(kind)
    putString(0, y, kfc(s), ct.ok, ct.bg)

template selectTheme*(kind: static[ThemeKind]): Theme =
    when kind == TQuarkCat:
        QuarkCat
    elif kind == TClassicJazz:
        ClassicJazz

#======================================================================
template hideCursor*() =
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