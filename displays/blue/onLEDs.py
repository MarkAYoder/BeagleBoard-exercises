#!/usr/bin/env python3
import Adafruit_BBIO.GPIO as GPIO
import time

LEDs = ["USR0", "USR1", "USR2", "USR3", 
            "GP0_3", "GP0_4", "GP0_5", "GP0_6",
            "GP1_3", "GP1_4",
            "RED", "GREEN",
            "BAT25", "BAT50", "BAT75", "BAT100",
            "WIFI"
            ]
delay = 0.25

for LED in LEDs:
    print(LED)
    GPIO.setup(LED, GPIO.OUT)
    GPIO.output(LED, 1)

while True:
    time.sleep(1000)