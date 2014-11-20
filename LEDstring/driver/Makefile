# Makefile for compiling out-of-tree
# From Free Electrons
# If $ARCH is arm, then we are cross compiling, use the kernel sources
# If on the Bone run apt-get install linux-headers-`uname -r`

ifeq ($(ARCH),arm)
KDIR := ~/BeagleBoard/bb-kernel/KERNEL
else
KDIR := /lib/modules/$(shell uname -r)/build
endif

ifeq ($(KERNELRELEASE),)
obj-$(CONFIG_EXAMPLES) += lpd8806.o
else
obj-m += lpd8806.o
endif

all:
	$(MAKE) -C $(KDIR) M=$$PWD
	
dt:
	# Set up device tree for SPI
	# SPI0
	echo ADAFRUIT-SPI0 > /sys/devices/bone_capemgr.*/slots
	# SPI1
	# echo ADAFRUIT-SPI1 > /sys/devices/bone_capemgr.*/slots
	
install:
	scp hello*.ko bone:.

print:
	@echo KERNELRELEASE= $(KERNELRELEASE)
	@echo CONFIG_EXAMPLES= $(CONFIG_EXAMPLES)
	@echo obj-m= $(obj-m)
	
clean:
	rm -rf .tmp_versions .lpd8806* lpd8806*.mod.c *.o 
	rm Module.symvers modules.order
