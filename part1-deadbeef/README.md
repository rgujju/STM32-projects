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
- arm-none-eabi-gcc main.o -mcpu=cortex-m4 -mthumb -Wall -nostdlib -lgcc -T./stm32_base.ld -o main.elf
    
    main.o => Input object file
    -nostdlib => do not link with the C std lib
    -lgcc => Use the gcc lib
    -T./stm32_base.ld => Linker script to be used
    -o main.elf => Output elf that can be loaded to mcu


### References
https://vivonomicon.com/2018/04/02/bare-metal-stm32-programming-part-1-hello-arm/
