# schrod/_src/NIX/kmain.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}
{.push noInit.}

import modules/arch/idt
import modules/arch/gtd
import modules/arch/pic
import modules/arch/ioutils
import modules/arch/ui/themes

import modules/lang/pythonfy

import modules/drivers/vga
import modules/drivers/keyboard {.all.}

proc kmain*() {.exportc, noreturn.} =
    # ===============================
    # Meu anti triple fault
    # virou parte do meu vocabulário
    # "triple fault"
    # ===============================
    cli()

    initGDT()
    remapPIC()
    initIDT()

    sti()

    # ===============================
    # Agora o kernel pode viver
    # ===============================
    setTheme(TQuarkCat)
    hideCursor()
    clearScreen(ct.init, ct.bg)

    putString(0, 0, kfc"Kernel Schrod: STARTING 'BEH!' VERSION", ct.init, ct.bg)

    rainbow(vram, kfc"WELCOME TO SCHROD", (x: 0, y: 2))

    putString(0, 4, kfc"[ OK ] VGA TEXT MODE is alive!", ct.alive, ct.bg)
    putString(0, 5, kfc"[ WARN ] This is a testing version, DON'T USE THIS IN YOUR MACHINE!", ct.warn, ct.bg)
    putString(0, 6, kfc"[ TEST ] Testing ilegal characters: ấ (what heck is that?), ṕ, ç, õ", ct.test, ct.bg)
    putString(0, 7, kfc"[ DEBUG ] Dumb debug", ct.debug, ct.bg)

    putString(0, 9, kfc"[ SUCCESS ] YAY!!!!!! >:)", ct.sucess, ct.bg)

    # =======================================================
    # Aqui vão ficar as funções que vão me dar ódio na alma:
    #   -idt, gtd | -teclado | -framebuffer | e outros
    # =======================================================

    # =======================================================
    # Loop principal do kernel
    # não usamos por agora o panicloop porque não usamos panic
    # (ainda)
    # =======================================================
    idleloop()