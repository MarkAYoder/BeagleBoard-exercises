CC=gcc

TARGETS=test \
test.o

all: $(TARGETS)

.PHONY: example lpd8806 clean

kernel:
	cp -f ./example.c ~/BeagleBoard/kernel/kernel/drivers/char
	cp -f ./lpd8806.c ~/BeagleBoard/kernel/kernel/drivers/char
	./buildKernel.sh
	scp -P2001 ~/BeagleBoard/kernel/kernel/drivers/char/lpd8806.ko root@home:/lib/modules/3.2.25+/kernel/drivers/char
#	scp ~/BeagleBoard/kernel/kernel/drivers/char/example.ko root@192.168.7.2:/lib/modules/3.2.25+/kernel/drivers/char
#	scp ~/BeagleBoard/kernel/kernel/drivers/char/lpd8806.ko root@192.168.7.2:/lib/modules/3.2.25+/kernel/drivers/char

example:
	cp -f ./example.c ~/BeagleBoard/kernel/kernel/drivers/char
	./buildKernel.sh
	scp ~/BeagleBoard/kernel/kernel/drivers/char/example.ko root@192.168.7.2:/lib/modules/3.2.25+/kernel/drivers/char

lpd8806:
	cp -f ./lpd8806.c ~/BeagleBoard/kernel/kernel/drivers/char
	./buildKernel.sh
	scp ~/BeagleBoard/kernel/kernel/drivers/char/lpd8806.ko root@192.168.7.2:/lib/modules/3.2.25+/kernel/drivers/char

clean: 
	clear
	rm -f $(TARGETS)

test: test.o
	$(CC) $^ -o $@

%.o: %.c
	$(CC) -c $< -o $@


