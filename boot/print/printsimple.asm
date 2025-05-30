[bits 16]
printstring:
	pusha
	mov ah, 0x0e
startloopprintstr:
	mov al, [bx] 
	cmp al, 0
	jne continueprintstr
	popa
	ret
continueprintstr:
	add bx,1
	int 0x10
	jmp startloopprintstr


println:
	pusha
	call printstring
	mov al, 10
	int 0x10
	mov al, 13
	int 0x10
	popa
	ret
