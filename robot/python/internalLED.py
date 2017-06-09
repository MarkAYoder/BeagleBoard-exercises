#!/usr/bin/env python
# Blinks a single builtin LED
import Adafruit_BBIO.GPIO as GPIO
import time

LED = "USR3"

GPIO.setup(LED, GPIO.OUT)

while True:
    GPIO.output(LED, GPIO.HIGH)
    time.sleep(0.25)
    GPIO.output(LED, GPIO.LOW)
    time.sleep(0.25)