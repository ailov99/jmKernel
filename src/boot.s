	;; Kernel start location
	;; Also defines multiboot header

	MBOOT_PAGE_ALIGN	equ 1<<0       ; load kernel and modules on a page boundary
	MBOOT_MEM_INFO	    equ 1<<1       ; provide kernel with meminfo
	MBOOT_HEADER_MAGIC  equ 0x1BADB002 ; multiboot magic value
	;; no MBOOT_AOUT_KLUDGE == GRUB doesnt pass a symbol table
	MBOOT_HEADER_FLAGS  equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
	MBOOT_CHECKSUM      equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

	[BITS 32]					; all instructions are 32 bit

	[GLOBAL mboot]				; make "mboot" accessible from C
	[EXTERN code]				; start of '.text' section
	[EXTERN bss]				; start of '.bss' section
	[EXTERN end]                ; end of the last loadable section

mboot:
	dd MBOOT_HEADER_MAGIC		; GRUB searches for this value on each 4-byte boundary in kernel file
	dd MBOOT_HEADER_FLAGS		; how GRUB should load file/settings
	dd MBOOT_CHECKSUM			; to ensure above values are correct

	dd mboot 					; location of this descriptor
	dd code						; start of kernel '.text' section
	dd bss						; end of kernel '.data' section
	dd end						; end of kernel
	dd start					; kernel entry point (initial EIP)

	;; end of Multiboot-compliant structure
	
	[GLOBAL start]				; kernel entry point
	[EXTERN main]				; entry point of C code

start:
	push ebx					; load multiboot header location

	;; execute kernel
	cli							; disable interrupts
	call main					; call main()
	jmp $						; infinite loop
