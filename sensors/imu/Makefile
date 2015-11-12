# I2C tools for Linux
#
# Copyright (C) 2007  Jean Delvare <khali@linux-fr.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

TOOLS_CFLAGS	:= -Wshadow -Wpointer-arith -Wcast-qual \
		   -Wcast-align -Wwrite-strings -Wnested-externs -Winline \
		   -W -Wundef 
# -Wmissing-prototypes -Wstrict-prototypes 

TOOLS_TARGETS	:= my2cset

#
# Programs
#
all:	mpu6050

testIMU:  testIMU.o i2cbusses.o
	$(CC) $(LDFLAGS) -o $@ $^

mpu6050:  mpu6050.o i2cbusses.o
	$(CC) $(LDFLAGS) -o $@ $^

#
# Objects
#

%.o: %.c
	$(CC) $(CFLAGS) $(TOOLS_CFLAGS) -c $< -o $@

clean:
	rm testIMU testIMU.o i2cbusses.o
