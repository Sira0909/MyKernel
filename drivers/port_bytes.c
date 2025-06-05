#include "port_bytes.h"

void memory_copy(char* source, char* dest, int no_bytes){
	int i;
	for(i = 0; i<no_bytes; i++){
		*(dest+i) = *(source  + i);
	}
}
unsigned char port_byte_in(unsigned short port) {
	// A handy C wrapper function that reads a byte from the specified port
	// "=a" (result) means: put AL register in variable RESULT when finished
	// etc
	unsigned char result;
	__asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}
void port_byte_out(unsigned short port, unsigned char data) {
	__asm__("out %%al, %%dx" : :"a" (data), "d" (port));
}
unsigned short port_word_in ( unsigned short port ) {
	unsigned short result ;
	__asm__("in %%dx, %% ax" : "=a" (result) : "d" (port));
	return result;
}
void port_word_out ( unsigned short port , unsigned short data ) {
	__asm__( "out %%ax , %%dx " : : "a" ( data ) , "d" ( port ));
}

