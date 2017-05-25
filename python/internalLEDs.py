#!/usr/bin/env python
import Adafruit_BBIO.GPIO as GPIO
import time

LEDs=6

for i in range(LEDs):
    GPIO.setup("USR%d" % i, GPIO.OUT)

while True:
    for i in range(LEDs):
        GPIO.output("USR%d" % i, GPIO.HIGH)
        time.sleep(0.25)
    for i in range(LEDs):
        GPIO.output("USR%d" % i, GPIO.LOW)
        time.sleep(0.25)