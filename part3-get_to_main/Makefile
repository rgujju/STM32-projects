
#################### CONFIGURABLE SECTION ###########################
# Target can be anything you want. It will create an elf and bin file
# with this name
TARGET = main

# Define the linker script location and chip architecture.
# Change this based on your linker script name and chip architecture
LD_SCRIPT = stm32_linker.ld
MCU_SPEC  = cortex-m4

# Add assembler and C files to this, later we can add a wildcard
# to compile all c files in the directory
AS_SRC  = ./startup.S
C_SRC   = ./main.c 

# Toolchain definitions (ARM bare metal defaults)
# Set the TOOLCHAIN_PATH variable to the path where it is installed
# If it is accessible globally. ie it is in your system path ($PATH)
# then leave it blank. A slash at the end of the path is required
# eg: TOOLCHAIN_PATH = /usr/local/bin/
TOOLCHAIN_PATH = 
TOOLCHAIN = $(TOOLCHAIN_PATH)arm-none-eabi-
CC = $(TOOLCHAIN)gcc
AS = $(TOOLCHAIN)as
LD = $(TOOLCHAIN)ld
OC = $(TOOLCHAIN)objcopy
OD = $(TOOLCHAIN)objdump
OS = $(TOOLCHAIN)size

######################################################################

# Assembly directives.
ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -Wall
# (Set error messages to appear on a single line.)
ASFLAGS += -fmessage-length=0

# C compilation directives
CFLAGS += -mcpu=$(MCU_SPEC)
CFLAGS += -mthumb
CFLAGS += -Wall
CFLAGS += -g
# (Set error messages to appear on a single line.)
CFLAGS += -fmessage-length=0
# (Set system to ignore semihosted junk)
CFLAGS += --specs=nosys.specs

# Linker directives
LSCRIPT = ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -Wall
LFLAGS += --specs=nosys.specs
LFLAGS += -nostdlib
LFLAGS += -lgcc
LFLAGS += -T$(LSCRIPT)

OBJS    = $(AS_SRC:.S=.o)
OBJS   += $(C_SRC:.c=.o)

# The PHONY keyword is required so that makefile does not
# consider the rule 'all' as a file
.PHONY: all
all: $(TARGET).bin

# There should be a tab here on line 71, 4 spaces does not work
%.o: %.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCLUDE) $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf $(TARGET).bin

