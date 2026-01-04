# schrod/_src/modules/arch/crossworld.nim
# Se, estruturalmente, não faz sentido eu fazer isso:
# gtd.nim: import pythonfy
# então vai ter essa ponte intermediária que expõe API
# ideia de girico? É, mas é a forma mais simples que achei de resolver esse demônio
# schrod/_src/modules/arch/crossworld.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}

import ../arch/ui/themes
import ../lang/pythonfy

type
    UiAction* = enum
        ToggleTheme
        ClearScreen

proc dispatch*(action: UiAction) =
    case action
    of ToggleTheme:
        # 1. Pega o tema antigo enquanto muda para o novo
        let oldTheme = nextTheme() 
        # 2. Aplica a tradução baseada na diferença entre eles
        applyTheme(oldTheme, ct)

    of ClearScreen:
        clearScreen(ct.ok, ct.bg)