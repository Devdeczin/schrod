# schrod/_src/NIX/modules/arch/irq.nim
import ../drivers/keyboard
import ../drivers/timer
import pic

var tick: Timer

# IRQ0: Timer
proc irq0_handler*() {.cdecl.} =
    tick(tick)
    sendEOI(0)   # avisa o PIC

# IRQ1: Teclado
proc irq1_handler*() {.cdecl, exportc.} =
    keyboardIRQ() # processa a tecla
    sendEOI(1)    # avisa o PIC