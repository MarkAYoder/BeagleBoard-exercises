#!/usr/bin/env python
# From: https://python-evdev.readthedocs.io/en/latest/tutorial.html#reading-events

import evdev

device = evdev.InputDevice('/dev/input/event1')

LED=3
LEDPATH='/sys/class/leds/beaglebone:green:usr'

f = open(LEDPATH+str(LED)+"/brightness", "w")

for event in device.read_loop():
    if event.type == evdev.ecodes.EV_KEY:
        if(event.value != 2):   # Ignore the 'hold' event
            print(event.value)
            f.write(str(event.value))
            f.seek(0)
