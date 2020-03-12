## Part 4
### Global offset tables and procedure linkage tables



#### Commands to build:
- ``make`` will make statically linked position dependent code, it contains absolute adress to all data and functions
- ``make got_only`` will make statically linked code with global and static data access through the GOT.
- ``make got_plt`` will make code with global and static data access through the GOT and function calls through PLT. 
					This code will not have the ``library_function`` in the output.


#### How GOT works
- use ``make got_only`` to generate GOT.
```
arm-none-eabi-objdump -Dz --source main.elf > main.diss

int main ( void )
{
 8000050:	b598      	push	{r3, r4, r7, lr}
 8000052:	af00      	add	r7, sp, #0
 8000054:	4c09      	ldr	r4, [pc, #36]	; (800007c <main+0x2c>)
 8000056:	447c      	add	r4, pc
	x=7;
 8000058:	4b09      	ldr	r3, [pc, #36]	; (8000080 <main+0x30>)
 800005a:	58e3      	ldr	r3, [r4, r3]
 800005c:	461a      	mov	r2, r3
 800005e:	2307      	movs	r3, #7
 8000060:	6013      	str	r3, [r2, #0]
 .
 .
 .
z=library_function(77);
 800006c:	204d      	movs	r0, #77	; 0x4d
 800006e:	f000 f80d 	bl	800008c <library_function>
 .
 .
 .
 800007c:	17ffffa6 	ldrbne	pc, [pc, r6, lsr #31]!	; <UNPREDICTABLE>
 8000080:	00000000 	andeq	r0, r0, r0
 8000084:	00000008 	andeq	r0, r0, r8
 8000088:	00000004 	andeq	r0, r0, r4
 .
 .
 .
Disassembly of section .got:

20000000 <.got>:
20000000:	20000018 	andcs	r0, r0, r8, lsl r0
20000004:	2000001c 	andcs	r0, r0, ip, lsl r0
20000008:	20000020 	andcs	r0, r0, r0, lsr #32
.
.
.
Disassembly of section .bss:

20000018 <x>:
unsigned int x;
20000018:	00000000 	andeq	r0, r0, r0
 
```
The instructions at ``8000054`` and ``8000056`` will load the address of the GOT into register r4 and then the subsequent 
access to global data will be as offsets in the GOT. The offsets will be added to the value in the register r4 as shown below.

8000054     load data at address ``800007c`` into r4. (pc (instruction address + 4) + #36(0x24) = 800007c) so r4 contains ``17ffffa6``  
8000056     add pc to r4, so r4 contains ``20000000``, which is the base of the GOT  
8000058     r3 contains data at ``8000080`` ie ``00000000`` which is the offset of x in the GOT  
800005a     load data at r4+r3 into r3. ie load data at (20000000+00000000) which is ``20000018`` into r3.  
800005c     r2 contains ``20000018``  
800005e     r3 contains #7  
8000060     store data in r3 to r2+0 ie ``20000018``  

The call library_function is a direct branch call to its address.

The compiled objects like main.o contains the relocation information [3] which will be used by the linker to patch the GOT entries.

```
arm-none-eabi-readelf -r main.o

Relocation section '.rel.text' at offset 0x4fc contains 5 entries:
 Offset     Info    Type            Sym.Value  Sym. Name
0000001e  0000130a R_ARM_THM_CALL    00000000   library_function
0000002c  00001419 R_ARM_BASE_PREL   00000000   _GLOBAL_OFFSET_TABLE_
00000030  00000f1a R_ARM_GOT_BREL    00000004   x
00000034  0000101a R_ARM_GOT_BREL    00000004   y
00000038  0000111a R_ARM_GOT_BREL    00000004   z

```

The offset here matches the offset in the disassembly which just contains zeros. See offset 1e, 2c,30,34 and 38 below. 
The call to library_function is a direct call to its address. (which is also 0 and to be patched by linker)


```
arm-none-eabi-objdump -Dz --source main.o

Disassembly of section .text:

00000000 <main>:
unsigned int x;
unsigned int y;
unsigned int z;

int main ( void )
{
   0:	b598      	push	{r3, r4, r7, lr}

.
.
.
z=library_function(77);
  1c:	204d      	movs	r0, #77	; 0x4d
  1e:	f7ff fffe 	bl	0 <library_function>
.
.
.
while(1){
  2a:	e7fe      	b.n	2a <main+0x2a>
  2c:	00000022 	andeq	r0, r0, r2, lsr #32
  30:	00000000 	andeq	r0, r0, r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00000000 	andeq	r0, r0, r0

```


### How PLT works



### Notes
- In addition to the change in output sections in the linker script, the method for getting the ``_sidata`` global variable is changed. 
``_sidata`` is the LMA of the data section. This new method gives the correct LMA. If the previous method was used then there was another section
(rel.dyn) being pushed in between the ``_sidata`` and the actual start of the .data section so there was always an offset in accessing the .data
section. As a consequence the location of variables were not accurate.

### References
[1] https://eli.thegreenplace.net/2011/11/03/position-independent-code-pic-in-shared-libraries  
		This is probably the holy grail of pic.
[2] http://infocenter.arm.com/help/topic/com.arm.doc.dai0242a/DAI0242A_dynamic_linking_with_rvct.pdf  
		Explains what dynamic linking is and some details on how to implement it
[3] https://www.airs.com/blog/archives/38
		20 part series on how linkers work
[4] https://stackoverflow.com/a/50701832
		Minimal example of creating GOT. Does not have PLT.
[5] http://www.chibios.com/forum/viewtopic.php?f=3&t=1229
		Explains different ways to achive dynamic module loading
[3] https://static.docs.arm.com/ihi0044/f/IHI0044F_aaelf.pdf  
		ARM ELF specification. This document contains all the details about the ARM elf like relocation types, etc.
