	# Constants used for creating a multiboot header
	.set ALIGN, 1<<0 	            # align loaded modules on page boundaries
	.set MEMINFO, 1<<1	            # provide memory map
	.set FLAGS,	ALIGN | MEMINFO	    # multiboot flag field
	.set MAGIC, 0x1BADB002          # let bootloader find header
	.set CHECKSUM, -(MAGIC + FLAGS) # checksum of above, proves multiboot

	# Declare standard multiboot header
	# Bootloader will search for this
	.section .multiboot
	.align 4
	.long MAGIC
	.long FLAGS
	.long CHECKSUM

	# Allocate small temporary stack (16384 bytes)
	# Symbols at bottom and top
	.section .bootstrap_stack, "aw", @nobits
stack_bottom:
	.skip 16384 # 16 KiB
stack_top:

	# Linker script specifies _start as entry point to kernel
	.section .text
	.global _start
	.type _start, @function
_start:	
	# ----- Start of kernel mode -----

	# set up a stack by setting ESP -> top
	movl $stack_top, %esp

	# call C entry point
	call kernel_main

	# go into infinite loop after function returns
	cli
	hlt
.Lhang:
	jmp .Lhang

	# _start symbol size = current location - its start
	# used in debugging and call tracing
	.size _start, . - _start
