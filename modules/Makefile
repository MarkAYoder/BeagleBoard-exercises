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
obj-$(CONFIG_EXAMPLES) += hello1.o
obj-$(CONFIG_EXAMPLES) += hello2.o
obj-$(CONFIG_EXAMPLES) += hello3.o
else
obj-m += hello1.o
obj-m += hello2.o
obj-m += hello3.o
endif

all:
	$(MAKE) -C $(KDIR) M=$$PWD
	
install:
	scp hello*.ko bone:.

print:
	@echo KERNELRELEASE= $(KERNELRELEASE)
	@echo CONFIG_EXAMPLES= $(CONFIG_EXAMPLES)
	@echo obj-m= $(obj-m)
	
clean:
	rm -rf .tmp_versions .hello* hello*.mod.c *.o 
	rm Module.symvers modules.order
