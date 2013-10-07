TOOLS_CFLAGS	:= -Wstrict-prototypes -Wshadow -Wpointer-arith -Wcast-qual \
		   -Wcast-align -Wwrite-strings -Wnested-externs -Winline \
		   -W -Wundef -Wmissing-prototypes
#
# Programs
#
all:	gpio-int-test togglegpio ncurses

gpio-int-test:  gpio-int-test.o gpio-utils.o
	$(CC) $(LDFLAGS) -o $@ $^

togglegpio:	togglegpio.o gpio-utils.o
	$(CC) $(LDFLAGS) -o $@ $^

ncurses:	ncurses.c
	gcc ncurses.c -lncurses -o ncurses

#
# Objects
#

%.o: %.c
	$(CC) $(CFLAGS) $(TOOLS_CFLAGS) -c $< -o $@

clean:
	rm gpio-int-test.o gpio-utils.o togglegpio.o gpio-int-test togglegpio ncurses
