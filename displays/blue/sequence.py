#!/usr/bin/env python3
import Adafruit_BBIO.GPIO as GPIO
import time

LEDs = ["USR0", "USR1", "USR2", "USR3", 
            "GP0_4", "GP0_5", "GP0_6",
            "GP1_3", "GP1_4",
            "RED", "GREEN"
            ]
delay = 0.25

for LED in LEDs:
    GPIO.setup(LED, GPIO.OUT)

while True:
    for LED in LEDs:
        GPIO.output(LED, GPIO.HIGH)
        time.sleep(delay)
    for LED in LEDs:
        GPIO.output(LED, GPIO.LOW)
        time.sleep(delay)