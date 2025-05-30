
[bits 16]
	
switch_to_pm:

	cli		;clear all interupts

	lgdt [gdt_descriptor]	;load gdt table

	mov eax, cr0	; to make the switch, set the first bit of CRO, a 
	or eax, 0x1	; control register
	mov cr0, eax	; update cr0

	jmp CODE_SEG:init_pm

[bits 32]

init_pm:
			;By now we are assuredly in 32-bit protected mode.
	mov ax, DATA_SEG	;old segments now meaningless in PM,
	mov ds, ax		; so point seg regs to data selector defined
	mov es, ax		; in GDT
	mov ss, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000	; update stack position so right att the top of the
	mov esp, ebp		;free space

	call BEGIN_PM		;call some well known label
