#!/bin/bash
CC32="$HOME/opt/cross/bin/i686-elf-gcc"

$CC32 -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
$CC32 -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

grub-mkrescue -o myos.iso isodir
