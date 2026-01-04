# schrod/_src/NIX/modules/drivers/timer.nim
# Até agora, irei usar um sistema básico de ticks
# na próxima atualização, irei implementar o bips_and_ticks
# que é um tick mais sofisticado
type
    Timer* = object
        ticks*: int

# Timer global
var timer*: Timer

# Inicializa o timer
proc initTimer*(): void =
    timer.ticks = 0

# Incrementa ticks
proc tick*(t: var Timer) =
    t.ticks += 1

# Lê ticks atuais
proc readTicks*(t: Timer): int =
    t.ticks