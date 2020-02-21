// These instructions define attributes of our chip and
// the assembly language we'll use:
.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

// Global memory locations.
.global vtable
.global reset_handler

/*
 * The actual vector table.
 * Only the size of RAM and 'reset' handler are
 * included, for simplicity.
 */
.type vtable, %object
/* This is additional line that is required to be added so that
 * we create a new section header called vector_table in the object file
 * which will be placed in the vector_table section of the output elf by
 * the linker */
.section .vector_table,"a",%progbits 
vtable:
    .word _estack
    .word reset_handler
.size vtable, .-vtable



/*
 * The Reset handler. Called on reset.
 */
.type reset_handler, %function
reset_handler:
    // Set the stack pointer to the end of the stack.
    // The '_estack' value is defined in our linker script.
    LDR  r0, =_estack
    MOV  sp, r0

    // Set some dummy values. When we see these values
    // in our debugger, we'll know that our program
    // is loaded on the chip and working.
    // Set a breakpoint at copy_src to see DEADBEEF
    LDR  r7, =0xDEADBEEF
    MOVS r0, #0
    B copy_src
.size reset_handler, .-reset_handler
