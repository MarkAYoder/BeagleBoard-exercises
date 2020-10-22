#!/usr/bin/env python3
# Write to a seven segment display
# https://www.adafruit.com/product/877

import smbus
import time
bus = smbus.SMBus(2)  # Use i2c bus 1
matrix = 0x71         # Use address 0x70

delay = 1; # Delay between images in s

bus.write_byte_data(matrix, 0x21, 0)   # Start oscillator (p10)
bus.write_byte_data(matrix, 0x81, 0)   # Disp on, blink off (p11)
bus.write_byte_data(matrix, 0xe7, 0)   # Full brightness (page 15)

# The first byte is GREEN, the second is RED.
smile = [0x00, 0x3c, 0x00, 0x42, 0x28, 0x89, 0x04, 0x85,
    0x04, 0x85, 0x28, 0x89, 0x00, 0x42, 0x00, 0x3c
]
frown = [0x81, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04, 0x00, 0x05, 0x00,
]
neutral = [0x3c, 0x3c, 0x42, 0x42, 0xa9, 0xa9, 0x89, 0x89,
    0x89, 0x89, 0xa9, 0xa9, 0x42, 0x42, 0x3c, 0x3c
]

bus.write_i2c_block_data(matrix, 0, frown)
# for fade in range(0xef, 0xe0, -1):
#     bus.write_byte_data(matrix, fade, 0)
#     time.sleep(delay/10)

# bus.write_i2c_block_data(matrix, 0, neutral)
# for fade in range(0xe0, 0xef, 1):
#     bus.write_byte_data(matrix, fade, 0)
#     time.sleep(delay/10)

# bus.write_i2c_block_data(matrix, 0, smile)
