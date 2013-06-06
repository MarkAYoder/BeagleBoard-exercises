CC=gcc

TARGETS=fire

all: $(TARGETS)

.PHONY: example lpd8806 clean

kernel:
#	cp -f ./example.c ~/BeagleBoard/kernel/kernel/drivers/char
	cp -f ./lpd8806.c ~/BeagleBoard/kernel/kernel/drivers/char
	./buildKernel.sh
#	scp ~/BeagleBoard/kernel/kernel/drivers/char/example.ko root@yoder-white-bone:/.
	scp ~/BeagleBoard/kernel/kernel/drivers/char/lpd8806.ko root@yoder-white-bone:/.

example:
	cp -f ./example.c ~/BeagleBoard/kernel/kernel/drivers/char
	./buildKernel.sh
	scp ~/BeagleBoard/kernel/kernel/drivers/char/example.ko root@yoder-white-bone:/.
lpd8806:
	cp -f ./lpd8806.c ~/BeagleBoard/kernel/kernel/drivers/char
	./buildKernel.sh
	scp ~/BeagleBoard/kernel/kernel/drivers/char/lpd8806.ko root@yoder-white-bone:/.

clean: 
	clear
	rm -f $(TARGETS)

test: test.o
	$(CC) $^ -o $@

tree:	tree.o
	$(CC) $^ -o $@

fire:	fire.o gpio.o
	$(CC) $^ -o $@ -lpthread

%.o: %.c
	$(CC) -c $< -o $@


