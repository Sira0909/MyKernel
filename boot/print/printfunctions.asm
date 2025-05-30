printstring:
	pusha
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

print_char_from_hex_as_dec:
	pusha
	cmp dl, 10
	jl hex_is_decimal
	mov al, dl
	add al, "a"
	sub al, 10
	int 0x10
	popa
	ret
hex_is_decimal:
	mov al, dl
	add al, "0"
	int 0x10
	popa
	ret

print_hex:
	pusha
	mov al, "0"
	int 0x10
	mov al, "x"
	int 0x10
	mov dl, bh
	shr dl, 4
	and dl, 0x0f
	call print_char_from_hex_as_dec
	mov dl, bh
	and dl, 0x0f
	call print_char_from_hex_as_dec
	mov dl, bl
	shr dl, 4
	and dl, 0x0f
	call print_char_from_hex_as_dec
	mov dl, bl
	and dl, 0x0f
	call print_char_from_hex_as_dec
	;mov al, bh
	;int 0x10
	;mov al, bl
	;int 0x10
	popa
	ret


HEX_OUT: db "0x0000", 0
