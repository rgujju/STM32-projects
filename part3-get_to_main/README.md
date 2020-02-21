## Part 3
### Getting to main function in C

This example builds up on the previous code and shows how 
the main function usually defined in the C file is reached

See the comments in the linker script as there are a few changes in it

#### Commands to build:
    ``make``

### References
[1] https://vivonomicon.com/2018/04/20/bare-metal-stm32-programming-part-2-making-it-to-main/
[2] https://stackoverflow.com/questions/381244/purpose-of-memory-alignment    
[3] https://developer.ibm.com/articles/pa-dalign/  
    - Memory alignment and its importance  
[4] https://interrupt.memfault.com/blog/code-size-optimization-gcc-flags#linker-garbage-collection  
    - Link time garbage collection and the KEEP command in linker script  
[5] https://community.st.com/s/question/0D50X00009XkZDa/understanding-alignment-in-stm32f405xg-ld-linker-script
    - Memory alignment clarification
