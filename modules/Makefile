# Makefile for compiling in-tree
# From Free Electrons

ifneq ($(KERNELRELEASE),)
obj-$(CONFIG_EXAMPLES) += hello1.o
obj-$(CONFIG_EXAMPLES) += hello2.o
obj-$(CONFIG_EXAMPLES) += hello3.o
else
KDIR := ~/BeagleBoard/bb-kernel/KERNEL

all:
	$(MAKE) -C $(KDIR) M=$$PWD
endif
