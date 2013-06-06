CC=gcc

TARGETS=test \
test.o

all: $(TARGETS)

.PHONY: example lpd8806 clean

kernel:
#	cp -f ./example.c ~/BeagleBoard/linux-dev/KERNEL/drivers/char
	cp -f ./lpd8806.c ~/BeagleBoard/linux-dev/KERNEL/drivers/char
	./buildKernel.sh
#	scp ~/BeagleBoard/linux-dev/KERNEL/drivers/char/example.ko root@192.168.7.2:/lib/modules/3.2.25+/kernel/drivers/char
	scp ~/BeagleBoard/linux-dev/KERNEL/drivers/char/lpd8806.ko root@yoder-white-bone.dhcp.rose-hulman.edu:.

example:
	cp -f ./example.c ~/BeagleBoard/linux-dev/KERNEL/drivers/char
	./buildKernel.sh
	scp ~/BeagleBoard/linux-dev/KERNEL/drivers/char/example.ko root@192.168.7.2:/lib/modules/3.2.25+/kernel/drivers/char

lpd8806:
	cp -f ./lpd8806.c ~/BeagleBoard/linux-dev/KERNEL/drivers/char
	./buildKernel.sh
	scp ~/BeagleBoard/linux-dev/KERNEL/drivers/char/lpd8806.ko root@192.168.7.2:/lib/modules/3.2.25+/kernel/drivers/char

dt:	# Set up device tree for SPI
	# SPI1
#	dtc -O dtb -o BB-SPI1-01-00A0.dtbo -b 0 -@ BB-SPI1-01-00A0.dts
#	cp BB-SPI1-01-00A0.dtbo /lib/firmware/
#	echo BB-SPI1-01 > /sys/devices/bone_capemgr.*/slots
	# SPI0
	dtc -O dtb -o BB-SPI0-01-00A0.dtbo -b 0 -@ BB-SPI0-01-00A0.dts
	cp BB-SPI0-01-00A0.dtbo /lib/firmware/
	echo BB-SPI0-01 > /sys/devices/bone_capemgr.*/slots

clean: 
	clear
	rm -f $(TARGETS)

test: test.o
	$(CC) $^ -o $@

%.o: %.c
	$(CC) -c $< -o $@


