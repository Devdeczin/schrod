# schrod/_src/NIX/themes.nim
{.define: nimNoMain.}
import ioutils

type
  ThemeKind* = enum
        TClassicJazz,
        TQuarkCat

  Theme* = object
        test*, init*, ok*, sucess*, warn*, debug*, alive*, error*, bg*: VGAColor

const
  ClassicJazz* = Theme(
        test  : LightBlue,
        init  : LightBlue,
        ok    : LightGreen,
        warn  : Yellow,
        debug : LightGray,
        alive : Magenta,
        error : LightRed,
        bg    : Blue
  )

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

var
    ct* = ClassicJazz  # currentTheme

proc setTheme*(kind: ThemeKind) =
    case kind
    of TClassicJazz: ct = ClassicJazz
    of TQuarkCat:    ct = QuarkCat