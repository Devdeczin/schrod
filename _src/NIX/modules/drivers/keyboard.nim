# schrod/_src/NIX/modules/drivers/keyboard.nim
{.define: nimNoMain.}
{.define: nimNoSystem.}

import ../arch/io
import ../arch/pic

import ../actions/crossworld

import ../lang/pythonfy

import rspd

var
    shiftDown = false
    ctrlDown  = false
    lastkey*: uint8 


proc debugScancode(sc: uint8) =
    # converte o número em caractere decimal simples
    let hundreds = sc div 100 + '0'.ord
    let tens     = (sc mod 100) div 10 + '0'.ord
    let ones     = (sc mod 10) mod 10 + '0'.ord

    ttyPutChar(char(hundreds))
    ttyPutChar(char(tens))
    ttyPutChar(char(ones))
    ttyPutChar('\n')

proc keyboardIRQ*() {.cdecl.} =
    let sc = inb(0x60)  # lê o scancode

    # Shift e Ctrl
    case sc
    of 0x2A, 0x36: shiftDown = true
    of 0xAA, 0xB6: shiftDown = false
    of 0x1D: ctrlDown = true
    of 0x9D: ctrlDown = false
    else:
        if sc < 0x80:
            dispatchKey(sc, shiftDown, ctrlDown)

proc keyboard_handler*() {.exportc, cdecl.} =
    let sc = inb(0x60)

    case sc
    of 0x2A, 0x36: shiftDown = true
    of 0xAA, 0xB6: shiftDown = false
    of 0x1D: ctrlDown = true
    of 0x9D: ctrlDown = false
    else:
        if sc < 0x80:
            dispatchKey(sc, shiftDown, ctrlDown)