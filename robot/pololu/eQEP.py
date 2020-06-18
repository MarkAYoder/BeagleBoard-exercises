#!/usr/bin/env python3
# From: https://adafruit-beaglebone-io-python.readthedocs.io/en/latest/Encoder.html
from Adafruit_BBIO.Encoder import RotaryEncoder, eQEP0, eQEP2
import time

# Instantiate the class to access channel eQEP2, and initialize
# that channel
left  = RotaryEncoder(eQEP0)
right = RotaryEncoder(eQEP2)

# Get the current position

leftOld  = 0
rightOld = 0

print(left.position, right.position)

while True:
    if left.position != leftOld or right.position != rightOld:
        print(left.position, right.position)
        
        leftOld  = left.position
        rightOld = right.position

    time.sleep(0.1)
