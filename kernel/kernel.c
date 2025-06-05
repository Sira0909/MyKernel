#include "../drivers/screen.h"
void __stack_chk_fail(void){
	print_char('#',0,0,WHITE_ON_BLACK);
	while(1){}
}
int main() {
	//create pointer to a char, and point it to the first text cell 
	//of video memory (i.e. the top left of the screen)
//	char* video_memory = (char*) 0xb8000;
	// at address pointed to by video_memory, store the character 'X'
//	*video_memory = 'X';
	
	//clear_screen();
	//while(1){}

	char *message = "Hi! This is my Kernel so far. Is quite barebones. \n\n\n\nI can do newlines";

	//char message3[] = "Hi Kernel3";
	//char e = 'f';
	//char g = 'H';
	int col = 3;
	int row = 6;
	
	//clear_screen();	
	print_char('H', 1, 1, WHITE_ON_BLACK);

//	print_at(message, -1, -1); 
	return 1;
}
