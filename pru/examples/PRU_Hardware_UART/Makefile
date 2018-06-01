# 
# Copyright (c) 2016 Zubeen Tolani <ZeekHuge - zeekhuge@gmail.com>
# Copyright (c) 2017 Texas Instruments - Jason Kridner <jdk@ti.com>
# 

# TARGET must be defined
# PRUN must be defined

# PRU_CGT environment variable must point to the TI PRU compiler directory.
# PRU_SUPPORT points to pru-software-support-package
PRU_CGT:=/usr/share/ti/cgt-pru
PRU_SUPPORT:=/usr/lib/ti/pru-software-support-package

LINKER_COMMAND_FILE=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))/AM335x_PRU.cmd
LIBS=--library=$(PRU_SUPPORT)/lib/rpmsg_lib.lib
INCLUDE=--include_path=$(PRU_SUPPORT)/include --include_path=$(PRU_SUPPORT)/include/am335x
STACK_SIZE=0x100
HEAP_SIZE=0x100

CFLAGS=-v3 -O2 --display_error_number --endian=little --hardware_mac=on --obj_directory=$(GEN_DIR) --pp_directory=$(GEN_DIR) --asm_directory=$(GEN_DIR) -ppd -ppa --asm_listing --c_src_interlist # --absolute_listing
LFLAGS=--reread_libs --warn_sections --stack_size=$(STACK_SIZE) --heap_size=$(HEAP_SIZE) -m $(GEN_DIR)/file.map

GEN_DIR=/tmp/pru$(PRUN)-gen

PRU_DIR=$(wildcard /sys/devices/platform/ocp/4a326000.pruss-soc-bus/4a300000.pruss/4a33*000.pru$(PRUN)/remoteproc/remoteproc*)

all: run

run: stop install start
	@echo '-	rebooting $(PRUN) via $(PRU_DIR)'
	@# @sudo $(dir $(realpath $(firstword $(MAKEFILE_LIST))))/write_init_pins.sh /lib/firmware/am335x-$(PRUN)-fw
	@echo "-	$(PRUN) is now loaded with $(GEN_DIR)/$(TARGET).out"

stop:
	@echo "-    Stopping PRU$(PRUN)"
	@echo stop | sudo tee $(PRU_DIR)/state || echo Cannot stop $(PRUN)

start:
	@echo "-    Starting PRU$(PRUN)"
	@echo start | sudo tee $(PRU_DIR)/state

install: $(GEN_DIR)/$(TARGET).out
	@echo '-	copying firmware file $(GEN_DIR)/$(TARGET).out to /lib/firmware/am335x-pru$(PRUN)-fw'
	@sudo cp $(GEN_DIR)/$(TARGET).out /lib/firmware/am335x-pru$(PRUN)-fw

$(GEN_DIR)/$(TARGET).out: $(GEN_DIR)/$(TARGET).obj
	@echo 'LD	$^' 
	@lnkpru -i$(PRU_CGT)/lib -i$(PRU_CGT)/include $(LFLAGS) -o $@ $^ $(LINKER_COMMAND_FILE) --library=libc.a $(LIBS) $^

$(GEN_DIR)/$(TARGET).obj: $(TARGET).c
	@mkdir -p $(GEN_DIR)
	@echo 'CC	$<'
	@clpru --include_path=$(PRU_CGT)/include $(INCLUDE) $(CFLAGS) -fe $@ $<

clean:
	@echo 'CLEAN	PRU$(PRUN).'
	@rm -rf $(GEN_DIR)
