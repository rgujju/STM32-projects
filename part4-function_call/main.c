
extern unsigned int _sidata,_sdata,_edata;   // These values are defined in the linker script
extern unsigned int _sbss,_ebss;             // based on the values of the memory regions


int test_function2(int a, int b, int c, int d, int e);

int main(void){
    test_function2(1,2,3,4,5);
    while(1){

    }
}

int test_function2(int a, int b, int c, int d, int e){
    return a+b+c+d+e;
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
