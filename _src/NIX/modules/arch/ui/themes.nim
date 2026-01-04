# schrod/_src/NIX/modules/themes.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}

import ../../drivers/vga # negócio feio

type
    ThemeKind* = enum
        TClassicJazz = 0,
        TQuarkCat    = 1

    Theme* = object
        test*, init*, ok*, sucess*, warn*, debug*, alive*, error*, bg*: VGAColor

const
    # CRIADOR: @turrvideos (YouTube)
    # Estilo terminal clássico, vibes de Kitty
    # achei muito otimista
    # "naum gostei"
    ClassicJazz* = Theme(
        test   : LightBlue,
        init   : LightBlue,
        ok     : LightGreen,
        sucess : LightGreen,
        warn   : Yellow,
        debug  : LightGray,
        alive  : Magenta,
        error  : LightRed,
        bg     : Blue
    )

    # CRIADOR: Devdeczin (GitHub)
    # Minimalista, Arch-like
    QuarkCat* = Theme(
        test   : LightGray,
        init   : White,
        ok     : LightGreen,
        sucess : Green,
        warn   : Yellow,
        debug  : DarkGray,
        alive  : LightMagenta,
        error  : LightRed,
        bg     : Black
    )

const
    ThemeCount* = 2

    Themes*: array[0 .. ThemeCount-1, Theme] = [
        ClassicJazz,
        QuarkCat
    ]

var
    currentThemeIndex*: int = 0
    ct* = Themes[0]

proc setTheme*(kind: ThemeKind) =
    currentThemeIndex = int(kind)
    ct = Themes[currentThemeIndex]

proc nextTheme*(): Theme =
    result = ct # O Nim preenche o 'result' com o tema atual antes da troca
    currentThemeIndex = (currentThemeIndex + 1) mod ThemeCount
    ct = Themes[currentThemeIndex]