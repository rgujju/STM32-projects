/* Define the end of RAM and limit of stack memory */
/* (64KB SRAM on the STM32F429 line, 4096 = 0x1000) */
/* (RAM starts at address 0x20000000) */
_estack = 0x2000FA00;

MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 32K
    SRAM (rxw) : ORIGIN = 0x20000000, LENGTH = 64K

}
