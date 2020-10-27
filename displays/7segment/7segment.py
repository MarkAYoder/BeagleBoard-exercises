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

def map2seven(str):
    to7seg = {
      "0": 0x3f,
      "1": 0x06,
      "2": 0x5b,
      "3": 0x4f,
      "4": 0x66,
      "5": 0x6d,
      "6": 0x7d,
      "7": 0x07,
      "8": 0x7f,
      "9": 0x7f,
      ":": 0x02,
      ".": 0x03,
    }
    
    data = []
    for c in str:
        if c == '.':    # if . add to previous number
            data[-2] = data[-2] | 0x80
        else:
            data = data + [to7seg[c]] +[0x00]
    print(data)
    bus.write_i2c_block_data(matrix, 0, data)

map2seven('5.6:78')
# The first byte is GREEN, the second is RED.
frown = [0x81, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04, 0x00, 0x05, 0x00,
]

# for fade in range(0xef, 0xe0, -1):
#     bus.write_byte_data(matrix, fade, 0)
#     time.sleep(delay/10)

# bus.write_i2c_block_data(matrix, 0, neutral)
# for fade in range(0xe0, 0xef, 1):
#     bus.write_byte_data(matrix, fade, 0)
#     time.sleep(delay/10)

# bus.write_i2c_block_data(matrix, 0, smile)
