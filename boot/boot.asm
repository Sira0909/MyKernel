[org 0x7c00]
KERNEL_OFFSET equ 0x1000	; This is the offset to which we will louad our kernel

	mov [BOOT_DRIVE], dl	; BIOS stores boot drive in DL, save to remember

	mov bp, 0x9000	;set the stack
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call printstring

	call load_kernel	;load our kernel
	call switch_to_pm	;Note that we never return from here

	jmp $

%include "boot/print/printsimple.asm"
%include "boot/disk/disk_load.asm"
%include "boot/pm/gdt.asm"
%include "boot/pm/print_string_pm.asm"
%include "boot/pm/enter32bit.asm"
[bits 16]
	
;load_kernel
load_kernel:
	mov bx, MSG_LOAD_KERNEL	; print a message to say loading kernel
	call printstring

	mov bx, KERNEL_OFFSET
	mov dh, 50
	mov dl, [BOOT_DRIVE]
	call disk_load

	ret

[bits 32]

BEGIN_PM:
	
	mov ebx, MSG_PROT_MODE
	call print_string_pm	;use our 32-bit print routine.

	call KERNEL_OFFSET 
	jmp $			;Hang

BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "loading kernel into memory.", 0

	times 510 - ($-$$) db 0
	dw 0xaa55
