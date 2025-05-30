all: os-image.bin

C_SOURCES= ${wildcard kernel/*.c drivers/*.c}
HEADERS = ${wildcard kernel/*.h drivers/*.c}

OBJ = ${C_SOURCES:.c=.o}
os-image.bin: boot/boot.bin kernel.bin 
	cat $^ > os-image.bin

kernel.bin: kernel/kernel_entry.o ${OBJ} kernel/kernel_padding.o
	ld -o kernel.bin -Ttext 0x1001 kernel/kernel_entry.o kernel/kernel.o  -m elf_i386

%.o : %.c ${HEADERS}
	gcc -m32 -ffreestanding -c $< -o $@ 

%.o : %.asm
	nasm $< -f elf32 -o $@


%.bin : %.asm
	nasm $< -f bin -o $@

cleanfull:
	rm  kernel/*.o boot/*.bin drivers/*.o
	rm  *.bin *.o os-image
clean:
	rm  kernel/*.o boot/*.bin drivers/*.o
	rm  *.bin *.o 
