#!/usr/bin/env python

import evdev

device = evdev.InputDevice('/dev/input/event1')
print(device)

for event in device.read_loop():
    if event.type == evdev.ecodes.EV_KEY:
        print(evdev.categorize(event))