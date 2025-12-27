# schrod/_src/NIX/panicoverride.nim
{.define: nimNoMain.}

import ioutils

proc panic*(msg: cstring) {.exportc, noreturn.} =
    asm "cli"
    while true:
        asm "hlt"

proc rawoutput*(msg: cstring) {.exportc, noreturn.} =
    asm "cli"
    while true:
        asm "hlt"