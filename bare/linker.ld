ENTRY(_start)

SECTIONS
{
	/* begin sections at 1MB */
	. = 1M;

	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.multiboot)
		*(.text)
	}

	.rodata BLOCK(4K) : ALIGN(4K)
	{
		*(.rodata)
	}

    /* rw init */
	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}

	/* rw uninit & stack */
	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
		*(.bootstrap_stack)
	}
}
