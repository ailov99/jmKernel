/* Linked script for the kernel */

ENTRY(start)
/*
STARTUP(Boot.o)
MEMORY
{
	ROM (rx) : ORIGIN = 0, LENGTH = 256k
	RAM (wx) : org = 0x00100000, len = 1M
}
INPUT(...o ...o)
OUTPUT(Kernel.bin)
*/
SECTIONS
{
  /* "code" section starts at 1MB */
  /* objdump -drS .process.o */
  .text 0x100000 :
  {
    code = .; _code = .; /* extern "C" void _code */
	*(.text)
	. = ALIGN(4096);
  }

  /* Initialised static data */
  /* objdump -s -j .data.process.o */
  /* objdump -s -j .rodata.process.o */
  .data :
  {
    data = .; _data = .;
	*(.data)
	*(.rodata) /* bundle gcc's rodata */
	. = ALIGN(4096);
  }
 
  /* Uninitialised static data (zeroes)  */
  .bss :
  {
    bss = .; _bss = .;
	*(.bss)
	. = ALIGN(4096);
  }

  end = .; _end = .;
}
