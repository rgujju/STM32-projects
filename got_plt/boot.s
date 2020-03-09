.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

// Global memory locations.
.global vtable
.globl _start

.section .vector_table,"a",%progbits 
vtable:
	.word _estack
	.word reset_handler


_start:
reset_handler:
    mov r0,pc
    ldr r1,=0xFFFF0000
    and r0,r1
    ldr r1,gotbase
    add r0,r1
    bl centry
    b .
    .align

gotbase:
    .word _GLOBAL_OFFSET_TABLE_-(_start)
    .word _start
    .word _GLOBAL_OFFSET_TABLE_
    .word _GLOBAL_OFFSET_TABLE_
