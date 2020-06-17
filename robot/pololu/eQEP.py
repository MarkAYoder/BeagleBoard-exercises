#!/usr/bin/env python3
# From: https://adafruit-beaglebone-io-python.readthedocs.io/en/latest/Encoder.html
from Adafruit_BBIO.Encoder import RotaryEncoder, eQEP2
import time

# Instantiate the class to access channel eQEP2, and initialize
# that channel
myEncoder = RotaryEncoder(eQEP2)

# Get the current position

while True:
    cur_position = myEncoder.position
    print(cur_position)
    time.sleep(1)