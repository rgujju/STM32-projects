## Part 1
### Bare metal assembler and linker

This example demonstrates the simple assembler code and linker usage by using a few registers

Commands to build:
#### Compile/Assemble
- arm-none-eabi-gcc -x assembler-with-cpp -c -O0 -mcpu=cortex-m4 -mthumb -Wall main.S -o main.o
    
    Assemble the assembly file into object code witht the AMR thumb instruction set  
    -x assembler-with-cpp => Use C preprocessor  
    -c => Only compile, do not link  
    -O0 => Optimization level to 0  
    -mcpu=cortex-m4 => Use the cortex-m4 cpu  
    -mthumb => Use thumb instruction set  
    -Wall => Treat all warnings as errors  
    main.S => Input assembly file  
    -o main.o => Output object file  

#### Link
- arm-none-eabi-gcc main.o -mcpu=cortex-m4 -mthumb -Wall -nostdlib -lgcc -T./stm32_sections_only.ld -o main.elf
    
    main.o => Input object file  
    -nostdlib => do not link with the C std lib  
    -lgcc => Use the gcc lib  
    -T./stm32_base.ld => Linker script to be used  
    -o main.elf => Output elf that can be loaded to mcu  

#### Load
Install stlink utility from https://github.com/texane/stlink/blob/master/doc/tutorial.md  
[Optional] Copy binaries to /usr/local/bin and libs to /usr/local/lib  
[If above step is performed] ``ldconfig``  
Start gdb server using ``st-util``  
Start gdb using ``arm-none-eabi-gdb <elf>``  
Connect to gdb server ``target extended localhost:4242``  
Load the elf ``load <elf>``  
Run program ``r``   
Stop after sometime ``ctrl+c`` and examine the registers ``info registers`` you should see deadbeef at r7



### References
[1] https://vivonomicon.com/2018/04/02/bare-metal-stm32-programming-part-1-hello-arm/  
[2] https://www.st.com/content/ccc/resource/technical/document/programming_manual/6c/3a/cb/e7/e4/ea/44/9b/DM00046982.pdf/files/DM00046982.pdf/jcr:content/translations/en.DM00046982.pdf  
    - See section about Vector table  
[3] https://www.mikrocontroller.net/articles/ARM-ASM-Tutorial#Writing_assembly_applications  
    - See section titled 'Defining symbols in linker scripts'  
[4] https://sourceware.org/binutils/docs/ld/Scripts.html  
    - Complete information about linker scripts
