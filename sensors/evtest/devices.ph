#!/usr/bin/env python
# From: https://python-evdev.readthedocs.io/en/latest/usage.html
import evdev

devices = [evdev.InputDevice(path) for path in evdev.list_devices()]
for device in devices:
    print(device.path, device.name, device.phys)
