all: os-image

C_SOURCES= ${wildcard kernel/*.c drivers/*.c}
HEADERS = ${wildcard kernel/*.h drivers/*.h}

OBJ = ${C_SOURCES:.c=.o}
os-image: boot/boot.bin kernel.bin kernel/kernel_padding.bin
	cat $^ > os-image

kernel.bin: kernel/kernel_entry.o ${OBJ} 
	ld -o kernel.bin -Ttext 0x1000  $^  -m elf_i386 -e 0 

%.o : %.c 
	"$$HOME/opt/cross/bin/i386-elf-gcc" -ffreestanding  -c $< -o $@ -O0

%.o : %.asm
	nasm $< -f elf -o $@


%.bin : %.asm
	nasm $< -f bin -o $@

cleanfull:
	rm  kernel/*.o boot/*.bin drivers/*.o
	rm  *.bin *.o os-image logfile.txt
clean:
	rm  kernel/*.o boot/*.bin drivers/*.o
	rm  *.bin *.o 
