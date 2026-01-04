# schrod/_src/NIX/modules/drivers/keymap.nim
{.define: nimNoSystem.}
{.define: nimNoMain.}

import ../drivers/keyboard
import ../arch/pic

type 
    KernelEvent* = enum
        # útil: k = kernel
        kNone
        kNextTheme

        # inútil: uk = useless in kernel
        ukThereIsSomethingHappening
        ukDeadBeef

    Keymap* = array[128, char]

var lastEvent*: KernelEvent = kNone

# créditos ao osdev
# foi difícil de entender o que eles queriam dizer, foi,
# mas serviu: https://wiki.osdev.org/PS/2_Keyboard
const
    keymapLower*: Keymap = block:
        var km: Keymap
        km[0x01] = '\x1B'   # ESC
        km[0x02] = '1'
        km[0x03] = '2'
        km[0x04] = '3'
        km[0x05] = '4'
        km[0x06] = '5'
        km[0x07] = '6'
        km[0x08] = '7'
        km[0x09] = '8'
        km[0x0A] = '9'
        km[0x0B] = '0'
        km[0x0C] = '-'
        km[0x0D] = '='
        km[0x0E] = '\b'
        km[0x0F] = '\t'

        km[0x10] = 'q'
        km[0x11] = 'w'
        km[0x12] = 'e'
        km[0x13] = 'r'
        km[0x14] = 't'
        km[0x15] = 'y'
        km[0x16] = 'u'
        km[0x17] = 'i'
        km[0x18] = 'o'
        km[0x19] = 'p'
        km[0x1A] = '['
        km[0x1B] = ']'
        km[0x1C] = '\n'

        km[0x1E] = 'a'
        km[0x1F] = 's'
        km[0x20] = 'd'
        km[0x21] = 'f'
        km[0x22] = 'g'
        km[0x23] = 'h'
        km[0x24] = 'j'
        km[0x25] = 'k'
        km[0x26] = 'l'
        km[0x27] = ';'
        km[0x28] = '\''
        km[0x29] = '`'

        km[0x2B] = '\\'

        km[0x2C] = 'z'
        km[0x2D] = 'x'
        km[0x2E] = 'c'
        km[0x2F] = 'v'
        km[0x30] = 'b'
        km[0x31] = 'n'
        km[0x32] = 'm'
        km[0x33] = ','
        km[0x34] = '.'
        km[0x35] = '/'

        km[0x39] = ' '     # space
        km

    keymapUpper*: Keymap = block:
        var km: Keymap
        km[0x01] = '\x1B'
        km[0x02] = '!'
        km[0x03] = '@'
        km[0x04] = '#'
        km[0x05] = '$'
        km[0x06] = '%'
        km[0x07] = '^'
        km[0x08] = '&'
        km[0x09] = '*'
        km[0x0A] = '('
        km[0x0B] = ')'
        km[0x0C] = '_'
        km[0x0D] = '+'
        km[0x0E] = '\b'
        km[0x0F] = '\t'

        km[0x10] = 'Q'
        km[0x11] = 'W'
        km[0x12] = 'E'
        km[0x13] = 'R'
        km[0x14] = 'T'
        km[0x15] = 'Y'
        km[0x16] = 'U'
        km[0x17] = 'I'
        km[0x18] = 'O'
        km[0x19] = 'P'
        km[0x1A] = '{'
        km[0x1B] = '}'
        km[0x1C] = '\n'

        km[0x1E] = 'A'
        km[0x1F] = 'S'
        km[0x20] = 'D'
        km[0x21] = 'F'
        km[0x22] = 'G'
        km[0x23] = 'H'
        km[0x24] = 'J'
        km[0x25] = 'K'
        km[0x26] = 'L'
        km[0x27] = ':'
        km[0x28] = '"'
        km[0x29] = '~'

        km[0x2B] = '|'

        km[0x2C] = 'Z'
        km[0x2D] = 'X'
        km[0x2E] = 'C'
        km[0x2F] = 'V'
        km[0x30] = 'B'
        km[0x31] = 'N'
        km[0x32] = 'M'
        km[0x33] = '<'
        km[0x34] = '>'
        km[0x35] = '?'

        km[0x39] = ' '
        km