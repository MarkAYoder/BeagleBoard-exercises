# I2C tools for Linux
#
# Copyright (C) 2007  Jean Delvare <khali@linux-fr.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

TOOLS_CFLAGS	:= -Wstrict-prototypes -Wshadow -Wpointer-arith -Wcast-qual \
		   -Wcast-align -Wwrite-strings -Wnested-externs -Winline \
		   -W -Wundef -Wmissing-prototypes 

TOOLS_C++FLAGS	:= -Wshadow -Wpointer-arith -Wcast-qual \
		   -Wcast-align -Wwrite-strings -Winline \
		   -W -Wundef -fno-rtti
# the -fno-rtti gets rid of the error:
# Adafruit_LEDBackpack.o:(.rodata+0x128): undefined reference to `vtable for __cxxabiv1::__vmi_class_type_info'
# http://zedcode.blogspot.com/2007/02/gcc-c-link-problems-on-small-embedded.html

TOOLS_TARGETS	:= my2cset

#
# Programs
#

matrix8x8: matrix8x8.o i2cbusses.o Adafruit_GFX.o Adafruit_LEDBackpack.o \
		Print.o
	$(CC) $(LDFLAGS) -o $@ $^

my2cset:  my2cset.o i2cbusses.o
	$(CC) $(LDFLAGS) -o $@ $^

#
# Objects
#

%.o: %.cpp
	$(CC) $(CFLAGS) $(TOOLS_C++FLAGS) -c $< -o $@

i2cbusses.o: i2cbusses.c i2cbusses.h i2c-dev.h
	$(CC) $(CFLAGS) $(TOOLS_CFLAGS) -c $< -o $@

my2cset.o: my2cset.c i2c-dev.h
	$(CC) $(CFLAGS) $(TOOLS_CFLAGS) -c $< -o $@

#
# Commands
#

all-tools: $(addprefix $(TOOLS_DIR)/,$(TOOLS_TARGETS))

strip-tools: $(addprefix $(TOOLS_DIR)/,$(TOOLS_TARGETS))
	strip $(addprefix $(TOOLS_DIR)/,$(TOOLS_TARGETS))

clean-tools:
	$(RM) $(addprefix $(TOOLS_DIR)/,*.o $(TOOLS_TARGETS))

install-tools: $(addprefix $(TOOLS_DIR)/,$(TOOLS_TARGETS))
	$(INSTALL_DIR) $(DESTDIR)$(sbindir) $(DESTDIR)$(man8dir)
	for program in $(TOOLS_TARGETS) ; do \
	$(INSTALL_PROGRAM) $(TOOLS_DIR)/$$program $(DESTDIR)$(sbindir) ; \
	$(INSTALL_DATA) $(TOOLS_DIR)/$$program.8 $(DESTDIR)$(man8dir) ; done

uninstall-tools:
	for program in $(TOOLS_TARGETS) ; do \
	$(RM) $(DESTDIR)$(sbindir)/$$program ; \
	$(RM) $(DESTDIR)$(man8dir)/$$program.8 ; done

all: all-tools

strip: strip-tools

clean: clean-tools

install: install-tools

uninstall: uninstall-tools
