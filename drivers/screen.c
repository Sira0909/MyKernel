#include "port_bytes.c"
#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
// Attribute byte for our default colour scheme .
#define WHITE_ON_BLACK 0x0f
// Screen device I / O ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

int get_screen_offset(int col, int row){
	return ((row*MAX_COLS + col)*2);
}


int get_cursor(){
	port_byte_out(REG_SCREEN_CTRL, 14);
	int offset = port_byte_in(REG_SCREEN_DATA) << 8;
	port_byte_out(REG_SCREEN_CTRL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);
	return offset*2;
}
void set_cursor(int offset){
	offset /= 2;
	port_byte_out(REG_SCREEN_CTRL,14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset));
}

int handle_scrolling(int cursor_offset) {
	if ( cursor_offset < MAX_ROWS*MAX_COLS*2){
		return cursor_offset;
	}

	int i;
	for( i = 1; i< MAX_ROWS;i++) {
		memory_copy((char*)(get_screen_offset(0,i) + VIDEO_ADDRESS),
			    (char*)(get_screen_offset(0,i-1)+VIDEO_ADDRESS),
			    MAX_COLS*2
			   );
	}
	char* last_line = (char*)(get_screen_offset(0,MAX_ROWS-1) + VIDEO_ADDRESS);
	for (i = 0; i< MAX_COLS*2; i++) {
		last_line[i] = 0;
	}
	cursor_offset -= 2*MAX_COLS;

	return cursor_offset;
}
void print_char(char character , int col , int row , char attribute_byte ) {
	/* Create a byte ( char ) pointer to the start of video memory */
	unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;
	/* If attribute byte is zero , assume the default style . */
	if (!attribute_byte) {
		attribute_byte = WHITE_ON_BLACK;
	}
	/* Get the video memory offset for the screen location */
	int offset;
	/* If col and row are non - negative , use them for offset . */
	if ( col >= 0 && row >= 0) {
		offset = get_screen_offset(col,row);
	}
	else { 
		offset = get_cursor();
	}

	if (character == '\n'){
		int rows = offset / (2*MAX_COLS);
		offset = get_screen_offset(79,rows);

	} else {
		vidmem[offset] = character;
		vidmem[offset+1] = attribute_byte;
	}

	offset += 2;

	offset = handle_scrolling(offset);

	set_cursor(offset);
}
void clear_screen() {
	int row =0;
	int col = 0;
	for(row=0;row<MAX_ROWS; row++){
		for(col=0;col<MAX_COLS; col++){
			print_char(' ', col, row, WHITE_ON_BLACK);
		}
	}

	set_cursor(get_screen_offset(0,0));
}
void print_at(char* message, int col, int row){
	if (col>= 0 && row >=0) {
		set_cursor(get_screen_offset(col,row));
	}
	int i = 0;
	while(message[i] != '\0'){
		print_char(message[i], -1, -1, WHITE_ON_BLACK);
		i++;
	}
}
void print(char* message){
	print_at(message, -1, -1);
}
