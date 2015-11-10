# Compiles all in SOURCES and links
# into one ELF binary using link.ld


SOURCES=boot.o main.o
CFLAGS=-m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector
LDFLAGS=-melf_i386 -Tlink.ld
ASFLAGS=-felf32

all: $(SOURCES) link

clean:
	-rm *.o kernel

link:
	ld $(LDFLAGS) -o kernel $(SOURCES)

.s.o:
	nasm $(ASFLAGS) $<
