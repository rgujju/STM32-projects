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
arm-none-eabi-objdump -Dz --source main.elf

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

| Intruction | Description |
| ---------- | ----------- |
|  8000054   | load data at address ``800007c`` into r4. (pc (instruction address + 4) + #36(0x24) = 800007c) so r4 contains ``17ffffa6`` |
|  8000056   | add pc to r4, so r4 contains ``20000000``, which is the base of the GOT |
|  8000058   | r3 contains data at ``8000080`` ie ``00000000`` which is the offset of x in the GOT |
|  800005a   | load data at r4+r3 into r3. ie load data at (20000000+00000000) which is ``20000018`` into r3. |
|  800005c   | r2 contains ``20000018`` |
|  800005e   | r3 contains #7 |
|  8000060   | store data in r3 to r2+0 ie ``20000018`` |

The call to ``library_function`` is a direct branch call to its address.

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
The call to ``library_function`` is a direct call to its address. (which is also 0 and to be patched by linker)


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
- use ``make got_plt`` to generate PIC code with GOT and PLT.  
- In this case ``library_function`` will not get linked into the final binary. ``mylib.c`` is compiled as a shared library and linked.

```
arm-none-eabi-objdump -Dz --source main.elf

int main ( void )
{
 8000050:	b598      	push	{r3, r4, r7, lr}
 8000052:	af00      	add	r7, sp, #0
 8000054:	4c09      	ldr	r4, [pc, #36]	; (800007c <main+0x2c>)
 8000056:	447c      	add	r4, pc
 .
 .
 .
	z=library_function(77);
 800006c:	204d      	movs	r0, #77	; 0x4d
 800006e:	f000 f855 	bl	800011c <.plt+0x10>
 8000072:	4602      	mov	r2, r0
 8000074:	4b04      	ldr	r3, [pc, #16]	; (8000088 <main+0x38>)
 8000076:	58e3      	ldr	r3, [r4, r3]
 8000078:	601a      	str	r2, [r3, #0]

	while(1){
 800007a:	e7fe      	b.n	800007a <main+0x2a>
 800007c:	1800002e 	stmdane	r0, {r1, r2, r3, r5}
 8000080:	00000000 	andeq	r0, r0, r0
 8000084:	00000008 	andeq	r0, r0, r8
 8000088:	00000004 	andeq	r0, r0, r4
 .
 .
 .
 Disassembly of section .plt:

0800010c <.plt>:
 800010c:	b500      	push	{lr}
 800010e:	f8df e008 	ldr.w	lr, [pc, #8]	; 8000118 <.plt+0xc>
 8000112:	44fe      	add	lr, pc
 8000114:	f85e ff08 	ldr.w	pc, [lr, #8]!
 8000118:	17ffff7c 			; <UNDEFINED> instruction: 0x17ffff7c
 800011c:	f64f 7c78 	movw	ip, #65400	; 0xff78
 8000120:	f2c1 7cff 	movt	ip, #6143	; 0x17ff
 8000124:	44fc      	add	ip, pc
 8000126:	f8dc f000 	ldr.w	pc, [ip]
 800012a:	e7fd      	b.n	8000128 <.plt+0x1c>
 .
 .
 .
 Disassembly of section .got.plt:

20000094 <_GLOBAL_OFFSET_TABLE_>:
20000094:	20000000 	andcs	r0, r0, r0
20000098:	00000000 	andeq	r0, r0, r0
2000009c:	00000000 	andeq	r0, r0, r0
200000a0:	0800010c 	stmdaeq	r0, {r2, r3, r8}
```
| Intruction | Description |
| ---------- | ----------- |
|  8000054   | load data at address ``800007c`` into r4. (pc (instruction address + 4) + #36(0x24) = 800007c) so r4 contains ``17ffffa6`` |
|  8000056   | add pc to r4, so r4 contains ``20000000``, which is the base of the GOT |
|  800006C   | move value #77 into r0 which is passed as argument to the function. |
|  800006E   | branch to address ``800011c``, which is inside the PLT |
|  800011c   | move ``0xff78`` to the lower 16 bits of ip |
|  8000120   | move ``0x17ff`` to the upper 16 bits of ip, so IP contains ``17ffff78`` |
|  8000124   | add ``8000124+0x4``(pc) + ``17ffff78``(ip) = ``200000A0``. which is the GOT for the PLT. This entry will be updated with the actual address by the dynamic linker |
|  8000126   | branch to the value at address ``200000A0``, which is initially ``800010c``. This address is the first entry in the PLT which contains code for *lazy binding* and resolving the actual address of the function called. *The value ``800010c`` is likely wrong here, more on this below.*|
|  800010c-8000114 | branch to the value at address ``2000009a``, which contains ``00000000`` currently. |


The problem with ``0800010c``:

   In ARM cortex-M architecture when interworking addresses (bx & blx or ldr & ldm when loading a pc-relative value) are used for branches 
   the lowest bit is to be set to 1, to indicate thumb state else a INVSTATE fault will be generated [7]. The generated instruction ``0800010c``
   has its last bit as 0 which causes a fault at instruction ``8000114``. This maybe a bug in the gcc compiler [8] [9]. If I change ``0800010c``
   to ``0800010d`` using a hex editor then the branch works and we end up at ``00000000``.
   
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
[3] https://static.docs.arm.com/ihi0044/f/IHI0044F_aaelf.pdf  
		ARM ELF specification. This document contains all the details about the ARM elf like relocation types, etc.
[4] https://www.airs.com/blog/archives/38
		20 part series on how linkers work
[5] https://stackoverflow.com/a/50701832
		Minimal example of creating GOT. Does not have PLT.
[6] http://www.chibios.com/forum/viewtopic.php?f=3&t=1229
		Explains different ways to achive dynamic module loading
[7] https://interrupt.memfault.com/blog/cortex-m-fault-debug
		Information on debugging faults
[8] https://community.arm.com/developer/ip-products/processors/f/cortex-m-forum/45919/gcc-does-not-generate-correct-code-while-building-pic
[9] https://answers.launchpad.net/gcc-arm-embedded/+question/689355

