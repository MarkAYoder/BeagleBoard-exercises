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

TOOLS_TARGETS	:= my2cset

#
# Programs
#
myi2ctest:  myi2ctest.o i2cbusses.o
	$(CC) $(LDFLAGS) -o $@ $^

#
# Objects
#

%.o: %.c
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
