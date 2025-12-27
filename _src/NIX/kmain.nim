#schrod/_src/NIX/kmain.nim
{.define: nimNoMain.}
{.push noInit.}

import pythonfy
import ioutils
import themes

proc kmain*() {.exportc, noreturn.} =
    setTheme(TQuarkCat)
    hideCursor()
    clearScreen(ct.init, ct.bg)

    putString(0, 0, kfc"Kernel Schrod: STARTING 'BEH!' VERSION", ct.init, ct.bg)

    rainbow(vram, kfc"WELCOME TO SCHROD", (x: 0, y: 2))
    
    putString(0, 4, kfc"[ OK ] VGA TEXT MODE is alive!", ct.alive, ct.bg)
    putString(0, 5, kfc"[ WARN ] This is a testing version, DON'T USE THIS IN YOUR MACHINE!", ct.warn, ct.bg)
    putString(0, 6, kfc"[ TEST ] Testing ilegal charactes: ấ, ṕ, ç, õ", ct.test, ct.bg)
    putString(0, 7, kfc"[ DEBUG ] Dumb debug", ct.debug, ct.bg)

    putString(0, 9, kfc"[ SUCESSX ] YAY!!!!!! >:)", ct.sucess, ct.bg)

    var testPos: TPos = (x: 0, y: 4)
    var i = 0
    while i < 10:
        putChar(testPos.x + i, testPos.y, ' ', ct.error, ct.bg)
        i += 1

    cli()
    while true:
        hlt()