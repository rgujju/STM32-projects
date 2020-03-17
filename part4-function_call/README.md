## Part 4
### How is a function called

The ARM Procedure Call standard states that for a function call
The arguments are stored in r0,r1,r2,r3 and if there are more than that
then it is stored on the stack.

#### Commands to build:
- Make objcode ``make``  
- Check disassembly using ``arm-none-eabi-objdump -d --source main.o``

### References
[1] https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/function-parameters-on-32-bit-arm  
[2] https://developer.arm.com/docs/ihi0042/latest  
