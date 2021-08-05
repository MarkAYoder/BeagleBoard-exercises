#!/usr/bin/env python3
# Write to a seven segment display
# https://www.sparkfun.com/products/11441
# Commands: https://github.com/sparkfun/Serial7SegmentDisplay/wiki/Special-Commands

import smbus
import time
bus = smbus.SMBus(1)  # Use i2c bus 1
display = 0x71        # Use default address 0x71

# Clear the display a show 0123
bus.write_byte(display, 0x76)   # Clear display
for i in range(4):
    bus.write_byte(display, i)   # Show 0 1 2 3
    time.sleep(0.25)

# Sequence the decimals, colon and apostrophe
for i in range(6):
    bus.write_byte_data(display, 0x77, 0x1<<i)
    time.sleep(0.1)
bus.write_byte_data(display, 0x77, 0x2f)

# Fade out and in
for i in range(11):
    bus.write_byte_data(display, 0x7a, 100-10*i)
    time.sleep(0.1)
for i in range(11):
    bus.write_byte_data(display, 0x7a, 10*i)
    time.sleep(0.1)

# Individual Segment Control
for digit in [0x7b, 0x7c, 0x7d, 0x7e]:
    for i in range(7):
        bus.write_byte_data(display, digit, 0x1<<i)
        time.sleep(0.1)
