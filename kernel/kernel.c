#include "../drivers/screen.c"
void __stack_chk_fail_local(void){
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
	char a = 'a';
	char b = 'b';
	char c = 'c';
	char d = 'd';
	char message[] = "Hi Kernel";
	char message2[] = "ths";
	//char message3[] = "Hi Kernel3";
	//char e = 'f';
	//char g = 'H';
	int col = 3;
	int row = 6;

	clear_screen();	

	print_at(message, 0, 0); 
	return 1;
}
