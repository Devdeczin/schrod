#!/bin/bash
set -e  # para quebrar no primeiro erro

# Cria pastas necessárias
mkdir -p bin/nixOF
mkdir -p build/nimcache
mkdir -p behiso/boot

# Monta arquivos .o do assembly
nasm -f elf32 asma/boot.asm -o bin/boot.o
nasm -f elf32 asma/stubs.asm -o bin/stubs.o
nasm -f elf32 asma/gtd.asm -o bin/gtd.o

# Compila Nim para C
finn c \
  --os:standalone \
  --cpu:i386 \
  --compileOnly \
  --noMain \
  --gc:none \
  --panics:off \
  --exceptions:goto \
  --overflowChecks:off \
  --rangeChecks:off \
  --boundChecks:off \
  --nilChecks:off \
  --assertions:off \
  -d:danger \
  -d:nimNoSystem \
  -d:nimBareMetal \
  --nimcache:build/nimcache \
  --passC:"-ffreestanding -fno-stack-protector -fno-builtin" \
  kmain.nim

# Remove arquivos system desnecessários
rm -f build/nimcache/@*system.nim.c
rm -f build/nimcache/@*system@*assertions*.nim.c

# Compila todos os arquivos .c do Nim
for c in build/nimcache/*.c; do
    gcc -c "$c" -o "bin/nixOF/$(basename "$c" .c).o" \
        -m32 -ffreestanding -nostdlib -fno-stack-protector -fno-builtin \
        -Ibuild/nimcache -I"$HOME/finn/lib"
done

# Linka tudo em ELF
ld -T bin/linker.ld -m elf_i386 \
    bin/*.o \
    bin/nixOF/*.o \
    -o bin/nixOUT/kernelIso0003-0001.elf

# Copia para a ISO de boot
cp bin/nixOUT/kernelIso0003-0001.elf behiso/boot/kernelIso0003-0001.elf

# Cria ISO com GRUB
mkdir -p bin/nixOUT/iso
grub-mkrescue -o bin/nixOUT/iso/schrod_BEH.iso behiso

# Roda no QEMU
#qemu-system-i386 \
#    -cdrom bin/nixOUT/iso/schrod_BEH.iso \
#    -vga std \
#    -display gtk \
#    -no-reboot \
#    -d guest_errors

# isso para caso esteja em arch/RebornOS, que foi meu caso
env -u LD_LIBRARY_PATH qemu-system-i386 -cdrom bin/nixOUT/iso/schrod_BEH.iso -vga std -display sdl -no-reboot -d guest_errors