[bits 32]
	; Define some constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

;prints a null-terminated string pointed to by EXD
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY	;set edx to start of vid mem
print_string_pm_loop:
	mov al, [ebx]		; Store the char at EBX in AL
	mov ah, WHITE_ON_BLACK	; Store the attributes in AH

	cmp al, 0		; if (al==0), at end of string, so jump to done
	je print_string_pm_done

	mov [edx], ax		; Store char and attributes at current 
				; character cell.
	add ebx, 1		; increment EBX to the next char in string
	add edx, 2		; move to next char cell in vid mem.

	jmp print_string_pm_loop; loop around to print next char
	
print_string_pm_done:
	popa
	ret

