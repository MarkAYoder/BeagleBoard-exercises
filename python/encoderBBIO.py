#!/usr/bin/env python3
# From: https://adafruit-beaglebone-io-python.readthedocs.io/en/latest/Encoder.html
# From: https://adafruit-beaglebone-io-python.readthedocs.io/en/latest/Encoder.html
# Channel   Pin A	Pin B	Notes
# eQEP0     P9.27	P9.42	 
# eQEP1     P8.33	P8.35	Only available with video disabled
# eQEP2     P8.11	P8.12	Only available with eQEP2b unused (same channel)
# eQEP2b	P8.41	P8.42	Only available with video disabled and eQEP2 unused
from Adafruit_BBIO.Encoder import RotaryEncoder, eQEP2
import time

# Instantiate the class to access channel eQEP2, and initialize
# that channel
print('Hit ^C to stop')

myEncoder = RotaryEncoder(eQEP2)
myEncoder.setAbsolute()
myEncoder.enable()

print('frequency ' + str(myEncoder.frequency))

# Get the current position
while True:
    print(myEncoder.position, end='    \r', flush=True)
    time.sleep(0.1)
    
cur_position = myEncoder.position
print(cur_position)

# # Set the current position
# next_position = 15
# myEncoder.position = next_position

# # Reset position to 0
# myEncoder.zero()

# # Change mode to relative (default is absolute)
# # You can use setAbsolute() to change back to absolute
# # Absolute: the position starts at zero and is incremented or
# #           decremented by the encoder's movement
# # Relative: the position is reset when the unit timer overflows.
# myEncoder.setRelative()

# # Read the current mode (0: absolute, 1: relative)
# # Mode can also be set as a property
# mode = myEncoder.mode

# # Get the current frequency of update in Hz
# freq = myEncoder.frequency

# # Set the update frequency to 1 kHz
# myEncoder.frequency = 1000

# # Disable the eQEP channel
# myEncoder.disable()

# # Check if the channel is enabled
# # The 'enabled' property is read-only
# # Use the enable() and disable() methods to
# # safely enable or disable the module
# isEnabled = myEncoder.enabled