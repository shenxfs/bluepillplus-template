##########################################################################################################################
# File automatically-generated by tool: [projectgenerator] version: [3.11.0-B13] date: [Sun May 08 07:39:17 CST 2022]
##########################################################################################################################

# ------------------------------------------------
# Generic Makefile (based on gcc)
#
# ChangeLog :
#	2017-02-10 - Several enhancements + project update mode
#   2015-07-22 - first version
# ------------------------------------------------

######################################
#GD32F10x Firmware Library ROOT Path
GD32F10xFWL =$(HOME)/GD32/GD32F10x_Firmware_Library_V2.2.3

######################################
# target
######################################
TARGET = hello


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og


#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
VPATH = \
$(GD32F10xFWL)/Firmware/GD32F10x_standard_peripheral/Source:\
Src

# C sources
C_SOURCES = 
C_SOURCES += main.c
C_SOURCES +=gd32f10x_it.c
C_SOURCES +=systick.c
C_SOURCES +=gd32f10x_eval.c
C_SOURCES +=system_gd32f10x.c
C_SOURCES +=gd32f10x_adc.c
C_SOURCES +=gd32f10x_bkp.c
C_SOURCES +=gd32f10x_can.c
C_SOURCES +=gd32f10x_crc.c
C_SOURCES +=gd32f10x_dac.c
C_SOURCES +=gd32f10x_dbg.c
C_SOURCES +=gd32f10x_dma.c
C_SOURCES +=gd32f10x_exti.c
C_SOURCES +=gd32f10x_fmc.c
C_SOURCES +=gd32f10x_fwdgt.c
C_SOURCES +=gd32f10x_gpio.c
C_SOURCES +=gd32f10x_i2c.c
C_SOURCES +=gd32f10x_misc.c
C_SOURCES +=gd32f10x_pmu.c
C_SOURCES +=gd32f10x_rcu.c
C_SOURCES +=gd32f10x_rtc.c
C_SOURCES +=gd32f10x_sdio.c
C_SOURCES +=gd32f10x_spi.c
C_SOURCES +=gd32f10x_timer.c
C_SOURCES +=gd32f10x_usart.c
C_SOURCES +=gd32f10x_wwdgt.c

# ASM sources
ASM_SOURCES =  \
startup_gd32f10x_xd.s


#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m3

# fpu
# NONE for Cortex-M0/M0+/M3

# float-abi


# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DUSE_STDPERIPH_DRIVER \
-DGD32F10X_MD


# AS includes
AS_INCLUDES = 

# C includes
C_INCLUDES =  \
-IInc \
-I$(GD32F10xFWL)/Firmware/CMSIS \
-I$(GD32F10xFWL)/Firmware/CMSIS/GD/GD32F10x/Include \
-I$(GD32F10xFWL)/Firmware/GD32F10x_standard_peripheral/Include


# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = GD32F103CBTx_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
#vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
#vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		

#######################################
# clean up
#######################################
clean:
	-rm -fr $(BUILD_DIR)
  
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

update:
	openocd -f openocd.cfg -c init -c halt \
	-c "program $(BUILD_DIR)/$(TARGET).hex verify reset exit"

reset:
	openocd -f openocd.cfg -c init -c halt -c reset -c shutdown

flash:$(BUILD_DIR)/$(TARGET).bin
	st-flash write $< 0x08000000

# *** EOF ***