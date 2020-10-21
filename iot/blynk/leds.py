#!/usr/bin/env python3
# From: https://github.com/blynkkk/lib-python
# Blink the USR3 LED in response to a V0 input.
import blynklib
import os, sys
import Adafruit_BBIO.GPIO as GPIO

# Setup the LED
LED = 'USR3'
GPIO.setup(LED, GPIO.OUT)
GPIO.output(LED, 1) 

# Setup the button
button = 'P9_11'
GPIO.setup(button, GPIO.IN)
# print("button: " + str(GPIO.input(button)))

# Get the autherization code (See setup.sh)
BLYNK_AUTH = os.getenv('BLYNK_AUTH', default="")
if(BLYNK_AUTH == ""):
    print("BLYNK_AUTH is not set")
    sys.exit()

# Initialize Blynk
blynk = blynklib.Blynk(BLYNK_AUTH)

# Register Virtual Pins
# The V* says to response to all virtual pins
@blynk.handle_event('write V*')
def my_write_handler(pin, value):
    print('Current V{} value: {}'.format(pin, value))
    GPIO.output(LED, int(value[0])) 
    
# This calback is called everytime the button changes
# channel is the name of the pin that changed
def pushed(channel):
    # Read the current value of the input
    state = GPIO.input(channel)
    print('Edge detected on channel {}, value={}'.format(channel, state))
    # Write it out
    GPIO.output(LED, state)     # Physical LED
    blynk.virtual_write(10, 255*state)  # Virtual LED: 255 max brightness

# This is a non-blocking event 
GPIO.add_event_detect(button, GPIO.BOTH, callback=pushed) 


while True:
    blynk.run()