#!/usr/bin/env python
import time

w1="/sys/class/hwmon/hwmon0/device/temperature"

while True:
    raw = open(w1, "r").read()
    print("Temperature is "+str(float(raw)/1000)+" degrees")
    time.sleep(1)
