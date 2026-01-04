# schrod/_src/NIX/modules/drivers/rspd.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}

import vga

import ../actions/crossworld
import ../arch/ui/themes
import ../lang/pythonfy
import ../misc/pub

proc translateScancode(sc: uint8, shift: bool): char =
    if sc >= 128: return '\0'
    if shift:
        keymapUpper[sc]
    else:
        keymapLower[sc]

proc dispatchKey*(sc: uint8, shift, ctrl: bool) =
    let ch = translateScancode(sc, shift)
    if ch == '\0': return

    if ctrl:
        case ch
        of 't', 'T': 
            dispatch(ToggleTheme)
        else:
            discard
    else:
        # isso faz o usuário conseguir escrever/sobrescrever na tela em cima dos textos existentes
        #ttyPutChar(ch)
        discard