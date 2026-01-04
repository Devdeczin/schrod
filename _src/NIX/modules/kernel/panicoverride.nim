# schrod/_src/NIX/panicoverride.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}
import ../arch/ioutils

proc panic*(msg: cstring) {.exportc, noreturn.} =
    asm "cli"
    while true:
        asm "hlt"

proc rawoutput*(msg: cstring) {.exportc, noreturn.} =
    asm "cli"
    while true:
        asm "hlt"