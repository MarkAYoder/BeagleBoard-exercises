#!/usr/bin/env python3
# From: https://github.com/blynkkk/lib-python
import blynklib
import os

BLYNK_AUTH = os.getenv('BLYNK_AUTH')

# Initialize Blynk
blynk = blynklib.Blynk(BLYNK_AUTH)

# Register Virtual Pins
@blynk.handle_event('write V4')
def my_write_handler(pin, value):
    print('Current V{} value: {}'.format(pin, value))

@blynk.handle_event('write V0')
def my_write_handler2(pin, value):
    # this widget will show some time in seconds..
    print('Current V{} value: {}'.format(pin, value))
    blynk.virtual_write(11, value)

while True:
    blynk.run()