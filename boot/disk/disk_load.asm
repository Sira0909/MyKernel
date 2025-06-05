; load DH sectors to ES : BX from drive DL
disk_load:	
	push dx	 	; Store DX on stack so later we can recall
			; how many sectors were request to be read ,
			; even if it is altered in the meantime

	mov ah, 0x02	; BIOS read sector function
	mov al, dh	; Read DH sectors
	mov ch, 0x00	; Select cylinder 0
	mov dh, 0x00	; select head 0
	mov cl, 0x0a	; Start reading from second sector, ie
			; after boot sector)

	int 0x13	;now issue the BIOS interrupt to do the actual read

	; Check that the disk was successfully read
	jc disk_error	; jc jumps if carry flag set
	
	pop dx		; Restore DX from stack
	cmp dh, al	; if AL (sectors read) != DH (sectors expected)
	jne disk_error	;	display error message
	ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call printstring
	jmp $

DISK_ERROR_MSG: db "DISK READ ERROR!", 0
