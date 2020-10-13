#!/usr/bin/env python3
# From: https://github.com/blynkkk/lib-python
import blynklib
import os
import Adafruit_BBIO.GPIO as GPIO

LED = 'P9_14'
GPIO.setup(LED, GPIO.OUT)
GPIO.output(LED, 1) 

BLYNK_AUTH = os.getenv('BLYNK_AUTH')

# Initialize Blynk
blynk = blynklib.Blynk(BLYNK_AUTH)

# Register Virtual Pins
@blynk.handle_event('write V*')
def my_write_handler(pin, value):
    print('Current V{} value: {}'.format(pin, value))

@blynk.handle_event('write V0')
def my_write_handler(pin, value):
    print('Current V{} value: {}'.format(pin, value[0]))
    GPIO.output(LED, int(value[0])) 

# @blynk.handle_event('write V0')
# def my_write_handler2(pin, value):
#     # this widget will show some time in seconds..
#     print('Current V{} value: {}'.format(pin, value))
#     blynk.virtual_write(11, value)

while True:
    blynk.run()