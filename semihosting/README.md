## Part 6
### ARM Semihosting

Semihosting is a way for the microcontroller to use the hosts (PCs) I/O capabilities. With this we can use functions like printf
to send strings to the host.

#### Commands to build:
- ``make no_semihosting`` will make code without the semihosting functionality
- ``make simple_semihosting`` will make code with semihosting functionality and print "Hello World" to the gdb server. See below 
                                how to enable semihosting support on the host.
- ``make pic_semihosting`` will make pic with semihosting support. (Not tested yet.)

#### How to setup semihosting using gdb
- This functionality should be supported by the gdb server.
- openocd and st-util supports this functionality
- openocd:
    - Use command ``monitor arm semihosting enable`` in the gdb client it will show prints on the *openocd console*.
- st-util
    - Use command ``monitor semihosting enable`` in the gdb client it will show prints in a file call *:tt* on the folder where you run st-util.

### References
1. http://www.keil.com/support/man/docs/armcc/armcc_pge1358787046598.htm  
2. https://developer.arm.com/docs/dui0471/k/what-is-semihosting/what-is-semihosting  
3. https://shawnhymel.com/1840/how-to-use-semihosting-with-stm32/  
