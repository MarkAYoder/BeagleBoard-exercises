TOOLS_CFLAGS	:= -Wstrict-prototypes -Wshadow -Wpointer-arith -Wcast-qual \
		   -Wcast-align -Wwrite-strings -Wnested-externs -Winline \
		   -W -Wundef -Wmissing-prototypes -O3
#
# Programs
#
all:	gpiotest gpioToggle

gpiotest:  gpiotest.c beaglebone_gpio.h
	$(CC) $(LDFLAGS) -o $@ $^

gpioToggle:  gpioToggle.c beaglebone_gpio.h
	$(CC) $(LDFLAGS) -o $@ $^

#
# Objects
#

%.o: %.c
	$(CC) $(CFLAGS) $(TOOLS_CFLAGS) -c $< -o $@

clean:
	rm gpiotest
