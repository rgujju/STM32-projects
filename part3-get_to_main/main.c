
extern unsigned int _sidata,_sdata,_edata;   // These values are defined in the linker script
extern unsigned int _sbss,_ebss;             // based on the values of the memory regions

char global_data = 27; // Check in gdb if it is 27
char global_bss; // Check in gdb if it is 0

/* Run the main loop infinitely */
int main(){
    char main_data = 0x27;  // Check in gdb if it is 0x28
    main_data+=1;           // because we are adding 1 to it
    while(1){

    }

    return 0;
}

void copy_src(){
    /* The reset_handler will be the first function to be called.
     * In the reset_handler we will copy the .data section from 
     * FLASH to RAM and initialize the BSS section with 0s */
    
    unsigned int *src, *dst;
    
    // Copy from _sidata (FLASH) to _sdata (RAM)
    for(src = &_sidata, dst = &_sdata; dst < &_edata; src++, dst++){
        *dst = *src;
    }

    // Zero out the .bss section
    src = &_sbss;
    while(src < &_ebss){
        *src = 0;
        src++;
    }
  
    // Call main
    main();
}
