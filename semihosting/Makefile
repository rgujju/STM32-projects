
#################### CONFIGURABLE SECTION ###########################
# Target can be anything you want. It will create an elf and bin file
# with this name
TARGET = main

# Define the linker script location and chip architecture.
# Change this based on your linker script name and chip architecture
LD_SCRIPT = stm32_linker.ld
MCU_SPEC  = cortex-m4
FLOAT_SPEC = -mfloat-abi=hard -mfpu=fpv4-sp-d16

# Add assembler and C files to this, later we can add a wildcard
# to compile all c files in the directory
AS_SRC    = startup.S
C_SRC     = main.c 
LIBS_SRC  = 
DLIB_SRC = mylib.c
# Toolchain definitions (ARM bare metal defaults)
# Set the TOOLCHAIN_PATH variable to the path where it is installed
# If it is accessible globally. ie it is in your system path ($PATH)
# then leave it blank. A slash at the end of the path is required
# eg: TOOLCHAIN_PATH = /usr/local/bin/
TOOLCHAIN_PATH = 
TOOLCHAIN = $(TOOLCHAIN_PATH)arm-none-eabi-
CC 	= $(TOOLCHAIN)gcc
AS 	= $(TOOLCHAIN)as
LD 	= $(TOOLCHAIN)gcc
OC 	= $(TOOLCHAIN)objcopy
OD 	= $(TOOLCHAIN)objdump
OS 	= $(TOOLCHAIN)size
GDB = $(TOOLCHAIN)gdb

######################################################################
.DELETE_ON_ERROR:

# Assembly directives.
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -mthumb-interwork
ASFLAGS += -Wall
# (Set error messages to appear on a single line.)
ASFLAGS += -fmessage-length=0
ASFLAGS += $(FLOAT_SPEC)

# C compilation directives
CFLAGS += -mcpu=$(MCU_SPEC)
CFLAGS += -mthumb
CFLAGS += -mthumb-interwork
CFLAGS += -Wall
CFLAGS += -g3
CFLAGS += $(FLOAT_SPEC)
# (Set error messages to appear on a single line.)
CFLAGS += -fmessage-length=0
# Create separate sections for function and data
# so it can be garbage collected by linker
CFLAGS += -ffunction-sections
CFLAGS += -fdata-sections

# Linker directives
LSCRIPT = ./$(LD_SCRIPT)

LFLAGS += $(CFLAGS)
#~ LFLAGS += -nostdlib
LFLAGS += -T$(LSCRIPT)
LFLAGS += -Wl,-Map=$(TARGET).map
LFLAGS += -Wl,--print-memory-usage
LFLAGS += -Wl,--gc-sections

OBJS   += $(AS_SRC:.S=.o)
OBJS   += $(C_SRC:.c=.o)
OBJS   += $(LIB_SRC:.c=.o)

DLIB_CFLAGS += -mcpu=$(MCU_SPEC)
DLIB_CFLAGS += -mthumb
DLIB_CFLAGS += -Wall
DLIB_CFLAGS += -g3
DLIB_CFLAGS += -fPIC
DLIB_CFLAGS += -fmessage-length=0

DLIB_LFLAGS += $(DLIB_SRC:%.c=-l%)
DLIBS       += $(DLIB_SRC:%.c=lib%.so)

# The following two lines are to remove the existing so and o files
DLIBS_SO  += $(DLIB_SRC:.c=.so)
DLIBS_O   += $(DLIB_SRC:.c=.o)

# The PHONY keyword is required so that makefile does not
# consider the rule 'all' as a file
.PHONY: all
all: $(TARGET).bin

# There should be a tab here on the line with $(CC), 4 spaces does not work
%.o: %.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) -c $< -o $@

%.o: %.s
	$(CC) -x assembler-with-cpp $(ASFLAGS) -c $< -o $@

# If -c is used then it will create a reloc file ie normal object file
# and not a dynamic object. For dynamic object -shared is required.
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

%.so: %.c
	$(CC) -shared $(DLIB_CFLAGS) $< -o lib$@

$(TARGET).diss: $(TARGET).elf
	$(OD) -Dz --source $^ > $@

$(TARGET).elf: $(OBJS)
	$(LD) $^ $(LFLAGS) -o $@

$(TARGET).bin: $(TARGET).elf $(TARGET).diss
	$(OC) -S -O binary $< $@
	$(OS) $<

########################### no_semihosting ####################
# @Brief This target makes executable with no semihosting
no_semihosting:CFLAGS += --specs=nosys.specs
.PHONY: no_semihosting
no_semihosting: $(TARGET).bin
################################################################

########################### simple_semihosting ################# 
# @Brief This target makes executable with simple demonstration
# of semihosting
simple_semihosting:CFLAGS  += -DENABLE_SEMIHOSTING=1
simple_semihosting:LFLAGS  += --specs=rdimon.specs -lc -lrdimon
.PHONY: simple_semihosting
simple_semihosting: $(TARGET).bin
################################################################

####################### pic_semihosting ########################
# @Brief This target makes executable with global variables 
# accessed through GOT and shared library functions through
# the PLT. The GOT base is hardcoded in register r9.
pic_semihosting:ASFLAGS      += -fPIC -msingle-pic-base -mpic-register=r9 -mno-pic-data-is-text-relative -mlong-calls
pic_semihosting:CFLAGS       += -DENABLE_SEMIHOSTING=1 -DENABLE_PIC=1
pic_semihosting:CFLAGS       += -fPIC -msingle-pic-base -mpic-register=r9 -mno-pic-data-is-text-relative -mlong-calls
pic_semihosting:DLIB_CFLAGS  += -fPIC -msingle-pic-base -mpic-register=r9 -mno-pic-data-is-text-relative -mlong-calls
pic_semihosting:LFLAGS       += --specs=rdimon.specs -lc -lrdimon
pic_semihosting:LFLAGS       += -L. $(DLIB_LFLAGS)
.PHONY: pic_semihosting
pic_semihosting: $(DLIBS_SO) $(TARGET).bin
################################################################

########################### clean ############################## 
# @Brief Remove the target output files.
.PHONY: clean
clean:
	rm -f $(OBJS) $(DLIBS) $(DLIBS_O)
	rm -f $(TARGET).elf $(TARGET).bin $(TARGET).list $(TARGET).srec
	rm -f $(TARGET).diss $(TARGET).map
################################################################

########################### flash ##############################
# @Brief Start GDB, connect to server and load the elf
.PHONY: flash
flash:
	@pgrep -x "openocd" || (echo "Please start openocd"; exit -1)
	@echo "Starting GDB client"
	$(GDB) -ex "target extended :3333" -ex "load $(TARGET).elf" -ex "monitor arm semihosting enable" $(TARGET).elf
################################################################
