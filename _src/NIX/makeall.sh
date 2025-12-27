nasm -f elf32 asma/boot.asm -o bin/boot.o

finn c \
  --os:standalone \
  --cpu:i386 \
  --compileOnly \
  --noMain \
  --app:staticlib \
  --gc:none \
  --panics:off \
  --exceptions:goto \
  --overflowChecks:off \
  --rangeChecks:off \
  --boundChecks:off \
  --nilChecks:off \
  --assertions:off \
  --panics:off \
  -d:danger \
  -d:nimNoSystem \
  -d:nimNoRuntime \
  -d:nimBareMetal \
  --nimcache:build/nimcache \
  --out:build/kernel \
  kernel.nim

gcc -c build/nimcache/*.c -ffreestanding -nostdlib -m32

gcc -c C_files/nim_runtime_stubs.c -m32 -ffreestanding -fno-builtin -nostdlib

gcc -c C_files/kernel_stubs.c   -ffreestanding   -nostdlib   -m32   -fno-stack-protector   -fno-builtin

#nixOF/@mlilsystem.nim.o \
#nixOF/@mpanicoverride.nim.o \
ld -T bin/linker.ld -m elf_i386 \
  bin/boot.o \
  bin/kernel_stubs.o \
  bin/nim_runtime_stubs.o \
  bin/nixOF/@mkmain.nim.o \
  bin/nixOF/@mioutils.nim.o \
  bin/nixOF/@mpythonfy.nim.o \
  bin/nixOF/@mthemes.nim.o \
  -o kernelIso0003.elf

grub-mkrescue -o bin/nixOUT/iso/schrod_BEH.iso behiso

qemu-system-i386   -cdrom bin/nixOUT/iso/schrod_BEH.iso   -display gtk   -vga std   -no-reboot   -d guest_errors