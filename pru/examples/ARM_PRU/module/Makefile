# Makefile for compiling out-of-tree
# From Free Electrons
# If on the Bone run apt install linux-headers-`uname -r`

KDIR := /lib/modules/$(shell uname -r)/build

obj-m += rpmsg_client_sample.o
obj-m += rpmsg_pru.o

all:
	$(MAKE) -C $(KDIR) M=$$PWD
	
install:
	scp hello*.ko bone:.

print:
	@echo KERNELRELEASE= $(KERNELRELEASE)
	@echo CONFIG_EXAMPLES= $(CONFIG_EXAMPLES)
	@echo obj-m= $(obj-m)
	
clean:
	rm -rf .tmp_versions *.o 
	rm -rf .rpmsg_client_sample* rpmsg_client_sample*.mod.c
	rm -rf .rpmsg_pru* rpmsg_pru*.mod.c
	rm modules.order Module.symvers .built-in.o.cmd 