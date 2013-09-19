TARGET = hello_world-1
CC     = gcc
WARN   = -Wall -Wextra -Wstrict-prototypes -Wmissing-prototypes -Wshadow -Wconversion
CFLAGS = -ggdb3 -O1 $(WARN) -std=c99
LDLIBS = -lm -lncurses
CFILES = $(wildcard *.c)
OFILES = $(patsubst %.c, %.o, $(CFILES))
DFILES = $(patsubst %.c, .deps/%.d, $(CFILES))

all: $(TARGET)
#	ctags *.c

.deps/%.d: %.c
	$(shell if [ ! -d .deps/ ]; then mkdir .deps/; fi )
	@$(CC) -MM $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; rm $@.$$$$

ifneq ($(MAKECMDGOALS),clean)
-include $(DFILES)
endif


.PHONY: clean package bz2

clean:
	$(RM) $(TARGET) *.o .deps/* core tags *.bz2
	rm -rf .deps/

package:
	make bz2

bz2:
	make clean
	cd ..; rm -rf $(TARGET)/$(TARGET).tar.bz2
	cd ..; tar jcv ./$(TARGET) > $(TARGET).tar.bz2
	mv ../$(TARGET).tar.bz2 .
