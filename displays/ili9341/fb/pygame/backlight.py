#!/usr/bin/env python3
import Adafruit_BBIO.PWM as PWM
import sys

LED = "P9_16"
duty = 100     # Default to 100
if(len(sys.argv) > 1):
    duty = float(sys.argv[1])

print("duty: " + str(duty))

#PWM.start(channel, duty, freq=2000, polarity=0)
PWM.start(LED, duty)