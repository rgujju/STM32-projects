#include <stdio.h>

extern void initialise_monitor_handles(void);
extern unsigned int library_function( unsigned int x );

unsigned int x = 5;

int main(void) {
#if ENABLE_SEMIHOSTING
	initialise_monitor_handles();

	// don't buffer on stdout
	setbuf(stdout, NULL);
	//~ setvbuf(stdout, NULL, _IONBF, 0);
	printf("Hello World!\n");
#endif

#if ENABLE_PIC
	x = library_function(10);
#endif
	printf("Value of x is %d\n",x);
	
	while (1) {
		
	};

	return 0;
}
