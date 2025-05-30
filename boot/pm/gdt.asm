; GDT
gdt_start:

gdt_null: 	; the mandatory null descriptor
	dd 0x0	; 'dd' means define double word, ie 4 bytes
	dd 0x0

gdt_code: ; the code segment descriptor
	;base=0x0, limit=0xfffff
	; 1st flags: (present)1 (privilage)00 (descriptor type)1 ->1001b
	; type flags: (code)1 (conformiing)0 (readable)1 (accessed)0 -> 1010b
	; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b
	dw 0xffff	; Limit
	dw 0x0		; Base (bits 0-15)
	db 0x0		; Base (bits 16-23)
	db 10011010b	; 1st flags, type flags
	db 11001111b	; 2nd flags, limit (bits 16-19)
	db 0x0		; Base(bits 24-31)

gdt_data:	;the data segment descriptor
	; Same as coede except for type flags
	; type flags: (code)0 (expand down)0 (writable)1 (accessed)0-> 0010b
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end:	; The reason for putting a label at the end of the 
		;GDT is so we can have assemblr calculate 
		;the size of the GDT for the GDT descriptor

gdt_descriptor:
	dw gdt_end - gdt_start - 1	;size of our GDt, always one less
					;than true size
	dd gdt_start			; Start addres of our GDt

; Define some handy constants for the GDT segment descriptor offsests, which
; are what segment registers must contain when in protected mode. For example,
; when we set DS = 0x10 in PM, the CPU knows that we mean it to use the
; segment dscribed at offset 0x10 (ie 16 bytes) in our GDT, which in 
; our case is the DATA segment (0x0-> NULL; 0x08 -> CODe; 0x10->DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
