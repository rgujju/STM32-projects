
_estack = 0x20001000;

MEMORY
{
    rom : ORIGIN = 0x08000000, LENGTH = 0x1000
    ram : ORIGIN = 0x20000000, LENGTH = 0x1000
}
SECTIONS
{
    .text : {
        KEEP (*(.vector_table))
        *(.text*) 
    } > rom
    .rodata : { *(.rodata*) } > rom
    .bss : { *(.bss*) } > ram
}
